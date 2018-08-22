using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using org.in2bits.MyXls;

public partial class yjylkckctjb : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "" || Session["roleid"] == null || Session["roleid"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
                BindCity();
                BindClass();
                NewsBind();
                if (Request.QueryString["action"] == "del" && Session["pre"] != null)
                {
                    int infoid = 0;
                    if (Request.QueryString["id"] == null || !int.TryParse(Request.QueryString["id"].ToString(), out infoid))
                    {
                        Response.Write("参数错误！");
                        Response.End();
                    }
                    else
                    {
                        DirectDataAccessor.Execute("Delete from " + Session["pre"].ToString() + "yjylkc_kcmx where id='" + infoid.ToString() + "'");
                        ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('删除成功！'); location.href='" + Request.UrlReferrer + "';", true);

                    }
                }
            }
        }
    }
    /// <summary>
    /// 绑定市县
    /// </summary>
    private void BindCity()
    {
        string sql = "select pre,city from deptinfo ";
        if (Session["roleid"] != null && Session["roleid"].ToString() != "0" && Session["roleid"].ToString() != "4")
            sql += "where pre ='" + Session["pre"].ToString() + "' ";
        sql += " group by city,pre order by pre";
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            ddlpre.Items.Add(new ListItem(dr[1].ToString(), dr[0].ToString()));
        }
    }
    /// <summary>
    /// 绑定类别
    /// </summary>
    private void BindClass()
    {
        string strPre = Request.QueryString["pre"] != null ? Request.QueryString["pre"].ToString() : Session["pre"].ToString();

        string sql = "select *  from " + strPre + "yjylkc_Class";
        //判断权限：0:admin看全部；4：运维部看全部；2：库管，5：公众领导不能看南水北调；11：南水北调库管只操作南水北调
        if (Session["roleid"] != null)
        {
            switch (Session["roleid"].ToString())
            {
                case "2":
                case "5":
                    sql += "  where classname<>'南水北调' ";
                    break;
                case "11":
                    sql += " where classname='南水北调'";
                    break;
            }
        }
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        ddlClass.Items.Add(new ListItem("---全部---", "0"));
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            ddlClass.Items.Add(new ListItem(dr[1].ToString()));
        }
    }
    /// <summary>
    /// 绑定型号
    /// </summary>
    /// <param name="classname">类别名称</param>
    private void BindType(string classname)
    {
        string strPre = Request.QueryString["pre"] != null ? Request.QueryString["pre"].ToString() : Session["pre"].ToString();
        string sql = "select typename from " + strPre + "yjylkc_Type  a join  " + strPre + "yjylkc_Class b on a.classid=b.classid where b.classname ='" + classname + "'";
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        ddlType.Items.Clear();
        ddlType.Items.Add(new ListItem("--------------全部---------------", "0"));
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            ddlType.Items.Add(new ListItem(dr[0].ToString()));
        }

    }
    protected void ddlClass_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindType(ddlClass.Text);
    }
    /// <summary>
    /// 获取DataTable
    /// </summary>
    /// <returns></returns>
    private DataTable GetDataTable()
    {
        string sqlStr = "select row_number() over (order by id desc) as rowid,* from ";
        if (Request.QueryString["pre"] != null)
        {
            ddlpre.Text = Server.UrlDecode(Request.QueryString["pre"].ToString());
            sqlStr += Server.UrlDecode(Request.QueryString["pre"].ToString());
        }
        else
        {
            ddlpre.Text = Session["pre"].ToString();
            sqlStr += Session["pre"].ToString();
        }
        sqlStr += "yjylkc_kcmx  ";
        string whereStr = "where";
        if (Request.QueryString["cl"] != null)
        {
            ddlClass.Text = Server.UrlDecode(Request.QueryString["cl"].ToString());
            whereStr += "  classname='" + Server.UrlDecode(Request.QueryString["cl"].ToString()) + "' and";
            BindType(ddlClass.Text);
        }
        if (Request.QueryString["typename"] != null)
        {
            ddlType.Text = Server.UrlDecode(Request.QueryString["typename"].ToString());
            whereStr += "  typename = '" + Server.UrlDecode(Request.QueryString["typename"].ToString()) + "' and";
        }
        //判断权限：0:admin看全部；4：运维部看全部；2：库管，5：公众领导不能看南水北调；11：南水北调库管只操作南水北调
        if (Session["roleid"] != null)
        {
            switch (Session["roleid"].ToString())
            {
                case "2":
                case "5":
                    whereStr += "   classname<>'南水北调' and";
                    break;
                case "11":
                    whereStr += "  classname='南水北调' and";
                    break;
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
        if (Request.QueryString["cl"] != null)
        {
            condition += "&cl=" + Server.UrlEncode(Request.QueryString["cl"].ToString());
        }
        if (Request.QueryString["typename"] != null)
        {
            condition += "&typename=" + Server.UrlEncode(Request.QueryString["typename"].ToString());
        }
        if (Request.QueryString["pre"] != null)
        {
            condition += "&pre=" + Server.UrlEncode(Request.QueryString["pre"].ToString());
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
        if (ddlClass.Text != "0")
            condition += "&cl=" +Server.UrlEncode(ddlClass.Text);
        if (ddlType.Text != "0")
            condition += "&typename=" + Server.UrlEncode(ddlType.Text);
        if (ddlpre.Text != "0")
            condition += "&pre=" + Server.UrlEncode(ddlpre.Text);
        ClientScript.RegisterStartupScript(this.GetType(), "redirect", "window.location='" + Request.CurrentExecutionFilePath + "?page=1" + condition + "'", true);

    }
    protected void btnExportExcel_Click(object sender, EventArgs e)
    {
        string outputFileName = "";
        if (Request.QueryString["cl"] != null)
        {
            outputFileName += Server.UrlDecode( Request.QueryString["cl"].ToString()) + "-";
        }
        if (Request.QueryString["typename"] != null)
        {
            outputFileName += Server.UrlDecode(Request.QueryString["typename"].ToString()) + "-";
        }
        outputFileName += "库存统计表.xls";
        DataTable dt = GetDataTable();
        dt.Columns.Remove("id");
        dt.Columns[0].ColumnName = "序号";
        dt.Columns[1].ColumnName = "类别";
        dt.Columns[2].ColumnName = "型号";
        dt.Columns[3].ColumnName = "盘号";
        dt.Columns[4].ColumnName = "单位";
        dt.Columns[5].ColumnName = "数量";
        MyXls.CreateXls(dt, outputFileName, "2");
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
            cell.Font.Bold = true;
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
    public string handleEdit(string id,string rowid)
    {
        string str = "";
        if (Session["roleid"] != null && (Session["roleid"].ToString() == "2" || Session["roleid"].ToString() == "11") && Session["uname"].ToString()=="guoleijie")
        {
            str = "<a href=\"yjylkckcedit.aspx?id=" + id + "\" title=\"库存编辑\">" + rowid + "</a>&nbsp;&nbsp;";
            str += "<a href=\"javascript:if(confirm('确认删除该条数据？')) location.href='?id=" + id + "&action=del';\"  title=\"删除\">删除</a>";
        }
        else
            str = rowid;

        return str;
    }
}