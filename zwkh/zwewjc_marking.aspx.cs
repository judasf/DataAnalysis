using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.UI.HtmlControls;
using System.Text;

public partial class zwkh_zwewjc_marking : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["pre"] == null || Session["uname"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
                //判断权限;4：运维部考核额外奖惩
                if (Session["roleid"] == null || Session["roleid"].ToString() != "4")
                    Response.Write("<script type='text/javascript'>alert('您没有相应的权限，请重新登陆！');top.location.href='../';</script>");
                NewsBind();
                scoredate.InnerText = DateTime.Now.AddMonths(-1).ToString("yyyy年MM月");
                BindDept();
            }
        }
    }
    private void BindDept()
    {
        //运维部考核
        if (Session["roleid"].ToString() == "4")
        {
            DataSet ds = DirectDataAccessor.QueryForDataSet("select deptname from zwkh_deptinfo");
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
        string sql = "select b.id,row_number() over(order by b.id) as rowid,a.classname,itemname,std,marks,markstd ";
        sql += "  from zwkh_class as a join  zwkh_item as b  ";
        sql += "on b.classid=a.id and a.id=3";
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        repData.DataSource = ds;
        repData.DataBind();
        MergeCells(repData, "classname");
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
        string sqlExit = "select count(*) from zwkh_score where deptname='" + deptname.Text + "' and scoredate='" + scoredate.InnerText + "'";
        sqlExit += " and ewjc_score<>0";
        DataSet ds = DirectDataAccessor.QueryForDataSet(sqlExit);
        if (ds.Tables[0].Rows[0][0].ToString() != "0")
        {
            ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('已经对" + deptname.Text + "分公司考核成功，不能重复考核！');location.href=location.href;", true);
            return;
        }
        StringBuilder sql = new StringBuilder();
        double total = 0;
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
        sql.Append(" Update  zwkh_score set ewjc_score=" + total + " where deptname='" + deptname.Text + "' ");
        sql.Append(" and scoredate='" + scoredate.InnerText + "'");
        sql.Append(" ELSE ");
        sql.Append(" Insert into  zwkh_score(deptname,scoredate,ewjc_score) values('" + deptname.Text + "','" + scoredate.InnerText + "'," + total + ")");
        DirectDataAccessor.Execute(sql.ToString());
        ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('对" + deptname.Text + "分公司考核成功！');location.href=location.href;", true);
    }
}
