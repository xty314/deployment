using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class app_user : System.Web.UI.Page
{
    public string info = "";
    public DBhelper hostDb = new DBhelper();
    public DBhelper tenantDb;
    public string appId;
    public string appName;
    public DataTable userDatatable;
    protected void Page_Load(object sender, EventArgs e)
    {
        CheckAndInit();
        if (Request.Form["cmd"] == "addNewUser")
        {
            CreateNewUser();
        }
        if (Request.Form["cmd"] == "editUser")
        {
            EditUser();
        }
        if (Request.Form["cmd"] == "deleteUser")
        {
            DeleteUser();
        }
        GetListOfUser();
    }





    public void EditUser()
    {
        string userId = Request.Form["id"];
        string name = Request.Form["name"];
        string email = Request.Form["email"];
        string newPassword = Common.MD5Encrypt(Request.Form["password"]).ToUpper();
        string sc;
        if (Request.Form["changePassword"] != null)
        {
            //change password
            sc = "UPDATE card set name=@name,email=@email,password=@password WHERE id=@id";
            SqlParameter[] sqlParameters =
       {
            new SqlParameter("@name",name),
             new SqlParameter("@email",email),
               new SqlParameter("@id",userId),
              new SqlParameter("@password",newPassword),
        };
            tenantDb.ExecuteNonQuery(sc, sqlParameters);
        }
        else
        {
            //donot change password
            sc = "UPDATE card set name=@name,email=@email WHERE id=@id";
            SqlParameter[] sqlParameters =
            {
                new SqlParameter("@name",name),
                 new SqlParameter("@email",email),
                   new SqlParameter("@id",userId),

            };
            tenantDb.ExecuteNonQuery(sc, sqlParameters);
        }

        Common.Refresh();
    }
    public void DeleteUser()
    {
        string userId = Request.Form["id"];
        string sc = "SELECT email FROM card  WHERE id=@id";
        SqlParameter parameter = new SqlParameter("@id", userId);
        string email = (string)tenantDb.ExecuteScalar(sc, parameter);
        if (email == "support@eznz.com")
        {
            info = "You can not delete support email";
            return;
        }
        else
        {
            sc = "DELETE FROM card WHERE id=@id";
            SqlParameter parameter2 = new SqlParameter("@id", userId);
            tenantDb.ExecuteNonQuery(sc, parameter2);
            Common.Refresh();
        }



    }
    public void CreateNewUser()
    {
        string rawPassword = Request.Form["password"];
        string name = Request.Form["name"];
        string email = Request.Form["email"];
        string password = Common.MD5Encrypt(rawPassword).ToUpper();
        //check email if exist
        string sql = "SELECT ISNULL((SELECT top(1) 1 FROM card WHERE email=@email), 0)";
        SqlParameter sqlParameter = new SqlParameter("@email", email);
        int isExistEmail = (int)tenantDb.ExecuteScalar(sql, sqlParameter);
        if (isExistEmail == 1)
        {
            info = "Email has already existed.";
            return;
        }
        string sc = "INSERT INTO card (name,email,password) values (@name,@email,@password)";
        //Response.Write(password);
        SqlParameter[] sqlParameters =
        {
            new SqlParameter("@name",name),
             new SqlParameter("@email",email),
              new SqlParameter("@password",password),
        };
        tenantDb.ExecuteNonQuery(sc, sqlParameters);
        Common.Refresh();
    }
    public void CheckAndInit()
    {
        appId = Request.QueryString["id"];
        //invalid id will redirect to company.aspx
        if (String.IsNullOrEmpty(appId) || !Common.IsNumberic(appId))
        {
            Response.Redirect("./company.aspx");
        }
        string sc = @"SELECT top 1 wa.name as app_name,wa.db_id FROM web_app wa
                LEFT JOIN db_list db ON wa.db_id=db.id 
                WHERE wa.id =@appId";
        SqlParameter cmd = new SqlParameter("@appId", appId);
        DataRow dr = hostDb.ExecuteDataTable(sc, cmd).Rows[0];
        appName = dr["app_name"].ToString();
        string dbId = dr["db_id"].ToString();
        //invalid id will redirect to company.aspx
        if (string.IsNullOrEmpty(appName))
        {
            Response.Write("<script>alert('Company is invalid'); location = './app_list.aspx'</script");
            Response.Write(">");
        }
        else
        {
            tenantDb = new DBhelper(Convert.ToInt32(dbId));
           
        }
    }
    public void GetListOfUser()
    {

        string sc = "select e.name as type_name,* from card c left join enum e on c.type=e.id and e.class='card_type'";
        userDatatable = tenantDb.ExecuteDataTable(sc);
       
    }
}