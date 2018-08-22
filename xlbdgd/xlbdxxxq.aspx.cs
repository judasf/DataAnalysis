using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class xlbdxxxq : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
                if (Request.QueryString["bdid"] == null)
                {
                    Response.Write("参数错误！");
                    Response.End();
                }
                else
                {
                    bdid.Text = Request.QueryString["bdid"].ToString();
                    DataSet ds = DirectDataAccessor.QueryForDataSet("select * from xlbdxx where id='" + Request.QueryString["bdid"].ToString() + "'");
                    if (ds.Tables[0].Rows.Count < 1)
                    {
                        Response.Write("参数错误！");
                        Response.End();
                    }
                    else
                    {
                        bdrq.Text = ds.Tables[0].Rows[0][1].ToString();
                        bddd.Text = ds.Tables[0].Rows[0][2].ToString();
                        bgarq.Text = ds.Tables[0].Rows[0][4].ToString();
                        bbxgsrq.Text = ds.Tables[0].Rows[0][5].ToString();
                        bxgscxc.Text = ds.Tables[0].Rows[0][6].ToString();
                        bdss.Text = ds.Tables[0].Rows[0][7].ToString();
                        ssje.Text = ds.Tables[0].Rows[0][8].ToString();
                        hfsj.Text = ds.Tables[0].Rows[0][9].ToString();
                        bdll.Text = ds.Tables[0].Rows[0][10].ToString() == "0" ? "<span style='color:#F98E02;font-weight:700;'>该被盗未领料</span>" : "<a href=xlbdllxxxq.aspx?bdid=" + bdid.Text + " target='_blank'>点击查看领料详情</a>";
                        bdwj.Text = ds.Tables[0].Rows[0][9].ToString() == "" ? "<span style='color:#E82246;font-weight:700;'>未完结</span>" : "已完结";
                        //被盗现场照片
                        DataSet dsxc = DirectDataAccessor.QueryForDataSet("select * from Attachment_BDAndQX where InfoAutoID='" + Request.QueryString["bdid"].ToString() + "' and LiveOrFinish=0");
                        if(dsxc.Tables[0].Rows.Count>0)
                        {
                            foreach(DataRow dr in dsxc.Tables[0].Rows)
                            {
                                bdxczp.Text += "<span style='margin-right:10px;'><a target='_blank' style='margin-left:6px;' href='../" + dr["filepath"] + "' title='点击查看'>" + dr["filename"] + "</a></span>";
                            }
                        }
                        //被盗恢复现场照片
                        DataSet dshf = DirectDataAccessor.QueryForDataSet("select * from Attachment_BDAndQX where InfoAutoID='" + Request.QueryString["bdid"].ToString() + "' and LiveOrFinish=1");
                        if (dshf.Tables[0].Rows.Count > 0)
                        {
                            foreach (DataRow dr in dshf.Tables[0].Rows)
                            {
                                bdhfxc.Text += "<span style='margin-right:10px;'><a target='_blank' style='margin-left:6px;' href='../" + dr["filepath"] + "' title='点击查看'>" + dr["filename"] + "</a></span>";
                            }
                        }
                    }
                }

            }
        }
    }
}
