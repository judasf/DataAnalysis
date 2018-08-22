using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class ywbkh_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void ImageButton1_Click(object sender, ImageClickEventArgs e)
    {
        if (username.Value == "" && password.Value == "")
            ClientScript.RegisterStartupScript(this.GetType(), "Error", "alert('用户名或密码错误,请重新输入!')", true);
        else
        {
            DataSet ds = DirectDataAccessor.QueryForDataSet("SELECT * FROM ywbkh_userinfo  WHERE username='" +  username.Value.Trim() + "' and passwd = '" + password.Value.Trim() + "'");
            if (ds.Tables[0].Rows.Count > 0)
            {
                Session["uname"] = ds.Tables[0].Rows[0][1];
                Session["roleid"] = ds.Tables[0].Rows[0][3];
                Response.Redirect("index.aspx");
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "Error", "alert('用户名或密码错误,请重新输入!')", true);
            }
        }
    }
}