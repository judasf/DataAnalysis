using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;

public partial class yhgl : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
                //判断权限,超管管理所有用户，外包管理各自外包区域，公众领导管理自己的派单人，库管和线管、报账员
                if (Session["roleid"] == null || (Session["roleid"].ToString() != "0" && Session["roleid"].ToString() != "3" && Session["roleid"].ToString() != "5"))
                    Response.Write("<script type='text/javascript'>alert('您没有相应的权限，请重新登陆！');top.location.href='../';</script>");
                BindDept();
                BindRole();
                BindRepeater();
            }
        }
    }
    /// <summary>
    /// 绑定单位
    /// </summary>
    private void BindDept()
    {
            string sql = "select * from deptinfo";
            if (Session["roleid"] != null && Session["roleid"].ToString() != "0")
                sql += " where  deptname='"+Session["deptname"].ToString()+"' ";

            DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
            ddlDept.Items.Add(new ListItem("选择单位", "0"));
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                ddlDept.Items.Add(new ListItem(dr[1].ToString()));
            }
    

    }
    /// <summary>
    /// 绑定岗位
    /// </summary>
    private void BindRole()
    {

        string sql = "select * from roleinfo";
        if (Session["roleid"] != null && Session["roleid"].ToString() == "0")
            sql += " where roleid<>0  ";
        if (Session["roleid"] != null && Session["roleid"].ToString() == "3")
            sql += " where roleid=7  ";
        if (Session["roleid"] != null && Session["roleid"].ToString() == "5")
            sql += " where roleid=1 or roleid=2 or roleid=6 or roleid=8 ";
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        ddlRole.Items.Add(new ListItem("选择岗位", "100"));
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            ddlRole.Items.Add(new ListItem(dr[2].ToString(), dr[1].ToString()));
        }


    }
    /// <summary>
    /// 绑定repeater
    /// </summary>
    private void BindRepeater()
    {
        string condition = "";
        string sql = "select a.*,b.rolename,row_number() over (order by uid) as rowid from userinfo a join roleinfo  b on  a.roleid=b.roleid";
        if (Session["roleid"] != null && Session["roleid"].ToString() == "0")
            sql += " where uid<>1 ";
        if (Session["roleid"] != null && Session["roleid"].ToString() == "3")
            sql += " where a.roleid<>3 and a.deptname='" + Session["deptname"] + "' ";
        if (Session["roleid"] != null && Session["roleid"].ToString() == "5")
            sql += " where a.roleid<>5 and a.deptname='" + Session["deptname"] + "' ";
        if (Request.QueryString["username"] != null)
        {
            username.Text = Server.UrlDecode(Request.QueryString["username"].ToString());
            sql += "  and  uname like '%" + Server.UrlDecode(Request.QueryString["username"].ToString()) + "%' ";
            condition += "&username=" + Server.UrlEncode(Request.QueryString["username"].ToString());
        }
        sql += " order by a.uid desc";
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        try
        {

            PagedDataSource objPage = new PagedDataSource();
            objPage.DataSource = ds.Tables[0].DefaultView;
            objPage.AllowPaging = true;
            objPage.PageSize = 10;
            int CurPage;
            if (Request.QueryString["Page"] != null)
            {
                CurPage = Convert.ToInt32(Request.QueryString["page"]);
            }
            else
            {
                CurPage = 1;
            }
            objPage.CurrentPageIndex = CurPage - 1;
            repData.DataSource = objPage;//这里更改控件名称
            repData.DataBind();//这里更改控件名称
            RecordCount.Text = objPage.DataSourceCount.ToString();
            PageCount.Text = objPage.PageCount.ToString();
            Pageindex.Text = CurPage.ToString();
            Literal1.Text = PageList(objPage.PageCount, CurPage, condition);

            FirstPage.NavigateUrl = Request.CurrentExecutionFilePath + "?page=1" + condition;
            PrevPage.NavigateUrl = Request.CurrentExecutionFilePath + "?page=" + (CurPage - 1) + condition;
            NextPage.NavigateUrl = Request.CurrentExecutionFilePath + "?page=" + (CurPage + 1) + condition;
            LastPaeg.NavigateUrl = Request.CurrentExecutionFilePath + "?page=" + objPage.PageCount.ToString() + condition;
            if (CurPage <= 1 && objPage.PageCount <= 1)
            {
                FirstPage.NavigateUrl = "";
                PrevPage.NavigateUrl = "";
                NextPage.NavigateUrl = "";
                LastPaeg.NavigateUrl = "";
            }
            if (CurPage <= 1 && objPage.PageCount > 1)
            {
                FirstPage.NavigateUrl = "";
                PrevPage.NavigateUrl = "";
            }
            if (CurPage >= objPage.PageCount)
            {
                NextPage.NavigateUrl = "";
                LastPaeg.NavigateUrl = "";
            }
        }
        catch (Exception error)
        {
            Response.Write(error.ToString());
        }

    }
    private string PageList(int Pagecount, int Pageindex, string condition)//private string Jump_List(int Pagecount , int Pageindex , long L_Manage)//带参数的传递
    {
        StringBuilder sb = new StringBuilder();
        //下为带参数的传递
        //sb.Append("<select id=\"Page_Jump\" name=\"Page_Jump\" onchange=\"window.location='" + Request.CurrentExecutionFilePath + "?page='+ this.options[this.selectedIndex].value + '&Org_ID=" + L_Manage + "';\">");
        //不带参数的传递
        sb.Append("<select id=\"Page_Jump\" name=\"Page_Jump\" onchange=\"window.location='" + Request.CurrentExecutionFilePath + "?page='+ this.options[this.selectedIndex].value + '" + condition + "';\">");

        for (int i = 1; i <= Pagecount; i++)
        {
            if (Pageindex == i)
                sb.Append("<option value='" + i + "' selected>" + i + "</option>");
            else
                sb.Append("<option value='" + i + "'>" + i + "</option>");
        }
        sb.Append("</select>");
        return sb.ToString();
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        string sql = "INSERT INTO userinfo  VALUES('" +uname.Text + "','ayltyw.0','" + ddlDept.SelectedItem.Text + "','" + ddlRole.Text + "','"+pre.Text+"',1)";
        DirectDataAccessor.Execute(sql);
        ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('用户添加成功！');location.href=location.href;", true);

    }
    protected void ddlDept_SelectedIndexChanged(object sender, EventArgs e)
    {
        DataSet ds = DirectDataAccessor.QueryForDataSet("select pre from deptinfo where deptname='" + ddlDept.Text + "'");
        pre.Text = ds.Tables[0].Rows[0][0].ToString();
    }
    protected void repData_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "btnRecover")
        {
            DirectDataAccessor.Execute("update userinfo set passwd='ayltyw.0' where uid='" + e.CommandArgument.ToString() + "'");
            ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('密码恢复成功！');location.href=location.href;", true);

        }
        if (e.CommandName == "btnDel")
        {
            DirectDataAccessor.Execute("delete userinfo where uid='" + e.CommandArgument.ToString() + "'");
            ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('用户删除成功！');location.href=location.href;", true);

        }
        if (e.CommandName == "btnStatus")
        {
            string[] arr = e.CommandArgument.ToString().Split(',');
            string sql = "update userinfo set status=" + (arr[1] == "1" ? "0" : "1") + " where uid='" + arr[0] + "'";
            DirectDataAccessor.Execute(sql);
            ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('用户" + (arr[1] == "1" ? "停用" : "启用") + "成功！');location.href=location.href;", true);
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string condition = "";
        if (username.Text != "")
            condition += "&username=" + Server.UrlEncode(username.Text);
        ClientScript.RegisterStartupScript(this.GetType(), "redirect", "window.location='" + Request.CurrentExecutionFilePath + "?page=1" + condition + "'", true);

    }
}
