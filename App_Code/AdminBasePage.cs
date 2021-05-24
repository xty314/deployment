using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// AdminBasePage 的摘要说明
/// </summary>
public class AdminBasePage : System.Web.UI.Page
{
 
    protected virtual void Page_Init(object sender, EventArgs e)
    {
        if (Session["login"] == null)
        {
            Response.Redirect("~/index.aspx");
        }
        else

        {
            if (Session["login"].ToString() != "true")
            {
                Response.Redirect("~/index.aspx");
            }
        }

    }
}