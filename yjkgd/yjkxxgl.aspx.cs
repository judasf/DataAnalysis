using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using org.in2bits.MyXls;

public partial class yjkxxgl : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
                Binddw();
                BindMonth();
                NewsBind();
            }
        }
    }
   
    /// <summary>
    /// 绑定单位
    /// </summary>
    private void Binddw()
    {
        string sql = "select jsdw from yjkxx  ";
        //检查角色：1：派单员，2：库管
        if (Session["roleid"] != null && Session["deptname"] != null && Session["roleid"].ToString() == "2" && Session["pre"].ToString() != "")
            sql += " where jsdw='" + Session["deptname"].ToString() + "'";
        sql += " group by jsdw";

        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        ddljsdw.Items.Add(new ListItem("------全部------", "0"));
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            ddljsdw.Items.Add(dr[0].ToString());
        }
    }
    /// <summary>
    /// 绑定日期
    /// </summary>
    private void BindMonth()
    {

        ddlMonth.Text = ddlMonth.Text == "" ? DateTime.Now.AddMonths(-1).ToString("yyyy-MM") : ddlMonth.Text;
        ddlMonth1.Text = ddlMonth1.Text == "" ? DateTime.Now.ToString("yyyy-MM") : ddlMonth1.Text;
    }
    
    /// <summary>
    /// 获取DataTable
    /// </summary>
    /// <returns></returns>
    private DataTable GetDataTable(string sqlStr)
    {

        string whereStr = "where ";
        if (Request.QueryString["qj"] != null)
        {
            ddlMonth.Text = Request.QueryString["qj"].ToString();
            whereStr += "  substring (pdsj,0,8)>='" + Request.QueryString["qj"].ToString() + "' and";
        }
        else
        {
            whereStr += "  substring (pdsj,0,8)>='" + DateTime.Now.AddMonths(-1).ToString("yyyy-MM") + "' and";
        }
        if (Request.QueryString["jz"] != null)
        {
            ddlMonth1.Text = Request.QueryString["jz"].ToString();
            whereStr += "  substring (pdsj,0,8)<='" + Request.QueryString["jz"].ToString() + "' and";
        }
        else
        {
            whereStr += "  substring (pdsj,0,8)<='" + DateTime.Now.ToString("yyyy-MM") + "' and";
        }

        //判断市县派单用户和库管，线管
        if (Session["roleid"] != null && Session["deptname"] != null && Session["roleid"].ToString() == "2" && Session["pre"].ToString() != "")
        {
            ddljsdw.Text = Session["deptname"].ToString();
            whereStr += "  jsdw='" + Session["deptname"].ToString() + "' and";
        }
        else
        {
            if (Request.QueryString["dw"] != null)
            {
                ddljsdw.Text = Server.UrlDecode(Request.QueryString["dw"].ToString());
                whereStr += "  jsdw='" + Server.UrlDecode(Request.QueryString["dw"].ToString()) + "' and";
            }
        }
       
     
        //编号
        if (Request.QueryString["id"] != null)
        {
            id.Text = Request.QueryString["id"].ToString();
            whereStr += "  id like '%" + Request.QueryString["id"].ToString() + "%' and";
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
            condition += "&dw=" + Server.UrlEncode(Request.QueryString["dw"].ToString());
        }
       
        if (Request.QueryString["id"] != null)
        {
            condition += "&id=" + Request.QueryString["id"].ToString();
        }
        DataTable dt = GetDataTable("select * from yjkxx  ");
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
            Literal1.Text = PageList(objPage.PageCount, CurPage, condition, pagesize);

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
    private string PageList(int Pagecount, int Pageindex, string condition,int pagesieze)
    {
        StringBuilder sb = new StringBuilder();
        //不带参数的传递
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
    
        if (ddljsdw.Text != "0")
            condition += "&dw=" + Server.UrlEncode(ddljsdw.Text); 
        if (id.Text != "")
            condition += "&id=" + id.Text;
        ClientScript.RegisterStartupScript(this.GetType(), "redirect", "window.location='" + Request.CurrentExecutionFilePath + "?page=1" + condition + "'", true);

    }
    protected void btnExportExcel_Click(object sender, EventArgs e)
    {
        string outputFileName = "";
        if (Request.QueryString["qj"] != null)
        {
            outputFileName += Request.QueryString["qj"].ToString()+"-";
        }
        if (Request.QueryString["jz"] != null)
        {
            outputFileName += Request.QueryString["jz"].ToString() + "-";
        }
    
        outputFileName += "应急库信息表.xls";
        DataTable dt = GetDataTable("select id,pdsj,pdr,jsdw,jsr,jssj,bz from yjkxx ");

        dt.Columns[0].ColumnName = "序号";
        dt.Columns[1].ColumnName = "派单时间";
        dt.Columns[2].ColumnName = "派单人";
        dt.Columns[3].ColumnName = "接收单位";
        dt.Columns[4].ColumnName = "接收人";
        dt.Columns[5].ColumnName = "接收时间";
        dt.Columns[6].ColumnName = "备注";
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
        //设置列格式
        ColumnInfo colInfo = new ColumnInfo(xls, sheet);
        colInfo.ColumnIndexStart = 0;
        colInfo.ColumnIndexEnd = 8;
        colInfo.Width = 20 * 256;
        sheet.AddColumnInfo(colInfo);
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
            Cell cell = cells.Add(1, colIndex, col.ColumnName,xf);
            cell.Font.Bold = true;
        }

        foreach (DataRow row in dt.Rows)
        {
            rowIndex++;
            colIndex = 0;
            foreach (DataColumn col in dt.Columns)
            {
                colIndex++;
                Cell cell = cells.Add(rowIndex, colIndex, row[col.ColumnName].ToString(),xf);//转换为数字型
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
    /// 处理派单接收
    /// </summary>
    /// <param name="id">应急库id</param>
    /// <param name="jsr">接收人</param>
    /// /// <param name="jsdw">接收单位</param>
    /// <returns></returns>
    public string handleJS(string id, string jsr, string jsdw)
    {
        string str = "";
        if (jsr != "")//已接收
            str = "<a class='gray'   href=\"yjkllxxxq.aspx?id=" + id + "\" target=\"_blank\" title='点击查看领料信息'>已接收</a>";
        else //未接收
        {
            //角色判断，2：库管
            if (Session["roleid"] != null && Session["roleid"].ToString() == "2" && Session["deptname"] != null && Session["deptname"].ToString() ==jsdw)
            {
                str = "<a class='b_blue' href=\"yjkxxllqr.aspx?id=" + id + "\" title='点击接收领料信息'>未接收</a>";
            }
            else //非区域维护
                str = "<span class='b_blue'>未接收</a>";
        }

        return str;
    }
}