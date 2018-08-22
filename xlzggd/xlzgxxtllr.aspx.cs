using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class xlzgxxtllr : System.Web.UI.Page
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
                zgid.InnerText = Request.QueryString["id"].ToString();
                DataSet ds = DirectDataAccessor.QueryForDataSet("select * from xlzgxx where id='" + Request.QueryString["id"].ToString() + "'");
                if (ds.Tables[0].Rows.Count < 1)
                {
                    Response.Write("参数错误！");
                    Response.End();
                }
                   else
                {
                    pdr.InnerHtml = ds.Tables[0].Rows[0]["pdr"].ToString();
                    pfdw.InnerHtml = ds.Tables[0].Rows[0]["pfdw"].ToString();
                    pdsj.InnerHtml = ds.Tables[0].Rows[0]["pdsj"].ToString();
                    whdw.InnerHtml = ds.Tables[0].Rows[0]["whdw"].ToString();
                    fzr.InnerHtml = ds.Tables[0].Rows[0]["fzr"].ToString();
                    fzr.InnerHtml = ds.Tables[0].Rows[0]["fzr"].ToString();
                    lxr.InnerHtml = ds.Tables[0].Rows[0]["lxr"].ToString();
                    lxrdh.InnerHtml = ds.Tables[0].Rows[0]["lxdh"].ToString();
                    qywh.InnerHtml = ds.Tables[0].Rows[0]["qywh"].ToString();
                }

            }
            }
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        string sql = "insert into xlzgxx_tlmx values('" + zgid.InnerText + "','" + tlxx.Text + "');"; 
        sql+="update xlzgxx set zgtl=1 where id='"+zgid.InnerText+"'";
        DirectDataAccessor.Execute(sql);
        ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('线路整改退料成功！');location.href=\"xlzgxxgl.aspx\";", true);


    }
}
