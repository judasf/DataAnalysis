﻿using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.UI.HtmlControls;
using System.Text;

public partial class zwkh_zwjcgl_marking_view : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
                if (Request.QueryString["scoredate"] == null || Request.QueryString["dept"] == null || Request.QueryString["markingdept"] == null)
                {
                    Response.Write("参数错误！");
                    Response.End();
                }
                else
                {
                    scoredate.InnerText = Request.QueryString["scoredate"];
                    deptname.InnerHtml = Request.QueryString["dept"];
                    markingdept.InnerText = Request.QueryString["markingdept"];
                    NewsBind();

                }

            }
        }
    }
    /// <summary>
    /// 绑定repeater
    /// </summary>
    private void NewsBind()
    {
        double total = 0;
        StringBuilder sql = new StringBuilder("select  b.id,row_number() over(order by b.orderid) as rowid,a.classname,itemname,std,marks,markstd");
        sql.Append(",c.score,c.memo,c.markingdept,c.markingtime ");
        sql.Append("from ((zwkh_class as a join  zwkh_item as b ");
        sql.Append("on b.classid=a.id and a.id=2) join zwkh_marking as c ");
        sql.Append("on b.id=c.itemid and c.deptname='" + deptname.InnerHtml + "' and c.scoredate='" + scoredate.InnerText + "')");
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql.ToString());
        repData.DataSource = ds;
        repData.DataBind();
        MergeCells(repData, "classname");
        MergeCells(repData, "marks");
        foreach (DataRow dr in ds.Tables[0].Rows)
            total += double.Parse(dr["score"].ToString());
        trtotal.InnerText = total.ToString();
        if (ds.Tables[0].Rows.Count > 0)
        {
            markingtime.InnerHtml = "<b>考核时间：</b>" + ds.Tables[0].Rows[0]["markingtime"];
        }
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
}
