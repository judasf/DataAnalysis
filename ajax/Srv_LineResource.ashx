<%@ WebHandler Language="C#" Class="Srv_LineResource" %>

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
/// 线路资源管理
/// </summary>
public class Srv_LineResource : IHttpHandler, IRequiresSessionState
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

        if (Session["_token"] == null || string.IsNullOrEmpty(token) || token != Session["_token"].ToString())
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
    #region 线路延伸管理
    /// <summary>
    /// 设置线路延伸查询条件
    /// </summary>
    /// <returns></returns>
    public string SetQueryConditionForLE()
    {
        string queryStr = "";
        //设置查询条件
        List<string> list = new List<string>();
        //提交开始日期
        if (!string.IsNullOrEmpty(Request.Form["sdate"]))
            list.Add(" CONVERT(VARCHAR(50),inputtime,23) >='" + Request.Form["sdate"] + "'");
        //提交截止日期
        if (!string.IsNullOrEmpty(Request.Form["edate"]))
            list.Add(" CONVERT(VARCHAR(50),inputtime,23) <='" + Request.Form["edate"] + "'");
        //按所属单位
        if (!string.IsNullOrEmpty(Request.Form["deptname"]))
            list.Add(" deptname ='" + Request.Form["deptname"] + "'");
        //按装维经理
        if (!string.IsNullOrEmpty(Request.Form["linkman"]))
            list.Add(" linkman like'%" + Request.Form["linkman"] + "%'");
        //按进度
        if (!string.IsNullOrEmpty(Request.Form["status"]))
            list.Add(" status ='" + Request.Form["status"] + "'");
        //按施工单位
        if (!string.IsNullOrEmpty(Request.Form["constructionunit"]))
            list.Add(" constructionunit ='" + Request.Form["constructionunit"] + "'");
        //管理员和客户支撑中心查看所有，其余只看本部门
        if (roleid != "0" && roleid != "8" && roleid != "3")
        {
            list.Add(" deptname='" + deptname + "' ");
        }
        else if (roleid == "3")
            list.Add(" constructionunit='" + deptname + "' ");
        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 获取线路延伸 数据page:1 rows:10 sort:id order:asc
    /// </summary>
    public void GetLineExtension()
    {
        int total = 0;
        string where = SetQueryConditionForLE();
        string tableName = " LRM_LineExtension ";
        string fieldStr = "*,CONVERT(VARCHAR(50),inputtime,23) as inputdate";
        DataSet ds = SqlHelper.GetPagination(tableName, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    ///  LRM_LineExtension
    /// </summary>
    public void GetLineExtensionByID()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = id;
        string sql = "SELECT * FROM LRM_LineExtension  where ID=@id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    /// <summary>
    /// 核查线路资源
    /// </summary>
    public void CheckLineResourceByID()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        string isNext = Convert.ToString(Request.Form["isNext"]);
        string status = "";
        string checkinfo = Convert.ToString(Request.Form["checkinfo"]);
        string constructionunit = Convert.ToString(Request.Form["constructionunit"]);
        if (isNext == "0")//退回发起单位
        {
            status = "-1";
        }
        else//指派施工单位
        {
            status = "2";
        }
        string sql = "update LRM_LineExtension set status=@status,checkinfo=@checkinfo,constructionunit=@constructionunit,checkuser=@checkuser,checktime=getdate() where id=@id";
        //设定参数
        List<SqlParameter> _paras = new List<SqlParameter>();
        _paras.Add(new SqlParameter("@id", id));
        _paras.Add(new SqlParameter("@status", status));
        _paras.Add(new SqlParameter("@checkinfo", checkinfo));
        _paras.Add(new SqlParameter("@constructionunit", constructionunit));
        _paras.Add(new SqlParameter("@checkuser", Session["uname"].ToString()));

        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, _paras.ToArray());
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"核查成功！\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    /// <summary>
    /// 建设施工
    /// </summary>
    public void FinishLineResourceByID()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        string isNext = Convert.ToString(Request.Form["isNext"]);
        string status = "";
        string constructioninfo = Convert.ToString(Request.Form["constructioninfo"]);
        string reportname = Convert.ToString(Request.Form["reportName"]);
        string reportpath = Convert.ToString(Request.Form["report"]);

        if (isNext == "0")//退回发起单位
        {
            status = "-2";
        }
        else//施工完成，需要上传资料
        {
            status = "3";
            //建设资料
            if (string.IsNullOrEmpty(reportpath))
            {
                Response.Write("{\"success\":false,\"msg\":\"请上传资料！\"}");
                return;
            }
        }
        string sql = "update LRM_LineExtension set status=@status,constructioninfo=@constructioninfo,reportname=@reportname,reportpath=@reportpath,finishuser=@finishuser,finishtime=getdate() where id=@id";
        //设定参数
        List<SqlParameter> _paras = new List<SqlParameter>();
        _paras.Add(new SqlParameter("@id", id));
        _paras.Add(new SqlParameter("@status", status));
        _paras.Add(new SqlParameter("@constructioninfo", constructioninfo));
        _paras.Add(new SqlParameter("@reportname", reportname));
        _paras.Add(new SqlParameter("@reportpath", reportpath));
        _paras.Add(new SqlParameter("@finishuser", Session["uname"].ToString()));

        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, _paras.ToArray());
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"提交成功！\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    /// <summary>
    /// 导出光缆延伸明细
    /// </summary>
    public void ExportLineExtension()
    {
        string where = SetQueryConditionForLE();
        if (where != "")
            where = " where " + where;
        StringBuilder sql = new StringBuilder();
        sql.Append("select id,");
        sql.Append("status= case when status=-2 then '施工退回' when status=-1 then '核查退回' when status=1 then '核查中' ");
        sql.Append(" when status=2 then '施工中'  when status=3 then '已完工' end,");
        sql.Append("inputtime,deptname,account,address,boxno,terminalnumber,linkman,linkphone,username,checkuser,checkinfo,checktime,constructionunit,constructioninfo,reportname,finishtime,memo");
        sql.Append(" from LRM_LineExtension ");
        sql.Append(where);
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.Columns[0].ColumnName = "序号";
        dt.Columns[1].ColumnName = "当前进度";
        dt.Columns[2].ColumnName = "录入时间";
        dt.Columns[3].ColumnName = "发起单位";
        dt.Columns[4].ColumnName = "宽带账号";
        dt.Columns[5].ColumnName = "标准地址";
        dt.Columns[6].ColumnName = "分纤箱号";
        dt.Columns[7].ColumnName = "终端数量";
        dt.Columns[8].ColumnName = "装维经理";
        dt.Columns[9].ColumnName = "联系电话";
        dt.Columns[10].ColumnName = "录入人";
        dt.Columns[11].ColumnName = "核查人";
        dt.Columns[12].ColumnName = "核查信息";
        dt.Columns[13].ColumnName = "核查时间";
        dt.Columns[14].ColumnName = "施工单位";
        dt.Columns[15].ColumnName = "施工信息";
        dt.Columns[16].ColumnName = "施工资料";
        dt.Columns[17].ColumnName = "完工时间";
        dt.Columns[18].ColumnName = "备注";
        ExcelHelper.ExportByWeb(dt, "", "光缆延伸台账.xls", "光缆延伸台账");
    }
    //<summary>
    //新增线路延伸工单
    //</summary>
    public void SaveLineExtensionInfo()
    {
        StringBuilder sql = new StringBuilder();
        string account = Convert.ToString(Request.Form["account"]);
        string address = Convert.ToString(Request.Form["address"]);
        string boxno = Convert.ToString(Request.Form["boxno"]);
        string terminalnumber = Convert.ToString(Request.Form["terminalnumber"]);
        string linkman = Convert.ToString(Request.Form["linkman"]);
        string linkphone = Convert.ToString(Request.Form["linkphone"]);
        string memo = Convert.ToString(Request.Form["memo"]);
        //3、保存信息
        sql.Append("insert LRM_LineExtension(inputtime,deptname,account,address,boxno,terminalnumber,linkman,linkphone,username,memo,status) values(getdate(),@deptname,@account,@address,@boxno,@terminalnumber,@linkman,@linkphone,@username,@memo,1);");

        //设定参数
        List<SqlParameter> _paras = new List<SqlParameter>();
        _paras.Add(new SqlParameter("@deptname", deptname));
        _paras.Add(new SqlParameter("@account", account));
        _paras.Add(new SqlParameter("@address", address));
        _paras.Add(new SqlParameter("@boxno", boxno));
        _paras.Add(new SqlParameter("@terminalnumber", terminalnumber));
        _paras.Add(new SqlParameter("@linkman", linkman));
        _paras.Add(new SqlParameter("@linkphone", linkphone));
        _paras.Add(new SqlParameter("@username", Session["uname"].ToString()));
        _paras.Add(new SqlParameter("@memo", memo));
        //使用事务提交操作
        using (SqlConnection conn = SqlHelper.GetConnection())
        {
            conn.Open();
            using (SqlTransaction trans = conn.BeginTransaction())
            {
                try
                {
                    SqlHelper.ExecuteNonQuery(trans, CommandType.Text, sql.ToString(), _paras.ToArray());
                    trans.Commit();
                    Response.Write("{\"success\":true,\"msg\":\"录入成功!\"}");
                }
                catch
                {
                    trans.Rollback();
                    Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
                    throw;
                }
            }
        }
    }


    #endregion 光缆延伸工单管理
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}