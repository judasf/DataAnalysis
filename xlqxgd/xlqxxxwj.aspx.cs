using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class xlqxxxwj : System.Web.UI.Page
{
    public static string url;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
                  //判断权限，派单员有权限完结工单
                if (Session["roleid"] == null || Session["roleid"].ToString() != "1")
                    Response.Write("<script type='text/javascript'>alert('您没有相应的权限，请重新登陆！');top.location.href='../';</script>");
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
                }
            }
            if (Request.UrlReferrer != Request.Url)
                url = Request.UrlReferrer.ToString();
            }
      }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        string sql = "update xlqxxx set hfsj='" + hfsj.Text + "' where id='" + qxid.Text + "'";
        DirectDataAccessor.Execute(sql);
        ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('该抢修设置完结成功！');location.href='" + url + "'", true);
    }
}
