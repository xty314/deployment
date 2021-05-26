using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
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
        LoadScriptList();
    }

    private void CreateScript()
    {
       string content = Request["content"];

    }

    public void LoadScriptList()
    {
        string db = Request.QueryString["db"];
        string id = Request.QueryString["id"];
        if (!String.IsNullOrEmpty(db)&&Common.IsNumberic(db))
        {
            string sc = "SELECT name from db_list where id="+db;
            DBName = "Database: "+(string)dbhelper.ExecuteScalar(sc);

            DBhelper tenantHelper = new DBhelper(Convert.ToInt32(db));
            sc = "SELECT * FROM script";
            scriptDataTable = tenantHelper.ExecuteDataTable(sc);


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

}