using Newtonsoft.Json;
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

public partial class mreport : System.Web.UI.Page
{
    public DBhelper dbhelper = new DBhelper();
    public DataTable mreportDatatable = new DataTable();
    public string info = "";

    private string MreportRootPath = Common.GetSetting("mreport_root_path");
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.Form["cmd"] == "new")
        {
            CreateNewMreport();
        }else if(Request.Form["cmd"] == "delete")
        {
            DeleteMreport();
        }
        else if (Request.Form["cmd"] == "edit")
        {
            EditMreport();
        }
        GetCategoriesOfCompany();
    }

    private void EditMreport()
    {
        string mreportName = Request.Form["name"].ToString().Trim();
        string description = Request.Form["description"].ToString().Trim();
        string id = Request.Form["id"].ToString().Trim();
        string app_id = Request.Form["app"].ToString().Trim();
        DataRow dr = dbhelper.ExecuteDataTable("SELECT top 1 * FROM mreport where id=" + id).Rows[0];
 
        string sc = "UPDATE mreport SET name=@name,description=@description,app_id=@app_id where id=@id";
        SqlParameter[] sqlParameters =
        {
            new SqlParameter("@app_id",app_id),
            new SqlParameter("@name",mreportName ),
            new SqlParameter("@description",description),
            new SqlParameter("@id",id )
         };
        try
        {
            if (dr["app_id"].ToString() != app_id)
            {
                //change the binding app
                string targetPath = Path.GetFullPath(dr["location"].ToString());
                CreateOrEditConfigFile(targetPath, Convert.ToInt32(app_id));
            }
            dbhelper.ExecuteNonQuery(sc, sqlParameters);
         
            Common.Refresh();
        }
        catch (Exception e)
        {
            info = e.Message;
            return;
        }


    }

    public void GetCategoriesOfCompany()
    {
        mreportDatatable = dbhelper.ExecuteDataTable("SELECT m.*,wa.name as 'app' from mreport m left join web_app wa on m.app_id=wa.id");
    
    }
    public void CreateNewMreport()
    {
      
        //step 1
        string mreportName= Request.Form["name"].ToString().Trim();
        mreportName = Regex.Replace(mreportName.ToLower(), @"\s+", "_");
        string description = Request.Form["description"].ToString().Trim();

        string app_id= Request.Form["app"].ToString().Trim();
        string url = String.Format(Common.GetSetting("mreport_url"), mreportName);
        string sourcePath = Path.Combine(MreportRootPath, "admin\\source");
        string targetPath = Path.Combine(MreportRootPath, "m\\" + mreportName); 
        //todo: 判断不添加的条件
        if (System.IO.Directory.Exists(targetPath) ||String.IsNullOrEmpty(mreportName))
        {
            return;
        }
        System.IO.Directory.CreateDirectory(targetPath);
        if (System.IO.Directory.Exists(sourcePath))
        {
            string[] files = System.IO.Directory.GetFiles(sourcePath);
            // Copy the files and overwrite destination files if they already exist.
            foreach (string s in files)
            {
                // Use static Path methods to extract only the file name from the path.
                string fileName = System.IO.Path.GetFileName(s);
                string destFile = System.IO.Path.Combine(targetPath, fileName);
                System.IO.File.Copy(s, destFile, true);
            }
        }
        string sc = "INSERT INTO mreport (name,description,url,location,app_id) values(@name,@description,@url,@location,@app_id)";
        SqlParameter[] sqlParameters =
        {
            new SqlParameter("@app_id",app_id),
            new SqlParameter("@name",mreportName ),
            new SqlParameter("@url",url),
            new SqlParameter("@description",description),
            new SqlParameter("@location",targetPath )
         };
        try
        {
            dbhelper.ExecuteNonQuery(sc, sqlParameters);
            CreateOrEditConfigFile(targetPath, Convert.ToInt32(app_id));
            Common.Refresh();
        }
        catch (Exception e)
        {
            info = e.Message;
            return;
        }


    }
    public void DeleteMreport()
    {

        string id = Request.Form["id"];
        string reportDir = (string)dbhelper.ExecuteScalar("SELECT location FROM mreport where id=" + id);

        string password = Request.Form["password"];
 
        if (password != Common.password)
        {
            info = "Password is not correct!";
            return;
        }
        
        // delete files
      
        if (Directory.Exists(reportDir) && !String.IsNullOrEmpty(reportDir))
        {
            Common.DeleteDir(reportDir);
        }
        //delete record
        string sc = "DELETE FROM mreport WHERE id=@id";
        SqlParameter sqlParameter2 = new SqlParameter("@id", id);
        dbhelper.ExecuteNonQuery(sc, sqlParameter2);
    }

    public void CreateOrEditConfigFile(string path, int app_id)
    {
       
        
        string content = "var config ="+ JsonConvert.SerializeObject(new
        {
            url = string.Format(Common.GetSetting("cloud_mreport_api"),app_id),
            accessLevel = 1,
            enduserLevel = 10,
            loadingpic = "/admin/mreport/assets/images/gpos/loading2.gif"
        });
        string configPath = Path.Combine(path, "config.js").ToString();

        if (File.Exists(configPath))
        {
            File.Delete(configPath);
        }
        using (FileStream fs = File.Open(configPath, FileMode.OpenOrCreate, FileAccess.Write, FileShare.None))
        {

            Byte[] info = new UTF8Encoding(true).GetBytes(content);
            // Add some information to the file.
            fs.Write(info, 0, info.Length);
        }


    }

    public string PrintAppList()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(@"<div class='form-group row'>");
        sb.Append(@"<label class='col-form-label col-sm-4'>App</label>");
        sb.Append("<select class='form-control col-sm-8' name='app'>");

        string sc = "SELECT * FROM web_app order by id desc";
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