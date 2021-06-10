<%@ WebHandler Language="C#" Class="ScriptDuallist" %>

using System;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Text;


public class ScriptDuallist : IHttpHandler {

    public void ProcessRequest (HttpContext context) {

        context.Response.ContentType = "text/plain";
        string db_id = context.Request.QueryString["dbid"];
        string install_db_id = context.Request.QueryString["install"];
        if (!string.IsNullOrEmpty(db_id) &&Common.IsNumberic(db_id))
        {
            context.Response.Clear();
            context.Response.Write(GetDuallist(Convert.ToInt32(db_id)));
            context.Response.End();
        }

        if (!string.IsNullOrEmpty(install_db_id) &&Common.IsNumberic(install_db_id))
        {
            context.Response.Clear();
            context.Response.Write(GetInstallDuallist(Convert.ToInt32(install_db_id)));
            context.Response.End();
        }
    }

    public bool IsReusable {
        get {
            return false;
        }
    }
    public string GetDuallist(int db_id)
    {
        DBhelper dbhelper = new DBhelper();
        string sc = "SELECT id,name,location FROM script WHERE del=0";
        DataTable dt = dbhelper.ExecuteDataTable(sc);
        DBhelper tenantHelper= new DBhelper(db_id);
        sc = "SELECT id,name,location FROM script";
        DataTable tenantScriptDt = tenantHelper.ExecuteDataTable(sc);
        StringBuilder sb = new StringBuilder();
        sb.Append("<select id='scriptDuallist' class='duallistbox' name='scripts' multiple='multiple'>");

        foreach (DataRow dr in dt.Rows)
        {
            bool exist = false;
            foreach (DataRow tenantDr in tenantScriptDt.Rows)
            {
                if(tenantDr["location"].ToString()==dr["location"].ToString()&&tenantDr["id"].ToString() == dr["id"].ToString())
                {
                    exist = true;
                }
            }
            if (exist)
            {
                sb.Append(string.Format("<option value='{0}' disabled selected>{1}</option>", dr["id"], dr["name"]));
            }
            else
            {
                sb.Append(string.Format("<option value='{0}'>{1}</option>", dr["id"], dr["name"]));
            }

        }
        sb.Append("</select>");
        return sb.ToString();
    }
    public string GetInstallDuallist(int install_db_id)
    {
        DBhelper dbhelper = new DBhelper();
        string sc = "SELECT id,name,location FROM script WHERE del=0";
        DataTable dt = dbhelper.ExecuteDataTable(sc);
        string install_conn_str = (string)dbhelper.ExecuteScalar("SELECT conn_str FROM install_db where id=" + install_db_id);
        DBhelper tenantHelper= new DBhelper(install_conn_str);
        sc = "SELECT id,name,location FROM script";
        DataTable tenantScriptDt = tenantHelper.ExecuteDataTable(sc);
        StringBuilder sb = new StringBuilder();
        sb.Append("<select id='scriptDuallist' class='duallistbox' name='scripts' multiple='multiple'>");

        foreach (DataRow dr in dt.Rows)
        {
            bool exist = false;
            foreach (DataRow tenantDr in tenantScriptDt.Rows)
            {
                if(tenantDr["location"].ToString()==dr["location"].ToString()&&tenantDr["id"].ToString() == dr["id"].ToString())
                {
                    exist = true;
                }
            }
            if (exist)
            {
                sb.Append(string.Format("<option value='{0}' disabled selected>{1}</option>", dr["id"], dr["name"]));
            }
            else
            {
                sb.Append(string.Format("<option value='{0}'>{1}</option>", dr["id"], dr["name"]));
            }

        }
        sb.Append("</select>");
        return sb.ToString();
    }

}