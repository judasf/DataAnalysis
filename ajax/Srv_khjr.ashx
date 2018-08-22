<%@ WebHandler Language="C#" Class="Srv_khjr" %>

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
/// 客户接入服务类
/// </summary>
public class Srv_khjr : IHttpHandler, IRequiresSessionState
{
    HttpRequest Request;
    HttpResponse Response;
    HttpSessionState Session;
    HttpServerUtility Server;
    HttpCookie Cookie;
    /// <summary>
    /// 权限id
    /// </summary>
    string roleid = "";
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
            roleid = Session["roleid"].ToString();
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
    #region 客户接入——库存型号
    /// <summary>
    /// 客户接入——库存型号
    /// 获取khjr_Wlxh表数据page:1 rows:10 sort:id order:asc
    public void GetKhjrWlxh()
    {
        int total = 0;
        string where = "";
        if (!string.IsNullOrEmpty(Request.Form["where"]))
            where = Server.UrlDecode(Request.Form["where"].ToString());
        string fieldStr = "*";
        string table = "KHJR_Wlxh";
        DataSet ds = SqlHelper.GetPagination(table, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    /// 通过ID获取Wlxh信息
    /// </summary>
    public void GetWlxhByID()
    {
        int classID = Convert.ToInt32(Request.Form["id"]);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = classID;
        string sql = "SELECT * FROM  KHJR_Wlxh WHERE id=@id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    /// <summary>
    /// 保存Wlxh信息
    /// </summary>
    public void SaveWlxh()
    {
        string typeName = Convert.ToString(Request.Form["typename"]);
        string units = Convert.ToString(Request.Form["units"]);
        SqlParameter[] paras = new SqlParameter[] { new SqlParameter("@typename", typeName), new SqlParameter("@units", units) };
        string sql = "if not exists( select id from KHJR_Wlxh where typename=@typename)";
        sql += "INSERT INTO KHJR_Wlxh VALUES(@typename,@units)";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"该物料类型已存在！\"}");
    }
    /// <summary>
    /// 通过id更新KHJR_Wlxh表数据
    /// </summary>
    public void UpdateWlxh()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        string typeName = Convert.ToString(Request.Form["typename"]);
        string units = Convert.ToString(Request.Form["units"]);
        SqlParameter[] paras = new SqlParameter[] {
         new SqlParameter("@id",SqlDbType.Int),
         new SqlParameter("@typename",SqlDbType.NVarChar),
         new SqlParameter("@units",SqlDbType.NVarChar)
        };
        paras[0].Value = id;
        paras[1].Value = typeName;
        paras[2].Value = units;
        string sql = "UPDATE KHJR_Wlxh set typename=@typename,units=@units where id=@id";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    /// <summary>
    /// 通过ID获取删除Wlxh信息
    /// </summary>
    public void RemoveWlxhByID()
    {
        int id = 0;
        int.TryParse(Request.Form["id"], out id);

        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = id;
        string sql = "DELETE FROM KHJR_Wlxh WHERE id=@id";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    /// <summary>
    /// 生成库存型号树json
    /// </summary>
    public void GetWlxhTree()
    {
        StringBuilder json = new StringBuilder("[");
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, "select * from KHJR_Wlxh order by id");
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
    /// 生成库存型号列表combobox使用的json字符串
    /// </summary>
    public void GetWlxhCombobox()
    {
        string sql = "select id,typename from KHJR_Wlxh  order by id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql);
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0]));
    }
    /// <summary>
    /// 生成库存型号列表combobox使用的json字符串带全部
    /// </summary>
    public void GetWlxhComboboxAll()
    {
        string sql = "select id,typename from KHJR_Wlxh  order by id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql);
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0], 0));
    }
    /// <summary>
    /// 生成片区领料页面的库存型号列表combobox使用的json字符串，只显示有库存的
    /// </summary>
    public void GetWlxhComboboxForStockOut()
    {
        string sql = "select a.id,typename from KHJR_Wlxh  a  JOIN  KHJR_Stock b ON a.id=b.TypeID AND b.Amount>0 WHERE UnitName='" + Session["deptname"].ToString() + "'";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql);
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0]));
    }
    #endregion 客户接入——库存型号
    #region 客户接入——装维片区
    /// <summary>
    /// 客户接入——装维片区
    /// 获取KHJR_UnitArea表数据page:1 rows:10 sort:id order:asc
    public void GetKhjrUnitArea()
    {
        int total = 0;
        string where = "";
        if (!string.IsNullOrEmpty(Request.Form["where"]))
            where = Server.UrlDecode(Request.Form["where"].ToString());
        if (roleid == "12" || roleid == "13" || roleid == "14")
        {
            where += where == "" ? "" : " and ";
            where += "unitname='" + Session["deptname"] + "'";
        }
        string fieldStr = "*";
        string table = "KHJR_UnitArea";
        DataSet ds = SqlHelper.GetPagination(table, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    /// 通过ID获取KHJR_UnitArea信息
    /// </summary>
    public void GetUnitAreaByID()
    {
        int classID = Convert.ToInt32(Request.Form["id"]);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = classID;
        string sql = "SELECT * FROM  KHJR_UnitArea WHERE id=@id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    /// <summary>
    /// 保存UnitArea信息
    /// </summary>
    public void SaveUnitArea()
    {
        string unitname = Convert.ToString(Request.Form["unitname"]);
        string areaname = Convert.ToString(Request.Form["areaname"]);
        SqlParameter[] paras = new SqlParameter[] { new SqlParameter("@unitname", unitname), new SqlParameter("@areaname", areaname) };
        string sql = "if not exists( select id from KHJR_UnitArea where areaname=@areaname)";
        sql += "INSERT INTO KHJR_UnitArea VALUES(@unitname,@areaname)";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"该装维片区已存在！\"}");
    }
    /// <summary>
    /// 通过id更新KHJR_UnitArea表数据
    /// </summary>
    public void UpdateUnitArea()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        string unitname = Convert.ToString(Request.Form["unitname"]);
        string areaname = Convert.ToString(Request.Form["areaname"]);
        SqlParameter[] paras = new SqlParameter[] {
         new SqlParameter("@id",SqlDbType.Int),
         new SqlParameter("@unitname",SqlDbType.NVarChar),
         new SqlParameter("@areaname",SqlDbType.NVarChar)
        };
        paras[0].Value = id;
        paras[1].Value = unitname;
        paras[2].Value = areaname;
        string sql = "UPDATE KHJR_UnitArea set unitname=@unitname,areaname=@areaname where id=@id";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    /// <summary>
    /// 通过ID获取删除KHJR_UnitArea信息
    /// </summary>
    public void RemoveUnitAreaByID()
    {
        int id = 0;
        int.TryParse(Request.Form["id"], out id);

        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = id;
        string sql = "DELETE FROM KHJR_UnitArea WHERE id=@id";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    /// <summary>
    /// 生成KHJR_UnitArea表的combobox使用的json字符串
    /// </summary>
    public void GetKHJR_UnitAreaCombobox()
    {
        string where = "";
        if (Session["deptname"] != null)
            where = "where  unitname='" + Session["deptname"].ToString() + "'";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, "select id,areaname from KHJR_UnitArea " + where + " order by id");
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0]));
    }
    /// <summary>
    /// 生成KHJR_UnitArea表的combobox使用的json字符串,带“全部”选项
    /// </summary>
    public void GetKHJR_UnitAreaComboboxAll()
    {
        string where = "";
        string unitname = "";
        if (Session["deptname"] != null && (roleid == "12" || roleid == "13" || roleid == "14" || roleid == "17"))
            //where = "where  unitname='" + Session["deptname"].ToString() + "'";
            unitname = Session["deptname"].ToString();
        else
        {
            if (!string.IsNullOrEmpty(Request.QueryString["unitname"]))
                unitname = Server.UrlDecode(Convert.ToString(Request.QueryString["unitname"]));
        }
        if (unitname != "")
            where = "where  unitname='" + unitname + "'";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, "select id,areaname from KHJR_UnitArea " + where + " order by id");
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0], 0));
    }
    #endregion  客户接入——装维片区
    #region 客户接入——基层单元用户管理
    /// <summary>
    /// 客户接入——用户管理
    /// 获取KHJR_UnitUserInfo表数据page:1 rows:10 sort:id order:asc
    public void GetKhjrUnitUserInfo()
    {
        int total = 0;
        string where = "";
        if (!string.IsNullOrEmpty(Request.Form["where"]))
            where = Server.UrlDecode(Request.Form["where"].ToString());
        if (roleid == "12" || roleid == "13" || roleid == "14")
        {
            where += where == "" ? "" : " and ";
            where += "deptname='" + Session["deptname"] + "'";
        }
        string fieldStr = "u.deptname,u.uid,u.uname,ri.rolename,kua.AreaName";
        string table = "KHJR_UnitUserInfo AS kuui JOIN  userinfo AS u ON u.UID = kuui.UID JOIN RoleInfo AS ri ON ri.roleid = u.roleid left JOIN KHJR_UnitArea AS kua ON kua.ID = kuui.AreaID";
        DataSet ds = SqlHelper.GetPagination(table, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    /// 通过ID获取KHJR_UnitUserInfo信息
    /// </summary>
    public void GetUnitUserInfoByID()
    {
        int uid = Convert.ToInt32(Request.Form["uid"]);
        SqlParameter paras = new SqlParameter("@uid", SqlDbType.Int);
        paras.Value = uid;
        string sql = "SELECT u.uid,u.uname,u.roleid,kuui.areaid FROM  KHJR_UnitUserInfo AS kuui JOIN  userinfo AS u ON u.UID = kuui.UID WHERE u.uid=@uid";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    /// <summary>
    /// 保存基层单元用户信息
    /// </summary>
    public void SaveUnitUserInfo()
    {
        string uname = Convert.ToString(Request.Form["uname"]);
        int roleid = 0;
        int.TryParse(Request.Form["roleId"], out roleid);
        int areaid = 0;
        int.TryParse(Request.Form["areaid"], out areaid);
        string deptname = Convert.ToString(Session["deptname"]);
        string tablepre = Convert.ToString(Session["pre"]);
        int newUid = 0;
        List<SqlParameter> paras = new List<SqlParameter>();
        paras.Add(new SqlParameter("@uname", uname));
        paras.Add(new SqlParameter("@deptname", deptname));
        paras.Add(new SqlParameter("@roleId", roleid));
        paras.Add(new SqlParameter("@tablepre", tablepre));
        string sql = "if not exists( select uname from UserInfo where uname=@uname)";
        sql += "INSERT INTO UserInfo VALUES(@uname,'123456',@deptname,@roleid,@tablepre,1);";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras.ToArray());
        if (result != 1)
        {
            Response.Write("{\"success\":false,\"msg\":\"该用户名已存在！\"}");
            return;
        }
        else
        {
            newUid = Convert.ToInt32(SqlHelper.ExecuteScalar(SqlHelper.GetConnection(), CommandType.Text, "SELECT IDENT_CURRENT('UserInfo')"));
            int rst = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, "Insert KHJR_UnitUserInfo values(@uid,@areaid)", new SqlParameter[] { new SqlParameter("@uid", newUid), new SqlParameter("@areaid", areaid) });
            if (rst == 1)
                Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
            else
                Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
        }
    }
    /// <summary>
    /// 通过uid更新KHJR_UnitUserInfo表数据
    /// </summary>
    public void UpdateUnitUserInfo()
    {
        int uid = Convert.ToInt32(Request.Form["uid"]);
        string uname = Convert.ToString(Request.Form["uname"]);
        int roleId = Convert.ToInt32(Request.Form["roleId"]);
        int areaId = Convert.ToInt32(Request.Form["areaId"]);
        SqlParameter[] paras = new SqlParameter[] {
            new SqlParameter("@uid",SqlDbType.Int),
            new SqlParameter("@uname",SqlDbType.VarChar),
            new SqlParameter("@roleid",SqlDbType.Int),
            new SqlParameter("@areaid",SqlDbType.Int)
        };
        paras[0].Value = uid;
        paras[1].Value = uname;
        paras[2].Value = roleId;
        paras[3].Value = areaId;
        string sql = "if not exists(select uname from UserInfo where uname=@uname and uid<>@uid)";
        sql += "begin ";
        sql += "UPDATE KHJR_UnitUserInfo set areaid=@areaid where uid=@uid;";
        sql += "UPDATE UserInfo set uname=@uname,roleid=@roleid where uid=@uid;";
        sql += " end";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 2)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"该用户名已存在！\"}");
    }
    /// <summary>
    /// 通过UID删除KHJR_UnitUserInfo信息
    /// </summary>
    public void RemoveUnitUserInfoByID()
    {
        int uid = 0;
        int.TryParse(Request.Form["uid"], out uid);

        SqlParameter paras = new SqlParameter("@uid", SqlDbType.Int);
        paras.Value = uid;
        string sql = "DELETE FROM KHJR_UnitUserInfo WHERE uid=@uid;Delete from userinfo where uid=@uid";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 2)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    /// <summary>
    /// 通过uid恢复用户密码
    /// </summary>
    public void ResetPwdByID()
    {
        int uid = 0;
        int.TryParse(Request.Form["uid"], out uid);
        string userPwd = "123456";
        SqlParameter[] paras = new SqlParameter[]{
            new SqlParameter("@id", SqlDbType.Int),
            new SqlParameter("@userPwd", SqlDbType.VarChar)
        };
        paras[0].Value = uid;
        paras[1].Value = userPwd;
        string sql = "update UserInfo set passwd=@userPwd WHERE uid=@id";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    #endregion 客户接入——基层单元用户管理

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}