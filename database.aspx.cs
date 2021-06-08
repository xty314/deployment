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
     
        LoadDatabaseList();
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
            //if (backup == "1")
            //{
            //    string backupPath = Common.GetSetting("BACKUP_DIR_PATH") + database + ".bak";
            //    sc = String.Format("Backup Database {0} To disk = '{1}' WITH INIT", database, backupPath);
            //    dbhelper.ExecuteNonQuery(sc);
            //}
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
                                            [executer] [int] NULL,
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

    private void LoadDatabaseList()
    {
        string origin = Request.QueryString["origin"];
        string sc = "";
        if (string.IsNullOrEmpty(origin))
        {
            sc="select db.*,id.name as 'install_db_name' from  db_list db left join install_db id on db.install_db_id=id.id";
        }
        else 
        {
            sc = "select db.*,id.name as 'install_db_name' from  db_list db left join install_db id on db.install_db_id=id.id where db.install_db_id="+origin;
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
}