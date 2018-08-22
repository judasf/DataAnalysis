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
        set { _pre = value + "RC"; }
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
                if (Request.QueryString["lldw"] != null)
                {
                    lldw.Text = Server.UrlDecode(Request.QueryString["lldw"].ToString());
                    lldw.ReadOnly = true;
                }
                if (Request.QueryString["llr"] != null)
                {
                    llr.Text = Server.UrlDecode(Request.QueryString["llr"].ToString());
                    llr.ReadOnly = true;
                }
                BindClass();
            }
        }
    }
    /// <summary>
    /// 绑定类别
    /// </summary>
    private void BindClass()
    {
        string sql = "select *  from " + Session["pre"].ToString() + "yjylkc_Class  where classid<8";

        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        ddlClass.Items.Add(new ListItem("请选择类别", "0"));
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            ddlClass.Items.Add(new ListItem(dr[1].ToString(), dr[0].ToString()));
        }
    }
    protected void Button1_Click(object sender, EventArgs e)
    {

        string sql;
        if (ddlClass.SelectedValue == "1" || ddlClass.SelectedValue == "2")
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
            //辅件新增
            if (ddlType1.SelectedValue != "0") 
            {
                sql += "insert into yjylkc_llmx values('" + id.InnerText + "','" + cksj.InnerText + "','" + lldw.Text + "','" + llr.Text + "','" + ddlClass.SelectedItem.Text + "',";
                sql += "'" + ddlType1.SelectedItem.Text + "','','" + amount1.Text + "','" + unitAdd1.InnerHtml + "','" + yldz.Text + "','" + llyt.Text + "','" + bz.Text + "','" + ckdw.InnerText + "'); ";
                sql += "update " + Session["pre"].ToString() + "yjylkc_kcmx set amount=amount-" + amount1.Text + " where classname='" + ddlClass.SelectedItem.Text + "' and typename ='" + ddlType1.SelectedItem.Text + "'; ";
            }
            if (ddlType2.SelectedValue != "0")
            {
                sql += "insert into yjylkc_llmx values('" + id.InnerText + "','" + cksj.InnerText + "','" + lldw.Text + "','" + llr.Text + "','" + ddlClass.SelectedItem.Text + "',";
                sql += "'" + ddlType2.SelectedItem.Text + "','','" + amount2.Text + "','" + unitAdd2.InnerHtml + "','" + yldz.Text + "','" + llyt.Text + "','" + bz.Text + "','" + ckdw.InnerText + "'); ";
                sql += "update " + Session["pre"].ToString() + "yjylkc_kcmx set amount=amount-" + amount2.Text + " where classname='" + ddlClass.SelectedItem.Text + "' and typename ='" + ddlType2.SelectedItem.Text + "'; ";
            }
            if (ddlType3.SelectedValue != "0")
            {
                sql += "insert into yjylkc_llmx values('" + id.InnerText + "','" + cksj.InnerText + "','" + lldw.Text + "','" + llr.Text + "','" + ddlClass.SelectedItem.Text + "',";
                sql += "'" + ddlType3.SelectedItem.Text + "','','" + amount3.Text + "','" + unitAdd3.InnerHtml + "','" + yldz.Text + "','" + llyt.Text + "','" + bz.Text + "','" + ckdw.InnerText + "'); ";
                sql += "update " + Session["pre"].ToString() + "yjylkc_kcmx set amount=amount-" + amount3.Text + " where classname='" + ddlClass.SelectedItem.Text + "' and typename ='" + ddlType3.SelectedItem.Text + "'; ";
            }
        }
        sql += "Update autoid set  " + Pre + "xxid=" + (int.Parse(id.InnerText.Substring(Pre.Length)) + 1);
        //写入sql日志
        DirectDataAccessor.writeLog("RC", Session["pre"].ToString() == "" ? "SQ_" : Session["pre"].ToString(), sql.ToString());

        DirectDataAccessor.Execute(sql);

      string script = "if (confirm('领料成功！是否继续领料？\\n点击确定继续领料，点击取消返回信息管理页面')){location.href=\"";
      script += "yjylkctzlr.aspx?cksj=" + cksj.InnerText + "&lldw=" +Server.UrlEncode(lldw.Text) + "&llr=" +Server.UrlEncode(llr.Text) + "&id=" + id.InnerText + "\";}";
      script += "else{location.href=\"yjylkctzgl.aspx\";}";
      ClientScript.RegisterStartupScript(this.GetType(), "info", script, true);
    
	}
    protected void ddlClass_SelectedIndexChanged(object sender, EventArgs e)
    {
        //判断盘号是否显示
        if (ddlClass.SelectedValue == "1" || ddlClass.SelectedValue == "2")
            trPanhao.Attributes.CssStyle["display"] = "";
        else trPanhao.Attributes.CssStyle["display"] = "none";
        if (ddlClass.SelectedValue == "4")//辅件
        {
            addtr1.Attributes.CssStyle["display"] = "";
            addtr2.Attributes.CssStyle["display"] = "";
            addtr3.Attributes.CssStyle["display"] = "";
            addtr4.Attributes.CssStyle["display"] = "";
            addtr5.Attributes.CssStyle["display"] = "";
            addtr6.Attributes.CssStyle["display"] = "";
        }
        else
        {
            addtr1.Attributes.CssStyle["display"] = "none";
            addtr2.Attributes.CssStyle["display"] = "none";
            addtr3.Attributes.CssStyle["display"] = "none";
            addtr4.Attributes.CssStyle["display"] = "none";
            addtr5.Attributes.CssStyle["display"] = "none";
            addtr6.Attributes.CssStyle["display"] = "none";
        }
        string sql = "select typeid,typename from " + Session["pre"].ToString() + "yjylkc_Type where classid =" + ddlClass.SelectedValue;
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        ddlType.Items.Clear();
        ddlType.Items.Add(new ListItem("请选择型号", "0"));
        if (ddlClass.SelectedValue == "4")//辅件
        {
            ddlType1.Items.Clear();
            ddlType1.Items.Add(new ListItem("请选择型号", "0"));
            ddlType2.Items.Clear();
            ddlType2.Items.Add(new ListItem("请选择型号", "0"));
            ddlType3.Items.Clear();
            ddlType3.Items.Add(new ListItem("请选择型号", "0"));
        }
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            ddlType.Items.Add(new ListItem(dr[1].ToString(), dr[0].ToString()));
            if (ddlClass.SelectedValue == "4")//辅件
            {
            ddlType1.Items.Add(new ListItem(dr[1].ToString(), dr[0].ToString()));
            ddlType2.Items.Add(new ListItem(dr[1].ToString(), dr[0].ToString()));
            ddlType3.Items.Add(new ListItem(dr[1].ToString(), dr[0].ToString()));
            }
        }
    }
    protected void ddlType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlType.SelectedValue != "0")
        {
            //非电缆、光缆时，不考虑盘号问题
            if (ddlClass.SelectedValue != "1" && ddlClass.SelectedValue != "2")
            {
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
            if (ddlClass.SelectedValue == "1" || ddlClass.SelectedValue == "2")
            {
                string sql = "select isnull(sum(amount),0) from " + Session["pre"].ToString() + "yjylkc_kcmx where classname='" + ddlClass.SelectedItem.Text + "' and typename ='" + ddlType.SelectedItem.Text + "'";
               DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
                kcamount.Text = ds.Tables[0].Rows[0][0].ToString();
                sql = "select panhao,amount ,units from  " + Session["pre"].ToString() + "yjylkc_kcmx where classname='" + ddlClass.SelectedItem.Text + "' and typename ='" + ddlType.SelectedItem.Text + "'";
                ds = DirectDataAccessor.QueryForDataSet(sql);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    units1.InnerText = units2.InnerText = units3.InnerText = ds.Tables[0].Rows[0][2].ToString();
                    ddlPanhao.Items.Clear();
                    ddlPanhao.Items.Add(new ListItem("请选择盘号", "0"));
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        ddlPanhao.Items.Add(new ListItem(dr[0].ToString(), dr[1].ToString()));
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
    //附件增加1
    protected void ddlType1_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlType1.SelectedValue != "0")
        {
            string sql = "select units,amount from " + Session["pre"].ToString() + "yjylkc_kcmx where classname='" + ddlClass.SelectedItem.Text + "' and typename ='" + ddlType1.SelectedItem.Text + "'";
                DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    kcamount1.Text = ds.Tables[0].Rows[0][1].ToString();
                    unitAdd1.InnerText = ds.Tables[0].Rows[0][0].ToString();
                }
                else
                {
                    kcamount1.Text = "0";
                    unitAdd1.InnerText = "";
                }
        }
    
    }
    //附件增加2
    protected void ddlType2_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlType2.SelectedValue != "0")
        {
            string sql = "select units,amount from " + Session["pre"].ToString() + "yjylkc_kcmx where classname='" + ddlClass.SelectedItem.Text + "' and typename ='" + ddlType2.SelectedItem.Text + "'";
            DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
            if (ds.Tables[0].Rows.Count > 0)
            {
                kcamount2.Text = ds.Tables[0].Rows[0][1].ToString();
                unitAdd2.InnerText = ds.Tables[0].Rows[0][0].ToString();
            }
            else
            {
                kcamount2.Text = "0";
                unitAdd2.InnerText = "";
            }
        }

    }
    //附件增加3
    protected void ddlType3_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlType3.SelectedValue != "0")
        {
            string sql = "select units,amount from " + Session["pre"].ToString() + "yjylkc_kcmx where classname='" + ddlClass.SelectedItem.Text + "' and typename ='" + ddlType3.SelectedItem.Text + "'";
            DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
            if (ds.Tables[0].Rows.Count > 0)
            {
                kcamount3.Text = ds.Tables[0].Rows[0][1].ToString();
                unitAdd3.InnerText = ds.Tables[0].Rows[0][0].ToString();
            }
            else
            {
                kcamount3.Text = "0";
                unitAdd3.InnerText = "";
            }
        }

    }
    protected void ddlPanhao_SelectedIndexChanged(object sender, EventArgs e)
    {
        phkc.Text = ddlPanhao.Text;
    }
}
