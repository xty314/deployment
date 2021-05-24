using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class admin_branch : System.Web.UI.Page
{
    public string info = "";
    public DBhelper hostDb = new DBhelper();
    public DBhelper tenantDb;
    public string companyId;
    public string companyName;
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
            SqlParameter parameter= new SqlParameter("@id", branchId);
            tenantDb.ExecuteNonQuery(sc, parameter);
            Common.Refresh();
        }
    }

    private void EditBranch()
    {
        string branchId = Request.Form["id"];
        string name = Request.Form["name"];
        string address1 = Request.Form["address1"];
        string address2 = Request.Form["address2"];
        string address3 = Request.Form["address3"];
        string sc;
   
            //donot change password
            sc = "UPDATE branch SET name=@name,address1=@address1,address2=@address2,address3=@address3 WHERE id=@id";
            SqlParameter[] sqlParameters =
            { new SqlParameter("@id",branchId),
                 new SqlParameter("@name",name),
                new SqlParameter("@address1",address1),
                new SqlParameter("@address2",address2),
                new SqlParameter("@address3",address3),

            };
            tenantDb.ExecuteNonQuery(sc, sqlParameters);

        Common.Refresh();
    }

    public void CreateNewBranch()
    {
        string address1= Request.Form["address1"];
        string address2 = Request.Form["address2"];
        string address3 = Request.Form["address3"];
        string name = Request.Form["name"];
        //check name if exist
        string sql = "SELECT ISNULL((SELECT top(1) 1 FROM branch WHERE name=@name), 0)";
        SqlParameter sqlParameter = new SqlParameter("@name", name);
        int isExistEmail = (int)tenantDb.ExecuteScalar(sql, sqlParameter);
        if (isExistEmail == 1)
        {
            info = "Branch has already existed.";
            return;
        }
        string sc = "INSERT INTO branch (name,address1,address2,address3,fax) values (@name,@address1,@address2,@address3,'')";
        //Response.Write(password);
        SqlParameter[] sqlParameters =
        {
            new SqlParameter("@name",name),
            new SqlParameter("@address1",address1),
            new SqlParameter("@address2",address2),
            new SqlParameter("@address3",address3),
        };
        tenantDb.ExecuteNonQuery(sc, sqlParameters);
        Common.Refresh();
    }
    public void CheckAndInit()
    {
        companyId = Request.QueryString["id"];
        //invalid id will redirect to company.aspx
        if (String.IsNullOrEmpty(companyId) || !Common.IsNumberic(companyId))
        {
            Response.Redirect("./company.aspx");
        }
        string sc = "select TradingName from hosttenants where id =@companyId";
        SqlParameter cmd = new SqlParameter("@companyId", companyId);
        companyName = (string)hostDb.ExecuteScalar(sc, cmd);
        //invalid id will redirect to company.aspx
        if (string.IsNullOrEmpty(companyName))
        {
            Response.Write("<script>alert('Company is invalid'); location = './company.aspx'</script");
            Response.Write(">");
        }
        else
        {
            tenantDb = new DBhelper(Convert.ToInt32(companyId));
            branchDatatable = GetListOfBranch();
        }
    }
    public DataTable GetListOfBranch()
    {

        string sc = "select * from branch";
        DataTable dt = tenantDb.ExecuteDataTable(sc);
        return dt;
    }
}