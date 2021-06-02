using LibGit2Sharp;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class v2_invoice : AdminBasePage
{
   
    public DBhelper dbhelper = new DBhelper();
    public string info = "";
    public DataTable companyDataTable;
    public List<DirectoryInfo> companyDirs;
    public string[] allCategoryDirs;
    public string[] cats ;
    public List<string> exceptCompanyDirs = new List<string>(new string[] { "admin", ".git" });
    public List<string> undeleteCompanyList = new List<string>(new string[] { "asiasuperstd","actp" });
    protected void Page_Load(object sender, EventArgs e)
    {
    
        //test();
        if (Request.Form["cmd"] == "addNewCompany")
        {
            GitTest();
            //CreateNewCompany();
        }
        //if (Request.Form["cmd"] == "editCompany")
        //{
        //    EditCompany();
        //}
        //if (Request.Form["cmd"] == "deleteCompany")
        //{
        //    DeleteCompany();
        //}

        //companyDataTable=GetListOfCompany();
        //allCategoryDirs = Common.GetAllCategories();



    }
    public void GitTest()
    {
        Repository.Clone("https://github.com/xty314/adv.git", "G://test");//x86
        //string gitCommand = "git";
        //string gitAddArgument = @"clone https://github.com/libgit2/libgit2sharp.git G://test";
        ////string gitCommitArgument = @"commit ""explanations_of_changes""";
        ////string gitPushArgument = @"push our_remote";

        //Process.Start(gitCommand, gitAddArgument);
    }
    /// <summary>
    /// Total 4 steps
    /// step 1 : delete record in hosttenants
    /// step 2 : delete directory in m folder
    /// step 3 : back up database 
    /// step 4 : drop database
    /// </summary>
    public void DeleteCompany()
    {
      
        string id = Request.Form["id"];
        string company = Request.Form["company"];    
        string reportDir = Request.Form["reportDir"];
        string password = Request.Form["password"];
        string backup = Request.Form["backup"];
        string deleteDb = Request.Form["deleteDb"];
        if (password != "9aysdata")
        {
            info = "Password is not correct!";
            return;
        }
        string sc = "";
        string database = "";
        try
        {
            //get target database
            if (deleteDb == "1")
            {
                sc = "SELECT DbConnectionString FROM hosttenants where id=@id and NewDb=1 and Removable=1";
            }
            else
            {
                sc = "SELECT DbConnectionString FROM hosttenants where id=@id and  Removable=1";
            }
            SqlParameter sqlParameter = new SqlParameter("@id", id);
            string connectString = (string)dbhelper.ExecuteScalar(sc, sqlParameter);
             database = GetDatabase(connectString);

            if (String.IsNullOrEmpty(connectString))
            {
                throw new Exception("You can not drop this database.");         
            }
        
        }
        catch(Exception e)
        {
            info = e.Message;
            return;
        }
    

        //step 1 backup database
        if (backup == "1")
        {
            string backupPath = Common.GetSetting("BACKUP_DIR_PATH") + database + ".bak";
            sc = String.Format("Backup Database {0} To disk = '{1}'", database, backupPath);
            dbhelper.ExecuteNonQuery(sc);
        }
        //step 2 delete database
        if (deleteDb == "1")
        {
            sc = "alter database " + database + " set single_user with rollback immediate ";
            sc += " DROP DATABASE " + database;
            dbhelper.ExecuteNonQuery(sc);
        }
        //step 3 delete files
        string deletePath = Server.MapPath("~/m/" + reportDir);
        if (Directory.Exists(deletePath) && !String.IsNullOrEmpty(reportDir))
        {
            Common.DeleteDir(deletePath);
        }
        //step 4 delete recode
        sc = "DELETE FROM hosttenants WHERE id=@id";
        SqlParameter sqlParameter2 = new SqlParameter("@id", id);
        dbhelper.ExecuteNonQuery(sc, sqlParameter2);
     
       
      
      



    }
    public void EditCompany()
    {
        string id = Request.Form["id"];
        string database = Request.Form["database"];
        string company = Request.Form["company"];
        string server = Request.Form["server"];
       string reportDir= Request.Form["reportDir"];
        string api = Request.Form["api"];
       int removable =0;
        if (!String.IsNullOrEmpty(Request.Form["removable"])&& Request.Form["removable"] == "1")
        {
            removable = 1;
        }
        string connectionString ="Server=" + server + ";Database=" + database + ";User Id=eznz;password=9seqxtf7";
        string sc = @"UPDATE HostTenants SET TradingName=@TradingName,DbConnectionString=@DbConnectionString,ApiBase=@ApiBase,
                    Removable=@Removable WHERE id=@id";
        SqlParameter[] parameters =
        {
           new SqlParameter("@TradingName",company),
            new SqlParameter("@DbConnectionString",connectionString),
             new SqlParameter("@ApiBase",api),
              new SqlParameter("@Removable",removable),
                new SqlParameter("@id",id)
        };
        dbhelper.ExecuteNonQuery(sc, parameters);
        ConfigModel config = new ConfigModel
        {
            url = api + "/app/" + id + "/",
            accessLevel = 1,
            enduserLevel = 10,
            loadingpic = "/admin/mreport/assets/images/gpos/loading2.gif"
        };
        if (!String.IsNullOrEmpty(reportDir))
        {
            EditConfigJsFile(reportDir, config);
        }
        Common.Refresh();

    }
    public string GetDatabase(string connectionString)
    {
        SqlConnection conn = new SqlConnection(connectionString);
        return conn.Database;
    }
    public string GetServer(string connectionString)
    {
        SqlConnection conn = new SqlConnection(connectionString);
        return conn.DataSource;
    }




    /// <summary>
    /// Total 4 steps
    /// step 1 : copy path files to [m] folder
    /// step 2 : insert report and api infomation into host database
    /// step 3 : create a new database for new company
    /// step 4 : retore database
    /// </summary>
    public void CreateNewCompany()
    {
        //step 1
        string company = Request.Form["company"];
        string server = Request.Form["server"];
        string createDatebase = Request.Form["createDb"];
        //Response.Write("createDatebase"+createDatebase);
        //return;
        string companyFolderAndDbName= Regex.Replace(company.ToLower(), @"\s+", "_")+"_m";
        string sourcePath = Server.MapPath("./source");
        string targetPath = Server.MapPath("~/m/" + companyFolderAndDbName);
        //todo: 判断不添加的条件
        if (System.IO.Directory.Exists(targetPath)||String.IsNullOrEmpty(server)|| String.IsNullOrEmpty(company))
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

        //step 2

        string sc;
        if (createDatebase == "1")
        {
            sc = @"INSERT INTO HostTenants (TradingName,DbConnectionString,ApiBase,SyncApi,ReportApi,ReportDir,NewDb) VALUES
                    (@TradingName,@DbConnectionString,@ApiBase,@SyncApi,@ReportApi,@ReportDir,1)";
        }
        else
        {
            sc = @"INSERT INTO HostTenants (TradingName,DbConnectionString,ApiBase,SyncApi,ReportApi,ReportDir) VALUES
                    (@TradingName,@DbConnectionString,@ApiBase,@SyncApi,@ReportApi,@ReportDir)";
        }
            
        string newId = dbhelper.GetNextId("HostTenants").ToString();
        string newDbConnection = "Server=" + server + ";Database=" + companyFolderAndDbName + ";User Id=eznz;password=9seqxtf7";
        SqlParameter[] parameters =
        {
           new SqlParameter("@TradingName", company),
           new SqlParameter("@DbConnectionString",newDbConnection),
           new SqlParameter("@ApiBase", Common.GetSetting("API_URL")),
           new SqlParameter("@SyncApi", "/app/"+newId+"/api/sync/auth"),
           new SqlParameter("@ReportApi", "/app/"+newId+"/"),
           new SqlParameter("@ReportDir",companyFolderAndDbName),
        };
        dbhelper.ExecuteNonQuery(sc, parameters);
        // write config into config.js
        ConfigModel config = new ConfigModel
        {
            url = Common.GetSetting("API_URL") + "/app/" + newId + "/",
            accessLevel = 1,
            enduserLevel = 10,
            loadingpic = "/admin/mreport/assets/images/gpos/loading2.gif"
        };
        EditConfigJsFile(companyFolderAndDbName, config);
     
        string masterDbConnection = "Server=" + server + ";Database=master;User Id=eznz;password=9seqxtf7";
        if (createDatebase == "1") {
            //step 3 create a new database
            try
            {
                dbhelper.CreadDatabase(masterDbConnection, companyFolderAndDbName);
            }
            catch (Exception e)
            {
                info = e.Message;
                return;
            }
            //step 4 restore database
            string databasePath = Common.GetSetting("DB_BAK_PATH");//还原bak的文件地址路径
                                                                   //!!!!bak文件需要在数据库的服务器上，地址也为数据库上bak的路径不是aspx程序的服务器
            DBhelper newDbHelper = new DBhelper(masterDbConnection);
            sc = String.Format("RESTORE DATABASE {0} FROM DISK = '{1}' WITH REPLACE", companyFolderAndDbName, databasePath);
            newDbHelper.ExecuteNonQuery(sc);
        }
      
        Common.Refresh();
    }
    public DataTable GetListOfCompany()
    {
        DBhelper dbhelper = new DBhelper();
        string sc = "select * from HostTenants";
        DataTable dt = dbhelper.ExecuteDataTable(sc);
        return dt;
    }
    public void EditConfigJsFile(string companyFolderAndDbName, ConfigModel config)
    {
     
        string content = "var config =" + JsonConvert.SerializeObject(config);
        string ConfigPath = HttpContext.Current.Server.MapPath("~/m/" + companyFolderAndDbName + "/config.js");
        if (File.Exists(ConfigPath))
        {
            using (StreamWriter sw = new StreamWriter(ConfigPath))
            {
                sw.WriteLine(content);
            }
        }
    }




}