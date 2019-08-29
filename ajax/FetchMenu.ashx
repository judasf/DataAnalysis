<%@ WebHandler Language="C#" Class="FetchMenu" %>

using System;
using System.Web;
using System.Web.SessionState;
using System.Reflection;
using System.Text;
using System.Collections;
using System.Collections.Generic;

public class FetchMenu : IHttpHandler, IRequiresSessionState
{
    HttpRequest Request;
    HttpResponse Response;
    HttpSessionState Session;
    HttpServerUtility Server;
    HttpCookie Cookie;
    /// <summary>
    /// 是否财务部：查看电费
    /// </summary>
    bool isCW = false;
    /// <summary>
    /// 用户角色
    /// </summary>
    int roleid = 0;
    /// <summary>
    /// 是否市县用户，派单员
    /// </summary>
    bool isSX = false;
    /// <summary>
    /// 判断是否超管
    /// </summary>
    bool isAdmin = false;
    /// <summary>
    /// 判断是否外包单位
    /// </summary>
    bool isWB = false;
    /// <summary>
    /// 是否库管
    /// </summary>
    bool isKG = false;
    /// <summary>
    /// 4是否运维部
    /// </summary>
    bool isYW = false;
    /// <summary>
    /// 5：光缆线路查询
    /// </summary>
    bool isXLCX = false;
    /// <summary>
    /// 6：公众报账员(迁改时审计报账录入)	
    /// </summary>
    bool isGZBZ = false;
    /// <summary>
    /// 7：区域维护（工程局和北京合力施工队）	
    /// </summary>
    bool isQYWH = false;
    /// <summary>
    /// 8：线路主管 （整改时确认料单和措施）	
    /// </summary>
    bool isXLZG = false;
    /// <summary>
    /// 9:基站考核人员（网络优化中心和各县）
    /// </summary>
    bool isJZKH = false;
    /// <summary>
    /// 9:各县基站考核人员
    /// </summary>
    bool isGXJZKH = false;
    /// <summary>
    /// 9:基站考核，网优考核人
    /// </summary>
    bool isWY = false;
    /// <summary>
    /// 9:基站考核，网络维护中心考核人:
    /// </summary>
    bool isWW = false;
    /// <summary>
    /// 9:基站考核，运维部考核人:zhaoziqiang
    /// </summary>
    bool isYWJZ = false;
    /// <summary>
    /// 10:线路考核人员（公众响应中心和各县）
    /// </summary>
    bool isXLKH = false;
    //11：南水北调库管
    bool isNSBD = false;
    /// <summary>
    ///12：装维单元负责人
    /// </summary>
    bool isUnitMana = false;
    /// <summary>
    /// 13:装维单元库管
    /// </summary>
    bool isUnitKG = false;
    /// <summary>
    /// 14：装维片区工号
    /// </summary>
    bool isUnitPQ = false;
    /// <summary>
    /// 17：装维片区领料工号
    /// </summary>
    bool isUnitPQLL = false;
    /// <summary>
    /// 15:接入网资源管理
    /// </summary>
    bool isAN = false;
    /// <summary>
    /// 16：无线上网卡管理
    /// </summary>
    bool isNetCard = false;
    /// <summary>
    /// 是否各县用户
    /// </summary>
    bool isTOWN = false;
    /// <summary>
    /// 20：能耗管理员
    /// </summary>
    bool isEC = false;
    /// <summary>
    /// 21：能耗部门主管
    /// </summary>
    bool isECMana = false;
    /// <summary>
    /// 30：客户接入库管
    /// </summary>
    bool isCAKG = false;
    /// <summary>
    /// 31：客户接入领料
    /// </summary>
    bool isCALL = false;
    /// <summary>
    /// 32：客户接入网格
    /// </summary>
    bool isCAWG = false;
    /// <summary>
    /// 18：故障维修工单
    /// </summary>
    bool isFaultReapir = false;
    /// <summary>
    /// 19:专线客户光缆管理
    /// </summary>
    bool isZXGL = false;
    /// <summary>
    /// 40:资源盘活管理
    /// </summary>
    bool isZYPH = false;
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
        if (Session["uname"] == null || string.IsNullOrEmpty(Session["uname"].ToString()))
        {
            Response.Write("{\"flag\":\"0\",\"msg\":\"登陆超时，请重新登陆后再进行操作！\"}");
            return;
        }
        else
        {
            isAdmin = Session["roleid"].ToString() == "0" ? true : false;
            isSX = Session["roleid"].ToString() == "1" ? true : false;
            isKG = Session["roleid"].ToString() == "2" ? true : false;
            isWB = Session["roleid"].ToString() == "3" ? true : false;
            isYW = Session["roleid"].ToString() == "4" ? true : false;
            isXLCX = Session["roleid"].ToString() == "5" ? true : false;
            isGZBZ = Session["roleid"].ToString() == "6" ? true : false;
            isQYWH = Session["roleid"].ToString() == "7" ? true : false;
            isXLZG = Session["roleid"].ToString() == "8" ? true : false;
            isJZKH = Session["roleid"].ToString() == "9" ? true : false;
            isGXJZKH = Session["roleid"].ToString() == "9" && Session["pre"].ToString() != "" ? true : false;
            isWY = Session["roleid"].ToString() == "9" && Session["deptname"].ToString() == "网络优化中心" ? true : false;
            isWW = Session["roleid"].ToString() == "9" && Session["deptname"].ToString() == "网络维护中心" ? true : false;
            isYWJZ = Session["roleid"].ToString() == "9" && Session["deptname"].ToString() == "运行维护部" ? true : false;
            isXLKH = Session["roleid"].ToString() == "10" ? true : false;
            isNSBD = Session["roleid"].ToString() == "11" ? true : false;
            isUnitMana = Session["roleid"].ToString() == "12" ? true : false;
            isUnitKG = Session["roleid"].ToString() == "13" ? true : false;
            isUnitPQ = Session["roleid"].ToString() == "14" ? true : false;
            isAN = Session["roleid"].ToString() == "15" ? true : false;
            isNetCard = Session["roleid"].ToString() == "16" ? true : false;
            isUnitPQLL = Session["roleid"].ToString() == "17" ? true : false;
            isEC = Session["roleid"].ToString() == "20" ? true : false;
            isECMana = Session["roleid"].ToString() == "21" ? true : false;
            isCAKG = Session["roleid"].ToString() == "30" ? true : false;
            isCALL = Session["roleid"].ToString() == "31" ? true : false;
            isCAWG = Session["roleid"].ToString() == "32" ? true : false;
            isTOWN = Session["pre"].ToString().Trim() != "" ? true : false;
            //管理员roleid=0,和运维部roleid=4,可跟踪市公司和县公司的整改和电缆延伸情况
            isFaultReapir = Session["roleid"].ToString() == "18" ? true : false;
            //专线客户光缆管理
            isZXGL = Session["roleid"].ToString() == "19" ? true : false;
            //资源盘活
            isZYPH = Session["roleid"].ToString() == "40" ? true : false;

            isCW = Session["deptname"].ToString() == "财务部" ? true : false;
        }
        if (!string.IsNullOrEmpty(Request.Form["method"]))
        {
            MethodInfo methodInfo = this.GetType().GetMethod(Request.Form["method"]);
            if (methodInfo != null)
            {
                methodInfo.Invoke(this, null);
            }
            else
                Response.Write("{\"flag\":\"0\",\"msg\":\"method not match!\"}");
        }
        else
        {
            Response.Write("{\"flag\":\"0\",\"msg\":\"method not found!\"}");
        }
    }

    public void CreatMenu()
    {
        string uname = Session["uname"] == null ? "" : Session["uname"].ToString();
        if (uname != "")
        {
            List<string> menuArr = new List<string>();
            StringBuilder menuList = new StringBuilder();
            StringBuilder subMenu = new StringBuilder();
            menuList.Append("{\"flag\":\"1\",\"msg\":\"succ\",\"menus\":");
            menuList.Append("[");
            //线路资源管理 begin
            if (isAdmin || isSX || isXLZG || isWB || isZXGL || isXLCX)
            {
                //accordion 头
                subMenu.Append("{\"menuid\": \"3\",\"menuname\": \"线路资源管理\",\"icon\": \"icon-server\",\"menus\": [");

                if (!isZXGL)
                {
                    subMenu.Append("{\"menuid\": \"11\",\"menuname\": \"光缆延伸管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"LineResourceManager/LineExtension.aspx\",\"iframename\": \"xlysgl\"}");
                }
                if (!isSX && !isXLZG)
                {
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"专线客户光缆\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"LineResourceManager/SpecialLine.aspx\",\"iframename\": \"zxkhgl\"}");
                }
                //accordion 尾
                subMenu.Append("]}");


            }
            menuArr.Add(subMenu.ToString());
            subMenu.Length = 0;
            //线路资源管理 end
            //能耗台账管理 begin
            if (isAdmin || isEC || isECMana || isYW || isCW)
            {
                //accordion 头
                subMenu.Append("{\"menuid\": \"3\",\"menuname\": \"能耗台账管理\",\"icon\": \"icon-server\",\"menus\": [");
                subMenu.Append("{\"menuid\": \"11\",\"menuname\": \"接入网机房月度电费\",\"icon\": \"ext-icon-table\",");
                subMenu.Append("\"url\": \"EnergyConsumption/AccessStationElec.aspx\",\"iframename\": \"jfzygl\"}");
                subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"接入网机房上年电费\",\"icon\": \"ext-icon-table\",");
                subMenu.Append("\"url\": \"EnergyConsumption/AccessStationLastElec.aspx\",\"iframename\": \"sbxxgl\"}");
                subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"接入网机房动力信息\",\"icon\": \"ext-icon-table\",");
                subMenu.Append("\"url\": \"EnergyConsumption/AccessStationInfo.aspx\",\"iframename\": \"jrwjzxx\"}");
                //accordion 尾
                subMenu.Append("]}");

                menuArr.Add(subMenu.ToString());
                subMenu.Length = 0;
                //accordion 头
                subMenu.Append("{\"menuid\": \"3\",\"menuname\": \"保留基站能耗管理\",\"icon\": \"icon-server\",\"menus\": [");
                subMenu.Append("{\"menuid\": \"11\",\"menuname\": \"保留基站月度电费\",\"icon\": \"ext-icon-table\",");
                subMenu.Append("\"url\": \"EnergyConsumption/RetainStationElec.aspx\",\"iframename\": \"jfzygl\"}");
                subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"保留基站上年电费\",\"icon\": \"ext-icon-table\",");
                subMenu.Append("\"url\": \"EnergyConsumption/RetainStationLastElec.aspx\",\"iframename\": \"sbxxgl\"}");
                subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"保留基站基础信息\",\"icon\": \"ext-icon-table\",");
                subMenu.Append("\"url\": \"EnergyConsumption/RetainStationInfo.aspx\",\"iframename\": \"jrwjzxx\"}");
                //accordion 尾
                subMenu.Append("]}");

            }
            menuArr.Add(subMenu.ToString());
            subMenu.Length = 0;
            //能耗台账管理 end
            //客户接入物料管理 begin
            if (isAdmin || isCAKG || isCALL || isCAWG || isYW)
            {

                //accordion 头
                subMenu.Append("{\"menuid\": \"3\",\"menuname\": \"客户接入物料管理\",\"icon\": \"icon-book\",\"menus\": [");
                if (isAdmin || isYW || isCAKG || isCALL || isCAWG)
                {
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"物料库存管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"CustomAccess/UnitStockMana.aspx\",\"iframename\": \"jcdykcgl\"}");

                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"物料入库明细\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"CustomAccess/UnitInStockDetail.aspx\",\"iframename\": \"jcdyrkmx\"}");
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"物料调拨明细\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"CustomAccess/UnitAllotStockDetail.aspx\",\"iframename\": \"jscdyrkmx\"}");
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"营业部领料明细\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"CustomAccess/UnitOutStockDetail.aspx\",\"iframename\": \"zwpqllmx\"}");
                    //subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"用料明细\",\"icon\": \"ext-icon-table\",");
                    //subMenu.Append("\"url\": \"CustomAccess/AreaMaterialDetail.aspx\",\"iframename\": \"zwpqylmx\"}");
                }
                if (isAdmin || isCAKG)
                {
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"物料型号管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"CustomAccess/wlxh.aspx\",\"iframename\": \"wlxhgl\"}");
                }
                if (isAdmin || isCAKG)
                {
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"营业部/支局管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"CustomAccess/UnitArea.aspx\",\"iframename\": \"zwpqgl\"}");
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"用户管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"CustomAccess/UnitUserInfo.aspx\",\"iframename\": \"yybyhgl\"}");
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"领料人管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"CustomAccess/UnitPickerInfo.aspx\",\"iframename\": \"llrgl\"}");
                }
                //accordion 尾
                subMenu.Append("]}");
            }
            menuArr.Add(subMenu.ToString());
            subMenu.Length = 0;

            //接入网资源管理 begin
            if (isAdmin || isEC || isECMana || isYW || isCW)
            {
                //accordion 头
                subMenu.Append("{\"menuid\": \"3\",\"menuname\": \"接入网资源管理\",\"icon\": \"icon-server\",\"menus\": [");
                subMenu.Append("{\"menuid\": \"11\",\"menuname\": \"机房资源管理\",\"icon\": \"ext-icon-table\",");
                subMenu.Append("\"url\": \"AccessNetwork/RoomResources.aspx\",\"iframename\": \"jfzygl\"}");
                subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"设备信息管理\",\"icon\": \"ext-icon-table\",");
                subMenu.Append("\"url\": \"AccessNetwork/EquipmentInfo.aspx\",\"iframename\": \"sbxxgl\"}");
                subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"租赁合同台账\",\"icon\": \"ext-icon-table\",");
                subMenu.Append("\"url\": \"AccessNetwork/LeaseContract.aspx\",\"iframename\": \"wdwxtz\"}");
                //accordion 尾
                subMenu.Append("]}");
            }
            menuArr.Add(subMenu.ToString());
            subMenu.Length = 0;
            //接入网资源管理 end
            //故障维修台账 begin
            if (isAdmin || isFaultReapir || isEC || isECMana || isYW || isCW || isKG)
            {
                //accordion 头
                subMenu.Append("{\"menuid\": \"3\",\"menuname\": \"故障维修台账管理\",\"icon\": \"icon-server\",\"menus\": [");
                subMenu.Append("{\"menuid\": \"11\",\"menuname\": \"故障工单管理\",\"icon\": \"ext-icon-table\",");
                subMenu.Append("\"url\": \"StandingBook/FaultOrder.aspx\",\"iframename\": \"gzgdgl\"}");
                subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"日常维修台账\",\"icon\": \"ext-icon-table\",");
                subMenu.Append("\"url\": \"StandingBook/DailyRepairInfo.aspx\",\"iframename\": \"rcwxtz\"}");
                //accordion 尾
                subMenu.Append("]}");
            }
            menuArr.Add(subMenu.ToString());
            subMenu.Length = 0;
            //故障维修台账 end
            //运维物料管理 begin
            if (isAdmin || isKG || isYW || isFaultReapir || isEC || isECMana)
            {

                //accordion 头
                subMenu.Append("{\"menuid\": \"3\",\"menuname\": \"运维物料管理\",\"icon\": \"icon-database\",\"menus\": [");
                if (isAdmin || isKG || isYW)
                {
                    subMenu.Append("{\"menuid\": \"11\",\"menuname\": \"库存管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"MaintainMaterial/UnitStockMana.aspx\",\"iframename\": \"spframe\"}");

                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"物料领用管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"MaintainMaterial/UnitDrawStockDetail.aspx\",\"iframename\": \"spframe\"}");

                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"领料明细（旧）\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"MaintainMaterial/UnitOutStockDetail.aspx\",\"iframename\": \"spframe\"}");
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"物料入库明细\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"MaintainMaterial/UnitInStockDetail.aspx\",\"iframename\": \"spframe\"}");
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"物料调拨明细\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"MaintainMaterial/UnitAllotStockDetail.aspx\",\"iframename\": \"spframe\"}");
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"物料型号管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"MaintainMaterial/TypeInfo.aspx\",\"iframename\": \"spframe\"}");
                }
                if (isEC || isECMana)
                {
                    subMenu.Append("{\"menuid\": \"11\",\"menuname\": \"物料领用管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"MaintainMaterial/UnitDrawStockDetail.aspx\",\"iframename\": \"spframe\"}");
                }
                if (isFaultReapir)
                {
                    subMenu.Append("{\"menuid\": \"11\",\"menuname\": \"库存管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"MaintainMaterial/UnitStockMana.aspx\",\"iframename\": \"spframe\"},");
                    subMenu.Append("{\"menuid\": \"11\",\"menuname\": \"物料领用管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"MaintainMaterial/UnitDrawStockDetail.aspx\",\"iframename\": \"spframe\"}");
                }
                subMenu.Append("]}");
            }
            menuArr.Add(subMenu.ToString());
            subMenu.Length = 0;
            //运维物料管理 end
            //利旧物料管理 begin
            if (isAdmin || isKG || isYW || isFaultReapir || isEC || isECMana)
            {

                //accordion 头
                subMenu.Append("{\"menuid\": \"3\",\"menuname\": \"利旧物料管理\",\"icon\": \"icon-database_refresh\",\"menus\": [");
                if (isAdmin || isKG || isYW)
                {
                    subMenu.Append("{\"menuid\": \"11\",\"menuname\": \"利旧库存管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"ReuseMaintainMaterial/ReuseStockMana.aspx\",\"iframename\": \"spframe\"}");

                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"利旧物料领用管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"ReuseMaintainMaterial/ReuseDrawStockDetail.aspx\",\"iframename\": \"spframe\"}");

                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"利旧物料入库明细\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"ReuseMaintainMaterial/ReuseInStockDetail.aspx\",\"iframename\": \"spframe\"}");
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"利旧物料调拨明细\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"ReuseMaintainMaterial/ReuseAllotStockDetail.aspx\",\"iframename\": \"spframe\"}");
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"利旧物料型号管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"ReuseMaintainMaterial/ReuseTypeInfo.aspx\",\"iframename\": \"spframe\"}");
                }
                if (isEC || isECMana)
                {
                    subMenu.Append("{\"menuid\": \"11\",\"menuname\": \"利旧物料领用管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"ReuseMaintainMaterial/ReuseDrawStockDetail.aspx\",\"iframename\": \"spframe\"}");
                }
                if (isFaultReapir)
                {
                    subMenu.Append("{\"menuid\": \"11\",\"menuname\": \"利旧库存管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"ReuseMaintainMaterial/ReuseStockMana.aspx\",\"iframename\": \"spframe\"},");
                    subMenu.Append("{\"menuid\": \"11\",\"menuname\": \"利旧物料领用管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"ReuseMaintainMaterial/ReuseDrawStockDetail.aspx\",\"iframename\": \"spframe\"}");
                }
                subMenu.Append("]}");
            }
            menuArr.Add(subMenu.ToString());
            subMenu.Length = 0;
            //利旧物料管理 end
            // 专项整治事项管理 begin
            if (isAdmin || isKG || isYW || isFaultReapir || isEC || isECMana)
            {

                //accordion 头
                subMenu.Append("{\"menuid\": \"3\",\"menuname\": \"专项整治事项管理\",\"icon\": \"icon-plugin\",\"menus\": [");
                if (isAdmin || isKG || isYW)
                {
                    subMenu.Append("{\"menuid\": \"11\",\"menuname\": \"故障工单管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"NetWorkSpecialProject/FaultOrder.aspx\",\"iframename\": \"gzgdgl\"}");
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"维修台账管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"NetWorkSpecialProject/DailyRepairInfo.aspx\",\"iframename\": \"rcwxtz\"}");
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"物料库存管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"NetWorkSpecialProject/UnitStockMana.aspx\",\"iframename\": \"spframe\"}");
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"物料领用管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"NetWorkSpecialProject/UnitDrawStockDetail.aspx\",\"iframename\": \"spframe\"}");

                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"物料入库明细\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"NetWorkSpecialProject/UnitInStockDetail.aspx\",\"iframename\": \"spframe\"}");
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"物料调拨明细\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"NetWorkSpecialProject/UnitAllotStockDetail.aspx\",\"iframename\": \"spframe\"}");
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"物料型号管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"NetWorkSpecialProject/TypeInfo.aspx\",\"iframename\": \"spframe\"}");
                }
                if (isFaultReapir || isEC || isECMana)
                {
                    subMenu.Append("{\"menuid\": \"11\",\"menuname\": \"故障工单管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"NetWorkSpecialProject/FaultOrder.aspx\",\"iframename\": \"gzgdgl\"}");
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"维修台账管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"NetWorkSpecialProject/DailyRepairInfo.aspx\",\"iframename\": \"rcwxtz\"}");
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"物料领用管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"NetWorkSpecialProject/UnitDrawStockDetail.aspx\",\"iframename\": \"spframe\"}");
                }

                //accordion 尾
                subMenu.Append("]}");
            }
            menuArr.Add(subMenu.ToString());
            subMenu.Length = 0;
            //专项整治事项管理 end
            //资源盘活事项 begin
            if (isAdmin || isZYPH)
            {

                //accordion 头
                subMenu.Append("{\"menuid\": \"3\",\"menuname\": \"资源盘活事项\",\"icon\": \"icon-database_refresh\",\"menus\": [");
                subMenu.Append("{\"menuid\": \"11\",\"menuname\": \"资源入库管理\",\"icon\": \"ext-icon-table\",");
                subMenu.Append("\"url\": \"ResourceReuse/RRStockMana.aspx\",\"iframename\": \"spframe\"}");
                subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"资源领用明细\",\"icon\": \"ext-icon-table\",");
                subMenu.Append("\"url\": \"ResourceReuse/RRStockDraw.aspx\",\"iframename\": \"spframe\"}");
                subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"资源类别管理\",\"icon\": \"ext-icon-table\",");
                subMenu.Append("\"url\": \"ResourceReuse/RRTypeInfo.aspx\",\"iframename\": \"spframe\"}");
                subMenu.Append("]}");
            }
            menuArr.Add(subMenu.ToString());
            subMenu.Length = 0;
            //资源盘活事项 end
            //系统设置 begin

            if (isAdmin)
            {

                //accordion 头
                subMenu.Append("{\"menuid\": \"3\",\"menuname\": \"系统设置\",\"icon\": \"icon-cog\",\"menus\": [");
                if (isAdmin)
                {
                    subMenu.Append("{\"menuid\": \"11\",\"menuname\": \"部门设置\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"system1/bmsz.aspx\",\"iframename\": \"pbframe\"},");

                    subMenu.Append("{\"menuid\": \"11\",\"menuname\": \"岗位设置\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"system1/gwsz.aspx\",\"iframename\": \"spframe\"}");
                }
                subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"用户管理\",\"icon\": \"ext-icon-table\",");
                subMenu.Append("\"url\": \"system1/userinfo.aspx\",\"iframename\": \"spframe\"}");
                //accordion 尾
                subMenu.Append("]}");
            }
            menuArr.Add(subMenu.ToString());
            subMenu.Length = 0;

            //系统设置 end
            menuArr.Remove("");
            menuArr.RemoveAll(RemoveBlank);
            menuList.Append(string.Join(",", menuArr.ToArray()));
            menuList.Append("]}");
            Response.Write(menuList.ToString().Replace(",]", "]").Replace(",,", ",").Replace("[,", "["));
        }
        else
            Response.Write("{\"flag\":\"0\",\"msg\":\"argument not match!\"}");


    }
    private bool RemoveBlank(string s)
    {
        if (s.Length == 0)
            return true;
        else
            return false;
    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}