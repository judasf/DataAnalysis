using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class yjkxxxq : System.Web.UI.Page
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

                if (Request.QueryString["id"] == null)
                {
                    Response.Write("参数错误！");
                    Response.End();
                }
                else
                {
                    id.InnerHtml = Request.QueryString["id"].ToString();
                    DataSet ds = DirectDataAccessor.QueryForDataSet("select * from yjkxx where id='" + Request.QueryString["id"].ToString() + "'");
                    if (ds.Tables[0].Rows.Count < 1)
                    {
                        Response.Write("参数错误！");
                        Response.End();
                    }
                    else
                    {


                        pdsj.InnerHtml = ds.Tables[0].Rows[0][1].ToString();
                        pdr.InnerHtml = ds.Tables[0].Rows[0][2].ToString();
                        jsdw.InnerHtml = ds.Tables[0].Rows[0][3].ToString();
                        jsr.InnerHtml = ds.Tables[0].Rows[0][4].ToString();
                        bz.InnerHtml = ds.Tables[0].Rows[0][5].ToString();
                        jssj.InnerHtml = ds.Tables[0].Rows[0][6].ToString();
                        NewsBind();
                    }
                }

            }

        }
    }
    private void NewsBind()
    {
        string sqlStr = "select  row_number() over(order by id ) as rowid,* from yjkxx_llmx  where yjkid='" + Request.QueryString["id"].ToString() + "'";
        DataSet ds = DirectDataAccessor.QueryForDataSet(sqlStr);
        repData.DataSource = ds;
        repData.DataBind();

    }
}
