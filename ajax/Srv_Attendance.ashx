<%@ WebHandler Language="C#" Class="Srv_Attendance" %>

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
/// 员工考勤管理
/// </summary>
public class Srv_Attendance : IHttpHandler, IRequiresSessionState
{
    HttpRequest Request;
    HttpResponse Response;
    HttpSessionState Session;
    HttpServerUtility Server;
    HttpCookie Cookie;


    /// <summary>
    /// 所在部门
    /// </summary>
    string deptname;
    /// <summary>
    /// 岗位
    /// </summary>
    string roleid;

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
        else
        {
            deptname = Session["deptname"].ToString();
            roleid = Session["roleid"].ToString();
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
    #region 考勤结果管理
    /// <summary>
    /// 设置查询条件
    /// </summary>
    /// <returns></returns>
    public string SetQueryCondition()
    {
        string queryStr = "";
        //设置查询条件
        List<string> list = new List<string>();
        //提交开始日期
        if (!string.IsNullOrEmpty(Request.Form["sdate"]))
            list.Add(" workdate >='" + Request.Form["sdate"] + "'");
        //提交截止日期
        if (!string.IsNullOrEmpty(Request.Form["edate"]))
            list.Add(" workdate <='" + Request.Form["edate"] + "'");
        //按所属班组
        if (!string.IsNullOrEmpty(Request.Form["teamname"]))
            list.Add(" teamname ='" + Request.Form["teamname"] + "'");
        //按姓名
        if (!string.IsNullOrEmpty(Request.Form["empname"]))
            list.Add(" empname like'%" + Request.Form["empname"] + "%'");

        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 获取考勤结果 数据page:1 rows:10 sort:id order:asc
    /// </summary>
    public void GetAttendanceResult()
    {
        int total = 0;
        string where = SetQueryCondition();
        string tableName = " Attendance_Result ";
        string fieldStr = "*,datename(weekday,workdate) as week";
        DataSet ds = SqlHelper.GetPagination(tableName, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    /// 获取签到明细 数据page:1 rows:10 sort:id order:asc
    /// </summary>
    public void GetAttendanceDetail()
    {
        int total = 0;
        string where = SetQueryCondition();
        string tableName = " Attendance_Detail ";
        string fieldStr = "*";
        DataSet ds = SqlHelper.GetPagination(tableName, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    /// 导入签到明细
    /// </summary>
    public void ImportAttendanceDetail()
    {
        string reportPath = "";
        if (!string.IsNullOrEmpty(Request.Form["report"]))
            reportPath = Server.MapPath("~") + Request.Form["report"].ToString();
        int checkFile = MyXls.ChkSheet(reportPath, "打卡签到记录");
        if (checkFile == -1)
        {
            Response.Write("{\"success\":false,\"msg\":\"上传文件不存在，请检查！\"}");
            return;
        }
        if (checkFile == 0)
        {
            Response.Write("{\"success\":false,\"msg\":\"请检查excel文件中单元表的名字是否正确！\"}");
            return;
        }
        //验证要导入的列在单元表中是否存在
        List<string> columnsName = new List<string>();
        columnsName.Add("姓名");
        List<int> columnsExists = MyXls.ChkSheetColumns(reportPath, "打卡签到记录", columnsName);
        if (columnsExists.Contains(0))
        {
            Response.Write("{\"success\":false,\"msg\":\"请检查excel文件内容格式是否正确！\"}");
            return;
        }
        SqlParameter[] paras = new SqlParameter[]{
            new SqlParameter("@filePath",SqlDbType.NVarChar),
            new SqlParameter("@sheetName",SqlDbType.NVarChar),
            new SqlParameter("@return",SqlDbType.Int)
        };
        paras[0].Value = reportPath;
        paras[1].Value = "打卡签到记录";
        paras[2].Direction = ParameterDirection.ReturnValue;
        SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.StoredProcedure, "HandleAttendanceInfo_x86", paras);
        //SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.StoredProcedure, "HandleAttendanceInfo_x64", paras);
        int returnVal = (int)paras[2].Value;
        if (returnVal == -1)
            Response.Write("{\"success\":false,\"msg\":\"该月数据已导入！\"}");
        if (returnVal == 0)
            Response.Write("{\"success\":true,\"msg\":\"数据导入成功！\"}");
    }
    /// <summary>
    /// 导出考核结果
    /// </summary>
    public void ExportAttendanceResult()
    {
        string where = SetQueryCondition();
        if (where != "")
            where = " where " + where;
        StringBuilder sql = new StringBuilder();
        sql.Append("select TeamName,EmpName,workdate,datename(weekday,workdate) as week,SignPoint,GPS,SignTime,SignStatus");
        sql.Append(" from Attendance_Result ");
        sql.Append(where);
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.Columns[0].ColumnName = "班组";
        dt.Columns[1].ColumnName = "姓名";
        dt.Columns[2].ColumnName = "日期";
        dt.Columns[3].ColumnName = "星期";
        dt.Columns[4].ColumnName = "签到点";
        dt.Columns[5].ColumnName = "GPS地址";
        dt.Columns[6].ColumnName = "签到时间";
        dt.Columns[7].ColumnName = "考核结果";
        ExcelHelper.ExportByWeb(dt, "", "员工签到考核明细.xls", "员工签到考核明细");
    }
    #endregion
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}