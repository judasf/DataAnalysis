﻿using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.UI.HtmlControls;
using System.Text;

public partial class zwkh_zwjcgl_marking : System.Web.UI.Page
{
    private string fieldPre = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
                //判断权限;10:线路，装维基础管理考核
                if (Session["roleid"] == null || (Session["roleid"].ToString() != "10"  && Session["roleid"].ToString() != "5") || (Session["roleid"].ToString() == "5" && Session["uname"].ToString() != "wangheyang") || (Session["roleid"].ToString() == "10" && Session["pre"].ToString().Trim() == ""))
                    Response.Write("<script type='text/javascript'>alert('您没有相应的权限，请重新登陆！');top.location.href='../';</script>");
                NewsBind();
                BindDept();
                scoredate.InnerText = DateTime.Now.AddMonths(-1).ToString("yyyy年MM月");

            }
        }
    }
    private void BindDept()
    {
        //装维考核
        if (Session["roleid"].ToString() == "10")
            deptname.Items.Add(Session["deptname"].ToString());
        //公响中心考核市区
        if (Session["roleid"].ToString() == "5")
        {
            deptname.Items.Add("市区");
        }
    }
    /// <summary>
    /// 绑定repeater
    /// </summary>
    private void NewsBind()
    {
        string sql = "select b.id,row_number() over(order by b.id) as rowid,a.classname,itemname,std,marks,markstd ";
        sql += "  from zwkh_class as a join  zwkh_item as b  ";
        sql += "on b.classid=a.id and a.id=2";
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        repData.DataSource = ds;
        repData.DataBind();
        MergeCells(repData, "classname");
        MergeCells(repData, "marks");

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

    protected void Button1_Click(object sender, EventArgs e)
    {
        double total = 0, ratio;
        ratio = 1;
        string sqlExit = "select count(*) from zwkh_score where deptname='" + deptname.Text + "' and scoredate='" + scoredate.InnerText + "'";
        sqlExit += " and jcgl_score<>0";
        DataSet ds = DirectDataAccessor.QueryForDataSet(sqlExit);
        if (ds.Tables[0].Rows[0][0].ToString() != "0")
        {
            ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('已经对" + deptname.Text + "分公司考核成功，不能重复考核！');location.href=location.href;", true);
            return;
        }
        StringBuilder sql = new StringBuilder();
        foreach (RepeaterItem rpitem in repData.Items)
        {
            TextBox score = (TextBox)rpitem.FindControl("txtscore");
            HiddenField itemid = (HiddenField)rpitem.FindControl("hfid");
            TextBox memo = (TextBox)rpitem.FindControl("txtmemo");
            total += double.Parse(score.Text);
            sql.Append("insert into zwkh_marking values('");
            sql.Append(deptname.Text); sql.Append("','");
            sql.Append(scoredate.InnerText); sql.Append("','");
            sql.Append(itemid.Value); sql.Append("','");
            sql.Append(score.Text); sql.Append("','");
            sql.Append(memo.Text); sql.Append("','");
            sql.Append(Session["uname"]); sql.Append("','");
            sql.Append(Session["deptname"]); sql.Append("','");
            sql.Append(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")); sql.Append("');");
        }
        //判断当前月，当前分公司记录是否存在，存在就update,不存在就insert
        sql.Append("IF EXISTS (SELECT * FROM  zwkh_score  WHERE deptname ='" + deptname.Text + "' ");
        sql.Append(" and scoredate='" + scoredate.InnerText + "') ");
        sql.Append(" Update  zwkh_score set jcgl_score=" + (15 - total) * ratio + " where deptname='" + deptname.Text + "' ");
        sql.Append(" and scoredate='" + scoredate.InnerText + "'");
        sql.Append(" ELSE ");
        sql.Append(" Insert into  zwkh_score(deptname,scoredate,jcgl_score) values('" + deptname.Text + "','" + scoredate.InnerText + "'," + (15 - total) * ratio + ")");
        DirectDataAccessor.Execute(sql.ToString());
        ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('对" + deptname.Text + "分公司考核成功！');location.href=location.href;", true);

    }
}
