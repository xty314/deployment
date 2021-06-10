using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class repository : System.Web.UI.Page
{
    public DBhelper dbhelper = new DBhelper();
    public DataTable repoDataTable = new DataTable();
    public string info = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.Form["cmd"] == "new")
        {
            CreateNewRepo();
        }
        else if (Request.Form["cmd"] == "delete")
        {
            DeleteRepo();
        }
        else if (Request.Form["cmd"] == "edit")
        {
            EditRepo();
        }
        LoadGithubRepository();
    }

    private void DeleteRepo()
    {
       string id = Request.Form["id"].ToString().Trim();
        string password = Request.Form["password"].ToString().Trim();
        if (password == Common.password)
        {
            try
            {
                
                int count = (int)dbhelper.ExecuteScalar("SELECT COUNT(*) FROM web_app WHERE repo_id=" + id);
                if (count > 0)
                {
                    info = "There are some apps using this repository, please delete those apps and try is again";
                    return;
                }
                else
                {
                   string sc = "update git_repository set del=1 where id=@id";
                    SqlParameter par = new SqlParameter("@id", id);
                    dbhelper.ExecuteNonQuery(sc, par);
                    Common.Refresh();
                }
                 

            }catch(Exception e)
            {
                info = e.Message;
                return;
            }
          
           
        }
        else
        {
            info = "invalid password!";
            return;
        }

    }

    private void EditRepo()
    {
        string id = Request.Form["id"].ToString().Trim();
        string name = Request.Form["name"].ToString().Trim();
        string url = Request.Form["url"].ToString().Trim();
        string description = Request.Form["description"].ToString().Trim();
        int isPrivate = String.IsNullOrEmpty(Request.Form["private"]) ? 0 : 1;
        string sc = "UPDATE git_repository set name=@name,url=@url,description=@description,private=@private where id=@id ";

        SqlParameter[] sqlParameters =
        {
             new SqlParameter("@id",id),
                new SqlParameter("@name",name),
                 new SqlParameter("@url",url),
                  new SqlParameter("@description",description),
                  new SqlParameter("@private",isPrivate)
            };
        try
        {
            dbhelper.ExecuteNonQuery(sc, sqlParameters);
            Common.Refresh();
        }
        catch (Exception e)
        {
            info = e.Message;
            return;
        }
      
       
    }
    private void CreateNewRepo()
    {
        string name = Request.Form["name"].ToString().Trim();
        string url = Request.Form["url"].ToString().Trim();
        string description = Request.Form["description"].ToString().Trim();
        int isPrivate= String.IsNullOrEmpty(Request.Form["private"]) ? 0 : 1;
        string sc = "INSERT INTO git_repository (name,url,description,private) VALUES (@name,@url,@description,@private) ";

        SqlParameter[] sqlParameters =
        {
                new SqlParameter("@name",name),
                 new SqlParameter("@url",url),
                  new SqlParameter("@description",description),
                  new SqlParameter("@private",isPrivate)
            };
        try
        {
            dbhelper.ExecuteNonQuery(sc, sqlParameters);
            Common.Refresh();
        }
        catch (Exception e)
        {
            info = e.Message;
            return;
        }
    }

    private void LoadGithubRepository()
    {
        string sc = "select * from  git_repository where del=0";
        repoDataTable = dbhelper.ExecuteDataTable(sc);
        //throw new NotImplementedException();
    }
}