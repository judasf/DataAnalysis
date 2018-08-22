<%@ WebHandler Language="C#" Class="DeptInfo" %>

using System;
using System.Web;
using System.Web.SessionState;
using System.Reflection;
using System.Text;
using System.Data;
using System.Data.SqlClient;
/// <summary>
/// 部门操作
/// </summary>
public class DeptInfo : IHttpHandler, IRequiresSessionState
{
    HttpRequest Request;
    HttpResponse Response;
    HttpSessionState Session;
    HttpServerUtility Server;
    HttpCookie Cookie;
    public void ProcessRequest(HttpContext context)
    {
        //不让浏览器缓存
        context.Response.Buffer = true;
        context.Response.ExpiresAbsolute = DateTime.Now.AddDays(-1);
        context.Response.AddHeader("pragma", "no-cache");
        context.Response.AddHeader("cache-control", "");
        context.Response.CacheControl = "no-cache";
        context.Response.ContentType = "text/plain";

        Request = context.Request;
        Response = context.Response;
        Session = context.Session;
        Server = context.Server;
        //验证token,防止CRSF
        string token = "";
        if (string.IsNullOrEmpty(Request.Headers["token"]))
            token = Request.Form["token"];
        else
            token = Request.Headers["token"];

        if (Session["_token"]==null||string.IsNullOrEmpty(token) || token != Session["_token"].ToString())
        {
            Response.Write("{\"success\":false,\"msg\":\"非法登录，请重新登陆后再进行操作！\",\"total\":-1,\"rows\":[]}");
            return;
        }
        //判断登陆状态
        if (Session["uname"] == null || Session["uname"].ToString() == "")
        {
            Response.Write("{\"success\":false,\"msg\":\"登陆超时，请重新登陆后再进行操作！\",\"total\":-1,\"rows\":[]}");
            return;
        }
        string method = HttpContext.Current.Request.PathInfo.Substring(1);
        if (method.Length != 0)
        {
            MethodInfo methodInfo = this.GetType().GetMethod(method);
            if (methodInfo != null)
            {
                methodInfo.Invoke(this, null);
            }
            else
                Response.Write("{\"success\":false,\"msg\":\"Method Not Matched !\"}");
        }
        else
        {
            Response.Write("{\"success\":false,\"msg\":\"Method not Found !\"}");
        }
    }
    /// <summary>
    /// 获取DeptInfo表数据page:1 rows:10 sort:id order:asc
    public void GetDeptInfoInfo()
    {
        int total = 0;
        string where = "";
        if (!string.IsNullOrEmpty(Request.Form["where"]))
            where = Server.UrlDecode(Request.Form["where"].ToString());
        string fieldStr = "*";
        string table = "DeptInfo";
        DataSet ds = SqlHelper.GetPagination(table, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    /// <summary>
    /// 通过deptid获取DeptInfo信息
    /// </summary>
    public void GetDeptInfoByID()
    {
        int deptID = Convert.ToInt32(Request.Form["deptID"]);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = deptID;
        string sql = "SELECT * FROM  DeptInfo WHERE deptid=@id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    /// <summary>
    /// 获取单位前缀
    /// </summary>
    public void GetTablePre()
    {
        int deptID = Convert.ToInt32(Request.Form["deptID"]);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = deptID;
        string sql = "SELECT pre FROM  DeptInfo WHERE id=@id";
        string pre = SqlHelper.ExecuteScalar(SqlHelper.GetConnection(), CommandType.Text, sql, paras).ToString();
        Response.Write("{\"success\":true,\"msg\":\"" + pre + "\"}");
    }
    /// <summary>
    /// 保存DeptInfo信息
    /// </summary>
    public void SaveDeptInfo()
    {
        string deptName = Convert.ToString(Request.Form["deptName"]);
        SqlParameter paras = new SqlParameter("@deptName", SqlDbType.NVarChar);
        paras.Value = deptName;
        string sql = "INSERT INTO DeptInfo VALUES(@deptName)";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    /// <summary>
    /// 通过DeptID更新DeptInfo表数据
    /// </summary>
    public void UpdateDeptInfo()
    {
        int deptID = Convert.ToInt32(Request.Form["deptID"]);
        string deptName = Convert.ToString(Request.Form["deptName"]);
        SqlParameter[] paras = new SqlParameter[] {
         new SqlParameter("@deptID",SqlDbType.Int),
         new SqlParameter("@deptName",SqlDbType.NVarChar)
        };
        paras[0].Value = deptID;
        paras[1].Value = deptName;
        string sql = "UPDATE DeptInfo set deptname=@deptName where deptID=@deptID";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    /// <summary>
    /// 通过deptid获取删除DeptInfo信息
    /// </summary>
    public void RemoveDeptInfoByID()
    {
        int deptID = 0;
        int.TryParse(Request.Form["deptID"], out deptID);

        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = deptID;
        string sql = "DELETE FROM DeptInfo WHERE deptID=@id";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    /// <summary>
    /// 生成DeptInfo表的combobox使用的json字符串
    /// </summary>
    public void GetDeptInfoCombobox()
    {
        string where = "";
        if (Request.Form["q"] != null && Convert.ToString(Request.Form["q"]) != "")
            where += " where deptname like '%" + Convert.ToString(Request.Form["q"]) + "%'";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, "select * from DeptInfo " + where + " order by id");
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0]));
    }

    /// <summary>
    /// 生成部门树json
    /// </summary>
    public void GetDeptTree()
    {
        StringBuilder json = new StringBuilder("[");
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, "select * from DeptInfo order by deptid");
        DataRowCollection rows = ds.Tables[0].Rows;
        if (rows.Count > 0)
        {
            foreach (DataRow row in rows)
            {
                //"{{"和"}}"在格式化字符串中被转义为"{","}"
                //json.AppendFormat("{{\"id\":{0},\"text\":\"{1}\"}},", row[0], row[1]);
                json.AppendFormat("{0}\"id\":{1},\"text\":\"{2}\",\"iconCls\":\"ext-icon-group\"{3},", "{", row[0], row[1], "}");
            }
        }
        json.Remove(json.Length - 1, 1);
        json.Append("]");
        Response.Write(json.ToString());
    }
    /// <summary>
    /// 生成非基层用户部门列表combobox使用的json字符串
    /// </summary>
    public void GetScopeDeptsCombobox()
    {
        string where = "";
        ////获取用户的管辖范围
        //if(Request.IsAuthenticated)
        //{
        //    UserDetail ud = new UserDetail();
        //    string scopeDepts = ud.LoginUser.ScopeDepts;
        //    if(scopeDepts != "0")
        //        where = "where deptid in (" + scopeDepts + ")";
        //}
        string sql = "select * from DeptInfo " + where + " order by deptid";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql);
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0]));
    }
    /// <summary>
    /// 生成非基层用户管辖是部门列表树的json
    /// </summary>
    public void GetDeptTreebyUID()
    {
        string where = "";
        ////获取登陆用户的管辖范围
        //if(Request.IsAuthenticated)
        //{
        //    UserDetail ud = new UserDetail();
        //    string scopeDepts = ud.LoginUser.ScopeDepts;
        //    if(scopeDepts != "0")
        //        where = "where deptid in (" + scopeDepts + ")";
        //}
        StringBuilder json = new StringBuilder("[");
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, "select * from DeptInfo  " + where + " order by deptid");
        DataRowCollection rows = ds.Tables[0].Rows;
        if (rows.Count > 0)
        {
            foreach (DataRow row in rows)
            {
                //"{{"和"}}"在格式化字符串中被转义为"{","}"
                //json.AppendFormat("{{\"id\":{0},\"text\":\"{1}\"}},", row[0], row[1]);
                json.AppendFormat("{0}\"id\":{1},\"text\":\"{2}\",\"iconCls\":\"ext-icon-group\"{3},", "{", row[0], row[1], "}");
            }
        }
        json.Remove(json.Length - 1, 1);
        json.Append("]");
        Response.Write(json.ToString());
    }
    /// <summary>
    /// 导出单位信息
    /// </summary>
    public void ExportDeptInfo()
    {
        string sql = "select deptname from DeptInfo ";

        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql);
        DataTable dt = ds.Tables[0];
        dt.Columns[0].ColumnName = "单位名称";
        MyXls.CreateXls(dt, "单位信息表.xls", "");
        Response.Flush();
        Response.End();
    }
}