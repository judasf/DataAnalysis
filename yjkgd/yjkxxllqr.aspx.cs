using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class yjkxxllqr : System.Web.UI.Page
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
                //判断权限,库管
                if (Session["roleid"] == null || Session["roleid"].ToString() != "2")
                    Response.Write("<script type='text/javascript'>alert('您没有相应的权限，请重新登陆！');top.location.href='../';</script>");
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
        
                    
                        pdsj.InnerHtml=ds.Tables[0].Rows[0][1].ToString();
                        pdr.InnerHtml = ds.Tables[0].Rows[0][2].ToString();
                        jsdw.InnerHtml = ds.Tables[0].Rows[0][3].ToString();
                        jsr.InnerHtml = ds.Tables[0].Rows[0][4].ToString();
                        bz.InnerHtml = ds.Tables[0].Rows[0][5].ToString();
                        NewsBind();
                }
            }

            }
            if (Request.UrlReferrer != null && Request.UrlReferrer != Request.Url)
                url = Request.UrlReferrer.ToString();
      }
    }
      private void NewsBind()
      {
          string sqlStr = "select  row_number() over(order by id ) as rowid,* from yjkxx_llmx  where yjkid='" + Request.QueryString["id"].ToString() + "'";
          DataSet ds = DirectDataAccessor.QueryForDataSet(sqlStr);
          repData.DataSource = ds;
          repData.DataBind();

      }


      protected void Button1_Click(object sender, EventArgs e)
      {
          DirectDataAccessor.Execute("Update yjkxx set  jsr='" + Session["uname"].ToString() + "',jssj=convert(varchar(50),getdate(),20) where id='" + id.InnerText + "'");
          ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('库管接收派单领料信息成功！');location.href='" + url + "'", true);

      }
}
