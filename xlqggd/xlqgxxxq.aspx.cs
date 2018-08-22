using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class xlqgxxxq : System.Web.UI.Page
{
    /// <summary>
    /// 是否送审
    /// </summary>
    public bool isSs = false;
    /// <summary>
    /// 是否审计
    /// </summary>
    public bool isSj = false;
    /// <summary>
    /// 是否付费
    /// </summary>
    public bool isFf = false;
    /// <summary>
    /// 是否验收
    /// </summary>
    public bool isYs = false;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
                if (Request.QueryString["id"] == null)
                {
                    Response.Write("参数错误！");
                    Response.End();
                }
                else
                {
                    id.InnerHtml = Request.QueryString["id"].ToString();
                    DataSet ds = DirectDataAccessor.QueryForDataSet("select * from xlqgxx where id='" + Request.QueryString["id"].ToString() + "'");
                    if (ds.Tables[0].Rows.Count < 1)
                    {
                        Response.Write("参数错误！");
                        Response.End();
                    }
                    else
                    {
                        fssj.InnerHtml = ds.Tables[0].Rows[0][1].ToString();
                        fsdw.InnerHtml = ds.Tables[0].Rows[0][2].ToString();
                        lxr.InnerHtml = ds.Tables[0].Rows[0][3].ToString();
                        lxdh.InnerHtml = ds.Tables[0].Rows[0][4].ToString();
                        sy.InnerHtml = ds.Tables[0].Rows[0][5].ToString();
                        ysje.InnerHtml = ds.Tables[0].Rows[0][6].ToString();

                        ysyj.InnerHtml = ds.Tables[0].Rows[0][10].ToString();
                        ysr.InnerHtml = ds.Tables[0].Rows[0][11].ToString();
                        yssj.InnerHtml = ds.Tables[0].Rows[0][12].ToString();
                        sssj.InnerHtml = ds.Tables[0].Rows[0][13].ToString();
                        ssje.InnerHtml = ds.Tables[0].Rows[0][14].ToString();
                        sjsj.InnerHtml = ds.Tables[0].Rows[0][15].ToString();
                        sjje.InnerHtml = ds.Tables[0].Rows[0][16].ToString();
                        ffsj.InnerHtml = ds.Tables[0].Rows[0][17].ToString();
                        //设置前台显示
                        //派单信息
                        sgdwxx.InnerHtml = ds.Tables[0].Rows[0][7].ToString() == "" ? "<span style='color:#F98E02;font-weight:700;'>该迁改工单未派单</span>" : "施工单位：" + ds.Tables[0].Rows[0][7].ToString() + "&nbsp;&nbsp;&nbsp;&nbsp;负责人：" + ds.Tables[0].Rows[0][8].ToString() + "&nbsp;&nbsp;&nbsp;&nbsp;联系电话：" + ds.Tables[0].Rows[0][9].ToString();
                        qgll.InnerHtml = ds.Tables[0].Rows[0][18].ToString() == "0" ? "<span style='color:#1F41EF;font-weight:700;'>该迁改未领料</span>" : "<a href=xlqgllxxxq.aspx?id=" + id.InnerText + " target='_blank'>点击查看领料详情</a>";
                        qgtl.InnerHtml = ds.Tables[0].Rows[0][19].ToString() == "0" ? "<span style='color:#17A0EF;font-weight:700;'>该迁改未退料</span>" : "<a href=xlqgtlxxxq.aspx?id=" + id.InnerText + ">点击查看退料详情</a>";
                        isSs = ds.Tables[0].Rows[0][13].ToString() == "" ? false : true;
                        isSj = ds.Tables[0].Rows[0][15].ToString() == "" ? false : true;
                        isFf = ds.Tables[0].Rows[0][17].ToString() == "" ? false : true;

                        isYs = ds.Tables[0].Rows[0][10].ToString() == "" ? false : true;

                        sjbz.InnerHtml = isFf ? "<span class='b_red'>已付费</span>" : isSj ? "<span class='b_orange'>已审计，未付费</span>" : isSs ? "<span class='b_blue'>已送审，未审计</span>" : "<span class='b_green'>未送审</span>";
                        //迁改现场照片
                        DataSet dsxc = DirectDataAccessor.QueryForDataSet("select * from Attachment_BDAndQX where InfoAutoID='" + Request.QueryString["id"].ToString() + "' and LiveOrFinish=0");
                        if (dsxc.Tables[0].Rows.Count > 0)
                        {
                            foreach (DataRow dr in dsxc.Tables[0].Rows)
                            {
                                qgxczp.Text += "<span style='margin-right:10px;'><a target='_blank' style='margin-left:6px;' href='../" + dr["filepath"] + "' title='点击查看'>" + dr["filename"] + "</a></span>";
                            }
                        }
                        //迁改完结现场照片
                        DataSet dshf = DirectDataAccessor.QueryForDataSet("select * from Attachment_BDAndQX where InfoAutoID='" + Request.QueryString["id"].ToString() + "' and LiveOrFinish=1");
                        if (dshf.Tables[0].Rows.Count > 0)
                        {
                            foreach (DataRow dr in dshf.Tables[0].Rows)
                            {
                                qgwjxc.Text += "<span style='margin-right:10px;'><a target='_blank' style='margin-left:6px;' href='../" + dr["filepath"] + "' title='点击查看'>" + dr["filename"] + "</a></span>";
                            }
                        }
                    }
                }

            }
        }
    }


}
