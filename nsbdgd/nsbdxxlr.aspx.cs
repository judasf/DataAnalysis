using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class nsbdxxlr : System.Web.UI.Page
{
    private string _pre;
    /// <summary>
    /// 表前缀
    /// </summary>
    public string Pre
    {
        get { return _pre; }
        set { _pre = value + "NSBD"; }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        Pre = Session["pre"] != null ? Session["pre"].ToString() : "";
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
                //判断角色 为 4，运维部派单员
                if(Session["roleid"] == null || Session["roleid"].ToString() != "4")
                    Response.Write("<script type='text/javascript'>alert('权限不足，请重新登陆！');top.location.href='../';</script>");
                //获取编号
            DataSet dr = DirectDataAccessor.QueryForDataSet("SELECT " + Pre + "xxid  FROM autoid");
                string currentId = dr.Tables[0].Rows[0][0].ToString();
                string datePre = DateTime.Now.ToString("yyyyMM");
                if (currentId.Substring(0, 6) == datePre)
                {
                    id.InnerText = Pre + currentId;
                }
                else
                {
                    id.InnerText = Pre + datePre + "001";
                }
                fsdw.InnerText = Session["deptname"].ToString();
                fssj.InnerText = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            }
        }
    }
   

    protected void Button1_Click(object sender, EventArgs e)
    {
        string sql = "insert into nsbdxx(id,fssj,fsdw,lxr,lxdh,sy,ysje,dd,sgdd,sgdw,sgdwfzr,sgdwlxdh) values(";
        sql += "'" + id.InnerText + "','" + fssj.InnerText + "','" + fsdw.InnerText + "','" + lxr.Text + "',";
        sql += "'" + lxdh.Text + "','" + sy.Text + "'," + ysje.Text + ",'"+ddl_dd.Text+"','"+sgdd.Text+"','"+sgdw.Text+"','"+sgdwfzr.Text+"','"+sgdwlxdh.Text+"');";
        sql += "Update autoid set  " + Pre + "xxid=" + (int.Parse(id.InnerText.Substring(Pre.Length)) + 1);
        DirectDataAccessor.Execute(sql);
        ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('南水北调信息录入成功！');location.href=location.href;", true);


    }
}
