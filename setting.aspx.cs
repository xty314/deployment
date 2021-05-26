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
    protected void Page_Load(object sender, EventArgs e)
    {
        LoadSettingDataTable();

    }

    private void LoadSettingDataTable()
    {
        string sc = "select * from setting";
        settingDataTable = dbhelper.ExecuteDataTable(sc);

    }
}