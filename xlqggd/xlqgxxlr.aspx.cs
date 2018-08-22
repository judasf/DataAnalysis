using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using System.Data.SqlClient;

public partial class xlqgxxlr : System.Web.UI.Page
{
    private string _pre;
    /// <summary>
    /// 表前缀
    /// </summary>
    public string Pre
    {
        get { return _pre; }
        set { _pre = value + "QG"; }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        Pre = Session["pre"] != null ? Session["pre"].ToString() : "";
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
                //判断角色 为 1，各单位派单人员可以录单
                if(Session["roleid"] == null || Session["roleid"].ToString() != "1")
                    Response.Write("<script type='text/javascript'>alert('权限不足，请重新登陆！');top.location.href='../';</script>");
                //获取编号
            DataSet dr = DirectDataAccessor.QueryForDataSet("SELECT " + Pre + "xxid  FROM autoid");
                string currentId = dr.Tables[0].Rows[0][0].ToString();
                string datePre = DateTime.Now.ToString("yyyyMM");
                if (currentId.Substring(0, 6) == datePre)
                {
                    id.InnerText = Pre + currentId;
                }
                else
                {
                    id.InnerText = Pre + datePre + "001";
                }
                fsdw.InnerText = Session["deptname"].ToString();
                fssj.InnerText = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            }
        }
    }
   

    protected void Button1_Click(object sender, EventArgs e)
    {
        StringBuilder sql = new StringBuilder();
        //保存信息
        sql.Append("insert into xlqgxx(id,fssj,fsdw,lxr,lxdh,sy,ysje) values(");
        sql.Append("@id,@fssj,@fsdw,@lxr,@lxdh,@sy,@ysje);");
        //现场照片
        string filesStr = report.Value;
        //保存附件列表
        if (!string.IsNullOrEmpty(filesStr))
        {
            string[] filesPath = filesStr.Split(new String[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            foreach (string path in filesPath)
            {
                string fileName = path.Substring(path.LastIndexOf('/') + 1);
                sql.Append("Insert into Attachment_BDAndQX values(@id,'" + fileName + "','" + path + "',0);");
            }
        }
        //更新编号
        sql.Append("Update autoid set " + Pre + "xxid=" + (int.Parse(id.InnerText.Substring(Pre.Length)) + 1));
        //设定参数
        List<SqlParameter> _paras = new List<SqlParameter>();
        _paras.Add(new SqlParameter("@id", id.InnerText));
        _paras.Add(new SqlParameter("@fssj", fssj.InnerText));
        _paras.Add(new SqlParameter("@fsdw", fsdw.InnerText));
        _paras.Add(new SqlParameter("@lxr", lxr.Text));
        _paras.Add(new SqlParameter("@lxdh", lxdh.Text));
        _paras.Add(new SqlParameter("@sy", sy.Text));
        _paras.Add(new SqlParameter("@ysje", ysje.Text));
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
                    ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('迁改信息录入成功！');location.href=location.href;", true);
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
