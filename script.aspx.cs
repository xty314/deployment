using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class script : System.Web.UI.Page
{
    public DBhelper dbhelper = new DBhelper();
    public DataTable dbDataTable = new DataTable();
    public string info = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.Form["cmd"] == "new")
        {
            UploadScript();
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


        }
        catch (Exception e)
        {

            info = e.Message;

        }
    }
}