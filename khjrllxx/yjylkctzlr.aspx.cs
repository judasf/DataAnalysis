using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class yjylkctzlr : System.Web.UI.Page
{
    private string _pre;
    /// <summary>
    /// 表前缀
    /// </summary>
    public string Pre
    {
        get { return _pre; }
        set { _pre = value + "KHJR"; }
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
                //获取编号
                if (Request.QueryString["id"] != null)
                {
                    id.InnerText = Request.QueryString["id"].ToString();
                }
                else
                {
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
                }
                ckdw.InnerText = Session["deptname"].ToString();
                if (Request.QueryString["cksj"] != null)
                {
                    cksj.InnerText = Request.QueryString["cksj"].ToString();
                }
                else
                    cksj.InnerText = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
               
                if (Request.QueryString["llr"] != null)
                {
                    llr.Text = Server.UrlDecode(Request.QueryString["llr"].ToString());
                    llr.ReadOnly = true;
                }
                BindClass();
                BindType();
                Bindlldw();
                if (Request.QueryString["lldw"] != null)
                {
                    lldw.Text = Server.UrlDecode(Request.QueryString["lldw"].ToString());
                }
            }
        }
    }
    private void BindType()
    {
        string sql = "select typeid,typename from " + Session["pre"].ToString() + "yjylkc_Type where classid =" + ddlClass.SelectedValue;
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        ddlType.Items.Clear();
        ddlType.Items.Add(new ListItem("请选择型号", "0"));
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            ddlType.Items.Add(new ListItem(dr[1].ToString(), dr[0].ToString()));
        }
       
    }
    
    /// <summary>
    /// 绑定类别
    /// </summary>
        private void BindClass()
        {
            string sql = "select *  from " + Session["pre"].ToString() + "yjylkc_Class  where classname='客户接入'";

            DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                ddlClass.Items.Add(new ListItem(dr[1].ToString(), dr[0].ToString()));
            }
        }
     
    /// <summary>
    /// 绑定领料单位
    /// </summary>
    private void Bindlldw()
        {
            string sql = "select unitname from  UnitAndDeptRelation where deptname ='" + Session["deptname"] + "'";
            DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
            lldw.Items.Clear();
            lldw.Items.Add(new ListItem("选择领料单位", "0"));
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                lldw.Items.Add(new ListItem(dr[0].ToString(), dr[0].ToString()));
            }
        }
    protected void Button1_Click(object sender, EventArgs e)
    {

        string sql;
        if (PanHaoShow(ddlClass.SelectedItem.Text ,ddlType.SelectedItem.Text))
        {
             sql = "insert into yjylkc_llmx values('" + id.InnerText+ "','" + cksj.InnerText + "','" + lldw.Text + "','" + llr.Text + "','" + ddlClass.SelectedItem.Text + "',";
            sql += "'" + ddlType.SelectedItem.Text + "','" + ddlPanhao.SelectedItem.Text + "','" + amount.Text + "','" + units1.InnerHtml + "','" + yldz.Text + "','" + llyt.Text + "','" + bz.Text + "','"+ckdw.InnerText+"'); ";
            sql += "update " + Session["pre"].ToString() + "yjylkc_kcmx set amount=amount-" + amount.Text + " where classname='" + ddlClass.SelectedItem.Text + "' and typename ='" + ddlType.SelectedItem.Text + "' and panhao='" + ddlPanhao.SelectedItem.Text + "' ; ";

        }
        else
        {
             sql = "insert into yjylkc_llmx values('" + id.InnerText + "','" + cksj.InnerText + "','" + lldw.Text + "','" + llr.Text + "','" + ddlClass.SelectedItem.Text + "',";
             sql += "'" + ddlType.SelectedItem.Text + "','','" + amount.Text + "','" + units1.InnerHtml + "','" + yldz.Text + "','" + llyt.Text + "','" + bz.Text + "','" + ckdw.InnerText + "'); ";
            sql += "update " + Session["pre"].ToString() + "yjylkc_kcmx set amount=amount-" + amount.Text + " where classname='" + ddlClass.SelectedItem.Text + "' and typename ='" + ddlType.SelectedItem.Text + "'; ";
        }
        sql += "Update autoid set  " + Pre + "xxid=" + (int.Parse(id.InnerText.Substring(Pre.Length)) + 1);
        //写入sql日志
        DirectDataAccessor.writeLog("KHJR", Session["pre"].ToString() == "" ? "SQ_" : Session["pre"].ToString(), sql.ToString());

        DirectDataAccessor.Execute(sql);

      string script = "if (confirm('领料成功！是否继续领料？\\n点击确定继续领料，点击取消返回信息管理页面')){location.href=\"";
      script += "yjylkctzlr.aspx?cksj=" + cksj.InnerText + "&lldw=" +Server.UrlEncode(lldw.Text) + "&llr=" +Server.UrlEncode(llr.Text) + "&id=" + id.InnerText + "\";}";
      script += "else{location.href=\"yjylkctzgl.aspx\";}";
      ClientScript.RegisterStartupScript(this.GetType(), "info", script, true);
    
	}
    protected void ddlType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlType.SelectedValue != "0")
        {
            //无盘号时：
            if (!PanHaoShow(ddlClass.SelectedItem.Text, ddlType.SelectedItem.Text))
            {
                //隐藏盘号
                trPanhao.Attributes.CssStyle["display"] = "none";
                string sql = "select units,amount from " + Session["pre"].ToString() + "yjylkc_kcmx where classname='" + ddlClass.SelectedItem.Text + "' and typename ='" + ddlType.SelectedItem.Text + "'";
                DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    units1.InnerText = units2.InnerText = units3.InnerText = ds.Tables[0].Rows[0][0].ToString();
                    kcamount.Text = ds.Tables[0].Rows[0][1].ToString();
                }
                else
                {
                    units1.InnerText = units2.InnerText = units3.InnerText = "";
                    kcamount.Text = "0";
                }

            }
            else
            {
                trPanhao.Attributes.CssStyle["display"] = "";
                string sql = "select isnull(sum(amount),0) from " + Session["pre"].ToString() + "yjylkc_kcmx where classname='" + ddlClass.SelectedItem.Text + "' and typename ='" + ddlType.SelectedItem.Text + "'";
               DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
                kcamount.Text = ds.Tables[0].Rows[0][0].ToString();
                sql = "select panhao,amount ,units,id from  " + Session["pre"].ToString() + "yjylkc_kcmx where classname='" + ddlClass.SelectedItem.Text + "' and typename ='" + ddlType.SelectedItem.Text + "'";
                ds = DirectDataAccessor.QueryForDataSet(sql);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    units1.InnerText = units2.InnerText = units3.InnerText = ds.Tables[0].Rows[0][2].ToString();
                    ddlPanhao.Items.Clear();
                    ddlPanhao.Items.Add(new ListItem("请选择盘号", "0"));
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        ddlPanhao.Items.Add(new ListItem(dr[0].ToString(), dr[3].ToString()));
                    }

                }
                else
                {
                    units1.InnerText = units2.InnerText = units3.InnerText = "";
                    phkc.Text = "0";
                }
            }
           
        }
        else
            units1.InnerText = units2.InnerText =units3.InnerText= "";
    }

    protected void ddlPanhao_SelectedIndexChanged(object sender, EventArgs e)
    {
        string sql = "select amount from " + Session["pre"].ToString() + "yjylkc_kcmx where id=" + ddlPanhao.Text;
        phkc.Text = SqlHelper.ExecuteScalar(SqlHelper.GetConnection(), CommandType.Text, sql).ToString();
    }
    /// <summary>
    /// 判断是否显示盘号
    /// </summary>
    /// <param name="classname"></param>
    /// <param name="typename"></param>
    /// <returns></returns>
    public bool PanHaoShow(string classname, string typename)
    {
        bool flag = false;
        string sql = "select isnull(panhao,'')  from " + Session["pre"].ToString() + "yjylkc_kcmx where classname='" + classname + "' and typename='" + typename + "'";
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        if (ds.Tables[0].Rows.Count > 0)
        {
            if (ds.Tables[0].Rows[0][0].ToString().Trim() != "")
                flag = true;
        }
        return flag;
    }
}
