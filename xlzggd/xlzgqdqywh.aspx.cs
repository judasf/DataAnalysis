using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class xlzgqdqywh : System.Web.UI.Page
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
                //判断权限,外包单位指定区域维护
                if (Session["roleid"] == null || Session["roleid"].ToString() != "3")
                    Response.Write("<script type='text/javascript'>alert('您没有相应的权限，请重新登陆！');top.location.href='../';</script>");
                if (Request.QueryString["zgid"] == null)
                {
                    Response.Write("参数错误！");
                    Response.End();
                }
                else
                {
                    zgid.InnerHtml = Request.QueryString["zgid"].ToString();
                    DataSet ds = DirectDataAccessor.QueryForDataSet("select * from xlzgxx where id='" + Request.QueryString["zgid"].ToString() + "'");
                    if (ds.Tables[0].Rows.Count < 1)
                    {
                        Response.Write("参数错误1！");
                        Response.End();
                    }
                    else
                    {
                        pddw.InnerHtml = ds.Tables[0].Rows[0]["pfdw"].ToString();
                        pdr.InnerHtml = ds.Tables[0].Rows[0]["pdr"].ToString();
                        pdsj.InnerHtml = ds.Tables[0].Rows[0]["pdsj"].ToString();
                        whdw.InnerHtml = ds.Tables[0].Rows[0][1].ToString();
                        fzr.InnerHtml = ds.Tables[0].Rows[0][2].ToString();
                        zgqy.InnerHtml = ds.Tables[0].Rows[0][3].ToString();
                        czwt.InnerHtml = ds.Tables[0].Rows[0][4].ToString();
                        zgyq.InnerHtml = ds.Tables[0].Rows[0][5].ToString();
                        zgsx.InnerHtml = ds.Tables[0].Rows[0][6].ToString();
                        lxr.InnerHtml = ds.Tables[0].Rows[0]["lxr"].ToString();
                        lxdh.InnerHtml = ds.Tables[0].Rows[0]["lxdh"].ToString();
                        BindQywh();
                    }

                }
            }
                if (Request.UrlReferrer!=null && Request.UrlReferrer != Request.Url)
                    url = Request.UrlReferrer.ToString();
        }
    }
    /// <summary>
    /// 绑定外包区域维护
    /// </summary>
    private void BindQywh()
    {
        DataSet ds = DirectDataAccessor.QueryForDataSet("select uname from userinfo where roleid=7 and  deptname='"+Session["deptname"].ToString()+"'");
        qywh.Items.Add(new ListItem("请选择区域维护", "0"));
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            qywh.Items.Add(dr[0].ToString());
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        string sql = "update xlzgxx set qywh='" + qywh.Text + "'  where id='" + zgid.InnerText + "'";
        DirectDataAccessor.Execute(sql);
        ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('确定整改区域维护成功！');location.href='" + url + "'", true);


    }
}
