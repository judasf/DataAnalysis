using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class xlqgxxtllr : System.Web.UI.Page
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
                id.InnerText = Request.QueryString["id"].ToString();
                DataSet ds = DirectDataAccessor.QueryForDataSet("select * from xlqgxx where id='" + Request.QueryString["id"].ToString() + "'");
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
        string sql = "insert into xlqgxx_tlmx values('" + id.InnerText + "','" + tlxx.Text + "');"; 
        sql+="update xlqgxx set qgtl=1 where id='"+id.InnerText+"'";
        DirectDataAccessor.Execute(sql);
        if (Session["pre"] != null && Session["pre"].ToString().Trim() == "")
            ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('迁改退料成功！');location.href=\"xlqgxxgl.aspx\";", true);
        if (Session["pre"] != null && Session["pre"].ToString().Trim() != "")
            ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('迁改退料成功！');location.href=\"xlqgxxgl_town.aspx\";", true);



    }
}
