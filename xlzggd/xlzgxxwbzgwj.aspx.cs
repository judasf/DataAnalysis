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
                //判断权限，外包单位和区域维护有权设置整改完结时间
                if (Session["roleid"] == null || (Session["roleid"].ToString() != "3" && Session["roleid"].ToString() != "7"))
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
                        qywh.InnerHtml = ds.Tables[0].Rows[0]["qywh"].ToString();
                        zgr.InnerHtml = ds.Tables[0].Rows[0]["zgr"].ToString();
                        //外包完结时间设置为当前时间
                        wjsj.Text = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                    }

                }
            }
                if (Request.UrlReferrer!=null && Request.UrlReferrer != Request.Url)
                    url = Request.UrlReferrer.ToString();
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
       string sql = "update xlzgxx set wjsj='"+wjsj.Text+"'  where id='" + zgid.InnerText + "'";
       DirectDataAccessor.Execute(sql);
        ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('整改完结时间设置成功！');location.href='" + url + "'", true);


    }
}
