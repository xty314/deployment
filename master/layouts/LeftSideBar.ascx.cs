using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Master_Page_LeftSidebar : System.Web.UI.UserControl
{
    protected DataTable menuTable;
    protected string sc;
    public DBhelper dbhelper = new DBhelper();
    public Common common;
    protected void Page_Load(object sender, EventArgs e)
    {

      
    }
    
}