using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class xlqxxxlr : System.Web.UI.Page
{
  
    private string _pre;
    /// <summary>
    /// 表前缀
    /// </summary>
    public string Pre
    {
        get { return _pre; }
        set { _pre = value+"QX"; }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        //设置表前缀
        Pre = Session["pre"] != null ? Session["pre"].ToString() : "";
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
                //判断角色 为 1，各单位派单人员可以录单
                if (Session["roleid"] == null || Session["roleid"].ToString() != "1")
                    Response.Write("<script type='text/javascript'>alert('您没有相应的权限，请重新登陆！');top.location.href='../';</script>");
                DataSet dr = DirectDataAccessor.QueryForDataSet("SELECT "+Pre+"xxid  FROM autoid");
                string currentId = dr.Tables[0].Rows[0][0].ToString();
                string datePre = DateTime.Now.ToString("yyyyMM");
                if (currentId.Substring(0, 6) == datePre)
                {
                    id.Text = Pre+currentId;
                }
                else
                {
                    id.Text = Pre+datePre + "001";
                }

            }
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        string sql = "insert into xlqxxx values('" + id.Text + "','" + qxrq.Text + "','" + qxdd.Text + "','" + Session["deptname"].ToString() + "',";
        sql += "'" + bgarq.Text + "','" + bbxgsrq.Text + "','" + bxgscxc.Text + "','" + qxss.Text + "','" + ssje.Text + "','',0,0);";
        sql += "Update autoid set " + Pre + "xxid=" + (int.Parse(id.Text.Substring(Pre.Length)) + 1);
        DirectDataAccessor.Execute(sql);
        ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('线路抢修信息录入成功！');location.href=location.href;", true);


    }
}
