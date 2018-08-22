using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;

public partial class xlzgxxlllr : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "" || Session["pre"]==null)
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
                //角色判断，7：区域维护有权领料;针对县公司派单人领料 权限 1
                if (Session["roleid"] == null || Session["roleid"].ToString() != "7" && Session["roleid"].ToString() != "1")
                    Response.Write("<script type='text/javascript'>alert('您没有对应的权限，请重新登陆！');top.location.href='../';</script>");
                if (Request.QueryString["id"] == null)
                {
                    Response.Write("参数错误！");
                    Response.End();
                }
                else
                {
                    zgid.InnerText = Request.QueryString["id"].ToString();
                    DataSet ds = DirectDataAccessor.QueryForDataSet("select * from dlysxx where id='" + Request.QueryString["id"].ToString() + "'");
                    if (ds.Tables[0].Rows.Count < 1)
                    {
                        Response.Write("参数错误！");
                        Response.End();
                    }
                    else
                    {
                        pfdw.InnerHtml = ds.Tables[0].Rows[0]["pfdw"].ToString();
                        pdr.InnerHtml = ds.Tables[0].Rows[0]["pdr"].ToString();
                        pdsj.InnerHtml = ds.Tables[0].Rows[0]["pdsj"].ToString();
                        whdw.InnerHtml = ds.Tables[0].Rows[0]["whdw"].ToString();
                        fzr.InnerHtml = ds.Tables[0].Rows[0]["fzr"].ToString();
                        lxr.InnerHtml = ds.Tables[0].Rows[0]["lxr"].ToString();
                        lxrdh.InnerHtml = ds.Tables[0].Rows[0]["lxdh"].ToString();
                        lldw.Text = Session["uname"].ToString();
                        if (Request.QueryString["cksj"] != null)
                        {
                            cksj.Text = Request.QueryString["cksj"].ToString();
                        }
                        else
                            cksj.Text = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                       
                        if (Request.QueryString["llr"] != null)
                        {
                            llr.Text = Server.UrlDecode(Request.QueryString["llr"].ToString());
                            llr.ReadOnly = true;
                        }
                        if (Request.QueryString["lxdh"] != null)
                        {
                            lxdh.Text = Request.QueryString["lxdh"].ToString();
                            lxdh.ReadOnly = true;
                        }
                    }
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
        ddlClass1.Items.Add(new ListItem("请选择类别", "0"));
        ddlClass2.Items.Add(new ListItem("请选择类别", "0"));
        ddlClass3.Items.Add(new ListItem("请选择类别", "0"));
        ddlClass4.Items.Add(new ListItem("请选择类别", "0"));
        ddlClass5.Items.Add(new ListItem("请选择类别", "0"));
        ddlClass6.Items.Add(new ListItem("请选择类别", "0"));
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            ddlClass1.Items.Add(new ListItem(dr[1].ToString(), dr[0].ToString()));
            ddlClass2.Items.Add(new ListItem(dr[1].ToString(), dr[0].ToString()));
            ddlClass3.Items.Add(new ListItem(dr[1].ToString(), dr[0].ToString()));
            ddlClass4.Items.Add(new ListItem(dr[1].ToString(), dr[0].ToString()));
            ddlClass5.Items.Add(new ListItem(dr[1].ToString(), dr[0].ToString()));
            ddlClass6.Items.Add(new ListItem(dr[1].ToString(), dr[0].ToString()));
        }
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        StringBuilder sql = new StringBuilder();
        //处理领料内容1
        if (ddlClass1.SelectedValue == "1" || ddlClass1.SelectedValue == "2")
        {
            sql.Append("insert into dlysxx_llmx values('" + zgid.InnerText + "','" + cksj.Text + "','" + lldw.Text + "','" + llr.Text + "','" + lxdh.Text + "','" + ddlClass1.SelectedItem.Text + "',");
            sql.Append("'" + ddlType1.SelectedItem.Text + "','" + ddlPanhao1.SelectedItem.Text + "','" + amount1.Text + "','" + units1_1.InnerHtml + "');");

        }
        else
        {
            sql.Append("insert into dlysxx_llmx values('" + zgid.InnerText + "','" + cksj.Text + "','" + lldw.Text + "','" + llr.Text + "','" + lxdh.Text + "','" + ddlClass1.SelectedItem.Text + "',");
            sql.Append("'" + ddlType1.SelectedItem.Text + "','','" + amount1.Text + "','" + units1_1.InnerHtml + "'); ");
        }
        //处理领料内容2
        if (ddlClass2.SelectedValue != "0")
        {
            if (ddlClass2.SelectedValue == "1" || ddlClass2.SelectedValue == "2")
            {
                sql.Append("insert into dlysxx_llmx values('" + zgid.InnerText + "','" + cksj.Text + "','" + lldw.Text + "','" + llr.Text + "','" + lxdh.Text + "','" + ddlClass2.SelectedItem.Text + "',");
                sql.Append("'" + ddlType2.SelectedItem.Text + "','" + ddlPanhao2.SelectedItem.Text + "','" + amount2.Text + "','" + units2_1.InnerHtml + "');");
            }
            else
            {
                sql.Append("insert into dlysxx_llmx values('" + zgid.InnerText + "','" + cksj.Text + "','" + lldw.Text + "','" + llr.Text + "','" + lxdh.Text + "','" + ddlClass2.SelectedItem.Text + "',");
                sql.Append("'" + ddlType2.SelectedItem.Text + "','','" + amount2.Text + "','" + units2_1.InnerHtml + "'); ");
            }
        }
        //处理领料内容3
        if (ddlClass3.SelectedValue != "0")
        {
            if (ddlClass3.SelectedValue == "1" || ddlClass3.SelectedValue == "2")
            {
                sql.Append("insert into dlysxx_llmx values('" + zgid.InnerText + "','" + cksj.Text + "','" + lldw.Text + "','" + llr.Text + "','" + lxdh.Text + "','" + ddlClass3.SelectedItem.Text + "',");
                sql.Append("'" + ddlType3.SelectedItem.Text + "','" + ddlPanhao3.SelectedItem.Text + "','" + amount3.Text + "','" + units3_1.InnerHtml + "');");
            }
            else
            {
                sql.Append("insert into dlysxx_llmx values('" + zgid.InnerText + "','" + cksj.Text + "','" + lldw.Text + "','" + llr.Text + "','" + lxdh.Text + "','" + ddlClass3.SelectedItem.Text + "',");
                sql.Append("'" + ddlType3.SelectedItem.Text + "','','" + amount3.Text + "','" + units3_1.InnerHtml + "'); ");
            }
        }
        //处理领料内容4
        if (ddlClass4.SelectedValue != "0")
        {
            if (ddlClass4.SelectedValue == "1" || ddlClass4.SelectedValue == "2")
            {
                sql.Append("insert into dlysxx_llmx values('" + zgid.InnerText + "','" + cksj.Text + "','" + lldw.Text + "','" + llr.Text + "','" + lxdh.Text + "','" + ddlClass4.SelectedItem.Text + "',");
                sql.Append("'" + ddlType4.SelectedItem.Text + "','" + ddlPanhao4.SelectedItem.Text + "','" + amount4.Text + "','" + units4_1.InnerHtml + "');");
            }
            else
            {
                sql.Append("insert into dlysxx_llmx values('" + zgid.InnerText + "','" + cksj.Text + "','" + lldw.Text + "','" + llr.Text + "','" + lxdh.Text + "','" + ddlClass4.SelectedItem.Text + "',");
                sql.Append("'" + ddlType4.SelectedItem.Text + "','','" + amount4.Text + "','" + units4_1.InnerHtml + "'); ");
            }
        }
        //处理领料内容5
        if (ddlClass5.SelectedValue != "0")
        {
            if (ddlClass5.SelectedValue == "1" || ddlClass5.SelectedValue == "2")
            {
                sql.Append("insert into dlysxx_llmx values('" + zgid.InnerText + "','" + cksj.Text + "','" + lldw.Text + "','" + llr.Text + "','" + lxdh.Text + "','" + ddlClass5.SelectedItem.Text + "',");
                sql.Append("'" + ddlType5.SelectedItem.Text + "','" + ddlPanhao5.SelectedItem.Text + "','" + amount5.Text + "','" + units5_1.InnerHtml + "');");

            }
            else
            {
                sql.Append("insert into dlysxx_llmx values('" + zgid.InnerText + "','" + cksj.Text + "','" + lldw.Text + "','" + llr.Text + "','" + lxdh.Text + "','" + ddlClass5.SelectedItem.Text + "',");
                sql.Append("'" + ddlType5.SelectedItem.Text + "','','" + amount5.Text + "','" + units5_1.InnerHtml + "'); ");
            }
        }
        //处理领料内容6
        if (ddlClass6.SelectedValue != "0")
        {
            if (ddlClass6.SelectedValue == "1" || ddlClass6.SelectedValue == "2")
            {
                sql.Append("insert into dlysxx_llmx values('" + zgid.InnerText + "','" + cksj.Text + "','" + lldw.Text + "','" + llr.Text + "','" + lxdh.Text + "','" + ddlClass6.SelectedItem.Text + "',");
                sql.Append("'" + ddlType6.SelectedItem.Text + "','" + ddlPanhao6.SelectedItem.Text + "','" + amount6.Text + "','" + units6_1.InnerHtml + "');");
            }
            else
            {
                sql.Append("insert into dlysxx_llmx values('" + zgid.InnerText + "','" + cksj.Text + "','" + lldw.Text + "','" + llr.Text + "','" + lxdh.Text + "','" + ddlClass6.SelectedItem.Text + "',");
                sql.Append("'" + ddlType6.SelectedItem.Text + "','','" + amount6.Text + "','" + units6_1.InnerHtml + "'); ");
            }
        }
        //写入sql日志
        DirectDataAccessor.writeLog("DLYS_GD", Session["pre"].ToString() == "" ? "SQ_" : Session["pre"].ToString(), sql.ToString());
        DirectDataAccessor.Execute(sql.ToString());
        //设置被盗信息领料状态
        DirectDataAccessor.Execute("update dlysxx set zgll=1 where id='" + zgid.InnerText + "'");
        string script = "if (confirm('领料成功！是否继续领料？\\n点击确定继续领料，点击取消返回信息管理页面')){location.href=\"";
        script += "xlzgxxlllr.aspx?id=" + zgid.InnerText + "&cksj=" + cksj.Text + "&llr=" +Server.UrlEncode(llr.Text) + "&lxdh=" + lxdh.Text + "\";}";
        if (Session["pre"] != null && Session["pre"].ToString().Trim() == "")
            script += "else{location.href=\"xlzgxxgl.aspx\";}";
        if (Session["pre"] != null && Session["pre"].ToString().Trim() != "")
            script += "else{location.href=\"xlzgxxgl_town.aspx\";}";
        ClientScript.RegisterStartupScript(this.GetType(), "info", script, true);

    }
    protected void ddlClass1_SelectedIndexChanged(object sender, EventArgs e)
    {
        ////判断盘号是否显示
        if (ddlClass1.SelectedValue == "1" || ddlClass1.SelectedValue == "2")
            trPanhao1.Attributes.CssStyle["display"] = "";
        else trPanhao1.Attributes.CssStyle["display"] = "none";

        string sql = "select typeid,typename from " + Session["pre"].ToString() + "yjylkc_Type where classid =" + ddlClass1.SelectedValue;
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        ddlType1.Items.Clear();
        ddlType1.Items.Add(new ListItem("请选择型号", "0"));
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            ddlType1.Items.Add(new ListItem(dr[1].ToString(), dr[0].ToString()));
        }
    }
    protected void ddlType1_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlType1.SelectedValue != "0")
        {
            //非电缆、光缆时，不考虑盘号问题
            if (ddlClass1.SelectedValue != "1" && ddlClass1.SelectedValue != "2")
            {
                string sql = "select units,amount from " + Session["pre"].ToString() + "yjylkc_kcmx where classname='" + ddlClass1.SelectedItem.Text + "' and typename ='" + ddlType1.SelectedItem.Text + "'";
                DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    units1_1.InnerText = units1_2.InnerText = units1_3.InnerText = ds.Tables[0].Rows[0][0].ToString();
                    kcamount1.Text = ds.Tables[0].Rows[0][1].ToString();
                }
                else
                {
                    units1_1.InnerText = units1_2.InnerText = units1_3.InnerText = "";
                    kcamount1.Text = "0";
                }

            }
            if (ddlClass1.SelectedValue == "1" || ddlClass1.SelectedValue == "2")
            {
                string sql = "select isnull(sum(amount),0) from " + Session["pre"].ToString() + "yjylkc_kcmx where classname='" + ddlClass1.SelectedItem.Text + "' and typename ='" + ddlType1.SelectedItem.Text + "'";
                DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
                kcamount1.Text = ds.Tables[0].Rows[0][0].ToString();
                sql = "select panhao,amount ,units from  " + Session["pre"].ToString() + "yjylkc_kcmx where amount<>0 and classname='" + ddlClass1.SelectedItem.Text + "' and typename ='" + ddlType1.SelectedItem.Text + "'";
                ds = DirectDataAccessor.QueryForDataSet(sql);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    units1_1.InnerText = units1_2.InnerText = units1_3.InnerText = ds.Tables[0].Rows[0][2].ToString();
                    ddlPanhao1.Items.Clear();
                    ddlPanhao1.Items.Add(new ListItem("请选择盘号", "0"));
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        ddlPanhao1.Items.Add(new ListItem(dr[0].ToString(), dr[1].ToString()));
                    }

                }
                else
                {
                    units1_1.InnerText = units1_2.InnerText = units1_3.InnerText = "";
                    phkc1.Text = "0";
                }
            }

        }
        else
            units1_1.InnerText = units1_2.InnerText = units1_3.InnerText = "";
    }

    protected void ddlPanhao1_SelectedIndexChanged(object sender, EventArgs e)
    {
        phkc1.Text = ddlPanhao1.Text;
    }
    //领料内容2
    protected void ddlClass2_SelectedIndexChanged(object sender, EventArgs e)
    {
        ////判断盘号是否显示
        if (ddlClass2.SelectedValue == "1" || ddlClass2.SelectedValue == "2")
            trPanhao2.Attributes.CssStyle["display"] = "";
        else trPanhao2.Attributes.CssStyle["display"] = "none";

        string sql = "select typeid,typename from " + Session["pre"].ToString() + "yjylkc_Type where classid =" + ddlClass2.SelectedValue;
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        ddlType2.Items.Clear();
        ddlType2.Items.Add(new ListItem("请选择型号", "0"));
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            ddlType2.Items.Add(new ListItem(dr[1].ToString(), dr[0].ToString()));
        }

    }
    protected void ddlType2_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlType2.SelectedValue != "0")
        {
            //非电缆、光缆时，不考虑盘号问题
            if (ddlClass2.SelectedValue != "1" && ddlClass2.SelectedValue != "2")
            {
                string sql = "select units,amount from " + Session["pre"].ToString() + "yjylkc_kcmx where classname='" + ddlClass2.SelectedItem.Text + "' and typename ='" + ddlType2.SelectedItem.Text + "'";
                DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    units2_1.InnerText = units2_2.InnerText = units2_3.InnerText = ds.Tables[0].Rows[0][0].ToString();
                    kcamount2.Text = ds.Tables[0].Rows[0][1].ToString();
                }
                else
                {
                    units2_1.InnerText = units2_2.InnerText = units2_3.InnerText = "";
                    kcamount2.Text = "0";
                }

            }
            if (ddlClass2.SelectedValue == "1" || ddlClass2.SelectedValue == "2")
            {
                string sql = "select isnull(sum(amount),0) from " + Session["pre"].ToString() + "yjylkc_kcmx where classname='" + ddlClass2.SelectedItem.Text + "' and typename ='" + ddlType2.SelectedItem.Text + "'";
                DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
                kcamount2.Text = ds.Tables[0].Rows[0][0].ToString();
                sql = "select panhao,amount ,units from  " + Session["pre"].ToString() + "yjylkc_kcmx where amount<>0 and classname='" + ddlClass2.SelectedItem.Text + "' and typename ='" + ddlType2.SelectedItem.Text + "'";
                ds = DirectDataAccessor.QueryForDataSet(sql);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    units2_1.InnerText = units2_2.InnerText = units2_3.InnerText = ds.Tables[0].Rows[0][2].ToString();
                    ddlPanhao2.Items.Clear();
                    ddlPanhao2.Items.Add(new ListItem("请选择盘号", "0"));
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        ddlPanhao2.Items.Add(new ListItem(dr[0].ToString(), dr[1].ToString()));
                    }

                }
                else
                {
                    units2_1.InnerText = units2_2.InnerText = units2_3.InnerText = "";
                    phkc2.Text = "0";
                }
            }

        }
        else
            units2_1.InnerText = units2_2.InnerText = units2_3.InnerText = "";
    }
    protected void ddlPanhao2_SelectedIndexChanged(object sender, EventArgs e)
    {
        phkc2.Text = ddlPanhao2.Text;
    }
    //领料内容3
    protected void ddlClass3_SelectedIndexChanged(object sender, EventArgs e)
    {
        ////判断盘号是否显示
        if (ddlClass3.SelectedValue == "1" || ddlClass3.SelectedValue == "2")
            trPanhao3.Attributes.CssStyle["display"] = "";
        else trPanhao3.Attributes.CssStyle["display"] = "none";

        string sql = "select typeid,typename from " + Session["pre"].ToString() + "yjylkc_Type where classid =" + ddlClass3.SelectedValue;
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        ddlType3.Items.Clear();
        ddlType3.Items.Add(new ListItem("请选择型号", "0"));
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            ddlType3.Items.Add(new ListItem(dr[1].ToString(), dr[0].ToString()));
        }

    }
    protected void ddlType3_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlType3.SelectedValue != "0")
        {
            //非电缆、光缆时，不考虑盘号问题
            if (ddlClass3.SelectedValue != "1" && ddlClass3.SelectedValue != "2")
            {
                string sql = "select units,amount from " + Session["pre"].ToString() + "yjylkc_kcmx where classname='" + ddlClass3.SelectedItem.Text + "' and typename ='" + ddlType3.SelectedItem.Text + "'";
                DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    units3_1.InnerText = units3_2.InnerText = units3_3.InnerText = ds.Tables[0].Rows[0][0].ToString();
                    kcamount3.Text = ds.Tables[0].Rows[0][1].ToString();
                }
                else
                {
                    units3_1.InnerText = units3_2.InnerText = units3_3.InnerText = "";
                    kcamount3.Text = "0";
                }

            }
            if (ddlClass3.SelectedValue == "1" || ddlClass3.SelectedValue == "2")
            {
                string sql = "select isnull(sum(amount),0) from " + Session["pre"].ToString() + "yjylkc_kcmx where classname='" + ddlClass3.SelectedItem.Text + "' and typename ='" + ddlType3.SelectedItem.Text + "'";
                DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
                kcamount3.Text = ds.Tables[0].Rows[0][0].ToString();
                sql = "select panhao,amount ,units from  " + Session["pre"].ToString() + "yjylkc_kcmx where amount<>0 and classname='" + ddlClass3.SelectedItem.Text + "' and typename ='" + ddlType3.SelectedItem.Text + "'";
                ds = DirectDataAccessor.QueryForDataSet(sql);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    units3_1.InnerText = units3_2.InnerText = units3_3.InnerText = ds.Tables[0].Rows[0][2].ToString();
                    ddlPanhao3.Items.Clear();
                    ddlPanhao3.Items.Add(new ListItem("请选择盘号", "0"));
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        ddlPanhao3.Items.Add(new ListItem(dr[0].ToString(), dr[1].ToString()));
                    }

                }
                else
                {
                    units3_1.InnerText = units3_2.InnerText = units3_3.InnerText = "";
                    phkc3.Text = "0";
                }
            }

        }
        else
            units3_1.InnerText = units3_2.InnerText = units3_3.InnerText = "";
    }
    protected void ddlPanhao3_SelectedIndexChanged(object sender, EventArgs e)
    {
        phkc3.Text = ddlPanhao3.Text;
    }
    //领料内容4
    protected void ddlClass4_SelectedIndexChanged(object sender, EventArgs e)
    {
        ////判断盘号是否显示
        if (ddlClass4.SelectedValue == "1" || ddlClass4.SelectedValue == "2")
            trPanhao4.Attributes.CssStyle["display"] = "";
        else trPanhao4.Attributes.CssStyle["display"] = "none";

        string sql = "select typeid,typename from " + Session["pre"].ToString() + "yjylkc_Type where classid =" + ddlClass4.SelectedValue;
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        ddlType4.Items.Clear();
        ddlType4.Items.Add(new ListItem("请选择型号", "0"));
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            ddlType4.Items.Add(new ListItem(dr[1].ToString(), dr[0].ToString()));
        }

    }
    protected void ddlType4_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlType4.SelectedValue != "0")
        {
            //非电缆、光缆时，不考虑盘号问题
            if (ddlClass4.SelectedValue != "1" && ddlClass4.SelectedValue != "2")
            {
                string sql = "select units,amount from " + Session["pre"].ToString() + "yjylkc_kcmx where classname='" + ddlClass4.SelectedItem.Text + "' and typename ='" + ddlType4.SelectedItem.Text + "'";
                DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    units4_1.InnerText = units4_2.InnerText = units4_3.InnerText = ds.Tables[0].Rows[0][0].ToString();
                    kcamount4.Text = ds.Tables[0].Rows[0][1].ToString();
                }
                else
                {
                    units4_1.InnerText = units4_2.InnerText = units4_3.InnerText = "";
                    kcamount4.Text = "0";
                }

            }
            if (ddlClass4.SelectedValue == "1" || ddlClass4.SelectedValue == "2")
            {
                string sql = "select isnull(sum(amount),0) from " + Session["pre"].ToString() + "yjylkc_kcmx where classname='" + ddlClass4.SelectedItem.Text + "' and typename ='" + ddlType4.SelectedItem.Text + "'";
                DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
                kcamount4.Text = ds.Tables[0].Rows[0][0].ToString();
                sql = "select panhao,amount ,units from  " + Session["pre"].ToString() + "yjylkc_kcmx where amount<>0 and classname='" + ddlClass4.SelectedItem.Text + "' and typename ='" + ddlType4.SelectedItem.Text + "'";
                ds = DirectDataAccessor.QueryForDataSet(sql);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    units4_1.InnerText = units4_2.InnerText = units4_3.InnerText = ds.Tables[0].Rows[0][2].ToString();
                    ddlPanhao4.Items.Clear();
                    ddlPanhao4.Items.Add(new ListItem("请选择盘号", "0"));
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        ddlPanhao4.Items.Add(new ListItem(dr[0].ToString(), dr[1].ToString()));
                    }

                }
                else
                {
                    units4_1.InnerText = units4_2.InnerText = units4_3.InnerText = "";
                    phkc4.Text = "0";
                }
            }

        }
        else
            units4_1.InnerText = units4_2.InnerText = units4_3.InnerText = "";
    }
    protected void ddlPanhao4_SelectedIndexChanged(object sender, EventArgs e)
    {
        phkc4.Text = ddlPanhao4.Text;
    }
    //领料内容5
    protected void ddlClass5_SelectedIndexChanged(object sender, EventArgs e)
    {
        ////判断盘号是否显示
        if (ddlClass5.SelectedValue == "1" || ddlClass5.SelectedValue == "2")
            trPanhao5.Attributes.CssStyle["display"] = "";
        else trPanhao5.Attributes.CssStyle["display"] = "none";

        string sql = "select typeid,typename from " + Session["pre"].ToString() + "yjylkc_Type where classid =" + ddlClass5.SelectedValue;
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        ddlType5.Items.Clear();
        ddlType5.Items.Add(new ListItem("请选择型号", "0"));
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            ddlType5.Items.Add(new ListItem(dr[1].ToString(), dr[0].ToString()));
        }

    }
    protected void ddlType5_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlType5.SelectedValue != "0")
        {
            //非电缆、光缆时，不考虑盘号问题
            if (ddlClass5.SelectedValue != "1" && ddlClass5.SelectedValue != "2")
            {
                string sql = "select units,amount from " + Session["pre"].ToString() + "yjylkc_kcmx where classname='" + ddlClass5.SelectedItem.Text + "' and typename ='" + ddlType5.SelectedItem.Text + "'";
                DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    units5_1.InnerText = units5_2.InnerText = units5_3.InnerText = ds.Tables[0].Rows[0][0].ToString();
                    kcamount5.Text = ds.Tables[0].Rows[0][1].ToString();
                }
                else
                {
                    units5_1.InnerText = units5_2.InnerText = units5_3.InnerText = "";
                    kcamount5.Text = "0";
                }

            }
            if (ddlClass5.SelectedValue == "1" || ddlClass5.SelectedValue == "2")
            {
                string sql = "select isnull(sum(amount),0) from " + Session["pre"].ToString() + "yjylkc_kcmx where classname='" + ddlClass5.SelectedItem.Text + "' and typename ='" + ddlType5.SelectedItem.Text + "'";
                DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
                kcamount5.Text = ds.Tables[0].Rows[0][0].ToString();
                sql = "select panhao,amount ,units from  " + Session["pre"].ToString() + "yjylkc_kcmx where amount<>0 and classname='" + ddlClass5.SelectedItem.Text + "' and typename ='" + ddlType5.SelectedItem.Text + "'";
                ds = DirectDataAccessor.QueryForDataSet(sql);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    units5_1.InnerText = units5_2.InnerText = units5_3.InnerText = ds.Tables[0].Rows[0][2].ToString();
                    ddlPanhao5.Items.Clear();
                    ddlPanhao5.Items.Add(new ListItem("请选择盘号", "0"));
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        ddlPanhao5.Items.Add(new ListItem(dr[0].ToString(), dr[1].ToString()));
                    }

                }
                else
                {
                    units5_1.InnerText = units5_2.InnerText = units5_3.InnerText = "";
                    phkc5.Text = "0";
                }
            }

        }
        else
            units5_1.InnerText = units5_2.InnerText = units5_3.InnerText = "";
    }
    protected void ddlPanhao5_SelectedIndexChanged(object sender, EventArgs e)
    {
        phkc5.Text = ddlPanhao5.Text;
    }
    //领料内容6
    protected void ddlClass6_SelectedIndexChanged(object sender, EventArgs e)
    {
        ////判断盘号是否显示
        if (ddlClass6.SelectedValue == "1" || ddlClass6.SelectedValue == "2")
            trPanhao6.Attributes.CssStyle["display"] = "";
        else trPanhao6.Attributes.CssStyle["display"] = "none";

        string sql = "select typeid,typename from " + Session["pre"].ToString() + "yjylkc_Type where classid =" + ddlClass6.SelectedValue;
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        ddlType6.Items.Clear();
        ddlType6.Items.Add(new ListItem("请选择型号", "0"));
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            ddlType6.Items.Add(new ListItem(dr[1].ToString(), dr[0].ToString()));
        }

    }
    protected void ddlType6_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlType6.SelectedValue != "0")
        {
            //非电缆、光缆时，不考虑盘号问题
            if (ddlClass6.SelectedValue != "1" && ddlClass6.SelectedValue != "2")
            {
                string sql = "select units,amount from " + Session["pre"].ToString() + "yjylkc_kcmx where classname='" + ddlClass6.SelectedItem.Text + "' and typename ='" + ddlType6.SelectedItem.Text + "'";
                DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    units6_1.InnerText = units6_2.InnerText = units6_3.InnerText = ds.Tables[0].Rows[0][0].ToString();
                    kcamount6.Text = ds.Tables[0].Rows[0][1].ToString();
                }
                else
                {
                    units6_1.InnerText = units6_2.InnerText = units6_3.InnerText = "";
                    kcamount6.Text = "0";
                }

            }
            if (ddlClass6.SelectedValue == "1" || ddlClass6.SelectedValue == "2")
            {
                string sql = "select isnull(sum(amount),0) from " + Session["pre"].ToString() + "yjylkc_kcmx where classname='" + ddlClass6.SelectedItem.Text + "' and typename ='" + ddlType6.SelectedItem.Text + "'";
                DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
                kcamount6.Text = ds.Tables[0].Rows[0][0].ToString();
                sql = "select panhao,amount ,units from  " + Session["pre"].ToString() + "yjylkc_kcmx where amount<>0 and classname='" + ddlClass6.SelectedItem.Text + "' and typename ='" + ddlType6.SelectedItem.Text + "'";
                ds = DirectDataAccessor.QueryForDataSet(sql);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    units6_1.InnerText = units6_2.InnerText = units6_3.InnerText = ds.Tables[0].Rows[0][2].ToString();
                    ddlPanhao6.Items.Clear();
                    ddlPanhao6.Items.Add(new ListItem("请选择盘号", "0"));
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        ddlPanhao6.Items.Add(new ListItem(dr[0].ToString(), dr[1].ToString()));
                    }

                }
                else
                {
                    units6_1.InnerText = units6_2.InnerText = units6_3.InnerText = "";
                    phkc6.Text = "0";
                }
            }

        }
        else
            units6_1.InnerText = units6_2.InnerText = units6_3.InnerText = "";
    }
    protected void ddlPanhao6_SelectedIndexChanged(object sender, EventArgs e)
    {
        phkc6.Text = ddlPanhao6.Text;
    }
}
