using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class xlbdxxxq : System.Web.UI.Page
{
    /// <summary>
    /// 是否整改
    /// </summary>
    public bool isZg=false;
    /// <summary>
    /// 是否复查
    /// </summary>
    public bool isFC = false;
    /// <summary>
    /// 是否退单
    /// </summary>
    public bool isTD = false;
    /// <summary>
    /// 是否各县用户
    /// </summary>
    public bool isTOWN = false;
    protected void Page_Load(object sender, EventArgs e)
    {
        //isTOWN = Session["pre"] != null && Session["pre"].ToString().Trim() != "" ? true : false;
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
            if (Request.QueryString["zgid"] == null)
            {
                Response.Write("参数错误！");
                Response.End();
            }
            else
            {
                zgid.InnerHtml = Request.QueryString["zgid"].ToString();
                    DataSet ds = DirectDataAccessor.QueryForDataSet("select *,dbo.GetJobDuration(pdsj,wjsj) as jobduration from xlzgxx where id='" + Request.QueryString["zgid"].ToString() + "'");
                    if (ds.Tables[0].Rows.Count < 1)
                    {
                        Response.Write("参数错误！");
                        Response.End();
                    }
                    else
                    {
                        whdw.InnerHtml = ds.Tables[0].Rows[0][1].ToString();
                        fzr.InnerHtml = ds.Tables[0].Rows[0][2].ToString();
                        zgqy.InnerHtml = ds.Tables[0].Rows[0][3].ToString();
                        czwt.InnerHtml = ds.Tables[0].Rows[0][4].ToString();
                        zgyq.InnerHtml = ds.Tables[0].Rows[0][5].ToString();
                        zgsx.InnerHtml = ds.Tables[0].Rows[0][6].ToString();
                        zgcs.InnerHtml = ds.Tables[0].Rows[0][7].ToString();
                        zgr.InnerHtml = ds.Tables[0].Rows[0][8].ToString();
                        fcyj.InnerHtml = ds.Tables[0].Rows[0][10].ToString();
                        fcr.InnerHtml = ds.Tables[0].Rows[0][11].ToString();
                        fcsj.InnerHtml = ds.Tables[0].Rows[0][12].ToString();
                        pdr.InnerHtml=ds.Tables[0].Rows[0][13].ToString();
                        pdsj.InnerHtml=ds.Tables[0].Rows[0][16].ToString();
                        pddw.InnerHtml=ds.Tables[0].Rows[0][17].ToString();
                        lxr.InnerHtml = ds.Tables[0].Rows[0]["lxr"].ToString();
                        lxdh.InnerHtml = ds.Tables[0].Rows[0]["lxdh"].ToString();
                        xllx.InnerHtml = ds.Tables[0].Rows[0]["xllx"].ToString();
                        jobDuration.InnerHtml = ds.Tables[0].Rows[0]["jobDuration"].ToString();
                        isTOWN=Request.QueryString["zgid"].ToString().Length>11?true:false;
                        //设置前台显示
                        qywh.InnerHtml = ds.Tables[0].Rows[0]["qywh"].ToString() == "" ? "<span style='color:#F98E02;font-weight:700;'>外包单位没有指定区域维护</span>" : ds.Tables[0].Rows[0]["qywh"].ToString();
                        wbqr.InnerHtml = ds.Tables[0].Rows[0]["wbqr"].ToString() == "0" ? "<span style='color:#F98E02;font-weight:700;'>未确认</span>" : "<span style='color:#F98E02;font-weight:700;'>已确认</span>";

                        if (ds.Tables[0].Rows[0]["zgtd"].ToString() == "1")
                        {
                            xgqr.InnerHtml = "<span  class='b_red'>已退单</span>";
                            isTD = true;
                            tdyy.InnerHtml = ds.Tables[0].Rows[0]["tdyy"].ToString();
                        }
                        else
                        {
                                xgqr.InnerHtml = ds.Tables[0].Rows[0]["xgqr"].ToString() == "0" ? "<span style='color:#F98E02;font-weight:700;'>未确认</span>" : "<span style='color:#F98E02;font-weight:700;'>已确认</span>";
                        }
                        zgll.InnerHtml = ds.Tables[0].Rows[0][14].ToString() == "0" ? "<span style='color:#1F41EF;font-weight:700;'>该整改未领料</span>" : "<a href=xlzgllxxxq.aspx?zgid=" + zgid.InnerText + " target='_blank'>点击查看领料详情</a>";
                        zgtl.InnerHtml = ds.Tables[0].Rows[0][15].ToString() == "0" ? "<span style='color:#17A0EF;font-weight:700;'>该整改未退料</span>" : "<a href=xlzgtlxxxq.aspx?zgid=" + zgid.InnerText + " >点击查看退料详情</a>";
                        isZg = ds.Tables[0].Rows[0][7].ToString() == "" ? false : true;
                        isFC = ds.Tables[0].Rows[0][10].ToString() == "" ? false : true;
                        kgck.InnerHtml = ds.Tables[0].Rows[0]["kgck"].ToString() == "0" ? "<span class='b_blue'>该领料未出库</span>" : "<span  class='b_blue'>该领料已出库</span>";
                        wjsj.InnerHtml = ds.Tables[0].Rows[0]["wjsj"].ToString() == "" ? "<span class='b_red'>未完结</span>" : ds.Tables[0].Rows[0]["wjsj"].ToString();
                        qrwjsj.InnerHtml = ds.Tables[0].Rows[0]["qrwjsj"].ToString() == "" ? "<span class='b_red'>未确认完结</span>" : ds.Tables[0].Rows[0]["qrwjsj"].ToString();
                        zgbz.InnerHtml = ds.Tables[0].Rows[0]["zgbz"].ToString();

                    }
            }

            }
      }
    }

  
}
