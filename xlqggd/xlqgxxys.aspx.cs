using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using System.Data.SqlClient;

public partial class xlqgxxys : System.Web.UI.Page
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
                //判断权限，公众领导有权限验收迁改，县公司录单人验收
                if (Session["roleid"] == null || (Session["roleid"].ToString() != "5" && Session["roleid"].ToString()!="1"))
                    Response.Write("<script type='text/javascript'>alert('您没有相应的权限，请重新登陆！');top.location.href='../';</script>");
                if (Request.QueryString["id"] == null)
                {
                    Response.Write("参数错误！");
                    Response.End();
                }
                else
                {
                    id.InnerText = Request.QueryString["id"].ToString();
                    DataSet ds = DirectDataAccessor.QueryForDataSet("select * from xlqgxx where id='" + Request.QueryString["id"].ToString() + "'");
                    if (ds.Tables[0].Rows.Count < 1)
                    {
                        Response.Write("参数错误！");
                        Response.End();
                    }
                    else
                    {
                        fssj.InnerHtml = ds.Tables[0].Rows[0]["fssj"].ToString();
                        fsdw.InnerHtml = ds.Tables[0].Rows[0]["fsdw"].ToString();
                        lxr.InnerHtml = ds.Tables[0].Rows[0]["lxr"].ToString();
                        lxdh.InnerHtml = ds.Tables[0].Rows[0]["lxdh"].ToString();
                        sy.InnerHtml = ds.Tables[0].Rows[0]["sy"].ToString();
                        ysje.InnerHtml = ds.Tables[0].Rows[0]["ysje"].ToString();
                        sgdw.InnerHtml = ds.Tables[0].Rows[0]["sgdw"].ToString();
                        sgdwfzr.InnerHtml = ds.Tables[0].Rows[0]["sgdwfzr"].ToString();
                        sgdwlxdh.InnerHtml = ds.Tables[0].Rows[0]["sgdwlxdh"].ToString();

                    }

                }
            }
            if (Request.UrlReferrer != null && Request.UrlReferrer != Request.Url)
                url = Request.UrlReferrer.ToString();
        }
    }


    protected void Button1_Click(object sender, EventArgs e)
    {
        //获取参数
     
        string filesStr = report.Value;
        StringBuilder sql = new StringBuilder();
        //更新恢复时间
        sql.Append("update  xlqgxx set ysyj=@ysyj,ysr=@ysr,yssj=@yssj where id=@id;");
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
        _paras.Add(new SqlParameter("@id", id.InnerText));
        _paras.Add(new SqlParameter("@ysyj", ysyj.Text));
        _paras.Add(new SqlParameter("@ysr", ysr.Text));
        _paras.Add(new SqlParameter("@yssj", yssj.Text));
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
                    ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('该迁改验收完成，进入审计报账状态！');location.href='" + url + "'", true);
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
