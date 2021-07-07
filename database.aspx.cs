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

public partial class database : AdminBasePage
{
    public DBhelper dbhelper = new DBhelper();
    public DataTable dbDataTable = new DataTable();
    public string info = "";
    protected void Page_Load(object sender, EventArgs e)
    {
   
        if (Request.Form["cmd"] == "new")
        {
            CreateNewDatabase();
        }
        else if (Request.Form["cmd"] == "edit")
        {
            EditDatabase();
        }
        else if (Request.Form["cmd"] == "delete")
        {
            DeleteDatabase();
        }
        if (Request.Form["backupDb"] != null && Request.Form["backupDb"] != "")
        {
            BackupDatabase();
        }
        if (Request.Form["copyDb"] != null && Request.Form["copyDb"] != "")
        {
            CopyDatabase();
        }
        LoadDatabaseList();
 
    }

    private void CopyDatabase()
    {
        string databaseId = Request.Form["copyDb"];
        DateTime currentTime = DateTime.Now;
        string backupPath = Common.GetSetting("db_backup_location");
        string connStr = (string)dbhelper.ExecuteScalar("SELECT conn_str FROM db_list WHERE id=" + databaseId);
        try
        {
            string server = Common.GetServer(connStr);
            string database = Common.GetDatabase(connStr);
            string masterDbConnection = "Server=" + server + ";Database=master;User Id=eznz;password=9seqxtf7";
            DBhelper masterHelper = new DBhelper(masterDbConnection);
            string bakName = database + "_" + currentTime.ToString("yyyyMMddHHmmss") + ".bak";
            backupPath = Path.Combine(backupPath, bakName);  //还原bak的文件地址路径
            //step1 备份bak文件
            string sc = String.Format("Backup Database [{0}] To disk = '{1}' WITH INIT", database, backupPath);
            masterHelper.ExecuteNonQuery(sc);
            //step2 创建一个空数据库
            string copyDbName = "dev_"+database + currentTime.ToString("yyyyMMddHHmmss");
            dbhelper.CreadDatabase(masterDbConnection, copyDbName);
       
            //!!!!bak文件需要在数据库的服务器上，地址也为数据库上bak的路径不是aspx程序的服务器
            //step3 还原数据库
            sc = String.Format("RESTORE DATABASE {0} FROM DISK = '{1}' WITH REPLACE", copyDbName, backupPath);
            masterHelper.ExecuteNonQuery(sc);

            int creator = (int)Session["user_id"];
            sc = @"INSERT INTO db_list (name,conn_str,creator,install_db_id,dev) VALUES
                    (@name,@conn_str,@creator,0,1)";
            string newDbConnection = "Server=" + server + ";Database=" + copyDbName + ";User Id=eznz;password=9seqxtf7";


            SqlParameter[] parameters =
            {
               new SqlParameter("@name", copyDbName),
               new SqlParameter("@conn_str",newDbConnection),
               new SqlParameter("@creator", creator),         
            };
            dbhelper.ExecuteNonQuery(sc, parameters);

            info =string.Format("Copy database successfully, new dev database {0} in the server {1}", copyDbName,server);
            //step4 删除生成的临时bak文件
            DeleteBakFileFromDBServer(server, backupPath);
         
           
        }
        catch (Exception e)
        {

            info = e.Message;
        }
        
    }
    private void DeleteBakFileFromDBServer(string server,string bakFilePath)
    {
        //判断传入路径是文件而不是文件夹
        Regex reg = new Regex(@"^(?<fpath>([a-zA-Z]:\\)([\s\.\-\w]+\\)*)(?<fname>[\w]+.bak)$");    
        Match result = reg.Match(bakFilePath);
        if (!result.Success)
        {
            info = "This Path is not a file.";
            return;
        }
        string masterDbConnection = "Server=" + server + ";Database=master;User Id=eznz;password=9seqxtf7";
        DBhelper masterHelper = new DBhelper(masterDbConnection); 
        try
        {
            string sc = "";
            sc += " RECONFIGURE "; //先执行一次刷新，处理上次的配置
             sc += " EXEC sp_configure 'show advanced options',1 "; //启用xp_cmdshell的高级配置
            sc += " RECONFIGURE";     //刷新配置
            sc += " EXEC sp_configure 'xp_cmdshell',1 ";//打开xp_cmdshell,可以调用SQL系统之外的命令
            sc += " RECONFIGURE "; //刷新配置
            sc += " EXEC master.dbo.xp_cmdshell 'del "+ bakFilePath + "',no_output "; //使用xp_cmdshell删除bak文件,[no_output]表示是否输出信息     
            sc += " EXEC sp_configure 'show advanced options','1' ";//确保show advances options 的值为1,这样才可以执行xp_cmdshell为0的操作 
            sc += " RECONFIGURE ";//刷新配置
            sc += " EXEC sp_configure 'xp_cmdshell',0"; //关闭xp_cmdshell 
            sc += " RECONFIGURE";//刷新配置
            sc += " EXEC sp_configure 'show advanced options','0' ";//关闭show advanced options
            SqlParameter sqlParameter = new SqlParameter("@bakPath", bakFilePath);
            masterHelper.ExecuteNonQuery(sc);
        }
        catch(Exception e)
        {
            info = e.Message;
        }

    }
    private void DeleteDatabase()
    {

        string id = Request.Form["id"];
        string password = Request.Form["password"];
        string backup = Request.Form["backup"];
        string deleteDb = Request.Form["deleteDb"];
        if (password != "9aysdata")
        {
            info = "Password is not correct!";
            return;
        }
        string sc = "";
        DataRow dr = dbhelper.ExecuteDataTable("select top 1 * from db_list where id=" + id).Rows[0];
        
        int origin = (int)dr["install_db_id"];
        if (!(bool)dr["removable"])
        {
            info = "You can not drop this database. This database is unremovable";
            return;
        }
        //check if there is any web app connecting to this app
        int count =(int)dbhelper.ExecuteScalar("select count(*) from web_app where db_id=" + id);
        if (count > 0)
        {
            info = "You can not drop this database. This database is occupied by some app.";
            return;
        }
        if (origin != 0)
        {
            string database = Common.GetDatabase(dr["conn_str"].ToString());
            //step 1 backup database
            //todo   
            if (backup == "1")
            {
                Backup(database);
       
            }
            //step 2 delete database
            if (deleteDb == "1")
            {
                sc = "alter database " + database + " set single_user with rollback immediate ";
                sc += " DROP DATABASE " + database;
                dbhelper.ExecuteNonQuery(sc);
            }

        }

        try
        {   
            //step 3 delete recode
            sc = "DELETE FROM db_list WHERE id=@id";
            SqlParameter sqlParameter2 = new SqlParameter("@id", id);
            dbhelper.ExecuteNonQuery(sc, sqlParameter2);
        }catch(Exception e)
        {
            info = e.Message;
            return;
        }
        Common.Refresh();
    }

