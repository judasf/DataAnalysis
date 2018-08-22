using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using System.Data.SqlClient;

public partial class xlbdxxwj : System.Web.UI.Page
{
    public static string url;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
                  //判断权限，派单员有权限完结工单
                if (Session["roleid"] == null || Session["roleid"].ToString() != "1")
                    Response.Write("<script type='text/javascript'>alert('您没有相应的权限，请重新登陆！');top.location.href='../';</script>");
            if (Request.QueryString["bdid"] == null)
            {
                Response.Write("参数错误！");
                Response.End();
            }
            else
            {
                bdid.Text = Request.QueryString["bdid"].ToString();
                DataSet ds = DirectDataAccessor.QueryForDataSet("select * from xlbdxx where id='" + Request.QueryString["bdid"].ToString() + "'");
                if (ds.Tables[0].Rows.Count < 1)
                {
                    Response.Write("参数错误！");
                    Response.End();
                }
                else
                {
                    bdrq.Text = ds.Tables[0].Rows[0][1].ToString();
                    bddd.Text = ds.Tables[0].Rows[0][2].ToString();
                    bgarq.Text = ds.Tables[0].Rows[0][4].ToString();
                    bbxgsrq.Text=ds.Tables[0].Rows[0][5].ToString();
                    bxgscxc.Text = ds.Tables[0].Rows[0][6].ToString();
                    bdss.Text = ds.Tables[0].Rows[0][7].ToString();
                    ssje.Text = ds.Tables[0].Rows[0][8].ToString();
                    hfsj.Text = ds.Tables[0].Rows[0][9].ToString();
                }
            }
            if (Request.UrlReferrer != Request.Url)
                url = Request.UrlReferrer.ToString();
            }
      }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        //获取参数
        //编号
        string id = bdid.Text;
        //恢复时间
        string hfsjStr = hfsj.Text;
        //现场照片
        string filesStr = report.Value;
        StringBuilder sql = new StringBuilder();
        //更新恢复时间
        sql.Append("update xlbdxx set hfsj=@hfsj where id=@id;");
        //保存恢复照片
        if (!string.IsNullOrEmpty(filesStr))
        {
            string[] filesPath = filesStr.Split(new String[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            foreach (string path in filesPath)
            {
                string fileName = path.Substring(path.LastIndexOf('/') + 1);
                sql.Append("Insert into Attachment_BDAndQX values(@id,'" + fileName + "','" + path + "',1);");
            }
        }
        //设定参数
        List<SqlParameter> _paras = new List<SqlParameter>();
        _paras.Add(new SqlParameter("@id", id));
        _paras.Add(new SqlParameter("@hfsj", hfsjStr));
        //使用事务提交操作
        using (SqlConnection conn = SqlHelper.GetConnection())
        {
            conn.Open();
            using (SqlTransaction trans = conn.BeginTransaction())
            {
                try
                {
                    SqlHelper.ExecuteNonQuery(trans, CommandType.Text, sql.ToString(), _paras.ToArray());
                    trans.Commit();
                    ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('该被盗设置完结成功！');location.href='" + url + "'", true);
                }
                catch
                {
                    trans.Rollback();
                    ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('执行出错！')", true);
                    throw;
                }
            }
        }
        
    }
}
