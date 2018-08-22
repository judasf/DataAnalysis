using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class nsbdxxtllr : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
                //南水北调库管有权限退料
                if (Session["roleid"] == null || Session["roleid"].ToString() != "11")
                    Response.Write("<script type='text/javascript'>alert('您没有对应的权限，请重新登陆！');top.location.href='../';</script>");
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
                    sgdw.InnerHtml = ds.Tables[0].Rows[0]["sgdw"].ToString();
                    fzr.InnerHtml = ds.Tables[0].Rows[0]["sgdwfzr"].ToString();
                }

            }
            }
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        string sql = "insert into nsbdxx_tlmx values('" + id.InnerText + "','" + tlxx.Text + "');"; 
        sql+="update nsbdxx set qgtl=1 where id='"+id.InnerText+"'";
        DirectDataAccessor.Execute(sql);
            ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('南水北调退料成功！');location.href=\"nsbdxxgl.aspx\";", true);



    }
}
