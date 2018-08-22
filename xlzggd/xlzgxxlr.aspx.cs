using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class xlzgxxlr : System.Web.UI.Page
{
    private string _pre;
    /// <summary>
    /// 表前缀
    /// </summary>
    public string Pre
    {
        get { return _pre; }
        set { _pre = value + "ZG"; }
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
                if (Session["roleid"] == null || Session["roleid"].ToString() != "1")
                    Response.Write("<script type='text/javascript'>alert('权限不足，请重新登陆！');top.location.href='../';</script>");
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
                pdr.InnerText = Session["uname"].ToString();
                pfdw.InnerText = Session["deptname"].ToString();
                pdsj.InnerText = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                BindWhdw();
            }
        }
    }
    /// <summary>
    /// 绑定维护单位
    /// </summary>
    private void BindWhdw()
    {
        //DataSet ds = DirectDataAccessor.QueryForDataSet("select deptname from userinfo where roleid=3 and tablepre='"+Session["pre"].ToString()+"'");
        //whdw.Items.Add(new ListItem("请选择维护单位", "0"));
        //foreach (DataRow dr in ds.Tables[0].Rows)
        //{
        //    whdw.Items.Add(dr[0].ToString());
        //}
        whdw.Items.Add("设计院");
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        List<SqlParameter> _paras = new List<SqlParameter>();
        _paras.Add(new SqlParameter("@id", id.InnerText));
        _paras.Add(new SqlParameter("@whdw", whdw.Text));
        _paras.Add(new SqlParameter("@fzr", fzr.Text));
        _paras.Add(new SqlParameter("@zgqy", zgqy.Text));
        _paras.Add(new SqlParameter("@czwt", czwt.Text));
        _paras.Add(new SqlParameter("@zgyq", zgyq.Text));
        _paras.Add(new SqlParameter("@zgsx", zgsx.Text));
        _paras.Add(new SqlParameter("@pdr", pdr.InnerText));
        _paras.Add(new SqlParameter("@pdsj", pdsj.InnerText));
        _paras.Add(new SqlParameter("@pfdw", Session["deptname"].ToString()));
        _paras.Add(new SqlParameter("@lxr", lxr.Text));
        _paras.Add(new SqlParameter("@lxdh", lxdh.Text));
        _paras.Add(new SqlParameter("@xllx", xllx.Text));
        string sql = "insert into xlzgxx(id,whdw,fzr,zgqy,czwt,zgyq,zgsx,pdr,pdsj,pfdw,lxr,lxdh,xllx) ";
        sql += "values(@id,@whdw,@fzr,@zgqy,@czwt,@zgyq,@zgsx,@pdr,@pdsj,@pfdw,@lxr,@lxdh,@xllx);";
        sql += "Update autoid set  " + Pre + "xxid=" + (int.Parse(id.InnerText.Substring(Pre.Length)) + 1);
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, _paras.ToArray());
        if (result == 2)
            ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('整改通知书派发成功！');location.href=location.href;", true);
        else
            ClientScript.RegisterStartupScript(this.GetType(), "error", "alert('整改通知书派发失败！');", true);


    }
}
