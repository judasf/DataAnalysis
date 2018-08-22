using System;
using System.Web.Security;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Text.RegularExpressions;

public partial class changepwd : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='./';</script>");
            else
                uname.InnerText = Session["uname"].ToString();
        }
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        //创建正则表达式，验证密码强度
        string pattern = @"^(([A-Z]*|[a-z]*|\d*|[-_\~!@#\$%\^&\*\.\(\)\[\]\{\}<>\?\\\/\'\""]*)|.{0,7})$|\s";
        Regex reg = new Regex(pattern);
        if (reg.IsMatch(txtRenew.Text))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('新密码必须包含字母、数字和符号！！')", true);

        }
        else
        {
            string sql = "select * from userinfo where uname=@uname and passwd=@oldpasswd";
            SqlParameter[] paras = new SqlParameter[] { new SqlParameter("@uname", uname.InnerText), new SqlParameter("@oldpasswd", FormsAuthentication.HashPasswordForStoringInConfigFile(txtOld.Text, "MD5").ToLower()), new SqlParameter("@newpasswd", FormsAuthentication.HashPasswordForStoringInConfigFile(txtRenew.Text, "MD5").ToLower()) };
            DataSet ds = DirectDataAccessor.QueryForDataSet(sql, paras);
            if (ds.Tables[0].Rows.Count > 0)
            {
                string UpdateSql = "update userinfo set passwd=@newpasswd where uname=@uname";
                SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, UpdateSql, paras);
                ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('密码修改成功！')", true);
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "Error", "alert('旧密码错误，请重新输入！')", true);
            }
        }
    }
    protected void Button2_Click(object sender, EventArgs e)
    {
        Response.Redirect("right.aspx");
    }
}
