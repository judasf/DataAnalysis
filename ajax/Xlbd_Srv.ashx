<%@ WebHandler Language="C#" Class="Xlbd_Srv" %>

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
/// 线路被盗信息处理
/// </summary>
public class Xlbd_Srv : IHttpHandler, IRequiresSessionState
{
    HttpRequest Request;
    HttpResponse Response;
    HttpSessionState Session;
    HttpServerUtility Server;
    HttpCookie Cookie;


    /// <summary>
    /// 当前登陆用户名
    /// </summary>
    string userName;
    /// <summary>
    ///用户号码
    /// </summary>
    string userNum;
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
    /// 获取线路被盗信息自动编号
    /// </summary>
    public void GetBDxxAutoID()
    {
        string pre = (Session["pre"] != null ? Session["pre"].ToString() : "") + "BD";
        DataSet dr = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, "SELECT " + pre + "xxid  FROM autoid");
        string currentId = dr.Tables[0].Rows[0][0].ToString();
        string datePre = DateTime.Now.ToString("yyyyMM");
        string autoid = "";
        if (currentId.Substring(0, 6) == datePre)
            autoid = pre + currentId;
        else
            autoid = pre + datePre + "001";
        Response.Write("{\"success\":true,\"msg\":\"成功\",\"autoid\":\"" + autoid + "\"}");
    }
    /// <summary>
    /// 保存被盗信息
    /// </summary>
    public void SaveInfo()
    {
        StringBuilder sql = new StringBuilder();
        //获取参数
        //编号
        string id = Convert.ToString(Request.Form["id"]);
        //被盗日期
        string bdrq = Convert.ToString(Request.Form["bdrq"]);
        //被盗地点
        string bddd = Convert.ToString(Request.Form["bddd"]);
        //报公安日期
        string bgarq = Convert.ToString(Request.Form["bgarq"]);
        //报保险公司日期
        string bbxgsrq = Convert.ToString(Request.Form["bbxgsrq"]);
        //保险公司是否出现场
        string bxgscxc = Convert.ToString(Request.Form["bxgscxc"]);
        //损失金额
        string ssje = Convert.ToString(Request.Form["ssje"]);
        //被盗损失
        string bdss = Convert.ToString(Request.Form["bdss"]);
        //现场照片
        string filesStr = Convert.ToString(Request.Form["report"]);
        //3、保存信息
        sql.Append("insert xlbdxx values(@id,@bdrq,@bddd,@deptName");
        sql.Append(",@bgarq,@bbxgsrq,@bxgscxc,@bdss,@ssje,'',0);");
        //保存附件列表
        if (!string.IsNullOrEmpty(filesStr))
        {
            string[] filesPath = filesStr.Split(new String[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            foreach (string path in filesPath)
            {
                string fileName = path.Substring(path.LastIndexOf('/') + 1);
                sql.Append("Insert into Attachment_BDAndQX values(@id,'" + fileName + "','" + path + "',0);");
            }
        }
        //更新编号
        string pre = (Session["pre"] != null ? Session["pre"].ToString() : "") + "BD";
        sql.Append("Update autoid set " + pre + "xxid=" + (int.Parse(id.Substring(pre.Length)) + 1));
        //设定参数
        List<SqlParameter> _paras = new List<SqlParameter>();
        _paras.Add(new SqlParameter("@id", id));
        _paras.Add(new SqlParameter("@bdrq", bdrq));
        _paras.Add(new SqlParameter("@bddd", bddd));
        _paras.Add(new SqlParameter("@deptName", Session["deptname"]));
        _paras.Add(new SqlParameter("@bgarq", bgarq));
        _paras.Add(new SqlParameter("@bbxgsrq", bbxgsrq));
        _paras.Add(new SqlParameter("@bxgscxc", bxgscxc));
        _paras.Add(new SqlParameter("@bdss", bdss));
        _paras.Add(new SqlParameter("@ssje", ssje));
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
                    Response.Write("{\"success\":true,\"msg\":\"被盗信息录入成功!\"}");
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

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}