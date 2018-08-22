using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;

public partial class yjylkclbgl : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
                //判断权限,库管2和南水北调库管11可录入库存
                if (Session["roleid"] == null || (Session["roleid"].ToString() != "2" && Session["roleid"].ToString() != "11"))
                    Response.Write("<script type='text/javascript'>alert('您没有相应的权限，请重新登陆！');top.location.href='../';</script>");
                BindClass();
                BindRepeater();
            }
        }
    }
    /// <summary>
    /// 绑定类别
    /// </summary>
    private void BindClass()
    {
        string sql = "select *  from "+Session["pre"]+"yjylkc_Class ";
        //判断权限：2：库管不能看南水北调；11：南水北调库管只操作南水北调
        if (Session["roleid"] != null)
        {
            switch (Session["roleid"].ToString())
            {
                case "2":
                    sql += "  where classname<>'南水北调'";
                    break;
                case "11":
                    sql += " where classname='南水北调'";
                    break;
            }
        }
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        ddlClass.Items.Add(new ListItem("选择类别", "0"));
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            ddlClass.Items.Add(new ListItem(dr[1].ToString(), dr[0].ToString()));
        }
    }
    /// <summary>
    /// 绑定repeater
    /// </summary>
    private void BindRepeater()
    {
        string condition = "";
        string sql = "select a.typeid,b.classname, row_number() over ( order by a.typeid desc ) as rowid,a.typename,a.units from " + Session["pre"] + "yjylkc_Type  a join " + Session["pre"] + "yjylkc_Class b  on a.classid=b.classid ";
        //判断权限：2：库管不能看南水北调；11：南水北调库管只操作南水北调
        if (Session["roleid"] != null)
        {
            switch (Session["roleid"].ToString())
            {
                case "2":
                    sql += "  and b.classname<>'南水北调'";
                    break;
                case "11":
                    sql += " and b.classname='南水北调'";
                    break;
            }
        }
        sql += " order by a.typeid desc";
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
        string sql = "INSERT INTO " + Session["pre"] + "yjylkc_Type(classid,typename,units) VALUES('" + ddlClass.SelectedValue + "','" + txtType.Text + "','" + txtUnits.Text + "')";
        DirectDataAccessor.Execute(sql);
        ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('型号添加成功！');location.href=location.href;", true);

    }
    protected void repData_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "btnDel")
        {
           string[] args=e.CommandArgument.ToString().Split('$');
           string sql="select isnull(sum(amount),0)  from " + Session["pre"].ToString() + "yjylkc_kcmx where ";
            sql +="classname='"+args[0]+"' and typename='"+args[1]+"' ";
           DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
           if (ds.Tables[0].Rows[0][0].ToString() != "0")
               ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('该型号下还有库存，不能删除！');", true);
           else
           {
               DirectDataAccessor.Execute("delete from " + Session["pre"] + "yjylkc_Type where typeid='"+args[2]+"'");
               ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('该型号删除成功！');location.href=location.href;", true);
           }
        }
    }
}
