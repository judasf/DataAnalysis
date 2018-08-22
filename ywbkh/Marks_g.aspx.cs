using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;
public partial class Marks_g : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "" || Session["roleid"] == null || Session["roleid"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');window.location.href='Default.aspx';</script>");
            else
            {
                if (Session["uname"] != null)
                    lblDeptName.Text = "当前用户：" + Session["uname"].ToString();

                markmonth.InnerText = DateTime.Now.AddMonths(-1).ToString("yyyy年MM月");
                //绑定Repepater开始  
                string wherestr="";
                if (int.Parse(Session["roleid"].ToString()) < 2)
                    wherestr = " where roleid='2'";
                else
                    wherestr = " where roleid>'0' and username<>'" + Session["uname"].ToString() + "'";
                DataSet ds = DirectDataAccessor.QueryForDataSet(" select username from ywbkh_userinfo "+wherestr);
                rep.DataSource = ds;
                rep.DataBind();
                //绑定Repepater结束
                // 绑定下拉列表框
                DataSet ds1 = DirectDataAccessor.QueryForDataSet("select scoremonth from ywbkh_marking group by scoremonth ");
                foreach (DataRow dr in ds1.Tables[0].Rows)
                {
                    ddlYm.Items.Add(new ListItem(dr[0].ToString().Trim()));
                }
            }
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        //判断部门当月是已打分
        string isMarkSql = "select *  from ywbkh_marking where itemid='g' and markinguser='" + Session["uname"].ToString() + "' and scoremonth='" + markmonth.InnerText + "'";
        DataSet ds = DirectDataAccessor.QueryForDataSet(isMarkSql);
        if (ds.Tables[0].Rows.Count > 0)
        {
            ClientScript.RegisterStartupScript(this.GetType(), "Error", "alert('对不起，您当月已经评分，请不要重复操作！')", true);
            return;
        }
        else
        {
            StringBuilder sql = new StringBuilder();
            double score = 0;
            foreach (RepeaterItem ctrl in rep.Items)
            {
                HiddenField uname = (HiddenField)ctrl.FindControl("uname");
                TextBox txt_score = (TextBox)ctrl.FindControl("txt_score");
                score = double.Parse(txt_score.Text);
                sql.Append("insert into ywbkh_marking values('");
                sql.Append(uname.Value); sql.Append("','");
                sql.Append(markmonth.InnerText); sql.Append("','");
                sql.Append("g"); sql.Append("','");
                sql.Append(score); sql.Append("','");
                sql.Append(Session["uname"]); sql.Append("','");
                sql.Append(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")); sql.Append("');");


                //判断当前月，当前分公司记录是否存在，存在就update,不存在就insert
                //sql.Append("IF EXISTS (SELECT * FROM  ywbkh_score  WHERE uname ='" + uname.Value + "' ");
                //sql.Append(" and scoremonth='" + markmonth.InnerText + "') ");
                //sql.Append(" Update  ywbkh_score set score_e=" + score + " where uname='" + uname.Value + "' ");
                //sql.Append(" and scoremonth='" + markmonth.InnerText + "'");
                //sql.Append(" ELSE ");
                //sql.Append(" Insert into  ywbkh_score(uname,scoremonth,score_e) values('" + uname.Value + "','" + markmonth.InnerText + "'," + score + ")");
            }
            DirectDataAccessor.Execute(sql.ToString());
            ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('对贡献度胜任度职业道德考核成功！');location.href=location.href;", true);
            

        }
    }

}
