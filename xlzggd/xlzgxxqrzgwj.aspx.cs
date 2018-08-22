using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class xlzgxxwj : System.Web.UI.Page
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
                //判断权限，派单人有权确认整改完结
                if (Session["roleid"] == null || Session["roleid"].ToString() != "1")
                    Response.Write("<script type='text/javascript'>alert('您没有相应的权限，请重新登陆！');top.location.href='../';</script>");
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
                        whdw.InnerHtml = ds.Tables[0].Rows[0][1].ToString();
                        fzr.InnerHtml = ds.Tables[0].Rows[0][2].ToString();
                        zgqy.InnerHtml = ds.Tables[0].Rows[0][3].ToString();
                        czwt.InnerHtml = ds.Tables[0].Rows[0][4].ToString();
                        zgyq.InnerHtml = ds.Tables[0].Rows[0][5].ToString();
                        zgsx.InnerHtml = ds.Tables[0].Rows[0][6].ToString();
                        pdr.InnerHtml = ds.Tables[0].Rows[0]["pdr"].ToString();
                        pdsj.InnerHtml = ds.Tables[0].Rows[0]["pdsj"].ToString();
                        zgcs.InnerHtml = ds.Tables[0].Rows[0]["zgcs"].ToString();
                        zgr.InnerHtml = ds.Tables[0].Rows[0]["zgr"].ToString();
                        wjsj.InnerHtml = ds.Tables[0].Rows[0]["wjsj"].ToString();
                        lxr.InnerHtml = ds.Tables[0].Rows[0]["lxr"].ToString();
                        lxdh.InnerHtml = ds.Tables[0].Rows[0]["lxdh"].ToString();
                        qywh.InnerHtml = ds.Tables[0].Rows[0]["qywh"].ToString();
                        
                        if (Request.QueryString["bz"] != null && Request.QueryString["bz"].ToString() == "1")
                        {
                            zgbz.Text = ds.Tables[0].Rows[0]["zgbz"].ToString();
                            zgbz.ReadOnly = true;
                        }
                    }

                }
            }
                if (Request.UrlReferrer!=null && Request.UrlReferrer != Request.Url)
                    url = Request.UrlReferrer.ToString();
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        string sql = "update xlzgxx set qrwjsj='" + qrwjsj.Text + "',zgbz='"+zgbz.Text+"'  where id='" + zgid.InnerText + "'";
       DirectDataAccessor.Execute(sql);
        ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('整改完结时间设置成功！');location.href='" + url + "'", true);


    }
}
