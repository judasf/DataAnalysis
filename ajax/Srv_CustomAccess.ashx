<%@ WebHandler Language="C#" Class="Srv_CustomAccess" %>

using System;
using System.Web;
using System.Web.SessionState;
using System.Reflection;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Generic;
using System.Web.Security;
/// <summary>
/// 客户接入服务类
/// </summary>
public class Srv_CustomAccess : IHttpHandler, IRequiresSessionState
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
    /// 获取CustomAccess_Wlxh表数据page:1 rows:10 sort:id order:asc
    public void GetCustomAccessWlxh()
    {
        int total = 0;
        string where = "";
        if (!string.IsNullOrEmpty(Request.Form["where"]))
            where = Server.UrlDecode(Request.Form["where"].ToString());
        string fieldStr = "*";
        string table = "CustomAccess_Wlxh";
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
        string sql = "SELECT * FROM  CustomAccess_Wlxh WHERE id=@id";
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
        string sql = "if not exists( select id from CustomAccess_Wlxh where typename=@typename)";
        sql += "INSERT INTO CustomAccess_Wlxh VALUES(@typename,@units)";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"该物料类型已存在！\"}");
    }
    /// <summary>
    /// 通过id更新CustomAccess_Wlxh表数据
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
        string sql = "UPDATE CustomAccess_Wlxh set typename=@typename,units=@units where id=@id";
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
        string sql = "DELETE FROM CustomAccess_Wlxh WHERE id=@id";
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
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, "select * from CustomAccess_Wlxh order by id");
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
        string sql = "select id,typename from CustomAccess_Wlxh  order by id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql);
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0]));
    }
    /// <summary>
    /// 生成库存型号列表combobox使用的json字符串带全部
    /// </summary>
    public void GetWlxhComboboxAll()
    {
        string sql = "select id,typename from CustomAccess_Wlxh  order by id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql);
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0], 0));
    }
    /// <summary>
    /// 生成领料页面的库存型号列表combobox使用的json字符串，只显示有库存的
    /// </summary>
    public void GetWlxhComboboxForStockOut()
    {
        string sql = "select a.id,typename from CustomAccess_Wlxh  a  JOIN  CustomAccess_Stock b ON a.id=b.TypeID AND b.Amount>0 WHERE UnitName='" + Session["deptname"].ToString() + "'";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql);
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0]));
    }
    /// <summary>
    ///  根据不同的营业部生成领料页面的库存型号列表combobox使用的json字符串，只显示有库存的
    /// </summary>
    public void GetWlxhComboboxForStockOutByAreaID()
    {
        string where = "";
        string areaid = "";
        if (Session["areaid"] != null && roleid == "32")
            areaid = Session["areaid"].ToString();
        else
        {
            if (!string.IsNullOrEmpty(Request.QueryString["areaid"]))
                areaid = Server.UrlDecode(Convert.ToString(Request.QueryString["areaid"]));
        }
        if (areaid != "")
            where = "where  areaid=" + areaid;
        string sql = "select DISTINCT a.id,a.typename from CustomAccess_Wlxh  a  JOIN  CustomAccess_Stock b ON a.id=b.TypeID AND b.Amount>0 " + where + " order by a.id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql);
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0]));
    }

    /// <summary>
    ///  根据不同的营业部,型号生成领料页面的出库单号的ombogrid使用的json字符串，只显示有库存的
    /// </summary>
    public void GetOrderCombogridForStockOut()
    {
        string areaid = Convert.ToString(Request.Form["areaid"]);
        string typeid = Convert.ToString(Request.Form["typeid"]);
        string where = " areaid=" + areaid + " and typeid=" + typeid;

        int total = 0;
        string table = "CustomAccess_Wlxh  a  JOIN  CustomAccess_Stock b ON a.id=b.TypeID AND b.Amount>0";
        string fieldStr = "typeid,b.Storeorderno,b.Amount,a.units";

        DataSet ds = SqlHelper.GetPagination(table, fieldStr, Request["sort"].ToString(), Request["order"].ToString(), where, Convert.ToInt32(Request["rows"]), Convert.ToInt32(Request["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    #endregion 客户接入——库存型号
    #region 客户接入——营业部/乡镇支局
    /// <summary>
    /// 客户接入——营业部/乡镇支局
    /// 获取CustomAccess_UnitArea表数据page:1 rows:10 sort:id order:asc
    public void GetCustomAccessUnitArea()
    {
        int total = 0;
        string where = "";
        if (!string.IsNullOrEmpty(Request.Form["unitname"]))
            where = "unitname='" + Server.UrlDecode(Request.Form["unitname"].ToString() + "'");
        if (roleid == "30" || roleid == "31" || roleid == "32")
            where = "unitname='" + Session["deptname"] + "'";
        string fieldStr = "*";
        string table = "CustomAccess_UnitArea";
        DataSet ds = SqlHelper.GetPagination(table, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    /// 通过ID获取CustomAccess_UnitArea信息
    /// </summary>
    public void GetUnitAreaByID()
    {
        int classID = Convert.ToInt32(Request.Form["id"]);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = classID;
        string sql = "SELECT * FROM  CustomAccess_UnitArea WHERE id=@id";
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
        string sql = "if not exists( select id from CustomAccess_UnitArea where areaname=@areaname)";
        sql += "INSERT INTO CustomAccess_UnitArea VALUES(@unitname,@areaname)";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"该营业部/乡镇支局已存在！\"}");
    }
    /// <summary>
    /// 通过id更新CustomAccess_UnitArea表数据
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
        string sql = "UPDATE CustomAccess_UnitArea set unitname=@unitname,areaname=@areaname where id=@id";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    /// <summary>
    /// 通过ID获取删除CustomAccess_UnitArea信息
    /// </summary>
    public void RemoveUnitAreaByID()
    {
        int id = 0;
        int.TryParse(Request.Form["id"], out id);

        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = id;
        string sql = "DELETE FROM CustomAccess_UnitArea WHERE id=@id";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    /// <summary>
    /// 生成CustomAccess_UnitArea表的combobox使用的json字符串
    /// </summary>
    public void GetCustomAccess_UnitAreaCombobox()
    {
        string where = "";
        if (Session["deptname"] != null && roleid != "0")
            where = "where  unitname='" + Session["deptname"].ToString() + "'";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, "select id,areaname from CustomAccess_UnitArea " + where + " order by id");
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0]));
    }
    /// <summary>
    /// 生成CustomAccess_UnitArea表的combobox使用的json字符串,带“全部”选项
    /// </summary>
    public void GetCustomAccess_UnitAreaComboboxAll()
    {
        string queryStr = "";
        string where = "";
        //设置查询条件
        List<string> list = new List<string>();
        if (Session["deptname"] != null && (roleid == "30" || roleid == "31" || roleid == "32"))
            list.Add(" unitname ='" + Session["deptname"].ToString() + "'");
        else
        {
            if (!string.IsNullOrEmpty(Request.QueryString["unitname"]))
                list.Add(" unitname ='" + Server.UrlDecode(Convert.ToString(Request.QueryString["unitname"])) + "'");
        }
        if (roleid == "32")
            list.Add(" id ='" + Session["areaid"].ToString() + "'");
        if (list.Count > 0)
        {
            queryStr = string.Join(" and ", list.ToArray());
            where = "where " + queryStr;
        }
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, "select id,areaname from CustomAccess_UnitArea " + where + " order by id");
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0], 0));
    }
    #endregion  客户接入——营业部/乡镇支局
    #region 客户接入——用户管理
    /// <summary>
    /// 设置用户管理查询条件
    /// </summary>
    /// <returns></returns>
    public string SetQueryConditionForUnitUser()
    {
        string queryStr = "";
        //设置查询条件
        List<string> list = new List<string>();
        //按单位
        if (Session["roleid"].ToString() == "30" || Session["roleid"].ToString() == "31" || Session["roleid"].ToString() == "32")
        {
            list.Add(" u.deptname ='" + Session["deptname"].ToString() + "'");
        }
        else if (!string.IsNullOrEmpty(Request.Form["unitname"]) && Request.Form["unitname"] != "全部")
        {

            list.Add(" u.deptname ='" + Request.Form["unitname"] + "'");
        }
        //按营业部
        if (!string.IsNullOrEmpty(Request.Form["areaid"]))
            list.Add(" areaid =" + Request.Form["areaid"]);
        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 客户接入——用户管理
    /// 获取CustomAccess_UnitUserInfo表数据page:1 rows:10 sort:id order:asc
    public void GetCustomAccessUnitUserInfo()
    {
        int total = 0;
        string where = SetQueryConditionForUnitUser();
        string fieldStr = "u.deptname,u.uid,u.uname,ri.rolename,kua.AreaName";
        string table = "CustomAccess_UnitUserInfo AS kuui JOIN  userinfo AS u ON u.UID = kuui.UID JOIN RoleInfo AS ri ON ri.roleid = u.roleid left JOIN CustomAccess_UnitArea AS kua ON kua.ID = kuui.AreaID";
        DataSet ds = SqlHelper.GetPagination(table, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    /// 通过ID获取CustomAccess_UnitUserInfo信息
    /// </summary>
    public void GetUnitUserInfoByID()
    {
        int uid = Convert.ToInt32(Request.Form["uid"]);
        SqlParameter paras = new SqlParameter("@uid", SqlDbType.Int);
        paras.Value = uid;
        string sql = "SELECT u.uid,u.uname,u.roleid,kuui.areaid FROM  CustomAccess_UnitUserInfo AS kuui JOIN  userinfo AS u ON u.UID = kuui.UID WHERE u.uid=@uid";
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
        paras.Add(new SqlParameter("@upwd", FormsAuthentication.HashPasswordForStoringInConfigFile("ayltyw.0","MD5").ToLower()));

        string sql = "if not exists( select uname from UserInfo where uname=@uname)";
        sql += "INSERT INTO UserInfo VALUES(@uname,@upwd,@deptname,@roleid,@tablepre,1);";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras.ToArray());
        if (result != 1)
        {
            Response.Write("{\"success\":false,\"msg\":\"该用户名已存在！\"}");
            return;
        }
        else
        {
            newUid = Convert.ToInt32(SqlHelper.ExecuteScalar(SqlHelper.GetConnection(), CommandType.Text, "SELECT IDENT_CURRENT('UserInfo')"));
            int rst = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, "Insert CustomAccess_UnitUserInfo values(@uid,@areaid)", new SqlParameter[] { new SqlParameter("@uid", newUid), new SqlParameter("@areaid", areaid) });
            if (rst == 1)
                Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
            else
                Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
        }
    }
    /// <summary>
    /// 通过uid更新CustomAccess_UnitUserInfo表数据
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
        sql += "UPDATE CustomAccess_UnitUserInfo set areaid=@areaid where uid=@uid;";
        sql += "UPDATE UserInfo set uname=@uname,roleid=@roleid where uid=@uid;";
        sql += " end";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 2)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"该用户名已存在！\"}");
    }
    /// <summary>
    /// 通过UID删除CustomAccess_UnitUserInfo信息
    /// </summary>
    public void RemoveUnitUserInfoByID()
    {
        int uid = 0;
        int.TryParse(Request.Form["uid"], out uid);

        SqlParameter paras = new SqlParameter("@uid", SqlDbType.Int);
        paras.Value = uid;
        string sql = "DELETE FROM CustomAccess_UnitUserInfo WHERE uid=@uid;Delete from userinfo where uid=@uid;";
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
        string userPwd = FormsAuthentication.HashPasswordForStoringInConfigFile("ayltyw.0","MD5").ToLower();
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

    #region 客户接入——领料人管理
    /// <summary>
    /// 设置领料人管理查询条件
    /// </summary>
    /// <returns></returns>
    public string SetQueryConditionForPicker()
    {
        string queryStr = "";
        //设置查询条件
        List<string> list = new List<string>();
        //按单位
        if (Session["roleid"].ToString() == "30" || Session["roleid"].ToString() == "31" || Session["roleid"].ToString() == "32")
        {
            list.Add(" b.unitname ='" + Session["deptname"].ToString() + "'");
        }
        else if (!string.IsNullOrEmpty(Request.Form["unitname"]) && Request.Form["unitname"] != "全部")
        {

            list.Add(" b.deptname ='" + Request.Form["unitname"] + "'");
        }
        //按营业部
        if (!string.IsNullOrEmpty(Request.Form["areaid"]))
            list.Add(" areaid =" + Request.Form["areaid"]);
        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 客户接入——领料人管理
    /// 获取CustomAccess_UnitPickerInfo表数据page:1 rows:10 sort:id order:asc
    public void GetCustomAccessUnitPickerInfo()
    {
        int total = 0;
        string where = SetQueryConditionForPicker();
        string fieldStr = "a.id,b.unitname,b.areaname,a.pickername";
        string table = "CustomAccess_UnitPickerInfo AS a left JOIN CustomAccess_UnitArea AS b ON b.id = a.AreaID";
        DataSet ds = SqlHelper.GetPagination(table, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    /// 通过ID获取CustomAccess_UnitPickerInfo信息
    /// </summary>
    public void GetUnitPickerInfoByID()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = id;
        string sql = "SELECT * FROM  CustomAccess_UnitPickerInfo  WHERE id=@id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    /// <summary>
    /// 保存各营业部领料人信息
    /// </summary>
    public void SaveUnitPickerInfo()
    {
        string pickername = Convert.ToString(Request.Form["pickername"]);
        int areaid = 0;
        int.TryParse(Request.Form["areaid"], out areaid);
        List<SqlParameter> paras = new List<SqlParameter>();
        paras.Add(new SqlParameter("@pickername", pickername));
        paras.Add(new SqlParameter("@areaid", areaid));
        string sql = "if not exists( select pickername from CustomAccess_UnitPickerInfo where pickername=@pickername and areaid=@areaid)";
        sql += "INSERT INTO CustomAccess_UnitPickerInfo VALUES(@pickername,@areaid);";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras.ToArray());
        if (result != 1)
            Response.Write("{\"success\":false,\"msg\":\"该领料人已存在！\"}");
        else
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
    }
    /// <summary>
    /// 通过uid更新CustomAccess_UnitPickerInfo表数据
    /// </summary>
    public void UpdateUnitPickerInfo()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        string pickername = Convert.ToString(Request.Form["pickername"]);
        int areaId = Convert.ToInt32(Request.Form["areaId"]);
        SqlParameter[] paras = new SqlParameter[] {
            new SqlParameter("@id",SqlDbType.Int),
            new SqlParameter("@pickername",SqlDbType.VarChar),
            new SqlParameter("@areaid",SqlDbType.Int)
        };
        paras[0].Value = id;
        paras[1].Value = pickername;
        paras[2].Value = areaId;
        string sql = "if not exists(select pickername from CustomAccess_UnitPickerInfo where pickername=@pickername and id<>@id and areaId=@areaId)";
        sql += "UPDATE CustomAccess_UnitPickerInfo set pickername=@pickername,areaid=@areaid where id=@id;";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"该领料人名已存在！\"}");
    }
    /// <summary>
    /// 通过ID删除CustomAccess_UnitPickerInfo信息
    /// </summary>
    public void RemoveUnitPickerInfoByID()
    {
        int id = 0;
        int.TryParse(Request.Form["id"], out id);

        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = id;
        string sql = "DELETE FROM CustomAccess_UnitPickerInfo WHERE id=@id;";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    /// <summary>
    ///  根据不同的营业部生成领料页面的领料人combobox使用的json字符串
    /// </summary>
    public void GetPickerComboboxForStockOutByAreaID()
    {
        string where = "";
        //设置查询条件
        List<string> list = new List<string>();
        if (Session["areaid"] != null && roleid == "32")
            list.Add(" areaid = " + Session["areaid"].ToString() + " ");
        else
        {
            if (!string.IsNullOrEmpty(Request.QueryString["areaid"]))
                list.Add("areaid = " + Server.UrlDecode(Convert.ToString(Request.QueryString["areaid"])));
        }
        //combobox自动补全模式下获查询变量q
        if (!string.IsNullOrEmpty(Request.Form["q"]))
            list.Add(" pickername like'%" + Request.Form["q"].ToString() + "%'");
        if (list.Count > 0)
            where = "where " + string.Join(" and ", list.ToArray());
        string sql = "select id,pickername from CustomAccess_UnitPickerInfo " + where + " order by id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql);
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0]));
    }


    #endregion  客户接入——领料人管理

    #region 客户接入——库存管理
    /// <summary>
    /// 设置库存管理查询条件
    /// </summary>
    /// <returns></returns>
    public string SetQueryConditionForStock()
    {
        string queryStr = "";
        //设置查询条件
        List<string> list = new List<string>();
        //按单位
        if (Session["roleid"].ToString() == "30" || Session["roleid"].ToString() == "31" || Session["roleid"].ToString() == "32")
        {
            list.Add(" a.unitname ='" + Session["deptname"].ToString() + "'");
        }
        else if (!string.IsNullOrEmpty(Request.Form["unitname"]) && Request.Form["unitname"] != "全部")
        {

            list.Add(" a.unitname ='" + Request.Form["unitname"] + "'");
        }
        //按营业部
        if (roleid == "32")
            list.Add(" areaid ='" + Session["areaid"].ToString() + "'");
        else if (!string.IsNullOrEmpty(Request.Form["areaid"]))
            list.Add(" areaid =" + Request.Form["areaid"]);
        //按物料型号
        if (!string.IsNullOrEmpty(Request.Form["typeid"]))
            list.Add(" typeid =" + Request.Form["typeid"]);
        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 客户接入——基层装维单元库存管理
    /// 获取CustomAccess_Stock表数据page:1 rows:10 sort:id order:asc
    public void GetCustomAccessUnitStock()
    {
        int total = 0;
        string where = SetQueryConditionForStock();
        if (!string.IsNullOrEmpty(Request.Form["where"]))
            where = Server.UrlDecode(Request.Form["where"].ToString());
        string fieldStr = "a.id,a.unitname,c.areaname,a.storeorderno,b.typename,a.amount,b.units,price";
        string table = "CustomAccess_Stock AS a JOIN CustomAccess_Wlxh AS b ON a.typeid=b.id join CustomAccess_UnitArea c on a.areaid=c.id";
        DataSet ds = SqlHelper.GetPagination(table, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    /// 通过基层单元名和物料型号获取当前库存信息
    /// </summary>
    public void GetCurrentStockByUnitNameAndTypeId()
    {
        int typeid = Convert.ToInt32(Request.Form["typeid"]);
        string unitname = Convert.ToString(Session["deptname"]);
        SqlParameter[] paras = new SqlParameter[]
        { new SqlParameter("@typeid", SqlDbType.Int),
        new SqlParameter("@unitname", SqlDbType.VarChar)
        };
        paras[0].Value = typeid;
        paras[1].Value = unitname;
        string sql = "SELECT  isnull(ks.Amount,0) AS amount,kw.Units FROM CustomAccess_Stock AS ks right  JOIN CustomAccess_Wlxh AS kw ON ks.TypeID=kw.ID AND  ks.UnitName=@unitname WHERE  kw.id=@typeid";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    /// <summary>
    /// 保存库存录入信息和录入日志
    /// </summary>
    public void SaveUnitStockInfo()
    {
        string llrq = Convert.ToString(Request.Form["llrq"]);
        string memo = Convert.ToString(Server.HtmlEncode(Request.Form["memo"]));
        //获取数据行数
        int rowsCount = 0;
        Int32.TryParse(Request.Form["rowsCount"], out rowsCount);
        if (rowsCount == 0)
        {
            Response.Write("{\"success\":false,\"msg\":\"请录入库存信息\"}");
            return;
        }
        //根据数据行数生成sql语句和参数列表
        StringBuilder sql = new StringBuilder();
        List<SqlParameter> paras = new List<SqlParameter>();
        paras.Add(new SqlParameter("@unitname", Session["deptname"]));
        paras.Add(new SqlParameter("@llrq", llrq));
        paras.Add(new SqlParameter("@memo", memo));
        //订单号集合
        ArrayList orderNoList = new ArrayList();
        //当前订单号
        string orderno;
        //判断重复订单号
        for (int i = 1; i <= rowsCount; i++)
        {
            orderno = Request.Form["storeorderno" + i.ToString()];
            //页面录入的订单号判断
            if (orderNoList.Contains(orderno))
            {
                Response.Write("{\"success\":false,\"msg\":\"请不要输入重复的出库单号：" + orderno + "！\"}");
                return;
            }
            else
                orderNoList.Add(orderno);
            //与数据库中的订单号判断
            string sqlExists = "select count(1) from CustomAccess_Stock WHERE storeorderno=@storeorderno";
            int num = (int)SqlHelper.ExecuteScalar(SqlHelper.GetConnection(), CommandType.Text, sqlExists, new SqlParameter("@storeorderno", orderno));
            if (num != 0)
            {
                Response.Write("{\"success\":false,\"msg\":\"出库单号：" + orderno + "已存在，请检查输入！\"}");
                return;
            }

        }
        //生产插入语句
        for (int i = 1; i <= rowsCount; i++)
        {
            paras.Add(new SqlParameter("@storeorderno" + i.ToString(), Request.Form["storeorderno" + i.ToString()]));
            paras.Add(new SqlParameter("@areaid" + i.ToString(), Request.Form["areaid" + i.ToString()]));
            paras.Add(new SqlParameter("@typeid" + i.ToString(), Request.Form["typeid" + i.ToString()]));
            paras.Add(new SqlParameter("@amount" + i.ToString(), Request.Form["amount" + i.ToString()]));
            paras.Add(new SqlParameter("@price" + i.ToString(), Request.Form["price" + i.ToString()]));
            paras.Add(new SqlParameter("@money" + i.ToString(), double.Parse(Request.Form["price" + i.ToString()]) * Int32.Parse(Request.Form["amount" + i.ToString()])));
            sql.Append(" INSERT INTO CustomAccess_Stock	VALUES(	@unitname,@areaid" + i.ToString() + ",@storeorderno" + i.ToString() + ",@typeid" + i.ToString() + ",@amount" + i.ToString() + ",@price" + i.ToString() + "); ");
            sql.Append("INSERT INTO CustomAccess_KclrLog values(@llrq,@storeorderno" + i.ToString() + ",@unitname,@areaid" + i.ToString() + ",@typeid" + i.ToString() + ",@amount" + i.ToString() + ",@price" + i.ToString() + ",@money" + i.ToString() + ",getdate(),@memo);");
        }

        //使用事务提交操作
        using (SqlConnection conn = SqlHelper.GetConnection())
        {
            conn.Open();
            using (SqlTransaction trans = conn.BeginTransaction())
            {
                try
                {
                    SqlHelper.ExecuteNonQuery(trans, CommandType.Text, sql.ToString(), paras.ToArray());
                    trans.Commit();
                    Response.Write("{\"success\":true,\"msg\":\"库存录入成功!\"}");
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    Response.Write("{\"success\":false,\"msg\":\"" + ex.ToString() + "\"}");
                    throw;
                }
            }
        }

    }
    /// <summary>
    /// 保存营业部/乡镇支局领料信息并减少库存
    /// </summary>
    public void SaveUnitStockOutInfo()
    {
        string ckrq = Convert.ToString(Request.Form["ckrq"]);
        string llr = Convert.ToString(Request.Form["llr"]);
        string memo = Convert.ToString(Server.HtmlEncode(Request.Form["memo"]));
        int areaid = Convert.ToInt32(Request.Form["areaid"]);
        //获取数据行数
        int rowsCount = 0;
        Int32.TryParse(Request.Form["rowsCount"], out rowsCount);
        if (rowsCount == 0)
        {
            Response.Write("{\"success\":false,\"msg\":\"请录入领料信息\"}");
            return;
        }
        //根据数据行数生成sql语句和参数列表
        StringBuilder sql = new StringBuilder();
        List<SqlParameter> paras = new List<SqlParameter>();
        paras.Add(new SqlParameter("@unitname", Session["deptname"]));
        paras.Add(new SqlParameter("@ckrq", ckrq));
        paras.Add(new SqlParameter("@areaid", areaid));
        paras.Add(new SqlParameter("@llr", llr));
        paras.Add(new SqlParameter("@memo", memo));
        for (int i = 1; i <= rowsCount; i++)
        {
            paras.Add(new SqlParameter("@typeid" + i.ToString(), Request.Form["typeid" + i.ToString()]));
            paras.Add(new SqlParameter("@storeorderno" + i.ToString(), Request.Form["storeorderno" + i.ToString()]));
            paras.Add(new SqlParameter("@amount" + i.ToString(), Request.Form["amount" + i.ToString()]));
            sql.Append(" UPDATE CustomAccess_Stock 	SET Amount =amount-@amount" + i.ToString() + "	where areaid = @areaid AND TypeID = @typeid" + i.ToString() + " and storeorderno=@storeorderno" + i.ToString() + "; ");
            sql.Append("INSERT INTO CustomAccess_StockOut values(@storeorderno" + i.ToString() + ",@ckrq,@unitname,@areaid,@llr,@typeid" + i.ToString() + ",@amount" + i.ToString() + ",getdate(),@memo);");

        }
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), paras.ToArray());
        if (result > 0)
            Response.Write("{\"success\":true,\"msg\":\"提交成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    /// <summary>
    /// 导出基层单元库存
    /// </summary>
    public void ExportUnitStock()
    {
        string where = SetQueryConditionForStock();
        if (where != "")
            where = " where " + where;
        StringBuilder sql = new StringBuilder();
        sql.Append("select a.id,a.unitname,c.areaname,a.storeorderno,b.typename,a.amount,b.units,price ");
        sql.Append(" from CustomAccess_Stock AS a JOIN CustomAccess_Wlxh AS b ON a.typeid=b.id join CustomAccess_UnitArea c on a.areaid=c.id ");
        sql.Append(where);
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.Columns[0].ColumnName = "序号";
        dt.Columns[1].ColumnName = "单位名称";
        dt.Columns[2].ColumnName = "营业部";
        dt.Columns[3].ColumnName = "商城出库单号";
        dt.Columns[4].ColumnName = "物料型号";
        dt.Columns[5].ColumnName = "库存数量";
        dt.Columns[6].ColumnName = "单位";
        dt.Columns[7].ColumnName = "单价";
        MyXls.CreateXls(dt, "客户接入物料库存统计表.xls", "4");
        Response.Flush();
        Response.End();
    }
    #endregion 客户接入——库存管理
    #region 库存入库明细
    /// <summary>
    /// 设置入库明细查询条件
    /// </summary>
    /// <returns></returns>
    public string SetQueryConditionForInStock()
    {
        string queryStr = "";
        //设置查询条件
        List<string> list = new List<string>();
        //按领料日期查询
        //提交开始日期
        if (!string.IsNullOrEmpty(Request.Form["sdate"]))
            list.Add(" llrq >='" + Request.Form["sdate"] + "'");
        //提交截止日期
        if (!string.IsNullOrEmpty(Request.Form["edate"]))
            list.Add(" llrq <='" + Request.Form["edate"] + "'");
        //按单位
        if (Session["roleid"].ToString() == "30" || Session["roleid"].ToString() == "31" || Session["roleid"].ToString() == "32")
        {
            list.Add(" kkl.unitname ='" + Session["deptname"].ToString() + "'");
        }
        else if (!string.IsNullOrEmpty(Request.Form["unitname"]) && Request.Form["unitname"] != "全部")
        {

            list.Add(" kkl.unitname ='" + Request.Form["unitname"] + "'");
        }
        //按营业部
        if (roleid == "32")
            list.Add(" areaid ='" + Session["areaid"].ToString() + "'");
        else if (!string.IsNullOrEmpty(Request.Form["areaid"]))
            list.Add(" areaid =" + Request.Form["areaid"]);
        //按物料型号
        if (!string.IsNullOrEmpty(Request.Form["typeid"]))
            list.Add(" typeid =" + Request.Form["typeid"]);
        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 客户接入物料入库明细
    /// </summary>
    public void GetUnitInStockDetail()
    {
        int total = 0;
        string where = SetQueryConditionForInStock();
        if (!string.IsNullOrEmpty(Request.Form["where"]))
            where = Server.UrlDecode(Request.Form["where"].ToString());
        string fieldStr = "kkl.id,kkl.llrq,kkl.storeorderno,kkl.unitname,c.areaname,kkl.typeid,kw.TypeName,kkl.amount,kw.Units,price,money,kkl.inputtime,kkl.memo";
        string table = "CustomAccess_KclrLog AS kkl JOIN  CustomAccess_Wlxh AS kw ON kkl.typeid=kw.ID join CustomAccess_UnitArea c on kkl.areaid=c.id ";
        DataSet ds = SqlHelper.GetPagination(table, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    /// 导出基层单元入库明细
    /// </summary>
    public void ExportUnitInStockDetail()
    {
        string where = SetQueryConditionForInStock();
        if (where != "")
            where = " where " + where;
        StringBuilder sql = new StringBuilder();
        sql.Append("select kkl.id,kkl.llrq,kkl.storeorderno,kkl.unitname,c.areaname,kw.TypeName,kkl.amount,kw.Units,price,money,kkl.memo ");
        sql.Append(" FROM CustomAccess_KclrLog AS kkl JOIN  CustomAccess_Wlxh AS kw ON kkl.typeid=kw.ID join CustomAccess_UnitArea c on kkl.areaid=c.id  ");
        sql.Append(where);
        sql.Append(" order by kkl.id ");
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.Columns[0].ColumnName = "序号";
        dt.Columns[1].ColumnName = "入库日期";
        dt.Columns[2].ColumnName = "商城出库单号";
        dt.Columns[3].ColumnName = "单位名称";
        dt.Columns[4].ColumnName = "营业部";
        dt.Columns[5].ColumnName = "物料型号";
        dt.Columns[6].ColumnName = "入库数量 ";
        dt.Columns[7].ColumnName = "单位";
        dt.Columns[8].ColumnName = "单价";
        dt.Columns[9].ColumnName = "金额";
        dt.Columns[10].ColumnName = "备注";
        MyXls.CreateXls(dt, "客户接入物料入库明细.xls", "2,5,10");
        Response.Flush();
        Response.End();
    }
    #endregion 库存入库明细
    #region 营业部/乡镇支局领料明细
    /// <summary>
    /// 设置营业部/乡镇支局领料明细查询条件
    /// </summary>
    /// <returns></returns>
    public string SetQueryConditionForOutStock()
    {
        string queryStr = "";
        //设置查询条件
        List<string> list = new List<string>();
        //按领料日期查询
        //提交开始日期
        if (!string.IsNullOrEmpty(Request.Form["sdate"]))
            list.Add(" ckrq >='" + Request.Form["sdate"] + "'");
        //提交截止日期
        if (!string.IsNullOrEmpty(Request.Form["edate"]))
            list.Add(" ckrq <='" + Request.Form["edate"] + "'");
        //按单位
        if (Session["roleid"].ToString() == "30" || Session["roleid"].ToString() == "31" || Session["roleid"].ToString() == "32")
        {
            list.Add(" a.unitname ='" + Session["deptname"].ToString() + "'");
        }
        else if (!string.IsNullOrEmpty(Request.Form["unitname"]) && Request.Form["unitname"] != "全部")
        {

            list.Add(" a.unitname ='" + Request.Form["unitname"] + "'");
        }
        //按营业部/乡镇支局
        if (Session["roleid"].ToString() == "32" && Session["areaid"] != null)
            list.Add(" a.areaid =" + Session["areaid"].ToString());
        else if (!string.IsNullOrEmpty(Request.Form["areaid"]))
            list.Add(" a.areaid =" + Request.Form["areaid"]);
        //按物料型号
        if (!string.IsNullOrEmpty(Request.Form["typeid"]))
            list.Add(" a.typeid =" + Request.Form["typeid"]);
        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 营业部/乡镇支局领料明细明细（营业部/乡镇支局领料明细）
    /// </summary>
    public void GetUnitOutStockDetail()
    {
        int total = 0;
        string where = SetQueryConditionForOutStock();
        if (!string.IsNullOrEmpty(Request.Form["where"]))
            where = Server.UrlDecode(Request.Form["where"].ToString());
        string fieldStr = "a.id,a.ckrq,a.unitname,c.AreaName,a.llr,a.storeorderno,b.TypeName,a.amount,b.Units,d.price,a.amount*d.price as allFee,a.memo";
        string table = "CustomAccess_StockOut AS a JOIN CustomAccess_Wlxh AS b ON a.typeid=b.ID JOIN CustomAccess_UnitArea AS c ON a.areaid=c.ID left join CustomAccess_Stock d on a.storeorderno=d.storeorderno ";
        DataSet ds = SqlHelper.GetPagination(table, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    /// 导出营业部/乡镇支局领料明细
    /// </summary>
    public void ExportUnitOutStockDetail()
    {
        string where = SetQueryConditionForOutStock();
        if (where != "")
            where = " where " + where;
        StringBuilder sql = new StringBuilder();
        sql.Append("SELECT a.ckrq,a.unitname,c.AreaName,a.llr,a.storeorderno,b.TypeName,a.amount,b.Units,d.price,a.amount*d.price as allFee,a.memo ");
        sql.Append(" FROM CustomAccess_StockOut AS a JOIN CustomAccess_Wlxh AS b ON a.typeid=b.ID JOIN CustomAccess_UnitArea AS c ON a.areaid=c.ID left join CustomAccess_Stock d on a.storeorderno=d.storeorderno ");
        sql.Append(where);
        sql.Append(" order by a.id ");
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.Columns[0].ColumnName = "出库日期";
        dt.Columns[1].ColumnName = "出库单位";
        dt.Columns[2].ColumnName = "领料单元";
        dt.Columns[3].ColumnName = "领料人";
        dt.Columns[4].ColumnName = "商城出库单号";
        dt.Columns[5].ColumnName = "物料型号";
        dt.Columns[6].ColumnName = "数量";
        dt.Columns[7].ColumnName = "单位";
        dt.Columns[8].ColumnName = "单价";
        dt.Columns[9].ColumnName = "金额（元）";
        dt.Columns[10].ColumnName = "备注";
        MyXls.CreateXls(dt, "营业部/乡镇支局领料明细.xls", "5,8");
        Response.Flush();
        Response.End();
    }
    #endregion 营业部/乡镇支局领料明细
    #region 营业部/乡镇支局用料明细
    /// <summary>
    /// 设置营业部/乡镇支局用料明细查询条件
    /// </summary>
    /// <returns></returns>
    public string SetQueryConditionForAreaMaterial()
    {
        string queryStr = "";
        //设置查询条件
        List<string> list = new List<string>();
        //按领料日期查询
        //提交开始日期
        if (!string.IsNullOrEmpty(Request.Form["sdate"]))
            list.Add(" CONVERT(varchar(10), inputtime, 23) >='" + Request.Form["sdate"] + "'");
        //提交截止日期
        if (!string.IsNullOrEmpty(Request.Form["edate"]))
            list.Add(" CONVERT(varchar(10), inputtime, 23) <='" + Request.Form["edate"] + "'");
        //按基层单元
        if (Session["roleid"].ToString() == "12" || Session["roleid"].ToString() == "13" || Session["roleid"].ToString() == "14" || Session["roleid"].ToString() == "17")
        {
            list.Add(" a.unitname ='" + Session["deptname"].ToString() + "'");
        }
        else if (!string.IsNullOrEmpty(Request.Form["unitname"]) && Request.Form["unitname"] != "全部")
        {

            list.Add(" a.unitname ='" + Request.Form["unitname"] + "'");
        }
        //按营业部/乡镇支局
        if (Session["roleid"].ToString() == "14" && Session["areaid"] != null)
            list.Add(" b.id =" + Session["areaid"].ToString());
        else if (!string.IsNullOrEmpty(Request.Form["areaid"]))
            list.Add(" b.id =" + Request.Form["areaid"]);
        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 营业部/乡镇支局用料明细
    /// </summary>
    public void GetAreaMaterialDetail()
    {
        int total = 0;
        string where = SetQueryConditionForAreaMaterial();
        if (!string.IsNullOrEmpty(Request.Form["where"]))
            where = Server.UrlDecode(Request.Form["where"].ToString());
        string fieldStr = "a.*, CONVERT(varchar(10), inputtime, 23) as inputdate";
        string table = "CustomAccess_Zwyl AS a JOIN CustomAccess_UnitArea AS b ON a.areaname=b.AreaName";
        DataSet ds = SqlHelper.GetPagination(table, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds.Tables[0], total, true, "pxgl,ljct_3m,ljct_gc,px,hx,wx", "onu", "合计"));
    }
    /// <summary>
    /// 导出营业部/乡镇支局用料明细
    /// </summary>
    public void ExportAreaMaterialDetail()
    {
        string where = SetQueryConditionForAreaMaterial();
        if (where != "")
            where = " where " + where;
        StringBuilder sql = new StringBuilder();
        sql.Append("SELECT a.id,CONVERT(varchar(10), inputtime, 23) as inputdate,a.unitname,a.AreaName,a.yllb, a.usernum,a.username,a.useraddress,onu,pxgl,ljct_3m,ljct_gc,px,hx,wx,memo ");
        sql.Append(" FROM CustomAccess_Zwyl AS a JOIN CustomAccess_UnitArea AS b ON a.areaname=b.AreaName ");
        sql.Append(where);
        sql.Append(" order by a.id ");
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.Columns[0].ColumnName = "序号";
        dt.Columns[1].ColumnName = "录入日期";
        dt.Columns[2].ColumnName = "基层单元";
        dt.Columns[3].ColumnName = "营业部/乡镇支局";
        dt.Columns[4].ColumnName = "用料类别";
        dt.Columns[5].ColumnName = "用户号码";
        dt.Columns[6].ColumnName = "用户姓名";
        dt.Columns[7].ColumnName = "用户地址";
        dt.Columns[8].ColumnName = "光猫";
        dt.Columns[9].ColumnName = "皮线光缆";
        dt.Columns[10].ColumnName = "冷接(3M)";
        dt.Columns[11].ColumnName = "冷接(国产)";
        dt.Columns[12].ColumnName = "皮线";
        dt.Columns[13].ColumnName = "户线";
        dt.Columns[14].ColumnName = "网线";
        dt.Columns[15].ColumnName = "备注";
        MyXls.CreateXls(dt, "营业部/乡镇支局用料明细.xls", "7,15");
        Response.Flush();
        Response.End();
    }
    /// <summary>
    /// 导入上传的营业部/乡镇支局用料明细信息
    /// </summary>
    public void ImportAreaMaterialInfo()
    {
        string reportPath = "";
        if (!string.IsNullOrEmpty(Request.Form["report"]))
            reportPath = Server.MapPath("~") + Request.Form["report"].ToString();
        int checkFile = MyXls.ChkSheet(reportPath, "sheet");
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
        columnsName.Add("基层单元");
        columnsName.Add("营业部/乡镇支局");
        columnsName.Add("用料类别");
        columnsName.Add("用户号码");
        columnsName.Add("用户姓名");
        columnsName.Add("用户地址");
        columnsName.Add("光猫");
        columnsName.Add("皮线光缆");
        columnsName.Add("冷接(3M)");
        columnsName.Add("冷接(国产)");
        columnsName.Add("皮线");
        columnsName.Add("户线");
        columnsName.Add("网线");
        columnsName.Add("备注");
        List<int> columnsExists = MyXls.ChkSheetColumns(reportPath, "sheet", columnsName);
        if (columnsExists.Contains(0))
        {
            Response.Write("{\"success\":false,\"msg\":\"请检查excel文件内容格式是否正确！\"}");
            return;
        }
        SqlParameter[] paras = new SqlParameter[]{
            new SqlParameter("@filePath",reportPath),
            new SqlParameter("@sheetName","sheet")
        };
        SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.StoredProcedure, "ImportAreaMaterialInfoFromExcel", paras);
        //SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.StoredProcedure, "ImportAreaMaterialInfoFromExcel_x64", paras);
        Response.Write("{\"success\":true,\"msg\":\"数据导入成功！\"}");
    }
    /// <summary>
    /// 保存营业部/乡镇支局用料明细
    /// </summary>
    public void SaveAreaMaterial()
    {
        string usernum = Convert.ToString(Request.Form["usernum"]);
        string username = Convert.ToString(Request.Form["username"]);
        string useraddress = Convert.ToString(Server.HtmlEncode(Request.Form["useraddress"]));
        string yllb = Convert.ToString(Request.Form["yllb"]);
        string onu = Convert.ToString(Request.Form["onu"]);
        string pxgl = Convert.ToString(Request.Form["pxgl"]);
        string ljct_3M = Convert.ToString(Request.Form["ljct_3M"]);
        string ljct_gc = Convert.ToString(Request.Form["ljct_gc"]);
        string px = Convert.ToString(Request.Form["px"]);
        string hx = Convert.ToString(Request.Form["hx"]);
        string wx = Convert.ToString(Request.Form["wx"]);
        string memo = Convert.ToString(Server.HtmlEncode(Request.Form["memo"]));
        string areaname = SqlHelper.ExecuteScalar(SqlHelper.GetConnection(), CommandType.Text, "Select areaname from CustomAccess_UnitArea where id=@id", new SqlParameter("@id", Session["areaid"])).ToString();
        //根据数据行数生成sql语句和参数列表
        StringBuilder sql = new StringBuilder();
        List<SqlParameter> paras = new List<SqlParameter>();
        paras.Add(new SqlParameter("@unitname", Session["deptname"]));
        paras.Add(new SqlParameter("@areaname", areaname));
        paras.Add(new SqlParameter("@usernum", usernum));
        paras.Add(new SqlParameter("@username", username));
        paras.Add(new SqlParameter("@useraddress", useraddress));
        paras.Add(new SqlParameter("@yllb", yllb));
        paras.Add(new SqlParameter("@onu", onu));
        paras.Add(new SqlParameter("@pxgl", pxgl));
        paras.Add(new SqlParameter("@ljct_3M", ljct_3M));
        paras.Add(new SqlParameter("@ljct_gc", ljct_gc));
        paras.Add(new SqlParameter("@px", px));
        paras.Add(new SqlParameter("@hx", hx));
        paras.Add(new SqlParameter("@wx", wx));
        paras.Add(new SqlParameter("@memo", memo));
        sql.Append("INSERT INTO CustomAccess_Zwyl VALUES(@unitname,@areaname,@usernum,@username,@useraddress,@yllb,@onu,@pxgl,@ljct_3M,@ljct_gc,@px,@hx,@wx,@memo,getdate()	)");
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), paras.ToArray());
        if (result > 0)
            Response.Write("{\"success\":true,\"msg\":\"提交成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    #endregion 营业部/乡镇支局用料

    #region 物料调拨
    /// <summary>
    /// 通过ID获取被调拨物料的库存信息
    /// </summary>
    public void GetCustomAccessUnitStockById()
    {
        int id = 0;
        int.TryParse(Request.Form["id"], out id);
        string sql = "select  a.id,a.unitname,a.areaid,c.areaname,a.storeorderno,b.typename,a.amount,b.units,price  from  CustomAccess_Stock AS a JOIN CustomAccess_Wlxh AS b ON a.typeid=b.id join CustomAccess_UnitArea c on a.areaid=c.id where a.id=@id";
        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = id;
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    /// <summary>
    /// 获取要调拨的营业部信息
    /// </summary>
    public void GetCustomAccess_AllotUnitAreaCombobox()
    {
        int id = Convert.ToInt32(Request.QueryString["id"]);
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, "select id,areaname from CustomAccess_UnitArea WHERE id<>@id AND UnitName=(SELECT UnitName FROM dbo.CustomAccess_UnitArea WHERE id=@id)", new SqlParameter("@id", id));
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0]));
    }
    /// <summary>
    /// 保存营业部/乡镇支局物料调拨信息
    /// </summary>
    public void SaveUnitAllotStockInfo()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        int allotareaid = Convert.ToInt32(Request.Form["areaid"]);
        int allotnum = Convert.ToInt32(Request.Form["allotnum"]);
        string allotrq = DateTime.Now.ToString("yyyy-MM-dd");
        string memo = Convert.ToString(Server.HtmlEncode(Request.Form["memo"]));
        //生成库存表中调拨单编号
        Random myrdn = new Random();//产生随机数
        string allotOrderNo = "Allot-" + DateTime.Now.ToString("yyyyMMddhhmmss") + myrdn.Next(1000);
        //根据数据行数生成sql语句和参数列表
        StringBuilder sql = new StringBuilder();
        List<SqlParameter> paras = new List<SqlParameter>();
        paras.Add(new SqlParameter("@id", id));
        paras.Add(new SqlParameter("@allotareaid", allotareaid));
        paras.Add(new SqlParameter("@allotnum", allotnum));
        paras.Add(new SqlParameter("@allotrq", allotrq));
        paras.Add(new SqlParameter("@memo", memo));
        paras.Add(new SqlParameter("@allotorderno", allotOrderNo));

        sql.Append("IF EXISTS(SELECT * FROM  dbo.CustomAccess_Stock WHERE id=@id AND Amount>=@allotnum) ");
        sql.Append(" begin ");
        sql.Append("INSERT INTO dbo.CustomAccess_Allotlog SELECT @allotrq,@allotareaid,@allotorderno,Storeorderno,UnitName,areaid,TypeID,@allotnum,Price,@allotnum*Price,GETDATE(),@memo FROM dbo.CustomAccess_Stock WHERE id=@id;");
        sql.Append(" UPDATE dbo.CustomAccess_Stock SET Amount=Amount-@allotnum WHERE id=@id; ");
        sql.Append(" INSERT INTO dbo.CustomAccess_Stock SELECT UnitName, @allotareaid, @allotorderno, TypeID, @allotnum, Price FROM dbo.CustomAccess_Stock WHERE id = @id; ");
        sql.Append(" end ");
        //使用事务提交操作
        using (SqlConnection conn = SqlHelper.GetConnection())
        {
            conn.Open();
            using (SqlTransaction trans = conn.BeginTransaction())
            {
                try
                {
                    SqlHelper.ExecuteNonQuery(trans, CommandType.Text, sql.ToString(), paras.ToArray());
                    trans.Commit();
                    Response.Write("{\"success\":true,\"msg\":\"物料调拨成功!\"}");
                }
                catch (SqlException ex)
                {
                    trans.Rollback();
                    Response.Write("{\"success\":false,\"msg\":\"" + ex.ToString() + "\"}");
                    throw;
                }
            }
        }
    }
    /// <summary>
    /// 设置物料调拨查询条件
    /// </summary>
    /// <returns></returns>
    public string SetQueryConditionForAllot()
    {
        string queryStr = "";
        //设置查询条件
        List<string> list = new List<string>();
        //按领料日期查询
        //提交开始日期
        if (!string.IsNullOrEmpty(Request.Form["sdate"]))
            list.Add(" allotrq >='" + Request.Form["sdate"] + "'");
        //提交截止日期
        if (!string.IsNullOrEmpty(Request.Form["edate"]))
            list.Add(" allotrq <='" + Request.Form["edate"] + "'");
        //按单位
        if (Session["roleid"].ToString() == "30" || Session["roleid"].ToString() == "31" || Session["roleid"].ToString() == "32")
        {
            list.Add(" kkl.unitname ='" + Session["deptname"].ToString() + "'");
        }
        else if (!string.IsNullOrEmpty(Request.Form["unitname"]) && Request.Form["unitname"] != "全部")
        {

            list.Add(" kkl.unitname ='" + Request.Form["unitname"] + "'");
        }
        //按营业部
        if (roleid == "32")
            list.Add(" allotareaid ='" + Session["areaid"].ToString() + "'");
        else if (!string.IsNullOrEmpty(Request.Form["areaid"]))
            list.Add(" allotareaid =" + Request.Form["areaid"]);
        //按物料型号
        if (!string.IsNullOrEmpty(Request.Form["typeid"]))
            list.Add(" typeid =" + Request.Form["typeid"]);
        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 物料调拨明细
    /// </summary>
    public void GetUnitAllotStockDetail()
    {
        int total = 0;
        string where = SetQueryConditionForAllot();
        if (!string.IsNullOrEmpty(Request.Form["where"]))
            where = Server.UrlDecode(Request.Form["where"].ToString());
        string fieldStr = "kkl.id,kkl.allotrq,kkl.allotareaid,d.AreaName as allotareaname,kkl.AllotOrderNo,kkl.storeorderno,kkl.unitname,c.areaname,kkl.typeid,kw.TypeName,kkl.allotnum,kw.Units,price,money,kkl.inputtime,kkl.memo";
        string table = "CustomAccess_Allotlog AS kkl JOIN  CustomAccess_Wlxh AS kw ON kkl.typeid=kw.ID join CustomAccess_UnitArea c on kkl.areaid=c.id JOIN CustomAccess_UnitArea d ON kkl.allotareaid=d.ID ";
        DataSet ds = SqlHelper.GetPagination(table, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    /// 导出物料调拨明细
    /// </summary>
    public void ExportUnitAllotStockDetail()
    {
        string where = SetQueryConditionForAllot();
        if (where != "")
            where = " where " + where;
        StringBuilder sql = new StringBuilder();
        sql.Append("select kkl.id,kkl.allotrq,kkl.unitname,d.AreaName,kkl.AllotOrderNo,kkl.storeorderno,c.areaname,kw.TypeName,kkl.allotnum,kw.Units,price,money,kkl.inputtime,kkl.memo  FROM CustomAccess_Allotlog AS kkl JOIN  CustomAccess_Wlxh AS kw ON kkl.typeid=kw.ID join CustomAccess_UnitArea c on kkl.areaid=c.id JOIN CustomAccess_UnitArea d ON kkl.allotareaid=d.ID ");
        sql.Append(where);
        sql.Append(" order by kkl.id ");
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.Columns[0].ColumnName = "序号";
        dt.Columns[1].ColumnName = "调拨日期";
        dt.Columns[2].ColumnName = "单位名称";
        dt.Columns[3].ColumnName = "营业部";
        dt.Columns[4].ColumnName = "调拨单号";
        dt.Columns[5].ColumnName = "原商城订单号";
        dt.Columns[6].ColumnName = "原营业部";
        dt.Columns[7].ColumnName = "物料型号";
        dt.Columns[8].ColumnName = "调拨数量";
        dt.Columns[9].ColumnName = "单位";
        dt.Columns[10].ColumnName = "单价（元）";
        dt.Columns[11].ColumnName = "金额（元）";
        dt.Columns[12].ColumnName = "调拨时间";
        dt.Columns[13].ColumnName = "备注";
        MyXls.CreateXls(dt, "客户接入物料调拨明细.xls", "4,5,7,12,13");
        Response.Flush();
        Response.End();
    }
    #endregion 物料调拨
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}