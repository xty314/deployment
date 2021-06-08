using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

/// <summary>
/// Summary description for DBhelper
/// </summary>
public class DBhelper
{
    
    private SqlConnection DBhelperConnection;
    
   private SqlConnectionStringBuilder connbuilder = new SqlConnectionStringBuilder();
    private HttpResponse Response= HttpContext.Current.Response;

    public DBhelper()
    {
      
        connbuilder.DataSource = GetSetting("DataSource");
        connbuilder.UserID = GetSetting("DBUser");
        connbuilder.Password = GetSetting("DBpwd");
        connbuilder.InitialCatalog = GetSetting("DBname");
        this.DBhelperConnection = new SqlConnection(connbuilder.ConnectionString);
    }
    public DBhelper(SqlConnection _DBhelperConnection)
    {
        this.DBhelperConnection = _DBhelperConnection;
    }
    
    public DBhelper(string  _connectionString)
    {
        if (_connectionString == "master")
        {
            connbuilder.DataSource = GetSetting("DataSource");
            connbuilder.UserID = GetSetting("DBUser");
            connbuilder.Password = GetSetting("DBpwd");
            connbuilder.InitialCatalog = "master";
            this.DBhelperConnection = new SqlConnection(connbuilder.ConnectionString);
        }
        else
        {
            this.DBhelperConnection = new SqlConnection(_connectionString);
        }
       
    }
    public DBhelper(int id)
    {
        connbuilder.DataSource = GetSetting("DataSource");
        connbuilder.UserID = GetSetting("DBUser");
        connbuilder.Password = GetSetting("DBpwd");
        connbuilder.InitialCatalog = GetSetting("DBname");
        this.DBhelperConnection = new SqlConnection(connbuilder.ConnectionString);
        string sc = "select conn_str from db_list where Id=@id";
        SqlParameter[] sp = { new SqlParameter("@id", id) };
        string sqlString = (string)ExecuteScalar(sc, sp);
        this.DBhelperConnection= new SqlConnection(sqlString);

    }

    

    private string GetSetting(string key)
    {
        string appSettings = System.Web.HttpContext.Current.Server.MapPath("~/") + "/appSettings.json";

        using (System.IO.StreamReader file = System.IO.File.OpenText(appSettings))
        {
            using (JsonTextReader reader = new JsonTextReader(file))
            {
                JObject o = (JObject)JToken.ReadFrom(reader);
                var value = o[key].ToString();
                return value;
            }
        }
    }
    public bool ConnectTest()
    {
        try
        {
            this.DBhelperConnection.Open();

        }
        catch (Exception err)
        {
            return false;
        }
        this.DBhelperConnection.Close();
        return true;

    }
    public SqlCommand GetSqlStringCommond(string sqlQuery)
    {
        SqlCommand sqlCommand = DBhelperConnection.CreateCommand();
        sqlCommand.CommandText = sqlQuery;
        sqlCommand.CommandType = CommandType.Text;
        return sqlCommand;
    }
    public void AddInParameter(SqlCommand cmd, string parameterName, DbType dbType, object value)
    {
        SqlParameter dbParameter = cmd.CreateParameter();
        dbParameter.DbType = dbType;
        dbParameter.ParameterName = parameterName;
        dbParameter.Value = value;
        dbParameter.Direction = ParameterDirection.Input;
        cmd.Parameters.Add(dbParameter);
    }
    public SqlCommand AddInParameter(string sqlQuery, string parameterName, object value)
    {
        SqlCommand sqlCommand = DBhelperConnection.CreateCommand();
        sqlCommand.CommandText = sqlQuery;
        sqlCommand.CommandType = CommandType.Text;
        SqlParameter dbParameter = sqlCommand.CreateParameter();
        dbParameter.ParameterName = parameterName;
        dbParameter.Value = value;
        dbParameter.Direction = ParameterDirection.Input;
        sqlCommand.Parameters.Add(dbParameter);
        return sqlCommand;
    }
    public void AddInParameter(SqlCommand cmd, string parameterName,  object value)
    {
        SqlParameter dbParameter = cmd.CreateParameter();
        dbParameter.ParameterName = parameterName;
        dbParameter.Value = value;
        dbParameter.Direction = ParameterDirection.Input;
        cmd.Parameters.Add(dbParameter);
    }
    public void AddParameterCollection(SqlCommand cmd, params SqlParameter[] pars)
    {
        foreach (SqlParameter par in pars)
        {
            cmd.Parameters.Add(par);
        }
    }




