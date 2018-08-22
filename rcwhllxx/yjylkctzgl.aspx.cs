using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using org.in2bits.MyXls;

public partial class yjylkctzgl : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
                BindClass();
                Binddw();
                BindMonth();
                NewsBind();
            }
        }
    }
    /// <summary>
    /// 绑定类别
    /// </summary>
    private void BindClass()
    {

        DataSet ds = DirectDataAccessor.QueryForDataSet("select *  from " + Session["pre"] + "yjylkc_Class  where classid<8");
        ddlClass.Items.Add(new ListItem("---全部---", "0"));
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            ddlClass.Items.Add(new ListItem(dr[1].ToString()));
        }
    }
    /// <summary>
    /// 绑定单位
    /// </summary>
    private void Binddw()
    {
        string sql = "select ckdw from yjylkc_llmx ";
        //检查角色：1：派单员，2：库管，8：线管
        if (Session["roleid"] != null && Session["deptname"] != null && (Session["roleid"].ToString() == "1" || Session["roleid"].ToString() == "2" || Session["roleid"].ToString() == "8"))
            sql += " where ckdw='" + Session["deptname"].ToString() + "'";
        sql += " group by ckdw";

        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        ddldw.Items.Add(new ListItem("------全部------", "0"));
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            ddldw.Items.Add(dr[0].ToString());
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
    private DataTable GetDataTable()
    {
        string sqlStr = "select * from yjylkc_llmx  ";
        string whereStr = "where";
        if (Request.QueryString["qj"] != null)
        {
            ddlMonth.Text = Request.QueryString["qj"].ToString();
            whereStr += "  substring (cksj,0,8)>='" + Request.QueryString["qj"].ToString() + "' and";
        }
        else
            whereStr += "  substring (cksj,0,8)>='" + DateTime.Now.AddMonths(-1).ToString("yyyy-MM") + "' and";
        if (Request.QueryString["jz"] != null)
        {
            ddlMonth1.Text = Request.QueryString["jz"].ToString();
            whereStr += "  substring (cksj,0,8)<='" + Request.QueryString["jz"].ToString() + "' and";
        }
        else
            whereStr += "  substring (cksj,0,8)<='" + DateTime.Now.ToString("yyyy-MM") + "' and";
        if (Request.QueryString["lb"] != null)
        {
            ddlClass.Text = Request.QueryString["lb"].ToString();
            whereStr += "  classname='" + Request.QueryString["lb"].ToString() + "' and";
        }
        if (Request.QueryString["id"] != null)
        {
            id.Text = Request.QueryString["id"].ToString();
            whereStr += "  id like '%" + Request.QueryString["id"].ToString() + "%' and";
        }
          //判断市县派单用户和库管
        if (Session["roleid"] != null && Session["deptname"] != null && (Session["roleid"].ToString() == "1" || Session["roleid"].ToString() == "2"))
        {
            ddldw.Text = Session["deptname"].ToString();
            whereStr += "  ckdw='" + Session["deptname"].ToString() + "' and";
        }
        else
        {
            if (Request.QueryString["dw"] != null)
            {
                ddldw.Text = Request.QueryString["dw"].ToString();
                whereStr += "  ckdw='" + Request.QueryString["dw"].ToString() + "' and";
            }
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
        if (Request.QueryString["lb"] != null)
        {
            condition += "&lb=" + Request.QueryString["lb"].ToString();
        }
        if (Request.QueryString["dw"] != null)
        {
            condition += "&dw=" + Request.QueryString["dw"].ToString();
        }
        if (Request.QueryString["id"] != null)
        {
            condition += "&id=" + Request.QueryString["id"].ToString();
        }
        DataTable dt = GetDataTable();
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
        if (ddlClass.Text != "0")
            condition += "&lb=" + ddlClass.Text;
        if (ddldw.Text != "0")
            condition += "&dw=" + ddldw.Text;
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
        if (Request.QueryString["lb"] != null)
        {
            outputFileName += Request.QueryString["lb"].ToString() + "-";
        }
        outputFileName += "日常维护领料表.xls";
        DataTable dt = GetDataTable();

        dt.Columns[0].ColumnName = "序号";
        dt.Columns[1].ColumnName = "出库时间";
        dt.Columns[2].ColumnName = "领料单位";
        dt.Columns[3].ColumnName = "领料人";
        dt.Columns[4].ColumnName = "类别";
        dt.Columns[5].ColumnName = "型号";
        dt.Columns[6].ColumnName = "盘号";
        dt.Columns[7].ColumnName = "数量";
        dt.Columns[8].ColumnName = "单位";
        dt.Columns[9].ColumnName = "用料地址";
        dt.Columns[10].ColumnName = "领料用途";
        dt.Columns[11].ColumnName = "备注";
        dt.Columns[12].ColumnName = "出库单位";
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
}