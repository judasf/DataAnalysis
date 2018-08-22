using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class logout : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Session.Abandon();
        Session.Clear();
        Response.Cookies["_token"].Expires = DateTime.Now.AddDays(-1);
        Response.Write("<script type='text/javascript'>top.location.href='./';</script>");
    }
}
