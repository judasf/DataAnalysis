<%@ WebHandler Language="C#" Class="Srv_MaintainMaterial" %>

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
/// 运维物料管理
/// </summary>
public class Srv_MaintainMaterial : IHttpHandler, IRequiresSessionState
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
    /// <summary>
    /// 部门名称
    /// </summary>
    string deptname = "";
    /// <summary>
    /// 登录用户
    /// </summary>
    string uname = "";
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
            roleid = Session["roleid"].ToString();
            deptname = Session["deptname"].ToString();
            uname = Session["uname"].ToString();
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
    #region 运维物料——物料型号
    /// <summary>
    /// 运维物料——物料型号
    /// 获取MaintainMaterial_TypeInfo表数据page:1 rows:10 sort:id order:asc
    public void GetMaintainMaterialTypeInfo()
    {
        int total = 0;
        string where = "";
        if (!string.IsNullOrEmpty(Request.Form["classname"]))
            where += " classname='" + Request.Form["classname"] + "' and";
        if (!string.IsNullOrEmpty(Request.Form["typeid"]))
            where += " id= " + Request.Form["typeid"] + " and";
        if (where.Length > 0)
            where = where.Substring(0, where.Length - 3);
        string fieldStr = "*";
        string table = "MaintainMaterial_TypeInfo";
        DataSet ds = SqlHelper.GetPagination(table, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    /// 通过ID获取物料型号信息
    /// </summary>
    public void GetTypeInfoByID()
    {
        int classID = Convert.ToInt32(Request.Form["id"]);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = classID;
        string sql = "SELECT * FROM  MaintainMaterial_TypeInfo WHERE id=@id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    /// <summary>
    /// 保存物料型号信息
    /// </summary>
    public void SaveTypeInfo()
    {
        string classname = Convert.ToString(Request.Form["classname"]);
        string typeName = Convert.ToString(Request.Form["typename"]);
        string units = Convert.ToString(Request.Form["units"]);
        SqlParameter[] paras = new SqlParameter[] { new SqlParameter("@classname", classname), new SqlParameter("@typename", typeName), new SqlParameter("@units", units) };
        string sql = "if not exists( select id from MaintainMaterial_TypeInfo where classname=@classname and typename=@typename)";
        sql += "INSERT INTO MaintainMaterial_TypeInfo VALUES(@classname,@typename,@units)";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"该物料型号已存在！\"}");
    }
    /// <summary>
    /// 通过id更新MaintainMaterial_TypeInfo表数据
    /// </summary>
    public void UpdateTypeInfo()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        string classname = Convert.ToString(Request.Form["classname"]);
        string typeName = Convert.ToString(Request.Form["typename"]);
        string units = Convert.ToString(Request.Form["units"]);
        SqlParameter[] paras = new SqlParameter[] {
         new SqlParameter("@id",SqlDbType.Int),
         new SqlParameter("@classname",SqlDbType.NVarChar),
         new SqlParameter("@typename",SqlDbType.NVarChar),
         new SqlParameter("@units",SqlDbType.NVarChar)
        };
        paras[0].Value = id;
        paras[1].Value = classname;
        paras[2].Value = typeName;
        paras[3].Value = units;
        string sql = "if not exists( select id from MaintainMaterial_TypeInfo where  classname=@classname and typename=@typename)";
        sql += "UPDATE MaintainMaterial_TypeInfo set classname=@classname,typename=@typename,units=@units where id=@id";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"该物料型号已存在\"}");
    }
    /// <summary>
    /// 通过ID获取删除物料型号信息
    /// </summary>
    public void RemoveTypeInfoByID()
    {
        int id = 0;
        int.TryParse(Request.Form["id"], out id);

        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = id;
        string sql = "DELETE FROM MaintainMaterial_TypeInfo WHERE id=@id";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    /// <summary>
    /// 生成物料型号树json
    /// </summary>
    //public void GetTypeInfoTree()
    //{
    //    StringBuilder json = new StringBuilder("[");
    //    DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, "select * from MaintainMaterial_TypeInfo order by id");
    //    DataRowCollection rows = ds.Tables[0].Rows;
    //    if (rows.Count > 0)
    //    {
    //        foreach (DataRow row in rows)
    //        {
    //            //"{{"和"}}"在格式化字符串中被转义为"{","}"
    //            //json.AppendFormat("{{\"id\":{0},\"text\":\"{1}\"}},", row[0], row[1]);
    //            json.AppendFormat("{0}\"id\":{1},\"text\":\"{2}\",\"iconCls\":\"ext-icon-group\"{3},", "{", row[0], row[1], "}");
    //        }
    //    }
    //    json.Remove(json.Length - 1, 1);
    //    json.Append("]");
    //    Response.Write(json.ToString());
    //}
    /// <summary>
    /// 通过物料类型生成MaintainMaterial_TypeInfo表的combobox使用的json字符串,带“全部”选项
    /// </summary>
    public void GetMaintainMaterial_TypeInfoComboboxAll()
    {
        string queryStr = "";
        string where = "";
        //设置查询条件
        List<string> list = new List<string>();
        if (!string.IsNullOrEmpty(Request.QueryString["classname"]))
            list.Add(" classname ='" + Server.UrlDecode(Convert.ToString(Request.QueryString["classname"])) + "'");
        if (list.Count > 0)
        {
            queryStr = string.Join(" and ", list.ToArray());
            where = "where " + queryStr;
        }
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, "select id,typename from MaintainMaterial_TypeInfo " + where + " order by id");
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0], 0));
    }
    /// <summary>
    /// 通过物料类型生成入库页面物料型号combobox
    /// </summary>
    public void GetMaintainMaterial_TypeInfoComboboxForIn()
    {
        string queryStr = "";
        string where = "";
        //设置查询条件
        List<string> list = new List<string>();
        if (!string.IsNullOrEmpty(Request.QueryString["classname"]))
            list.Add(" classname ='" + Server.UrlDecode(Convert.ToString(Request.QueryString["classname"])) + "'");
        if (list.Count > 0)
        {
            queryStr = string.Join(" and ", list.ToArray());
            where = "where " + queryStr;
        }
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, "select id,typename from MaintainMaterial_TypeInfo " + where + " order by id");
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0], 2));
    }
    /// <summary>
    /// 生成物料型号列表combobox使用的json字符串
    /// </summary>
    public void GetTypeInfoCombobox()
    {
        string sql = "select id,typename from MaintainMaterial_TypeInfo  order by id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql);
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0]));
    }
    /// <summary>
    /// 生成物料型号列表combobox使用的json字符串带全部
    /// </summary>
    public void GetTypeInfoComboboxAll()
    {
        string sql = "select id,typename from MaintainMaterial_TypeInfo  order by id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql);
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0], 0));
    }
    /// <summary>
    /// 生成领料页面的物料型号列表combobox使用的json字符串，只显示有库存的
    /// </summary>
    public void GetTypeInfoComboboxForStockOut()
    {
        string queryStr = "";
        string where = "";
        //设置查询条件
        List<string> list = new List<string>();
        if (!string.IsNullOrEmpty(Request.QueryString["classname"]))
            list.Add(" classname ='" + Server.UrlDecode(Convert.ToString(Request.QueryString["classname"])) + "'");
        list.Add(" unitname='" + Session["deptname"] + "' ");
        if (list.Count > 0)
        {
            queryStr = string.Join(" and ", list.ToArray());
            where = "where " + queryStr;
        }
        string sql = "select distinct a.id,typename from MaintainMaterial_TypeInfo  a  JOIN  MaintainMaterial_Stock b ON a.id=b.TypeID AND b.Amount>0 " + where;
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql);
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0]));
    }

    /// <summary>
    ///  根据不同的单位,型号生成领料页面的出库单号的combogrid使用的json字符串，只显示有库存的
    /// </summary>
    public void GetOrderCombogridForStockOut()
    {
        string typeid = Convert.ToString(Request.Form["typeid"]);
        string where = " unitname='" + Session["deptname"] + "' and typeid=" + typeid;

        int total = 0;
        string table = "MaintainMaterial_TypeInfo  a  JOIN  MaintainMaterial_Stock b ON a.id=b.TypeID AND b.Amount>0";
        string fieldStr = "typeid,b.Storeorderno,b.Amount,a.units";

        DataSet ds = SqlHelper.GetPagination(table, fieldStr, Request["sort"].ToString(), Request["order"].ToString(), where, Convert.ToInt32(Request["rows"]), Convert.ToInt32(Request["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    /// 生成领料页面的物料类型列表combobox使用的json字符串，只显示有库存的
    /// </summary>
    public void GetClassInfoComboboxForStockOut()
    {
        string queryStr = "";
        string where = "";
        //设置查询条件
        List<string> list = new List<string>();
        //if (!string.IsNullOrEmpty(Request.QueryString["classname"]))
        //    list.Add(" classname ='" + Server.UrlDecode(Convert.ToString(Request.QueryString["classname"])) + "'");
        list.Add(" unitname='" + Session["deptname"] + "' ");
        if (list.Count > 0)
        {
            queryStr = string.Join(" and ", list.ToArray());
            where = "where " + queryStr;
        }
        string sql = "select  ROW_NUMBER() OVER (ORDER BY  a.ClassName)   AS rowid,a.ClassName  from MaintainMaterial_TypeInfo  a  JOIN  MaintainMaterial_Stock b ON a.id=b.TypeID AND b.Amount>0 " + where;
        sql += "  GROUP BY a.ClassName";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql);
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0]));
    }
    //********************维修台账页面信息 begin**********************************//
    /// <summary>
    /// 生成维修台账页面物料出库时当前维修台账录入人名下的物料类型列表combobox使用的json字符串，只显示有库存的
    /// </summary>
    public void GetClassInfoComboboxForDailyRepair()
    {
        string queryStr = "";
        string where = "";
        //设置查询条件
        List<string> list = new List<string>();
        list.Add(" llr='" + Session["uname"] + "' ");
        if (list.Count > 0)
        {
            queryStr = string.Join(" and ", list.ToArray());
            where = "where " + queryStr;
        }
        string sql = "select  ROW_NUMBER() OVER (ORDER BY  a.ClassName)   AS rowid,a.ClassName  from MaintainMaterial_TypeInfo  a  JOIN  dbo.MaintainMaterial_StockDraw b ON a.id=b.typeid AND b.currentstock>0  " + where;
        sql += "  GROUP BY a.ClassName";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql);
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0]));
    }
    /// <summary>
    /// 生成维修台账页面物料出库时当前维修台账录入人名下的物料型号列表combobox使用的json字符串，只显示有库存的
    /// </summary>
    public void GetTypeInfoComboboxForDailyRepair()
    {
        string queryStr = "";
        string where = "";
        //设置查询条件
        List<string> list = new List<string>();
        if (!string.IsNullOrEmpty(Request.QueryString["classname"]))
            list.Add(" classname ='" + Server.UrlDecode(Convert.ToString(Request.QueryString["classname"])) + "'");
        list.Add(" llr='" + Session["uname"] + "' ");
        if (list.Count > 0)
        {
            queryStr = string.Join(" and ", list.ToArray());
            where = "where " + queryStr;
        }
        string sql = "select distinct a.id,typename from MaintainMaterial_TypeInfo  a  JOIN  MaintainMaterial_StockDraw b ON a.id=b.TypeID AND b.currentstock>0 " + where;
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql);
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0]));
    }
    /// <summary>
    ///  根据不同的维修台账录入人名下的物料型号生成维修台账页面的出库单号的combogrid使用的json字符串，只显示有库存的
    /// </summary>
    public void GetOrderCombogridForDailyRepair()
    {
        string typeid = Convert.ToString(Request.Form["typeid"]);
        string where = " llr='" + Session["uname"] + "' and typeid=" + typeid;

        int total = 0;
        string table = "MaintainMaterial_TypeInfo  a  JOIN  MaintainMaterial_StockDraw b ON a.id=b.TypeID AND b.currentstock>0";
        string fieldStr = "b.id,typeid,b.Storeorderno,b.currentstock,a.units";

        DataSet ds = SqlHelper.GetPagination(table, fieldStr, Request["sort"].ToString(), Request["order"].ToString(), where, Convert.ToInt32(Request["rows"]), Convert.ToInt32(Request["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    //********************维修台账页面信息 end**********************************//
    #endregion 运维物料——物料型号
    #region 运维物料——领料单位,领料人
    /// <summary>
    /// 运维物料——领料单位
    /// 获取MaintainMaterial_AreaInfo表数据page:1 rows:10 sort:id order:asc
    public void GetMaintainMaterialAreaInfo()
    {
        int total = 0;
        string where = "";
        string fieldStr = "*";
        string table = "MaintainMaterial_AreaInfo";
        DataSet ds = SqlHelper.GetPagination(table, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    /// 通过ID获取MaintainMaterial_AreaInfo信息
    /// </summary>
    public void GetAreaInfoByID()
    {
        int classID = Convert.ToInt32(Request.Form["id"]);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = classID;
        string sql = "SELECT * FROM  MaintainMaterial_AreaInfo WHERE id=@id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    /// <summary>
    /// 保存AreaInfo信息
    /// </summary>
    public void SaveAreaInfo()
    {
        string areaname = Convert.ToString(Request.Form["areaname"]);
        SqlParameter[] paras = new SqlParameter[] { new SqlParameter("@areaname", areaname) };
        string sql = "if not exists( select id from MaintainMaterial_AreaInfo where areaname=@areaname)";
        sql += "INSERT INTO MaintainMaterial_AreaInfo VALUES(@areaname)";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"该领料单位已存在！\"}");
    }
    /// <summary>
    /// 通过id更新MaintainMaterial_AreaInfo表数据
    /// </summary>
    public void UpdateAreaInfo()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        string areaname = Convert.ToString(Request.Form["areaname"]);
        SqlParameter[] paras = new SqlParameter[] {
         new SqlParameter("@id",SqlDbType.Int),
         new SqlParameter("@areaname",SqlDbType.NVarChar)
        };
        paras[0].Value = id;
        paras[1].Value = areaname;
        string sql = "if not exists( select id from MaintainMaterial_AreaInfo where areaname=@areaname)";
        sql += "UPDATE MaintainMaterial_AreaInfo set areaname=@areaname where id=@id";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    /// <summary>
    /// 通过ID获取删除MaintainMaterial_AreaInfo信息
    /// </summary>
    public void RemoveAreaInfoByID()
    {
        int id = 0;
        int.TryParse(Request.Form["id"], out id);

        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = id;
        string sql = "DELETE FROM MaintainMaterial_AreaInfo WHERE id=@id";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    /// <summary>
    /// 生成MaintainMaterial_AreaInfo表的combobox使用的json字符串
    /// </summary>
    public void GetMaintainMaterial_AreaInfoCombobox()
    {
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, "select id,areaname from MaintainMaterial_AreaInfo  order by id");
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0]));
    }
    /// <summary>
    /// 生成MaintainMaterial_AreaInfo表的combobox使用的json字符串带“全部”
    /// </summary>
    public void GetMaintainMaterial_AreaInfoComboboxAll()
    {
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, "select id,areaname from MaintainMaterial_AreaInfo  order by id");
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0], 0));
    }
    /// <summary>
    /// 生成物料领取页面领料单位的combobox使用的json字符串
    /// </summary>
    public void GetMaintainMaterial_lldwCombobox()
    {
        string where = "";
        //if (roleid == "2")
        where = " where  a.deptname='" + deptname + "' ";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, "SELECT DISTINCT a.id,a.[deptname] FROM [dbo].[DeptInfo] a JOIN [dbo].[userinfo] b ON a.[deptname]=b.[deptname]  AND ([b].[roleid]=18 or [b].[roleid]=20 or [b].[roleid]=21 or [b].[roleid]=4)" + where);
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0]));
    }
    /// <summary>
    /// 生成物料领取页面领料人的combobox使用的json字符串；领料人为可以建立故障维修台账的角色为4，18，20，21
    /// </summary>
    public void GetllrComboboxForStockDraw()
    {
        string queryStr = "";
        string where = "";
        //设置查询条件
        List<string> list = new List<string>();
        if (!string.IsNullOrEmpty(Request.QueryString["lldw"]))
            list.Add(" deptname ='" + Server.UrlDecode(Convert.ToString(Request.QueryString["lldw"])) + "'");
        list.Add("  (roleid=18 or roleid=20 or roleid=21 or roleid=4) ");
        if (list.Count > 0)
        {
            queryStr = string.Join(" and ", list.ToArray());
            where = "where " + queryStr;
        }
        string sql = "select uid,uname FROM userinfo " + where;
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql);
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0]));
    }
    #endregion  运维物料——领料单位
    #region 运维物料——库存管理
    /// <summary>
    /// 设置库存管理查询条件
    /// </summary>
    /// <returns></returns>
    public string SetQueryConditionForStock()
    {
        string queryStr = "";
        //设置查询条件
        List<string> list = new List<string>();
        //按单位；//库管和故障维修工单工号只看自己库存
        if (Session["roleid"].ToString() == "2" || Session["roleid"].ToString() == "18")
        {
            list.Add(" a.unitname ='" + Session["deptname"].ToString() + "'");
        }
        else if (!string.IsNullOrEmpty(Request.Form["unitname"]) && Request.Form["unitname"] != "全部")
        {

            list.Add(" a.unitname ='" + Request.Form["unitname"] + "'");
        }
        //按物料类型
        if (!string.IsNullOrEmpty(Request.Form["classname"]))
            list.Add(" classname ='" + Request.Form["classname"] + "'");
        //按物料型号
        if (!string.IsNullOrEmpty(Request.Form["typeid"]))
            list.Add(" typeid =" + Request.Form["typeid"]);
        //按商城订单号
        if (!string.IsNullOrEmpty(Request.Form["storeorderno"]))
            list.Add(" storeorderno like '%" + Request.Form["storeorderno"] + "%'");
         //按是否有库存
        if (!string.IsNullOrEmpty(Request.Form["currentstock"]))
        {
            if (Request.Form["currentstock"] == "1")//有库存
                list.Add(" a.amount>0 ");
            if (Request.Form["currentstock"] == "0")//库存为0
                list.Add(" a.amount=0 ");
        }
        else//默认显示有库存
            list.Add(" a.amount>0 ");
        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 运维物料——库存管理
    /// 获取MaintainMaterial_Stock表数据page:1 rows:10 sort:id order:asc
    public void GetMaintainMaterialUnitStock()
    {
        int total = 0;
        string where = SetQueryConditionForStock();
        if (!string.IsNullOrEmpty(Request.Form["where"]))
            where = Server.UrlDecode(Request.Form["where"].ToString());
        string fieldStr = "a.id,a.unitname,a.storeorderno,b.classname,b.typename,a.amount,b.units,price";
        string table = "MaintainMaterial_Stock AS a JOIN MaintainMaterial_TypeInfo AS b ON a.typeid=b.id ";
        DataSet ds = SqlHelper.GetPagination(table, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    ///// <summary>
    ///// 通过基层单元名和物料型号获取当前库存信息
    ///// </summary>
    //public void GetCurrentStockByUnitNameAndTypeId()
    //{
    //    int typeid = Convert.ToInt32(Request.Form["typeid"]);
    //    string unitname = Convert.ToString(Session["deptname"]);
    //    SqlParameter[] paras = new SqlParameter[]
    //    { new SqlParameter("@typeid", SqlDbType.Int),
    //    new SqlParameter("@unitname", SqlDbType.VarChar)
    //    };
    //    paras[0].Value = typeid;
    //    paras[1].Value = unitname;
    //    string sql = "SELECT  isnull(ks.Amount,0) AS amount,kw.Units FROM MaintainMaterial_Stock AS ks right  JOIN MaintainMaterial_TypeInfo AS kw ON ks.TypeID=kw.ID AND  ks.UnitName=@unitname WHERE  kw.id=@typeid";
    //    DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
    //    Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    //}
    /// <summary>
    /// 保存单位库存录入信息
    /// </summary>
    public void SaveUnitStockInfo()
    {
        string llrq = Convert.ToString(Request.Form["llrq"]);
        string unitname = Convert.ToString(Server.UrlDecode(Request.Form["unitname"]));
        string memo = Convert.ToString(Server.HtmlEncode(Server.UrlDecode(Request.Form["memo"])));
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
        paras.Add(new SqlParameter("@unitname", unitname));
        paras.Add(new SqlParameter("@llrq", llrq));
        paras.Add(new SqlParameter("@memo", memo));
        //订单号集合
        ArrayList orderNoList = new ArrayList();
        //当前订单号
        string orderno;
        //判断重复订单号
        for (int i = 1; i <= rowsCount; i++)
        {
            orderno = Server.UrlDecode(Request.Form["storeorderno" + i.ToString()]).Trim();
            //页面录入的订单号判断
            if (orderNoList.Contains(orderno))
            {
                Response.Write("{\"success\":false,\"msg\":\"请不要输入重复的商城出库单号：" + orderno + "！\"}");
                return;
            }
            else
                orderNoList.Add(orderno);
            //与数据库中的订单号判断
            string sqlExists = "select count(1) from MaintainMaterial_Stock WHERE storeorderno=@storeorderno";
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
            paras.Add(new SqlParameter("@storeorderno" + i.ToString(), Server.UrlDecode(Request.Form["storeorderno" + i.ToString()])));
            paras.Add(new SqlParameter("@classname" + i.ToString(), Server.UrlDecode(Request.Form["classname" + i.ToString()])));
            paras.Add(new SqlParameter("@typeid" + i.ToString(), Request.Form["typeid" + i.ToString()]));
            paras.Add(new SqlParameter("@amount" + i.ToString(), Request.Form["amount" + i.ToString()]));
            paras.Add(new SqlParameter("@price" + i.ToString(), Request.Form["price" + i.ToString()]));
            paras.Add(new SqlParameter("@money" + i.ToString(), double.Parse(Request.Form["price" + i.ToString()]) * Int32.Parse(Request.Form["amount" + i.ToString()])));
            sql.Append(" INSERT INTO MaintainMaterial_Stock	VALUES(	@unitname,@storeorderno" + i.ToString() + ",@typeid" + i.ToString() + ",@amount" + i.ToString() + ",@price" + i.ToString() + "); ");
            sql.Append("INSERT INTO MaintainMaterial_KclrLog values(@llrq,@storeorderno" + i.ToString() + ",@unitname,@classname" + i.ToString() + ",@typeid" + i.ToString() + ",@amount" + i.ToString() + ",@price" + i.ToString() + ",@money" + i.ToString() + ",getdate(),@memo);");
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
    ///  检查故障单号是否存在
    /// </summary>
    public void CheckFaultOrderNo()
    {
        string faultorderno = Convert.ToString(Request.Form["faultorderno"]);
        SqlParameter paras = new SqlParameter("@faultorderno", SqlDbType.VarChar);
        paras.Value = faultorderno;
        string sql = "SELECT count(1) FROM SB_FaultOrderInfo  where faultorderno=@faultorderno";
        int result = (int)SqlHelper.ExecuteScalar(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 0)
            Response.Write("{\"success\":false,\"msg\":\"故障单号不存在!\"}");
        else
            Response.Write("{\"success\":true,\"msg\":\"故障单号存在!\"}");

    }
    /// <summary>
    /// 保存领料领取信息并减少库存
    /// </summary>
    public void SaveUnitStockDrawInfo()
    {
        string llrq = Convert.ToString(Request.Form["llrq"]);
        string lldw = Convert.ToString(Server.UrlDecode(Request.Form["lldw"]));
        string llr = Convert.ToString(Server.UrlDecode(Request.Form["llr"]));
        string memo = Convert.ToString(Server.HtmlEncode(Server.UrlDecode(Request.Form["memo"])));
        string lldpath = "";
        //获取数据行数
        int rowsCount = 0;
        Int32.TryParse(Request.Form["rowsCount"], out rowsCount);
        if (rowsCount == 0)
        {
            Response.Write("{\"success\":false,\"msg\":\"请录入领料信息\"}");
            return;
        }
        //判断是否上传领料单照片
        if (String.IsNullOrEmpty(Request.Form["lldpath"]))
        {
            Response.Write("{\"success\":false,\"msg\":\"请上传领料单照片!\"}");
            return;
        }
        else
            lldpath = Convert.ToString(Request.Form["lldpath"]);

        //订单号集合
        ArrayList orderNoList = new ArrayList();
        //当前订单号
        string orderno;
        //判断重复订单号
        for (int i = 1; i <= rowsCount; i++)
        {
            orderno = Server.UrlDecode(Request.Form["storeorderno" + i.ToString()]).Trim();
            //页面录入的订单号判断
            if (orderNoList.Contains(orderno))
            {
                Response.Write("{\"success\":false,\"msg\":\"请不要重复选择商城出库单号：" + orderno + "！\"}");
                return;
            }
            else
                orderNoList.Add(orderno);
        }
        //根据数据行数生成sql语句和参数列表
        StringBuilder sql = new StringBuilder();
        List<SqlParameter> paras = new List<SqlParameter>();
        paras.Add(new SqlParameter("@unitname", Session["deptname"]));
        paras.Add(new SqlParameter("@llrq", llrq));
        paras.Add(new SqlParameter("@lldw", lldw));
        paras.Add(new SqlParameter("@llr", llr));
        paras.Add(new SqlParameter("@memo", memo));
        paras.Add(new SqlParameter("@lldpath", lldpath));
        paras.Add(new SqlParameter("@inputuser", uname));
        for (int i = 1; i <= rowsCount; i++)
        {
            paras.Add(new SqlParameter("@typeid" + i.ToString(), Request.Form["typeid" + i.ToString()]));
            paras.Add(new SqlParameter("@storeorderno" + i.ToString(), Server.UrlDecode(Request.Form["storeorderno" + i.ToString()])));
            paras.Add(new SqlParameter("@amount" + i.ToString(), Request.Form["amount" + i.ToString()]));
            sql.Append(" UPDATE MaintainMaterial_Stock 	SET Amount =amount-@amount" + i.ToString() + "	where unitname = @unitname AND TypeID = @typeid" + i.ToString() + " and storeorderno=@storeorderno" + i.ToString() + "; ");
            sql.Append("INSERT INTO MaintainMaterial_StockDraw values(@storeorderno" + i.ToString() + ",@llrq,@unitname,@lldw,@llr,@typeid" + i.ToString() + ",@amount" + i.ToString() + ",@inputuser,getdate(),@memo,@lldpath,@amount" + i.ToString() + ");");
        }
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), paras.ToArray());
        if (result > 0)
            Response.Write("{\"success\":true,\"msg\":\"提交成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    /// <summary>
    /// 保存领料单位领料信息并减少库存
    /// </summary>
    public void SaveUnitStockOutInfo()
    {
        string ckrq = Convert.ToString(Request.Form["ckrq"]);
        string llr = Convert.ToString(Server.UrlDecode(Request.Form["llr"]));
        string faultorderno = Convert.ToString(Request.Form["faultorderno"]);
        string memo = Convert.ToString(Server.HtmlEncode(Server.UrlDecode(Request.Form["memo"])));
        int areaid = Convert.ToInt32(Request.Form["areaid"]);
        string lldpath = "";
        //获取数据行数
        int rowsCount = 0;
        Int32.TryParse(Request.Form["rowsCount"], out rowsCount);
        if (rowsCount == 0)
        {
            Response.Write("{\"success\":false,\"msg\":\"请录入领料信息\"}");
            return;
        }
        //判断故障单号是否存在
        if ((int)SqlHelper.ExecuteScalar(SqlHelper.GetConnection(), CommandType.Text, "SELECT count(1) FROM SB_FaultOrderInfo  where faultorderno=@faultorderno", new SqlParameter("@faultorderno", faultorderno)) == 0)
        {
            Response.Write("{\"success\":false,\"msg\":\"故障单号不存在!\"}");
            return;
        }
        //判断是否上传领料单照片
        if (String.IsNullOrEmpty(Request.Form["lldpath"]))
        {
            Response.Write("{\"success\":false,\"msg\":\"请上传领料单照片!\"}");
            return;
        }
        else
            lldpath = Convert.ToString(Request.Form["lldpath"]);

        //订单号集合
        ArrayList orderNoList = new ArrayList();
        //当前订单号
        string orderno;
        //判断重复订单号
        for (int i = 1; i <= rowsCount; i++)
        {
            orderno = Server.UrlDecode(Request.Form["storeorderno" + i.ToString()]).Trim();
            //页面录入的订单号判断
            if (orderNoList.Contains(orderno))
            {
                Response.Write("{\"success\":false,\"msg\":\"请不要重复选择商城出库单号：" + orderno + "！\"}");
                return;
            }
            else
                orderNoList.Add(orderno);
        }
        //根据数据行数生成sql语句和参数列表
        StringBuilder sql = new StringBuilder();
        List<SqlParameter> paras = new List<SqlParameter>();
        paras.Add(new SqlParameter("@unitname", Session["deptname"]));
        paras.Add(new SqlParameter("@ckrq", ckrq));
        paras.Add(new SqlParameter("@areaid", areaid));
        paras.Add(new SqlParameter("@llr", llr));
        paras.Add(new SqlParameter("@faultorderno", faultorderno));
        paras.Add(new SqlParameter("@memo", memo));
        paras.Add(new SqlParameter("@lldpath", lldpath));
        for (int i = 1; i <= rowsCount; i++)
        {
            paras.Add(new SqlParameter("@typeid" + i.ToString(), Request.Form["typeid" + i.ToString()]));
            paras.Add(new SqlParameter("@storeorderno" + i.ToString(), Server.UrlDecode(Request.Form["storeorderno" + i.ToString()])));
            paras.Add(new SqlParameter("@amount" + i.ToString(), Request.Form["amount" + i.ToString()]));
            sql.Append(" UPDATE MaintainMaterial_Stock 	SET Amount =amount-@amount" + i.ToString() + "	where unitname = @unitname AND TypeID = @typeid" + i.ToString() + " and storeorderno=@storeorderno" + i.ToString() + "; ");
            sql.Append("INSERT INTO MaintainMaterial_StockOut values(@storeorderno" + i.ToString() + ",@ckrq,@unitname,@areaid,@llr,@typeid" + i.ToString() + ",@amount" + i.ToString() + ",getdate(),@memo,@faultorderno,@lldpath);");
        }
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), paras.ToArray());
        if (result > 0)
            Response.Write("{\"success\":true,\"msg\":\"提交成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    /// <summary>
    /// 导出运维物料库存表
    /// /// </summary>
    public void ExportUnitStock()
    {
        string where = SetQueryConditionForStock();
        if (where != "")
            where = " where " + where;
        StringBuilder sql = new StringBuilder();
        sql.Append("select a.id,a.unitname,a.storeorderno,b.classname,b.typename,a.amount,b.units,price ");
        sql.Append(" from MaintainMaterial_Stock AS a JOIN MaintainMaterial_TypeInfo AS b ON a.typeid=b.id ");
        sql.Append(where);
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.Columns[0].ColumnName = "序号";
        dt.Columns[1].ColumnName = "单位名称";
        dt.Columns[2].ColumnName = "商城出库单号";
        dt.Columns[3].ColumnName = "物料类型";
        dt.Columns[4].ColumnName = "物料型号";
        dt.Columns[5].ColumnName = "库存数量";
        dt.Columns[6].ColumnName = "单位";
        dt.Columns[7].ColumnName = "单价";
        MyXls.CreateXls(dt, "运维物料库存表.xls", "2,4");
        Response.Flush();
        Response.End();
    }
    #endregion 运维物料——库存管理
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
        if (Session["roleid"].ToString() == "2")
        {
            list.Add(" kkl.unitname ='" + Session["deptname"].ToString() + "'");
        }
        else if (!string.IsNullOrEmpty(Request.Form["unitname"]) && Request.Form["unitname"] != "全部")
        {

            list.Add(" kkl.unitname ='" + Request.Form["unitname"] + "'");
        }
        //按物料类型
        if (!string.IsNullOrEmpty(Request.Form["classname"]))
            list.Add(" kw.classname ='" + Request.Form["classname"] + "'");
        //按物料型号
        if (!string.IsNullOrEmpty(Request.Form["typeid"]))
            list.Add(" typeid =" + Request.Form["typeid"]);
        //按商城订单号
        if (!string.IsNullOrEmpty(Request.Form["storeorderno"]))
            list.Add(" storeorderno like '%" + Request.Form["storeorderno"] + "%'");
        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 运维物料物料入库明细
    /// </summary>
    public void GetUnitInStockDetail()
    {
        int total = 0;
        string where = SetQueryConditionForInStock();
        if (!string.IsNullOrEmpty(Request.Form["where"]))
            where = Server.UrlDecode(Request.Form["where"].ToString());
        string fieldStr = "kkl.id,kkl.llrq,kkl.storeorderno,kkl.unitname,kw.classname,kkl.typeid,kw.TypeName,kkl.amount,kw.Units,price,money,kkl.inputtime,kkl.memo";
        string table = "MaintainMaterial_KclrLog AS kkl JOIN  MaintainMaterial_TypeInfo AS kw ON kkl.typeid=kw.ID";
        DataSet ds = SqlHelper.GetPagination(table, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    /// 导出入库明细
    /// </summary>
    public void ExportUnitInStockDetail()
    {
        string where = SetQueryConditionForInStock();
        if (where != "")
            where = " where " + where;
        StringBuilder sql = new StringBuilder();
        sql.Append("select   kkl.id,kkl.llrq,kkl.storeorderno,kkl.unitname,kw.classname,kw.TypeName,kkl.amount,kw.Units,price,money,kkl.memo,kkl.inputtime  FROM MaintainMaterial_KclrLog AS kkl JOIN  MaintainMaterial_TypeInfo AS kw ON kkl.typeid=kw.ID ");
        sql.Append(where);
        sql.Append(" order by kkl.id ");
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.Columns[0].ColumnName = "序号";
        dt.Columns[1].ColumnName = "入库日期";
        dt.Columns[2].ColumnName = "商城出库单号";
        dt.Columns[3].ColumnName = "入库单位";
        dt.Columns[4].ColumnName = "物料类型";
        dt.Columns[5].ColumnName = "物料型号 ";
        dt.Columns[6].ColumnName = "入库数量";
        dt.Columns[7].ColumnName = "单位";
        dt.Columns[8].ColumnName = "单价";
        dt.Columns[9].ColumnName = "金额";
        dt.Columns[10].ColumnName = "备注";
        dt.Columns[11].ColumnName = "录入时间";
        MyXls.CreateXls(dt, "运维物料入库明细.xls", "2,5,10,11");
        Response.Flush();
        Response.End();
    }
    #endregion 库存入库明细
    #region 领料单位领料明细
    /// <summary>
    /// 设置领料单位领料明细查询条件
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
        if (Session["roleid"].ToString() == "2")
        {
            list.Add(" a.unitname ='" + Session["deptname"].ToString() + "'");
        }
        else if (!string.IsNullOrEmpty(Request.Form["unitname"]) && Request.Form["unitname"] != "全部")
        {

            list.Add(" a.unitname ='" + Request.Form["unitname"] + "'");
        }
        if (roleid == "18" || roleid == "20" || roleid == "21")//故障维修、能耗、能耗管理员
        {
            list.Add(" a.llr ='" + Session["uname"].ToString() + "'");

        }
        //按领料单位
        if (!string.IsNullOrEmpty(Request.Form["areaid"]))
            list.Add(" a.areaid =" + Request.Form["areaid"]);
        //按物料类型
        if (!string.IsNullOrEmpty(Request.Form["classname"]))
            list.Add(" classname ='" + Request.Form["classname"] + "'");
        //按物料型号
        if (!string.IsNullOrEmpty(Request.Form["typeid"]))
            list.Add(" a.typeid =" + Request.Form["typeid"]);
        //按商城订单号
        if (!string.IsNullOrEmpty(Request.Form["storeorderno"]))
            list.Add(" a.storeorderno like '%" + Request.Form["storeorderno"] + "%'");
        //按是否有库存
        if (!string.IsNullOrEmpty(Request.Form["currentstock"]))
        {
            if (Request.Form["currentstock"] == "1")//有库存
                list.Add(" a.currentstock>0 ");
            if (Request.Form["currentstock"] == "0")//库存为0
                list.Add(" a.currentstock=0 ");
        }
        else//默认显示有库存
            list.Add(" a.currentstock>0 ");
        list.Add(" a.storeorderno like '%" + Request.Form["storeorderno"] + "%'");
        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 领料单位领料明细
    /// </summary>
    public void GetUnitOutStockDetail()
    {
        int total = 0;
        string where = SetQueryConditionForOutStock();
        if (!string.IsNullOrEmpty(Request.Form["where"]))
            where = Server.UrlDecode(Request.Form["where"].ToString());
        string fieldStr = "a.id,a.ckrq,a.unitname,c.AreaName,a.llr,a.storeorderno,b.classname,b.TypeName,a.currentstock,b.Units,d.price,a.currentstock*d.price as allFee,a.memo,a.faultorderno,a.lldpath";
        string table = "MaintainMaterial_StockOut AS a JOIN MaintainMaterial_TypeInfo AS b ON a.typeid=b.ID JOIN MaintainMaterial_AreaInfo AS c ON a.areaid=c.ID left join MaintainMaterial_Stock d on a.storeorderno=d.storeorderno ";
        DataSet ds = SqlHelper.GetPagination(table, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    /// 物料领用管理
    /// </summary>
    public void GetUnitDrawStockDetail()
    {
        int total = 0;
        string where = SetQueryConditionForOutStock();
        if (!string.IsNullOrEmpty(Request.Form["where"]))
            where = Server.UrlDecode(Request.Form["where"].ToString());
        string fieldStr = "a.id,a.llrq,a.unitname,a.lldw,a.llr,a.storeorderno,b.classname,b.TypeName,a.amount,a.currentstock,b.Units,d.price,a.amount*d.price as allFee,a.memo,a.lldpath,a.inputuser";
        string table = "MaintainMaterial_StockDraw AS a JOIN MaintainMaterial_TypeInfo AS b ON a.typeid=b.ID  left join MaintainMaterial_Stock d on a.storeorderno=d.storeorderno ";
        DataSet ds = SqlHelper.GetPagination(table, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    /// 导出领料单位领料明细
    /// </summary>
    public void ExportUnitDrawStockDetail()
    {
        string where = SetQueryConditionForOutStock();
        if (where != "")
            where = " where " + where;
        StringBuilder sql = new StringBuilder();
        sql.Append("SELECT a.llrq,a.unitname,a.lldw,a.llr,a.storeorderno,b.classname,b.TypeName,a.amount,a.currentstock,b.Units,d.price,a.amount*d.price as allFee,a.memo");
        sql.Append(" FROM MaintainMaterial_StockDraw AS a JOIN MaintainMaterial_TypeInfo AS b ON a.typeid=b.ID  left join MaintainMaterial_Stock d on a.storeorderno=d.storeorderno ");
        sql.Append(where);
        sql.Append(" order by a.id ");
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.Columns[0].ColumnName = "领料日期";
        dt.Columns[1].ColumnName = "出库单位";
        dt.Columns[2].ColumnName = "领料单位";
        dt.Columns[3].ColumnName = "领料人";
        dt.Columns[4].ColumnName = "商城出库单号";
        dt.Columns[5].ColumnName = "物料类型";
        dt.Columns[6].ColumnName = "物料型号";
        dt.Columns[7].ColumnName = "领取数量";
        dt.Columns[8].ColumnName = "当前库存";
        dt.Columns[9].ColumnName = "单位";
        dt.Columns[10].ColumnName = "单价（元）";
        dt.Columns[11].ColumnName = "金额（元）";
        dt.Columns[12].ColumnName = "备注";
        ExcelHelper.ExportByWeb(dt, "", "物料领用管理.xls", "物料领用管理");
    }
    /// <summary>
    /// 导出领料单位领料明细
    /// </summary>
    public void ExportUnitOutStockDetail()
    {
        string where = SetQueryConditionForOutStock();
        if (where != "")
            where = " where " + where;
        StringBuilder sql = new StringBuilder();
           
        sql.Append("SELECT a.ckrq,a.unitname,c.AreaName,a.llr,a.storeorderno,b.classname,b.TypeName,a.currentstock,b.Units,d.price,a.currentstock*d.price as allFee,a.memo,a.faultorderno");
        sql.Append(" from  MaintainMaterial_StockOut AS a JOIN MaintainMaterial_TypeInfo AS b ON a.typeid=b.ID JOIN MaintainMaterial_AreaInfo AS c ON a.areaid=c.ID left join MaintainMaterial_Stock d on a.storeorderno=d.storeorderno ");
        sql.Append(where);
        sql.Append(" order by a.id ");
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.Columns[0].ColumnName = "领料日期";
        dt.Columns[1].ColumnName = "出库单位";
        dt.Columns[2].ColumnName = "领料单位";
        dt.Columns[3].ColumnName = "领料人";
        dt.Columns[4].ColumnName = "商城出库单号";
        dt.Columns[5].ColumnName = "物料类型";
        dt.Columns[6].ColumnName = "物料型号";
        dt.Columns[7].ColumnName = "领取数量";
        dt.Columns[8].ColumnName = "单位";
        dt.Columns[9].ColumnName = "单价（元）";
        dt.Columns[10].ColumnName = "金额（元）";
        dt.Columns[11].ColumnName = "备注";
        dt.Columns[12].ColumnName = "故障单号";
        ExcelHelper.ExportByWeb(dt, "", "领料明细（旧）.xls", "领料明细");
    }
    /*
/// <summary>
/// 导出领料单位领料明细
/// </summary>
public void ExportUnitOutStockDetail()
{
    string where = SetQueryConditionForOutStock();
    if (where != "")
        where = " where " + where;
    StringBuilder sql = new StringBuilder();
    sql.Append("SELECT a.ckrq,a.unitname,c.AreaName,a.llr,a.storeorderno,a.faultorderno,b.classname,b.TypeName,a.amount,b.Units,d.price,a.amount*d.price as allFee,a.memo");
    sql.Append(" FROM MaintainMaterial_StockOut AS a JOIN MaintainMaterial_TypeInfo AS b ON a.typeid=b.ID JOIN MaintainMaterial_AreaInfo AS c ON a.areaid=c.ID left join MaintainMaterial_Stock d on a.storeorderno=d.storeorderno ");
    sql.Append(where);
    sql.Append(" order by a.id ");
    DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
    DataTable dt = ds.Tables[0];
    dt.Columns[0].ColumnName = "出库日期";
    dt.Columns[1].ColumnName = "出库单位";
    dt.Columns[2].ColumnName = "领料单位";
    dt.Columns[3].ColumnName = "领料人";
    dt.Columns[4].ColumnName = "商城出库单号";
    dt.Columns[5].ColumnName = "故障单号";
    dt.Columns[6].ColumnName = "物料类型";
    dt.Columns[7].ColumnName = "物料型号";
    dt.Columns[8].ColumnName = "数量";
    dt.Columns[9].ColumnName = "单位";
    dt.Columns[10].ColumnName = "单价（元）";
    dt.Columns[11].ColumnName = "金额（元）";
    dt.Columns[12].ColumnName = "备注";
    MyXls.CreateXls(dt, "领料单位领料明细.xls", "4,7");
    Response.Flush();
    Response.End();
}
    */
    #endregion 领料单位领料明细
    #region 物料调拨
    /// <summary>
    /// 通过ID获取被调拨物料的库存信息
    /// </summary>
    public void GetMaintainMaterialStockById()
    {
        int id = 0;
        int.TryParse(Request.Form["id"], out id);
        string sql = "select  a.id,a.unitname,a.storeorderno,b.classname,b.typename,a.amount,b.units  from  MaintainMaterial_Stock AS a JOIN MaintainMaterial_TypeInfo AS b ON a.typeid=b.id where a.id=@id";
        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = id;
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    /// <summary>
    /// 获取要调拨的单位信息
    /// </summary>
    public void GetAllotUnitInfoCombobox()
    {
        string unitname = Server.UrlDecode(Convert.ToString(Request.QueryString["id"]));
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, "select id,unitname from MaintainMaterial_UnitInfo WHERE UnitName<>@unitname ", new SqlParameter("@unitname", unitname));
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0]));
    }
    /// <summary>
    /// 保存领料单位物料调拨信息
    /// </summary>
    public void SaveUnitAllotStockInfo()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        int allotunitid = Convert.ToInt32(Request.Form["allotunitid"]);
        int allotnum = Convert.ToInt32(Request.Form["allotnum"]);
        string allotrq = DateTime.Now.ToString("yyyy-MM-dd");
        string memo = Convert.ToString(Server.HtmlEncode(Request.Form["memo"]));
        string reportpath = "";
        //判断是否上传调拨单
        if (String.IsNullOrEmpty(Request.Form["report"]))
        {
            Response.Write("{\"success\":false,\"msg\":\"请上传调拨单!\"}");
            return;
        }
        else
            reportpath = Convert.ToString(Request.Form["report"]);

        //生成库存表中调拨单编号
        Random myrdn = new Random();//产生随机数
        string allotOrderNo = "Allot-" + DateTime.Now.ToString("yyyyMMddhhmmss") + myrdn.Next(1000);
        //根据数据行数生成sql语句和参数列表
        StringBuilder sql = new StringBuilder();
        List<SqlParameter> paras = new List<SqlParameter>();
        paras.Add(new SqlParameter("@id", id));
        paras.Add(new SqlParameter("@allotunitid", allotunitid));
        paras.Add(new SqlParameter("@allotnum", allotnum));
        paras.Add(new SqlParameter("@allotrq", allotrq));
        paras.Add(new SqlParameter("@memo", memo));
        paras.Add(new SqlParameter("@allotorderno", allotOrderNo));
        paras.Add(new SqlParameter("@allotuser", Session["uname"].ToString()));
        paras.Add(new SqlParameter("@reportpath", reportpath));

        sql.Append("IF EXISTS(SELECT * FROM  dbo.MaintainMaterial_Stock WHERE id=@id AND Amount>=@allotnum) ");
        sql.Append(" begin ");
        sql.Append("INSERT INTO dbo.MaintainMaterial_Allotlog SELECT @allotrq,@allotunitid,@allotorderno,Storeorderno,UnitName,TypeID,@allotnum,Price,@allotnum*Price,GETDATE(),@memo,@allotuser,@reportpath FROM dbo.MaintainMaterial_Stock WHERE id=@id;");
        sql.Append(" UPDATE dbo.MaintainMaterial_Stock SET Amount=Amount-@allotnum WHERE id=@id; ");
        sql.Append(" INSERT INTO dbo.MaintainMaterial_Stock SELECT b.UnitName, @allotorderno, TypeID, @allotnum, Price FROM dbo.MaintainMaterial_Stock as a join MaintainMaterial_UnitInfo b  on a.id = @id and b.id=@allotunitid; ");
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
        if (Session["roleid"].ToString() == "2")
        {
            list.Add(" (c.unitname ='" + Session["deptname"].ToString() + "' or a.oldunitname='" + Session["deptname"].ToString() + "' ) ");
        }
        else if (!string.IsNullOrEmpty(Request.Form["unitname"]) && Request.Form["unitname"] != "全部")
        {

            list.Add(" c.unitname ='" + Request.Form["unitname"] + "'");
        }
        if (!string.IsNullOrEmpty(Request.Form["oldunitname"]) && Request.Form["oldunitname"] != "全部")
        {

            list.Add(" a.oldunitname ='" + Request.Form["oldunitname"] + "'");
        }

        //按物料类型
        if (!string.IsNullOrEmpty(Request.Form["classname"]))
            list.Add(" classname ='" + Request.Form["classname"] + "'");
        //按物料型号
        if (!string.IsNullOrEmpty(Request.Form["typeid"]))
            list.Add(" a.typeid =" + Request.Form["typeid"]);
        //按商城订单号
        if (!string.IsNullOrEmpty(Request.Form["storeorderno"]))
            list.Add(" storeorderno like '%" + Request.Form["storeorderno"] + "%'");
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
        string fieldStr = "a.id,a.allotrq,c.unitname as allotunitname,a.AllotOrderNo,a.storeorderno,a.oldunitname,b.classname,b.TypeName,a.allotnum,b.Units,price,money,a.inputtime,a.memo,a.allotuser,a.reportpath";
        string table = "MaintainMaterial_Allotlog AS a JOIN  MaintainMaterial_TypeInfo AS b ON a.typeid=b.ID join MaintainMaterial_UnitInfo c on  a.allotUnitID=c.id ";
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
        sql.Append("select a.id,a.allotrq,c.unitname as allotunitname,a.AllotOrderNo,a.storeorderno,a.oldunitname,b.classname,b.TypeName,a.allotnum,b.Units,price,money,a.memo,a.inputtime,a.allotuser  FROM MaintainMaterial_Allotlog AS a JOIN  MaintainMaterial_TypeInfo AS b ON a.typeid=b.ID join MaintainMaterial_UnitInfo c on  a.allotUnitID=c.id ");
        sql.Append(where);
        sql.Append(" order by a.id ");
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.Columns[0].ColumnName = "序号";
        dt.Columns[1].ColumnName = "调拨日期";
        dt.Columns[2].ColumnName = "单位名称";
        dt.Columns[3].ColumnName = "调拨单号";
        dt.Columns[4].ColumnName = "原商城订单号";
        dt.Columns[5].ColumnName = "调拨单位";
        dt.Columns[6].ColumnName = "物料类型";
        dt.Columns[7].ColumnName = "物料型号";
        dt.Columns[8].ColumnName = "调拨数量";
        dt.Columns[9].ColumnName = "单位";
        dt.Columns[10].ColumnName = "单价（元）";
        dt.Columns[11].ColumnName = "金额（元）";
        dt.Columns[12].ColumnName = "备注";
        dt.Columns[13].ColumnName = "调拨时间";
        dt.Columns[14].ColumnName = "调拨人";
        MyXls.CreateXls(dt, "运维物料调拨明细表.xls", "4,7,12,13");
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