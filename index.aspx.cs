using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class v2_login : Page
{
    public string m_msg;
    public DBhelper dbhelper = new DBhelper();
    public void Page_Load(object sender, EventArgs e)
	{

        if (Request.Form["cmd"] == "login")
        {

            string rawPass = Request.Form["pass"];
            string md5Pass = Common.MD5Encrypt(rawPass);
            string email = Request.Form["email"];
            string sql = "SELECT ISNULL((SELECT top(1) 1 FROM card WHERE email=@email), 0)";
            SqlParameter sqlParameter1 = new SqlParameter("@email", email);
            int isExistEmail = (int)dbhelper.ExecuteScalar(sql, sqlParameter1);
            if (isExistEmail == 0)
            {
                m_msg = "Email does not exist";
                //Response.StatusCode = 404;
                return;
            }
            sql = "SELECT ISNULL((SELECT top(1) id FROM card WHERE email=@email and password=@password), 0)";
            SqlParameter[] sqlParameter2 = {
            new SqlParameter("@email", email),
            new SqlParameter("@password",md5Pass.ToUpper())
        };
            int userId = (int)dbhelper.ExecuteScalar(sql, sqlParameter2);

            if (userId == 0)
            {
                m_msg = "Password is not correct";
            
                //Response.StatusCode = 404;
                //Response.Redirect("index.aspx");
                return;
            }
            else
            {

                Session["login"] = "true";
                Session["user_id"] = userId;
                Response.Redirect("app_list.aspx");
            }
        }

     



  

    }


}