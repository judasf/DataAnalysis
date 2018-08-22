<%@ WebHandler Language="C#" Class="Srv_khjr_Stock" %>

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
/// 客户接入服务类—库存管理
/// </summary>
public class Srv_khjr_Stock : IHttpHandler, IRequiresSessionState
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
        //按基层单元
        if (Session["roleid"].ToString() == "12" || Session["roleid"].ToString() == "13" || Session["roleid"].ToString() == "14" || Session["roleid"].ToString() == "17")
        {
            list.Add(" unitname ='" + Session["deptname"].ToString() + "'");
        }
        else if (!string.IsNullOrEmpty(Request.Form["unitname"]) && Request.Form["unitname"] != "全部")
        {

            list.Add(" unitname ='" + Request.Form["unitname"] + "'");
        }
        //按物料型号
        if (!string.IsNullOrEmpty(Request.Form["typeid"]))
            list.Add(" typeid =" + Request.Form["typeid"]);
        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 客户接入——基层装维单元库存管理
    /// 获取KHJR_Stock表数据page:1 rows:10 sort:id order:asc
    public void GetKhjrUnitStock()
    {
        int total = 0;
        string where = SetQueryConditionForStock();
        if (!string.IsNullOrEmpty(Request.Form["where"]))
            where = Server.UrlDecode(Request.Form["where"].ToString());
        string fieldStr = "a.id,a.unitname,b.typename,a.amount,b.units";
        string table = "KHJR_Stock AS a JOIN KHJR_Wlxh AS b ON a.typeid=b.id";
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
        string sql = "SELECT  isnull(ks.Amount,0) AS amount,kw.Units FROM KHJR_Stock AS ks right  JOIN KHJR_Wlxh AS kw ON ks.TypeID=kw.ID AND  ks.UnitName=@unitname WHERE  kw.id=@typeid";
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
        for (int i = 1; i <= rowsCount; i++)
        {
            paras.Add(new SqlParameter("@typeid" + i.ToString(), Request.Form["typeid" + i.ToString()]));
            paras.Add(new SqlParameter("@amount" + i.ToString(), Request.Form["amount" + i.ToString()]));
            sql.Append("IF EXISTS(SELECT * FROM KHJR_Stock  WHERE UnitName=@unitname AND TypeID=@typeid" + i.ToString() + ")");
            sql.Append(" UPDATE KHJR_Stock 	SET Amount =amount+@amount" + i.ToString() + "	where UnitName = @unitname AND TypeID = @typeid" + i.ToString() + "; ");
            sql.Append(" ELSE ");
            sql.Append(" INSERT INTO KHJR_Stock	VALUES(	@unitname,@typeid" + i.ToString() + ",@amount" + i.ToString() + "); ");
            sql.Append("INSERT INTO KHJR_KclrLog values(@llrq,@unitname,@typeid" + i.ToString() + ",@amount" + i.ToString() + ",getdate(),@memo);");

        }
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), paras.ToArray());
        if (result > 0)
            Response.Write("{\"success\":true,\"msg\":\"提交成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    /// <summary>
    /// 保存装维片区领料信息并减少库存
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
            paras.Add(new SqlParameter("@amount" + i.ToString(), Request.Form["amount" + i.ToString()]));
            sql.Append(" UPDATE KHJR_Stock 	SET Amount =amount-@amount" + i.ToString() + "	where UnitName = @unitname AND TypeID = @typeid" + i.ToString() + "; ");
            sql.Append("INSERT INTO KHJR_StockOut values(@ckrq,@unitname,@areaid,@llr,@typeid" + i.ToString() + ",@amount" + i.ToString() + ",getdate(),@memo);");

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
        sql.Append("select a.id,a.unitname,b.typename,a.amount,b.units ");
        sql.Append(" from KHJR_Stock AS a JOIN KHJR_Wlxh AS b ON a.typeid=b.id ");
        sql.Append(where);
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.Columns[0].ColumnName = "序号";
        dt.Columns[1].ColumnName = "基层单元";
        dt.Columns[2].ColumnName = "物料型号";
        dt.Columns[3].ColumnName = "库存数量";
        dt.Columns[4].ColumnName = "单位";
        MyXls.CreateXls(dt, "基层单元库存明细.xls", "2");
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
        //按基层单元
        if (Session["roleid"].ToString() == "12" || Session["roleid"].ToString() == "13" || Session["roleid"].ToString() == "14" || Session["roleid"].ToString() == "17")
        {
            list.Add(" unitname ='" + Session["deptname"].ToString() + "'");
        }
        else if (!string.IsNullOrEmpty(Request.Form["unitname"]) && Request.Form["unitname"] != "全部")
        {

            list.Add(" unitname ='" + Request.Form["unitname"] + "'");
        }
        //按物料型号
        if (!string.IsNullOrEmpty(Request.Form["typeid"]))
            list.Add(" typeid =" + Request.Form["typeid"]);
        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 基层单元库存入库明细
    /// </summary>
    public void GetUnitInStockDetail()
    {
        int total = 0;
        string where = SetQueryConditionForInStock();
        if (!string.IsNullOrEmpty(Request.Form["where"]))
            where = Server.UrlDecode(Request.Form["where"].ToString());
        string fieldStr = "kkl.id,kkl.llrq,kkl.unitname,kkl.typeid,kw.TypeName,kkl.amount,kw.Units,kkl.inputtime,kkl.memo";
        string table = "KHJR_KclrLog AS kkl JOIN  KHJR_Wlxh AS kw ON kkl.typeid=kw.ID";
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
        sql.Append("SELECT kkl.id,kkl.llrq,kkl.unitname,kw.TypeName,kkl.amount,");
        sql.Append("kw.Units,kkl.inputtime,kkl.memo  FROM KHJR_KclrLog AS kkl");
        sql.Append(" JOIN  KHJR_Wlxh AS kw ON kkl.typeid=kw.ID ");
        sql.Append(where);
        sql.Append(" order by kkl.id ");
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.Columns[0].ColumnName = "序号";
        dt.Columns[1].ColumnName = "领料日期";
        dt.Columns[2].ColumnName = "基层单元";
        dt.Columns[3].ColumnName = "物料型号";
        dt.Columns[4].ColumnName = "入库数量";
        dt.Columns[5].ColumnName = "单位";
        dt.Columns[6].ColumnName = "入库时间";
        dt.Columns[7].ColumnName = "备注";
        MyXls.CreateXls(dt, "基层单元入库明细.xls", "3,6,7");
        Response.Flush();
        Response.End();
    }
    #endregion 库存入库明细
    #region 装维片区领料明细
    /// <summary>
    /// 设置装维片区领料明细查询条件
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
        //按基层单元
        if (Session["roleid"].ToString() == "12" || Session["roleid"].ToString() == "13" || Session["roleid"].ToString() == "14" || Session["roleid"].ToString() == "17")
        {
            list.Add(" a.unitname ='" + Session["deptname"].ToString() + "'");
        }
        else if (!string.IsNullOrEmpty(Request.Form["unitname"]) && Request.Form["unitname"] != "全部")
        {

            list.Add(" a.unitname ='" + Request.Form["unitname"] + "'");
        }
        //按装维片区
        if (Session["roleid"].ToString() == "14" && Session["areaid"] != null)
            list.Add(" areaid =" + Session["areaid"].ToString());
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
    /// 装维片区领料明细明细（装维片区领料明细）
    /// </summary>
    public void GetUnitOutStockDetail()
    {
        int total = 0;
        string where = SetQueryConditionForOutStock();
        if (!string.IsNullOrEmpty(Request.Form["where"]))
            where = Server.UrlDecode(Request.Form["where"].ToString());
        string fieldStr = "a.id,a.ckrq,a.unitname,c.AreaName,a.llr,b.TypeName,a.amount,b.Units,a.memo";
        string table = "KHJR_StockOut AS a JOIN KHJR_Wlxh AS b ON a.typeid=b.ID JOIN KHJR_UnitArea AS c ON a.areaid=c.ID";
        DataSet ds = SqlHelper.GetPagination(table, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    /// 导出装维片区领料明细
    /// </summary>
    public void ExportUnitOutStockDetail()
    {
        string where = SetQueryConditionForOutStock();
        if (where != "")
            where = " where " + where;
        StringBuilder sql = new StringBuilder();
        sql.Append("SELECT a.id,a.ckrq,a.unitname,c.AreaName,a.llr, b.TypeName,a.amount,b.Units,a.memo ");
        sql.Append(" FROM KHJR_StockOut AS a JOIN KHJR_Wlxh AS b ON a.typeid=b.ID ");
        sql.Append(" JOIN KHJR_UnitArea AS c ON a.areaid=c.ID ");
        sql.Append(where);
        sql.Append(" order by a.id ");
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.Columns[0].ColumnName = "序号";
        dt.Columns[1].ColumnName = "出库日期";
        dt.Columns[2].ColumnName = "基层装维单元";
        dt.Columns[3].ColumnName = "装维片区";
        dt.Columns[4].ColumnName = "领料人";
        dt.Columns[5].ColumnName = "物料型号";
        dt.Columns[6].ColumnName = "数量";
        dt.Columns[7].ColumnName = "单位";
        dt.Columns[8].ColumnName = "备注";
        MyXls.CreateXls(dt, "装维片区领料明细.xls", "5,8");
        Response.Flush();
        Response.End();
    }
    #endregion 装维片区领料明细
    #region 装维片区用料明细
    /// <summary>
    /// 设置装维片区用料明细查询条件
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
        //按装维片区
        if (Session["roleid"].ToString() == "14" && Session["areaid"] != null)
            list.Add(" b.id =" + Session["areaid"].ToString());
        else if (!string.IsNullOrEmpty(Request.Form["areaid"]))
            list.Add(" b.id =" + Request.Form["areaid"]);
        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 装维片区用料明细
    /// </summary>
    public void GetAreaMaterialDetail()
    {
        int total = 0;
        string where = SetQueryConditionForAreaMaterial();
        if (!string.IsNullOrEmpty(Request.Form["where"]))
            where = Server.UrlDecode(Request.Form["where"].ToString());
        string fieldStr = "a.*, CONVERT(varchar(10), inputtime, 23) as inputdate";
        string table = "KHJR_Zwyl AS a JOIN KHJR_UnitArea AS b ON a.areaname=b.AreaName";
        DataSet ds = SqlHelper.GetPagination(table, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds.Tables[0], total, true, "pxgl,ljct_3m,ljct_gc,px,hx,wx", "onu", "合计"));
    }
    /// <summary>
    /// 导出装维片区用料明细
    /// </summary>
    public void ExportAreaMaterialDetail()
    {
        string where = SetQueryConditionForAreaMaterial();
        if (where != "")
            where = " where " + where;
        StringBuilder sql = new StringBuilder();
        sql.Append("SELECT a.id,CONVERT(varchar(10), inputtime, 23) as inputdate,a.unitname,a.AreaName,a.yllb, a.usernum,a.username,a.useraddress,onu,pxgl,ljct_3m,ljct_gc,px,hx,wx,memo ");
        sql.Append(" FROM KHJR_Zwyl AS a JOIN KHJR_UnitArea AS b ON a.areaname=b.AreaName ");
        sql.Append(where);
        sql.Append(" order by a.id ");
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.Columns[0].ColumnName = "序号";
        dt.Columns[1].ColumnName = "录入日期";
        dt.Columns[2].ColumnName = "基层单元";
        dt.Columns[3].ColumnName = "装维片区";
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
        MyXls.CreateXls(dt, "装维片区用料明细.xls", "7,15");
        Response.Flush();
        Response.End();
    }
    /// <summary>
    /// 导入上传的装维片区用料明细信息
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
        columnsName.Add("装维片区");
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
    /// 保存装维片区用料明细
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
        string areaname = SqlHelper.ExecuteScalar(SqlHelper.GetConnection(), CommandType.Text, "Select areaname from KHJR_UnitArea where id=@id", new SqlParameter("@id", Session["areaid"])).ToString();
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
        sql.Append("INSERT INTO KHJR_Zwyl VALUES(@unitname,@areaname,@usernum,@username,@useraddress,@yllb,@onu,@pxgl,@ljct_3M,@ljct_gc,@px,@hx,@wx,@memo,getdate()	)");
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), paras.ToArray());
        if (result > 0)
            Response.Write("{\"success\":true,\"msg\":\"提交成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    #endregion 装维片区用料
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}