    private void EditDatabase()
    {
        string id = Request.Form["id"];
        string database = Regex.Replace(Request.Form["database"].ToString().Trim(), @"\s+", "_");
        string name = Request.Form["name"];
        string server = Request.Form["server"].ToString().Trim();
        int removable = String.IsNullOrEmpty(Request.Form["removable"])?0:1;
    
   
        try
        {
            string connectionString = "Server=" + server + ";Database=" + database + ";User Id=eznz;password=9seqxtf7";
            DBhelper newDBhelper = new DBhelper(connectionString);

            string sc = "";
            string oldConnectionString = (string)dbhelper.ExecuteScalar("select conn_str from db_list where id=" + id);
            if (connectionString != oldConnectionString)
            {
                // new database must be able to connected.
                if (!newDBhelper.ConnectTest())
                {
                    info = string.Format("Can not connect to server：{0} ,database : {1}", server, database);
                    return;
                }
                //if change the database
                //the connection string exists in the db_list
                sc = "SELECT count(*) FROM db_list where conn_str='" + connectionString + "'";
                int count = (int)dbhelper.ExecuteScalar(sc);
                if (count > 0)
                {
                    info = string.Format("server：{0} ,database : {1} has already existed.", server, database);
                    return;
                }
                sc = @"UPDATE db_list SET conn_str=@conn_str,install_db_id=0 WHERE id=@id";
                SqlParameter[] parameters1 =
                {
                        new SqlParameter("@conn_str",connectionString),
                        new SqlParameter("@id",id)
                    };
                dbhelper.ExecuteNonQuery(sc, parameters1);
            }
            sc = @"UPDATE db_list SET name=@name,removable=@removable WHERE id=@id";
            SqlParameter[] parameters =
            {
                       new SqlParameter("@name",name),
                          new SqlParameter("@removable",removable),
                            new SqlParameter("@id",id)
             };
            dbhelper.ExecuteNonQuery(sc, parameters);
     
            
       
           
         
        }catch(Exception e)
        {
            info = e.Message;
            return;
        }
       
        Common.Refresh();
    }
    private void BackupDatabase()
    {
        string database = Request.Form["backupDb"];
        info= Backup(database);
    }
    private void CreateNewDatabase()
    {
        //step 1
        string name = Request.Form["dbname"];
        string server = Request.Form["server"].ToString().Trim();
        string install_db_id = Request.Form["install_db_id"];
        string databaseName = Regex.Replace(name.ToLower(), @"\s+", "_");
        string sc;
   
       int creator = (int)Session["user_id"];
        //info = (string)Session["login"];
        //return;
        string newDbConnection = "Server=" + server + ";Database=" + databaseName + ";User Id=eznz;password=9seqxtf7";
        
        string masterDbConnection = "Server=" + server + ";Database=master;User Id=eznz;password=9seqxtf7";
        if (install_db_id != "0")
        {
            //create a new database
            try
            {
                dbhelper.CreadDatabase(masterDbConnection, databaseName);

                sc = "SELECT location FROM install_db where id=" + install_db_id;
                string databasePath = Path.GetFullPath((string)dbhelper.ExecuteScalar(sc));
                //还原bak的文件地址路径
                //!!!!bak文件需要在数据库的服务器上，地址也为数据库上bak的路径不是aspx程序的服务器
            
                DBhelper masterHelper = new DBhelper("master");
                sc = String.Format("RESTORE DATABASE {0} FROM DISK = '{1}' WITH REPLACE", databaseName, databasePath);
                masterHelper.ExecuteNonQuery(sc);
            }
            catch (Exception e)
            {
                info = e.Message;
                return;
            }
            //restore database
        }
        else
        {
            //the connection string exists in the db_list
            sc = "SELECT count(*) FROM db_list where conn_str='" + newDbConnection + "'";
            int count = (int)dbhelper.ExecuteScalar(sc);
            if (count > 0)
            {
                info = string.Format("server：{0} ,database : {1} has already existed.", server, databaseName);
                return;
            }
        }

        DBhelper newdbHelper = new DBhelper(newDbConnection);
        if (!newdbHelper.ConnectTest())
        {
            info = string.Format("Can not connect to server：{0} ,database : {1}", server, databaseName);
            return;
        }
       


        sc = @"INSERT INTO db_list (name,conn_str,creator,install_db_id) VALUES
                    (@name,@conn_str,@creator,@install_db_id)";
        string newId = dbhelper.GetNextId("db_list").ToString();
      



        SqlParameter[] parameters =
        {
           new SqlParameter("@name", name),
           new SqlParameter("@conn_str",newDbConnection),
           new SqlParameter("@creator", creator),
           new SqlParameter("@install_db_id", install_db_id),

        };
        try
        {
            //没有script表时将在新数据库中创建script table，该表用于记录所有运行脚本的信息
            if (!newdbHelper.IsExistTable("script"))
            {
                string createScriptTable = @"CREATE TABLE [dbo].[script](
	                                        [id] [int] NULL,
	                                        [name] [nvarchar](50) NULL,
	                                        [uploader] [int] NULL,
	                                        [upload_date] [datetime] NULL,
	                                        [description] [ntext] NOT NULL,
	                                        [location] [nvarchar](max) NULL,
                                            [executor] [int] NULL,
                                            [record_id] [int] NULL,
	                                        [execute_date] [datetime] NULL CONSTRAINT [DF_script_execute_date]  DEFAULT (getdate())
                                        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]";
                newdbHelper.ExecuteNonQuery(createScriptTable);
            }
          
            dbhelper.ExecuteNonQuery(sc, parameters);
        }
        catch (Exception e)
        {
            info = e.Message;
            return;
        }





