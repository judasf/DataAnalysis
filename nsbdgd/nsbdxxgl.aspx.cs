﻿using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using org.in2bits.MyXls;

public partial class nsbdxxgl : System.Web.UI.Page
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
                NewsBind();
                //判断是否运维部超管
                isAdminYW = (Session["roleid"].ToString() == "4" && Session["deptname"].ToString() == "网络部") ? true : false;
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
                        DirectDataAccessor.Execute("Delete from nsbdxx where id='" + Request.QueryString["id"] + "'");
                        ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('删除成功！'); location.href='nsbdxxgl.aspx';", true);

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

        DataSet ds = DirectDataAccessor.QueryForDataSet("select distinct substring(fssj,0,8) as rq ,DateName(year,fssj)as yearstr,datename(month,fssj)as monthstr from nsbdxx ");
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            ddlMonth.Items.Add(new ListItem(dr["yearstr"].ToString() + "年" + dr["monthstr"].ToString() + "月", dr["yearstr"].ToString() + "-" + dr["monthstr"].ToString()));
            ddlMonth1.Items.Add(new ListItem(dr["yearstr"].ToString() + "年" + dr["monthstr"].ToString() + "月", dr["yearstr"].ToString() + "-" + dr["monthstr"].ToString()));
        }
        ddlMonth1.SelectedIndex = ds.Tables[0].Rows.Count - 1;
    }
    /// <summary>
    /// 获取DataTable
    /// </summary>
    /// <returns></returns>
    private DataTable GetDataTable( string sqlStr)
    {
        string whereStr = "where";
        //默认显示当前月数据
        if (Request.QueryString["qj"] != null)
        {
            ddlMonth.Text = Request.QueryString["qj"].ToString();
            whereStr += "  substring (fssj,0,8)>='" + Request.QueryString["qj"].ToString() + "' and";
        }
        else
        {
            ddlMonth.SelectedIndex = ddlMonth.Items.Count - 1;
            whereStr += "  substring (fssj,0,8)>='" + ddlMonth.Text + "' and";
        }
        if (Request.QueryString["jz"] != null)
        {
            ddlMonth1.Text = Request.QueryString["jz"].ToString();
            whereStr += "  substring (fssj,0,8)<='" + Request.QueryString["jz"].ToString() + "' and";
        }
        else
        {
            ddlMonth1.SelectedIndex = ddlMonth1.Items.Count - 1;
            whereStr += "  substring (fssj,0,8)>='" + ddlMonth1.Text + "' and";
        }
            if (Request.QueryString["dw"] != null)
            {
                ddl_dd.Text = Server.UrlDecode(Request.QueryString["dw"].ToString());
                whereStr += "  dd='" + Server.UrlDecode(Request.QueryString["dw"].ToString()) + "' and";
            }
        //按编号查询
            if (Request.QueryString["nsbdid"] != null)
        {
            nsbdid.Text = Request.QueryString["nsbdid"].ToString();
            whereStr += "  id like '%" + Request.QueryString["nsbdid"].ToString() + "%' and";
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
        DataTable dt = GetDataTable("select * from nsbdxx  ");
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

            FirstPage.NavigateUrl = Request.CurrentExecutionFilePath + "?page=&pagesize=" + pagesize.ToString() + condition;
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
        if (ddl_dd.Text != "0")
            condition += "&dw=" + ddl_dd.Text;
        if (nsbdid.Text != "")
            condition += "&nsbdid=" + nsbdid.Text;
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
        outputFileName += "市区南水北调信息明细表.xls";


        DataTable dt = GetDataTable("select id,fssj,fsdw,lxr,lxdh,dd,sgdd,sy,ysje,sgdw,sgdwfzr,sgdwlxdh,ysyj,ysr,yssj,sssj,ssje,sjsj,sjje,ffsj from nsbdxx  ");

        dt.Columns[0].ColumnName = "编号";
        dt.Columns[1].ColumnName = "申请时间";
        dt.Columns[2].ColumnName = "申请单位";
        dt.Columns[3].ColumnName = "联系人";
        dt.Columns[4].ColumnName = "联系人电话";
        dt.Columns[5].ColumnName = "迁建线路地点";
        dt.Columns[6].ColumnName = "施工地段";
        dt.Columns[7].ColumnName = "迁建线路内容及方案";
        dt.Columns[8].ColumnName = "预算金额";
        dt.Columns[9].ColumnName = "施工单位";
        dt.Columns[10].ColumnName = "负责人";
        dt.Columns[11].ColumnName = "联系电话";
        dt.Columns[12].ColumnName = "验收意见";
        dt.Columns[13].ColumnName = "验收人";
        dt.Columns[14].ColumnName = "验收时间";
        dt.Columns[15].ColumnName = "送审时间";
        dt.Columns[16].ColumnName = "送审金额";
        dt.Columns[17].ColumnName = "审计时间";
        dt.Columns[18].ColumnName = "审计金额";
        dt.Columns[19].ColumnName = "付费时间";
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
        ColumnInfo cl = new ColumnInfo(xls, sheet);
        cl.Width = 20 * 256;
        cl.ColumnIndexStart = 0;
        cl.ColumnIndexEnd = 20;
        sheet.AddColumnInfo(cl);
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
            Cell cell = cells.Add(1, colIndex, col.ColumnName,xf);
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
    /// 处理领料信息
    /// </summary>
    /// <param name="id">id</param>
    /// <param name="qgll">南水北调领料</param>
    /// <param name="sgdw">施工单位</param>
    /// <returns></returns>
    public string handleLL(string id, string qgll)
   {
       string str="";
       if (qgll == "1")//已领料
               str = "<a class='gray'   href=\"nsbdllxxxq.aspx?id=" + id + "\" target=\"_blank\" title='点击查看领料信息'>已领料</a>";
           else //未领料
           {
               if (Session["roleid"] != null && Session["roleid"].ToString() == "11")//是男士北调库管
               {
                 
                       str = "<a class='b_blue' href=\"nsbdxxlllr.aspx?id=" + id + "\" title='点击录入领料信息'>未领料</a>";
               }
               else //非库管
                   str = "<span class='b_blue'>未领料</a>";
           }
  
       return str;
    }
    /// <summary>
    /// 处理退料信息
    /// </summary>
    /// <param name="id">编号</param>
    /// <param name="qgtl">是否退料</param>
    /// <param name="qgll">南水北调领料</param>
    /// <returns></returns>
    public string handleTL(string id, string qgtl, string qgll)
    {
        string str = "";
        if (qgtl == "1")
            str = "<a class='gray'   href=nsbdtlxxxq.aspx?id=" + id + " title='点击查看退料信息'>已退料</a>";
        else
        {
            if (Session["roleid"] != null && Session["roleid"].ToString() == "11")//是库管
            {
                if (qgll == "0")//未领料
                    str = "<a href=\"javascript:alert('该南水北调还未领料，不能退料！');\" class='b_lightblue'>未退料</a> ";
                else //未领料
                    str = "<a class='b_lightblue' href=\"nsbdxxtllr.aspx?id=" + id + "\" title='点击录入退料信息'>未退料</a>";
            }
            else //非库管
                str = "<span class='b_lightblue'>未退料</a>";
        }
        return str;
    }
    /// <summary>
    /// 处理南水北调验收
    /// </summary>
    /// <param name="id">编号</param>
    /// <param name="ysr">验收人</param>
    /// <param name="qgtl">南水北调退料</param>
    /// <returns></returns>
    public string handleYS(string id, string ysr, string qgtl)
    {
        string str = "";
        if (ysr != "")//已验收
            str = "<a class='gray'   href=\"nsbdxxxq.aspx?id=" + id + "\"  title='点击查看南水北调详情'>已验收</a>";
        else
        {
            //判断4：运维部验收
            if (Session["roleid"] != null && Session["roleid"].ToString() == "4")
            {
                if (qgtl == "0")//未退料
                    str = "<a href=\"javascript:alert('该南水北调未退料，不能验收！');\" class='b_red'>未验收</a> ";
                else //已签收
                    str = "<a class='b_red' href=\"nsbdxxys.aspx?id=" + id + "\" title='点击录入南水北调验收信息'>未验收</a>";
            }
            else //非派单人
                str = "<span class='b_red'>未验收</a>";
        }
        return str;
    }
    /// <summary>
    /// 处理审计状态
    /// </summary>
    /// <param name="id">编号</param>
    /// <param name="sssj">送审时间</param>
    /// <param name="sjsj">审计时间</param>
  /// <param name="ffsj">付费时间</param>
    /// <param name="ysr">审计时间</param>
    /// <returns></returns>
   public string handleSJ(string id, string sssj,string sjsj,string ffsj, string ysr)
   {
       //4：运维部程然送审
       string str = "";
       if (ysr == "")//未验收
       {
           if (Session["roleid"] != null && Session["roleid"].ToString() == "4")//
               str = "<a href=\"javascript:alert('该南水北调还未验收，不能进行送审操作！');\" class='b_green'>未送审</a> ";
           else
               str = "<span class='b_green'>未送审</a>";
       }
       else//已验收
       {
           if (sssj == "")//未送审
           {
               if (Session["roleid"] != null && Session["roleid"].ToString() == "4")//
                   str = "<a href=\"nsbdxxsslr.aspx?id="+id+"\" class='b_green' title='点击录入送审信息'>未送审</a> ";
               else
                   str = "<span class='b_green'>未送审</a>";
           }
           else//已送审
           {
               if (sjsj == "")//未审计
               {
                   if (Session["roleid"] != null && Session["roleid"].ToString() == "4")//
                       str = "<a href=\"nsbdxxsjlr.aspx?id="+id+"\" class='b_orange' title='点击录入审计信息'>未审计</a> ";
                   else
                       str = "<span class='b_orange'>未审计</a>";
               }
               else //已审计
               {
                   if (ffsj == "")//未付费
                   {
                       if (Session["roleid"] != null && Session["roleid"].ToString() == "4")//
                           str = "<a href=\"nsbdxxfflr.aspx?id="+id+"\" class='b_blue' title='点击录入付费信息'>未付费</a> ";
                       else
                           str = "<span class='b_blue'>未付费</a>";
                   }
                   else//已付费
                   {
                       str = "<a class='gray'   href=\"nsbdxxxq.aspx?id=" + id + "\" title='点击查看南水北调详情'>已付费</a>";
                   }
               }
           }
       }
       return str;

   }
   /// <summary>
   /// 生成删除功能
   /// </summary>
   /// <param name="id">id</param>
   /// <param name="qgll">南水北调领料</param>
   /// <returns></returns>
   public string handleDel(string id, string qgll)
   {
       string str = "";
       if (qgll == "1")//已领料
           str = "<a href=\"javascript:alert('该工单已领料不可删除！')\"title=\"删除\">删除</a>";
       else //未领料
       {
           str = " <a href=\"javascript:if(confirm('确认删除该条数据？')) location.href='?id="+id+"&action=del';\"  title=\"删除\">删除</a> ";
       }
       return str;
   }
  
}