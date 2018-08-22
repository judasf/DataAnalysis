using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class xlqxxxtllr : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
                //库管有权限退料
                if (Session["roleid"] == null || Session["roleid"].ToString() != "2")
                    Response.Write("<script type='text/javascript'>alert('您没有对应的权限，请重新登陆！');top.location.href='../';</script>");
            if (Request.QueryString["id"] == null)
            {
                Response.Write("参数错误！");
                Response.End();
            }
            else
            {
                qxid.InnerText = Request.QueryString["id"].ToString();
                DataSet ds = DirectDataAccessor.QueryForDataSet("select * from xlqxxx where id='" + Request.QueryString["id"].ToString() + "'");
                if (ds.Tables[0].Rows.Count < 1)
                {
                    Response.Write("参数错误！");
                    Response.End();
                }
                   else
                {
                    qxrq.InnerHtml = ds.Tables[0].Rows[0][1].ToString();
                    qxdd.InnerHtml = ds.Tables[0].Rows[0][2].ToString();
                }

            }
            }
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        string sql = "insert into xlqxxx_tlmx values('" + qxid.InnerText + "','" + tlxx.Text + "');";
        sql += "update xlqxxx set qxtl=1 where id='" + qxid.InnerText + "'";
        DirectDataAccessor.Execute(sql);
        ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('抢修退料成功！');location.href=\"xlqxxxgl.aspx\";", true);


    }
}
