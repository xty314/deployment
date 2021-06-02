using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class setting : AdminBasePage
{
    public DataTable settingDataTable;
    DBhelper dbhelper = new DBhelper();
    public string info = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["cmd"] == "save")
        {
            SaveSetting();
        }
        LoadSettingDataTable();

    }

    private void SaveSetting()
    {
        string sc = " BEGIN TRANSACTION ";
        foreach (string key in Request.Form.Keys)
        {
            //Response.Write(key+":"+Request.Form[key]+"<br>");
            string value = Request.Form[key];
            sc += " UPDATE setting SET value=N'" +Request.Form[key]+"' where name=N'"+key+"'" ;
          
        }
        sc += " COMMIT ";
        dbhelper.ExecuteNonQuery(sc);
        info = "Save successfully.";
    }

    private void LoadSettingDataTable()
    {
        string sc = "select * from setting";
        settingDataTable = dbhelper.ExecuteDataTable(sc);

    }
}