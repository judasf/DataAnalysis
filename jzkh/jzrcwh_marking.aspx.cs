using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.UI.HtmlControls;
using System.Text;

public partial class jzkh_jzrcwh_marking : System.Web.UI.Page
{
    private string fieldPre = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        //新增修改:运维部zhaoziqiang打市公司对各县考核；网络维护中心tianlihua打市公司对市公司,各县对各县打分
        fieldPre = Session["deptname"] != null && Session["deptname"].ToString() == "运行维护部" ? "sgs_" : "wwhxgs_";
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == ""||Session["deptname"] == null )
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
                //判断权限;9:基站考核
                if (Session["roleid"] == null || Session["roleid"].ToString() != "9")
                    Response.Write("<script type='text/javascript'>alert('您没有相应的权限，请重新登陆！');top.location.href='../';</script>");
            NewsBind();
            BindDept();
            scoredate.InnerText = DateTime.Now.AddMonths(-1).ToString("yyyy年MM月");

            }
        }
    }
    private void BindDept()
    {
        //各县打自己
        if ( Session["deptname"].ToString() != "网络维护中心" && Session["deptname"].ToString() != "运行维护部")
            deptname.Items.Add(Session["deptname"].ToString());
        else
        {
            //网维打市区
            string sql = "select deptname from jzkh_deptinfo";
            if (Session["deptname"] != null && Session["deptname"].ToString() == "网络维护中心")
                sql = "select deptname from jzkh_deptinfo where id=1";
            //运维部打市公司对各县考核
            else if (Session["deptname"] != null && Session["deptname"].ToString() == "运行维护部")
                sql = "select deptname from jzkh_deptinfo";
            DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
            deptname.Items.Add(new ListItem("选择被考核分公司", "0"));
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                deptname.Items.Add(dr[0].ToString());
            }
        }
    }
    /// <summary>
    /// 绑定repeater
    /// </summary>
    private void NewsBind()
    {
        string sql = "select '日常维护管理及考核（100分）' as pclass, b.id,row_number() over(order by b.id) as rowid,a.classname,itemname,markname,markstd,memo";
        sql += " from jzkh_class as a join  jzkh_item as b ";
        sql += "on b.classid=a.id and a.parentid=3";
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        repData.DataSource = ds;
        repData.DataBind();
        MergeCells(repData, "pclass");
        MergeCells(repData, "classname");
        MergeCells(repData, "itemname");
        MergeCells(repData, "memo");
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
        ratio = fieldPre == "sgs_" ? 0.1 : 0.25;
       
        string sqlExit = "select count(*) from jzkh_marking where deptname='" + deptname.Text + "' and scoredate='" + scoredate.InnerText + "'";
        sqlExit += " and  markingdept='" + Session["deptname"].ToString() + "'";
        sqlExit += " and itemid in( select b.id from jzkh_class as a join  jzkh_item as b ";
        sqlExit += " on b.classid=a.id and a.parentid=3)";
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
            sql.Append("insert into jzkh_marking values('");
            sql.Append(deptname.Text); sql.Append("','");
            sql.Append(scoredate.InnerText); sql.Append("','");
            sql.Append(itemid.Value); sql.Append("','");
            sql.Append(score.Text); sql.Append("','");
            sql.Append(memo.Text); sql.Append("','");
            sql.Append(Session["uname"]); sql.Append("','");
            sql.Append(Session["deptname"]); sql.Append("','");
            sql.Append(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")); sql.Append("');");
        }
        DirectDataAccessor.Execute(sql.ToString());
        StringBuilder sb = new StringBuilder();
        string sqlTotal="select sum(score) from jzkh_marking where deptname='"+deptname.Text+"' and scoredate='"+ scoredate.InnerText +"'";
        ////县公司打分
        //if (Session["pre"] != null && Session["pre"].ToString().Trim() != "")
            sqlTotal += " and  markingdept='" + Session["deptname"].ToString() + "'";
        ////网络维护中心、运行维护部打分
        //if (Session["pre"] != null && Session["pre"].ToString().Trim() == "")
        //    sqlTotal += " and  (markingdept='网络维护中心' or markingdept='运行维护部')";

        sqlTotal+="  and itemid in( select b.id from jzkh_class as a join  jzkh_item as b ";
        sqlTotal += " on b.classid=a.id and a.parentid=3)";
        total = (double)DirectDataAccessor.QueryForDataSet(sqlTotal).Tables[0].Rows[0][0];
        //判断当前月，当前分公司记录是否存在，存在就update,不存在就insert
        sb.Append("IF EXISTS (SELECT * FROM  jzkh_score  WHERE deptname ='" + deptname.Text + "' ");
        sb.Append(" and scoredate='" + scoredate.InnerText + "') ");
        sb.Append(" Update  jzkh_score set " + fieldPre + "rcwh_score=" + (100 - total) * ratio + " where deptname='" + deptname.Text + "' ");
        sb.Append(" and scoredate='" + scoredate.InnerText + "'");
        sb.Append(" ELSE ");
        sb.Append(" Insert into  jzkh_score(deptname,scoredate," + fieldPre + "rcwh_score) values('" + deptname.Text + "','" + scoredate.InnerText + "'," + (100 - total) * ratio + ")");
        DirectDataAccessor.Execute(sb.ToString());
        ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('对"+deptname.Text+"分公司考核成功！');location.href=location.href;", true);
    }
}