    /// <summary>
    /// 返回DataTable...【Sql语句访问】
    /// </summary>
    /// <param name="cmd">sqlcommand</param>
    /// <returns></returns>
    public DataTable ExecuteDataTable(SqlCommand cmd)
    {
     
        DataTable dt = new DataTable();
        using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
        {
            try
            {

                sda.Fill(dt);
            }
            catch (Exception e)
            {
                ShowExp(cmd.CommandText, e);
            }

            return dt;
        }
        
    }

 public void ExecuteDataSet(string sql,DataSet ds,string tableName)
    {
         using (SqlDataAdapter sda = new SqlDataAdapter(sql, DBhelperConnection))
        {
            try
            {

                sda.Fill(ds,tableName);
            }
            catch (Exception e)
            {
                ShowExp(sql, e);
            }
         
        }
        
    }
    public DataTable ExecuteDataTable(string sql, params SqlParameter[] pars)
    {
        DataTable dt = new DataTable();
        using (SqlDataAdapter sda = new SqlDataAdapter(sql, DBhelperConnection))
        {
            try
            {
                if (pars != null && pars.Length > 0)
                {
                    sda.SelectCommand.Parameters.AddRange(pars);
                }

                sda.Fill(dt);
            }
            catch (Exception e)
            {
                ShowExp(sql, e);
            }

            return dt;
        }
    }

    public DataTable ExecutePageTable(string sql,int pageSize,int currentPage, params SqlParameter[] pars)
    {
        DataTable dt = new DataTable();
        using (SqlDataAdapter sda = new SqlDataAdapter(sql, DBhelperConnection))
        {
            try
            {
                if (pars != null && pars.Length > 0)
                {
                    sda.SelectCommand.Parameters.AddRange(pars);
                }

                sda.Fill( (currentPage - 1) *pageSize, pageSize, dt);
            }
            catch (Exception e)
            {
                ShowExp(sql, e);
            }

            return dt;
        }
    }
    /// <summary>
    /// 查询第一行一列值...【Sql语句访问】
    /// </summary>
    /// <param name="sql">sqk语句</param>
    /// <param name="pars">参数列表。选填！</param>
    /// <returns></returns>
    public object ExecuteScalar(string sql, params SqlParameter[] pars)
    {
        object result = null;
        using (SqlCommand cmd = new SqlCommand(sql, DBhelperConnection))
        {
            try
            {
                if (pars != null && pars.Length > 0)
                {
                    cmd.Parameters.AddRange(pars);
                }
                if (DBhelperConnection.State != ConnectionState.Open)
                {
                    DBhelperConnection.Open();
                }
                result = cmd.ExecuteScalar();
            }
            catch (Exception e)
            {
                ShowExp(sql, e);
            }
            finally
            {
                if (DBhelperConnection.State != ConnectionState.Closed)
                    DBhelperConnection.Close();
            }
            return result;
        }

    }

