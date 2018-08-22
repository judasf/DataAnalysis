using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using org.in2bits.MyXls;

public partial class gzbb_wbzbgl : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
                BindMonth();
                BindBddw();
                NewsBind();
            }
        }
    }
    /// <summary>
    /// 绑定日期
    /// </summary>
    private void BindMonth()
    {

        DataSet ds = DirectDataAccessor.QueryForDataSet("select distinct substring(uptime,0,8) as rq ,DateName(year,uptime)as yearstr,datename(month,uptime)as monthstr from upfilelist ");
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            ddlMonth.Items.Add(new ListItem(dr["yearstr"].ToString() + "年" + dr["monthstr"].ToString() + "月", dr["yearstr"].ToString() + "-" + dr["monthstr"].ToString()));
            ddlMonth1.Items.Add(new ListItem(dr["yearstr"].ToString() + "年" + dr["monthstr"].ToString() + "月", dr["yearstr"].ToString() + "-" + dr["monthstr"].ToString()));
        }
    }
    /// <summary>
    /// 绑定单位
    /// </summary>
    private void BindBddw()
    {
        string sql = "select userdept from upfilelist  ";
        sql += " group by userdept";
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        ddlscdw.Items.Add(new ListItem("----全部----", "0"));
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            ddlscdw.Items.Add(dr[0].ToString());
        }
    }
    /// <summary>
    /// 获取DataTable
    /// </summary>
    /// <returns></returns>
    private DataTable GetDataTable(string sqlStr)
    {

        string whereStr = "where";
        if (Request.QueryString["qj"] != null)
        {
            ddlMonth.Text = Request.QueryString["qj"].ToString();
            whereStr += "  substring (uptime,0,8)>='" + Request.QueryString["qj"].ToString() + "' and";
        }
        else
        {
            ddlMonth.Text = DateTime.Now.ToString("yyyy-MM");
            whereStr += "  substring (uptime,0,8)>='" + ddlMonth.Text + "' and";
        }
        if (Request.QueryString["jz"] != null)
        {
            ddlMonth1.Text = Request.QueryString["jz"].ToString();
            whereStr += "  substring (uptime,0,8)<='" + Request.QueryString["jz"].ToString() + "' and";
        }
        else
        {
            ddlMonth1.Text = DateTime.Now.ToString("yyyy-MM");
            whereStr += "  substring (uptime,0,8)>='" + ddlMonth1.Text + "' and";
        }
            if (Request.QueryString["dw"] != null)
            {
                ddlscdw.Text = Request.QueryString["dw"].ToString();
                whereStr += "  userdept='" + Request.QueryString["dw"].ToString() + "' and";
            }
        if (whereStr != "where")
        {
            whereStr = whereStr.Substring(0, whereStr.Length - 3);
            sqlStr += whereStr;
        }
        sqlStr += " order by id desc";
        DataSet ds = DirectDataAccessor.QueryForDataSet(sqlStr);
        return ds.Tables[0];
    }
    /// <summary>
    /// repeater分页并绑定
    /// </summary>
    private void NewsBind()
    {
        string condition = "";
        if (Request.QueryString["qj"] != null)
        {
            condition += "&qj=" + Request.QueryString["qj"].ToString();
        }
        if (Request.QueryString["jz"] != null)
        {
            condition += "&jz=" + Request.QueryString["jz"].ToString();
        }
        if (Request.QueryString["dw"] != null)
        {
            condition += "&dw=" + Request.QueryString["dw"].ToString();
        }
        DataTable dt = GetDataTable("select * from upfilelist  ");
        try
        {

            PagedDataSource objPage = new PagedDataSource();
            objPage.DataSource = dt.DefaultView;
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
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string condition = "";
        if (ddlMonth.Text != "0")
            condition += "&qj=" + ddlMonth.Text;
        if (ddlMonth1.Text != "0")
            condition += "&jz=" + ddlMonth1.Text;
        if (ddlscdw.Text != "0")
            condition += "&dw=" + ddlscdw.Text;
        ClientScript.RegisterStartupScript(this.GetType(), "redirect", "window.location='" + Request.CurrentExecutionFilePath + "?page=1" + condition + "'", true);

    }
    protected void btnExportExcel_Click(object sender, EventArgs e)
    {
        string outputFileName = "";
        if (Request.QueryString["qj"] != null)
        {
            outputFileName += Request.QueryString["qj"].ToString() + "-";
        }
        if (Request.QueryString["jz"] != null)
        {
            outputFileName += Request.QueryString["jz"].ToString() + "-";
        }
        if (Request.QueryString["dw"] != null)
        {
            outputFileName += Request.QueryString["dw"].ToString();
        }

        outputFileName += "线路被盗信息明细表.xls";
        DataTable dt = GetDataTable("select id,bdrq,bddd,bddw,bgarq,bbxgsrq,bxgscxc,bdss,ssje,hfsj from xlbdxx  ");

        dt.Columns[0].ColumnName = "序号";
        dt.Columns[1].ColumnName = "被盗日期";
        dt.Columns[2].ColumnName = "被盗地点";
        dt.Columns[3].ColumnName = "被盗单位";
        dt.Columns[4].ColumnName = "报公安日期";
        dt.Columns[5].ColumnName = "报保险公司日期";
        dt.Columns[6].ColumnName = "保险公司是否出现场";
        dt.Columns[7].ColumnName = "被盗损失";
        dt.Columns[8].ColumnName = "损失金额";
        dt.Columns[9].ColumnName = "恢复时间";
        xlsGridview(dt, outputFileName);
    }
    /// <summary>
    /// 绑定数据库生成XLS报表
    /// </summary>
    /// <param name="ds">获取DataSet数据集</param>
    /// <param name="xlsName">报表表名</param>
    private void xlsGridview(DataTable dt, string xlsName)
    {
        XlsDocument xls = new XlsDocument();
        xls.FileName = Server.UrlEncode(xlsName);
        int rowIndex = 1;
        int colIndex = 0;
        Worksheet sheet = xls.Workbook.Worksheets.Add("sheet");//状态栏标题名称
        //设置样式
        XF xf = xls.NewXF();
        xf.HorizontalAlignment = HorizontalAlignments.Centered;
        xf.VerticalAlignment = VerticalAlignments.Centered;
        xf.TextWrapRight = true;
        xf.UseBorder = true;
        xf.TopLineStyle = 1;
        xf.TopLineColor = Colors.Black;
        xf.BottomLineStyle = 1;
        xf.BottomLineColor = Colors.Black;
        xf.LeftLineStyle = 1;
        xf.LeftLineColor = Colors.Black;
        xf.RightLineStyle = 1;
        xf.RightLineColor = Colors.Black;
        xf.Font.Bold = true;
        Cells cells = sheet.Cells;
        foreach (DataColumn col in dt.Columns)
        {
            colIndex++;
            Cell cell = cells.Add(1, colIndex, col.ColumnName, xf);
        }

        foreach (DataRow row in dt.Rows)
        {
            rowIndex++;
            colIndex = 0;
            foreach (DataColumn col in dt.Columns)
            {
                colIndex++;
                Cell cell = cells.Add(rowIndex, colIndex, row[col.ColumnName].ToString(), xf);//转换为数字型
                //如果你数据库里的数据都是数字的话 最好转换一下，不然导入到Excel里是以字符串形式显示。
                cell.Font.FontFamily = FontFamilies.Roman; //字体
                cell.Font.Bold = false;  //字体为粗体            
            }
        }
        xls.Send();
        Response.Flush();
        Response.End();
    }
    /// <summary>
    /// 处理领料信息
    /// </summary>
    /// <param name="id">被盗id</param>
    /// <param name="bdll">被盗领料</param>
    /// <returns></returns>
    public string handleLL(string id, string bdll)
    {
        string str = "";
        if (bdll == "1")//已领料
            str = "<a class='gray'   href=\"xlbdllxxxq.aspx?bdid=" + id + "\" target=\"_blank\" title='点击查看领料信息'>已领料</a>";
        else //未领料
        {
            if (Session["roleid"] != null && Session["roleid"].ToString() == "2")//是库管
                str = "<a class='b_blue' href=\"xlbdxxlllr.aspx?id=" + id + "\" title='点击录入领料信息'>未领料</a>";
            else //非库管
                str = "<span class='b_blue'>未领料</a>";
        }
        return str;
    }
    /// <summary>
    /// 处理整改完结
    /// </summary>
    /// <param name="id">编号</param>
    /// <param name="hfsj">回复时间</param>
    /// <param name="bdll">被盗领料</param>
    /// <returns></returns>
    public string handleWj(string id, string hfsj, string bdll)
    {
        string str = "";
        if (hfsj != "")//已回复
            str = "<a class='gray'   href=\"xlbdxxxq.aspx?bdid=" + id + "\"  title='点击查看详情'>已完结</a>";
        else
        {
            if (Session["roleid"] != null && Session["roleid"].ToString() == "1")//是派单人
            {
                if (bdll == "0")//未领料
                    str = "<a href=\"javascript:alert('该被盗工单未领料，不能完结！');\" class='b_red'>未完结</a> ";
                else //已领料
                    str = "<a class='b_red' href=\"xlbdxxwj.aspx?bdid=" + id + "\" title='点击设置工单完结'>未完结</a>";
            }
            else //非派单人
                str = "<span class='b_red'>未完结</a>";
        }
        return str;
    }
}