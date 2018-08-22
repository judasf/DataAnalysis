using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class right : System.Web.UI.Page
{
    /// <summary>
    /// 是否市县用户，派单员
    /// </summary>
    public bool isSX = false;
    /// <summary>
    /// 判断是否超管
    /// </summary>
    public bool isAdmin = false;
    /// <summary>
    /// 判断是否外包单位
    /// </summary>
    public bool isWB = false;
    /// <summary>
    /// 是否库管
    /// </summary>
    public bool isKG = false;
    /// <summary>
    /// 是否运维部(针对市区迁改)
    /// </summary>
    public bool isYW = false;
    /// <summary>
    /// 5：公众领导(迁改时验收工作)	
    /// </summary>
    public bool isGZLD = false;
    /// <summary>
    /// 6：公众报账员(迁改时审计报账录入)	
    /// </summary>
    public bool isGZBZ = false;
    /// <summary>
    /// 7：区域维护（工程局和北京合力施工队）	
    /// </summary>
    public bool isQYWH = false;
    /// <summary>
    /// 8：线路主管 （整改时确认料单和措施）	
    /// </summary>
    public bool isXLZG = false;
    /// <summary>
    /// 9:基站考核人员（络维护中心、网络优化中心和各县）
    /// </summary>
    public bool isJZKH = false;
    /// <summary>
    /// 9:各县基站考核人员
    /// </summary>
    public bool isGXJZKH = false;
    /// <summary>
    /// 9:基站考核，运维部考核人:zhaoziqiang
    /// </summary>
    public bool isYWJZ = false;
    /// <summary>
    /// 9:基站考核，网优考核人
    /// </summary>
    public bool isWY = false;
    /// <summary>
    /// 9:基站考核，网络维护中心考核人
    /// </summary>
    public bool isWW = false;
    /// <summary>
    /// 10:线路考核人员（公众响应中心和各县）
    /// </summary>
    public bool isXLKH = false;
    /// <summary>
    /// 11:南水北调库管
    /// </summary>
    public bool isNSBD = false;
    /// <summary>
    ///12：装维单元负责人
    /// </summary>
    public bool isUnitMana = false;
    /// <summary>
    /// 13:装维单元库管
    /// </summary>
    public bool isUnitKG = false;
    /// <summary>
    /// 14：装维片区工号
    /// </summary>
    public bool isUnitPQ = false;
    /// <summary>
    /// 17：装维片区领料工号
    /// </summary>
    public bool isUnitPQLL = false;
    /// <summary>
    /// 15：接入网资源管理
    /// </summary>
    public bool isAN = false;
    /// <summary>
    /// 16：无线上网卡管理
    /// </summary>
    public bool isNetCard = false;
    /// 20：能耗管理
    /// </summary>
    public bool isEC = false;
    /// <summary>
    /// 所在岗位
    /// </summary>
    public string SZGW = "";
    /// <summary>
    /// 是否各县用户
    /// </summary>
    public bool isTOWN = false;
    protected void Page_Load(object sender, EventArgs e)
    {


        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "" || Session["deptname"] == null || Session["roleid"] == null)
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='default.aspx';</script>");
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
                isUnitMana = Session["roleid"].ToString() == "12" ? true : false;
                isUnitKG = Session["roleid"].ToString() == "13" ? true : false;
                isUnitPQ = Session["roleid"].ToString() == "14" ? true : false;
                isAN = Session["roleid"].ToString() == "15" ? true : false;
                isNetCard = Session["roleid"].ToString() == "16" ? true : false;
                isUnitPQLL = Session["roleid"].ToString() == "17" ? true : false;
                isEC = Session["roleid"].ToString() == "20" ? true : false;
                isTOWN = Session["pre"].ToString().Trim() != "" ? true : false;

                SZGW = getRoleNameById(Session["roleid"].ToString());

                if (isSX)//工单管理员
                {
                    //提示被盗工单未恢复
                    DataSet ds = DirectDataAccessor.QueryForDataSet("select count(*) from xlbdxx where bdll=1 and isnull(hfsj,'')='' and bddw='" + Session["deptname"].ToString() + "'");
                    gztx.InnerHtml = "您有<a href='xlbdgd/xlbdxxgl.aspx'>&nbsp;" + ds.Tables[0].Rows[0][0].ToString() + "&nbsp;</a>条被盗工单未设置恢复时间，";
                    DataSet ds1 = DirectDataAccessor.QueryForDataSet("select count(*) from xlqxxx where qxll=1 and isnull(hfsj,'')='' and qxdw='" + Session["deptname"].ToString() + "'");
                    //提示抢修工单未恢复
                    if (ds1.Tables[0].Rows[0][0].ToString() != "0")
                        gztx.InnerHtml += "<a href='xlqxgd/xlqxxxgl.aspx'> &nbsp;" + ds1.Tables[0].Rows[0][0].ToString() + "&nbsp;</a>条抢修工单未设置恢复时间，";
                    //提示未设置确认整改完结时间
                    DataSet ds2 = DirectDataAccessor.QueryForDataSet("select count(id)  from xlzgxx where isnull(wjsj,'')<>'' and isnull(qrwjsj,'')=''  and pdr='" + Session["uname"].ToString() + "'" + GetZGSqlByDeptname());
                    if (ds2.Tables[0].Rows[0][0].ToString() != "0")
                        gztx.InnerHtml += "<a href='xlzggd/xlzgxxgl.aspx'> &nbsp;" + ds2.Tables[0].Rows[0][0].ToString() + "&nbsp;</a>条整改工单未确认整改完结，";
                    gztx.InnerHtml += "请及时处理！";

                }
                //库管
                if (isKG)
                {
                    //提示整改区域维护未领料出库
                    DataSet ds;
                    if (isTOWN)
                        ds = DirectDataAccessor.QueryForDataSet("select count(id)  from xlzgxx where zgll=1 and kgck=0   and pfdw='" + Session["deptname"].ToString() + "'" + GetZGSqlByDeptname());
                    else
                        ds = DirectDataAccessor.QueryForDataSet("select count(id)  from xlzgxx where xgqr=1 and kgck=0   and pfdw='" + Session["deptname"].ToString() + "'" + GetZGSqlByDeptname());
                    gztx.InnerHtml = "您有<a href='xlzggd/" + JudgeZGLinkByDeptname() + "'> &nbsp;" + ds.Tables[0].Rows[0][0].ToString() + "&nbsp;</a>条整改工单区域领料未出库，请及时处理！";
                }
                if (isWB)//外包单位
                {
                    if (!isTOWN)
                    {
                        //提示未派单
                        DataSet ds = DirectDataAccessor.QueryForDataSet("select count(*) from xlzgxx where  isnull(qywh,'')='' and whdw='" + Session["deptname"].ToString() + "'" + GetZGSqlByDeptname());
                        gztx.InnerHtml = "您有<a href='xlzggd/" + JudgeZGLinkByDeptname() + "'> &nbsp;" + ds.Tables[0].Rows[0][0].ToString() + "&nbsp;</a>条整改工单未派单，";
                        //提示未确认区域维护领料
                        DataSet ds1 = DirectDataAccessor.QueryForDataSet("select count(id)  from xlzgxx where  zgll=1 and wbqr=0 and whdw='" + Session["deptname"].ToString() + "'" + GetZGSqlByDeptname());
                        if (ds1.Tables[0].Rows[0][0].ToString() != "0")
                            gztx.InnerHtml += "<a href='xlzggd/" + JudgeZGLinkByDeptname() + "'> &nbsp;" + ds1.Tables[0].Rows[0][0].ToString() + "&nbsp;</a>条整改工单未确认区域维护领料单，";
                    }
                    //提示未设置完结时间
                    DataSet ds2 = DirectDataAccessor.QueryForDataSet("select count(id)  from xlzgxx where kgck=1 and isnull(wjsj,'')='' and whdw='" + Session["deptname"].ToString() + "'" + GetZGSqlByDeptname());
                    if (ds2.Tables[0].Rows[0][0].ToString() != "0")
                        gztx.InnerHtml += "<a href='xlzggd/" + JudgeZGLinkByDeptname() + "'> &nbsp;" + ds2.Tables[0].Rows[0][0].ToString() + "&nbsp;</a>条整改工单未设置完结时间，";
                    gztx.InnerHtml += "请及时处理！";
                }
                if (isYW)//运维部
                {
                    DataSet ds = DirectDataAccessor.QueryForDataSet("select count(*) from xlqgxx where  isnull(sgdw,'')='' and len(id)=11");
                    gztx.InnerHtml = "您有<a href='xlqggd/xlqgxxgl.aspx'> &nbsp;" + ds.Tables[0].Rows[0][0].ToString() + "&nbsp;</a>条市区迁改工单未派单，";
                    DataSet ds1 = DirectDataAccessor.QueryForDataSet("select count(*) from xlqgxx where  isnull(sgdw,'')='' and len(id)>11");
                    if (ds1.Tables[0].Rows[0][0].ToString() != "0")
                        gztx.InnerHtml += "<a href='xlqggd/xlqgxxgl_town.aspx'> &nbsp;" + ds1.Tables[0].Rows[0][0].ToString() + "&nbsp;</a>条县公司迁改工单未派单，";
                    gztx.InnerHtml += "请及时处理！";
                }
                if (isGZLD)//公众领导
                {
                    DataSet ds = DirectDataAccessor.QueryForDataSet("select count(*) from xlqgxx where  isnull(yssj,'')=''  and qgtl=1");
                    gztx.InnerHtml = "您有<a href='xlqggd/xlqgxxgl.aspx'> &nbsp;" + ds.Tables[0].Rows[0][0].ToString() + "&nbsp;</a>条市区迁改工单未验收，请及时处理";
                }
                if (isGZBZ)//报账员
                {
                    if (!isTOWN)
                    {
                        DataSet ds = DirectDataAccessor.QueryForDataSet("select count(*) from xlqgxx where  isnull(sssj,'')=''  and isnull(yssj,'')<>'' and  len(id)=11");
                        gztx.InnerHtml = "您有<a href='xlqggd/xlqgxxgl.aspx'> &nbsp;" + ds.Tables[0].Rows[0][0].ToString() + "&nbsp;</a>条市区迁改工单未送审，";
                        DataSet ds1 = DirectDataAccessor.QueryForDataSet("select count(*) from xlqgxx where  isnull(sjsj,'')=''  and isnull(sssj,'')<>'' and  len(id)=11");
                        gztx.InnerHtml += "<a href='xlqggd/xlqgxxgl.aspx'> &nbsp;" + ds1.Tables[0].Rows[0][0].ToString() + "&nbsp;</a>条市区迁改工单未审计，";
                        DataSet ds2 = DirectDataAccessor.QueryForDataSet("select count(*) from xlqgxx where isnull(ffsj,'')=''  and isnull(sjsj,'')<>'' and  len(id)=11");
                        gztx.InnerHtml += "<a href='xlqggd/xlqgxxgl.aspx'> &nbsp;" + ds2.Tables[0].Rows[0][0].ToString() + "&nbsp;</a>条市区迁改工单未付费，";
                    }
                    if (isTOWN)
                    {
                        DataSet ds3 = DirectDataAccessor.QueryForDataSet("select count(*) from xlqgxx where  isnull(sssj,'')=''  and isnull(yssj,'')<>'' and  len(id)>11");
                        gztx.InnerHtml = "您有<a href='xlqggd/xlqgxxgl_town.aspx'> &nbsp;" + ds3.Tables[0].Rows[0][0].ToString() + "&nbsp;</a>条县公司迁改工单未送审，";
                        DataSet ds4 = DirectDataAccessor.QueryForDataSet("select count(*) from xlqgxx where  isnull(sjsj,'')=''  and isnull(sssj,'')<>'' and  len(id)>11");
                        gztx.InnerHtml += "<a href='xlqggd/xlqgxxgl_town.aspx'> &nbsp;" + ds4.Tables[0].Rows[0][0].ToString() + "&nbsp;</a>条县公司迁改工单未审计，";
                        DataSet ds5 = DirectDataAccessor.QueryForDataSet("select count(*) from xlqgxx where isnull(ffsj,'')=''  and isnull(sjsj,'')<>'' and  len(id)>11");
                        gztx.InnerHtml += "<a href='xlqggd/xlqgxxgl_town.aspx'> &nbsp;" + ds5.Tables[0].Rows[0][0].ToString() + "&nbsp;</a>条县公司迁改工单未付费，";
                    }
                    gztx.InnerHtml += "请及时处理！";
                }
                if (isQYWH)//区域维护
                {
                    if (!isTOWN)
                    {
                        //提示未录入整改措施
                        DataSet ds = DirectDataAccessor.QueryForDataSet("select count(id)  from xlzgxx where isnull(zgcs,'')='' and qywh='" + Session["uname"].ToString() + "'" + GetZGSqlByDeptname());
                        gztx.InnerHtml = "您有<a href='xlzggd/" + JudgeZGLinkByDeptname() + "'> &nbsp;" + ds.Tables[0].Rows[0][0].ToString() + "&nbsp;</a>条整改工单未录入整改措施，";
                        //区域维护提示未录入整改领料
                        DataSet ds1 = DirectDataAccessor.QueryForDataSet("select count(id)  from xlzgxx where zgll=0 and isnull(zgcs,'')<>'' and qywh='" + Session["uname"].ToString() + "'" + GetZGSqlByDeptname());
                        if (ds1.Tables[0].Rows[0][0].ToString() != "0")
                            gztx.InnerHtml += "<a href='xlzggd/" + JudgeZGLinkByDeptname() + "'> &nbsp;" + ds1.Tables[0].Rows[0][0].ToString() + "&nbsp;</a>条整改工单未领料，";
                    }
                    //区域维护提示未设置整改完结
                    DataSet ds2 = DirectDataAccessor.QueryForDataSet("select count(id)  from xlzgxx where kgck=1 and isnull(wjsj,'')='' and qywh='" + Session["uname"].ToString() + "'" + GetZGSqlByDeptname());
                    if (ds2.Tables[0].Rows[0][0].ToString() != "0")
                        gztx.InnerHtml += "<a href='xlzggd/" + JudgeZGLinkByDeptname() + "'> &nbsp;" + ds2.Tables[0].Rows[0][0].ToString() + "&nbsp;</a>条整改工单未设置完结时间，";
                    gztx.InnerHtml += "请及时处理！";
                }
                //线路主管
                if (isXLZG)
                {
                    //提示未确认区域维护领料单
                    DataSet ds = DirectDataAccessor.QueryForDataSet("select count(id)  from xlzgxx where  wbqr=1 and xgqr=0  and  zgtd=0 and pfdw='" + Session["deptname"].ToString() + "'" + GetZGSqlByDeptname());
                    gztx.InnerHtml = "您有<a href='xlzggd/" + JudgeZGLinkByDeptname() + "'> &nbsp;" + ds.Tables[0].Rows[0][0].ToString() + "&nbsp;</a>条整改工单未确认区域维护领料单，请及时处理！";
                }
            }
        }
    }
    private string getRoleNameById(string id)
    {
        DataSet ds = DirectDataAccessor.QueryForDataSet("select rolename from roleinfo where roleid='" + id + "'");
        return ds.Tables[0].Rows[0][0].ToString();
    }
    /// <summary>
    ///根据单位判断整改地址
    /// </summary>
    /// <param name="pfdw"></param>
    /// <returns></returns>
    private string JudgeZGLinkByDeptname()
    {
        string link = "xlzgxxgl.aspx";
        string sql = "select pre from deptinfo where deptname='" + Session["deptname"] + "'";
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        if (ds.Tables[0].Rows.Count > 0)
        {
            if (ds.Tables[0].Rows[0][0].ToString() != "")
                link = "xlzgxxgl_town.aspx";
        }
        return link;
    }
    /// <summary>
    ///根据单位判断整改查询条件
    /// </summary>
    /// <param name="pfdw"></param>
    /// <returns></returns>
    private string GetZGSqlByDeptname()
    {
        string link = " and len(id)=11 ";
        string sql = "select pre from deptinfo where deptname='" + Session["deptname"] + "'";
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        if (ds.Tables[0].Rows.Count > 0)
        {
            if (ds.Tables[0].Rows[0][0].ToString() != "")
                link = " and len(id)>11 ";
        }
        return link;
    }
}
