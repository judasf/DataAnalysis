using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class xlzgxxlr : System.Web.UI.Page
{
    private string _pre;
    /// <summary>
    /// 表前缀
    /// </summary>
    public string Pre
    {
        get { return _pre; }
        set { _pre = value + "DLYS"; }
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
                BindWhdw();
            }
        }
    }
    /// <summary>
    /// 绑定维护单位
    /// </summary>
    private void BindWhdw()
    {
        DataSet ds = DirectDataAccessor.QueryForDataSet("select deptname from userinfo where roleid=3 and tablepre='"+Session["pre"].ToString()+"'");
        whdw.Items.Add(new ListItem("请选择维护单位", "0"));
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            whdw.Items.Add(dr[0].ToString());
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        string sql = "insert into dlysxx(id,whdw,fzr,zgqy,czwt,zgyq,zgsx,pdr,pdsj,pfdw,lxr,lxdh) values(";
        sql+="'" + id.InnerText + "','" + whdw.Text + "','"+fzr.Text+"','" + zgqy.Text + "',";
        sql += "'" + czwt.Text + "','" + zgyq.Text + "','" + zgsx.Text + "','" + pdr.InnerText + "',";
        sql += "'" + pdsj.InnerText + "','" + Session["deptname"].ToString() + "','"+lxr.Text+"','"+lxdh.Text+"');";
       sql += "Update autoid set  " + Pre + "xxid=" + (int.Parse(id.InnerText.Substring(Pre.Length)) + 1);
       DirectDataAccessor.Execute(sql);
       ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('电缆延伸通知书派发成功！');location.href=location.href;", true);


    }
}
