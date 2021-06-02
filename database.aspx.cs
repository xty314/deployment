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
        LoadDatabaseList();
    }

    private void CreateNewDatabase()
    {
        //step 1
        string company = Request.Form["dbname"];
        string server = Request.Form["server"];
        string install_db_id = Request.Form["install_db_id"];
        string companyFolderAndDbName = Regex.Replace(company.ToLower(), @"\s+", "_");
        string sc;
   
       int creator = (int)Session["user_id"];
        //info = (string)Session["login"];
        //return;
        string masterDbConnection = "Server=" + server + ";Database=master;User Id=eznz;password=9seqxtf7";

        if (install_db_id != "0")
        {
            //create a new database
            try
            {
                dbhelper.CreadDatabase(masterDbConnection, companyFolderAndDbName);

                sc = "SELECT location FROM install_db where id=" + install_db_id;
                string databasePath = Path.GetFullPath((string)dbhelper.ExecuteScalar(sc));
                //还原bak的文件地址路径
                //!!!!bak文件需要在数据库的服务器上，地址也为数据库上bak的路径不是aspx程序的服务器
            
                DBhelper masterHelper = new DBhelper("master");
                sc = String.Format("RESTORE DATABASE {0} FROM DISK = '{1}' WITH REPLACE", companyFolderAndDbName, databasePath);
                masterHelper.ExecuteNonQuery(sc);
            }
            catch (Exception e)
            {
                info = e.Message;
                return;
            }
            //restore database
     
        }


        sc = @"INSERT INTO db_list (name,conn_str,creator,install_db_id) VALUES
                    (@TradingName,@DbConnectionString,@creator,@install_db_id)";
        string newId = dbhelper.GetNextId("db_list").ToString();
        string newDbConnection = "Server=" + server + ";Database=" + companyFolderAndDbName + ";User Id=eznz;password=9seqxtf7";




        SqlParameter[] parameters =
        {
           new SqlParameter("@TradingName", company),
           new SqlParameter("@DbConnectionString",newDbConnection),
           new SqlParameter("@creator", creator),
           new SqlParameter("@install_db_id", install_db_id),

        };
        try
        {
            //没有script表时将在新数据库中创建script table，该表用于记录所有运行脚本的信息
            DBhelper newdbHelper = new DBhelper(newDbConnection);
            if (!newdbHelper.IsExistTable("script"))
            {
                string createScriptTable = @"CREATE TABLE [dbo].[script](
	                                        [id] [int] NULL,
	                                        [name] [nvarchar](50) NULL,
	                                        [uploader] [int] NULL,
	                                        [upload_date] [datetime] NULL,
	                                        [description] [ntext] NOT NULL,
	                                        [location] [nvarchar](max) NULL
                                        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]";
                newdbHelper.ExecuteNonQuery(createScriptTable);
            }
          
            dbhelper.ExecuteNonQuery(sc, parameters);
        }
        catch (Exception e)
        {
            info = e.Message;
        }





      //Common.Refresh();
    }

    private void LoadDatabaseList()
    {
        string sc = "select * from  db_list";
        dbDataTable = dbhelper.ExecuteDataTable(sc);
        //throw new NotImplementedException();
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
}