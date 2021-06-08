using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class install_db : AdminBasePage
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
        LoadDatabaseList();
        
    }

    private void CreateNewDatabase()
    {
        string dbName= Request.Form["dbname"];
        string server = Request.Form["server"];
        string location = Request.Form["location"];
        string description= Request.Form["description"];
        string newInsatllDbConnection = "Server=" + server + ";Database=" + dbName + ";User Id=eznz;password=9seqxtf7";
        DBhelper installDbHelper = new DBhelper(newInsatllDbConnection);
        if (installDbHelper.ConnectTest())
        {
            if (!installDbHelper.IsExistTable("script"))
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
                installDbHelper.ExecuteNonQuery(createScriptTable);
            }
           
            string sc = "INSERT INTO install_db(name,location,conn_str,description) VALUES (@name,@location,@conn,@description)";

            SqlParameter[] sqlParameters =
            {
                new SqlParameter("@name",dbName),
                 new SqlParameter("@location",location),
                  new SqlParameter("@conn",newInsatllDbConnection),
                  new SqlParameter("@description",description)
            };
            dbhelper.ExecuteNonQuery(sc, sqlParameters);

        }
        else
        {
            info = String.Format("Can not connect to {0} in db server {1}", dbName, server);
            return;
        }
       
    }

    private void LoadDatabaseList()
    {
        string sc = "select * from  install_db";
        dbDataTable = dbhelper.ExecuteDataTable(sc);
        //throw new NotImplementedException();
    }
}