﻿<%@ WebHandler Language="C#" Class="FetchMenu" %>

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
    /// 5：公众领导(迁改时验收工作,市区线路考核)	
    /// </summary>
    bool isGZLD = false;
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
    /// 20：能耗管理
    /// </summary>
    bool isEC = false;
    /// <summary>
    /// 21：能耗管理
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
            isGZLD = Session["roleid"].ToString() == "5" ? true : false;
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
            //客户接入物料管理 end
            //市区迁改 begin
            //if (!isWB && !isQYWH && !isUnitKG && !isUnitPQ && !isUnitPQLL && !isAN && !isNetCard)
            //{

            //    //accordion 头
            //    subMenu.Append("{\"menuid\": \"3\",\"menuname\": \"迁改事项管理\",\"icon\": \"icon-plugin\",\"menus\": [");
            //    if (!isTOWN)
            //    {
            //        subMenu.Append("{\"menuid\": \"11\",\"menuname\": \"市区迁改信息管理\",\"icon\": \"ext-icon-table\",");
            //        subMenu.Append("\"url\": \"xlqggd/xlqgxxgl.aspx\",\"iframename\": \"pbframe\"},");
            //    }
            //    if (isTOWN || isAdmin || isYW)
            //    {
            //        subMenu.Append("{\"menuid\": \"11\",\"menuname\": \"县公司迁改管理\",\"icon\": \"ext-icon-table\",");
            //        subMenu.Append("\"url\": \"xlqggd/xlqgxxgl_town.aspx\",\"iframename\": \"spframe\"}");
            //    }
            //    if (isSX)
            //    {
            //        subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"迁改信息录入\",\"icon\": \"ext-icon-table\",");
            //        subMenu.Append("\"url\": \"xlqggd/xlqgxxlr.aspx\",\"iframename\": \"spframe\"}");
            //    }
            //    //accordion 尾
            //    subMenu.Append("]}");
            //}
            //menuArr.Add(subMenu.ToString());
            //subMenu.Length = 0;
            //市区迁改 end
            /**
            //南水北调 begin
            if (isAdmin || isYW || isNSBD)
            {

                //accordion 头
                subMenu.Append("{\"menuid\": \"3\",\"menuname\": \"南水北调事项管理\",\"icon\": \"icon-plugin\",\"menus\": [");
                subMenu.Append("{\"menuid\": \"11\",\"menuname\": \"南水北调信息管理\",\"icon\": \"ext-icon-table\",");
                subMenu.Append("\"url\": \"nsbdgd/nsbdxxgl.aspx\",\"iframename\": \"pbframe\"}");
                if (isYW)
                {
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"南水北调信息录入\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"nsbdgd/nsbdxxlr.aspx\",\"iframename\": \"spframe\"}");
                }
                subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"南水北调领料信息\",\"icon\": \"ext-icon-table\",");
                subMenu.Append("\"url\": \"nsbdgd/nsbdxxllgl.aspx\",\"iframename\": \"spframe\"}");
                //accordion 尾
                subMenu.Append("]}");
            }
            menuArr.Add(subMenu.ToString());
            subMenu.Length = 0;
            //南水北调 end
            **/
            //被盗事项 begin
            //if (!isGZBZ && !isUnitKG && !isUnitPQ && !isUnitPQLL && !isAN && !isNetCard)
            //{

            //    //accordion 头
            //    subMenu.Append("{\"menuid\": \"3\",\"menuname\": \"被盗事项管理\",\"icon\": \"icon-plugin\",\"menus\": [");
            //    subMenu.Append("{\"menuid\": \"11\",\"menuname\": \"被盗信息统计\",\"icon\": \"ext-icon-table\",");
            //    subMenu.Append("\"url\": \"xlbdgd/xlbdxxtj.aspx\",\"iframename\": \"pbframe\"}");
            //    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"被盗信息管理\",\"icon\": \"ext-icon-table\",");
            //    subMenu.Append("\"url\": \"xlbdgd/xlbdxxgl.aspx\",\"iframename\": \"spframe\"}");
            //    if (isSX)
            //    {
            //        subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"被盗信息录入\",\"icon\": \"ext-icon-table\",");
            //        subMenu.Append("\"url\": \"xlbdgd/xlbdxxlr.aspx\",\"iframename\": \"spframe\"}");
            //    }
            //    if (isKG || isWB || isAdmin || isYW)
            //    {
            //        subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"被盗领料信息管理\",\"icon\": \"ext-icon-table\",");
            //        subMenu.Append("\"url\": \"xlbdgd/xlbdxxllgl.aspx\",\"iframename\": \"spframe\"}");
            //    }
            //    //accordion 尾
            //    subMenu.Append("]}");
            //}
            //menuArr.Add(subMenu.ToString());
            //subMenu.Length = 0;
            //被盗事项 end
            //整改事项 begin
            /*
            if (!isGZBZ && !isUnitKG && !isUnitPQ && !isUnitPQLL && !isAN && !isNetCard&& !isEC&& !isCAKG&& !isCALL&& !isCAWG)
            {

                //accordion 头
                subMenu.Append("{\"menuid\": \"3\",\"menuname\": \"整改事项管理\",\"icon\": \"icon-plugin\",\"menus\": [");
                subMenu.Append("{\"menuid\": \"11\",\"menuname\": \"整改信息统计\",\"icon\": \"ext-icon-table\",");
                subMenu.Append("\"url\": \"xlzggd/xlzgxxtj.aspx\",\"iframename\": \"pbframe\"}");
                if (!isTOWN || isAdmin || isYW)
                {
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"市公司整改信息\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"xlzggd/xlzgxxgl.aspx\",\"iframename\": \"spframe\"}");
                }
                if (isTOWN || isAdmin || isYW)
                {
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"县公司整改信息\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"xlzggd/xlzgxxgl_town.aspx\",\"iframename\": \"spframe\"}");
                }
                if (isSX && !isTOWN)
                {
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"整改信息录入\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"xlzggd/xlzgxxlr.aspx\",\"iframename\": \"spframe\"}");
                }
                if (isSX && isTOWN)
                {
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"整改信息录入\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"xlzggd/xlzgxxlr_town.aspx\",\"iframename\": \"spframe\"}");
                }
                if (isKG || isWB || isAdmin || isYW || isSX)
                {
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"整改领料信息管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"xlzggd/xlzgxxllgl.aspx\",\"iframename\": \"spframe\"}");
                }
                //accordion 尾
                subMenu.Append("]}");
            }
            menuArr.Add(subMenu.ToString());
            subMenu.Length = 0;
                */
            //整改事项 end
            //电缆延伸 begin
            //if (!isGZBZ && !isUnitKG && !isUnitPQ && !isUnitPQLL && !isAN && !isNetCard)
            //{

            //    //accordion 头
            //    subMenu.Append("{\"menuid\": \"3\",\"menuname\": \"电缆延伸事项管理\",\"icon\": \"icon-plugin\",\"menus\": [");
            //    subMenu.Append("{\"menuid\": \"11\",\"menuname\": \"电缆延伸信息统计\",\"icon\": \"ext-icon-table\",");
            //    subMenu.Append("\"url\": \"dlysgd/xlzgxxtj.aspx\",\"iframename\": \"pbframe\"}");
            //    if (!isTOWN || isAdmin || isYW)
            //    {
            //        subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"市公司电缆延伸\",\"icon\": \"ext-icon-table\",");
            //        subMenu.Append("\"url\": \"dlysgd/xlzgxxgl.aspx\",\"iframename\": \"spframe\"}");
            //    }
            //    if (isTOWN || isAdmin || isYW)
            //    {
            //        subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"县公司电缆延伸\",\"icon\": \"ext-icon-table\",");
            //        subMenu.Append("\"url\": \"dlysgd/xlzgxxgl_town.aspx\",\"iframename\": \"spframe\"}");
            //    }
            //    if (isSX && !isTOWN)
            //    {
            //        subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"电缆延伸信息录入\",\"icon\": \"ext-icon-table\",");
            //        subMenu.Append("\"url\": \"dlysgd/xlzgxxlr.aspx\",\"iframename\": \"spframe\"}");
            //    }
            //    if (isSX && isTOWN)
            //    {
            //        subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"电缆延伸信息录入\",\"icon\": \"ext-icon-table\",");
            //        subMenu.Append("\"url\": \"dlysgd/xlzgxxlr_town.aspx\",\"iframename\": \"spframe\"}");
            //    }
            //    if (isKG || isWB || isAdmin || isYW || isSX)
            //    {
            //        subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"电缆延伸领料管理\",\"icon\": \"ext-icon-table\",");
            //        subMenu.Append("\"url\": \"dlysgd/xlzgxxllgl.aspx\",\"iframename\": \"spframe\"}");
            //    }
            //    //accordion 尾
            //    subMenu.Append("]}");
            //}
            //menuArr.Add(subMenu.ToString());
            //subMenu.Length = 0;
            //电缆延伸 end
            //日常维护 begin
            /*
            if (isAdmin || isSX || isYW || isKG || isGZLD)
            {

                //accordion 头
                subMenu.Append("{\"menuid\": \"3\",\"menuname\": \"日常维护事项管理\",\"icon\": \"icon-book\",\"menus\": [");
                subMenu.Append("{\"menuid\": \"11\",\"menuname\": \"日常维护领料明细\",\"icon\": \"ext-icon-table\",");
                subMenu.Append("\"url\": \"rcwhllxx/yjylkctzgl.aspx\",\"iframename\": \"pbframe\"}");
                if (isKG)
                {
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"日常维护领料录入\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"rcwhllxx/yjylkctzlr.aspx\",\"iframename\": \"spframe\"}");
                }
                //accordion 尾
                subMenu.Append("]}");
            }
            menuArr.Add(subMenu.ToString());
            subMenu.Length = 0;
                */
            //日常维护 end
            //客户接入 begin
            /*
            if (isAdmin || isSX || isYW || isKG || isGZLD || isUnitMana || isUnitKG || isUnitPQ || isUnitPQLL)
            {

                //accordion 头
                subMenu.Append("{\"menuid\": \"3\",\"menuname\": \"客户接入事项管理\",\"icon\": \"icon-book\",\"menus\": [");
                if (isAdmin || isSX || isYW || isKG || isGZLD)
                {
                    subMenu.Append("{\"menuid\": \"11\",\"menuname\": \"客户接入领料明细\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"khjrllxx/yjylkctzgl.aspx\",\"iframename\": \"pbframe\"}");
                }
                if (isKG)
                {
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"客户接入领料录入\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"khjrllxx/yjylkctzlr.aspx\",\"iframename\": \"spframe\"}");
                }
                if (isAdmin || isYW || isGZLD || isUnitMana || isUnitKG || isUnitPQ || isUnitPQLL || (isKG && !isTOWN))
                {

                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"基层单元库存管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"BaseUnit/UnitStockMana.aspx\",\"iframename\": \"jcdykcgl\"}");
                    if (!isUnitPQ)
                    {
                        subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"基层单元入库明细\",\"icon\": \"ext-icon-table\",");
                        subMenu.Append("\"url\": \"BaseUnit/UnitInStockDetail.aspx\",\"iframename\": \"jcdyrkmx\"}");
                    }
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"装维片区领料明细\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"BaseUnit/UnitOutStockDetail.aspx\",\"iframename\": \"zwpqllmx\"}");
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"装维片区用料明细\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"BaseUnit/AreaMaterialDetail.aspx\",\"iframename\": \"zwpqylmx\"}");
                }
                if (isAdmin)
                {
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"物料型号管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"BaseUnit/wlxh.aspx\",\"iframename\": \"wlxhgl\"}");
                }
                if (isUnitMana)
                {
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"装维片区管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"BaseUnit/UnitArea.aspx\",\"iframename\": \"zwpqgl\"}");
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"基层单元用户管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"BaseUnit/UnitUserInfo.aspx\",\"iframename\": \"jcdyyhgl\"}");
                }
                //accordion 尾
                subMenu.Append("]}");
            }
            menuArr.Add(subMenu.ToString());
            subMenu.Length = 0;
            */
            //客户接入 end
            //上网卡管理 begin
            /*
            if (isGZLD || isUnitMana || isNetCard)
            {

                //accordion 头
                subMenu.Append("{\"menuid\": \"3\",\"menuname\": \"上网卡管理\",\"icon\": \"icon-transmit_blue\",\"menus\": [");
                subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"上网卡状态管理\",\"icon\": \"ext-icon-table\",");
                subMenu.Append("\"url\": \"NetWorkCard/CardInfo.aspx\",\"iframename\": \"swkztgl\"}");
                subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"上网卡使用明细\",\"icon\": \"ext-icon-table\",");
                subMenu.Append("\"url\": \"NetWorkCard/CardUsingLog.aspx\",\"iframename\": \"swksymx\"}");
                //accordion 尾
                subMenu.Append("]}");
            }
            menuArr.Add(subMenu.ToString());
            subMenu.Length = 0;
                */
            //上网卡管理 end
            ////员工考勤 begin
            //if (isGZLD)
            //{

            //    //accordion 头
            //    subMenu.Append("{\"menuid\": \"3\",\"menuname\": \"员工考勤管理\",\"icon\": \"ext-icon-page_edit\",\"menus\": [");
            //    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"考勤结果明细\",\"icon\": \"ext-icon-table\",");
            //    subMenu.Append("\"url\": \"WorkAttendance/AttendanceResult.aspx\",\"iframename\": \"kqjgmx\"}");
            //    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"签到记录明细\",\"icon\": \"ext-icon-table\",");
            //    subMenu.Append("\"url\": \"WorkAttendance/AttendanceDetail.aspx\",\"iframename\": \"qdjlmx\"}");
            //    //accordion 尾
            //    subMenu.Append("]}");
            //}
            //menuArr.Add(subMenu.ToString());
            //subMenu.Length = 0;
            //员工考勤 end
            //应急库 begin
            /*
            if (isAdmin || isSX || isYW || isKG || isGZLD)
            {

                //accordion 头
                subMenu.Append("{\"menuid\": \"3\",\"menuname\": \"应急库事项管理\",\"icon\": \"icon-book\",\"menus\": [");
                subMenu.Append("{\"menuid\": \"11\",\"menuname\": \"应急库信息管理\",\"icon\": \"ext-icon-table\",");
                subMenu.Append("\"url\": \"yjkgd/yjkxxgl.aspx\",\"iframename\": \"pbframe\"}");
                if (isKG && !isTOWN)
                {
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"应急库信息录入\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"yjkgd/yjkxxlr.aspx\",\"iframename\": \"spframe\"}");
                }
                if (isKG || isAdmin || isYW)
                {
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"应急库领料信息管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"yjkgd/yjkxxllgl.aspx\",\"iframename\": \"spframe\"}");
                }
                //accordion 尾
                subMenu.Append("]}");
            }
            menuArr.Add(subMenu.ToString());
            subMenu.Length = 0;
                */
            //应急库 end
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
                if (isFaultReapir || isEC || isECMana)
                {
                    subMenu.Append("{\"menuid\": \"11\",\"menuname\": \"物料领用管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"MaintainMaterial/UnitDrawStockDetail.aspx\",\"iframename\": \"spframe\"}");
                }
                //subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"领料单位管理\",\"icon\": \"ext-icon-table\",");
                //subMenu.Append("\"url\": \"MaintainMaterial/AreaInfo.aspx\",\"iframename\": \"spframe\"}");
                //accordion 尾
                subMenu.Append("]}");
            }
            menuArr.Add(subMenu.ToString());
            subMenu.Length = 0;
            //运维物料管理 end
            // 专项整治事项管理 begin
            if (isAdmin || isKG || isYW || isFaultReapir)
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
                if (isFaultReapir)
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
            //基站考核 begin
            /*
            if (!isSX && !isKG && !isUnitKG && !isUnitPQ && !isUnitPQLL && !isAN && !isNetCard&& !isEC&& !isCAKG&& !isCALL&& !isCAWG)
            {

                //accordion 头
                subMenu.Append("{\"menuid\": \"3\",\"menuname\": \"基站考核事项管理\",\"icon\": \"icon-chart_bar\",\"menus\": [");
                subMenu.Append("{\"menuid\": \"11\",\"menuname\": \"基站维护考核表\",\"icon\": \"ext-icon-table\",");
                subMenu.Append("\"url\": \"jzkh/jzkhtjb.aspx\",\"iframename\": \"pbframe\"}");
                if (isWW && Session["uname"].ToString() == "tianlihua")
                {
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"基站断站指标考核\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"jzkh/jzdzzb_marking.aspx\",\"iframename\": \"spframe\"}");
                }
                if (isWW && Session["uname"].ToString() == "tianlihua")
                {
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"小区故障指标考核\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"jzkh/xqjgzzb_marking.aspx\",\"iframename\": \"spframe\"}");
                }
                if ((isWW && Session["uname"].ToString() == "tianlihua") || isYWJZ || isGXJZKH)
                {
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"日常维护管理考核\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"jzkh/jzrcwh_marking.aspx\",\"iframename\": \"spframe\"}");
                }
                if (isWY)
                {
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"网优指标考核\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"jzkh/jzwykh_marking.aspx\",\"iframename\": \"spframe\"}");
                }
                if (isYWJZ)
                {
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"额外奖惩考核\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"jzkh/jzewjc_marking.aspx\",\"iframename\": \"spframe\"}");
                }
                //accordion 尾
                subMenu.Append("]}");
            }
            menuArr.Add(subMenu.ToString());
            subMenu.Length = 0;
                */
            //基站考核 end
            //线路考核 begin
            /*
            if (!isSX && !isKG && !isUnitKG && !isUnitPQ && !isUnitPQLL && !isAN && !isNetCard && !isEC&& !isCAKG&& !isCALL&& !isCAWG)
            {

                //accordion 头
                subMenu.Append("{\"menuid\": \"3\",\"menuname\": \"线路考核事项管理\",\"icon\": \"icon-chart_bar\",\"menus\": [");
                subMenu.Append("{\"menuid\": \"11\",\"menuname\": \"线路维护考核表\",\"icon\": \"ext-icon-table\",");
                subMenu.Append("\"url\": \"xlkh/xlkhtjb.aspx\",\"iframename\": \"pbframe\"}");
                //if (isYW && Session["uname"].ToString() == "dongxuee")
                //{
                //    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"障碍服务指标考核\",\"icon\": \"ext-icon-table\",");
                //    subMenu.Append("\"url\": \"xlkh/ywb_xlzayfw_marking.aspx\",\"iframename\": \"spframe\"}");
                //}
                if ((isXLKH && isTOWN) || (isGZLD && Session["uname"].ToString() == "wangheyang"))
                {
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"障碍服务指标考核\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"xlkh/xlzayfw_marking.aspx\",\"iframename\": \"spframe\"}");
                }
                if ((isXLKH && isTOWN) || (isYW && Session["uname"].ToString() == "wankun") || (isGZLD && Session["uname"].ToString() == "wangheyang"))
                {
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"日常维护内容考核\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"xlkh/xlrcwh_marking.aspx\",\"iframename\": \"spframe\"}");
                }
                if (isYW && Session["uname"].ToString() == "wankun")
                {
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"额外奖罚考核\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"xlkh/xlewjc_marking.aspx\",\"iframename\": \"spframe\"}");
                }
                //accordion 尾
                subMenu.Append("]}");
            }
            menuArr.Add(subMenu.ToString());
            subMenu.Length = 0;
                */
            //线路考核 end
            //装维考核 begin
            /*
            if (!isSX && !isKG && !isUnitKG && !isUnitPQ && !isUnitPQLL && !isAN && !isNetCard && !isEC&& !isCAKG&& !isCALL&& !isCAWG)
            {

                //accordion 头
                subMenu.Append("{\"menuid\": \"3\",\"menuname\": \"装维外包考核管理\",\"icon\": \"icon-chart_bar\",\"menus\": [");
                subMenu.Append("{\"menuid\": \"11\",\"menuname\": \"装维外包考核表\",\"icon\": \"ext-icon-table\",");
                subMenu.Append("\"url\": \"zwkh/zwkhtjb.aspx\",\"iframename\": \"pbframe\"}");
                if (isYW && Session["uname"].ToString() == "dongxuee")
                {
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"障碍服务指标考核\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"zwkh/zwzayfw_marking.aspx\",\"iframename\": \"spframe\"}");
                }
                if ((isXLKH && isTOWN) || (isGZLD && Session["uname"].ToString() == "wangheyang"))
                {
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"基础管理考核\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"zwkh/zwjcgl_marking.aspx\",\"iframename\": \"spframe\"}");
                }
                if (isYW && Session["uname"].ToString() == "dongxuee")
                {
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"额外奖罚考核\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"zwkh/zwewjc_marking.aspx\",\"iframename\": \"spframe\"}");
                }
                //accordion 尾
                subMenu.Append("]}");
            }
            menuArr.Add(subMenu.ToString());
            subMenu.Length = 0;
                */
            //装维考核 end
            //库存管理 begin
            /*
            if (isAdmin || isKG || isYW || isGZLD)
            {

                //accordion 头
                subMenu.Append("{\"menuid\": \"3\",\"menuname\": \"库存管理\",\"icon\": \"icon-database\",\"menus\": [");
                subMenu.Append("{\"menuid\": \"11\",\"menuname\": \"库存统计表\",\"icon\": \"ext-icon-table\",");
                subMenu.Append("\"url\": \"kcgl/yjylkckctjb.aspx\",\"iframename\": \"pbframe\"}");
                if (isKG || isNSBD)
                {
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"库存录入\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"kcgl/yjylkckclr.aspx\",\"iframename\": \"spframe\"}");
                    subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"库存型号管理\",\"icon\": \"ext-icon-table\",");
                    subMenu.Append("\"url\": \"kcgl/yjylkclbgl.aspx\",\"iframename\": \"spframe\"}");
                }
                subMenu.Append(",{\"menuid\": \"11\",\"menuname\": \"库存录入明细\",\"icon\": \"ext-icon-table\",");
                subMenu.Append("\"url\": \"kcgl/yjylkckclrmx.aspx\",\"iframename\": \"spframe\"}");
                //accordion 尾
                subMenu.Append("]}");
            }
            menuArr.Add(subMenu.ToString());
            subMenu.Length = 0;
                */
            //库存管理 end
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