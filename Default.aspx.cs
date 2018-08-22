using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Security;
public partial class Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void btn_login_Click(object sender, ImageClickEventArgs e)
    {
        if (name.Value == "" && pwd.Value == "")
            ClientScript.RegisterStartupScript(this.GetType(), "Error", "alert('用户名或密码错误,请重新输入!')", true);
        else
        {
            string sql = "SELECT * FROM userinfo  WHERE uname=@uname  and passwd = @passwd and status=1";
            SqlParameter[] paras = new SqlParameter[] { new SqlParameter("@uname", name.Value), new SqlParameter("@passwd", FormsAuthentication.HashPasswordForStoringInConfigFile(pwd.Value,"MD5").ToLower()) };
            DataSet ds = DirectDataAccessor.QueryForDataSet(sql, paras);
            //DataSet ds = DirectDataAccessor.QueryForDataSet("SELECT * FROM userinfo  WHERE uname='" + name.Value + "' and passwd = '" + pwd.Value + "'");
            if (ds.Tables[0].Rows.Count > 0)
            {
                Session["uname"] = ds.Tables[0].Rows[0][1];
                Session["uid"] = ds.Tables[0].Rows[0][0];
                Session["deptname"] = ds.Tables[0].Rows[0][3];
                Session["roleid"] = ds.Tables[0].Rows[0][4];
                Session["pre"] = ds.Tables[0].Rows[0][5];
                //生成CSRFToken
                string _csrfToken =FormsAuthentication.HashPasswordForStoringInConfigFile(ds.Tables[0].Rows[0][1].ToString() + ds.Tables[0].Rows[0][2].ToString(), "MD5").ToLower();
                HttpCookie cookie = new HttpCookie("_token", _csrfToken);
                //cookie.HttpOnly = true;
                Response.Cookies["_token"].Expires = DateTime.Now.AddMinutes(90);
                // 5. 写登录Cookie
                Response.Cookies.Remove(cookie.Name);
                Response.Cookies.Add(cookie);
                Session["_token"] = _csrfToken;
                if (ds.Tables[0].Rows[0][4].ToString() == "14")//装维片区
                {
                    DataSet ds14 = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, "SELECT a.AreaID,b.AreaName FROM KHJR_UnitUserInfo AS a JOIN dbo.KHJR_UnitArea AS b ON  a.AreaID=b.ID  where a.uid =" + ds.Tables[0].Rows[0][0].ToString());
                    if (ds14.Tables[0].Rows.Count == 1)
                    {
                        Session["areaid"] = ds14.Tables[0].Rows[0][0].ToString();
                        Session["areaname"] = ds14.Tables[0].Rows[0][1].ToString();
                    }
                }
                if (ds.Tables[0].Rows[0][4].ToString() == "32")//营业部/支局
                {
                    DataSet ds14 = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, "SELECT a.AreaID,b.AreaName FROM CustomAccess_UnitUserInfo AS a JOIN dbo.CustomAccess_UnitArea AS b ON  a.AreaID=b.ID  where a.uid =" + ds.Tables[0].Rows[0][0].ToString());
                    if (ds14.Tables[0].Rows.Count == 1)
                    {
                        Session["areaid"] = ds14.Tables[0].Rows[0][0].ToString();
                        Session["areaname"] = ds14.Tables[0].Rows[0][1].ToString();
                    }
                }
                Response.Redirect("index.aspx");
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "Error", "alert('用户名、密码错误或该账号已停用,请重新输入!')", true);
            }
        }
    }
}
