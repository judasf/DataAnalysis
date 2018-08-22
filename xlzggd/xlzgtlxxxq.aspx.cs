using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class xlzgtlxxxq : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
                if (Request.QueryString["zgid"] == null)
                {
                    Response.Write("参数错误！");
                    Response.End();
                }
                else
                {
                    zgid.InnerText = Request.QueryString["zgid"].ToString();
                    DataSet ds = DirectDataAccessor.QueryForDataSet("select * from xlzgxx where id='" + Request.QueryString["zgid"].ToString() + "'");
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
                        DataSet ds1 = DirectDataAccessor.QueryForDataSet("select * from xlzgxx_tlmx where zgid='" + zgid.InnerText + "'");
                        tlxx.InnerHtml = ds1.Tables[0].Rows[0][2].ToString();
                    }

                }
            }
        }
    }
}
