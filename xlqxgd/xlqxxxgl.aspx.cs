using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using org.in2bits.MyXls;

public partial class xlqxxxgl : System.Web.UI.Page
{
    /// 判断是否运维部超管
    /// </summary>
    public bool isAdminYW = false;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
                BindMonth();
                Bindqxdw();
                NewsBind();
                //判断是否运维部超管
                isAdminYW = (Session["roleid"].ToString() == "0" && Session["deptname"].ToString() == "网络部") ? true : false;
                //删除
                if (Request.QueryString["action"] == "del")
                {
                    if (Request.QueryString["id"] == null || Request.QueryString["id"].ToString() == "")
                    {
                        Response.Write("参数错误！");
                        Response.End();
                    }
                    else
                    {
                        DirectDataAccessor.Execute("Delete from xlqxxx where id='" + Request.QueryString["id"] + "'");
                        ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('删除成功！'); location.href='xlqxxxgl.aspx';", true);

                    }
                }
            }
        }
    }
    /// <summary>
    /// 绑定日期
    /// </summary>
    private void BindMonth()
    {

        DataSet ds = DirectDataAccessor.QueryForDataSet("select distinct substring(qxrq,0,8) as rq ,DateName(year,qxrq)as yearstr,datename(month,qxrq)as monthstr from xlqxxx ");
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            ddlMonth.Items.Add(new ListItem(dr["yearstr"].ToString() + "年" + dr["monthstr"].ToString() + "月", dr["yearstr"].ToString() + "-" + dr["monthstr"].ToString()));
            ddlMonth1.Items.Add(new ListItem(dr["yearstr"].ToString() + "年" + dr["monthstr"].ToString() + "月", dr["yearstr"].ToString() + "-" + dr["monthstr"].ToString()));
        }
        ddlMonth1.SelectedIndex = ds.Tables[0].Rows.Count - 1;

    }
    /// <summary>
    /// 绑定单位
    /// </summary>
    private void Bindqxdw()
    {
        string sql = "select qxdw from xlqxxx  ";
        if (Session["roleid"] != null && Session["deptname"] != null && (Session["roleid"].ToString() == "1" || Session["roleid"].ToString() == "2"))
            sql += " where qxdw='" + Session["deptname"].ToString() + "'";
        sql += " group by qxdw";
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        ddlqxdw.Items.Add(new ListItem("----全部----", "0"));
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            ddlqxdw.Items.Add(dr[0].ToString());
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
            whereStr += "  substring (qxrq,0,8)>='" + Request.QueryString["qj"].ToString() + "' and";
        }
        else
        {
            ddlMonth.SelectedIndex = ddlMonth.Items.Count - 1;
            whereStr += "  substring (qxrq,0,8)>='" + ddlMonth.Text + "' and";
        }
        if (Request.QueryString["jz"] != null)
        {
            ddlMonth1.Text = Request.QueryString["jz"].ToString();
            whereStr += "  substring (qxrq,0,8)<='" + Request.QueryString["jz"].ToString() + "' and";
        }
        else
        {
            ddlMonth1.SelectedIndex = ddlMonth1.Items.Count - 1;
            whereStr += "  substring (qxrq,0,8)>='" + ddlMonth1.Text + "' and";
        }
        //判断市县派单用户和库管
        if (Session["roleid"] != null && Session["deptname"] != null && (Session["roleid"].ToString() == "1" || Session["roleid"].ToString() == "2"))
        {
            ddlqxdw.Text = Session["deptname"].ToString();
            whereStr += "  qxdw='" + Session["deptname"].ToString() + "' and";
        }
        else
        {
            if (Request.QueryString["dw"] != null)
            {
                ddlqxdw.Text = Request.QueryString["dw"].ToString();
                whereStr += "  qxdw='" + Request.QueryString["dw"].ToString() + "' and";
            }
        }
        //按编号查询
        if (Request.QueryString["qxid"] != null)
        {
            qxid.Text = Request.QueryString["qxid"].ToString();
            whereStr += "  id like '%" + Request.QueryString["qxid"].ToString() + "%' and";
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
        if (Request.QueryString["qxid"] != null)
        {
            condition += "&qxid=" + Request.QueryString["qxid"].ToString();
        }
        DataTable dt = GetDataTable("select * from xlqxxx  ");
        try
        {

            PagedDataSource objPage = new PagedDataSource();
            objPage.DataSource = dt.DefaultView;
            objPage.AllowPaging = true;
            int CurPage, pagesize;
            if (Request.QueryString["Page"] != null)
            {
                CurPage = Convert.ToInt32(Request.QueryString["page"]);
            }
            else
            {
                CurPage = 1;
            }
            if (Request.QueryString["pagesize"] != null)
            {
                pagesize = Convert.ToInt32(Request.QueryString["pagesize"]);
            }
            else
            {
                pagesize = 10;
            }
            objPage.PageSize = pagesize;
            objPage.CurrentPageIndex = CurPage - 1;
            repData.DataSource = objPage;//这里更改控件名称
            repData.DataBind();//这里更改控件名称
            RecordCount.Text = objPage.DataSourceCount.ToString();
            PageCount.Text = objPage.PageCount.ToString();
            Pageindex.Text = CurPage.ToString();
            Literal1.Text = PageList(objPage.PageCount, CurPage, condition,pagesize);

            FirstPage.NavigateUrl = Request.CurrentExecutionFilePath + "?page=1&pagesize=" + pagesize.ToString() + condition;
            PrevPage.NavigateUrl = Request.CurrentExecutionFilePath + "?page=" + (CurPage - 1) + "&pagesize=" + pagesize.ToString() + condition;
            NextPage.NavigateUrl = Request.CurrentExecutionFilePath + "?page=" + (CurPage + 1) + "&pagesize=" + pagesize.ToString() + condition;
            LastPaeg.NavigateUrl = Request.CurrentExecutionFilePath + "?page=" + objPage.PageCount.ToString() + "&pagesize=" + pagesize.ToString() + condition;
            if (CurPage <= 1 && objPage.PageCount <= 1)
            {
                FirstPage.NavigateUrl = "javascript:void(0);";
                PrevPage.NavigateUrl = "javascript:void(0);";
                NextPage.NavigateUrl = "javascript:void(0);";
                LastPaeg.NavigateUrl = "javascript:void(0);";
            }
            if (CurPage <= 1 && objPage.PageCount > 1)
            {
                FirstPage.NavigateUrl = "javascript:void(0);";
                PrevPage.NavigateUrl = "javascript:void(0);";
            }
            if (CurPage >= objPage.PageCount)
            {
                NextPage.NavigateUrl = "javascript:void(0);";
                LastPaeg.NavigateUrl = "javascript:void(0);";
            }
        }
        catch (Exception error)
        {
            Response.Write(error.ToString());
        }

    }
    private string PageList(int Pagecount, int Pageindex, string condition, int pagesieze)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("<select id=\"Page_Jump\" name=\"Page_Jump\" onchange=\"window.location='" + Request.CurrentExecutionFilePath + "?page='+ this.options[this.selectedIndex].value + '&pagesize=" + pagesieze + condition + "';\">");

        for (int i = 1; i <= Pagecount; i++)
        {
            if (Pageindex == i)
                sb.Append("<option value='" + i + "' selected>" + i + "</option>");
            else
                sb.Append("<option value='" + i + "'>" + i + "</option>");
        }
        sb.Append("</select>");
        //分页大小
        sb.Append("页  每页显示<select id=\"Pagesize_Jump\" name=\"Pagesize_Jump\" onchange=\"window.location='" + Request.CurrentExecutionFilePath + "?page=" + Pageindex + "&pagesize='+ this.options[this.selectedIndex].value + '" + condition + "';\">");
        for (int i = 1; i <= 5; i++)
        {
            if (pagesieze == i * 10)
                sb.Append("<option value='" + i * 10 + "' selected>" + i * 10 + "</option>");
            else
                sb.Append("<option value='" + i * 10 + "'>" + i * 10 + "</option>");
        }
        sb.Append("</select>条记录");
        return sb.ToString();
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string condition = "";
        if (ddlMonth.Text != "0")
            condition += "&qj=" + ddlMonth.Text;
        if (ddlMonth1.Text != "0")
            condition += "&jz=" + ddlMonth1.Text;
        if (ddlqxdw.Text != "0")
            condition += "&dw=" + ddlqxdw.Text;
        if (qxid.Text != "")
            condition += "&qxid=" + qxid.Text;
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

        outputFileName += "线路抢修信息明细表.xls";
        DataTable dt = GetDataTable("select id,qxrq,qxdd,qxdw,bgarq,bbxgsrq,bxgscxc,qxss,ssje,hfsj from xlqxxx  ");

        dt.Columns[0].ColumnName = "序号";
        dt.Columns[1].ColumnName = "抢修日期";
        dt.Columns[2].ColumnName = "抢修地点";
        dt.Columns[3].ColumnName = "抢修单位";
        dt.Columns[4].ColumnName = "报公安日期";
        dt.Columns[5].ColumnName = "报保险公司日期";
        dt.Columns[6].ColumnName = "保险公司是否出现场";
        dt.Columns[7].ColumnName = "抢修损失";
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
    /// <param name="id">抢修id</param>
    /// <param name="qxll">抢修领料</param>
    /// <returns></returns>
    public string handleLL(string id, string qxll)
    {
        string str = "";
        if (qxll == "1")//已领料
            str = "<a class='gray'   href=\"xlqxllxxxq.aspx?qxid=" + id + "\" target=\"_blank\" title='点击查看领料信息'>已领料</a>";
        else //未领料
        {
            if (Session["roleid"] != null && Session["roleid"].ToString() == "2")//是库管
                str = "<a class='b_blue' href=\"xlqxxxlllr.aspx?id=" + id + "\" title='点击录入领料信息'>未领料</a>";
            else //非库管
                str = "<span class='b_blue'>未领料</a>";
        }
        return str;
    }
    /// <summary>
    /// 处理退料信息
    /// </summary>
    /// <param name="id">抢修id</param>
    /// <param name="qxtl">抢修退料</param>
    /// <param name="qxll">抢修领料</param>
    /// <returns></returns>
    public string handleTL(string id, string qxtl,string qxll)
    {
        string str = "";
        if (qxtl == "1")//已退料
            str = "<a class='gray'   href=\"xlqxtlxxxq.aspx?id=" + id + "\"  title='点击查看退料信息'>已退料</a>";
        else //未退料
        {
            if (Session["roleid"] != null && Session["roleid"].ToString() == "2")//是库管
            {
                if (qxll == "0")//未领料
                str = "<a class='b_lightblue'<a href=\"javascript:alert('该抢修工单未领料，不能退料！');\">未退料</a>";
                else //已领料
                    str = "<a class='b_lightblue' href=\"xlqxxxtllr.aspx?id=" + id + "\" title='点击录入退料信息'>未退料</a>";
            }
            else //非库管
                str = "<span class='b_lightblue'>未退料</a>";
        }
        return str;
    }
    /// <summary>
    /// 处理整改完结
    /// </summary>
    /// <param name="id">编号</param>
    /// <param name="hfsj">恢复时间</param>
    /// <param name="qxtl">抢修退料</param>
    /// <returns></returns>
    public string handleWj(string id, string hfsj, string qxtl)
    {
        string str = "";
        if (hfsj != "")//已恢复
            str = "<a class='gray'   href=\"xlqxxxxq.aspx?qxid=" + id + "\"  title='点击查看详情'>已完结</a>";
        else
        {
            if (Session["roleid"] != null && Session["roleid"].ToString() == "1")//是派单人
            {
                if (qxtl == "0")//未退料
                    str = "<a href=\"javascript:alert('该抢修工单未退料，不能完结！');\" class='b_red'>未完结</a> ";
                else //已退料
                    str = "<a class='b_red' href=\"xlqxxxwj.aspx?qxid=" + id + "\" title='点击设置工单完结'>未完结</a>";
            }
            else //非派单人
                str = "<span class='b_red'>未完结</a>";
        }
        return str;
    }
}