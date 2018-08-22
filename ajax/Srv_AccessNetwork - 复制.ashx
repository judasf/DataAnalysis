<%@ WebHandler Language="C#" Class="Srv_AccessNetwork" %>

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
/// 接入网资源管理
/// </summary>
public class Srv_AccessNetwork : IHttpHandler, IRequiresSessionState
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
    #region 接入网机房资源管理
    /// <summary>
    /// 设置接入网机房资源查询条件
    /// </summary>
    /// <returns></returns>
    public string SetQueryConditionForRoom()
    {
        string queryStr = "";
        //设置查询条件
        List<string> list = new List<string>();
        //按所属县市
        if (!string.IsNullOrEmpty(Request.Form["cityname"]))
            list.Add(" cityname ='" + Request.Form["cityname"] + "'");
        //按接入网编号
        if (!string.IsNullOrEmpty(Request.Form["anid"]))
            list.Add(" anid like'%" + Request.Form["anid"] + "%'");
        //按接入网级别
        if (!string.IsNullOrEmpty(Request.Form["anlevel"]))
            list.Add(" anlevel ='" + Request.Form["anlevel"] + "'");
        //状态（是否删除）
        if (!string.IsNullOrEmpty(Request.Form["status"]))
            list.Add(" IsDel=" + Request.Form["status"]);
        else
            list.Add(" IsDel=0");
        if (roleid == "15")
        {
            if (deptname == "网络维护中心")
                list.Add(" cityname='安阳市' ");
            else
                list.Add(" cityname='" + deptname + "' ");
        }
        
        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 获取接入网机房资源 数据page:1 rows:10 sort:id order:asc
    /// </summary>
    public void GetRoomResources()
    {
        int total = 0;
        string where = SetQueryConditionForRoom();
        string tableName = " AccessNetWork_RoomResources ";
        string fieldStr = "*,CONVERT(VARCHAR(50),inputtime,23) as inputdate";
        DataSet ds = SqlHelper.GetPagination(tableName, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    ///  AccessNetWork_RoomResources
    /// </summary>
    public void GetRoomResourcesInfoByID()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = id;
        string sql = "SELECT * FROM AccessNetWork_RoomResources  where ID=@id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    /// <summary>
    /// 导入上传的机房资源台账
    /// </summary>
    public void ImportRoomResourcesInfo()
    {
        string reportPath = "";
        if (!string.IsNullOrEmpty(Request.Form["report"]))
            reportPath = Server.MapPath("~") + Request.Form["report"].ToString();
        int checkFile = MyXls.ChkSheet(reportPath, "接入网资源基础台帐");
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
        columnsName.Add("接入网编号");
        List<int> columnsExists = MyXls.ChkSheetColumns(reportPath, "接入网资源基础台帐", columnsName);
        if (columnsExists.Contains(0))
        {
            Response.Write("{\"success\":false,\"msg\":\"请检查excel文件内容格式是否正确！\"}");
            return;
        }
        SqlParameter[] paras = new SqlParameter[]{
            new SqlParameter("@filePath",reportPath),
            new SqlParameter("@sheetName","接入网资源基础台帐")
        };
        SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.StoredProcedure, "ImportRoomResourcesFromExcelAndUpdate", paras);
        //SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.StoredProcedure, "ImportRoomResourcesFromExcelAndUpdate_x64", paras);
        //添加当天操作记录
        SaveOPerationLog();
        Response.Write("{\"success\":true,\"msg\":\"数据导入成功！\"}");
    }
    /// <summary>
    /// 导出接入网机房资源明细
    /// </summary>
    public void ExportRoomResources()
    {
        string where = SetQueryConditionForRoom();
        if (where != "")
            where = " where " + where;
        StringBuilder sql = new StringBuilder();
        sql.Append("select ANID,RoomName,CityName,RegionName,ANLevel,Address,PointType,Longitude,Dimension,Area,");
        sql.Append("PropertyRight,ContractNO,ContractPriod,LessorType,RentPayment,Rent,LastPayDate,");
        sql.Append("DEMStatus,DEMEM,RoomPlan,RoomResistance,PowerSupplyMode,ElectricityPrice,");
        sql.Append("RoomLoadCurrent,Memo1,Memo2,Memo3");
        sql.Append(" from AccessNetWork_RoomResources ");
        sql.Append(where);
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.Columns[0].ColumnName = "接入网编号";
        dt.Columns[1].ColumnName = "机房名称";
        dt.Columns[2].ColumnName = "所属县市";
        dt.Columns[3].ColumnName = "所属行政区域";
        dt.Columns[4].ColumnName = "接入网级别";
        dt.Columns[5].ColumnName = "详细地址";
        dt.Columns[6].ColumnName = "网点类型";
        dt.Columns[7].ColumnName = "经度";
        dt.Columns[8].ColumnName = "纬度";
        dt.Columns[9].ColumnName = "面积";
        dt.Columns[10].ColumnName = "产权性质";
        dt.Columns[11].ColumnName = "租赁合同编号";
        dt.Columns[12].ColumnName = "合同期限（起止时间）";
        dt.Columns[13].ColumnName = "租赁合同对方单位或个人";
        dt.Columns[14].ColumnName = "租金付款方式";
        dt.Columns[15].ColumnName = "年租金";
        dt.Columns[16].ColumnName = "最近一次交费日期";
        dt.Columns[17].ColumnName = "动环监控";
        dt.Columns[18].ColumnName = "动环设备厂家";
        dt.Columns[19].ColumnName = "机房平面图";
        dt.Columns[20].ColumnName = "机房接地电阻";
        dt.Columns[21].ColumnName = "机房供电方式";
        dt.Columns[22].ColumnName = "电费单价";
        dt.Columns[23].ColumnName = "机房负载电流（直流电流A）";
        dt.Columns[24].ColumnName = "备注1";
        dt.Columns[25].ColumnName = "备注2";
        dt.Columns[26].ColumnName = "备注3";
        ExcelHelper.ExportByWeb(dt, "", "接入网机房资源基础台账.xls", "接入网资源基础台帐");
    }
    /// <summary>
    /// 更新接入网机房资源信息
    /// </summary>
    public void UpdateRoomResourcesInfo()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        //接入网编号
        string anid = Convert.ToString(Request.Form["anid"]);
        //机房名称
        string roomname = Convert.ToString(Request.Form["roomname"]);
        //所属县市
        string cityname = Convert.ToString(Request.Form["cityname"]);
        //所属行政区域
        string regionname = Convert.ToString(Request.Form["regionname"]);
        //接入网级别
        string anlevel = Convert.ToString(Request.Form["anlevel"]);
        //详细地址
        string address = Convert.ToString(Request.Form["address"]);
        //网点类型
        string pointtype = Convert.ToString(Request.Form["pointtype"]);
        //经度
        string longitude = Convert.ToString(Request.Form["longitude"]);
        //纬度
        string dimension = Convert.ToString(Request.Form["dimension"]);
        //面积
        string area = Convert.ToString(Request.Form["area"]);
        //产权性质
        string propertyright = Convert.ToString(Request.Form["propertyright"]);
        //租赁合同编号
        string contractno = Convert.ToString(Request.Form["contractno"]);
        //合同期限（起止时间）
        string contractpriod = Convert.ToString(Request.Form["contractpriod"]);
        //租赁合同对方单位或个人
        string lessortype = Convert.ToString(Request.Form["lessortype"]);
        //租金付款方式
        string rentpayment = Convert.ToString(Request.Form["rentpayment"]);
        //年租金
        string rent = Convert.ToString(Request.Form["rent"]);
        //最近一次交费日期
        string lastpaydate = Convert.ToString(Request.Form["lastpaydate"]);
        //动环监控
        string demstatus = Convert.ToString(Request.Form["demstatus"]);
        //动环设备厂家
        string demem = Convert.ToString(Request.Form["demem"]);
        //机房平面图
        string roomplan = Convert.ToString(Request.Form["roomplan"]);
        //机房接地电阻
        string roomresistance = Convert.ToString(Request.Form["roomresistance"]);
        //机房供电方式
        string powersupplymode = Convert.ToString(Request.Form["powersupplymode"]);
        //电费单价
        string electricityprice = Convert.ToString(Request.Form["electricityprice"]);
        //机房负载电流
        string roomloadcurrent = Convert.ToString(Request.Form["roomloadcurrent"]);
        string memo1 = Convert.ToString(Request.Form["memo1"]);
        string memo2 = Convert.ToString(Request.Form["memo2"]);
        string memo3 = Convert.ToString(Request.Form["memo3"]);
        List<SqlParameter> _paras = new List<SqlParameter>();
        _paras.Add(new SqlParameter("@id", id));
        _paras.Add(new SqlParameter("@anid", anid));
        _paras.Add(new SqlParameter("@roomname", roomname));
        _paras.Add(new SqlParameter("@cityname", cityname));
        _paras.Add(new SqlParameter("@regionname", regionname));
        _paras.Add(new SqlParameter("@anlevel", anlevel));
        _paras.Add(new SqlParameter("@address", address));
        _paras.Add(new SqlParameter("@pointtype", pointtype));
        _paras.Add(new SqlParameter("@longitude", longitude));
        _paras.Add(new SqlParameter("@dimension", dimension));
        _paras.Add(new SqlParameter("@area", area));
        _paras.Add(new SqlParameter("@propertyright", propertyright));
        _paras.Add(new SqlParameter("@contractno", contractno));
        _paras.Add(new SqlParameter("@contractpriod", contractpriod));
        _paras.Add(new SqlParameter("@lessortype", lessortype));
        _paras.Add(new SqlParameter("@rentpayment", rentpayment));
        _paras.Add(new SqlParameter("@rent", rent));
        _paras.Add(new SqlParameter("@lastpaydate", lastpaydate));
        _paras.Add(new SqlParameter("@demstatus", demstatus));
        _paras.Add(new SqlParameter("@demem", demem));
        _paras.Add(new SqlParameter("@roomplan", roomplan));
        _paras.Add(new SqlParameter("@roomresistance", roomresistance));
        _paras.Add(new SqlParameter("@powersupplymode", powersupplymode));
        _paras.Add(new SqlParameter("@electricityprice", electricityprice));
        _paras.Add(new SqlParameter("@roomloadcurrent", roomloadcurrent));
        _paras.Add(new SqlParameter("@memo1", memo1));
        _paras.Add(new SqlParameter("@memo2", memo2));
        _paras.Add(new SqlParameter("@memo3", memo3));
        StringBuilder sql = new StringBuilder();
        sql.Append("update  AccessNetWork_RoomResources set ANID = @anid,RoomName = @roomname,CityName = @cityname,");
        sql.Append("RegionName = @regionname,ANLevel = @anlevel,[Address] = @address,PointType = @pointtype,");
        sql.Append("Longitude = @longitude,Dimension = @dimension,Area = @area,PropertyRight = @propertyright,");
        sql.Append("ContractNO = @contractno,ContractPriod = @contractpriod,LessorType = @lessortype,");
        sql.Append("RentPayment = @rentpayment,Rent = @rent,LastPayDate = @lastpaydate,DEMStatus = @demstatus,");
        sql.Append("DEMEM = @demem,RoomPlan = @roomplan,RoomResistance = @roomresistance,PowerSupplyMode = @powersupplymode,");
        sql.Append("ElectricityPrice = @electricityprice,RoomLoadCurrent = @roomloadcurrent,Memo1 = @memo1,");
        sql.Append("Memo2 = @memo2,Memo3 = @memo3,InputTime=getdate()  where id=@id");
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), _paras.ToArray());
        //添加用户操作记录
        SaveOPerationLog();
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"资源更新成功！\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    //<summary>
    //新增接入网机房资源
    //</summary>
    public void SaveRoomResourcesInfo()
    {
        //1、获取参数
        //接入网编号
        string anid = Convert.ToString(Request.Form["anid"]);
        //机房名称
        string roomname = Convert.ToString(Request.Form["roomname"]);
        //所属县市
        string cityname = Convert.ToString(Request.Form["cityname"]);
        //所属行政区域
        string regionname = Convert.ToString(Request.Form["regionname"]);
        //接入网级别
        string anlevel = Convert.ToString(Request.Form["anlevel"]);
        //详细地址
        string address = Convert.ToString(Request.Form["address"]);
        //网点类型
        string pointtype = Convert.ToString(Request.Form["pointtype"]);
        //经度
        string longitude = Convert.ToString(Request.Form["longitude"]);
        //纬度
        string dimension = Convert.ToString(Request.Form["dimension"]);
        //面积
        string area = Convert.ToString(Request.Form["area"]);
        //产权性质
        string propertyright = Convert.ToString(Request.Form["propertyright"]);
        //租赁合同编号
        string contractno = Convert.ToString(Request.Form["contractno"]);
        //合同期限（起止时间）
        string contractpriod = Convert.ToString(Request.Form["contractpriod"]);
        //租赁合同对方单位或个人
        string lessortype = Convert.ToString(Request.Form["lessortype"]);
        //租金付款方式
        string rentpayment = Convert.ToString(Request.Form["rentpayment"]);
        //年租金
        string rent = Convert.ToString(Request.Form["rent"]);
        //最近一次交费日期
        string lastpaydate = Convert.ToString(Request.Form["lastpaydate"]);
        //动环监控
        string demstatus = Convert.ToString(Request.Form["demstatus"]);
        //动环设备厂家
        string demem = Convert.ToString(Request.Form["demem"]);
        //机房平面图
        string roomplan = Convert.ToString(Request.Form["roomplan"]);
        //机房接地电阻
        string roomresistance = Convert.ToString(Request.Form["roomresistance"]);
        //机房供电方式
        string powersupplymode = Convert.ToString(Request.Form["powersupplymode"]);
        //电费单价
        string electricityprice = Convert.ToString(Request.Form["electricityprice"]);
        //机房负载电流
        string roomloadcurrent = Convert.ToString(Request.Form["roomloadcurrent"]);
        string memo1 = Convert.ToString(Request.Form["memo1"]);
        string memo2 = Convert.ToString(Request.Form["memo2"]);
        string memo3 = Convert.ToString(Request.Form["memo3"]);
        //设定参数
        List<SqlParameter> _paras = new List<SqlParameter>();
        _paras.Add(new SqlParameter("@anid", anid));
        _paras.Add(new SqlParameter("@roomname", roomname));
        _paras.Add(new SqlParameter("@cityname", cityname));
        _paras.Add(new SqlParameter("@regionname", regionname));
        _paras.Add(new SqlParameter("@anlevel", anlevel));
        _paras.Add(new SqlParameter("@address", address));
        _paras.Add(new SqlParameter("@pointtype", pointtype));
        _paras.Add(new SqlParameter("@longitude", longitude));
        _paras.Add(new SqlParameter("@dimension", dimension));
        _paras.Add(new SqlParameter("@area", area));
        _paras.Add(new SqlParameter("@propertyright", propertyright));
        _paras.Add(new SqlParameter("@contractno", contractno));
        _paras.Add(new SqlParameter("@contractpriod", contractpriod));
        _paras.Add(new SqlParameter("@lessortype", lessortype));
        _paras.Add(new SqlParameter("@rentpayment", rentpayment));
        _paras.Add(new SqlParameter("@rent", rent));
        _paras.Add(new SqlParameter("@lastpaydate", lastpaydate));
        _paras.Add(new SqlParameter("@demstatus", demstatus));
        _paras.Add(new SqlParameter("@demem", demem));
        _paras.Add(new SqlParameter("@roomplan", roomplan));
        _paras.Add(new SqlParameter("@roomresistance", roomresistance));
        _paras.Add(new SqlParameter("@powersupplymode", powersupplymode));
        _paras.Add(new SqlParameter("@electricityprice", electricityprice));
        _paras.Add(new SqlParameter("@roomloadcurrent", roomloadcurrent));
        _paras.Add(new SqlParameter("@memo1", memo1));
        _paras.Add(new SqlParameter("@memo2", memo2));
        _paras.Add(new SqlParameter("@memo3", memo3));
        //2、保存
        StringBuilder sql = new StringBuilder();
        sql.Append("if not exists(select * from AccessNetWork_RoomResources where anid=@anid)");
        sql.Append("insert AccessNetWork_RoomResources(ANID,RoomName,CityName,RegionName,ANLevel,");
        sql.Append("[Address],PointType,Longitude,Dimension,Area,PropertyRight,ContractNO,");
        sql.Append("ContractPriod,LessorType,RentPayment,Rent,LastPayDate,DEMStatus,DEMEM,RoomPlan,");
        sql.Append("RoomResistance,PowerSupplyMode,ElectricityPrice,RoomLoadCurrent,Memo1,Memo2,Memo3,InputTime) ");
        sql.Append(" values(@anid,@roomname,@cityname,");
        sql.Append("@regionname,@anlevel,@address,@pointtype,@longitude,@dimension,@area,@propertyright,");
        sql.Append("@contractno,@contractpriod,@lessortype,@rentpayment,@rent,@lastpaydate,@demstatus,");
        sql.Append("@demem,@roomplan,@roomresistance,@powersupplymode,@electricityprice,@roomloadcurrent,@memo1,");
        sql.Append("@memo2,@memo3,getdate());");

        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), _paras.ToArray());
        //添加用户操作记录
        SaveOPerationLog();
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"新增接入网机房资源成功！\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"该接入网编号已存在，请检查输入！\"}");
    }
    public void RemoveRoomAndEqResourcesInfoByAnID()
    {
        string anid = Convert.ToString(Request.Form["anid"]);
        SqlParameter paras = new SqlParameter("@anid", SqlDbType.VarChar);
        paras.Value = anid;
        StringBuilder sql = new StringBuilder();
        sql.Append("Update AccessNetWork_RoomResources set IsDel=1 where anid=@anid;");
        sql.Append("Update AccessNetWork_EqInfo set IsDel=1 Where anid=@anid;");
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), paras);
        //添加用户操作记录
        SaveOPerationLog();
        if (result >= 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    #endregion 接入网机房资源管理
    #region 接入网设备管理
    /// <summary>
    /// 设置接入网设备管理查询条件
    /// </summary>
    /// <returns></returns>
    public string SetQueryConditionForEq()
    {
        string queryStr = "";
        //设置查询条件
        List<string> list = new List<string>();
        //按接入网编号
        if (!string.IsNullOrEmpty(Request.Form["anid"]))
            list.Add(" anid like'%" + Request.Form["anid"] + "%'");
        //按接入网级别
        if (!string.IsNullOrEmpty(Request.Form["anlevel"]))
            list.Add(" anlevel ='" + Request.Form["anlevel"] + "'");
        //按所属市县
        if (roleid == "15")
        {
            if (deptname == "网络维护中心")
                list.Add(" cityname='安阳市' ");
            else
                list.Add(" cityname='" + deptname + "' ");
        }
        //状态（是否删除）
        if (!string.IsNullOrEmpty(Request.Form["status"]))
            list.Add(" IsDel=" + Request.Form["status"]);
        else
            list.Add(" IsDel=0");
        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 获取接入网设备信息 数据page:1 rows:10 sort:id order:asc
    /// </summary>
    public void GetEquipmentInfo()
    {
        int total = 0;
        string where = SetQueryConditionForRoom();
        string tableName = " AccessNetWork_EqInfo ";
        string fieldStr = "*,CONVERT(VARCHAR(50),inputtime,23) as inputdate";
        DataSet ds = SqlHelper.GetPagination(tableName, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    ///  AccessNetWork_EqInfo
    /// </summary>
    public void GetEqInfoByID()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = id;
        string sql = "SELECT * FROM AccessNetWork_EqInfo  where ID=@id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    /// <summary>
    /// 导入上传的设备信息
    /// </summary>
    public void ImportEquipmentInfo()
    {
        string reportPath = "";
        if (!string.IsNullOrEmpty(Request.Form["report"]))
            reportPath = Server.MapPath("~") + Request.Form["report"].ToString();
        int checkFile = MyXls.ChkSheet(reportPath, "接入网设备信息");
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
        columnsName.Add("接入网编号");
        List<int> columnsExists = MyXls.ChkSheetColumns(reportPath, "接入网设备信息", columnsName);
        if (columnsExists.Contains(0))
        {
            Response.Write("{\"success\":false,\"msg\":\"请检查excel文件内容格式是否正确！\"}");
            return;
        }
        SqlParameter[] paras = new SqlParameter[]{
            new SqlParameter("@filePath",reportPath),
            new SqlParameter("@sheetName","接入网设备信息")
        };
        SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.StoredProcedure, "ImportEqInfoFromExcelAndUpdate", paras);
        //SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.StoredProcedure, "ImportEqInfoFromExcelAndUpdate_x64", paras);
        //添加用户操作记录
        SaveOPerationLog();
        Response.Write("{\"success\":true,\"msg\":\"数据导入成功！\"}");
    }
    /// <summary>
    /// 导出接入网机房资源明细
    /// </summary>
    public void ExportEqInfo()
    {
        string where = SetQueryConditionForEq();
        if (where != "")
            where = " where " + where;
        StringBuilder sql = new StringBuilder();
        sql.Append("select ANID,PointName,CityName,ANLevel,RackNo,RackSpace,FrameNo,IPAddr,EqType,");
        sql.Append("Mfrs,model,EnableDate,Capacity1,Capacity2,Capacity3,Capacity4");
        sql.Append(" from AccessNetWork_EqInfo ");
        sql.Append(where);
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.Columns[0].ColumnName = "接入网编号";
        dt.Columns[1].ColumnName = "网点名称";
        dt.Columns[2].ColumnName = "所属县市";
        dt.Columns[3].ColumnName = "接入网级别";
        dt.Columns[4].ColumnName = "机架编号";
        dt.Columns[5].ColumnName = "机架空余空间（U单位）";
        dt.Columns[6].ColumnName = "机框号";
        dt.Columns[7].ColumnName = "IP地址";
        dt.Columns[8].ColumnName = "设备类型";
        dt.Columns[9].ColumnName = "厂家";
        dt.Columns[10].ColumnName = "型号";
        dt.Columns[11].ColumnName = "启用日期";
        dt.Columns[12].ColumnName = "容量信息1";
        dt.Columns[13].ColumnName = "容量信息2";
        dt.Columns[14].ColumnName = "容量信息3";
        dt.Columns[15].ColumnName = "容量信息4";
        ExcelHelper.ExportByWeb(dt, "", "接入网设备信息.xls", "接入网设备信息");
    }
    /// <summary>
    /// 更新设备资源信息
    /// </summary>
    public void UpdateEquipmentInfo()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        //接入网编号
        string anid = Convert.ToString(Request.Form["anid"]);
        //网点名称
        string pointname = Convert.ToString(Request.Form["pointname"]);
        //所属县市
        string cityname = Convert.ToString(Request.Form["cityname"]);
        //接入网级别
        string anlevel = Convert.ToString(Request.Form["anlevel"]);
        //机架编号
        string rackno = Convert.ToString(Request.Form["rackno"]);
        //机架空余空间（U单位）
        string rackspace = Convert.ToString(Request.Form["rackspace"]);
        //机框号
        string frameno = Convert.ToString(Request.Form["frameno"]);
        //ip地址
        string ipaddr = Convert.ToString(Request.Form["ipaddr"]);
        //设备类型
        string eqtype = Convert.ToString(Request.Form["eqtype"]);
        //厂家
        string mfrs = Convert.ToString(Request.Form["mfrs"]);
        //型号
        string model = Convert.ToString(Request.Form["model"]);
        //启用日期
        string enabledate = Convert.ToString(Request.Form["enabledate"]);
        //容量信息1
        string capacity1 = Convert.ToString(Request.Form["capacity1"]);
        //容量信息2
        string capacity2 = Convert.ToString(Request.Form["capacity2"]);
        //容量信息3
        string capacity3 = Convert.ToString(Request.Form["capacity3"]);
        //容量信息4
        string capacity4 = Convert.ToString(Request.Form["capacity4"]);
        List<SqlParameter> _paras = new List<SqlParameter>();
        _paras.Add(new SqlParameter("@id", id));
        _paras.Add(new SqlParameter("@anid", anid));
        _paras.Add(new SqlParameter("@pointname", pointname));
        _paras.Add(new SqlParameter("@cityname", cityname));
        _paras.Add(new SqlParameter("@anlevel", anlevel));
        _paras.Add(new SqlParameter("@rackno", rackno));
        _paras.Add(new SqlParameter("@rackspace", rackspace));
        _paras.Add(new SqlParameter("@frameno", frameno));
        _paras.Add(new SqlParameter("@ipaddr", ipaddr));
        _paras.Add(new SqlParameter("@eqtype", eqtype));
        _paras.Add(new SqlParameter("@mfrs", mfrs));
        _paras.Add(new SqlParameter("@model", model));
        _paras.Add(new SqlParameter("@enabledate", enabledate));
        _paras.Add(new SqlParameter("@capacity1", capacity1));
        _paras.Add(new SqlParameter("@capacity2", capacity2));
        _paras.Add(new SqlParameter("@capacity3", capacity3));
        _paras.Add(new SqlParameter("@capacity4", capacity4));
        StringBuilder sql = new StringBuilder();
        sql.Append("if exists(select * from AccessNetWork_RoomResources where anid=@anid)");
        sql.Append("UPDATE AccessNetWork_EqInfo SET anid = @anid, pointname = @pointname, cityname = @cityname,");
        sql.Append("anlevel = @anlevel,rackno = @rackno,rackspace = @rackspace,frameno = @frameno,ipaddr = @ipaddr,");
        sql.Append("eqtype = @eqtype, mfrs = @mfrs, model = @model, enabledate = @enabledate,");
        sql.Append("capacity1 = @capacity1, capacity2 = @capacity2, capacity3 = @capacity3,");
        sql.Append("capacity4 = @capacity4,InputTime=getdate()  where id=@id");
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), _paras.ToArray());
        //添加用户操作记录
        SaveOPerationLog();
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"设备信息更新成功！\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"该接入网编号不存在，请检查输入！\"}");
    }
    //<summary>
    //新增设备资源信息
    //</summary>
    public void SaveEquipmentInfo()
    {
        //1、获取参数
        //接入网编号
        string anid = Convert.ToString(Request.Form["anid"]);
        //网点名称
        string pointname = Convert.ToString(Request.Form["pointname"]);
        //所属县市
        string cityname = Convert.ToString(Request.Form["cityname"]);
        //接入网级别
        string anlevel = Convert.ToString(Request.Form["anlevel"]);
        //机架编号
        string rackno = Convert.ToString(Request.Form["rackno"]);
        //机架空余空间（U单位）
        string rackspace = Convert.ToString(Request.Form["rackspace"]);
        //机框号
        string frameno = Convert.ToString(Request.Form["frameno"]);
        //ip地址
        string ipaddr = Convert.ToString(Request.Form["ipaddr"]);
        //设备类型
        string eqtype = Convert.ToString(Request.Form["eqtype"]);
        //厂家
        string mfrs = Convert.ToString(Request.Form["mfrs"]);
        //型号
        string model = Convert.ToString(Request.Form["model"]);
        //启用日期
        string enabledate = Convert.ToString(Request.Form["enabledate"]);
        //容量信息1
        string capacity1 = Convert.ToString(Request.Form["capacity1"]);
        //容量信息2
        string capacity2 = Convert.ToString(Request.Form["capacity2"]);
        //容量信息3
        string capacity3 = Convert.ToString(Request.Form["capacity3"]);
        //容量信息4
        string capacity4 = Convert.ToString(Request.Form["capacity4"]);
        //设定参数
        List<SqlParameter> _paras = new List<SqlParameter>();
        _paras.Add(new SqlParameter("@anid", anid));
        _paras.Add(new SqlParameter("@pointname", pointname));
        _paras.Add(new SqlParameter("@cityname", cityname));
        _paras.Add(new SqlParameter("@anlevel", anlevel));
        _paras.Add(new SqlParameter("@rackno", rackno));
        _paras.Add(new SqlParameter("@rackspace", rackspace));
        _paras.Add(new SqlParameter("@frameno", frameno));
        _paras.Add(new SqlParameter("@ipaddr", ipaddr));
        _paras.Add(new SqlParameter("@eqtype", eqtype));
        _paras.Add(new SqlParameter("@mfrs", mfrs));
        _paras.Add(new SqlParameter("@model", model));
        _paras.Add(new SqlParameter("@enabledate", enabledate));
        _paras.Add(new SqlParameter("@capacity1", capacity1));
        _paras.Add(new SqlParameter("@capacity2", capacity2));
        _paras.Add(new SqlParameter("@capacity3", capacity3));
        _paras.Add(new SqlParameter("@capacity4", capacity4));
        //2、保存
        StringBuilder sql = new StringBuilder();
        sql.Append("if exists(select * from AccessNetWork_RoomResources where anid=@anid)");
        sql.Append("INSERT INTO AccessNetWork_EqInfo(ANID,PointName,CityName,ANLevel,RackNo,RackSpace,");
        sql.Append("FrameNo,IPAddr,EqType,Mfrs,model,EnableDate,Capacity1,Capacity2,Capacity3,Capacity4,InputTime)");
        sql.Append(" VALUES(@ANID,@PointName,@CityName,@ANLevel,@RackNo,@RackSpace,@FrameNo,@ipaddr,@EqType,");
        sql.Append("@Mfrs,@model,@EnableDate,@Capacity1,@Capacity2,@Capacity3,@Capacity4,getdate())");

        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), _paras.ToArray());
        //添加用户操作记录
        SaveOPerationLog();
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"新增设备资源成功！\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"该接入网编号不存在，请检查输入！\"}");
    }
    /// <summary>
    /// 删除接入网设备资源信息
    /// </summary>
    public void RemoveEqResourcesInfoByID()
    {
        string id = Convert.ToString(Request.Form["id"]);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = id;
        StringBuilder sql = new StringBuilder();
        sql.Append("Update AccessNetWork_EqInfo set IsDel=1 Where id=@id;");
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), paras);
        //添加用户操作记录
        SaveOPerationLog();
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    /// <summary>
    ///清除接入网设备资源信息，针对市区未删除的数据
    /// </summary>
    public void ClearEqResourcesInfo()
    {
        StringBuilder sql = new StringBuilder();
        sql.Append("DELETE FROM AccessNetWork_EqInfo  WHERE IsDel=0 AND CityName='安阳市';");
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        //添加用户操作记录
        SaveOPerationLog();
        if (result >=0)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    } 
    #endregion 接入网设备管理
    #region 接入网网点维修台账
    /// <summary>
    /// 设置接入网网点维修台账查询条件
    /// </summary>
    /// <returns></returns>
    public string SetQueryConditionForRepair()
    {
        string queryStr = "";
        //设置查询条件
        List<string> list = new List<string>();
        //按所属县市
        if (!string.IsNullOrEmpty(Request.Form["cityname"]))
            list.Add(" cityname ='" + Request.Form["cityname"] + "'");
        //按接入网编号
        if (!string.IsNullOrEmpty(Request.Form["anid"]))
            list.Add(" anid like'%" + Request.Form["anid"] + "%'");
        //按接入网级别
        if (!string.IsNullOrEmpty(Request.Form["anlevel"]))
            list.Add(" anlevel ='" + Request.Form["anlevel"] + "'");
        if (roleid == "15")
        {
            if (deptname == "网络维护中心")
                list.Add(" cityname='安阳市' ");
            else
                list.Add(" cityname='" + deptname + "' ");
        }
        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 获取接入网网点维修台账 数据page:1 rows:10 sort:id order:asc
    /// </summary>
    public void GetPointRepairInfo()
    {
        int total = 0;
        string where = SetQueryConditionForRepair();
        string tableName = " AccessNetWork_PointRepairInfo ";
        string fieldStr = "*";
        DataSet ds = SqlHelper.GetPagination(tableName, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    ///  AccessNetWork_PointRepairInfo
    /// </summary>
    public void GetPointRepairInfoByID()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = id;
        string sql = "SELECT * FROM AccessNetWork_PointRepairInfo  where ID=@id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    /// <summary>
    /// 导入上传的接入网网点维修台账
    /// </summary>
    public void ImportPointRepairInfo()
    {
        string reportPath = "";
        if (!string.IsNullOrEmpty(Request.Form["report"]))
            reportPath = Server.MapPath("~") + Request.Form["report"].ToString();
        int checkFile = MyXls.ChkSheet(reportPath, "接入网网点维修台账");
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
        columnsName.Add("接入网机房编号");
        List<int> columnsExists = MyXls.ChkSheetColumns(reportPath, "接入网网点维修台账", columnsName);
        if (columnsExists.Contains(0))
        {
            Response.Write("{\"success\":false,\"msg\":\"请检查excel文件内容格式是否正确！\"}");
            return;
        }
        SqlParameter[] paras = new SqlParameter[]{
            new SqlParameter("@filePath",reportPath),
            new SqlParameter("@sheetName","接入网网点维修台账")
        };
        SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.StoredProcedure, "ImportPointRepairFromExcelAndUpdate", paras);
        //SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.StoredProcedure, "ImportPointRepairFromExcelAndUpdate_x64", paras);
        Response.Write("{\"success\":true,\"msg\":\"数据导入成功！\"}");
    }
    /// <summary>
    /// 导出接入网网点维修台账
    /// </summary>
    public void ExportPointRepairInfo()
    {
        string where = SetQueryConditionForRepair();
        if (where != "")
            where = " where " + where;
        StringBuilder sql = new StringBuilder();
        sql.Append("select DeptName,ANID,RoomName,CityName,RepairInfo,RepairReportNo,ApplyTime,");
        sql.Append("NoticeRepairTime,RepairFinishTime,WarrantyExpirationDate,RepairContent,");
        sql.Append("CheckInfo,RepairPerson,RepairPersonTel,ApplyMoney,ReimnurseMoney,ProjectTime,");
        sql.Append("ReimburseTime,Memo");
        sql.Append(" from AccessNetWork_PointRepairInfo ");
        sql.Append(where);
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.Columns[0].ColumnName = "单位";
        dt.Columns[1].ColumnName = "接入网机房编号";
        dt.Columns[2].ColumnName = "接入机房名称";
        dt.Columns[3].ColumnName = "所属县市";
        dt.Columns[4].ColumnName = "维修事项";
        dt.Columns[5].ColumnName = "维修签报单号";
        dt.Columns[6].ColumnName = "申请时间";
        dt.Columns[7].ColumnName = "通知维修时间";
        dt.Columns[8].ColumnName = "维修完成时间";
        dt.Columns[9].ColumnName = "保修截止日期";
        dt.Columns[10].ColumnName = "维修内容";
        dt.Columns[11].ColumnName = "验收情况(包括验收人员名单)";
        dt.Columns[12].ColumnName = "维修方名称";
        dt.Columns[13].ColumnName = "维修方联系方式";
        dt.Columns[14].ColumnName = "申请金额";
        dt.Columns[15].ColumnName = "报账金额";
        dt.Columns[16].ColumnName = "立项时间";
        dt.Columns[17].ColumnName = "报账时间";
        dt.Columns[18].ColumnName = "备注";

        ExcelHelper.ExportByWeb(dt, "", "接入网网点维修台账.xls", "接入网网点维修台账");
    }
    /// <summary>
    /// 更新接入网接入网网点维修台账
    /// </summary>
    public void UpdatePointRepairInfo()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        //单位
        string deptname = Convert.ToString(Request.Form["deptname"]);
        //接入网机房编号
        string anid = Convert.ToString(Request.Form["anid"]);
        //接入机房名称
        string roomname = Convert.ToString(Request.Form["roomname"]);
        //所属县市
        string cityname = Convert.ToString(Request.Form["cityname"]);
        //维修事项
        string repairinfo = Convert.ToString(Request.Form["repairinfo"]);
        //维修签报单号
        string repairreportno = Convert.ToString(Request.Form["repairreportno"]);
        //申请时间
        string applytime = Convert.ToString(Request.Form["applytime"]);
        //通知维修时间
        string noticerepairtime = Convert.ToString(Request.Form["noticerepairtime"]);
        //维修完成时间
        string repairfinishtime = Convert.ToString(Request.Form["repairfinishtime"]);
        //保修截止日期
        string warrantyexpirationdate = Convert.ToString(Request.Form["warrantyexpirationdate"]);
        //维修内容
        string repaircontent = Convert.ToString(Request.Form["repaircontent"]);
        //验收情况(包括验收人员名单)
        string checkinfo = Convert.ToString(Request.Form["checkinfo"]);
        //维修方名称
        string repairperson = Convert.ToString(Request.Form["repairperson"]);
        //维修方联系方式
        string repairpersontel = Convert.ToString(Request.Form["repairpersontel"]);
        //申请金额
        string applymoney = Convert.ToString(Request.Form["applymoney"]);
        //报账金额
        string reimnursemoney = Convert.ToString(Request.Form["reimnursemoney"]);
        //立项时间
        string projecttime = Convert.ToString(Request.Form["projecttime"]);
        //报账时间
        string reimbursetime = Convert.ToString(Request.Form["reimbursetime"]);
        //备注
        string memo = Convert.ToString(Request.Form["memo"]);
        List<SqlParameter> _paras = new List<SqlParameter>();
        _paras.Add(new SqlParameter("@id", id));
        _paras.Add(new SqlParameter("@deptname", deptname));
        _paras.Add(new SqlParameter("@anid", anid));
        _paras.Add(new SqlParameter("@roomname", roomname));
        _paras.Add(new SqlParameter("@cityname", cityname));
        _paras.Add(new SqlParameter("@repairinfo", repairinfo));
        _paras.Add(new SqlParameter("@repairreportno", repairreportno));
        _paras.Add(new SqlParameter("@applytime", applytime));
        _paras.Add(new SqlParameter("@noticerepairtime", noticerepairtime));
        _paras.Add(new SqlParameter("@repairfinishtime", repairfinishtime));
        _paras.Add(new SqlParameter("@warrantyexpirationdate", warrantyexpirationdate));
        _paras.Add(new SqlParameter("@repaircontent", repaircontent));
        _paras.Add(new SqlParameter("@checkinfo", checkinfo));
        _paras.Add(new SqlParameter("@repairperson", repairperson));
        _paras.Add(new SqlParameter("@repairpersontel", repairpersontel));
        _paras.Add(new SqlParameter("@applymoney", applymoney));
        _paras.Add(new SqlParameter("@reimnursemoney", reimnursemoney));
        _paras.Add(new SqlParameter("@projecttime", projecttime));
        _paras.Add(new SqlParameter("@reimbursetime", reimbursetime));
        _paras.Add(new SqlParameter("@memo", memo));
        StringBuilder sql = new StringBuilder();
        sql.Append("UPDATE AccessNetWork_PointRepairInfo SET  DeptName = @deptname,  ANID = @anid, ");
        sql.Append(" RoomName = @roomname,  CityName = @cityname,  RepairInfo = @repairinfo,  ");
        sql.Append("RepairReportNo = @repairreportno,  ApplyTime = @applytime,  NoticeRepairTime = @noticerepairtime,");
        sql.Append("  RepairFinishTime = @repairfinishtime,  WarrantyExpirationDate = @warrantyexpirationdate,");
        sql.Append("  RepairContent = @repaircontent,  CheckInfo = @checkinfo,  RepairPerson = @repairperson, ");
        sql.Append(" RepairPersonTel = @repairpersontel,  ApplyMoney = @applymoney,  ReimnurseMoney = @reimnursemoney, ");
        sql.Append(" ProjectTime = @projecttime,  ReimburseTime = @reimbursetime,  Memo = @memo,InputTime=getdate()  where id=@id");
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), _paras.ToArray());
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"台账更新成功！\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    //<summary>
    //新增接入网接入网网点维修台账
    //</summary>
    public void SavePointRepairInfo()
    {
        //1、获取参数
        //单位
        string deptname = Convert.ToString(Request.Form["deptname"]);
        //接入网机房编号
        string anid = Convert.ToString(Request.Form["anid"]);
        //接入机房名称
        string roomname = Convert.ToString(Request.Form["roomname"]);
        //所属县市
        string cityname = Convert.ToString(Request.Form["cityname"]);
        //维修事项
        string repairinfo = Convert.ToString(Request.Form["repairinfo"]);
        //维修签报单号
        string repairreportno = Convert.ToString(Request.Form["repairreportno"]);
        //申请时间
        string applytime = Convert.ToString(Request.Form["applytime"]);
        //通知维修时间
        string noticerepairtime = Convert.ToString(Request.Form["noticerepairtime"]);
        //维修完成时间
        string repairfinishtime = Convert.ToString(Request.Form["repairfinishtime"]);
        //保修截止日期
        string warrantyexpirationdate = Convert.ToString(Request.Form["warrantyexpirationdate"]);
        //维修内容
        string repaircontent = Convert.ToString(Request.Form["repaircontent"]);
        //验收情况(包括验收人员名单)
        string checkinfo = Convert.ToString(Request.Form["checkinfo"]);
        //维修方名称
        string repairperson = Convert.ToString(Request.Form["repairperson"]);
        //维修方联系方式
        string repairpersontel = Convert.ToString(Request.Form["repairpersontel"]);
        //申请金额
        string applymoney = Convert.ToString(Request.Form["applymoney"]);
        //报账金额
        string reimnursemoney = Convert.ToString(Request.Form["reimnursemoney"]);
        //立项时间
        string projecttime = Convert.ToString(Request.Form["projecttime"]);
        //报账时间
        string reimbursetime = Convert.ToString(Request.Form["reimbursetime"]);
        //备注
        string memo = Convert.ToString(Request.Form["memo"]);
        //设定参数
        List<SqlParameter> _paras = new List<SqlParameter>();
        _paras.Add(new SqlParameter("@deptname", deptname));
        _paras.Add(new SqlParameter("@anid", anid));
        _paras.Add(new SqlParameter("@roomname", roomname));
        _paras.Add(new SqlParameter("@cityname", cityname));
        _paras.Add(new SqlParameter("@repairinfo", repairinfo));
        _paras.Add(new SqlParameter("@repairreportno", repairreportno));
        _paras.Add(new SqlParameter("@applytime", applytime));
        _paras.Add(new SqlParameter("@noticerepairtime", noticerepairtime));
        _paras.Add(new SqlParameter("@repairfinishtime", repairfinishtime));
        _paras.Add(new SqlParameter("@warrantyexpirationdate", warrantyexpirationdate));
        _paras.Add(new SqlParameter("@repaircontent", repaircontent));
        _paras.Add(new SqlParameter("@checkinfo", checkinfo));
        _paras.Add(new SqlParameter("@repairperson", repairperson));
        _paras.Add(new SqlParameter("@repairpersontel", repairpersontel));
        _paras.Add(new SqlParameter("@applymoney", applymoney));
        _paras.Add(new SqlParameter("@reimnursemoney", reimnursemoney));
        _paras.Add(new SqlParameter("@projecttime", projecttime));
        _paras.Add(new SqlParameter("@reimbursetime", reimbursetime));
        _paras.Add(new SqlParameter("@memo", memo));
        //2、保存
        StringBuilder sql = new StringBuilder();
        sql.Append("insert AccessNetWork_PointRepairInfo values(@deptname,@anid,@roomname,");
        sql.Append("@cityname,@repairinfo,@repairreportno,@applytime,@noticerepairtime,@repairfinishtime,");
        sql.Append("@warrantyexpirationdate,@repaircontent,@checkinfo,@repairperson,@repairpersontel,");
        sql.Append("@applymoney,@reimnursemoney,@projecttime,@reimbursetime,@memo,getdate());");

        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), _paras.ToArray());
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"新增网点维修台账成功！\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错！！\"}");
    }
    #endregion 接入网网点维修台账
    #region 资源更新数量统计
    /// <summary>
    /// 设置信息更新数量查询条件
    /// </summary>
    /// <returns></returns>
    public string SetQueryConditionForInfoUpdate()
    {
        string queryStr = "";
        //设置查询条件
        List<string> list = new List<string>();
        //按日期查询
        //提交开始日期
        if (!string.IsNullOrEmpty(Request.Form["sdate"]))
            list.Add(" CONVERT(VARCHAR(50),inputtime,23) >='" + Request.Form["sdate"] + "'");
        //提交截止日期
        if (!string.IsNullOrEmpty(Request.Form["edate"]))
            list.Add(" CONVERT(VARCHAR(50),inputtime,23) <='" + Request.Form["edate"] + "'");
        if (list.Count > 0)
            queryStr = "where "+string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 获取资源更新数量统计 sort:id order:asc
    /// </summary>
    public void GetUpdateStatistics()
    {
        
        string where = SetQueryConditionForInfoUpdate();
        StringBuilder sql = new StringBuilder("SELECT a.cityname AS cityname,ISNULL(num1,'0') AS num1,ISNULL(num2,'0') AS num2 FROM ");
        sql.Append("(SELECT Cityname FROM citylist) AS a LEFT JOIN ");
        sql.Append(" (SELECT cityname,COUNT(1) as num1 FROM AccessNetWork_RoomResources ");
        sql.Append(where);
        sql.Append(" GROUP BY CityName) AS b ON a.Cityname=b.cityname LEFT JOIN ");
        sql.Append(" (SELECT cityname,COUNT(1) as num2 FROM AccessNetWork_EqInfo ");
        sql.Append(where);
        sql.Append(" GROUP BY CityName) AS c ON a.Cityname=c.cityname ");
        sql.Append("order by ");
        sql.Append(Request.Form["sort"].ToString());
        sql.Append(" ");
        sql.Append(Request.Form["order"].ToString());
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    #endregion 资源更新数量统计
    #region 用户操作记录
    /// <summary>
    /// 保存操作记录
    /// </summary>
    private void SaveOPerationLog()
    {
        List<SqlParameter> _paras = new List<SqlParameter>();
        _paras.Add(new SqlParameter("@cityname",Session["deptname"].ToString() == "网络维护中心"?"安阳市":Session["deptname"].ToString()));
        _paras.Add(new SqlParameter("@username", Session["uname"].ToString()));
        _paras.Add(new SqlParameter("@operationdate", DateTime.Now.ToString("yyyy-MM-dd")));
        string sql = "if not exists(select * from AccessNetWork_OperationLog where cityname=@cityname and username=@username and operationdate=@operationdate) ";
        sql += "INSERT AccessNetWork_OperationLog values(@cityname,@username,@operationdate)";
        SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, _paras.ToArray());
    }
     /// <summary>
    /// 设置操作记录查询条件
    /// </summary>
    /// <returns></returns>
    public string SetQueryConditionForOPLog()
    {
        string queryStr = "";
        //设置查询条件
        List<string> list = new List<string>();
        //按日期查询
        //提交开始日期
        if (!string.IsNullOrEmpty(Request.Form["sdate"]))
            list.Add(" OperationDate >='" + Request.Form["sdate"] + "'");
        //提交截止日期
        if (!string.IsNullOrEmpty(Request.Form["edate"]))
            list.Add(" OperationDate <='" + Request.Form["edate"] + "'");
        if (list.Count > 0)
            queryStr = "where "+string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 获取操作记录数量统计 sort:id order:asc
    /// </summary>
    public void GetOPStatistics()
    {

        string where = SetQueryConditionForOPLog();
        StringBuilder sql = new StringBuilder("SELECT a.cityname AS cityname,ISNULL(num1,'0') AS num1 FROM ");
        sql.Append("(SELECT Cityname FROM citylist) AS a LEFT JOIN ");
        sql.Append(" (SELECT cityname,COUNT(1) as num1 FROM AccessNetWork_OperationLog ");
        sql.Append(where);
        sql.Append(" GROUP BY CityName) AS b ON a.Cityname=b.cityname ");
        sql.Append("order by ");
        sql.Append(Request.Form["sort"].ToString());
        sql.Append(" ");
        sql.Append(Request.Form["order"].ToString());
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    #endregion 用户操作记录
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}