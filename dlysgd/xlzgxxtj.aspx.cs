﻿using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using org.in2bits.MyXls;

public partial class xlzgxxtj : System.Web.UI.Page
{
    public string year;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
                if (Session["uname"] == null || Session["uname"].ToString() == "")
                    Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
                else
            {
            BindYear();
            BindPfdw();
            NewsBind();
            }
        }
    }
    /// <summary>
    /// 绑定年份
    /// </summary>
    private void BindYear()
    {
        DataSet ds = DirectDataAccessor.QueryForDataSet("select distinct DateName(year,pdsj)as yearstr from dlysxx ");
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            ddlYear.Items.Add(new ListItem(dr["yearstr"].ToString() + "年", dr["yearstr"].ToString()));
        }
    }
    /// <summary>
    /// 绑定单位
    /// </summary>
    private void BindPfdw()
    {
        string sql = "select pfdw from dlysxx ";
        if (Session["roleid"] != null && Session["deptname"] != null && (Session["roleid"].ToString() == "1" || Session["roleid"].ToString() == "2"))
            sql += " where pfdw='" + Session["deptname"].ToString() + "'";
        sql += " group by pfdw";

        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        ddlpfdw.Items.Add(new ListItem("----全部----", "0"));
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            ddlpfdw.Items.Add(dr[0].ToString());
        }
    }
    /// <summary>
    /// 获取sql语句 0:绑定列表；1:输出excel
    /// </summary>
    /// <returns></returns>
    private string GetSqlStr()
    {
        year = DateTime.Now.ToString("yyyy");//当前年
        string month;//01-12月
        string s;//月份的字符串形式
        string whereStr;
        string dwStr = "";// 按单位查询
        string wjStr = "";//按完结状态查询
        if (Request.QueryString["qj"] != null)
            ddlYear.Text = year = Request.QueryString["qj"].ToString();//查询年
                //判断市县派单用户和库管
        if (Session["roleid"] != null && Session["deptname"] != null && (Session["roleid"].ToString() == "1" || Session["roleid"].ToString() == "2" ))
        {
            ddlpfdw.Text = Session["deptname"].ToString();
            dwStr = " where  a.pfdw='" + Session["deptname"].ToString() + "'";
        }
        else
        {
            if (Request.QueryString["dw"] != null)
            {
                ddlpfdw.Text = Request.QueryString["dw"].ToString();
                dwStr = " where  a.pfdw='" + Request.QueryString["dw"].ToString() + "'";
            }
        }
        if (!string.IsNullOrEmpty(Request.QueryString["qrwj"]))
        {
            ddlqrwj.Text = Request.QueryString["qrwj"];
            if (Request.QueryString["qrwj"] == "1")
                wjStr = " and qrwjsj is not null";
            if (Request.QueryString["qrwj"] == "2")
                wjStr = " and qrwjsj is null";
        }
        //循环生成sql语句
        StringBuilder sql = new StringBuilder("select a.pfdw"); //完整的sql
        StringBuilder zdStr = new StringBuilder();//查询的字段
        StringBuilder joinStr = new StringBuilder();//左连接语句
        for (int i = 1; i < 13; i++)
        {
            s = i.ToString();
            month = i < 10 ? "-0" + s : "-" + s;
            whereStr = "where substring(pdsj,0,8)='" + year + month + "'";
            whereStr += wjStr;
           zdStr.Append(",isnull(m" + s + ".num,0) as num" + s );
            joinStr.Append(" left join (");
            joinStr.Append("select pfdw,count(id) as num  from dlysxx ");
            joinStr.Append(whereStr);
            joinStr.Append(" group by pfdw,substring(pdsj,0,8) )");
            joinStr.Append(" as m" + s + " on a.pfdw=m" + s + ".pfdw ");
        }
        sql.Append(zdStr);
        sql.Append(" from (select pfdw from dlysxx group by pfdw) as a ");
        sql.Append(joinStr);
        sql.Append(dwStr);
        return sql.ToString();
    }
    /// <summary>
    /// repeater分页并绑定
    /// </summary>
    private void NewsBind()
    {
        //Response.Write(GetSqlStr());
        DataSet ds = DirectDataAccessor.QueryForDataSet(GetSqlStr());
        repData.DataSource = ds;
        repData.DataBind();
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string condition = "";
        if (ddlYear.Text != "0")
            condition += "qj=" + ddlYear.Text;
        if (ddlpfdw.Text != "0")
            condition += "&dw=" + ddlpfdw.Text;
        if (ddlqrwj.Text != "0")
            condition += "&qrwj=" + ddlqrwj.Text;
        ClientScript.RegisterStartupScript(this.GetType(), "redirect", "window.location='" + Request.CurrentExecutionFilePath + "?" + condition + "'", true);

    }
    protected void btnExportExcel_Click(object sender, EventArgs e)
    {
        string outputFileName = "";
        if (Request.QueryString["qj"] != null)
        {
            outputFileName += Request.QueryString["qj"].ToString() + "-";
        }
        if (Request.QueryString["dw"] != null)
        {
            outputFileName += Request.QueryString["dw"].ToString() + "-";
        }
        if (Request.QueryString["qrwj"] != null)
        {
            if (Request.QueryString["qrwj"] == "1")
                outputFileName += "已完结-";
            if (Request.QueryString["qrwj"] == "2")
                outputFileName += "未完结-";
        }
        outputFileName += "线路电缆延伸信息统计.xls";
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
        int rowIndex = 1;
        int colIndex = 0;
        Worksheet sheet = xls.Workbook.Worksheets.Add("sheet");//状态栏标题名称
        Cells cells = sheet.Cells;
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
        //设置月份
        string[] colums1 = { "派发单位", "1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月" };
        foreach (string col1 in colums1)
        {
            colIndex++;
            Cell cell = cells.Add(1, colIndex, col1, xf);
        }
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
                cell.Font.Bold = false;  //字体为粗体    
            }
        }

        xls.Send();
        Response.Flush();
        Response.End();
    }
    /// <summary>
    ///根据派发单位判断链接地址
    /// </summary>
    /// <param name="pfdw"></param>
    /// <returns></returns>
    public string JudgeLinkBypfdw(string pfdw)
    {
        string link = "xlzgxxgl.aspx";
        string sql = "select pre from deptinfo where deptname='" + pfdw + "'";
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        if (ds.Tables[0].Rows.Count > 0)
        {
            if (ds.Tables[0].Rows[0][0].ToString() != "")
                link = "xlzgxxgl_town.aspx";
        }
        return link;
    }
}