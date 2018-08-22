using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class xlzgxxxgllqr : System.Web.UI.Page
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
                //判断权限,线路主管有权对外包单位已确认的区域维护领料单进行确认
                if (Session["roleid"] == null || Session["roleid"].ToString() != "8")
                    Response.Write("<script type='text/javascript'>alert('您没有相应的权限，请重新登陆！');top.location.href='../';</script>");
            if (Request.QueryString["zgid"] == null)
            {
                Response.Write("参数错误！");
                Response.End();
            }
            else
            {
                zgid.InnerHtml = Request.QueryString["zgid"].ToString();
                    DataSet ds = DirectDataAccessor.QueryForDataSet("select * from dlysxx where id='" + Request.QueryString["zgid"].ToString() + "'");
                    if (ds.Tables[0].Rows.Count < 1)
                    {
                        Response.Write("参数错误！");
                        Response.End();
                    }
                    else
                    {
                        whdw.InnerHtml = ds.Tables[0].Rows[0][1].ToString();
                        fzr.InnerHtml = ds.Tables[0].Rows[0][2].ToString();
                       zgcs.InnerHtml = ds.Tables[0].Rows[0][7].ToString();
                        zgr.InnerHtml = ds.Tables[0].Rows[0][8].ToString();
                        pdr.InnerHtml=ds.Tables[0].Rows[0][13].ToString();
                        pdsj.InnerHtml=ds.Tables[0].Rows[0][16].ToString();
                        pddw.InnerHtml=ds.Tables[0].Rows[0][18].ToString();
                        lxr.InnerHtml = ds.Tables[0].Rows[0]["lxr"].ToString();
                        lxdh.InnerHtml = ds.Tables[0].Rows[0]["lxdh"].ToString();
                        qywh.InnerHtml = ds.Tables[0].Rows[0]["qywh"].ToString();
                        DataSet ds1 = DirectDataAccessor.QueryForDataSet("select top 1  llr,lxdh from dlysxx_llmx where zgid='" + Request.QueryString["zgid"].ToString() + "'");
                        llr.InnerHtml = ds1.Tables[0].Rows[0][0].ToString();
                        llrlxdh.InnerHtml = ds1.Tables[0].Rows[0][1].ToString();

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
          string sqlStr = "select  row_number() over(order by id ) as rowid,* from dlysxx_llmx  where zgid='" + Request.QueryString["zgid"].ToString() + "'";
          DataSet ds = DirectDataAccessor.QueryForDataSet(sqlStr);
          repData.DataSource = ds;
          repData.DataBind();

      }


      protected void Button1_Click(object sender, EventArgs e)
      {
          string sql = "";
          if (zgtd.Text == "0")
              sql = "Update dlysxx set xgqr=1 where id='" + zgid.InnerText + "'";
          else
              sql = "Update dlysxx set zgtd=1,tdyy='"+tdyy.Text+"' where id='" + zgid.InnerText + "'";
          DirectDataAccessor.Execute(sql);
          ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('该区域维护领料单确认成功！');location.href='"+url+"'", true);

      }
}
