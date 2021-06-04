using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class execute : AdminBasePage
{
    public DBhelper dbhelper = new DBhelper();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.Form["cmd"] == "run")
        {
            Response.Clear();
            RunScript();
            Response.End();
        }
    }
    private void RunScript()
    {
        string[] dbIds = Request.Form.GetValues("id");
        string[] scriptIds = Request.Form.GetValues("scripts");
        string install_db = Request.Form["install_db"];
        if (dbIds==null)
        {
            Response.Write("<h1>No database selected, please try again.</h1>");
            Response.Flush();
            return;
        }
        if (scriptIds==null)
        {
            Response.Write("<h1>No scripts selected, please try again.</h1>");
            Response.Flush();
            return;
        }
        //List<string> conn_strs = new List<string>();
        //foreach(string dbId in dbIds)
        //{
        //    string conn_str = (string)dbhelper.ExecuteScalar("SELECT conn_str from db_list where id=" + dbId);
        //    conn_strs.Add(conn_str);
        //}

        string cmd = "SELECT id,conn_str,0 as is_install  from db_list where  id in ('" + string.Join("','", dbIds) + "')";
        if (install_db == "1")
        {
            cmd += " UNION ";
            cmd += "select distinct id.id,id.conn_str,1 as is_install from db_list dl left join install_db id on dl.install_db_id=id.id where id.id is not null and dl.id in ('" + string.Join("','", dbIds) + "')";
        }

        DataTable dbDataTable = dbhelper.ExecuteDataTable(cmd);


        try
        {
            foreach (DataRow dr in dbDataTable.Rows)
            {

                string conn_str = dr["conn_str"].ToString();
                Response.Write(String.Format("<h1>Database:{0} starts running the scripts</h1>", Common.GetDatabase(conn_str)));
                Response.Flush();
                string sc = "select id,location,name,uploader,description,upload_date from script where id in ('" + string.Join("','", scriptIds) + "')";
                DataTable dt = dbhelper.ExecuteDataTable(sc);
                DBhelper tenantDbHelper = new DBhelper(conn_str);
                if (!tenantDbHelper.ConnectTest())
                {
                    Response.Write(string.Format("<h3 style='color:red'>Database：{0} Server:{1} connect error</h3>", Common.GetDatabase(conn_str), Common.GetServer(conn_str)));
                    Response.Flush();
                    continue;
                }
                foreach (DataRow scriptDr in dt.Rows)
                {

                    string filePath = scriptDr["location"].ToString();
                    string content = System.IO.File.ReadAllText(filePath);

                    sc = "SELECT ISNULL((SELECT top(1) id FROM script WHERE id=@script_id and upload_date=@upload_date), 0)";
                    SqlParameter[] sqlParameters2 =
                    {
                        new SqlParameter("@script_id",scriptDr["id"].ToString()),
                        new SqlParameter("@upload_date", scriptDr["upload_date"].ToString())

                    };
                    int count = (int)tenantDbHelper.ExecuteScalar(sc, sqlParameters2);
                    if (count != 0)
                    {
                        Response.Write(String.Format("<h2 style='color:blue'>Script:{0} has already executed in Database:{1} </h2>", scriptDr["name"].ToString(), Common.GetDatabase(conn_str)));
                        Response.Write(string.Format("<h3 style='color:blue'>{0}</h3>", content));

                        Response.Flush();
                        continue;
                    }



                    Response.Write(String.Format("<h2 style='color:green'>Script:{0} starts running </h2>", scriptDr["name"].ToString()));
                    Response.Flush();
                    content = " BEGIN TRANSACTION " + content + " COMMIT ";
                    //execute script
                    try
                    {
                        tenantDbHelper.ExecuteNonQuery(content);
                    }
                    catch (Exception ex)
                    {
                        Response.Write(string.Format("<h3 style='color:red'>Script Error! {0}:{1} </h3>", scriptDr["name"].ToString(), scriptDr["location"].ToString()));
                        Response.Write(string.Format("<h3 style='color:red'>{0}</h3>", content));
                        Response.Write(string.Format("<h3 style='color:red'>{0}</h3>", ex.Message));
                        Response.Flush();
                        continue;
                    }
                    Response.Write(String.Format("<h3 style='color:green'>{0}  </h3>", content));
                    Response.Write(String.Format("<h2 style='color:green'>Script:{0} finished </h2>", scriptDr["name"].ToString()));
                    Response.Flush();



                    //run script successfully following record.
                    string sql = " insert into script (id,name,uploader,upload_date,description,location) values (@id,@name,@uploader,@upload_date,@description,@location) ";
                    SqlParameter[] sqlParameters = {
                        new SqlParameter("@id",scriptDr["id"].ToString()),
                        new SqlParameter("@name",scriptDr["name"].ToString()),
                        new SqlParameter("@uploader",scriptDr["uploader"].ToString()),
                         new SqlParameter("@upload_date",scriptDr["upload_date"].ToString()),
                        new SqlParameter("@description",scriptDr["description"].ToString()),
                        new SqlParameter("@location",scriptDr["location"].ToString()),
                    };
                    //record in the tenant db
                    tenantDbHelper.ExecuteNonQuery(sql, sqlParameters);
                    sql = @"insert into script_record (script_id,db_id,install_db_id) select @script_id
                            ,isnull((select id from db_list where conn_str=@conn_str),0)
                            ,isnull((select id from install_db where conn_str=@conn_str),0)";
                    SqlParameter[] sqlParameters1 = {
                        new SqlParameter("@script_id",scriptDr["id"].ToString()),
                        new SqlParameter("@conn_str",conn_str),
                    };
                    //record in the host db
                    dbhelper.ExecuteNonQuery(sql, sqlParameters1);
                }
                Response.Write(String.Format("<h1>Database:{0} excuted {1} scripts.</h1>", Common.GetDatabase(conn_str), scriptIds.Length));
                Response.Flush();

            }

        }
        catch (Exception e)
        {

            Response.Write(e.Message);
            return;
        }


    }
}