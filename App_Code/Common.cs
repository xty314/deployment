using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;

/// <summary>
/// Common 的摘要说明
/// </summary>
public class Common
{

    public static List<string> supportedFileTypes = new List<string>(new string[] { "jpg", "jpeg", "gif", "png", "bmp" });
    public static string[] GetCategories(string company)
    {
        string fullpath = HttpContext.Current.Server.MapPath("../"+company+"/config.txt");
        string content = "";
        if (File.Exists(fullpath))
        {
            content = System.IO.File.ReadAllText(fullpath);
        }
        else
        {
            System.IO.FileStream fs = System.IO.File.Create(fullpath);
            fs.Close();
            using (System.IO.StreamWriter sw = System.IO.File.AppendText(fullpath))
            {
                sw.WriteLine("default");
            }
        }
       
        string[] stringSeparators = new string[] { "\r\n" };
        string[] cat = content.Split(stringSeparators, StringSplitOptions.RemoveEmptyEntries);
        //for(int i = 0; i < cat.Length; i++)
        //{
        //    cat[i] = cat[i].Replace("\\r", "");
        //}
        return cat;

    }
    public static string GetSetting(string name)
    {
        //string appSettings = System.Web.HttpContext.Current.Server.MapPath("~/") + "/appSettings.json";

        //using (System.IO.StreamReader file = System.IO.File.OpenText(appSettings))
        //{
        //    using (JsonTextReader reader = new JsonTextReader(file))
        //    {
        //        JObject o = (JObject)JToken.ReadFrom(reader);
        //        var value = o[key].ToString();
        //        return value;
        //    }
        //}
        DBhelper dbhelper = new DBhelper();
        string sc = "SELECT value from setting where name=@name";
        SqlParameter par = new SqlParameter("@name", name);
        return (string)dbhelper.ExecuteScalar(sc, par);
    }
    public static string[] GetAllCategories()
    {
        string catrgoryPath = HttpContext.Current.Server.MapPath("./category");
  
        string[] categoryDirs = Directory.GetDirectories(catrgoryPath);
        return categoryDirs;
    }
    public static void DeleteDir(string srcPath)
    {
        try
        {
            DirectoryInfo dir = new DirectoryInfo(srcPath);
            //FileSystemInfo[] fileinfo = dir.GetFileSystemInfos();  //返回目录中所有文件和子目录
            dir.Delete(true);
  
            
        }
        catch (Exception e)
        {
            throw;
        }
    }
    public static void Refresh()
    {
        HttpContext.Current.Response.Write("<script language=javascript>window.location.href=window.location.href;</script>");
    }
    public static string GetLastDir(string dirs)
    {
        string dirName = dirs.Substring(dirs.LastIndexOf("\\")+1);
        return dirName;
    }
    public static string GetImgSecond(string fileName)
    {

        string filename = fileName.Substring(0, fileName.LastIndexOf("."));

        string time = "10";
        // string result="";
        if (filename.LastIndexOf("_") != -1)
        {
            string suffix = filename.Substring(filename.LastIndexOf("_") + 1);

            if (Regex.IsMatch(suffix, @"^[+-]?\d*$"))
            {
                if (Convert.ToInt32(suffix) < 60)
                {
                    time = suffix;
                }
               
            }
        }
        return time;
    }
    public static string RandomName(int digits)
    {
        string _zimu = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopgrstuvwxyz1234567890";//要随机的字母
        Random _rand = new Random(Guid.NewGuid().GetHashCode()); //随机类
        string _result = "";
        for (int i = 0; i < digits; i++) //循环6次，生成6位数字，10位就循环10次
        {
            _result += _zimu[_rand.Next(62)]; //通过索引下标随机

        }
        return _result;
    }
    public static bool IsNumberic(string oText)
    {
        try
        {
            int var1 = Convert.ToInt32(oText);
            return true;
        }
        catch
        {
            return false;
        }
    }

    public static string MD5Encrypt(string str)
    {
        if (String.IsNullOrEmpty(str))
        {
            return "";
        }
        else
        {
            MD5 md5 = MD5.Create();
            // 将字符串转换成字节数组
            byte[] byteOld = Encoding.UTF8.GetBytes(str);
            // 调用加密方法
            byte[] byteNew = md5.ComputeHash(byteOld);
            // 将加密结果转换为字符串
            StringBuilder sb = new StringBuilder();
            foreach (byte b in byteNew)
            {
                // 将字节转换成16进制表示的字符串，
                sb.Append(b.ToString("x2"));
            }
            // 返回加密的字符串
            return sb.ToString();

        }
       
    }
    public static string GetDatabase(string connectionString)
    {
        SqlConnection conn = new SqlConnection(connectionString);
        return conn.Database;
    }
    public static string GetServer(string connectionString)
    {
        SqlConnection conn = new SqlConnection(connectionString);
        return conn.DataSource;
    }

}



