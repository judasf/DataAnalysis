using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class yjylkckcedit : System.Web.UI.Page
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
                //判断权限,库管可录入库存
                if (Session["roleid"] == null || Session["roleid"].ToString() != "2" && Session["roleid"].ToString() != "11")
                    Response.Write("<script type='text/javascript'>alert('您没有相应的权限，请重新登陆！');top.location.href='../';</script>");
                int infoid = 0;
                if (Request.QueryString["id"] == null || !int.TryParse(Request.QueryString["id"].ToString(), out infoid))
                {
                    Response.Write("ACCESS DENIED!");
                    Response.End();
                }
                else
                {
                    DataSet dr = DirectDataAccessor.QueryForDataSet("SELECT *  FROM  " + Session["pre"].ToString() + "yjylkc_kcmx where id='" + infoid.ToString() + "'");
                    if (dr.Tables[0].Rows.Count <= 0)
                    {
                        Response.Write("当前信息不存在！");
                        Response.End();
                    }
                    else
                    {
                        id.InnerText = dr.Tables[0].Rows[0][0].ToString();
                        txtClassName.InnerText = dr.Tables[0].Rows[0][1].ToString();
                        txtTypeName.InnerText = dr.Tables[0].Rows[0][2].ToString();
                        units1.InnerText = dr.Tables[0].Rows[0][4].ToString();
                        amount.Text = dr.Tables[0].Rows[0][5].ToString();
                        if (PanHaoShow(dr.Tables[0].Rows[0][1].ToString(),dr.Tables[0].Rows[0][2].ToString()))
                        {
                            trPanhao.Attributes.CssStyle["display"] = "";
                            txtPanHao.Text = dr.Tables[0].Rows[0][3].ToString();
                        }
                    }

                }

            }
            if (Request.UrlReferrer != null && Request.UrlReferrer != Request.Url)
                url = Request.UrlReferrer.ToString();
        }
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        string sql;
        if (PanHaoShow(txtClassName.InnerText,txtTypeName.InnerText))
            sql = "update " + Session["pre"].ToString() + "yjylkc_kcmx set panhao='" + txtPanHao.Text.Trim() + "',amount='" + amount.Text.Trim() + "' where id='" + id.InnerText + "'";
        else
            sql = "update " + Session["pre"].ToString() + "yjylkc_kcmx set panhao='',amount='" + amount.Text.Trim() + "' where id='" + id.InnerText + "'";
        DirectDataAccessor.Execute(sql);
        ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('修改成功！');location.href='" + url + "';", true);
    }
    protected void Button2_Click(object sender, EventArgs e)
    {
        ClientScript.RegisterStartupScript(this.GetType(), "info", "location.href='" + url + "';", true);
      
    }
    /// <summary>
    /// 判断是否显示盘号
    /// </summary>
    /// <param name="classname"></param>
    /// <param name="typename"></param>
    /// <returns></returns>
    public bool PanHaoShow(string classname, string typename)
    {
        bool flag = false;
        string sql = "select isnull(panhao,'')  from " + Session["pre"].ToString() + "yjylkc_kcmx where classname='" + classname + "' and typename='" + typename + "'";
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        if (ds.Tables[0].Rows.Count > 0)
        {
            if (ds.Tables[0].Rows[0][0].ToString().Trim() != "")
                flag = true;
        }
        return flag;
    }
}
