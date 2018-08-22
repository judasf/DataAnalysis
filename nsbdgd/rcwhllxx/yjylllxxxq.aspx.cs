using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;


public partial class yjylllxxxq : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
            if (Request.QueryString["id"] == null)
            {
                Response.Write("参数错误！");
                Response.End();
            }
            else
            {
                id.Text = Request.QueryString["id"].ToString();
                DataSet ds = DirectDataAccessor.QueryForDataSet("select  top 1* from yjylkc_llmx where id='" + Request.QueryString["id"].ToString() + "'");
                if (ds.Tables[0].Rows.Count < 1)
                {
                    Response.Write("参数错误！");
                    Response.End();
                }
                else
                {
                    lldw.Text = ds.Tables[0].Rows[0]["lldw"].ToString();
                    cksj.Text = ds.Tables[0].Rows[0]["cksj"].ToString();
                    ckdw.InnerText = ds.Tables[0].Rows[0]["ckdw"].ToString();
                    llyt.InnerText = ds.Tables[0].Rows[0]["llyt"].ToString();
                    yldz.InnerText = ds.Tables[0].Rows[0]["yldz"].ToString();
                    llr.Text = ds.Tables[0].Rows[0]["llr"].ToString();
                    bz.InnerText = ds.Tables[0].Rows[0]["bz"].ToString();
                }
            }
                NewsBind();
            }
        }
    }


    private void NewsBind()
    {
        string sqlStr = "select  row_number() over(order by id ) as rowid,classname,typename,amount,units from yjylkc_llmx  where id='" + Request.QueryString["id"].ToString() + "'";
        DataSet ds = DirectDataAccessor.QueryForDataSet(sqlStr);
            repData.DataSource = ds;
            repData.DataBind();
    }
  }