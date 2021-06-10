using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

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
        }else if(Request.Form["cmd"] == "edit")
        {
            EditDatabase();
        }
        if (Request.Form["backup"] !=null&&Common.IsNumberic(Request.Form["backup"].ToString()))
        {
            Backup();
        }
        LoadDatabaseList();
        
    }

    private void CreateNewDatabase()
    {
        string dbName= Request.Form["dbname"].ToString().Trim();
        string server = Request.Form["server"].ToString().Trim();
        string location = Path.Combine(Path.GetFullPath(Request.Form["location"].ToString().Trim()), dbName + ".bak").ToString();

        string description= Request.Form["description"].ToString().Trim();
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
                                            [executor] [int] NULL,
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
           int newId= dbhelper.InsertAndGetId(sc, sqlParameters);
           Common.UpdateInstallDbBak(newId);

        }
        else
        {
            info = String.Format("Can not connect to {0} in db server {1}", dbName, server);
            return;
        }
       
    }
    private void EditDatabase()
    {
        string dbName = Request.Form["name"].ToString().Trim();
        string id = Request.Form["id"].ToString().Trim();
        string location = Request.Form["location"].ToString().Trim();

        string description = Request.Form["description"].ToString().Trim();
     
            string sc = "UPDATE  install_db SET name=@name,location=@location,description=@description where id=@id";

            SqlParameter[] sqlParameters =
            {
                new SqlParameter("@name",dbName),
                 new SqlParameter("@location",location),
                new SqlParameter("@id",id),
                  new SqlParameter("@description",description)
            };
        try
        {
            dbhelper.ExecuteNonQuery(sc, sqlParameters);
            Common.Refresh();
        }catch(Exception e)
        {
            info = e.Message;
            return;
        }
           
          

   

    }







    private void LoadDatabaseList()
    {
        string sc = "select * from  install_db";
        dbDataTable = dbhelper.ExecuteDataTable(sc);
        //throw new NotImplementedException();
    }
    private void Backup()
    {
        string id = Request.Form["backup"];
        Common.UpdateInstallDbBak(Convert.ToInt32(id));

    }
}