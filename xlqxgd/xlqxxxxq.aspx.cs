using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class xlqxxxxq : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
            if (Request.QueryString["qxid"] == null)
            {
                Response.Write("参数错误！");
                Response.End();
            }
            else
            {
                qxid.Text = Request.QueryString["qxid"].ToString();
                DataSet ds = DirectDataAccessor.QueryForDataSet("select * from xlqxxx where id='" + Request.QueryString["qxid"].ToString() + "'");
                if (ds.Tables[0].Rows.Count < 1)
                {
                    Response.Write("参数错误！");
                    Response.End();
                }
                else
                {
                    qxrq.Text = ds.Tables[0].Rows[0][1].ToString();
                    qxdd.Text = ds.Tables[0].Rows[0][2].ToString();
                    bgarq.Text = ds.Tables[0].Rows[0][4].ToString();
                    bbxgsrq.Text=ds.Tables[0].Rows[0][5].ToString();
                    bxgscxc.Text = ds.Tables[0].Rows[0][6].ToString();
                    qxss.Text = ds.Tables[0].Rows[0][7].ToString();
                    ssje.Text = ds.Tables[0].Rows[0][8].ToString();
                    hfsj.Text = ds.Tables[0].Rows[0][9].ToString();
                    qxll.Text = ds.Tables[0].Rows[0][10].ToString() == "0" ? "<span style='color:#F98E02;font-weight:700;'>该抢修未领料</span>" : "<a href=xlqxllxxxq.aspx?qxid=" + qxid.Text + " target='_blank'>点击查看领料详情</a>";
                    qxtl.Text = ds.Tables[0].Rows[0]["qxtl"].ToString() == "0" ? "<span style='color:#17A0EF;font-weight:700;'>该抢修未退料</span>" : "<a href=xlqxtlxxxq.aspx?id=" + qxid.Text + ">点击查看退料详情</a>";
                    bdwj.Text = ds.Tables[0].Rows[0][9].ToString() == "" ? "<span style='color:#E82246;font-weight:700;'>未完结</span>" : "已完结";
                }
            }

            }
      }
    }

  
}
