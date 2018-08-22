using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class nsbdxxsjlr : System.Web.UI.Page
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
                //判断权限，4：运维部有权限
                if (Session["roleid"] == null || Session["roleid"].ToString() != "4")
                    Response.Write("<script type='text/javascript'>alert('您没有相应的权限，请重新登陆！');top.location.href='../';</script>");
                if (Request.QueryString["id"] == null)
                {
                    Response.Write("参数错误！");
                    Response.End();
                }
                else
                {
                    id.InnerText = Request.QueryString["id"].ToString();
                    DataSet ds = DirectDataAccessor.QueryForDataSet("select * from nsbdxx where id='" + Request.QueryString["id"].ToString() + "'");
                    if (ds.Tables[0].Rows.Count < 1)
                    {
                        Response.Write("参数错误！");
                        Response.End();
                    }
                    else
                    {
                        fssj.InnerHtml = ds.Tables[0].Rows[0]["fssj"].ToString();
                        fsdw.InnerHtml = ds.Tables[0].Rows[0]["fsdw"].ToString();
                        lxr.InnerHtml = ds.Tables[0].Rows[0]["lxr"].ToString();
                        lxdh.InnerHtml = ds.Tables[0].Rows[0]["lxdh"].ToString();
                        sy.InnerHtml = ds.Tables[0].Rows[0]["sy"].ToString();
                        ysje.InnerHtml = ds.Tables[0].Rows[0]["ysje"].ToString();
                        sgdw.InnerHtml = ds.Tables[0].Rows[0]["sgdw"].ToString();
                        sgdwfzr.InnerHtml = ds.Tables[0].Rows[0]["sgdwfzr"].ToString();
                        sgdwlxdh.InnerHtml = ds.Tables[0].Rows[0]["sgdwlxdh"].ToString();
                        ysyj.InnerHtml = ds.Tables[0].Rows[0]["ysyj"].ToString();
                        ysr.InnerHtml = ds.Tables[0].Rows[0]["ysr"].ToString();
                        yssj.InnerHtml = ds.Tables[0].Rows[0]["yssj"].ToString();
                        sssj.InnerHtml = ds.Tables[0].Rows[0]["sssj"].ToString();
                        ssje.InnerHtml = ds.Tables[0].Rows[0]["ssje"].ToString();
                        dd.InnerHtml = ds.Tables[0].Rows[0]["dd"].ToString();
                        sgdd.InnerHtml = ds.Tables[0].Rows[0]["sgdd"].ToString();
                    }

                }
            }
            if (Request.UrlReferrer != null && Request.UrlReferrer != Request.Url)
                url = Request.UrlReferrer.ToString();
        }
    }


    protected void Button1_Click(object sender, EventArgs e)
    {
        string sql = "update nsbdxx set sjsj='" + sjsj.Text + "',sjje='" + sjje.Text + "'  where id='" + id.InnerText + "'";
        DirectDataAccessor.Execute(sql);
        ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('成功提交审计信息！');location.href='" + url + "'", true);


    }
}
