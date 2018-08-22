using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class xlqgxxsgpd : System.Web.UI.Page
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
                //判断权限，运维部有权派单
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
                    DataSet ds = DirectDataAccessor.QueryForDataSet("select * from xlqgxx where id='" + Request.QueryString["id"].ToString() + "'");
                    if (ds.Tables[0].Rows.Count < 1)
                    {
                        Response.Write("参数错误！");
                        Response.End();
                    }
                    else
                    {
                        //判断市区或县公司
                        if (id.InnerText.Length > 11)
                            pathname.InnerHtml = "<a href=\"xlqgxxgl_town.aspx\">县公司迁改信息管理</a>";
                        else
                            pathname.InnerHtml = "<a href=\"xlqgxxgl.aspx\">市区迁改信息管理</a>";

                        fssj.InnerHtml = ds.Tables[0].Rows[0]["fssj"].ToString();
                        fsdw.InnerHtml = ds.Tables[0].Rows[0]["fsdw"].ToString();
                        lxr.InnerHtml = ds.Tables[0].Rows[0]["lxr"].ToString();
                        lxdh.InnerHtml = ds.Tables[0].Rows[0]["lxdh"].ToString();
                        sy.InnerHtml = ds.Tables[0].Rows[0]["sy"].ToString();
                        ysje.InnerHtml = ds.Tables[0].Rows[0]["ysje"].ToString();

                    }

                }
            }
            if (Request.UrlReferrer != null && Request.UrlReferrer != Request.Url)
                url = Request.UrlReferrer.ToString();
        }
    }


    protected void Button1_Click(object sender, EventArgs e)
    {
        string sql = "update xlqgxx set sgdw='" + sgdw.Text + "',sgdwfzr='" + sgdwfzr.Text + "',sgdwlxdh='" + sgdwlxdh.Text + "'  where id='" + id.InnerText + "'";
        DirectDataAccessor.Execute(sql);
        ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('迁改派单成功！');location.href='" + url + "'", true);


    }
}
