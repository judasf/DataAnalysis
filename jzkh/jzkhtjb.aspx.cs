﻿using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.UI.HtmlControls;
using System.Text;
using org.in2bits.MyXls;

public partial class jzkh_jzkhtjb_marking : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
                BindDate();
                NewsBind();
            }
        }
    }
    /// <summary>
    /// 绑定日期
    /// </summary>
    private void BindDate()
    {
        DataSet ds = DirectDataAccessor.QueryForDataSet("select distinct  scoredate from jzkh_score ");
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            scoredate.Items.Add(new ListItem(dr[0].ToString()));
        }
    }
    private string GetSqlStr()
    {
        string ym = DateTime.Now.AddMonths(-1).ToString("yyyy年MM月");
        sd.InnerText = ym;
        if (Request.QueryString["qj"] != null)
            scoredate.Text = sd.InnerText = ym = Request.QueryString["qj"].ToString();//查询年
		else
			scoredate.SelectedIndex=scoredate.Items.Count-1;

        StringBuilder sql = new StringBuilder("select a.deptname,wbdw,isnull(dzzb_score,0)as s1,isnull(xqjgzzb_score,0)as s2,isnull(wwhxgs_rcwh_score,0) as s3,");
        sql.Append("isnull(sgs_rcwh_score,0) as s5,isnull(wykh_score,0) as s4,isnull(ewjc_score,0) as s6,");
        sql.Append("isnull((dzzb_score+xqjgzzb_score+wwhxgs_rcwh_score+wykh_score+sgs_rcwh_score+ewjc_score),0) as s7");
        sql.Append(" from jzkh_deptinfo as a left join jzkh_score as b on a.deptname=b.deptname ");
        sql.Append("and scoredate='" + ym + "'");
        return sql.ToString();
    }
    /// <summary>
    /// 绑定repeater
    /// </summary>
    private void NewsBind()
    {
        DataSet ds = DirectDataAccessor.QueryForDataSet(GetSqlStr());
        repData.DataSource = ds;
        repData.DataBind();
        MergeCells(repData, "wbdw");
    }
    /// <summary>
    /// 合并单元格
    /// </summary>
    /// <param name="rep">repeater控件</param>
    /// <param name="idname">要合并的单元格id</param>
    private void MergeCells(Repeater rep, string idname)
    {
        for (int i = rep.Items.Count - 1; i > 0; i--)
        {
            HtmlTableCell oCell_Previous = rep.Items[i - 1].FindControl(idname) as HtmlTableCell;
            HtmlTableCell oCell = rep.Items[i].FindControl(idname) as HtmlTableCell;

            oCell.RowSpan = (oCell.RowSpan == -1) ? 1 : oCell.RowSpan;
            oCell_Previous.RowSpan = (oCell_Previous.RowSpan == -1) ? 1 : oCell_Previous.RowSpan;
            if (oCell.InnerText == oCell_Previous.InnerText)
            {
                oCell.Visible = false;
                oCell_Previous.RowSpan += oCell.RowSpan;
            }
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string condition = "";
        if (scoredate.Text != "0")
            condition += "qj=" + scoredate.Text;
        ClientScript.RegisterStartupScript(this.GetType(), "redirect", "window.location='" + Request.CurrentExecutionFilePath + "?" + condition + "'", true);
    }
    protected void btnExportExcel_Click(object sender, EventArgs e)
    {
        string outputFileName = "";
        if (Request.QueryString["qj"] != null)
        {
            outputFileName += Request.QueryString["qj"].ToString() + "-";
        }
        else
            outputFileName += DateTime.Now.AddMonths(-1).ToString("yyyy年MM月")+"-";
        outputFileName += "基站外包维护质量考核表.xls";
        DataTable dt = DirectDataAccessor.QueryForDataSet(GetSqlStr()).Tables[0]; ;
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
        int rowIndex = 3;
        int colIndex = 0;
        Worksheet sheet = xls.Workbook.Worksheets.Add("sheet");//状态栏标题名称
        Cells cells = sheet.Cells;
        //设置列格式
        ColumnInfo colInfo = new ColumnInfo(xls, sheet);
        colInfo.ColumnIndexStart = 0;
        colInfo.ColumnIndexEnd =10;
        colInfo.Width = 15 * 256;
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
        //
       MergeRegion(ref sheet, xf, xlsName.Substring(0,xlsName.Length-4), 1, 1,1,9);
       MergeRegion(ref sheet, xf, "分公司",2,3, 1,1);
       MergeRegion(ref sheet, xf, "外包单位", 2, 3, 2,2);
      MergeRegion(ref sheet, xf, "基站故障指标（权重60%）", 2, 2, 3, 4);
      MergeRegion(ref sheet, xf, "日常维护管理与考核（40%）", 2, 2, 5, 7);
      MergeRegion(ref sheet, xf, "额外奖罚", 2, 3, 8, 8);
      MergeRegion(ref sheet, xf, "汇总得分", 2, 3, 9, 9);
      Cell cell1 = cells.Add(3, 3, "断站指标（权重48%）", xf);
      Cell cell2 = cells.Add(3, 4, "小区级故障指标（权重12%）", xf);
      Cell cell3 = cells.Add(3, 5, "网维或县公司考核（权重25%）", xf);
      Cell cell4 = cells.Add(3, 6, "网优考核（权重5%）", xf);
      Cell cell5 = cells.Add(3, 7, "市公司考核（权重10%）", xf);
        //填充数据
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
                if(colIndex!=1)
                cell.Font.Bold = false;  //字体为粗体    
            }
        }
        MergeRegion(ref sheet, xf, "设计院", 4, 5, 2, 2);
        MergeRegion(ref sheet, xf, "北京合力", 6, 9, 2, 2);
        xls.Send();
        Response.Flush();
        Response.End();
    }
    /// <summary>
    /// 合并单元格，参数列表：开始行，结束行，开始列，结束列
    /// </summary>
    /// <param name="ws">sheet</param>
    /// <param name="xf">样式</param>
    /// <param name="title">新内容</param>
    /// <param name="startRow">开始行</param>
    /// <param name="startCol">开始列</param>
    /// <param name="endRow">结束行</param>
    /// <param name="endCol">结束列</param>
    public void MergeRegion(ref Worksheet ws, XF xf, string title, int startRow, int endRow, int startCol, int endCol)
    {
        for (int i = startCol; i <= endCol; i++)
        {
            for (int j = startRow; j <= endRow; j++)
            {
                ws.Cells.Add(j, i, title, xf);
            }
        }
        ws.Cells.Merge(startRow, endRow, startCol, endCol);
    }

}
