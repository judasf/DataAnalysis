using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
public partial class yjylkckclr : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
                //判断权限,库管,南水北调库管可录入库存
                if (Session["roleid"] == null || (Session["roleid"].ToString() != "2" &&Session["roleid"].ToString() != "11"))
                    Response.Write("<script type='text/javascript'>alert('您没有相应的权限，请重新登陆！');top.location.href='../';</script>");
                BindClass();
            }
        }

    }
    /// <summary>
    /// 绑定类别
    /// </summary>
    private void BindClass()
    {
        string sql = "select *  from "+Session["pre"]+"yjylkc_Class ";
        //判断权限：2：库管不能看南水北调；11：南水北调库管只操作南水北调
        if (Session["roleid"] != null)
        {
            switch (Session["roleid"].ToString())
            {
                case "2":
                    sql += "  where classname<>'南水北调'";
                    break;
                case "11":
                    sql += " where classname='南水北调'";
                    break;
            }
        }
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        ddlClass.Items.Add(new ListItem("请选择类别", "0"));
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            ddlClass.Items.Add(new ListItem(dr[1].ToString(), dr[0].ToString()));
        }
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        string ckSql;
        StringBuilder sql = new StringBuilder(); ;
        //No.1
        if (ddlType1.Text != "0")
        {

            ckSql = "Select * from " + Session["pre"] + "yjylkc_kcmx where classname='" + ddlClass.SelectedItem.Text + "' and typename ='" + ddlType1.SelectedItem.Text + "' and panhao='" + txtPanhao1.Text.Trim() + "'";
            DataSet ds = DirectDataAccessor.QueryForDataSet(ckSql);
            if (ds.Tables[0].Rows.Count < 1)
            {
                sql.Append("insert into " + Session["pre"] + "yjylkc_kcmx(classname,typename,panhao,units,amount) values('" + ddlClass.SelectedItem.Text + "',");
                sql.Append( "'" + ddlType1.SelectedItem.Text + "','"+txtPanhao1.Text.Trim()+"','" + units1.InnerText + "'," + txtAmount1.Text + "); ");
            }
            else
                sql.Append("update " + Session["pre"] + "yjylkc_kcmx set amount=amount+" + txtAmount1.Text + " where classname='" + ddlClass.SelectedItem.Text + "' and typename ='" + ddlType1.SelectedItem.Text + "' and panhao='" + txtPanhao1.Text.Trim() + "'; ");
            sql.Append("insert into " + Session["pre"] + "yjylkc_lrLog(classname,typename,units,panhao,amount,memo) values('" + ddlClass.SelectedItem.Text + "',");
            sql.Append("'" + ddlType1.SelectedItem.Text + "','" + units1.InnerText + "','" + txtPanhao1.Text.Trim() + "'," + txtAmount1.Text + ",'" + memo1.Text + "'); ");
            
			
            DirectDataAccessor.Execute(sql.ToString());
            sql.Remove(0, sql.Length);
        }
        //No.2
        if (ddlType2.Text != "0")
        {
            ckSql = "Select * from " + Session["pre"] + "yjylkc_kcmx where classname='" + ddlClass.SelectedItem.Text + "' and typename ='" + ddlType2.SelectedItem.Text + "' and panhao='" + txtPanhao2.Text.Trim() + "'";
            DataSet ds = DirectDataAccessor.QueryForDataSet(ckSql);
            if (ds.Tables[0].Rows.Count < 1)
            {
                sql.Append("insert into " + Session["pre"] + "yjylkc_kcmx(classname,typename,panhao,units,amount) values('" + ddlClass.SelectedItem.Text + "',");
                sql.Append("'" + ddlType2.SelectedItem.Text + "','" + txtPanhao2.Text.Trim() + "','" + units2.InnerText + "'," + txtAmount2.Text + "); ");
            }
            else
                sql.Append("update " + Session["pre"] + "yjylkc_kcmx set amount=amount+" + txtAmount2.Text + " where classname='" + ddlClass.SelectedItem.Text + "' and typename ='" + ddlType2.SelectedItem.Text + "' and panhao='" + txtPanhao2.Text.Trim() + "'; ");
            sql.Append("insert into " + Session["pre"] + "yjylkc_lrLog(classname,typename,units,panhao,amount,memo) values('" + ddlClass.SelectedItem.Text + "',");
            sql.Append("'" + ddlType2.SelectedItem.Text + "','" + units2.InnerText + "','" + txtPanhao2.Text.Trim() + "'," + txtAmount2.Text + ",'" + memo2.Text + "'); ");
  
            DirectDataAccessor.Execute(sql.ToString());
            sql.Remove(0, sql.Length);
        }
        //No.3
        if (ddlType3.Text != "0")
        {
            ckSql = "Select * from " + Session["pre"] + "yjylkc_kcmx where classname='" + ddlClass.SelectedItem.Text + "' and typename ='" + ddlType3.SelectedItem.Text + "' and panhao='" + txtPanhao3.Text.Trim() + "'";
            DataSet ds = DirectDataAccessor.QueryForDataSet(ckSql);
            if (ds.Tables[0].Rows.Count < 1)
            {
                sql.Append("insert into " + Session["pre"] + "yjylkc_kcmx(classname,typename,panhao,units,amount) values('" + ddlClass.SelectedItem.Text + "',");
                sql.Append("'" + ddlType3.SelectedItem.Text + "','" + txtPanhao3.Text.Trim() + "','" + units3.InnerText + "'," + txtAmount3.Text + "); ");
            }
            else
                sql.Append("update " + Session["pre"] + "yjylkc_kcmx set amount=amount+" + txtAmount3.Text + " where classname='" + ddlClass.SelectedItem.Text + "' and typename ='" + ddlType3.SelectedItem.Text + "' and panhao='" + txtPanhao3.Text.Trim() + "'; ");
            sql.Append("insert into " + Session["pre"] + "yjylkc_lrLog(classname,typename,units,panhao,amount,memo) values('" + ddlClass.SelectedItem.Text + "',");
            sql.Append("'" + ddlType3.SelectedItem.Text + "','" + units3.InnerText + "','" + txtPanhao3.Text.Trim() + "'," + txtAmount3.Text + ",'" + memo3.Text + "'); ");
    
            DirectDataAccessor.Execute(sql.ToString());
            sql.Remove(0, sql.Length);
        }
        //No.4
        if (ddlType4.Text != "0")
        {
            ckSql = "Select * from " + Session["pre"] + "yjylkc_kcmx where classname='" + ddlClass.SelectedItem.Text + "' and typename ='" + ddlType4.SelectedItem.Text + "' and panhao='" + txtPanhao4.Text.Trim() + "'";
            DataSet ds = DirectDataAccessor.QueryForDataSet(ckSql);
            if (ds.Tables[0].Rows.Count < 1)
            {
                sql.Append("insert into " + Session["pre"] + "yjylkc_kcmx(classname,typename,panhao,units,amount) values('" + ddlClass.SelectedItem.Text + "',");
                sql.Append("'" + ddlType4.SelectedItem.Text + "','" + txtPanhao4.Text.Trim() + "','" + units4.InnerText + "'," + txtAmount4.Text + "); ");
            }
            else
                sql.Append("update " + Session["pre"] + "yjylkc_kcmx set amount=amount+" + txtAmount4.Text + " where classname='" + ddlClass.SelectedItem.Text + "' and typename ='" + ddlType4.SelectedItem.Text + "' and panhao='" + txtPanhao4.Text.Trim() + "'; ");
            sql.Append("insert into " + Session["pre"] + "yjylkc_lrLog(classname,typename,units,panhao,amount,memo) values('" + ddlClass.SelectedItem.Text + "',");
            sql.Append("'" + ddlType4.SelectedItem.Text + "','" + units4.InnerText + "','" + txtPanhao4.Text.Trim() + "'," + txtAmount4.Text + ",'" + memo4.Text + "'); ");
         
            DirectDataAccessor.Execute(sql.ToString());
            sql.Remove(0, sql.Length);
        }
        //No.5
        if (ddlType5.Text != "0")
        {
            ckSql = "Select * from " + Session["pre"] + "yjylkc_kcmx where classname='" + ddlClass.SelectedItem.Text + "' and typename ='" + ddlType5.SelectedItem.Text + "' and panhao='" + txtPanhao5.Text.Trim() + "'";
            DataSet ds = DirectDataAccessor.QueryForDataSet(ckSql);
            if (ds.Tables[0].Rows.Count < 1)
            {
                sql.Append("insert into " + Session["pre"] + "yjylkc_kcmx(classname,typename,panhao,units,amount) values('" + ddlClass.SelectedItem.Text + "',");
                sql.Append("'" + ddlType5.SelectedItem.Text + "','" + txtPanhao5.Text.Trim() + "','" + units5.InnerText + "'," + txtAmount5.Text + "); ");
            }
            else
                sql.Append("update " + Session["pre"] + "yjylkc_kcmx set amount=amount+" + txtAmount5.Text + " where classname='" + ddlClass.SelectedItem.Text + "' and typename ='" + ddlType5.SelectedItem.Text + "' and panhao='" + txtPanhao5.Text.Trim() + "'; ");
            sql.Append("insert into " + Session["pre"] + "yjylkc_lrLog(classname,typename,units,panhao,amount,memo) values('" + ddlClass.SelectedItem.Text + "',");
            sql.Append("'" + ddlType5.SelectedItem.Text + "','" + units5.InnerText + "','" + txtPanhao5.Text.Trim() + "'," + txtAmount5.Text + ",'" + memo5.Text + "'); ");
           
            DirectDataAccessor.Execute(sql.ToString());
            sql.Remove(0, sql.Length);
        }
        
        ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('库存追加成功！');location.href=location.href;", true);
    }
    protected void ddlClass_SelectedIndexChanged(object sender, EventArgs e)
    {
        string sql = "select typeid,typename from " + Session["pre"] + "yjylkc_Type where classid =" + ddlClass.SelectedValue;
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        ddlType1.Items.Clear();
        ddlType1.Items.Add(new ListItem("请选择型号", "0"));
        ddlType2.Items.Clear();
        ddlType2.Items.Add(new ListItem("请选择型号", "0"));
        ddlType3.Items.Clear();
        ddlType3.Items.Add(new ListItem("请选择型号", "0"));
        ddlType4.Items.Clear();
        ddlType4.Items.Add(new ListItem("请选择型号", "0"));
        ddlType5.Items.Clear();
        ddlType5.Items.Add(new ListItem("请选择型号", "0"));
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            ddlType1.Items.Add(new ListItem(dr[1].ToString(), dr[0].ToString()));
            ddlType2.Items.Add(new ListItem(dr[1].ToString(), dr[0].ToString()));
            ddlType3.Items.Add(new ListItem(dr[1].ToString(), dr[0].ToString()));
            ddlType4.Items.Add(new ListItem(dr[1].ToString(), dr[0].ToString()));
            ddlType5.Items.Add(new ListItem(dr[1].ToString(), dr[0].ToString()));
        }
    }
    protected void ddlType1_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlType1.SelectedValue != "0")
        {
            string sql = "select units from " + Session["pre"] + "yjylkc_Type where typeid=" + ddlType1.SelectedValue;
            DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
            units1.InnerText = ds.Tables[0].Rows[0][0].ToString();
        }
        else
            units1.InnerText = "";
    }
    protected void ddlType2_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlType2.SelectedValue != "0")
        {
            string sql = "select units from " + Session["pre"] + "yjylkc_Type where typeid=" + ddlType2.SelectedValue;
            DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
            units2.InnerText = ds.Tables[0].Rows[0][0].ToString();
        }
        else
            units2.InnerText = "";
    }
    protected void ddlType3_SelectedIndexChanged(object sender, EventArgs e)
    {
         if (ddlType3.SelectedValue != "0")
        {
            string sql = "select units from " + Session["pre"] + "yjylkc_Type where typeid=" + ddlType3.SelectedValue;
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        units3.InnerText = ds.Tables[0].Rows[0][0].ToString();
        }
         else
             units3.InnerText = "";
    }
    protected void ddlType4_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlType4.SelectedValue != "0")
        {
            string sql = "select units from " + Session["pre"] + "yjylkc_Type where typeid=" + ddlType4.SelectedValue;
            DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
            units4.InnerText = ds.Tables[0].Rows[0][0].ToString();
        }
        else
            units4.InnerText = "";
    }
    protected void ddlType5_SelectedIndexChanged(object sender, EventArgs e)
    {
         if (ddlType5.SelectedValue != "0")
        {
            string sql = "select units from " + Session["pre"] + "yjylkc_Type where typeid=" + ddlType5.SelectedValue;
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        units5.InnerText = ds.Tables[0].Rows[0][0].ToString();
        }
         else
             units5.InnerText = "";
    }
}