    public object ExecuteScalar(SqlCommand cmd)
    {
        object result = null;
            try
            {
              
                if (DBhelperConnection.State != ConnectionState.Open)
                {
                    DBhelperConnection.Open();
                }
                result = cmd.ExecuteScalar();
            }
            catch (Exception e)
            {
                ShowExp(cmd.CommandText, e);
            }
            finally
            {
                if (DBhelperConnection.State != ConnectionState.Closed)
                    DBhelperConnection.Close();
            }
            return result;
        

    }
    /// <summary>
    /// 在线查询，返回SqlDataReader，存储过程
    /// </summary>
    /// <param name="procname">存储过程名称</param>s
    /// <param name="pars">参数列表。选填！<</param>
    /// <returns></returns>
    public SqlDataReader ExecuteReaderProc(string procname, params SqlParameter[] pars)
    {
        SqlDataReader sdr = null;
        using (SqlCommand cmd = new SqlCommand(procname, DBhelperConnection))
        {
            try
            {
                cmd.CommandType = CommandType.StoredProcedure;
                if (pars != null && pars.Length > 0)
                {
                    cmd.Parameters.AddRange(pars);
                }
                if (DBhelperConnection.State != ConnectionState.Open)
                {
                    DBhelperConnection.Open();
                }
                sdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
            }
            catch (Exception e)
            {
                ShowExp(procname, e);
            }
            //finally
            //{
            //    if (DBhelperConnection.State != ConnectionState.Closed)
            //        DBhelperConnection.Close();
            //}

            return sdr;

        }
    }
    /// <summary>
    /// 在线查询，返回SqlDataReader
    /// </summary>
    /// <param name="sql"></param>
    /// <param name="pars"></param>
    /// <returns></returns>
    public SqlDataReader ExecuteReader(string sql, params SqlParameter[] pars)
    {

        SqlDataReader sdr = null;
        using (SqlCommand cmd = new SqlCommand(sql, DBhelperConnection))
        {
            try
            {
                if (pars != null && pars.Length > 0)
                {
                    cmd.Parameters.AddRange(pars);
                }
                if (DBhelperConnection.State != ConnectionState.Open)
                {
                    DBhelperConnection.Open();
                }
                sdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

            }
            catch (Exception e)
            {
                ShowExp(sql, e);
            }
            //finally
            //{
            //    if (DBhelperConnection.State != ConnectionState.Closed)
            //        DBhelperConnection.Close();
            //}
            return sdr;
        }
    }
    /// <summary>
    /// 增删改方法
    /// </summary>
    /// <param name="sql"></param>
    public int ExecuteNonQuery(string sql, params SqlParameter[] pars)
    {
        int mark = 0;
        using (SqlCommand cmd = new SqlCommand(sql, DBhelperConnection))
        {
            try
            {
                if (pars != null && pars.Length > 0)
                {
                    cmd.Parameters.AddRange(pars);
                }
                if (DBhelperConnection.State != ConnectionState.Open)
                {
                    DBhelperConnection.Open();
                }
                mark = cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {

                ShowExp(sql, e);
            }
            finally
            {
                if (DBhelperConnection.State != ConnectionState.Closed)
                    DBhelperConnection.Close();
            }
            return mark;
        }



    }
    /// <summary>
    /// 增删改方法
    /// </summary>
    /// <param name="sql"></param>
    public int ExecuteNonQuery(SqlCommand cmd)
    {
        int mark = 0;
        using (cmd)
        {
            try
            {
              
                if (DBhelperConnection.State != ConnectionState.Open)
                {
                    DBhelperConnection.Open();
                }
                mark = cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {

                ShowExp(cmd.CommandText, e);
            }
            finally
            {
                if (DBhelperConnection.State != ConnectionState.Closed)
                    DBhelperConnection.Close();
            }
            return mark;
        }



    }
    /// <summary>
    /// 增删改方法，存储过程
    /// </summary>
    /// <param name="sql"></param>
    /// <param name="pars"></param>
    /// <returns></returns>
    public int ExecuteNonQueryProc(string sql, params SqlParameter[] pars)
    {

        int mark = 0;
        using (SqlCommand cmd = new SqlCommand(sql, DBhelperConnection))
        {

            try
            {
                cmd.CommandTimeout = 60;
                cmd.CommandType = CommandType.StoredProcedure;
                if (pars != null && pars.Length > 0)
                {
                    cmd.Parameters.AddRange(pars);
                }
                if (DBhelperConnection.State != ConnectionState.Open)
                {
                    DBhelperConnection.Open();
                }
                mark = cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                ShowExp(sql, e);
            }
            finally
            {
                if (DBhelperConnection.State != ConnectionState.Closed)
                    DBhelperConnection.Close();
            }
            return mark;



        }

    }
    //执行insert 然后获得最新添加的id
    public int InsertAndGetId(string sql, params SqlParameter[] pars)
    {

        string getIdentity = sql + ";select @IdentityId=@@IDENTITY";
        //int result = 0;
        SqlParameter IdentityPara = new SqlParameter("@IdentityId", SqlDbType.Int);
        IdentityPara.Direction = ParameterDirection.Output;
        using (SqlCommand cmd = new SqlCommand(getIdentity, DBhelperConnection))
        {
            try
            {
                cmd.Parameters.Add(IdentityPara);
                if (pars != null && pars.Length > 0)
                {
                    cmd.Parameters.AddRange(pars);
                }
                if (DBhelperConnection.State != ConnectionState.Open)
                {
                    DBhelperConnection.Open();
                }
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {

                ShowExp(sql, e);
            }
            finally
            {
                if (DBhelperConnection.State != ConnectionState.Closed)
                    DBhelperConnection.Close();
            }
            return (int)cmd.Parameters["@IdentityId"].Value;
        }

    }
    //查询数据库是否存在某个表
    public bool IsExistTable(string tableName)
    {
        string sc = "if objectproperty(object_id(@tableName), 'IsUserTable') = 1 select 1 else select 0";
        SqlParameter[] pars = new SqlParameter[]{
                    new SqlParameter("@tableName",tableName)
                };
        bool result;
        int result_int = (int)ExecuteScalar(sc, pars);

        if (result_int == 1)
        {
            result = true;
        }
        else
        {
            result = false;
        }
        return result;
    }
    //查询数据库某个表中是否存在某个字段
    public bool IsExistColumnInTable(string columnName, string tableName)
    {
        string sc = "if exists(select * from syscolumns where id=object_id(@tableName) and name=@columnName) select 1 else select 0";
        SqlParameter[] pars = new SqlParameter[]{
                    new SqlParameter("@tableName",tableName),
                    new SqlParameter("@columnName",columnName)
                };
        bool result;
        int result_int = (int)ExecuteScalar(sc, pars);

        if (result_int == 1)
        {
            result = true;
        }
        else
        {
            result = false;
        }
        return result;
    }
    public int GetNextId(string tableName)
    {
        string sql = "SELECT IDENT_CURRENT(@tableName) + IDENT_INCR(@tableName)";
        SqlParameter parameter = new SqlParameter("@tableName", tableName);
        int id =Decimal.ToInt32((decimal)ExecuteScalar(sql, parameter));
        return id;
    }
    public void CreadDatabase(string sqlConnection,string dbname)
    {
        SqlConnection conn = new SqlConnection(sqlConnection);
        conn.Open();
        string str = string.Format("CREATE DATABASE {0}" , dbname);
        using (SqlCommand cmd = new SqlCommand(str, conn))
        {
            cmd.ExecuteNonQuery();
        }
        conn.Close();

    }
    private void ShowExp(string query, Exception e)
    {
         throw new Exception("Execute SQL Query Error.\n Query=" + query + "\n" + e.Message);
        if (Response != null)
        {
            Response.Write("Execute SQL Query Error.<br>\r\nQuery = ");
            Response.Write(query);
            Response.Write("<br>\r\n Error: ");
            Response.Write(e);
            Response.Write("<br>\r\n");
        }
        else
        {
            throw new Exception("Execute SQL Query Error.\n Query=" + query + "\n" + e.Message);
        }


    }
    public void SqlBulkCopy(string tableName, DataTable sourceTable)
    {
        try
        {
            if (DBhelperConnection.State != ConnectionState.Open)
            {
                DBhelperConnection.Open();
            }
            using (SqlBulkCopy sqlRevdBulkCopy = new SqlBulkCopy(DBhelperConnection))//引用SqlBulkCopy 
            {
                //SqlBulkCopyOptions.KeepIdentity
                sqlRevdBulkCopy.DestinationTableName = tableName;//数据库中对应的表名 
                sqlRevdBulkCopy.NotifyAfter = sourceTable.Rows.Count;//有几行数据 
                sqlRevdBulkCopy.WriteToServer(sourceTable);//数据导入数据库 
                sqlRevdBulkCopy.Close();//关闭连接 
            }
        }
        catch (Exception ex)
        {
            throw (ex);
        }
        finally
        {
            if (DBhelperConnection.State != ConnectionState.Closed)
                DBhelperConnection.Close();
        }
    }
    public void SqlTransaction(params SqlCommand[] commands)
    {


        SqlTransaction transaction = null;

        try
        {

            if (DBhelperConnection.State != ConnectionState.Open)
            {
                DBhelperConnection.Open();
            }

            transaction = DBhelperConnection.BeginTransaction();
            foreach (SqlCommand command in commands)
            {
                command.Connection = DBhelperConnection;
                command.Transaction = transaction;
                command.ExecuteNonQuery();
            }
            transaction.Commit();

        }
        catch (Exception ex)
        {
            transaction.Rollback();
            throw (ex);

        }




    }
    /// <summary>
    /// check if there is data in the target table.
    /// </summary>
    /// <param name="tableName">name of table</param>
    /// <returns></returns>
    public bool TableHasData(string tableName)
    {
        string sc = "SELECT ISNULL((SELECT TOP(1) 1 FROM @tableName),0)";
        SqlParameter parameter = new SqlParameter("@tableName", tableName);
        int i = (int)ExecuteScalar(sc, parameter);
        if (i == 1)
        {
            return true;
        }
        else
        {
            return false;
        }

    }
    public void RunScript(int dbId, params string[] scriptIds)
    {
        DBhelper dbhelper = new DBhelper();
        List<SqlCommand> commands = new List<SqlCommand>();

        string sc = "select location from script where id in ('" + string.Join("','", scriptIds)+"')";
        DataTable dt = dbhelper.ExecuteDataTable(sc);
        foreach(DataRow dr in dt.Rows)
        {
            string filePath = dr["location"].ToString();
            string content = System.IO.File.ReadAllText(filePath);
            SqlCommand command = new SqlCommand(content);
            commands.Add(command);
        }
        DBhelper tenantDbHelper = new DBhelper(dbId);
        tenantDbHelper.SqlTransaction(commands.ToArray());

    }

}