      Common.Refresh();
    }
    private string Backup(string databaseId)
    {
        DateTime currentTime = DateTime.Now;
        string backupPath = Common.GetSetting("db_backup_location");
        string connStr = (string)dbhelper.ExecuteScalar("SELECT conn_str FROM db_list WHERE id=" + databaseId);
        try
        {
            string server = Common.GetServer(connStr);
            string database = Common.GetDatabase(connStr);
            string masterDbConnection = "Server=" + server + ";Database=master;User Id=eznz;password=9seqxtf7";
            DBhelper masterHelper = new DBhelper(masterDbConnection);
            string bakName = database + "_" + currentTime.ToString("yyyyMMddHHmmss") + ".bak";
            backupPath = Path.Combine(backupPath, bakName);
            string sc = String.Format("Backup Database [{0}] To disk = '{1}' WITH INIT", database, backupPath);
            masterHelper.ExecuteNonQuery(sc);
            return string.Format("Backup successfully, please go to {0} to check file {1}", Common.GetSetting("db_server"), backupPath);
        }catch(Exception e)
        {
        
            return e.Message;
        }
       
      
    }
    private void LoadDatabaseList()
    {
        string origin = Request.QueryString["origin"];
        string sc = "";
        if (string.IsNullOrEmpty(origin))
        {
            sc= "select db.*,id.name as 'install_db_name' from  db_list db left join install_db id on db.install_db_id=id.id where db.dev=0";
        }
        else 
        {
            sc = "select db.*,id.name as 'install_db_name' from  db_list db left join install_db id on db.install_db_id=id.id where db.dev=0 and db.install_db_id="+origin;
        }
      
        dbDataTable = dbhelper.ExecuteDataTable(sc);
       
    }

    public string PrintInstallDbList()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(@"<div class='form-group row'>");
        sb.Append(@"<label class='col-form-label col-sm-4'>Install DB</label>");
        sb.Append("<select class='form-control col-sm-8' name='install_db_id'>");
        sb.Append("<option value='0' >Existing Database</option>");
        string sc = "SELECT * FROM install_db order by id desc";
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
    public string PrintInstallDbListHeader()
    {
        StringBuilder sb = new StringBuilder();
        
        sb.Append("<select class='form-control col-sm-4' name='install_db_id' onchange='window.location.href=\"?origin=\"+this.value'>");
        sb.Append("<option value='' >All</option>");
        sb.Append("<option value='0' ");
        if (Request.QueryString["origin"] == "0")
        {
            sb.Append(" selected ");
        }
        sb.Append(" >Existing Database</option>");
        string sc = "SELECT * FROM install_db order by id ";
        DataTable dt = dbhelper.ExecuteDataTable(sc);
        foreach (DataRow dr in dt.Rows)
        {
            sb.Append("<option ");
            if (Request.QueryString["origin"] == dr["id"].ToString())
            {
                sb.Append(" selected ");
            }
            sb.Append(String.Format(" value ={0} >{1}</ option > ", dr["id"], dr["name"]));
        }

        sb.Append("</select>");
       

        return sb.ToString();
        //
    }
    public string ActiveRow(string id)
    {
        string result = "";

        if (id ==Request.QueryString["id"])
        {
            result = "active-tr";
        }
        return result;
    }
}