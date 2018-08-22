<%@ WebHandler Language="C#" Class="Srv_NetWorkCard" %>

using System;
using System.Web;
using System.Web.SessionState;
using System.Reflection;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Generic;
/// <summary>
/// 上网卡
/// </summary>
public class Srv_NetWorkCard : IHttpHandler, IRequiresSessionState
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
    #region 上网卡信息
    /// <summary>
    /// 设置上网卡信息查询条件
    /// </summary>
    /// <returns></returns>
    public string SetQueryConditionForCardInfo()
    {
        string queryStr = "";
        //设置查询条件
        List<string> list = new List<string>();
        //按基层单元
        if (Session["roleid"].ToString() == "12" || Session["roleid"].ToString() == "13" || Session["roleid"].ToString() == "14")
        {
            list.Add(" unitname ='" + Session["deptname"].ToString() + "'");
        }
        else if (!string.IsNullOrEmpty(Request.Form["unitname"]) && Request.Form["unitname"] != "全部")
        {

            list.Add(" unitname ='" + Request.Form["unitname"] + "'");
        }
        //按状态
        if (!string.IsNullOrEmpty(Request.Form["status"]))
        {

            list.Add(" status =" + Request.Form["status"] + "");
        }
        //按IMEI
        if (!string.IsNullOrEmpty(Request.Form["imei"]))
            list.Add(" imei ='" + Request.Form["imei"] + "'");
        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 上网卡信息管理
    /// 获取NetWorkCardInfo表数据page:1 rows:10 sort:id order:asc
    public void GetCardInfo()
    {
        int total = 0;
        string where = SetQueryConditionForCardInfo();
        if (!string.IsNullOrEmpty(Request.Form["where"]))
            where = Server.UrlDecode(Request.Form["where"].ToString());
        string fieldStr = "*";
        string table = "NetWorkCardInfo";
        DataSet ds = SqlHelper.GetPagination(table, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    /// 通过ID获取NetWorkCardInfo信息
    /// </summary>
    public void GetCardInfoByID()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = id;
        string sql = "SELECT * FROM  NetWorkCardInfo  WHERE id=@id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    /// <summary>
    /// 保存CardInfo信息
    /// </summary>
    public void SaveCardInfo()
    {
        string unitname = Convert.ToString(Request.Form["unitname"]);
        string imei = Convert.ToString(Request.Form["imei"]);
        SqlParameter[] paras = new SqlParameter[] { new SqlParameter("@unitname", unitname), new SqlParameter("@imei", imei) };
        string sql = "if not exists( select id from NetWorkCardInfo where imei=@imei)";
        sql += "INSERT INTO NetWorkCardInfo VALUES(@unitname,@imei,0)";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"该IMEI已存在！\"}");
    }
    /// <summary>
    /// 更新NetWorkCardInfo表数据
    /// </summary>
    public void UpdateCardInfo()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        string unitname = Convert.ToString(Request.Form["unitname"]);
        string imei = Convert.ToString(Request.Form["imei"]);
        SqlParameter[] paras = new SqlParameter[] {
            new SqlParameter("@id",SqlDbType.Int),
            new SqlParameter("@unitname", unitname),
            new SqlParameter("@imei",SqlDbType.VarChar)
        };
        paras[0].Value = id;
        paras[1].Value = unitname;
        paras[2].Value = imei;
        string sql = "if not exists(select imei from NetWorkCardInfo where imei=@imei and id<>@id)";
        sql += "UPDATE NetWorkCardInfo set imei=@imei,unitname=@unitname where id=@id;";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"该IMEI已存在！\"}");
    }
    /// <summary>
    /// 通过ID获取删除NetWorkCardInfo信息
    /// </summary>
    public void RemoveCardInfoByID()
    {
        int id = 0;
        int.TryParse(Request.Form["id"], out id);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = id;
        string sql = "DELETE FROM NetWorkCardInfo WHERE id=@id";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    #endregion 上网卡信息 
    #region 上网卡领用
    /// <summary>
    /// 保存上网卡领用信息
    /// </summary>
    public void SaveReciveCardInfo()
    {
        string imei = Convert.ToString(Request.Form["imei"]);
        string usernum = Convert.ToString(Request.Form["usernum"]);
        string receivepeople = Convert.ToString(Request.Form["receivepeople"]);
        string memo = Convert.ToString(Request.Form["memo"]);
        SqlParameter[] paras = new SqlParameter[] {
            new SqlParameter("@imei", imei),
            new SqlParameter("@usernum", usernum),
            new SqlParameter("@receivepeople", receivepeople),
            new SqlParameter("@memo", memo),
            new SqlParameter("@receivedate", DateTime.Now.ToString("yyyy-MM-dd"))
        };
        string sql = "INSERT INTO NetWorkCardLog(IMEI,ReceivePeople,ReceiveDate,UserNum,Memo) VALUES(@imei,@receivepeople,@receivedate,@usernum,@memo);";
        sql += "UPDATE NetWorkCardInfo SET Status=1 where IMEI=@imei;";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 2)
            Response.Write("{\"success\":true,\"msg\":\"上网卡领用成功！\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行失败\"}");
    }
    /// <summary>
    /// 通过IMEI获取使用中的上网卡领用信息
    /// </summary>
    public void GetUsingCardInfoByIMEI()
    {
        string imei = Convert.ToString(Request.Form["imei"]);
        SqlParameter paras = new SqlParameter("@imei", SqlDbType.VarChar);
        paras.Value = imei;
        string sql = "SELECT * FROM  NetWorkCardLog  WHERE imei=@imei and isnull(ReturnPeople,'')=''";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    #endregion 上网卡领用
    #region 上网卡归还
    /// <summary>
    /// 保存上网卡归还信息
    /// </summary>
    public void SaveReturnCardInfo()
    {
        string imei = Convert.ToString(Request.Form["imei"]);
        string returnpeople = Convert.ToString(Request.Form["returnpeople"]);
        string memo = Convert.ToString(Request.Form["memo"]);
        SqlParameter[] paras = new SqlParameter[] {
            new SqlParameter("@imei", imei),
            new SqlParameter("@returnpeople", returnpeople),
            new SqlParameter("@memo", memo),
            new SqlParameter("@returndate", DateTime.Now.ToString("yyyy-MM-dd"))
        };
        string sql = "UPDATE NetWorkCardLog SET returnpeople=@returnpeople,returndate=@returndate,memo=@memo where imei=@imei and isnull(ReturnPeople,'')='';";
        sql += "UPDATE NetWorkCardInfo SET Status=0 where IMEI=@imei;";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 2)
            Response.Write("{\"success\":true,\"msg\":\"上网卡归还成功！\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行失败\"}");
    }
    #endregion 上网卡归还
    #region 上网卡使用明细
    /// <summary>
    /// 设置上网卡使用明细信息查询条件
    /// </summary>
    /// <returns></returns>
    public string SetQueryConditionForCardLog()
    {
        string queryStr = "";
        //设置查询条件
        List<string> list = new List<string>();
        //按基层单元
        if (Session["roleid"].ToString() == "12" || Session["roleid"].ToString() == "13" || Session["roleid"].ToString() == "14")
        {
            list.Add(" unitname ='" + Session["deptname"].ToString() + "'");
        }
        else if (!string.IsNullOrEmpty(Request.Form["unitname"]) && Request.Form["unitname"] != "全部")
        {

            list.Add(" unitname ='" + Request.Form["unitname"] + "'");
        }
        //按领用日期查询
        //提交开始日期
        if (!string.IsNullOrEmpty(Request.Form["sdate"]))
            list.Add(" ReceiveDate >='" + Request.Form["sdate"] + "'");
        //提交截止日期
        if (!string.IsNullOrEmpty(Request.Form["edate"]))
            list.Add(" ReceiveDate <='" + Request.Form["edate"] + "'");
        //按用户号码
        if (!string.IsNullOrEmpty(Request.Form["usernum"]))
        {

            list.Add(" usernum ='" + Request.Form["usernum"] + "'");
        }
        //按状态
        if (!string.IsNullOrEmpty(Request.Form["status"]))
        {

            list.Add(" status =" + Request.Form["status"] + "");
        }
        //按IMEI
        if (!string.IsNullOrEmpty(Request.Form["imei"]))
            list.Add(" a.imei ='" + Request.Form["imei"] + "'");
        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 上网卡使用明细
    /// 获取NetWorkCardLog表数据page:1 rows:10 sort:id order:asc
    public void GetCardUsingLog()
    {
        int total = 0;
        string where = SetQueryConditionForCardLog();
        if (!string.IsNullOrEmpty(Request.Form["where"]))
            where = Server.UrlDecode(Request.Form["where"].ToString());
        string fieldStr = "b.unitname,b.status,a.*";
        string table = "NetWorkCardLog AS a JOIN NetWorkCardInfo AS b ON a.IMEI = b.IMEI";
        DataSet ds = SqlHelper.GetPagination(table, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    /// 导出无线上网卡使用明细
    /// </summary>
    public void ExportCardUsingLog()
    {
        string where = SetQueryConditionForCardLog();
        if (where != "")
            where = " where " + where;
        StringBuilder sql = new StringBuilder();
        sql.Append("SELECT b.unitname,a.IMEI,a.UserNum,a.ReceiveDate,a.ReceivePeople,a.ReturnDate,a.ReturnPeople,a.memo ");
        sql.Append(" FROM NetWorkCardLog AS a JOIN NetWorkCardInfo AS b ON a.IMEI = b.IMEI ");
        sql.Append(where);
        sql.Append(" order by a.id  desc");
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.Columns[0].ColumnName = "基层单元";
        dt.Columns[1].ColumnName = "IMEI";
        dt.Columns[2].ColumnName = "用户号码";
        dt.Columns[3].ColumnName = "领用日期";
        dt.Columns[4].ColumnName = "领用人";
        dt.Columns[5].ColumnName = "归还日期";
        dt.Columns[6].ColumnName = "归还人";
        dt.Columns[7].ColumnName = "备注";
        MyXls.CreateXls(dt, "无线上网卡使用明细.xls", "1");
        Response.Flush();
        Response.End();
    }
    #endregion 上网卡使用明细
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}