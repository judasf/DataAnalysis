using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class xlzgxxlr_town : System.Web.UI.Page
{
    private string _pre;
    /// <summary>
    /// 表前缀
    /// </summary>
    public string Pre
    {
        get { return _pre; }
        set { _pre = value + "ZG"; }
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
                //判断角色 为 1，各单位派单人员可以录单
                if(Session["roleid"] == null || Session["roleid"].ToString() != "1")
                    Response.Write("<script type='text/javascript'>alert('权限不足，请重新登陆！');top.location.href='../';</script>");
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
                pdr.InnerText = Session["uname"].ToString();
                pfdw.InnerText = Session["deptname"].ToString();
                pdsj.InnerText = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                BindQYWH();
            }
        }
    }
    /// <summary>
    /// 绑定区域维护
    /// </summary>
    private void BindQYWH()
    {
        DataSet ds = DirectDataAccessor.QueryForDataSet("select uname from userinfo where roleid=7 and tablepre='"+Session["pre"].ToString()+"'");
        whdw.Items.Add(new ListItem("请选择区域维护", "0"));
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            whdw.Items.Add(dr[0].ToString());
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        string sql = "insert into xlzgxx(id,whdw,fzr,zgqy,czwt,zgyq,zgsx,pdr,pdsj,pfdw,lxr,lxdh,qywh) values(";
        sql += "'" + id.InnerText + "','" + Session["deptname"].ToString() + "','" + fzr.Text + "','" + zgqy.Text + "',";
        sql += "'" + czwt.Text + "','" + zgyq.Text + "','" + zgsx.Text + "','" + pdr.InnerText + "',";
        sql += "'" + pdsj.InnerText + "','" + Session["deptname"].ToString() + "','" + lxr.Text + "','" + lxdh.Text + "','" + whdw.Text + "');";
       sql += "Update autoid set  " + Pre + "xxid=" + (int.Parse(id.InnerText.Substring(Pre.Length)) + 1);
       DirectDataAccessor.Execute(sql);
       ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('整改通知书派发成功！');location.href=location.href;", true);


    }
}
