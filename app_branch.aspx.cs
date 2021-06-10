using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class app_branch : System.Web.UI.Page
{
    public string info = "";
    public DBhelper hostDb = new DBhelper();
    public DBhelper tenantDb;
    public string appId;
    public string appName;
    public DataTable branchDatatable;
    protected void Page_Load(object sender, EventArgs e)
    {
        CheckAndInit();
        if (Request.Form["cmd"] == "addNewBranch")
        {
            CreateNewBranch();
        }

        if (Request.Form["cmd"] == "editBranch")
        {
            EditBranch();
        }
        if (Request.Form["cmd"] == "deleteBranch")
        {
            DeleteBranch();
        }
       GetListOfBranch();

    }
    public void CheckAndInit()
    {
        appId = Request.QueryString["id"];
        //invalid id will redirect to company.aspx
        if (String.IsNullOrEmpty(appId) || !Common.IsNumberic(appId))
        {
            Response.Redirect("./app_list.aspx");
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
    public void GetListOfBranch()
    {

        string sc = "select * from branch";
        branchDatatable = tenantDb.ExecuteDataTable(sc);
     
       
    }
    private void EditBranch()
    {
        string branchId = Request.Form["id"];
        string name = Request.Form["name"].ToString().Trim();
        string address1 = Request.Form["address1"].ToString().Trim();
        string address2 = Request.Form["address2"].ToString().Trim();
        string address3 = Request.Form["address3"].ToString().Trim();
        string auth_code = Request.Form["auth_code"].ToString().Trim();
        string sc;

        //donot change password
        sc = "UPDATE branch SET name=@name,address1=@address1,address2=@address2,address3=@address3,auth_code=@auth_code WHERE id=@id";
        SqlParameter[] sqlParameters =
        { new SqlParameter("@id",branchId),
                 new SqlParameter("@name",name),
                new SqlParameter("@address1",address1),
                new SqlParameter("@address2",address2),
                new SqlParameter("@address3",address3),
                 new SqlParameter("@auth_code",auth_code),

            };
        tenantDb.ExecuteNonQuery(sc, sqlParameters);

        Common.Refresh();
    }
    private void DeleteBranch()
    {
        string branchId = Request.Form["id"];
        if (branchId == "1")
        {
            info = "You can not delete default branch";
            return;
        }
        else
        {
            string sc = "DELETE FROM branch WHERE id=@id";
            SqlParameter parameter = new SqlParameter("@id", branchId);
            tenantDb.ExecuteNonQuery(sc, parameter);
            Common.Refresh();
        }
    }
    public void CreateNewBranch()
    {
        string address1 = Request.Form["address1"].ToString().Trim();
        string address2 = Request.Form["address2"].ToString().Trim();
        string address3 = Request.Form["address3"].ToString().Trim();
        string auth_code = Request.Form["auth_code"].ToString().Trim();
        string name = Request.Form["name"].ToString().Trim();
        //check name if exist
        string sql = "SELECT ISNULL((SELECT top(1) 1 FROM branch WHERE name=@name), 0)";
        SqlParameter sqlParameter = new SqlParameter("@name", name);
        int isExistEmail = (int)tenantDb.ExecuteScalar(sql, sqlParameter);
        if (isExistEmail == 1)
        {
            info = "Branch has already existed.";
            return;
        }
        string sc = "INSERT INTO branch (name,address1,address2,address3,fax,auth_code) values (@name,@address1,@address2,@address3,'',@auth_code)";
        //Response.Write(password);
        SqlParameter[] sqlParameters =
        {
            new SqlParameter("@name",name),
            new SqlParameter("@address1",address1),
            new SqlParameter("@address2",address2),
            new SqlParameter("@address3",address3),
            new SqlParameter("@auth_code",auth_code),
        };
        tenantDb.ExecuteNonQuery(sc, sqlParameters);
        Common.Refresh();
    }
}