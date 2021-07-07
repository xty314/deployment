using LibGit2Sharp;
using LibGit2Sharp.Handlers;
using Microsoft.Web.Administration;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class app_list : AdminBasePage
{
    public DBhelper dbhelper = new DBhelper();
    public DataTable appDataTable = new DataTable();
    public string info = "";
    public int[] cloudRepoIds = { 1 };//属于cloud的仓库，需要建立appSettings.json和ecom/config.js
    protected void Page_Load(object sender, EventArgs e)
    {
        string checkId = Request.QueryString["check"];
        if (!String.IsNullOrEmpty(checkId) && Common.IsNumberic(checkId))//check if modified
        {
            CheckApp();
        }
        if (Request.Form["cmd"] == "new")// create new app
        {
            CreateApp();
        }else if (Request.Form["cmd"] == "deploy")//deploy to iis
        {
            DeployApp();
        }
        else if (Request.Form["cmd"] == "idle")//cancel deploy and delele the site from the iis
        {
            IdleApp();
        }
        else if (Request.Form["cmd"] == "delete")//delete app
        {
            DeleteApp();
        }
        else if (Request.Form["cmd"] == "edit")//eidt app
        {
            EditApp();
        }
        else if (Request.Form["cmd"] == "pull")//update app, pull code from github
        {
            PullFromGithub();
        }
        else if (Request.Form["cmd"] == "restart")//update app, pull code from github
        {
            RestartApp();
        }
        LoadAppList();
    }

    private void RestartApp()
    {
        string app_id = Request.Form["id"];
        string sc = "SELECT top 1 * from web_app where id=" + app_id;
        DataTable dt = dbhelper.ExecuteDataTable(sc);
        DataRow dr = dt.Rows[0];
        string siteName = dr["url"].ToString();
        try
        {
            ServerManager iismanager = new ServerManager();
            ObjectState currentStart = iismanager.Sites[siteName].State;
            if(currentStart == ObjectState.Started)
            {
                iismanager.Sites[siteName].Stop();
                iismanager.ApplicationPools[siteName].Stop();
                info = "App has already stopped.";
            }
            else
            {
                iismanager.Sites[siteName].Start();
                iismanager.ApplicationPools[siteName].Start();
                info = "App has already started.";
            }
        }
        catch(Exception e)
        {
            info = e.Message;
            return;
        }
       
        
    }
    public string GetiisState(string id)
    {
        
        string sc = "SELECT top 1 * from web_app where id=" + id;
        DataTable dt = dbhelper.ExecuteDataTable(sc);
        DataRow dr = dt.Rows[0];
        string siteName = dr["url"].ToString();
        string result = "";
        ServerManager iismanager = new ServerManager();
        if (!string.IsNullOrEmpty(siteName)&& iismanager.Sites[siteName] != null)
        {
            try
            {
                result = iismanager.Sites[siteName].State.ToString();
            }
            catch(System.Runtime.InteropServices.COMException e)
            {
                Common.Refresh();
                return result;
            }
         
        }
     
        return result;
    }
    private void CheckApp()
    {
     
        string id = Request.QueryString["check"];

        string path = (string)dbhelper.ExecuteScalar("SELECT location from web_app where id=" + id);
        string name = (string)dbhelper.ExecuteScalar("SELECT name from web_app where id=" + id);
        path = Path.GetFullPath(path);
      
        
        using (var repo = new Repository(path))
        {
            var changes = repo.Diff.Compare<TreeChanges>();
            if (changes.Count > 0)
            {
                info = "The following files are changed in app "+name+".<br>";
                foreach (TreeEntryChanges c in changes)
                {
                    //Console.WriteLine(c);
                    info += string.Format("File:{0} exist({1}) status({2})<br>", c.Path ,c.Exists,c.Status);
                }

            }
            else
            {
                info =String.Format( "No changes in {0}.",name);
            }
            
        }
    }

    private void PullFromGithub()
    {
        string id = Request.Form["id"].ToString().Trim();
        string userName = Request.Form["gitname"].ToString().Trim();
        string password = Request.Form["gitpass"].ToString().Trim();
        string path = (string)dbhelper.ExecuteScalar("SELECT location from web_app where id=" + id);
        path = Path.GetFullPath(path);
        try
        {
            using (Repository repo = new Repository(path))
            {
                // Credential information to fetch
                LibGit2Sharp.PullOptions options = new LibGit2Sharp.PullOptions();
                options.FetchOptions = new FetchOptions();
                options.FetchOptions.CredentialsProvider = new CredentialsHandler(
                    (url, usernameFromUrl, types) =>
                        new UsernamePasswordCredentials()
                        {
                            Username = userName,
                            Password = password
                        });

                // User information to create a merge commit
                var signature = new LibGit2Sharp.Signature(
                    new Identity(userName, "support@eznz.com"), DateTimeOffset.Now);

                // Pull
                MergeResult result = Commands.Pull(repo, signature, options);
                info = result.Status.ToString();
                
            }

            string sc = "UPDATE web_app SET last_update_date=GETDATE() WHERE id=" + id;
            dbhelper.ExecuteNonQuery(sc);

        }
        catch (Exception e)
        {
            info = e.Message;
            return;
        }


    }
    private void EditApp()
    {
        int removable = string.IsNullOrEmpty(Request.Form["removable"]) ? 0 : 1;
        string app_id = Request.Form["id"].ToString();
        string description = Request.Form["description"].ToString();
        string db_id = Request.Form["db"].ToString();
        string name = Request.Form["name"].ToString();
        string sc = "SELECT top 1 * from web_app where id=" + app_id;
        DataTable dt = dbhelper.ExecuteDataTable(sc);
        DataRow dr = dt.Rows[0];
       sc = "UPDATE web_app set name=@name, description=@description,db_id=@db_id,removable=@removable where id=@app_id";
        SqlParameter[] parameters =
        {
            new SqlParameter("@name",name),
            new SqlParameter("@description",description),
            new SqlParameter ("@db_id",db_id),
            new SqlParameter("@removable",removable),
            new SqlParameter ("@app_id",app_id)
        };
        try
        {
            if (cloudRepoIds.Contains((int)dr["repo_id"]))
            {
                string appPath = Path.GetFullPath(dr["location"].ToString());
                CreateOrEditEcomConfigFile(appPath, Convert.ToInt32(app_id));
                if (dr["db_id"].ToString() != db_id)//if the db of app is change, regenerate a new appSettings.json
                {
                    CreateOrEditAppSettingsJsonFile(appPath, Convert.ToInt32(db_id));
                }
              
            }      
            dbhelper.ExecuteNonQuery(sc, parameters);
        
        }
        catch(Exception e)
        {
            info = e.Message;
            return;
        }
      

    }

    /// <summary>
    /// only when removable=0 deploy=0 customize=0 and correct password the app can be deleted.
    /// </summary>
    private void DeleteApp()
    {
        string password = Request.Form["password"].ToString();
        string app_id= Request.Form["id"].ToString();
        if (password != Common.password)
        {
            info = "invalid password";
            return;
        }
        string sc = "SELECT top 1 * from web_app where id=" + app_id;
        DataTable dt = dbhelper.ExecuteDataTable(sc);
        DataRow dr = dt.Rows[0];
        if (!(bool)dr["dev"])
        {
            info = "This app is not for development.";
            return;
        }
        string sql = "SELECT count(*) from mreport where app_id=" + app_id;
        int count = (int)dbhelper.ExecuteScalar(sql);
        if (count > 0)
        {
            info = "This app is occupied by mreport, please delete mreport first and try again.";
            return;
        }
      
        try
        {
            sc = "DELETE FROM web_app where dev=1 and id=" + app_id;
            dbhelper.ExecuteNonQuery(sc);
        }catch(Exception e)
        {
            info = e.Message;
            return;
        }
        info = string.Format("{0} has already been deleted successfully.", dr["name"].ToString());


    }

    /// <summary>
    ///  System.UnauthorizedAccessException: Filename: redirection.config
    /// solution:
    /// (IIS manager, Application pools, right click DefaultAppPool, advanced settings, identity, select LocalSystem in dropdown)
    /// https://forums.iis.net/t/1154515.aspx?ServerManager+UnauthorizedAccessException
    /// </summary>
    private void DeployApp()
    {
        string url = Request.Form["url"].ToString().Trim();
        string app_id = Request.Form["id"];
        string sc = "SELECT top 1 * from web_app where id=" + app_id;
        DataTable dt = dbhelper.ExecuteDataTable(sc);
        DataRow dr = dt.Rows[0];
        string path = Path.GetFullPath(dr["location"].ToString());
     
        Regex url_test= new Regex(@"^[A-Za-z0-9-_]+\.[A-Za-z0-9-_%&?/.=]+$");
   
    
        if (url_test.IsMatch(url))
        {
            PublishWeb(url, path);
        }
        else
        {
            info = "invalid url, please check and try again.";
            return;
        }
        sc = "UPDATE web_app SET deploy=1,url=@url where id=@app_id";
        SqlParameter[] parameters =
        {
            new SqlParameter("@url", url),
            new SqlParameter("@app_id", app_id)
        };

        dbhelper.ExecuteNonQuery(sc, parameters);

    }
    private void IdleApp()
    {
 
        string app_id = Request.Form["id"];
        string sc = "SELECT top 1 * from web_app where id=" + app_id;
        DataTable dt = dbhelper.ExecuteDataTable(sc);
        DataRow dr = dt.Rows[0];
        string siteName = dr["url"].ToString();
        CancelWeb(siteName);
        sc = "UPDATE web_app SET deploy=0,url='' where id=" + app_id;
        dbhelper.ExecuteNonQuery(sc);
    }
    public void CreateApp()
    {
        string name = Request.Form["name"].Trim();
        string repo ="1";
        string description = Request.Form["description"].Trim();
        string db= Request.Form["db"].Trim();
        string location = Path.GetFullPath(Request.Form["location"].ToString().Trim());
        string appSettingsPath = Path.Combine(location, "appSettings.json").ToString();
        if (!Directory.Exists(location))
        {
            info = "The directory does not exist.";
            return;
        }
        if (!File.Exists(appSettingsPath))
        {
            info = "appSettings.json can not be found. Please make sure this is a RST374cloud application.";
            return;
        }
        int count = (int)dbhelper.ExecuteScalar("SELECT COUNT(*) FROM web_app where location='" + location+"'");
        if (count >0)
        {
            info = "This directory is occupied.";
            return;
        }
        string sc = "INSERT into web_app (name,location,db_id,repo_id,creator,description,dev) VALUES(@name,@location,@db_id,@repo_id,@creator,@description,1) ";
        SqlParameter[] sqlParameters =
        {
                new SqlParameter("@name",name),
                new SqlParameter("@db_id",db),
                new SqlParameter("@repo_id",repo),
                new SqlParameter("@location",location),
                new SqlParameter("@creator",(int)Session["user_id"]),
                new SqlParameter("@description", description)
            };
        int newAppId = dbhelper.InsertAndGetId(sc, sqlParameters);
        CreateOrEditAppSettingsJsonFile(location, Convert.ToInt32(db));
        CreateOrEditEcomConfigFile(location, newAppId);
        string createMreport = Request.Form["createMreport"];
        if (createMreport == "1")
        {
            string mreportName = Regex.Replace(name.ToLower(), @"\s+", "_");
          
            string url = String.Format(Common.GetSetting("mreport_url"), mreportName);
            string MreportRootPath = Common.GetSetting("mreport_root_path");
            string sourcePath = Path.Combine(MreportRootPath, "admin\\source");
            string targetPath = Path.Combine(MreportRootPath, "m\\" + mreportName);
            //todo: 判断不添加的条件
            if (System.IO.Directory.Exists(targetPath) || String.IsNullOrEmpty(mreportName))
            {
                return;
            }
            System.IO.Directory.CreateDirectory(targetPath);
            if (System.IO.Directory.Exists(sourcePath))
            {
                string[] files = System.IO.Directory.GetFiles(sourcePath);
                // Copy the files and overwrite destination files if they already exist.
                foreach (string s in files)
                {
                    // Use static Path methods to extract only the file name from the path.
                    string fileName = System.IO.Path.GetFileName(s);
                    string destFile = System.IO.Path.Combine(targetPath, fileName);
                    System.IO.File.Copy(s, destFile, true);
                }
            }
             sc = "INSERT INTO mreport (name,description,url,location,app_id) values(@name,@description,@url,@location,@app_id)";
            SqlParameter[] parameters =
            {
                new SqlParameter("@app_id",newAppId),
                new SqlParameter("@name",mreportName ),
                new SqlParameter("@url",url),
                new SqlParameter("@description",description),
                new SqlParameter("@location",targetPath )
             };

            try
            {
                dbhelper.ExecuteNonQuery(sc, parameters);
                CreateOrEditConfigFile(targetPath, newAppId);
                // set mreport menu in cloud
                int db_id = (int)dbhelper.ExecuteScalar("SELECT db_id from web_app where id=" + newAppId);
                DBhelper appHelper = new DBhelper(db_id);
                sc = "UPDATE menu_admin_id set uri=@url where id =3219";
                SqlParameter sqlParameter = new SqlParameter("@url", url);
                appHelper.ExecuteNonQuery(sc, sqlParameter);
                Common.Refresh();
            }
            catch (Exception e)
            {
                info = e.Message;
                return;
            }
        }

        Common.Refresh();
         

        
    }

    public void LoadAppList()
    {

        string sc = "";
        sc = @"SELECT wa.*,db.conn_str,db.name as 'db_name',gr.name as 'repo_name',mp.url as 'mreport_url',db.dev as 'db_dev' from web_app wa 
            left join db_list db on wa.db_id=db.id 
            left join git_repository gr on wa.repo_id=gr.id 
            left join mreport mp on mp.app_id=wa.id
            where wa.dev=1 
            order by repo_id,id desc";
        appDataTable = dbhelper.ExecuteDataTable(sc);


    }


    public string PrintRepoList()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(@"<div class='form-group row'>");
        sb.Append(@"<label class='col-form-label col-sm-4'>Github Repo</label>");
        sb.Append("<select class='form-control col-sm-8' name='repo'>");

        string sc = "SELECT * FROM git_repository WHERE del=0";
        DataTable dt = dbhelper.ExecuteDataTable(sc);
        foreach (DataRow  dr in dt.Rows)
        {
            sb.Append(String.Format("<option value={0} data-private={1}>{2}</option>",dr["id"], dr["private"], dr["name"]));
        }
   
        sb.Append("<option value='0'  >Not from Github</option>");
        sb.Append("</select>");
        sb.Append("</div>");

        return sb.ToString();
     //
                       
                      
    }
    public string PrintDbList()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(@"<div class='form-group row'>");
        sb.Append(@"<label class='col-form-label col-sm-4'>Database</label>");
        sb.Append("<select class='form-control col-sm-8' name='db'>");

        string sc = "SELECT * FROM db_list order by dev desc,id desc";
        DataTable dt = dbhelper.ExecuteDataTable(sc);
        foreach (DataRow dr in dt.Rows)
        {
            sb.Append(String.Format("<option value={0} >{1}</option>", dr["id"], dr["name"]));
        }

        sb.Append("</select>");
        sb.Append("</div>");

        return sb.ToString();
        //
    }
    public void CreateOrEditAppSettingsJsonFile(string path, int db_id)
    {
        string sc = "SELECT conn_str FROM db_list where id=" + db_id;
        string conn_str = (string)dbhelper.ExecuteScalar(sc);
        SqlConnection conn = new SqlConnection(conn_str);
        string content =JsonConvert.SerializeObject(new
        {
            DataSource=conn.DataSource,
            DBUser="eznz",
            DBpwd="9seqxtf7",
            DBname= conn.Database,
            AlertEmail= "alter2@eznz.com"
        });
        string appSettingsPath = Path.Combine(path, "appSettings.json").ToString() ;

        if (File.Exists(appSettingsPath))
        {
            File.Delete(appSettingsPath);
        }
        using (FileStream fs = File.Open(appSettingsPath, FileMode.OpenOrCreate, FileAccess.Write, FileShare.None))
        {

            Byte[] info = new UTF8Encoding(true).GetBytes(content);
            // Add some information to the file.
            fs.Write(info, 0, info.Length);
        }


    }
    private bool PublishWeb(string webName,string path)
    {
        try
        {
            ServerManager iismanager = new ServerManager();
            //判断应用程序池是否存在
            if (iismanager.ApplicationPools[webName] != null)
            {
                iismanager.ApplicationPools.Remove(iismanager.ApplicationPools[webName]);
            }
            //判断web应用程序是否存在
            if (iismanager.Sites[webName] != null)
            {
                iismanager.Sites.Remove(iismanager.Sites[webName]);
            }
            //建立web应用程序（第二个参数为安装文件的地址）
            //  public Site Add(string name, string bindingProtocol, string bindingInformation, string physicalPath);
            string bindingInformation = "*:80:" + webName;
            Site mySite = iismanager.Sites.Add(webName,"http",bindingInformation, path);
            mySite.ServerAutoStart = true;
            //添加web应用程序池
            ApplicationPool pool = iismanager.ApplicationPools.Add(webName);
            //设置web应用程序池的Framework版本（注意版本号大小写问题）
            pool.ManagedRuntimeVersion = "v4.0";
            //设置是否启用32为应用程序
            //pool.SetAttributeValue("enable32BitAppOnWin64", true);
            //设置web网站的应用程序池
            iismanager.Sites[webName].Applications[0].ApplicationPoolName = webName;
           
            //iismanager.Sites[webName].Bindings.Add(bindInfo, "http");

            //提交更改
            iismanager.CommitChanges();
            return true;
        }
        catch (Exception ex)
        {
            info = ex.Message;
            return false;
        }
    }
    private bool CancelWeb(string webName)
    {
        try
        {
            ServerManager iismanager = new ServerManager();
            //判断应用程序池是否存在
            if (iismanager.ApplicationPools[webName] != null)
            {
                iismanager.ApplicationPools.Remove(iismanager.ApplicationPools[webName]);
            }
            //判断web应用程序是否存在
            if (iismanager.Sites[webName] != null)
            {
                iismanager.Sites.Remove(iismanager.Sites[webName]);
            }
             //提交更改
            iismanager.CommitChanges();
            return true;
        }
        catch (Exception ex)
        {
            info = ex.Message;
            return false;
        }
    }
    public static void DeleteDirectory(string directoryPath)
    {
        if (!Directory.Exists(directoryPath))
        {
            return;
        }

        var files = Directory.GetFiles(directoryPath);
        var directories = Directory.GetDirectories(directoryPath);

        foreach (var file in files)
        {
            File.SetAttributes(file, FileAttributes.Normal);
            File.Delete(file);
        }

        foreach (var dir in directories)
        {
            DeleteDirectory(dir);
        }

        File.SetAttributes(directoryPath, FileAttributes.Normal);

        Directory.Delete(directoryPath, false);
    }
    public string PrintRepoListHeader()
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("<select class='form-control col-sm-4' name='install_db_id' onchange='window.location.href=\"?repo=\"+this.value'>");
        sb.Append("<option value='' >All</option>");
 
        string sc = "SELECT * FROM git_repository where del=0 order by id ";
        DataTable dt = dbhelper.ExecuteDataTable(sc);
        foreach (DataRow dr in dt.Rows)
        {
            sb.Append("<option ");
            if (Request.QueryString["repo"] == dr["id"].ToString())
            {
                sb.Append(" selected ");
            }
            sb.Append(String.Format(" value ={0} >{1}</ option > ", dr["id"], dr["name"]));
        }
        sb.Append("<option value='0' ");
        if (Request.QueryString["repo"] == "0")
        {
            sb.Append(" selected ");
        }
        sb.Append(" >Not from Github</option>");
        sb.Append("</select>");


        return sb.ToString();
        //
    }
    public void CreateOrEditEcomConfigFile(string appPath, int app_id)
    {

        string ecomPath = Path.Combine(appPath, "ecom");
        if (!Directory.Exists(ecomPath))
        {
            //throw (new Exception(path+" does not exist."));
            return;
        }
        string content = "window.config =" + JsonConvert.SerializeObject(new
        {
            apiURL = string.Format(Common.GetSetting("cloud_ecom_api"), app_id),
            LOGIN_AGE=3600
        });

        string configPath = Path.Combine(ecomPath, "config.js").ToString();

        if (File.Exists(configPath))
        {
            File.Delete(configPath);
        }
        using (FileStream fs = File.Open(configPath, FileMode.OpenOrCreate, FileAccess.Write, FileShare.None))
        {

            Byte[] info = new UTF8Encoding(true).GetBytes(content);
            // Add some information to the file.
            fs.Write(info, 0, info.Length);
        }


    }
    public void CreateOrEditConfigFile(string path, int app_id)
    {
        if (!Directory.Exists(path))
        {
            //throw (new Exception(path+" does not exist."));
            return;
        }

        string content = "var config =" + JsonConvert.SerializeObject(new
        {
            url = string.Format(Common.GetSetting("cloud_mreport_api"), app_id),
            accessLevel = 1,
            enduserLevel = 10,
            loadingpic = "/admin/mreport/assets/images/gpos/loading2.gif"
        });
        string configPath = Path.Combine(path, "config.js").ToString();

        if (File.Exists(configPath))
        {
            File.Delete(configPath);
        }
        using (FileStream fs = File.Open(configPath, FileMode.OpenOrCreate, FileAccess.Write, FileShare.None))
        {

            Byte[] info = new UTF8Encoding(true).GetBytes(content);
            // Add some information to the file.
            fs.Write(info, 0, info.Length);
        }


    }
}
