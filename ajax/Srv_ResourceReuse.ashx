<%@ WebHandler Language="C#" Class="Srv_ResourceReuse" %>

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
/// 资源盘活
/// </summary>
public class Srv_ResourceReuse : IHttpHandler, IRequiresSessionState
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
    #region 盘活资源——资源类别
    /// <summary>
    /// 盘活资源——资源类别
    /// 获取RR_TypeInfo表数据page:1 rows:10 sort:id order:asc
    public void GetRRTypeInfo()
    {
        int total = 0;
        string where = "";
        if (!string.IsNullOrEmpty(Request.Form["typeid"]))
            where += " id= " + Request.Form["typeid"] + " and";
        if (where.Length > 0)
            where = where.Substring(0, where.Length - 3);
        string fieldStr = "*";
        string table = "RR_TypeInfo";
        DataSet ds = SqlHelper.GetPagination(table, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    /// 通过ID获取资源类别信息
    /// </summary>
    public void GetTypeInfoByID()
    {
        int classID = Convert.ToInt32(Request.Form["id"]);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = classID;
        string sql = "SELECT * FROM  RR_TypeInfo WHERE id=@id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    /// <summary>
    /// 保存资源类别信息
    /// </summary>
    public void SaveTypeInfo()
    {
        string price = Convert.ToString(Request.Form["price"]);
        string typeName = Convert.ToString(Request.Form["typename"]);
        string units = Convert.ToString(Request.Form["units"]);
        SqlParameter[] paras = new SqlParameter[] { new SqlParameter("@price", price), new SqlParameter("@typename", typeName), new SqlParameter("@units", units) };
        string sql = "if not exists( select id from RR_TypeInfo where price=@price and typename=@typename)";
        sql += "INSERT INTO RR_TypeInfo VALUES(@typename,@price,@units)";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"该资源类别已存在！\"}");
    }
    /// <summary>
    /// 通过id更新RR_TypeInfo表数据
    /// </summary>
    public void UpdateTypeInfo()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        string price = Convert.ToString(Request.Form["price"]);
        string typeName = Convert.ToString(Request.Form["typename"]);
        string units = Convert.ToString(Request.Form["units"]);
        SqlParameter[] paras = new SqlParameter[] {
         new SqlParameter("@id",SqlDbType.Int),
         new SqlParameter("@price",SqlDbType.Decimal),
         new SqlParameter("@typename",SqlDbType.NVarChar),
         new SqlParameter("@units",SqlDbType.NVarChar)
        };
        paras[0].Value = id;
        paras[1].Value = price;
        paras[2].Value = typeName;
        paras[3].Value = units;
        string sql = "if not exists( select id from RR_TypeInfo where  price=@price and typename=@typename)";
        sql += "UPDATE RR_TypeInfo set price=@price,typename=@typename,units=@units where id=@id";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"该资源类别已存在\"}");
    }
    /// <summary>
    /// 通过ID获取删除资源类别信息
    /// </summary>
    public void RemoveTypeInfoByID()
    {
        int id = 0;
        int.TryParse(Request.Form["id"], out id);

        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = id;
        string sql = "DELETE FROM RR_TypeInfo WHERE id=@id";
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    /// <summary>
    /// 通过物料类型生成入库页面资源类别combobox
    /// </summary>
    public void GetRR_TypeInfoComboboxForIn()
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
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, "select id,typename from RR_TypeInfo " + where + " order by id");
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0], 2));
    }
    /// <summary>
    /// 生成资源类别列表combobox使用的json字符串
    /// </summary>
    public void GetTypeInfoCombobox()
    {
        string sql = "select id,typename from RR_TypeInfo  order by id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql);
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0]));
    }
    /// <summary>
    /// 生成资源类别列表combobox使用的json字符串带全部
    /// </summary>
    public void GetTypeInfoComboboxAll()
    {
        string sql = "select id,typename from RR_TypeInfo  order by id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql);
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0], 0));
    }
    /// <summary>
    /// 生成领料页面的资源类别列表combobox使用的json字符串，只显示有库存的
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
        string sql = "select distinct a.id,typename from RR_TypeInfo  a  JOIN  RR_Stock b ON a.id=b.TypeID AND b.Amount>0 " + where;
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql);
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0]));
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
        string sql = "select  ROW_NUMBER() OVER (ORDER BY  a.ClassName)   AS rowid,a.ClassName  from RR_TypeInfo  a  JOIN  RR_Stock b ON a.id=b.TypeID AND b.Amount>0 " + where;
        sql += "  GROUP BY a.ClassName";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql);
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0]));
    }

    #endregion 盘活资源——资源类别
    /// <summary>
    /// 生成网格名称combobox使用的json字符串
    /// </summary>
    public void GetGridInfoCombobox()
    {
        string queryStr = "";
        string where = "";
        //设置查询条件
        List<string> list = new List<string>();
        if (roleid != "0")
            list.Add(" deptname='" + deptname + "' ");
        if (list.Count > 0)
        {
            queryStr = string.Join(" and ", list.ToArray());
            where = "where " + queryStr;
        }
        string sql = "select id,gridname from RR_GridInfo " + where;
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql);
        Response.Write(JsonConvert.CreateComboboxJson(ds.Tables[0]));
    }
    #region 盘活资源——库存管理
    /// <summary>
    /// 生成资源编号
    /// </summary>
    public string GetRRID()
    {
        DataSet dr = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, "SELECT RRid  FROM RR_AutoNo");
        string currentId = dr.Tables[0].Rows[0][0].ToString();
        int newno = 0;
        string datePre = DateTime.Now.ToString("yyyyMM");
        string autono = "";
        if (currentId.Substring(0, 6) == datePre)
            newno = int.Parse(currentId.Substring(6)) + 1;

        else
            newno = 1;
        autono += datePre + newno.ToString().PadLeft(3, '0');
        return autono;
    }
    /// <summary>
    /// 保存单位库存录入信息
    /// </summary>
    public void SaveRRStockInfo()
    {
        string indate = Convert.ToString(Request.Form["indate"]);
        string unitname = Session["deptname"].ToString();
        string RRid = GetRRID();
        string gridid = Convert.ToString(Request.Form["gridid"]);
        string typeid = Convert.ToString(Request.Form["typeid"]);
        string AssetsNo = Convert.ToString(Request.Form["AssetsNo"]);
        string amount = Convert.ToString(Request.Form["amount"]);
        string linkman = Convert.ToString(Request.Form["linkman"]);
        string linkphone = Convert.ToString(Request.Form["linkphone"]);
        string Location = Convert.ToString(Server.HtmlEncode(Server.UrlDecode(Request.Form["Location"])));
        string memo = Convert.ToString(Server.HtmlEncode(Server.UrlDecode(Request.Form["memo"])));
        //根据数据行数生成sql语句和参数列表
        StringBuilder sql = new StringBuilder();
        List<SqlParameter> paras = new List<SqlParameter>();
        paras.Add(new SqlParameter("@indate", indate));
        paras.Add(new SqlParameter("@unitname", unitname));
        paras.Add(new SqlParameter("@RRid", RRid));
        paras.Add(new SqlParameter("@gridid", gridid));
        paras.Add(new SqlParameter("@typeid", typeid));
        paras.Add(new SqlParameter("@AssetsNo", AssetsNo));
        paras.Add(new SqlParameter("@amount", amount));
        paras.Add(new SqlParameter("@linkman", linkman));
        paras.Add(new SqlParameter("@linkphone", linkphone));
        paras.Add(new SqlParameter("@Location", Location));
        paras.Add(new SqlParameter("@memo", memo));
        sql.Append(" INSERT INTO RR_StockInfo	VALUES(	@RRid,@indate,@unitname,@gridid,@typeid,@AssetsNo,@amount,@amount,@Location,@linkman,@linkphone,getdate(),@memo); ");
        sql.Append(" update RR_AutoNo set RRid= @RRid; ");
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
                    Response.Write("{\"success\":true,\"msg\":\"资源录入成功!\"}");
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
    #endregion 盘活资源——库存管理
    #region 物资领用
    /// <summary>
    /// 通过ID获取被物资的库存信息
    /// </summary>
    public void GetResourceReuseStockById()
    {
        int id = 0;
        int.TryParse(Request.Form["id"], out id);
        string sql = "select  a.id,a.rrid,a.unitname,b.TypeName,a.currentstock,b.Units  from  dbo.RR_StockInfo AS a JOIN  RR_TypeInfo AS b ON a.typeid=b.ID  where a.id=@id";
        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = id;
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    /// <summary>
    /// 保存资源领用信息
    /// </summary>
    public void SaveRRReceiveInfo()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        string receiveunitname = Convert.ToString(Request.Form["receiveunitname"]);
        int receivenum = Convert.ToInt32(Request.Form["receivenum"]);
        string outdate = Convert.ToString(Request.Form["outdate"]);
        string signno = Convert.ToString(Request.Form["signno"]);
        string receiveman = Convert.ToString(Request.Form["receiveman"]);
        string receivephone = Convert.ToString(Request.Form["receivephone"]);
        string usefor = Convert.ToString(Server.HtmlEncode(Request.Form["usefor"]));
        string useplace = Convert.ToString(Server.HtmlEncode(Request.Form["useplace"]));
        string memo = Convert.ToString(Server.HtmlEncode(Request.Form["memo"]));
        //根据数据行数生成sql语句和参数列表
        StringBuilder sql = new StringBuilder();
        List<SqlParameter> paras = new List<SqlParameter>();
        paras.Add(new SqlParameter("@id", id));
        paras.Add(new SqlParameter("@outdate", outdate));
        paras.Add(new SqlParameter("@receiveunitname", receiveunitname));
        paras.Add(new SqlParameter("@receivenum", receivenum));
        paras.Add(new SqlParameter("@receiveman", receiveman));
        paras.Add(new SqlParameter("@receivephone", receivephone));
        paras.Add(new SqlParameter("@signno", signno));
        paras.Add(new SqlParameter("@usefor", usefor));
        paras.Add(new SqlParameter("@useplace", useplace));
        paras.Add(new SqlParameter("@memo", memo));

        sql.Append("IF EXISTS(SELECT * FROM  dbo.RR_StockInfo WHERE id=@id AND currentstock>=@receivenum) ");
        sql.Append(" begin ");
        sql.Append("INSERT INTO dbo.RR_StockDrawInfo SELECT rrid,@outdate,@receiveunitname,typeid,@receivenum,@signno,@usefor,@useplace,@receiveman,@receivephone,GETDATE(),@memo FROM RR_StockInfo WHERE id=@id;");
        sql.Append(" UPDATE RR_StockInfo SET currentstock=currentstock-@receivenum WHERE id=@id; ");
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
                    Response.Write("{\"success\":true,\"msg\":\"领取成功!\"}");
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
    #endregion
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
        //按日期查询
        //提交开始日期
        if (!string.IsNullOrEmpty(Request.Form["sdate"]))
            list.Add(" indate >='" + Request.Form["sdate"] + "'");
        //提交截止日期
        if (!string.IsNullOrEmpty(Request.Form["edate"]))
            list.Add(" indate <='" + Request.Form["edate"] + "'");
        //按资源类别
        if (!string.IsNullOrEmpty(Request.Form["typeid"]))
            list.Add(" typeid =" + Request.Form["typeid"]);
        //按单位名称
        if (!string.IsNullOrEmpty(Request.Form["unitname"]))
            list.Add(" unitname ='" + Request.Form["unitname"] + "'");
        //按资源编号
        if (!string.IsNullOrEmpty(Request.Form["rrid"]))
            list.Add(" rrid like '%" + Request.Form["rrid"] + "%'");
        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 盘活资源物料入库明细
    /// </summary>
    public void GetRRStockInfo()
    {
        int total = 0;
        string where = SetQueryConditionForInStock();
        if (!string.IsNullOrEmpty(Request.Form["where"]))
            where = Server.UrlDecode(Request.Form["where"].ToString());
        string fieldStr = "a.id,a.indate,a.rrid,a.unitname,c.gridname,b.TypeName,a.amount,a.currentstock,a.linkman,a.linkphone,a.location,b.Units,a.inputtime,a.memo";
        string table = "dbo.RR_StockInfo AS a JOIN  RR_TypeInfo AS b ON a.typeid=b.ID left join RR_GridInfo c on a.gridid=c.id";
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
        sql.Append("select   kkl.id,kkl.llrq,kkl.storeorderno,kkl.unitname,kw.classname,kw.TypeName,kkl.amount,kw.Units,price,money,kkl.memo,kkl.inputtime  FROM RR_KclrLog AS kkl JOIN  RR_TypeInfo AS kw ON kkl.typeid=kw.ID ");
        sql.Append(where);
        sql.Append(" order by kkl.id ");
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.Columns[0].ColumnName = "序号";
        dt.Columns[1].ColumnName = "入库日期";
        dt.Columns[2].ColumnName = "商城出库单号";
        dt.Columns[3].ColumnName = "入库单位";
        dt.Columns[4].ColumnName = "物料类型";
        dt.Columns[5].ColumnName = "资源类别 ";
        dt.Columns[6].ColumnName = "入库数量";
        dt.Columns[7].ColumnName = "单位";
        dt.Columns[8].ColumnName = "单价";
        dt.Columns[9].ColumnName = "金额";
        dt.Columns[10].ColumnName = "备注";
        dt.Columns[11].ColumnName = "录入时间";
        MyXls.CreateXls(dt, "盘活资源入库明细.xls", "2,5,10,11");
        Response.Flush();
        Response.End();
    }
    #endregion 库存入库明细
    #region 资源领用明细
    /// <summary>
    /// 设置领料单位领料明细查询条件
    /// </summary>
    /// <returns></returns>
    public string SetQueryConditionForDrawStock()
    {
        string queryStr = "";
        //设置查询条件
        List<string> list = new List<string>();
        //按领料日期查询
        //提交开始日期
        if (!string.IsNullOrEmpty(Request.Form["sdate"]))
            list.Add(" outdate >='" + Request.Form["sdate"] + "'");
        //提交截止日期
        if (!string.IsNullOrEmpty(Request.Form["edate"]))
            list.Add(" outdate <='" + Request.Form["edate"] + "'");
        //按单位
        if (!string.IsNullOrEmpty(Request.Form["unitname"]))
                list.Add(" b.unitname ='" + Request.Form["unitname"] + "'");
        //按领料单位
        if (!string.IsNullOrEmpty(Request.Form["oldunitname"]))
            list.Add(" a.receiveunitname ='" + Request.Form["oldunitname"]+"'");
        //按资源类别
        if (!string.IsNullOrEmpty(Request.Form["typeid"]))
            list.Add(" a.typeid =" + Request.Form["typeid"]);
        //按资源编号
        if (!string.IsNullOrEmpty(Request.Form["rrid"]))
            list.Add(" a.rrid  like '%" + Request.Form["rrid"]+"%'");
        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 物料领用管理
    /// </summary>
    public void GetRRStockDrawDetail()
    {
        int total = 0;
        string where = SetQueryConditionForDrawStock();
        if (!string.IsNullOrEmpty(Request.Form["where"]))
            where = Server.UrlDecode(Request.Form["where"].ToString());
        string fieldStr = "a.id,a.outdate,a.receiveunitname,a.rrid,a.receivenum,a.signno,a.usefor,a.useplace,a.receiveman,a.receivephone,a.memo,b.unitname,c.typename,c.price,c.price*a.receivenum as money,c.price*a.receivenum*0.2 as award ";
        string table = "dbo.RR_StockDrawInfo AS a JOIN RR_StockInfo AS b ON a.rrid=b.rrid  left join RR_TypeInfo c  on a.typeid=c.id ";
        DataSet ds = SqlHelper.GetPagination(table, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    /// 导出领料单位领料明细
    /// </summary>
    public void ExportDrawRRDetail()
    {
        string where = SetQueryConditionForDrawStock();
        if (where != "")
            where = " where " + where;
        StringBuilder sql = new StringBuilder();
        sql.Append("SELECT a.outdate,a.receiveunitname,a.rrid,c.typename,a.receivenum,a.signno,a.usefor,a.useplace,a.receiveman,a.receivephone,b.unitname,c.price,c.price*a.receivenum as money,c.price*a.receivenum*0.2 as award,a.memo ");
        sql.Append(" FROM dbo.RR_StockDrawInfo AS a JOIN RR_StockInfo AS b ON a.rrid=b.rrid  left join RR_TypeInfo c  on a.typeid=c.id ");
        sql.Append(where);
        sql.Append(" order by a.id ");
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.Columns[0].ColumnName = "领用日期";
        dt.Columns[1].ColumnName = "领用单位";
        dt.Columns[2].ColumnName = "资源编号";
        dt.Columns[3].ColumnName = "资源名称";
        dt.Columns[4].ColumnName = "领用数量";
        dt.Columns[5].ColumnName = "计费编码/签报编号";
        dt.Columns[6].ColumnName = "用途";
        dt.Columns[7].ColumnName = "使用地点";
        dt.Columns[8].ColumnName = "领用人";
        dt.Columns[9].ColumnName = "联系电话";
        dt.Columns[10].ColumnName = "资源入库单位";
        dt.Columns[11].ColumnName = "采购单价（元）";
        dt.Columns[12].ColumnName = "节约成本";
        dt.Columns[13].ColumnName = "激励金额";
        dt.Columns[14].ColumnName = "备注";
        ExcelHelper.ExportByWeb(dt, "", "资源领用明细.xls", "资源领用明细");
    }
         /// <summary>
    /// 设置资源管理显示在单条记录的领用明细查询条件
    /// </summary>
    /// <returns></returns>
    public string SetQueryConditionForDrawResource()
    {
        //设置查询条件
        string queryStr = "";
        //设置查询条件
        List<string> list = new List<string>();
        //当前资源编号
        if (!string.IsNullOrEmpty(Request.QueryString["id"]))
            list.Add(" rrid='" + Request.QueryString["id"] + "' ");
        //领用开始日期
        if (!string.IsNullOrEmpty(Request.Form["sdate"]))
            list.Add(" outdate >='" + Request.Form["sdate"] + "'");
        //领用截止日期
        if (!string.IsNullOrEmpty(Request.Form["edate"]))
            list.Add(" outdate <='" + Request.Form["edate"] + "'");
        //按领用单位
        if (!string.IsNullOrEmpty(Request.Form["receivename"]))
            list.Add(" receiveunitname like'%" + Request.Form["receivename"] + "%'");
        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    ///  在资源管理显示在单条记录的领用明细 数据page:1 rows:10 sort:id order:asc
    /// </summary>
    public void GetDrawResourceInfo()
    {
        int total = 0;
        string where = SetQueryConditionForDrawResource();
        StringBuilder sql = new StringBuilder(" RR_StockDrawInfo ");
        string tableName = sql.ToString();
        string fieldStr = "id,outdate,receiveunitname,receivenum,usefor,receiveman,receivephone";
        DataSet ds = SqlHelper.GetPagination(tableName, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds.Tables[0], total, true, "receivenum", "outdate", "合计"));
    }
    #endregion 资源领用明细
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}