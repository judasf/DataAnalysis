using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class yjkxxlr : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
                //判断角色 为 2，各单位派单人员可以录单
                if (Session["roleid"] == null || Session["roleid"].ToString() != "2"||Session["pre"].ToString()!="")
                    Response.Write("<script type='text/javascript'>alert('权限不足，请重新登陆！');top.location.href='../';</script>");
                //获取编号
                if (Request.QueryString["id"] != null)
                {
                    id.InnerText = Request.QueryString["id"].ToString();
                }
                else
                {   //应急库针对市区
                    DataSet dr = DirectDataAccessor.QueryForDataSet("SELECT yjkxxid  FROM autoid");
                    string currentId = dr.Tables[0].Rows[0][0].ToString();
                    string datePre = DateTime.Now.ToString("yyyyMM");
                    if (currentId.Substring(0, 6) == datePre)
                    {
                        id.InnerText = "YJK" + currentId;
                    }
                    else
                    {
                        id.InnerText = "YJK" + datePre + "001";
                    }
                }
                pdr.InnerText = Session["uname"].ToString();
                if (Request.QueryString["pdsj"] != null)
                {
                    pdsj.InnerText = Request.QueryString["pdsj"].ToString();
                }
                else
                    pdsj.InnerText = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                if (Request.QueryString["jsdw"] != null)
                {
                    ddljsdw.Items.Clear();
                    ddljsdw.Items.Add(new ListItem(Server.UrlDecode(Request.QueryString["jsdw"].ToString())));
                }
                else
                    BindJsdw();
                if (Request.QueryString["bz"] != null)
                {
                    bz.Text = Server.UrlDecode(Request.QueryString["bz"].ToString());
                    bz.ReadOnly = true;
                }
                BindClass();
                BindType();
            }
        }
    }
    /// <summary>
    /// 绑定接收单位
    /// </summary>
    private void BindJsdw()
    {
        string sql = "select deptname from userinfo where roleid=2";
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        ddljsdw.Items.Clear();
        ddljsdw.Items.Add(new ListItem("请选择接收单位", "0"));
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            ddljsdw.Items.Add(new ListItem(dr[0].ToString()));
        }
    }
    private void BindType()
    {
        string sql = "select typeid,typename from  yjylkc_Type where classid =" + ddlClass.SelectedValue;
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
            string sql = "select *  from  yjylkc_Class  where classname='应急库'";

            DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                ddlClass.Items.Add(new ListItem(dr[1].ToString(), dr[0].ToString()));
            }
        }
     

    protected void Button1_Click(object sender, EventArgs e)
    {

        string sql;
        //判断当前月，当前分公司记录是否存在，存在就update,不存在就insert
        sql = "IF NOT EXISTS (SELECT * FROM  yjkxx  WHERE pdsj ='" + pdsj.InnerText + "' and jsdw='" + ddljsdw.Text + "') ";
        sql += " Insert into  yjkxx values('" + id.InnerText + "','" + pdsj.InnerText + "','" + pdr.InnerText + "','" + ddljsdw.Text + "','','" + bz.Text + "','');";
        if (PanHaoShow(ddlClass.SelectedItem.Text, ddlType.SelectedItem.Text))
        {
            sql += "insert into yjkxx_llmx values('" + id.InnerText + "','"+pdsj.InnerText+"','"+ddljsdw.Text+"','" + ddlClass.SelectedItem.Text + "',";
            sql += "'" + ddlType.SelectedItem.Text + "','" + ddlPanhao.SelectedItem.Text + "','" + amount.Text + "','" + units1.InnerHtml + "'); ";
            sql += "update  yjylkc_kcmx set amount=amount-" + amount.Text + " where classname='" + ddlClass.SelectedItem.Text + "' and typename ='" + ddlType.SelectedItem.Text + "' and panhao='" + ddlPanhao.SelectedItem.Text + "' ; ";

        }
        else
        {
            sql += "insert into yjkxx_llmx values('" + id.InnerText + "','" + pdsj.InnerText + "','" + ddljsdw.Text + "','" + ddlClass.SelectedItem.Text + "',";
             sql += "'" + ddlType.SelectedItem.Text + "','','" + amount.Text + "','" + units1.InnerHtml + "'); ";
            sql += "update  yjylkc_kcmx set amount=amount-" + amount.Text + " where classname='" + ddlClass.SelectedItem.Text + "' and typename ='" + ddlType.SelectedItem.Text + "'; ";
        }
        sql += "Update autoid set  yjkxxid=" + (int.Parse(id.InnerText.Substring(3)) + 1);
        //写入sql日志
        DirectDataAccessor.writeLog("YJK", Session["pre"].ToString() == "" ? "SQ_" : Session["pre"].ToString(), sql.ToString());
        DirectDataAccessor.Execute(sql);

      string script = "if (confirm('领料成功！是否继续领料？\\n点击确定继续领料，点击取消返回信息管理页面')){location.href=\"";
      script += "yjkxxlr.aspx?pdsj=" + pdsj.InnerText + "&jsdw=" + Server.UrlEncode(ddljsdw.Text) + "&bz=" + Server.UrlEncode(bz.Text) + "&id=" + id.InnerText + "\";}";
      script += "else{location.href=\"yjkxxgl.aspx\";}";
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
                string sql = "select units,amount from  yjylkc_kcmx where classname='" + ddlClass.SelectedItem.Text + "' and typename ='" + ddlType.SelectedItem.Text + "'";
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
                string sql = "select isnull(sum(amount),0) from  yjylkc_kcmx where classname='" + ddlClass.SelectedItem.Text + "' and typename ='" + ddlType.SelectedItem.Text + "'";
               DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
                kcamount.Text = ds.Tables[0].Rows[0][0].ToString();
                sql = "select panhao,amount ,units from   yjylkc_kcmx where classname='" + ddlClass.SelectedItem.Text + "' and typename ='" + ddlType.SelectedItem.Text + "'";
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
    protected void ddlPanhao_SelectedIndexChanged(object sender, EventArgs e)
    {
        phkc.Text = ddlPanhao.Text;
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
        string sql = "select isnull(panhao,'')  from  yjylkc_kcmx where classname='" + classname + "' and typename='" + typename + "'";
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        if (ds.Tables[0].Rows.Count > 0)
        {
            if (ds.Tables[0].Rows[0][0].ToString().Trim() != "")
                flag = true;
        }
        return flag;
    }
}
