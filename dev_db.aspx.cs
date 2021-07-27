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
   
       if (Request.Form["cmd"] == "edit")
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
        DataRow dr = dbhelper.ExecuteDataTable("select top 1 * from db_list where dev=1 and id=" + id).Rows[0];
        int origin = (int)dr["install_db_id"];
        bool dev = (bool)dr["dev"];
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
      
        try
        {
            if (origin == 0 && dev )
            {
                string database = Common.GetDatabase(dr["conn_str"].ToString());
                // delete database
                if (deleteDb == "1")
                {
                    sc = " if exists(select * from sys.databases where name = '" + database + "') ";
                    sc += " BEGIN ";
                    sc += "alter database " + database + " set single_user with rollback immediate ";
                    sc += " DROP DATABASE " + database;
                    sc += " END ";
                    dbhelper.ExecuteNonQuery(sc);
                }
            }
            else
            {
                info = "You can not delete this database. Check this database if it is a dev db.";
                return;
            }
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
 
   

    private void LoadDatabaseList()
    {
        string origin = Request.QueryString["origin"];
        string sc = "";
        if (string.IsNullOrEmpty(origin))
        {
            sc="select db.*,id.name as 'install_db_name' from  db_list db left join install_db id on db.install_db_id=id.id where db.dev=1";
        }
        else 
        {
            sc = "select db.*,id.name as 'install_db_name' from  db_list db left join install_db id on db.install_db_id=id.id where db.dev=1 and db.install_db_id=" + origin;
        }
      
        dbDataTable = dbhelper.ExecuteDataTable(sc);
       
    }

    public string ActiveRow(string id)
    {
        string result = "";

        if (id == Request.QueryString["id"])
        {
            result = "active-tr";
        }
        return result;
    }

}