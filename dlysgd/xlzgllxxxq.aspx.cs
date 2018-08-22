using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;


public partial class xlzgllxxxq : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
            if (Request.QueryString["zgid"] == null)
            {
                Response.Write("参数错误！");
                Response.End();
            }
            else
            {
                zgid.Text = Request.QueryString["zgid"].ToString();
                DataSet ds = DirectDataAccessor.QueryForDataSet("select * from dlysxx where id='" + Request.QueryString["zgid"].ToString() + "'");
                if (ds.Tables[0].Rows.Count < 1)
                {
                    Response.Write("参数错误！");
                    Response.End();
                }
                else
                {
                    pdsj.InnerHtml = ds.Tables[0].Rows[0]["pdsj"].ToString();
                    pfdw.InnerHtml = ds.Tables[0].Rows[0]["pfdw"].ToString();
                    pdr.InnerHtml = ds.Tables[0].Rows[0]["pdr"].ToString();
                    whdw.InnerHtml = ds.Tables[0].Rows[0]["whdw"].ToString();
                    fzr.InnerHtml = ds.Tables[0].Rows[0]["fzr"].ToString();
                    lxr.InnerHtml = ds.Tables[0].Rows[0]["lxr"].ToString();
                    lxrdh.InnerHtml = ds.Tables[0].Rows[0]["lxdh"].ToString();
                }
                DataSet ds1 = DirectDataAccessor.QueryForDataSet("select top 1* from dlysxx_llmx where zgid='" + Request.QueryString["zgid"].ToString() + "'");
                cksj.Text = ds1.Tables[0].Rows[0][2].ToString();
                lldw.Text = ds1.Tables[0].Rows[0][3].ToString();
                llr.Text = ds1.Tables[0].Rows[0][4].ToString();
                lxdh.Text = ds1.Tables[0].Rows[0][5].ToString();

            }

                NewsBind();
            }
        }
    }
   

    private void NewsBind()
    {
        string sqlStr = "select  row_number() over(order by id ) as rowid,* from dlysxx_llmx  where zgid='" + Request.QueryString["zgid"].ToString()+"'" ;
        DataSet ds = DirectDataAccessor.QueryForDataSet(sqlStr);
            repData.DataSource = ds;
            repData.DataBind();

    }
  }