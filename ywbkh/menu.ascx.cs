using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

public partial class ywbkh_menu : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "" || Session["roleid"] == null || Session["roleid"] == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');window.location.href='Default.aspx';</script>");
            else
            {
                string uname = Session["uname"].ToString();
                StringBuilder sb = new StringBuilder("<a href=\"Marks_g.aspx\">贡献度胜任度职业道德考核</a><a href=\"ChangePwd.aspx\">修改密码</a> <a href=\"LogOut.aspx\">退出</a>");
                switch (uname)
                {
                    case "白凌峰":
                        sb.Insert(0, "<a href=\"Marks_a.aspx\">劳动纪律考核</a><a href=\"Marks_f.aspx\">其他加扣分</a>");
                        break;
                    case "李靖":
                        sb.Insert(0, "<a href=\"Marks_b.aspx\">信息报道考核</a>");
                        break;
                    case "董雪娥":
                        sb.Insert(0, "<a href=\"Marks_c.aspx\">基础报表考核</a><a href=\"Marks_d.aspx\">网运指标考核</a>");
                        break;
                    case "李常欣":
                        sb.Insert(0, "<a href=\"Marks_e.aspx\">工作效率考核</a>");
                        break;
                }
                sb.Insert(0, "<a href=\"index.aspx\">考核得分表</a>");
                menu.Text = sb.ToString();
            }

        }
    }
}