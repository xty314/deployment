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
     
        LoadAppList();
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
            if (dr["db_id"].ToString() != db_id)//if the db of app is change, regenerate a new appSettings.json
            {
                CreateOrEditAppSettingsJsonFile(dr["location"].ToString(), Convert.ToInt32(db_id));
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
        bool deleteFile = string.IsNullOrEmpty(Request.Form["deleteFile"])?false:true;
      
        if (password != Common.password)
        {
            info = "invalid password";
            return;
        }
        string sc = "SELECT top 1 * from web_app where id=" + app_id;
        DataTable dt = dbhelper.ExecuteDataTable(sc);
        DataRow dr = dt.Rows[0];
        if ((bool)dr["deploy"])
        {
            info = "This app has already deployed in IIS, please unbind the app first and try again.";
            return;
        }
        if ((bool)dr["customize"])
        {
            info = "This app is customized. Please delete this app manually";
            return;
        }
        if (!(bool)dr["removable"])
        {
            info = "This app can not be removed.";
            return;
        }
        if ((int)dr["repo_id"]<=0||string.IsNullOrEmpty(dr["location"].ToString()))
        {
            deleteFile = false;
            string sql = "SELECT count(*) from mreport where app_id=" + app_id;
            int count = (int)dbhelper.ExecuteScalar(sql);
            if (count > 0)
            {
                info = "This app is occupied by mreport, please delete mreport first and try again.";
                return;
            }
        }
        try
        {
            if (deleteFile)
            {
                DirectoryInfo di = new DirectoryInfo(Path.GetFullPath(dr["location"].ToString()));
                if (di.Exists)
                {
                    DeleteDirectory(Path.GetFullPath(dr["location"].ToString()));
                }
            }
         
            sc = "DELETE FROM web_app where id=" + app_id;
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
        string name = Request.Form["name"];
        string repo = Request.Form["repo"];
        string description = Request.Form["description"];
        string username = Request.Form["gitname"];
        string password = Request.Form["gitpass"];
        string db= Request.Form["db"];
     
        string location = Path.GetFullPath(Request.Form["location"].ToString());
        if (Convert.ToInt32(repo) > 0)//greater than 0 means choose one valid github repo
        {
            if (string.IsNullOrEmpty(location))
            {
                location = Path.GetFullPath(Common.GetSetting("app_install_location"));
            }
            string sc = "SELECT * FROM git_repository WHERE id=" + repo;
            DataTable repoDt = dbhelper.ExecuteDataTable(sc);
            string directoryPath = Path.Combine(location, name);//location + "\\\\" + name;

            if (!Directory.Exists(directoryPath))
            {
                Directory.CreateDirectory(directoryPath);
            }
            else
            {
                info = "App directory exists, please change a name.";
                return;
            }
            if (repoDt.Rows.Count == 1)
            {

                DataRow dr = repoDt.Rows[0];
                Response.Clear();
                Response.Write("<h1>Download Starting...</h1>");
                Response.Write("<h1>Please do not close the page, it will spend several minutes to download files...</h1>");
                Response.Flush();
                try
                {
                    if (!(bool)dr["private"])
                    {
                        //public  git repo no password
                        Repository.Clone(dr["url"].ToString(), directoryPath);//x64

                    }
                    else
                    {
                        CloneOptions options = new CloneOptions
                        {
                            CredentialsProvider = (_url, _user, _cred) => new UsernamePasswordCredentials
                            {
                                Username = username,
                                Password = password
                            },
                        };

                        //private git repo need user name and password
                        Repository.Clone(dr["url"].ToString(), directoryPath, options);//x64
                    }
                }
                catch (Exception e)
                {
                    DirectoryInfo di = new DirectoryInfo(directoryPath);
                    di.Delete();//如果出错就删除创建的文件夹
                    info = e.Message;
                    return;
                }
                Response.Write("Download Fininshed.");
                Response.Write("Record into databaset Starting.");
                Response.Flush();
                //step2: insert into database
                sc = "INSERT into web_app (name,location,db_id,repo_id,creator,description) VALUES(@name,@location,@db_id,@repo_id,@creator,@description) ";
                SqlParameter[] sqlParameters =
                {
                    new SqlParameter("@name",name),
                    new SqlParameter("@location",directoryPath),
                    new SqlParameter("@db_id",db),
                    new SqlParameter("@repo_id",repo),
                    new SqlParameter("@creator",(int)Session["user_id"]),
                    new SqlParameter("@description", description)
                };
                dbhelper.ExecuteNonQuery(sc, sqlParameters);
                Response.Write("Record into databaset Finished.");
                Response.Flush();
                Common.Refresh();
                //step3:create appSettings.json for add connecting to the database
                CreateOrEditAppSettingsJsonFile(directoryPath, Convert.ToInt32(db));
            }
        }
        else{
            //repo<0 means one empty app
           string sc = "INSERT into web_app (name,location,db_id,repo_id,creator,description) VALUES(@name,'',@db_id,@repo_id,@creator,@description) ";
            SqlParameter[] sqlParameters =
            {
                    new SqlParameter("@name",name),
                    new SqlParameter("@db_id",db),
                    new SqlParameter("@repo_id",repo),
                    new SqlParameter("@creator",(int)Session["user_id"]),
                    new SqlParameter("@description", description)
                };
            dbhelper.ExecuteNonQuery(sc, sqlParameters);
        }
       
        
    }

    public void LoadAppList()
    {
        string repo = Request.QueryString["repo"];
        string sc = "";
        if (string.IsNullOrEmpty(repo))
        {
            sc = @"SELECT wa.*,db.conn_str,db.name as 'db_name',gr.name as 'repo_name',mp.url as 'mreport_url' from web_app wa 
                left join db_list db on wa.db_id=db.id 
                left join git_repository gr on wa.repo_id=gr.id 
                left join mreport mp on mp.app_id=wa.id
                order by repo_id,id desc";

        }
        else{
            sc = @"SELECT wa.*,db.conn_str,db.name as 'db_name',gr.name as 'repo_name',mp.url as 'mreport_url' from web_app wa 
                left join db_list db on wa.db_id=db.id 
                left join git_repository gr on wa.repo_id=gr.id 
                left join mreport mp on mp.app_id=wa.id
                where wa.repo_id=" + repo;
        }
      
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

        string sc = "SELECT * FROM db_list order by id desc";
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
}
