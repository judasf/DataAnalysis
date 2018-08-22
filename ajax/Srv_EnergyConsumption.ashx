<%@ WebHandler Language="C#" Class="Srv_EnergyConsumption" %>

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
/// 能耗管理
/// </summary>
public class Srv_EnergyConsumption : IHttpHandler, IRequiresSessionState
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
    #region 接入网机房动力信息管理
    /// <summary>
    /// 设置接入网机房动力信息查询条件
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
        //按局站编号
        if (!string.IsNullOrEmpty(Request.Form["stationid"]))
            list.Add(" stationid like'%" + Request.Form["stationid"] + "%'");
        //按机房名称
        if (!string.IsNullOrEmpty(Request.Form["roomname"]))
            list.Add(" roomname like'%" + Request.Form["roomname"] + "%'");
        //按用电类别
        if (!string.IsNullOrEmpty(Request.Form["electype"]))
            list.Add(" electype ='" + Request.Form["electype"] + "'");
        //按供电方式
        if (!string.IsNullOrEmpty(Request.Form["powersupplymode"]))
            list.Add(" powersupplymode ='" + Request.Form["powersupplymode"] + "'");
        if (roleid == "20" || roleid == "21")
        {
            if (deptname == "网络维护中心")
                list.Add(" cityname='市区' ");
            else if (deptname == "林州市")
                list.Add(" cityname='林州' ");
            else
                list.Add(" cityname='" + deptname + "' ");
        }

        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 获取接入网机房动力信息 数据page:1 rows:10 sort:id order:asc
    /// </summary>
    public void GetAccessStation()
    {
        int total = 0;
        string where = SetQueryConditionForRoom();
        string tableName = " EC_AccessStationInfo ";
        string fieldStr = "*,CONVERT(VARCHAR(50),updatetime,23) as updatedate";
        DataSet ds = SqlHelper.GetPagination(tableName, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    ///  EC_AccessStationInfo
    /// </summary>
    public void GetAccessStationInfoByID()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = id;
        string sql = "SELECT * FROM EC_AccessStationInfo  where ID=@id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    /// <summary>
    /// 导入上传的接入网机房动力信息
    /// </summary>
    /// 
    public void ImportAccessStationInfo()
    {
        string reportPath = "";
        if (!string.IsNullOrEmpty(Request.Form["report"]))
            reportPath = Server.MapPath("~") + Request.Form["report"].ToString();
        if (ExcelHelper.CheckFileExists(reportPath) == -1)
        {
            Response.Write("{\"success\":false,\"msg\":\"上传文件不存在，请检查！\"}");
            return;
        }
        string sn = "接入网机房基础信息表";
        DataTable dt = new DataTable();
        if (ExcelHelper.CheckSheetContains(reportPath, sn) == -1)
        {
            Response.Write("{\"success\":false,\"msg\":\"单元表“" + sn + "”不存在，请检查文件！\"}");
            return;
        }
        else
        {
            dt = ExcelHelper.RenderDataTableFromExcel(reportPath, sn, 1, false, 3, 1);
        }
        if (dt.TableName == "Error")
        {
            Response.Write("{\"success\":false,\"msg\":\"" + dt.Rows[0][0].ToString() + ",请检查文件！\"}");
            return;
        }
        //定义sqlparameter 
        List<SqlParameter> _paras = new List<SqlParameter>();
        StringBuilder sql = new StringBuilder();
        //遍历数据
        if (dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                try
                {
                    _paras.Add(new SqlParameter("@stationid", String.IsNullOrEmpty(dr[0].ToString()) ? "" : dr[0].ToString()));
                    _paras.Add(new SqlParameter("@roomname", String.IsNullOrEmpty(dr[1].ToString()) ? "" : dr[1].ToString()));
                    _paras.Add(new SqlParameter("@housestructure", String.IsNullOrEmpty(dr[2].ToString()) ? "" : dr[2].ToString()));
                    _paras.Add(new SqlParameter("@pointtype", String.IsNullOrEmpty(dr[3].ToString()) ? "" : dr[3].ToString()));
                    _paras.Add(new SqlParameter("@pointcategory", String.IsNullOrEmpty(dr[4].ToString()) ? "" : dr[4].ToString()));
                    _paras.Add(new SqlParameter("@cityname", String.IsNullOrEmpty(dr[5].ToString()) ? "" : dr[5].ToString()));
                    _paras.Add(new SqlParameter("@powersupplymode", String.IsNullOrEmpty(dr[6].ToString()) ? "" : dr[6].ToString()));
                    _paras.Add(new SqlParameter("@hasinvoice", String.IsNullOrEmpty(dr[7].ToString()) ? "" : dr[7].ToString()));
                    _paras.Add(new SqlParameter("@propertyright", String.IsNullOrEmpty(dr[8].ToString()) ? "" : dr[8].ToString()));
                    _paras.Add(new SqlParameter("@energysaving", String.IsNullOrEmpty(dr[9].ToString()) ? "" : dr[9].ToString()));
                    _paras.Add(new SqlParameter("@signpost", String.IsNullOrEmpty(dr[10].ToString()) ? "" : dr[10].ToString()));
                    _paras.Add(new SqlParameter("@loadcurrent", String.IsNullOrEmpty(dr[11].ToString()) ? "" : dr[11].ToString()));
                    _paras.Add(new SqlParameter("@dcpower", String.IsNullOrEmpty(dr[12].ToString()) ? "" : dr[12].ToString()));
                    _paras.Add(new SqlParameter("@acpower", String.IsNullOrEmpty(dr[13].ToString()) ? "" : dr[13].ToString()));
                    _paras.Add(new SqlParameter("@airconditionnum", String.IsNullOrEmpty(dr[14].ToString()) ? "" : dr[14].ToString()));
                    _paras.Add(new SqlParameter("@airconditionpower", String.IsNullOrEmpty(dr[15].ToString()) ? "" : dr[15].ToString()));
                    _paras.Add(new SqlParameter("@hasenergysaving", String.IsNullOrEmpty(dr[16].ToString()) ? "" : dr[16].ToString()));
                    _paras.Add(new SqlParameter("@energysavingname", String.IsNullOrEmpty(dr[17].ToString()) ? "" : dr[17].ToString()));
                    _paras.Add(new SqlParameter("@issignpost", String.IsNullOrEmpty(dr[18].ToString()) ? "" : dr[18].ToString()));
                    _paras.Add(new SqlParameter("@elecprice", String.IsNullOrEmpty(dr[19].ToString()) ? "" : dr[19].ToString()));
                    _paras.Add(new SqlParameter("@paymentcycle", String.IsNullOrEmpty(dr[20].ToString()) ? "" : dr[20].ToString()));
                    _paras.Add(new SqlParameter("@electype", String.IsNullOrEmpty(dr[21].ToString()) ? "" : dr[21].ToString()));
                    _paras.Add(new SqlParameter("@electriccontract", String.IsNullOrEmpty(dr[22].ToString()) ? "" : dr[22].ToString()));
                    _paras.Add(new SqlParameter("@ammeterno", String.IsNullOrEmpty(dr[23].ToString()) ? "" : dr[23].ToString()));
                    _paras.Add(new SqlParameter("@rate", String.IsNullOrEmpty(dr[24].ToString()) ? "" : dr[24].ToString()));
                    _paras.Add(new SqlParameter("@memo1", String.IsNullOrEmpty(dr[25].ToString()) ? "" : dr[25].ToString()));
                    _paras.Add(new SqlParameter("@memo2", String.IsNullOrEmpty(dr[26].ToString()) ? "" : dr[26].ToString()));

                    sql.Append(" IF NOT EXISTS(SELECT * FROM EC_AccessStationInfo WHERE StationID=@stationid and roomname=@roomname) ");
                    sql.Append("INSERT INTO EC_AccessStationInfo (stationid,roomname,housestructure,PointType,PointCategory,cityname,PowerSupplyMode,HasInvoice,PropertyRight,EnergySaving,signpost,loadcurrent,DCPower,ACPower,AirconditionNum,AirconditionPower,HasEnergySaving,EnergySavingName,IsSignPost,ElecPrice,Paymentcycle,ElecType,ElectricContract,ammeterNo,rate,Memo1,Memo2)");
                    sql.Append(" VALUES (@stationid,@roomname,@housestructure,@pointtype,@pointcategory,@cityname,@powersupplymode,@hasinvoice,@propertyright,@energysaving,@signpost,@loadcurrent,@dcpower,@acpower,@airconditionnum,@airconditionpower,@hasenergysaving,@energysavingname,@issignpost,@elecprice,@paymentcycle,@electype,@electriccontract,@ammeterno,@rate,@memo1,@memo2) ");
                    sql.Append(" ELSE ");
                    sql.Append("Update EC_AccessStationInfo  set  housestructure=@housestructure,pointtype=@pointtype,pointcategory=@pointcategory,cityname=@cityname,powersupplymode=@powersupplymode,hasinvoice=@hasinvoice,propertyright=@propertyright,energysaving=@energysaving,signpost=@signpost,loadcurrent=@loadcurrent,dcpower=@dcpower,acpower=@acpower,airconditionnum=@airconditionnum,airconditionpower=@airconditionpower,hasenergysaving=@hasenergysaving,energysavingname=@energysavingname,issignpost=@issignpost,elecprice=@elecprice,paymentcycle=@paymentcycle,electype=@electype,electriccontract=@electriccontract,ammeterno=@ammeterno,rate=@rate,memo1=@memo1,memo2=@memo2");
                    sql.Append(" WHERE StationID=@stationid and roomname=@roomname ");

                    SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), _paras.ToArray());
                }
                catch (Exception ex)
                {
                    Response.Write("{\"success\":false,\"msg\":\"执行出错，错误信息：" + ex.Message + ",请检查文件！\"}");
                    return;
                }
                finally
                {
                    sql.Length = 0;
                    _paras.Clear();
                }
            }
        }
        Response.Write("{\"success\":true,\"msg\":\"数据导入成功！\"}");
    }

    /// <summary>
    /// 导出接入网机房动力信息明细
    /// </summary>
    public void ExportAccessStation()
    {
        string where = SetQueryConditionForRoom();
        if (where != "")
            where = " where " + where;
        StringBuilder sql = new StringBuilder();
        sql.Append("select ROW_NUMBER() OVER(ORDER BY updatetime asc) AS rowid,stationid,roomname,housestructure,PointType,PointCategory,cityname,PowerSupplyMode,HasInvoice,PropertyRight,EnergySaving,signpost,loadcurrent,DCPower,ACPower,AirconditionNum,AirconditionPower,HasEnergySaving,EnergySavingName,IsSignPost,ElecPrice,Paymentcycle,ElecType,ElectricContract,ammeterNo,rate,Memo1,Memo2");
        sql.Append(" from EC_AccessStationInfo ");
        sql.Append(where);
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.TableName = "接入网机房基础信息表";
        ExcelHelper.ExportByWebForAccessStation(dt, "接入网机房基础信息表.xls");
    }
    /// <summary>
    /// 更新接入网机房动力信息信息
    /// </summary>
    public void UpdateAccessStationInfo()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        string stationid = Convert.ToString(Request.Form["stationid"]);
        string roomname = Convert.ToString(Request.Form["roomname"]);
        string housestructure = Convert.ToString(Request.Form["housestructure"]);
        string pointtype = Convert.ToString(Request.Form["pointtype"]);
        string pointcategory = Convert.ToString(Request.Form["pointcategory"]);
        string cityname = Convert.ToString(Request.Form["cityname"]);
        string powersupplymode = Convert.ToString(Request.Form["powersupplymode"]);
        string hasinvoice = Convert.ToString(Request.Form["hasinvoice"]);
        string propertyright = Convert.ToString(Request.Form["propertyright"]);
        string energysaving = Convert.ToString(Request.Form["energysaving"]);
        string signpost = Convert.ToString(Request.Form["signpost"]);
        string loadcurrent = Convert.ToString(Request.Form["loadcurrent"]);
        string dcpower = Convert.ToString(Request.Form["dcpower"]);
        string acpower = Convert.ToString(Request.Form["acpower"]);
        string airconditionnum = Convert.ToString(Request.Form["airconditionnum"]);
        string airconditionpower = Convert.ToString(Request.Form["airconditionpower"]);
        string hasenergysaving = Convert.ToString(Request.Form["hasenergysaving"]);
        string energysavingname = Convert.ToString(Request.Form["energysavingname"]);
        string issignpost = Convert.ToString(Request.Form["issignpost"]);
        string elecprice = Convert.ToString(Request.Form["elecprice"]);
        string paymentcycle = Convert.ToString(Request.Form["paymentcycle"]);
        string electype = Convert.ToString(Request.Form["electype"]);
        string electriccontract = Convert.ToString(Request.Form["electriccontract"]);
        string ammeterno = Convert.ToString(Request.Form["ammeterno"]);
        string rate = Convert.ToString(Request.Form["rate"]);
        string memo1 = Convert.ToString(Request.Form["memo1"]);
        string memo2 = Convert.ToString(Request.Form["memo2"]);
        List<SqlParameter> _paras = new List<SqlParameter>();
        _paras.Add(new SqlParameter("@id", id));
        _paras.Add(new SqlParameter("@stationid", stationid));
        _paras.Add(new SqlParameter("@roomname", roomname));
        _paras.Add(new SqlParameter("@housestructure", housestructure));
        _paras.Add(new SqlParameter("@pointtype", pointtype));
        _paras.Add(new SqlParameter("@pointcategory", pointcategory));
        _paras.Add(new SqlParameter("@cityname", cityname));
        _paras.Add(new SqlParameter("@powersupplymode", powersupplymode));
        _paras.Add(new SqlParameter("@hasinvoice", hasinvoice));
        _paras.Add(new SqlParameter("@propertyright", propertyright));
        _paras.Add(new SqlParameter("@energysaving", energysaving));
        _paras.Add(new SqlParameter("@signpost", signpost));
        _paras.Add(new SqlParameter("@loadcurrent", loadcurrent));
        _paras.Add(new SqlParameter("@dcpower", dcpower));
        _paras.Add(new SqlParameter("@acpower", acpower));
        _paras.Add(new SqlParameter("@airconditionnum", airconditionnum));
        _paras.Add(new SqlParameter("@airconditionpower", airconditionpower));
        _paras.Add(new SqlParameter("@hasenergysaving", hasenergysaving));
        _paras.Add(new SqlParameter("@energysavingname", energysavingname));
        _paras.Add(new SqlParameter("@issignpost", issignpost));
        _paras.Add(new SqlParameter("@elecprice", elecprice));
        _paras.Add(new SqlParameter("@paymentcycle", paymentcycle));
        _paras.Add(new SqlParameter("@electype", electype));
        _paras.Add(new SqlParameter("@electriccontract", electriccontract));
        _paras.Add(new SqlParameter("@ammeterno", ammeterno));
        _paras.Add(new SqlParameter("@rate", rate));
        _paras.Add(new SqlParameter("@memo1", memo1));
        _paras.Add(new SqlParameter("@memo2", memo2));
        StringBuilder sql = new StringBuilder();
        sql.Append("Update EC_AccessStationInfo  set  roomname=@roomname,housestructure=@housestructure,pointtype=@pointtype,pointcategory=@pointcategory,cityname=@cityname,powersupplymode=@powersupplymode,hasinvoice=@hasinvoice,propertyright=@propertyright,energysaving=@energysaving,signpost=@signpost,loadcurrent=@loadcurrent,dcpower=@dcpower,acpower=@acpower,airconditionnum=@airconditionnum,airconditionpower=@airconditionpower,hasenergysaving=@hasenergysaving,energysavingname=@energysavingname,issignpost=@issignpost,elecprice=@elecprice,paymentcycle=@paymentcycle,electype=@electype,electriccontract=@electriccontract,ammeterno=@ammeterno,rate=@rate,memo1=@memo1,memo2=@memo2,");
        sql.Append("updatetime=getdate()  where id=@id");
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), _paras.ToArray());
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"更新成功！\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"该局站编码已存在，请检查输入!\"}");
    }
    //<summary>
    //新增接入网机房动力信息
    //</summary>
    public void SaveAccessStationInfo()
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
        sql.Append("if not exists(select * from EC_AccessStationInfo where anid=@anid)");
        sql.Append("insert EC_AccessStationInfo(ANID,RoomName,CityName,RegionName,ANLevel,");
        sql.Append("[Address],PointType,Longitude,Dimension,Area,PropertyRight,ContractNO,");
        sql.Append("ContractPriod,LessorType,RentPayment,Rent,LastPayDate,DEMStatus,DEMEM,RoomPlan,");
        sql.Append("RoomResistance,PowerSupplyMode,ElectricityPrice,RoomLoadCurrent,Memo1,Memo2,Memo3,updatetime) ");
        sql.Append(" values(@anid,@roomname,@cityname,");
        sql.Append("@regionname,@anlevel,@address,@pointtype,@longitude,@dimension,@area,@propertyright,");
        sql.Append("@contractno,@contractpriod,@lessortype,@rentpayment,@rent,@lastpaydate,@demstatus,");
        sql.Append("@demem,@roomplan,@roomresistance,@powersupplymode,@electricityprice,@roomloadcurrent,@memo1,");
        sql.Append("@memo2,@memo3,getdate());");

        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), _paras.ToArray());
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"新增接入网机房动力信息成功！\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"该局站编码已存在，请检查输入！\"}");
    }
    public void RemoveRoomAndEqResourcesInfoByAnID() //RemoveAccessStationElecByID
    {
        string anid = Convert.ToString(Request.Form["anid"]);
        SqlParameter paras = new SqlParameter("@anid", SqlDbType.VarChar);
        paras.Value = anid;
        StringBuilder sql = new StringBuilder();
        sql.Append("Update EC_AccessStationInfo set IsDel=1 where anid=@anid;");
        sql.Append("Update EC_AccessStationLastElec set IsDel=1 Where anid=@anid;");
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), paras);
        if (result >= 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    #endregion 接入网机房动力信息管理
    #region 接入网机房上年电费
    /// <summary>
    /// 设置接入网机房上年电费查询条件
    /// </summary>
    /// <returns></returns>
    public string SetQueryConditionForLastElec()
    {
        string queryStr = "";
        //设置查询条件
        List<string> list = new List<string>();
        //按所属县市
        if (!string.IsNullOrEmpty(Request.Form["cityname"]))
            list.Add(" cityname ='" + Request.Form["cityname"] + "'");
        //按缴费年月
        if (!string.IsNullOrEmpty(Request.Form["paymentyear"]))
            list.Add(" paymentyearmonth ='" + Request.Form["paymentyear"] + "'");
        //按局站编号
        if (!string.IsNullOrEmpty(Request.Form["stationid"]))
            list.Add(" stationid like'%" + Request.Form["stationid"] + "%'");
        //按机房名称
        if (!string.IsNullOrEmpty(Request.Form["roomname"]))
            list.Add(" roomname like'%" + Request.Form["roomname"] + "%'");
        //按用电类别
        if (!string.IsNullOrEmpty(Request.Form["electype"]))
            list.Add(" electype ='" + Request.Form["electype"] + "'");
        //按供电方式
        if (!string.IsNullOrEmpty(Request.Form["powersupplymode"]))
            list.Add(" powersupplymode ='" + Request.Form["powersupplymode"] + "'");
        if (roleid == "20" || roleid == "21")
        {
            if (deptname == "网络维护中心")
                list.Add(" cityname='市区' ");
            else if (deptname == "林州市")
                list.Add(" cityname='林州' ");
            else
                list.Add(" cityname='" + deptname + "' ");
        }

        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 获取接入网机房上年电费 数据page:1 rows:10 sort:id order:asc
    /// </summary>
    public void GetAccessStationLastElec()
    {
        int total = 0;
        string where = SetQueryConditionForLastElec();
        string tableName = " EC_AccessStationLastElec ";
        string fieldStr = "*";
        DataSet ds = SqlHelper.GetPagination(tableName, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    /// 获取上年最后一次缴费
    /// </summary>
    public void GetAccessStationLastElecByID()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = id;
        string sql = "SELECT * FROM EC_AccessStationLastElec  where ID=@id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    /// <summary>
    /// 更新接入网上年最后一次缴费电费信息
    /// </summary>
    public void UpdateAccessStationLastElec()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        string ammeterno = Convert.ToString(Request.Form["ammeterno"]);
        string startdegrees = Convert.ToString(Request.Form["startdegrees"]);
        string enddegrees = Convert.ToString(Request.Form["enddegrees"]);
        string powerusage = Convert.ToString(Request.Form["powerusage"]);
        string elecprice = Convert.ToString(Request.Form["elecprice"]);
        string amount = Convert.ToString(Request.Form["amount"]);
        string meterperiod = Convert.ToString(Request.Form["meterperiod"]);
        string convertmonth = Convert.ToString(Request.Form["convertmonth"]);

        List<SqlParameter> _paras = new List<SqlParameter>();
        _paras.Add(new SqlParameter("@id", id));
        _paras.Add(new SqlParameter("@ammeterno", ammeterno));
        _paras.Add(new SqlParameter("@startdegrees", startdegrees));
        _paras.Add(new SqlParameter("@enddegrees", enddegrees));
        _paras.Add(new SqlParameter("@powerusage", powerusage));
        _paras.Add(new SqlParameter("@elecprice", elecprice));
        _paras.Add(new SqlParameter("@amount", amount));
        _paras.Add(new SqlParameter("@meterperiod", meterperiod));
        _paras.Add(new SqlParameter("@convertmonth", convertmonth));

        StringBuilder sql = new StringBuilder();
        sql.Append("Update EC_AccessStationLastElec  set  ammeterno=@ammeterno,startdegrees=@startdegrees,enddegrees=@enddegrees,powerusage=@powerusage,elecprice=@elecprice,amount=@amount,meterperiod=@meterperiod,convertmonth=@convertmonth");
        sql.Append(" where id=@id");
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), _paras.ToArray());
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"更新成功！\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"该局站编码已存在，请检查输入!\"}");
    }
    /// <summary>
    /// 导入接入网机房上年度最后一次交费信息
    /// </summary>
    public void ImportAccessStationLastElec()
    {
        string reportPath = "";
        if (!string.IsNullOrEmpty(Request.Form["report"]))
            reportPath = Server.MapPath("~") + Request.Form["report"].ToString();
        if (ExcelHelper.CheckFileExists(reportPath) == -1)
        {
            Response.Write("{\"success\":false,\"msg\":\"上传文件不存在，请检查！\"}");
            return;
        }
        string sn = "接入网机房上年度最后一次交费";
        DataTable dt = new DataTable();
        if (ExcelHelper.CheckSheetContains(reportPath, sn) == -1)
        {
            Response.Write("{\"success\":false,\"msg\":\"单元表“" + sn + "”不存在，请检查文件！\"}");
            return;
        }
        else
        {
            dt = ExcelHelper.RenderDataTableFromExcel(reportPath, sn, 0, false, 2, 1);
        }
        if (dt.TableName == "Error")
        {
            Response.Write("{\"success\":false,\"msg\":\"" + dt.Rows[0][0].ToString() + ",请检查文件！\"}");
            return;
        }
        //定义sqlparameter 
        List<SqlParameter> _paras = new List<SqlParameter>();
        StringBuilder sql = new StringBuilder();
        double StartDegrees, EndDegrees, PowerUsage, ElecPrice, Amount, ConvertMonth;
        //遍历数据
        if (dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                try
                {
                    _paras.Add(new SqlParameter("@stationid", String.IsNullOrEmpty(dr[0].ToString()) ? "" : dr[0].ToString()));
                    _paras.Add(new SqlParameter("@roomname", String.IsNullOrEmpty(dr[1].ToString()) ? "" : dr[1].ToString()));
                    _paras.Add(new SqlParameter("@PointCategory", String.IsNullOrEmpty(dr[2].ToString()) ? "" : dr[2].ToString()));
                    _paras.Add(new SqlParameter("@cityname", String.IsNullOrEmpty(dr[3].ToString()) ? "" : dr[3].ToString()));
                    _paras.Add(new SqlParameter("@PowerSupplyMode", String.IsNullOrEmpty(dr[4].ToString()) ? "" : dr[4].ToString()));
                    _paras.Add(new SqlParameter("@ElecType", String.IsNullOrEmpty(dr[5].ToString()) ? "" : dr[5].ToString()));
                    _paras.Add(new SqlParameter("@ammeterno", String.IsNullOrEmpty(dr[6].ToString()) ? "" : dr[6].ToString()));
                    _paras.Add(new SqlParameter("@PaymentYearMonth", String.IsNullOrEmpty(dr[7].ToString()) ? "" : dr[7].ToString()));
                    double.TryParse(dr[8].ToString(), out StartDegrees);
                    _paras.Add(new SqlParameter("@StartDegrees", StartDegrees));
                    double.TryParse(dr[9].ToString(), out EndDegrees);
                    _paras.Add(new SqlParameter("@EndDegrees", EndDegrees));
                    double.TryParse(dr[10].ToString(), out PowerUsage);
                    _paras.Add(new SqlParameter("@PowerUsage", PowerUsage));
                    double.TryParse(dr[11].ToString(), out ElecPrice);
                    _paras.Add(new SqlParameter("@ElecPrice", ElecPrice));
                    double.TryParse(dr[12].ToString(), out Amount);
                    _paras.Add(new SqlParameter("@Amount", Amount));
                    _paras.Add(new SqlParameter("@meterperiod", String.IsNullOrEmpty(dr[13].ToString()) ? "" : dr[13].ToString()));
                    double.TryParse(dr[14].ToString(), out ConvertMonth);
                    _paras.Add(new SqlParameter("@ConvertMonth", ConvertMonth));
                    sql.Append(" IF NOT EXISTS(SELECT * FROM EC_AccessStationLastElec WHERE StationID=@stationid and roomname=@roomname and PaymentYearMonth=@PaymentYearMonth) ");
                    sql.Append("INSERT INTO EC_AccessStationLastElec (stationid,roomname,PointCategory,cityname,PowerSupplyMode,ElecType,ammeterno,PaymentYearMonth,StartDegrees,EndDegrees,PowerUsage,ElecPrice,Amount,meterperiod,ConvertMonth)");
                    sql.Append(" VALUES (@stationid,@roomname,@PointCategory,@cityname,@PowerSupplyMode,@ElecType,@ammeterno,@PaymentYearMonth,@StartDegrees,@EndDegrees,@PowerUsage,@ElecPrice,@Amount,@meterperiod,@ConvertMonth) ");
                    sql.Append(" ELSE ");
                    sql.Append("Update EC_AccessStationLastElec  set  PointCategory=@PointCategory,cityname=@cityname,PowerSupplyMode=@PowerSupplyMode,ElecType=@ElecType,ammeterno=@ammeterno,StartDegrees=@StartDegrees,EndDegrees=@EndDegrees,PowerUsage=@PowerUsage,ElecPrice=@ElecPrice,Amount=@Amount,meterperiod=@meterperiod,ConvertMonth=@ConvertMonth");
                    sql.Append(" WHERE StationID=@stationid and roomname=@roomname and PaymentYearMonth=@PaymentYearMonth ");
                    SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), _paras.ToArray());
                }
                catch (Exception ex)
                {
                    Response.Write("{\"success\":false,\"msg\":\"执行出错，错误信息：" + ex.Message + ",请检查文件！\"}");
                    return;
                }
                finally
                {
                    sql.Length = 0;
                    _paras.Clear();
                }
            }
        }
        Response.Write("{\"success\":true,\"msg\":\"数据导入成功！\"}");
    }
    /// <summary>
    /// 导出接入网机房上年最后一次缴费电费台账
    /// </summary>
    public void ExportAccessStationLastElec()
    {
        string where = SetQueryConditionForLastElec();
        if (where != "")
            where = " where " + where;
        StringBuilder sql = new StringBuilder();
        sql.Append("select * from EC_AccessStationLastElec ");
        sql.Append(where);
        sql.Append(" order by id ");
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.TableName = "接入网机房上年度最后一次交费";
        ExcelHelper.ExportByWebForAccessStationLastElec(dt, "接入网机房上年度最后一次交费台账.xls");
    }
    /// <summary>
    /// 删除接入网上年缴费信息
    /// </summary>
    public void RemoveAccessStationLastElecByID()
    {
        string id = Convert.ToString(Request.Form["id"]);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.VarChar);
        paras.Value = id;
        StringBuilder sql = new StringBuilder();
        sql.Append("delete from  EC_AccessStationLastElec  where id=@id;");
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    #endregion 接入网机房上年电费
    #region 接入网机房月度电费
    /// <summary>
    /// 设置接入网机房上年电费查询条件
    /// </summary>
    /// <returns></returns>
    public string SetQueryConditionForElec()
    {
        string queryStr = "";
        //设置查询条件
        List<string> list = new List<string>();
        //按所属县市
        if (!string.IsNullOrEmpty(Request.Form["cityname"]))
            list.Add(" cityname ='" + Request.Form["cityname"] + "'");
        //按缴费年月
        if (!string.IsNullOrEmpty(Request.Form["paymentyear"]))
            list.Add(" paymentyearmonth ='" + Request.Form["paymentyear"] + "'");
        //按局站编号
        if (!string.IsNullOrEmpty(Request.Form["stationid"]))
            list.Add(" stationid like'%" + Request.Form["stationid"] + "%'");
        //按机房名称
        if (!string.IsNullOrEmpty(Request.Form["roomname"]))
            list.Add(" roomname like'%" + Request.Form["roomname"] + "%'");
        //按用电类别
        if (!string.IsNullOrEmpty(Request.Form["electype"]))
            list.Add(" electype ='" + Request.Form["electype"] + "'");
        //按供电方式
        if (!string.IsNullOrEmpty(Request.Form["powersupplymode"]))
            list.Add(" powersupplymode ='" + Request.Form["powersupplymode"] + "'");
        //按起止度校验
        if (!string.IsNullOrEmpty(Request.Form["degreescheck"]))
        {
            list.Add(" dbo.AccessDegreesCheck(id) ='" + Request.Form["degreescheck"] + "'");

        }

        //按用电量校验
        if (!string.IsNullOrEmpty(Request.Form["eleccheck"]))
        {
            if (Request.Form["eleccheck"] == "通过")
                list.Add(" (CASE EndDegrees  WHEN 0.00 THEN 0 ELSE ((EndDegrees-StartDegrees)* CASE rate WHEN '' THEN 1  ELSE rate END)-PowerUsage END >=-1.00 and CASE EndDegrees  WHEN 0.00 THEN 0 ELSE ((EndDegrees-StartDegrees)* CASE rate WHEN '' THEN 1  ELSE rate END)-PowerUsage END <=1.00)");
            else
                list.Add(" (CASE EndDegrees  WHEN 0.00 THEN 0 ELSE ((EndDegrees-StartDegrees)* CASE rate WHEN '' THEN 1  ELSE rate END)-PowerUsage END <-1.00 or CASE EndDegrees  WHEN 0.00 THEN 0 ELSE ((EndDegrees-StartDegrees)* CASE rate WHEN '' THEN 1  ELSE rate END)-PowerUsage END >1.00)");

        }
        //按金额校验
        if (!string.IsNullOrEmpty(Request.Form["amountcheck"]))
        {
            if (Request.Form["amountcheck"] == "通过")
                list.Add(" (CAST(((PowerUsage+loss)*ElecPrice-Amount) AS DECIMAL(18,2))>=-1.00  and CAST(((PowerUsage+loss)*ElecPrice-Amount) AS DECIMAL(18,2)) <=1.00)");
            else
                list.Add(" (CAST(((PowerUsage+loss)*ElecPrice-Amount) AS DECIMAL(18,2))<-1.00  or CAST(((PowerUsage+loss)*ElecPrice-Amount) AS DECIMAL(18,2)) >1.00)");

        }
        if (roleid == "20" || roleid == "21")
        {
            if (deptname == "网络维护中心")
                list.Add(" cityname='市区' ");
            else if (deptname == "林州市")
                list.Add(" cityname='林州' ");
            else
                list.Add(" cityname='" + deptname + "' ");
        }

        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 获取接入网机房月度电费 数据page:1 rows:10 sort:id order:asc
    /// </summary>
    public void GetAccessStationElec()
    {
        int total = 0;
        string where = SetQueryConditionForElec();
        //Response.Write(where);
        string tableName = " EC_AccessStationElec ";
        string fieldStr = "CAST(((PowerUsage+loss)*ElecPrice-Amount) AS DECIMAL(18,2)) as amountcheck,*,CASE EndDegrees  WHEN 0.00 THEN 0 ELSE ((EndDegrees-StartDegrees)* CASE rate WHEN '' THEN 1  ELSE rate END)-PowerUsage END as eleccheck,dbo.AccessDegreesCheck(id) as degreescheck";
        DataSet ds = SqlHelper.GetPagination(tableName, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        string sql_All = "SELECT SUM(PowerUsage) AS allpower,SUM(Amount) AS allamount  FROM dbo.EC_AccessStationElec";
        sql_All = where.Length > 0 ? sql_All + " where " + where : sql_All;
        DataSet ds_All = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql_All);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds.Tables[0], ds_All.Tables[0], total, true, "powerusage,amount", "electype", "当前页合计"));
    }
    /// <summary>
    ///  EC_AccessStationElec
    /// </summary>
    public void GetAccessStationElecByID()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = id;
        string sql = "SELECT * FROM EC_AccessStationElec  where ID=@id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    /// <summary>
    /// 更新接入网机房月度电费信息
    /// </summary>
    public void UpdateAccessStationElecInfo()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        string ammeterno = Convert.ToString(Request.Form["ammeterno"]);
        string startdegrees = Convert.ToString(Request.Form["startdegrees"]);
        string enddegrees = Convert.ToString(Request.Form["enddegrees"]);
        string powerusage = Convert.ToString(Request.Form["powerusage"]);
        string rate = Convert.ToString(Request.Form["rate"]);
        string loss = Convert.ToString(Request.Form["loss"]);
        string elecprice = Convert.ToString(Request.Form["elecprice"]);
        string amount = Convert.ToString(Request.Form["amount"]);
        string meterperiod = Convert.ToString(Request.Form["meterperiod"]);
        string convertmonth = Convert.ToString(Request.Form["convertmonth"]);
        string memo = Convert.ToString(Request.Form["memo"]);

        List<SqlParameter> _paras = new List<SqlParameter>();
        _paras.Add(new SqlParameter("@id", id));
        _paras.Add(new SqlParameter("@ammeterno", ammeterno));
        _paras.Add(new SqlParameter("@startdegrees", startdegrees));
        _paras.Add(new SqlParameter("@enddegrees", enddegrees));
        _paras.Add(new SqlParameter("@powerusage", powerusage));
        _paras.Add(new SqlParameter("@rate", rate));
        _paras.Add(new SqlParameter("@loss", loss));
        _paras.Add(new SqlParameter("@elecprice", elecprice));
        _paras.Add(new SqlParameter("@amount", amount));
        _paras.Add(new SqlParameter("@meterperiod", meterperiod));
        _paras.Add(new SqlParameter("@convertmonth", convertmonth));
        _paras.Add(new SqlParameter("@memo", memo));

        StringBuilder sql = new StringBuilder();
        sql.Append("Update EC_AccessStationElec  set  ammeterno=@ammeterno,startdegrees=@startdegrees,enddegrees=@enddegrees,powerusage=@powerusage,rate=@rate,loss=@loss,elecprice=@elecprice,amount=@amount,meterperiod=@meterperiod,convertmonth=@convertmonth,memo=@memo");
        sql.Append(" where id=@id");
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), _paras.ToArray());
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"更新成功！\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"该局站编码已存在，请检查输入!\"}");
    }
    /// <summary>
    /// 导入接入网机房月度电费信息
    /// </summary>
    public void ImportAccessStationElec()
    {
        string reportPath = "";
        if (!string.IsNullOrEmpty(Request.Form["report"]))
            reportPath = Server.MapPath("~") + Request.Form["report"].ToString();
        if (ExcelHelper.CheckFileExists(reportPath) == -1)
        {
            Response.Write("{\"success\":false,\"msg\":\"上传文件不存在，请检查！\"}");
            return;
        }
        string sn = "接入网机房月度电费台账";
        DataTable dt = new DataTable();
        if (ExcelHelper.CheckSheetContains(reportPath, sn) == -1)
        {
            Response.Write("{\"success\":false,\"msg\":\"单元表“" + sn + "”不存在，请检查文件！\"}");
            return;
        }
        else
        {
            dt = ExcelHelper.RenderDataTableFromExcel(reportPath, sn, 0, false, 2, 1);
        }
        if (dt.TableName == "Error")
        {
            Response.Write("{\"success\":false,\"msg\":\"" + dt.Rows[0][0].ToString() + ",请检查文件！\"}");
            return;
        }
        //定义sqlparameter 
        List<SqlParameter> _paras = new List<SqlParameter>();
        StringBuilder sql = new StringBuilder();
        double StartDegrees, EndDegrees, PowerUsage, ElecPrice, loss, Amount, ConvertMonth;
        //遍历数据
        if (dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                try
                {
                    _paras.Add(new SqlParameter("@stationid", String.IsNullOrEmpty(dr[0].ToString()) ? "" : dr[0].ToString()));
                    _paras.Add(new SqlParameter("@roomname", String.IsNullOrEmpty(dr[1].ToString()) ? "" : dr[1].ToString()));
                    _paras.Add(new SqlParameter("@PointCategory", String.IsNullOrEmpty(dr[2].ToString()) ? "" : dr[2].ToString()));
                    _paras.Add(new SqlParameter("@cityname", String.IsNullOrEmpty(dr[3].ToString()) ? "" : dr[3].ToString()));
                    _paras.Add(new SqlParameter("@PowerSupplyMode", String.IsNullOrEmpty(dr[4].ToString()) ? "" : dr[4].ToString()));
                    _paras.Add(new SqlParameter("@ElecType", String.IsNullOrEmpty(dr[5].ToString()) ? "" : dr[5].ToString()));
                    _paras.Add(new SqlParameter("@ammeterno", String.IsNullOrEmpty(dr[6].ToString()) ? "" : dr[6].ToString()));
                    _paras.Add(new SqlParameter("@PaymentYearMonth", String.IsNullOrEmpty(dr[7].ToString()) ? "" : dr[7].ToString()));
                    double.TryParse(dr[8].ToString(), out StartDegrees);
                    _paras.Add(new SqlParameter("@StartDegrees", StartDegrees));
                    double.TryParse(dr[9].ToString(), out EndDegrees);
                    _paras.Add(new SqlParameter("@EndDegrees", EndDegrees));
                    double.TryParse(dr[10].ToString(), out PowerUsage);
                    _paras.Add(new SqlParameter("@PowerUsage", PowerUsage));
                    _paras.Add(new SqlParameter("@rate", String.IsNullOrEmpty(dr[11].ToString()) ? "" : dr[11].ToString()));
                    double.TryParse(dr[12].ToString(), out loss);
                    _paras.Add(new SqlParameter("@loss", loss));
                    double.TryParse(dr[13].ToString(), out ElecPrice);
                    _paras.Add(new SqlParameter("@ElecPrice", ElecPrice));
                    double.TryParse(dr[14].ToString(), out Amount);
                    _paras.Add(new SqlParameter("@Amount", Amount));
                    _paras.Add(new SqlParameter("@meterperiod", String.IsNullOrEmpty(dr[14].ToString()) ? "" : dr[15].ToString()));
                    double.TryParse(dr[16].ToString(), out ConvertMonth);
                    _paras.Add(new SqlParameter("@ConvertMonth", ConvertMonth));
                    _paras.Add(new SqlParameter("@memo", String.IsNullOrEmpty(dr[17].ToString()) ? "" : dr[17].ToString()));
                    sql.Append(" IF NOT EXISTS(SELECT * FROM EC_AccessStationElec WHERE StationID=@stationid and roomname=@roomname and PaymentYearMonth=@PaymentYearMonth) ");
                    sql.Append("INSERT INTO EC_AccessStationElec (stationid,roomname,PointCategory,cityname,PowerSupplyMode,ElecType,ammeterno,PaymentYearMonth,StartDegrees,EndDegrees,PowerUsage,rate,loss,ElecPrice,Amount,meterperiod,ConvertMonth,memo)");
                    sql.Append(" VALUES (@stationid,@roomname,@PointCategory,@cityname,@PowerSupplyMode,@ElecType,@ammeterno,@PaymentYearMonth,@StartDegrees,@EndDegrees,@PowerUsage,@rate,@loss,@ElecPrice,@Amount,@meterperiod,@ConvertMonth,@memo) ");
                    sql.Append(" ELSE ");
                    sql.Append("Update EC_AccessStationElec  set  PointCategory=@PointCategory,cityname=@cityname,PowerSupplyMode=@PowerSupplyMode,ElecType=@ElecType,ammeterno=@ammeterno,StartDegrees=@StartDegrees,EndDegrees=@EndDegrees,PowerUsage=@PowerUsage,rate=@rate,loss=@loss,ElecPrice=@ElecPrice,Amount=@Amount,meterperiod=@meterperiod,ConvertMonth=@ConvertMonth,memo=@memo");
                    sql.Append(" WHERE StationID=@stationid and roomname=@roomname and PaymentYearMonth=@PaymentYearMonth");
                    SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), _paras.ToArray());
                }
                catch (Exception ex)
                {
                    Response.Write("{\"success\":false,\"msg\":\"执行出错，错误信息：" + ex.Message + ",请检查文件！\"}");
                    return;
                }
                finally
                {
                    sql.Length = 0;
                    _paras.Clear();
                }
            }
        }
        Response.Write("{\"success\":true,\"msg\":\"数据导入成功！\"}");
    }
    /// <summary>
    /// 导出接入网机房月度电费台账
    /// </summary>
    public void ExportAccessStationElec()
    {
        string where = SetQueryConditionForElec();
        if (where != "")
            where = " where " + where;
        StringBuilder sql = new StringBuilder();
        sql.Append("select ROW_NUMBER() OVER(ORDER BY paymentyearmonth asc) AS rowid,stationid,roomname,pointcategory,cityname,powersupplymode,electype,ammeterno,paymentyearmonth,startdegrees,enddegrees,powerusage,rate,loss,elecprice,amount,meterperiod,convertmonth,memo,dbo.AccessDegreesCheck(id) as degreescheck,CASE EndDegrees  WHEN 0.00 THEN 0 ELSE ((EndDegrees-StartDegrees)* CASE rate WHEN '' THEN 1  ELSE rate END)-PowerUsage END as eleccheck,CAST(((PowerUsage+loss)*ElecPrice-Amount) AS DECIMAL(18,2)) as amountcheck");
        sql.Append(" from EC_AccessStationElec ");
        sql.Append(where);
        sql.Append(" order by paymentyearmonth ");
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.TableName = "接入网机房月度电费台账";
        ExcelHelper.ExportByWebForAccessStationElec(dt, "接入网机房月度电费台账.xls");
    }
    /// <summary>
    /// 删除接入网月度电费信息
    /// </summary>
    public void RemoveAccessStationElecByID()
    {
        string id = Convert.ToString(Request.Form["id"]);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.VarChar);
        paras.Value = id;
        StringBuilder sql = new StringBuilder();
        sql.Append("delete from  EC_AccessStationElec  where id=@id;");
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    #endregion 接入网机房月度电费
    #region 保留基站信息管理
    /// <summary>
    /// 设置保留基站信息查询条件
    /// </summary>
    /// <returns></returns>
    public string SetQueryConditionForRetainInfo()
    {
        string queryStr = "";
        //设置查询条件
        List<string> list = new List<string>();
        //按所属县市
        if (!string.IsNullOrEmpty(Request.Form["cityname"]))
            list.Add(" cityname ='" + Request.Form["cityname"] + "'");
        //按局站编号
        if (!string.IsNullOrEmpty(Request.Form["stationid"]))
            list.Add(" stationid like'%" + Request.Form["stationid"] + "%'");
        //按基站名称
        if (!string.IsNullOrEmpty(Request.Form["stationname"]))
            list.Add(" stationname like'%" + Request.Form["stationname"] + "%'");
        //按用电类别
        if (!string.IsNullOrEmpty(Request.Form["electype"]))
            list.Add(" electype ='" + Request.Form["electype"] + "'");
        if (roleid == "20" || roleid == "21")
        {
            if (deptname == "网络维护中心")
                list.Add(" cityname='市区' ");
            else if (deptname == "林州市")
                list.Add(" cityname='林州' ");
            else
                list.Add(" cityname='" + deptname + "' ");
        }

        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 获取保留基站信息 数据page:1 rows:10 sort:id order:asc
    /// </summary>
    public void GetRetainStation()
    {
        int total = 0;
        string where = SetQueryConditionForRetainInfo();
        string tableName = " EC_RetainStationInfo ";
        string fieldStr = "*,CONVERT(VARCHAR(50),updatetime,23) as updatedate";
        DataSet ds = SqlHelper.GetPagination(tableName, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    ///  EC_RetainStationInfo
    /// </summary>
    public void GetRetainStationInfoByID()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = id;
        string sql = "SELECT * FROM EC_RetainStationInfo  where ID=@id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    /// <summary>
    /// 导入上传的保留基站信息
    /// </summary>
    /// 
    public void ImportRetainStationInfo()
    {
        string reportPath = "";
        if (!string.IsNullOrEmpty(Request.Form["report"]))
            reportPath = Server.MapPath("~") + Request.Form["report"].ToString();
        if (ExcelHelper.CheckFileExists(reportPath) == -1)
        {
            Response.Write("{\"success\":false,\"msg\":\"上传文件不存在，请检查！\"}");
            return;
        }
        string sn = "保留基站基础信息表";
        DataTable dt = new DataTable();
        if (ExcelHelper.CheckSheetContains(reportPath, sn) == -1)
        {
            Response.Write("{\"success\":false,\"msg\":\"单元表“" + sn + "”不存在，请检查文件！\"}");
            return;
        }
        else
        {
            dt = ExcelHelper.RenderDataTableFromExcel(reportPath, sn, 1, false, 3, 1);
        }
        if (dt.TableName == "Error")
        {
            Response.Write("{\"success\":false,\"msg\":\"" + dt.Rows[0][0].ToString() + ",请检查文件！\"}");
            return;
        }
        //定义sqlparameter 
        List<SqlParameter> _paras = new List<SqlParameter>();
        StringBuilder sql = new StringBuilder();
        //遍历数据
        if (dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                try
                {
                    _paras.Add(new SqlParameter("@stationname", String.IsNullOrEmpty(dr[0].ToString()) ? "" : dr[0].ToString()));
                    _paras.Add(new SqlParameter("@stationid", String.IsNullOrEmpty(dr[1].ToString()) ? "" : dr[1].ToString()));
                    _paras.Add(new SqlParameter("@sharedrelation", String.IsNullOrEmpty(dr[2].ToString()) ? "" : dr[2].ToString()));
                    _paras.Add(new SqlParameter("@stationtype", String.IsNullOrEmpty(dr[3].ToString()) ? "" : dr[3].ToString()));
                    _paras.Add(new SqlParameter("@stationcategory", String.IsNullOrEmpty(dr[4].ToString()) ? "" : dr[4].ToString()));
                    _paras.Add(new SqlParameter("@fannum", String.IsNullOrEmpty(dr[5].ToString()) ? "" : dr[5].ToString()));
                    _paras.Add(new SqlParameter("@switchcurrent", String.IsNullOrEmpty(dr[6].ToString()) ? "" : dr[6].ToString()));
                    _paras.Add(new SqlParameter("@airconditionpower", String.IsNullOrEmpty(dr[7].ToString()) ? "" : dr[7].ToString()));
                    _paras.Add(new SqlParameter("@cityname", String.IsNullOrEmpty(dr[8].ToString()) ? "" : dr[8].ToString()));
                    _paras.Add(new SqlParameter("@electype", String.IsNullOrEmpty(dr[9].ToString()) ? "" : dr[9].ToString()));
                    _paras.Add(new SqlParameter("@ammeterno", String.IsNullOrEmpty(dr[10].ToString()) ? "" : dr[10].ToString()));
                    _paras.Add(new SqlParameter("@elecprice", String.IsNullOrEmpty(dr[11].ToString()) ? "" : dr[11].ToString()));
                    _paras.Add(new SqlParameter("@paymentcycle", String.IsNullOrEmpty(dr[12].ToString()) ? "" : dr[12].ToString()));


                    sql.Append(" IF NOT EXISTS(SELECT * FROM EC_RetainStationInfo WHERE StationID=@stationid and stationname=@stationname) ");
                    sql.Append("INSERT INTO EC_RetainStationInfo (stationname,stationid,sharedrelation,stationtype,stationcategory,fannum,switchcurrent,airconditionpower,cityname,electype,ammeterno,elecprice,paymentcycle)");
                    sql.Append(" VALUES (@stationname,@stationid,@sharedrelation,@stationtype,@stationcategory,@fannum,@switchcurrent,@airconditionpower,@cityname,@electype,@ammeterno,@elecprice,@paymentcycle) ");
                    sql.Append(" ELSE ");
                    sql.Append("Update EC_RetainStationInfo  set  sharedrelation=@sharedrelation,stationtype=@stationtype,stationcategory=@stationcategory,fannum=@fannum,switchcurrent=@switchcurrent,airconditionpower=@airconditionpower,cityname=@cityname,electype=@electype,ammeterno=@ammeterno,elecprice=@elecprice,paymentcycle=@paymentcycle");
                    sql.Append(" WHERE StationID=@stationid and stationname=@stationname ");

                    SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), _paras.ToArray());
                }
                catch (Exception ex)
                {
                    Response.Write("{\"success\":false,\"msg\":\"执行出错，错误信息：" + ex.Message + ",请检查文件！\"}");
                    return;
                }
                finally
                {
                    sql.Length = 0;
                    _paras.Clear();
                }
            }
        }
        Response.Write("{\"success\":true,\"msg\":\"数据导入成功！\"}");
    }

    /// <summary>
    /// 导出保留基站信息明细
    /// </summary>
    public void ExportRetainStation()
    {
        string where = SetQueryConditionForRetainInfo();
        if (where != "")
            where = " where " + where;
        StringBuilder sql = new StringBuilder();
        sql.Append("select ROW_NUMBER() OVER(ORDER BY updatetime asc) AS rowid,stationname,stationid,sharedrelation,stationtype,stationcategory,fannum,switchcurrent,airconditionpower,cityname,electype,ammeterno,elecprice,paymentcycle");
        sql.Append(" from EC_RetainStationInfo ");
        sql.Append(where);
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.TableName = "保留基站基础信息表";
        ExcelHelper.ExportByWebForRetainStation(dt, "保留基站基础信息表.xls");
    }
    /// <summary>
    /// 更新保留基站信息信息
    /// </summary>
    public void UpdateRetainStationInfo()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        string stationname = Convert.ToString(Request.Form["stationname"]);
        string stationid = Convert.ToString(Request.Form["stationid"]);
        string sharedrelation = Convert.ToString(Request.Form["sharedrelation"]);
        string stationtype = Convert.ToString(Request.Form["stationtype"]);
        string stationcategory = Convert.ToString(Request.Form["stationcategory"]);
        string fannum = Convert.ToString(Request.Form["fannum"]);
        string switchcurrent = Convert.ToString(Request.Form["switchcurrent"]);
        string airconditionpower = Convert.ToString(Request.Form["airconditionpower"]);
        string cityname = Convert.ToString(Request.Form["cityname"]);
        string electype = Convert.ToString(Request.Form["electype"]);
        string ammeterno = Convert.ToString(Request.Form["ammeterno"]);
        string elecprice = Convert.ToString(Request.Form["elecprice"]);
        string paymentcycle = Convert.ToString(Request.Form["paymentcycle"]);

        List<SqlParameter> _paras = new List<SqlParameter>();
        _paras.Add(new SqlParameter("@id", id));
        _paras.Add(new SqlParameter("@stationname", stationname));
        _paras.Add(new SqlParameter("@stationid", stationid));
        _paras.Add(new SqlParameter("@sharedrelation", sharedrelation));
        _paras.Add(new SqlParameter("@stationtype", stationtype));
        _paras.Add(new SqlParameter("@stationcategory", stationcategory));
        _paras.Add(new SqlParameter("@fannum", fannum));
        _paras.Add(new SqlParameter("@switchcurrent", switchcurrent));
        _paras.Add(new SqlParameter("@airconditionpower", airconditionpower));
        _paras.Add(new SqlParameter("@cityname", cityname));
        _paras.Add(new SqlParameter("@electype", electype));
        _paras.Add(new SqlParameter("@ammeterno", ammeterno));
        _paras.Add(new SqlParameter("@elecprice", elecprice));
        _paras.Add(new SqlParameter("@paymentcycle", paymentcycle));
        StringBuilder sql = new StringBuilder();
        sql.Append("if not exists(select * from EC_RetainStationInfo where id<>@id and stationid=@stationid)");
        sql.Append("Update EC_RetainStationInfo  set  stationname=@stationname,stationid=@stationid,sharedrelation=@sharedrelation,stationtype=@stationtype,stationcategory=@stationcategory,fannum=@fannum,switchcurrent=@switchcurrent,airconditionpower=@airconditionpower,cityname=@cityname,electype=@electype,ammeterno=@ammeterno,elecprice=@elecprice,paymentcycle=@paymentcycle,");
        sql.Append("updatetime=getdate()  where id=@id");
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), _paras.ToArray());
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"更新成功！\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"该基站编码已存在，请检查输入!\"}");
    }
    //<summary>
    //新增保留基站信息
    //</summary>
    public void SaveRetainStationInfo()
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
        sql.Append("if not exists(select * from EC_RetainStationInfo where anid=@anid)");
        sql.Append("insert EC_RetainStationInfo(ANID,RoomName,CityName,RegionName,ANLevel,");
        sql.Append("[Address],PointType,Longitude,Dimension,Area,PropertyRight,ContractNO,");
        sql.Append("ContractPriod,LessorType,RentPayment,Rent,LastPayDate,DEMStatus,DEMEM,RoomPlan,");
        sql.Append("RoomResistance,PowerSupplyMode,ElectricityPrice,RoomLoadCurrent,Memo1,Memo2,Memo3,updatetime) ");
        sql.Append(" values(@anid,@roomname,@cityname,");
        sql.Append("@regionname,@anlevel,@address,@pointtype,@longitude,@dimension,@area,@propertyright,");
        sql.Append("@contractno,@contractpriod,@lessortype,@rentpayment,@rent,@lastpaydate,@demstatus,");
        sql.Append("@demem,@roomplan,@roomresistance,@powersupplymode,@electricityprice,@roomloadcurrent,@memo1,");
        sql.Append("@memo2,@memo3,getdate());");

        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), _paras.ToArray());
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"新增保留基站信息成功！\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"该基站编码已存在，请检查输入！\"}");
    }
    #endregion 保留基站信息管理
    #region 保留基站上年电费
    /// <summary>
    /// 设置保留基站上年电费查询条件
    /// </summary>
    /// <returns></returns>
    public string SetQueryConditionForRetainLastElec()
    {
        string queryStr = "";
        //设置查询条件
        List<string> list = new List<string>();
        //按所属县市
        if (!string.IsNullOrEmpty(Request.Form["cityname"]))
            list.Add(" cityname ='" + Request.Form["cityname"] + "'");
        //按缴费年月
        if (!string.IsNullOrEmpty(Request.Form["paymentyear"]))
            list.Add(" paymentyearmonth ='" + Request.Form["paymentyear"] + "'");
        //按局站编号
        if (!string.IsNullOrEmpty(Request.Form["stationid"]))
            list.Add(" stationid like'%" + Request.Form["stationid"] + "%'");
        //按基站名称
        if (!string.IsNullOrEmpty(Request.Form["stationname"]))
            list.Add(" stationname like'%" + Request.Form["stationname"] + "%'");
        //按用电类别
        if (!string.IsNullOrEmpty(Request.Form["electype"]))
            list.Add(" electype ='" + Request.Form["electype"] + "'");
        if (roleid == "20" || roleid == "21")
        {
            if (deptname == "网络维护中心")
                list.Add(" cityname='市区' ");
            else if (deptname == "林州市")
                list.Add(" cityname='林州' ");
            else
                list.Add(" cityname='" + deptname + "' ");
        }

        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 获取保留基站上年电费 数据page:1 rows:10 sort:id order:asc
    /// </summary>
    public void GetRetainStationLastElec()
    {
        int total = 0;
        string where = SetQueryConditionForRetainLastElec();
        string tableName = " EC_RetainStationLastElec ";
        string fieldStr = "*";
        DataSet ds = SqlHelper.GetPagination(tableName, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    ///  EC_RetainStationLastElec
    /// </summary>
    public void GetRetainStationLastElecByID()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = id;
        string sql = "SELECT * FROM EC_RetainStationLastElec  where ID=@id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    /// <summary>
    /// 导入保留基站上年度最后一次交费信息
    /// </summary>
    public void ImportRetainStationLastElec()
    {
        string reportPath = "";
        if (!string.IsNullOrEmpty(Request.Form["report"]))
            reportPath = Server.MapPath("~") + Request.Form["report"].ToString();
        if (ExcelHelper.CheckFileExists(reportPath) == -1)
        {
            Response.Write("{\"success\":false,\"msg\":\"上传文件不存在，请检查！\"}");
            return;
        }
        string sn = "保留基站上年度最后一次交费";
        DataTable dt = new DataTable();
        if (ExcelHelper.CheckSheetContains(reportPath, sn) == -1)
        {
            Response.Write("{\"success\":false,\"msg\":\"单元表“" + sn + "”不存在，请检查文件！\"}");
            return;
        }
        else
        {
            dt = ExcelHelper.RenderDataTableFromExcel(reportPath, sn, 0, false, 2, 1);
        }
        if (dt.TableName == "Error")
        {
            Response.Write("{\"success\":false,\"msg\":\"" + dt.Rows[0][0].ToString() + ",请检查文件！\"}");
            return;
        }
        //定义sqlparameter 
        List<SqlParameter> _paras = new List<SqlParameter>();
        StringBuilder sql = new StringBuilder();
        double StartDegrees, EndDegrees, PowerUsage, ElecPrice, loss, Amount, ConvertMonth;
        //遍历数据
        if (dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                try
                {
                    _paras.Add(new SqlParameter("@stationname", String.IsNullOrEmpty(dr[0].ToString()) ? "" : dr[0].ToString()));
                    _paras.Add(new SqlParameter("@stationid", String.IsNullOrEmpty(dr[1].ToString()) ? "" : dr[1].ToString()));
                    _paras.Add(new SqlParameter("@sharedrelation", String.IsNullOrEmpty(dr[2].ToString()) ? "" : dr[2].ToString()));
                    _paras.Add(new SqlParameter("@stationtype", String.IsNullOrEmpty(dr[3].ToString()) ? "" : dr[3].ToString()));
                    _paras.Add(new SqlParameter("@cityname", String.IsNullOrEmpty(dr[4].ToString()) ? "" : dr[4].ToString()));
                    _paras.Add(new SqlParameter("@electype", String.IsNullOrEmpty(dr[5].ToString()) ? "" : dr[5].ToString()));
                    _paras.Add(new SqlParameter("@ammeterno", String.IsNullOrEmpty(dr[6].ToString()) ? "" : dr[6].ToString()));
                    _paras.Add(new SqlParameter("@paymentyearmonth", String.IsNullOrEmpty(dr[7].ToString()) ? "" : dr[7].ToString()));

                    double.TryParse(dr[8].ToString(), out StartDegrees);
                    _paras.Add(new SqlParameter("@StartDegrees", StartDegrees));
                    double.TryParse(dr[9].ToString(), out EndDegrees);
                    _paras.Add(new SqlParameter("@EndDegrees", EndDegrees));
                    _paras.Add(new SqlParameter("@rate", String.IsNullOrEmpty(dr[10].ToString()) ? "" : dr[10].ToString()));
                    double.TryParse(dr[11].ToString(), out loss);
                    _paras.Add(new SqlParameter("@loss", loss));
                    double.TryParse(dr[12].ToString(), out PowerUsage);
                    _paras.Add(new SqlParameter("@PowerUsage", PowerUsage));
                    double.TryParse(dr[13].ToString(), out ElecPrice);
                    _paras.Add(new SqlParameter("@ElecPrice", ElecPrice));
                    double.TryParse(dr[14].ToString(), out Amount);
                    _paras.Add(new SqlParameter("@Amount", Amount));
                    _paras.Add(new SqlParameter("@meterperiod", String.IsNullOrEmpty(dr[15].ToString()) ? "" : dr[15].ToString()));
                    double.TryParse(dr[16].ToString(), out ConvertMonth);
                    _paras.Add(new SqlParameter("@ConvertMonth", ConvertMonth));
                    sql.Append(" IF NOT EXISTS(SELECT * FROM EC_RetainStationLastElec WHERE StationID=@stationid and stationname=@stationname and PaymentYearMonth=@PaymentYearMonth) ");
                    sql.Append("INSERT INTO EC_RetainStationLastElec (stationname,stationid,SharedRelation,stationtype,cityname,ElecType,ammeterNo,PaymentYearMonth,StartDegrees,EndDegrees,rate,loss,PowerUsage,ElecPrice,Amount,meterperiod,ConvertMonth)");
                    sql.Append(" VALUES (@stationname,@stationid,@sharedrelation,@stationtype,@cityname,@electype,@ammeterno,@paymentyearmonth,@startdegrees,@enddegrees,@rate,@loss,@powerusage,@elecprice,@amount,@meterperiod,@convertmonth) ");
                    sql.Append(" ELSE ");
                    sql.Append("Update EC_RetainStationLastElec  set  sharedrelation=@sharedrelation,stationtype=@stationtype,cityname=@cityname,electype=@electype,ammeterno=@ammeterno,paymentyearmonth=@paymentyearmonth,startdegrees=@startdegrees,enddegrees=@enddegrees,rate=@rate,loss=@loss,powerusage=@powerusage,elecprice=@elecprice,amount=@amount,meterperiod=@meterperiod,convertmonth=@convertmonth");
                    sql.Append(" WHERE StationID=@stationid and stationname=@stationname and PaymentYearMonth=@PaymentYearMonth ");
                    SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), _paras.ToArray());
                }
                catch (Exception ex)
                {
                    Response.Write("{\"success\":false,\"msg\":\"执行出错，错误信息：" + ex.Message + ",请检查文件！\"}");
                    return;
                }
                finally
                {
                    sql.Length = 0;
                    _paras.Clear();
                }
            }
        }
        Response.Write("{\"success\":true,\"msg\":\"数据导入成功！\"}");
    }
    /// <summary>
    /// 导出保留基站上年最后一次缴费电费台账
    /// </summary>
    public void ExportRetainStationLastElec()
    {
        string where = SetQueryConditionForRetainLastElec();
        if (where != "")
            where = " where " + where;
        StringBuilder sql = new StringBuilder();
        sql.Append("select  * from EC_RetainStationLastElec ");
        sql.Append(where);
        sql.Append(" order by id ");
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.TableName = "保留基站上年度最后一次交费";
        ExcelHelper.ExportByWebForRetainStationLastElec(dt, "保留基站上年度最后一次交费台账.xls");
    }
    /// <summary>
    /// 更新保留基站上年最后一次缴费信息
    /// </summary>
    public void UpdateRetainStationLastElec()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        string startdegrees = Convert.ToString(Request.Form["startdegrees"]);
        string enddegrees = Convert.ToString(Request.Form["enddegrees"]);
        string powerusage = Convert.ToString(Request.Form["powerusage"]);
        string rate = Convert.ToString(Request.Form["rate"]);
        string loss = Convert.ToString(Request.Form["loss"]);
        string elecprice = Convert.ToString(Request.Form["elecprice"]);
        string amount = Convert.ToString(Request.Form["amount"]);
        string meterperiod = Convert.ToString(Request.Form["meterperiod"]);
        string convertmonth = Convert.ToString(Request.Form["convertmonth"]);

        List<SqlParameter> _paras = new List<SqlParameter>();
        _paras.Add(new SqlParameter("@id", id));
        _paras.Add(new SqlParameter("@startdegrees", startdegrees));
        _paras.Add(new SqlParameter("@enddegrees", enddegrees));
        _paras.Add(new SqlParameter("@powerusage", powerusage));
        _paras.Add(new SqlParameter("@rate", rate));
        _paras.Add(new SqlParameter("@loss", loss));
        _paras.Add(new SqlParameter("@elecprice", elecprice));
        _paras.Add(new SqlParameter("@amount", amount));
        _paras.Add(new SqlParameter("@meterperiod", meterperiod));
        _paras.Add(new SqlParameter("@convertmonth", convertmonth));

        StringBuilder sql = new StringBuilder();
        sql.Append("Update EC_RetainStationLastElec  set  startdegrees=@startdegrees,enddegrees=@enddegrees,powerusage=@powerusage,rate=@rate,loss=@loss,elecprice=@elecprice,amount=@amount,meterperiod=@meterperiod,convertmonth=@convertmonth");
        sql.Append(" where id=@id");
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), _paras.ToArray());
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"更新成功！\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"该局站编码已存在，请检查输入!\"}");
    }
    /// <summary>
    /// 删除保留基站上年最后一次缴费信息
    /// </summary>
    public void RemoveRetainStationLastElecByID()
    {
        string id = Convert.ToString(Request.Form["id"]);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.VarChar);
        paras.Value = id;
        StringBuilder sql = new StringBuilder();
        sql.Append("delete from  EC_RetainStationLastElec  where id=@id;");
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    #endregion 保留基站上年电费
    #region 保留基站月度电费
    /// <summary>
    /// 设置保留基站月度电费查询条件
    /// </summary>
    /// <returns></returns>
    public string SetQueryConditionForRetainElec()
    {
        string queryStr = "";
        //设置查询条件
        List<string> list = new List<string>();
        //按所属县市
        if (!string.IsNullOrEmpty(Request.Form["cityname"]))
            list.Add(" cityname ='" + Request.Form["cityname"] + "'");
        //按缴费年月
        if (!string.IsNullOrEmpty(Request.Form["paymentyear"]))
            list.Add(" paymentyearmonth ='" + Request.Form["paymentyear"] + "'");
        //按局站编号
        if (!string.IsNullOrEmpty(Request.Form["stationid"]))
            list.Add(" stationid like'%" + Request.Form["stationid"] + "%'");
        //按基站名称
        if (!string.IsNullOrEmpty(Request.Form["stationname"]))
            list.Add(" stationname like'%" + Request.Form["stationname"] + "%'");
        //按用电类别
        if (!string.IsNullOrEmpty(Request.Form["electype"]))
            list.Add(" electype ='" + Request.Form["electype"] + "'");
        //按起止度校验
        if (!string.IsNullOrEmpty(Request.Form["degreescheck"]))
        {
            list.Add(" dbo.RetainDegreesCheck(id) ='" + Request.Form["degreescheck"] + "'");

        }
        //按用电量校验
        if (!string.IsNullOrEmpty(Request.Form["eleccheck"]))
        {
            if (Request.Form["eleccheck"] == "通过")
                list.Add(" (CASE EndDegrees  WHEN 0.00 THEN 0 ELSE ((EndDegrees-StartDegrees)* CASE rate WHEN '' THEN 1  ELSE rate END)-PowerUsage END >=-1.00 and CASE EndDegrees  WHEN 0.00 THEN 0 ELSE ((EndDegrees-StartDegrees)* CASE rate WHEN '' THEN 1  ELSE rate END)-PowerUsage END <=1.00)");
            else
                list.Add(" (CASE EndDegrees  WHEN 0.00 THEN 0 ELSE ((EndDegrees-StartDegrees)* CASE rate WHEN '' THEN 1  ELSE rate END)-PowerUsage END <-1.00 or CASE EndDegrees  WHEN 0.00 THEN 0 ELSE ((EndDegrees-StartDegrees)* CASE rate WHEN '' THEN 1  ELSE rate END)-PowerUsage END >1.00)");

        }
        //按金额校验
        if (!string.IsNullOrEmpty(Request.Form["amountcheck"]))
        {
            if (Request.Form["amountcheck"] == "通过")
                list.Add(" (CAST(((PowerUsage+loss)*ElecPrice-Amount) AS DECIMAL(18,2))>=-1.00  and CAST(((PowerUsage+loss)*ElecPrice-Amount) AS DECIMAL(18,2)) <=1.00)");
            else
                list.Add(" (CAST(((PowerUsage+loss)*ElecPrice-Amount) AS DECIMAL(18,2))<-1.00  or CAST(((PowerUsage+loss)*ElecPrice-Amount) AS DECIMAL(18,2)) >1.00)");

        }
        if (roleid == "20" || roleid == "21")
        {
            if (deptname == "网络维护中心")
                list.Add(" cityname='市区' ");
            else if (deptname == "林州市")
                list.Add(" cityname='林州' ");
            else
                list.Add(" cityname='" + deptname + "' ");
        }

        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 获取保留基站月度电费 数据page:1 rows:10 sort:id order:asc
    /// </summary>
    public void GetRetainStationElec()
    {
        int total = 0;
        string where = SetQueryConditionForRetainElec();
        string tableName = " EC_RetainStationElec ";
        string fieldStr = " CAST(((PowerUsage+loss)*ElecPrice-Amount) AS DECIMAL(18,2)) as amountcheck,*,CASE EndDegrees  WHEN 0.00 THEN 0 ELSE ((EndDegrees-StartDegrees)* CASE rate WHEN '' THEN 1  ELSE rate END)-PowerUsage END as eleccheck,dbo.RetainDegreesCheck(id) as degreescheck ";
        DataSet ds = SqlHelper.GetPagination(tableName, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    ///  EC_RetainStationElec
    /// </summary>
    public void GetRetainStationElecByID()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = id;
        string sql = "SELECT * FROM EC_RetainStationElec  where ID=@id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    /// <summary>
    /// 导入保留基站月度电费台账
    /// </summary>
    public void ImportRetainStationElec()
    {
        string reportPath = "";
        if (!string.IsNullOrEmpty(Request.Form["report"]))
            reportPath = Server.MapPath("~") + Request.Form["report"].ToString();
        if (ExcelHelper.CheckFileExists(reportPath) == -1)
        {
            Response.Write("{\"success\":false,\"msg\":\"上传文件不存在，请检查！\"}");
            return;
        }
        string sn = "保留基站月度电费台账";
        DataTable dt = new DataTable();
        if (ExcelHelper.CheckSheetContains(reportPath, sn) == -1)
        {
            Response.Write("{\"success\":false,\"msg\":\"单元表“" + sn + "”不存在，请检查文件！\"}");
            return;
        }
        else
        {
            dt = ExcelHelper.RenderDataTableFromExcel(reportPath, sn, 0, false, 2, 1);
        }
        if (dt.TableName == "Error")
        {
            Response.Write("{\"success\":false,\"msg\":\"" + dt.Rows[0][0].ToString() + ",请检查文件！\"}");
            return;
        }
        //定义sqlparameter 
        List<SqlParameter> _paras = new List<SqlParameter>();
        StringBuilder sql = new StringBuilder();
        double StartDegrees, EndDegrees, PowerUsage, ElecPrice, loss, Amount, ConvertMonth;
        //遍历数据
        if (dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                try
                {
                    _paras.Add(new SqlParameter("@stationname", String.IsNullOrEmpty(dr[0].ToString()) ? "" : dr[0].ToString()));
                    _paras.Add(new SqlParameter("@stationid", String.IsNullOrEmpty(dr[1].ToString()) ? "" : dr[1].ToString()));
                    _paras.Add(new SqlParameter("@sharedrelation", String.IsNullOrEmpty(dr[2].ToString()) ? "" : dr[2].ToString()));
                    _paras.Add(new SqlParameter("@stationtype", String.IsNullOrEmpty(dr[3].ToString()) ? "" : dr[3].ToString()));
                    _paras.Add(new SqlParameter("@cityname", String.IsNullOrEmpty(dr[4].ToString()) ? "" : dr[4].ToString()));
                    _paras.Add(new SqlParameter("@electype", String.IsNullOrEmpty(dr[5].ToString()) ? "" : dr[5].ToString()));
                    _paras.Add(new SqlParameter("@ammeterno", String.IsNullOrEmpty(dr[6].ToString()) ? "" : dr[6].ToString()));
                    _paras.Add(new SqlParameter("@paymentyearmonth", String.IsNullOrEmpty(dr[7].ToString()) ? "" : dr[7].ToString()));

                    double.TryParse(dr[8].ToString(), out StartDegrees);
                    _paras.Add(new SqlParameter("@StartDegrees", StartDegrees));
                    double.TryParse(dr[9].ToString(), out EndDegrees);
                    _paras.Add(new SqlParameter("@EndDegrees", EndDegrees));
                    _paras.Add(new SqlParameter("@rate", String.IsNullOrEmpty(dr[10].ToString()) ? "" : dr[10].ToString()));
                    double.TryParse(dr[11].ToString(), out loss);
                    _paras.Add(new SqlParameter("@loss", loss));
                    double.TryParse(dr[12].ToString(), out PowerUsage);
                    _paras.Add(new SqlParameter("@PowerUsage", PowerUsage));
                    double.TryParse(dr[13].ToString(), out ElecPrice);
                    _paras.Add(new SqlParameter("@ElecPrice", ElecPrice));
                    double.TryParse(dr[14].ToString(), out Amount);
                    _paras.Add(new SqlParameter("@Amount", Amount));
                    _paras.Add(new SqlParameter("@meterperiod", String.IsNullOrEmpty(dr[15].ToString()) ? "" : dr[15].ToString()));
                    double.TryParse(dr[16].ToString(), out ConvertMonth);
                    _paras.Add(new SqlParameter("@ConvertMonth", ConvertMonth));
                    _paras.Add(new SqlParameter("@memo", String.IsNullOrEmpty(dr[17].ToString()) ? "" : dr[17].ToString()));
                    sql.Append(" IF NOT EXISTS(SELECT * FROM EC_RetainStationElec WHERE StationID=@stationid and stationname=@stationname and PaymentYearMonth=@PaymentYearMonth) ");
                    sql.Append("INSERT INTO EC_RetainStationElec (stationname,stationid,SharedRelation,stationtype,cityname,ElecType,ammeterNo,PaymentYearMonth,StartDegrees,EndDegrees,rate,loss,PowerUsage,ElecPrice,Amount,meterperiod,ConvertMonth,memo)");
                    sql.Append(" VALUES (@stationname,@stationid,@sharedrelation,@stationtype,@cityname,@electype,@ammeterno,@paymentyearmonth,@startdegrees,@enddegrees,@rate,@loss,@powerusage,@elecprice,@amount,@meterperiod,@convertmonth,@memo) ");
                    sql.Append(" ELSE ");
                    sql.Append("Update EC_RetainStationElec  set  sharedrelation=@sharedrelation,stationtype=@stationtype,cityname=@cityname,electype=@electype,ammeterno=@ammeterno,paymentyearmonth=@paymentyearmonth,startdegrees=@startdegrees,enddegrees=@enddegrees,rate=@rate,loss=@loss,powerusage=@powerusage,elecprice=@elecprice,amount=@amount,meterperiod=@meterperiod,convertmonth=@convertmonth,memo=@memo");
                    sql.Append(" WHERE StationID=@stationid and stationname=@stationname and PaymentYearMonth=@PaymentYearMonth ");
                    SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), _paras.ToArray());
                }
                catch (Exception ex)
                {
                    Response.Write("{\"success\":false,\"msg\":\"执行出错，错误信息：" + ex.Message + ",请检查文件！\"}");
                    return;
                }
                finally
                {
                    sql.Length = 0;
                    _paras.Clear();
                }
            }
        }
        Response.Write("{\"success\":true,\"msg\":\"数据导入成功！\"}");
    }
    /// <summary>
    /// 导出保留基站月度电费台账
    /// </summary>
    public void ExportRetainStationElec()
    {
        string where = SetQueryConditionForRetainElec();
        if (where != "")
            where = " where " + where;
        StringBuilder sql = new StringBuilder();
        sql.Append("select ROW_NUMBER() OVER(ORDER BY paymentyearmonth asc) AS rowid,stationname,stationid,SharedRelation,stationtype,cityname,ElecType,ammeterNo,PaymentYearMonth,StartDegrees,EndDegrees,rate,loss,PowerUsage,ElecPrice,Amount,meterperiod,ConvertMonth,memo,dbo.RetainDegreesCheck(id) as degreescheck,CASE EndDegrees  WHEN 0.00 THEN 0 ELSE ((EndDegrees-StartDegrees)* CASE rate WHEN '' THEN 1  ELSE rate END)-PowerUsage END as eleccheck,CAST(((PowerUsage+loss)*ElecPrice-Amount) AS DECIMAL(18,2)) as amountcheck");
        sql.Append(" from EC_RetainStationElec ");
        sql.Append(where);
        sql.Append(" order by paymentyearmonth ");
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.TableName = "保留基站月度电费台账";
        ExcelHelper.ExportByWebForRetainStationElec(dt, "保留基站月度电费台账.xls");
    }
    /// <summary>
    /// 更新保留基站月度电费信息
    /// </summary>
    public void UpdateRetainStationElecInfo()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        string startdegrees = Convert.ToString(Request.Form["startdegrees"]);
        string enddegrees = Convert.ToString(Request.Form["enddegrees"]);
        string powerusage = Convert.ToString(Request.Form["powerusage"]);
        string rate = Convert.ToString(Request.Form["rate"]);
        string loss = Convert.ToString(Request.Form["loss"]);
        string elecprice = Convert.ToString(Request.Form["elecprice"]);
        string amount = Convert.ToString(Request.Form["amount"]);
        string meterperiod = Convert.ToString(Request.Form["meterperiod"]);
        string convertmonth = Convert.ToString(Request.Form["convertmonth"]);
        string memo = Convert.ToString(Request.Form["memo"]);

        List<SqlParameter> _paras = new List<SqlParameter>();
        _paras.Add(new SqlParameter("@id", id));
        _paras.Add(new SqlParameter("@startdegrees", startdegrees));
        _paras.Add(new SqlParameter("@enddegrees", enddegrees));
        _paras.Add(new SqlParameter("@powerusage", powerusage));
        _paras.Add(new SqlParameter("@rate", rate));
        _paras.Add(new SqlParameter("@loss", loss));
        _paras.Add(new SqlParameter("@elecprice", elecprice));
        _paras.Add(new SqlParameter("@amount", amount));
        _paras.Add(new SqlParameter("@meterperiod", meterperiod));
        _paras.Add(new SqlParameter("@convertmonth", convertmonth));
        _paras.Add(new SqlParameter("@memo", memo));

        StringBuilder sql = new StringBuilder();
        sql.Append("Update EC_RetainStationElec  set  startdegrees=@startdegrees,enddegrees=@enddegrees,powerusage=@powerusage,rate=@rate,loss=@loss,elecprice=@elecprice,amount=@amount,meterperiod=@meterperiod,convertmonth=@convertmonth,memo=@memo");
        sql.Append(" where id=@id");
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), _paras.ToArray());
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"更新成功！\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"该局站编码已存在，请检查输入!\"}");
    }
    /// <summary>
    /// 删除保留站月度电费信息
    /// </summary>
    public void RemoveRetainStationElecByID()
    {
        string id = Convert.ToString(Request.Form["id"]);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.VarChar);
        paras.Value = id;
        StringBuilder sql = new StringBuilder();
        sql.Append("delete from  EC_RetainStationElec  where id=@id;");
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    #endregion 保留基站月度电费
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}