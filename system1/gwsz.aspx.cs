using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;

public partial class gwsz : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
                //判断权限,超管可管理岗位
                if (Session["roleid"] == null || (Session["roleid"].ToString() != "0"&&Session["roleid"].ToString()!="3" &&Session["roleid"].ToString() != "5"))
                    Response.Write("<script type='text/javascript'>alert('您没有相应的权限，请重新登陆！');top.location.href='../';</script>");
                BindRepeater();
            }
        }
    }
  
    /// <summary>
    /// 绑定repeater
    /// </summary>
    private void BindRepeater()
    {
        string sql = "select * from roleinfo";
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
            repData.DataSource = ds;
            repData.DataBind();
    }

   
}
