using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class xlbdtlxxxq : System.Web.UI.Page
{
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
                    id.InnerText = Request.QueryString["id"].ToString();
                    DataSet ds = DirectDataAccessor.QueryForDataSet("select bdrq,bddd from xlbdxx where id='" + Request.QueryString["id"].ToString() + "'");
                    if (ds.Tables[0].Rows.Count < 1)
                    {
                        Response.Write("参数错误！");
                        Response.End();
                    }
                    else
                    {
                        bdrq.InnerHtml = ds.Tables[0].Rows[0]["bdrq"].ToString();
                        bddd.InnerHtml = ds.Tables[0].Rows[0]["bddd"].ToString();
                   
                        DataSet ds1 = DirectDataAccessor.QueryForDataSet("select * from xlbdxx_tlmx where bdid='" + id.InnerText + "'");
                        tlxx.InnerHtml = ds1.Tables[0].Rows[0][2].ToString();
                    }

                }
            }
        }
    }
}
