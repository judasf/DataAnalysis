﻿using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using org.in2bits.MyXls;

public partial class xlqxxxllgl : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
                //判断权限,库管查看出库情况
                if (Session["roleid"] == null || Session["roleid"].ToString() != "2")
                    Response.Write("<script type='text/javascript'>alert('您没有相应的权限，请重新登陆！');top.location.href='../';</script>");
                else
                {
                    BindMonth();
                    NewsBind();
                }
            }
        }
    }
    /// <summary>
    /// 绑定日期
    /// </summary>
    private void BindMonth()
    {

        DataSet ds = DirectDataAccessor.QueryForDataSet("select distinct substring(cksj,0,8) as rq ,DateName(year,cksj)as yearstr,datename(month,cksj)as monthstr from xlqxxx_llmx ");
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            ddlMonth.Items.Add(new ListItem(dr["yearstr"].ToString() + "年" + dr["monthstr"].ToString() + "月", dr["yearstr"].ToString() + "-" + dr["monthstr"].ToString()));
            ddlMonth1.Items.Add(new ListItem(dr["yearstr"].ToString() + "年" + dr["monthstr"].ToString() + "月", dr["yearstr"].ToString() + "-" + dr["monthstr"].ToString()));
        }
        ddlMonth1.SelectedIndex = ds.Tables[0].Rows.Count-1;
    }

    /// <summary>
    /// 获取DataTable
    /// </summary>
    /// <returns></returns>
    private DataTable GetDataTable()
    {
        string sql;
        sql = "select b.* from xlqxxx as a join xlqxxx_llmx as b on a.id=b.qxid and ";
        sql += " qxdw='" + Session["deptname"] + "' ";

        string whereStr = "where";
        if (Request.QueryString["qj"] != null)
        {
            ddlMonth.Text = Request.QueryString["qj"].ToString();
            whereStr += "  substring (cksj,0,8)>='" + Request.QueryString["qj"].ToString() + "' and";
        }
        if (Request.QueryString["jz"] != null)
        {
            ddlMonth1.Text = Request.QueryString["jz"].ToString();
            whereStr += "  substring (cksj,0,8)<='" + Request.QueryString["jz"].ToString() + "' and";
        }
        if (Request.QueryString["qxid"] != null)
        {
            qxid.Text = Request.QueryString["qxid"].ToString();
            whereStr += " qxid like '%" + Request.QueryString["qxid"].ToString() + "%' and";
        }
        if (whereStr != "where")
        {
            whereStr = whereStr.Substring(0, whereStr.Length - 3);
            sql += whereStr;
        }
        sql += " order by b.id desc";
        //Response.Write (sql);
        //Response.End();
        //return null;
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
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
        if (Request.QueryString["qxid"] != null)
        {
            condition += "&qxid=" + Request.QueryString["qxid"].ToString();
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
        outputFileName += "线路整改领料明细表.xls";
        DataTable dt = GetDataTable();

        dt.Columns[0].ColumnName = "序号";
        dt.Columns[1].ColumnName = "整改编号";
        dt.Columns[2].ColumnName = "出库时间";
        dt.Columns[3].ColumnName = "领料单位";
        dt.Columns[4].ColumnName = "领料人";
        dt.Columns[5].ColumnName = "联系电话";
        dt.Columns[6].ColumnName = "物资类别";
        dt.Columns[7].ColumnName = "物资型号";
        dt.Columns[8].ColumnName = "盘号";
        dt.Columns[9].ColumnName = "领取数量";
        dt.Columns[10].ColumnName = "单位";
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
        Cells cells = sheet.Cells;
        //设置列样式
        ColumnInfo cl = new ColumnInfo(xls,sheet);
        cl.Width = 20 * 256;
        cl.ColumnIndexStart = 1;
        cl.ColumnIndexEnd =2;
        sheet.AddColumnInfo(cl);
        ColumnInfo cl1 = new ColumnInfo(xls, sheet);
        cl1.Width = 20 * 256;
        cl1.ColumnIndexStart = 7;
        cl1.ColumnIndexEnd = 7;
        sheet.AddColumnInfo(cl1);
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
}