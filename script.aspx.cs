using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class script : AdminBasePage
{
    public DBhelper dbhelper = new DBhelper();
    public DataTable scriptDataTable = new DataTable();
    public string DBName = "Script List";
    public string info = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.Form["cmd"] == "new")
        {
            CreateScript();
        }
        if (Request.Form["cmd"] == "upload")
        {
            UploadScript();
        }
        if (Request.Form["cmd"] == "delete")
        {
            DeleteScript();
        }
        if (Request.Form["cmd"] == "edit")
        {
            EditScript();
        }
        if (!String.IsNullOrEmpty(Request.QueryString["download"])&&Common.IsNumberic(Request.QueryString["download"]))
        {
            DownloadScript();
        }
        LoadScriptList();
    }

    private void EditScript()
    {

        string scriptId = Request.Form["id"];
        string name= Request.Form["name"];
        string description= Request.Form["description"];
        string sc = "UPDATE  script SET name=@name,description=@description WHERE id=@id";
        SqlParameter[] sqlParameters =
        {
            new SqlParameter("@name",name),
            new SqlParameter("@description",description),
            new SqlParameter("@id",scriptId)
        };
        dbhelper.ExecuteNonQuery(sc,sqlParameters);
        Common.Refresh();
    }

    private void DeleteScript()
    {
        string scriptId = Request.Form["id"];
        string sc = "UPDATE  script SET del=1 WHERE id=" + scriptId;
        dbhelper.ExecuteNonQuery(sc);
        Common.Refresh();
    }

    private void CreateScript()
    {
       string content = Request["content"];
        string name = Request.Form["name"];
        string description = Request.Form["description"];
        string scriptPath = Server.MapPath("~/script/" + name + ".sql");


        if (System.IO.File.Exists(scriptPath))
        {
            scriptPath = Server.MapPath("~/script/" + Path.GetRandomFileName() + ".sql");
        }
        try
        {
            using (System.IO.FileStream fs = System.IO.File.Create(scriptPath))
            {
                byte[] info = new UTF8Encoding(true).GetBytes(content);
                // 向文件中写入一些信息。
                fs.Write(info, 0, info.Length);
            }
            string sc = @"INSERT INTO script ([name]
           ,[location]
           ,[uploader]       
           ,[description]
           ,[del]) VALUES (@name,@location,@uploader,@description,0)";
            SqlParameter[] sqlParameters =
            {
                new SqlParameter("@name",name),
                 new SqlParameter("@location",scriptPath),
                  new SqlParameter("@uploader",Session["user_id"]),
                   new SqlParameter("@description",description),
            };
            dbhelper.ExecuteNonQuery(sc, sqlParameters);

        }
        catch(Exception e)
        {
            info = e.Message;
            return;
        }
       

    


    }

    public void LoadScriptList()
    {
        string db = Request.QueryString["db"];
        string id = Request.QueryString["id"];
        string origin = Request.QueryString["origin"];
        if (!String.IsNullOrEmpty(db)&&Common.IsNumberic(db))
        {
            string sc = "SELECT name from db_list where id="+db;
            DBName = "Database: "+(string)dbhelper.ExecuteScalar(sc);

            DBhelper tenantHelper = new DBhelper(Convert.ToInt32(db));
            sc = "SELECT * FROM script";
            scriptDataTable = tenantHelper.ExecuteDataTable(sc);


        }
       else if (!String.IsNullOrEmpty(origin) && Common.IsNumberic(origin))
        {
            string sc = "SELECT top 1 name,conn_str from install_db where id=" + origin;
            DataTable dt = dbhelper.ExecuteDataTable(sc);
            DataRow dr = dt.Rows[0];
            DBName = "Install Database: " + dr["name"];

            DBhelper installHelper = new DBhelper(dr["conn_str"].ToString());
            sc = "SELECT * FROM script";
            scriptDataTable = installHelper.ExecuteDataTable(sc);


        }
        else
        {
            string sc = "SELECT * FROM script where del=0";
            scriptDataTable = dbhelper.ExecuteDataTable(sc);
        }
       

    }
    public void UploadScript()
    {
        string scriptName = Request["name"];
        string uploadFileName = Request.Files["scriptFile"].FileName;
        string type = uploadFileName.Substring(uploadFileName.LastIndexOf(".") + 1).ToLower();
        string scriptPath = Server.MapPath("~/script/" + scriptName + ".sql");
        int uploader = (int)Session["user_id"];
        try
        {
            if (type!="sql")
            {
                info="File format is not supported.";
                return;
            }
            
            if (File.Exists(scriptPath))
            {
                info = "The file is existing or having the same name.";
                return;
            }

            Request.Files["scriptFile"].SaveAs(scriptPath);
            info = "Upload file successfully.";
            string sc = @"INSERT INTO script ([name]
           ,[location]
           ,[uploader]       
           ,[description]
           ,[del]) VALUES (@name,@location,@uploader,@description,0)";
            SqlParameter[] sqlParameters =
            {
                new SqlParameter("@name",scriptName),
                 new SqlParameter("@location",scriptPath),
                  new SqlParameter("@uploader",Session["user_id"]),
                   new SqlParameter("@description",Request.Form["description"]),
            };
            dbhelper.ExecuteNonQuery(sc, sqlParameters);
            Common.Refresh();

        }
        catch (Exception e)
        {

            info = e.Message;

        }
    }
    public string  ScriptName(string id)
    {
        string sc = "SELECT name FROM script where id=" + id;
        return (string)dbhelper.ExecuteScalar(sc);
    }
    public string ScriptContent(string id)
    {
        string sc = "SELECT location FROM script where id=" + id;
        string scriptPath = (string)dbhelper.ExecuteScalar(sc);
        string content = "";
        content = File.ReadAllText(scriptPath);
        return content;

    }
    public void DownloadScript()
    {
        string id= Request.QueryString["download"];
        string sc = "SELECT location from script where id=" + id;
        string path = (string)dbhelper.ExecuteScalar(sc);
        FileInfo fi1 = new FileInfo(path);
        //download file from memory
        Response.Clear();
        Response.AddHeader("content-disposition", "attachment; filename=" + fi1.Name);
        Response.TransmitFile(path);
        Response.End();
    }

}