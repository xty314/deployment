using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class database : System.Web.UI.Page
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
        string createDatebase = Request.Form["createDb"];
        string companyFolderAndDbName = Regex.Replace(company.ToLower(), @"\s+", "_");
        string sc;
        if (String.IsNullOrEmpty(createDatebase))
        {
            createDatebase = "0";
        }
       int creator = (int)Session["user_id"];
        //info = (string)Session["login"];
        //return;
        string masterDbConnection = "Server=" + server + ";Database=master;User Id=eznz;password=9seqxtf7";

        if (createDatebase == "1")
        {
            //create a new database
            try
            {
                dbhelper.CreadDatabase(masterDbConnection, companyFolderAndDbName);
                string databasePath = Common.GetSetting("install_db_location");//还原bak的文件地址路径
                                                                               //!!!!bak文件需要在数据库的服务器上，地址也为数据库上bak的路径不是aspx程序的服务器
                                                                               // DBhelper masterHelper = new DBhelper(masterDbConnection);
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
           new SqlParameter("@install_db_id", createDatebase),

        };
        try
        {
            dbhelper.ExecuteNonQuery(sc, parameters);
        }
        catch (Exception e)
        {
            info = e.Message;
        }





        // Common.Refresh();
    }

    private void LoadDatabaseList()
    {
        string sc = "select * from  db_list";
        dbDataTable = dbhelper.ExecuteDataTable(sc);
        //throw new NotImplementedException();
    }
}