using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using org.in2bits.MyXls;

public partial class xlbdllxxxq : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
            if (Request.QueryString["bdid"] == null)
            {
                Response.Write("参数错误！");
                Response.End();
            }
            else
            {
                bdid.Text = Request.QueryString["bdid"].ToString();
                DataSet ds = DirectDataAccessor.QueryForDataSet("select * from xlbdxx where id='" + Request.QueryString["bdid"].ToString() + "'");
                if (ds.Tables[0].Rows.Count < 1)
                {
                    Response.Write("参数错误！");
                    Response.End();
                }
                else
                {
                    bdrq.Text = ds.Tables[0].Rows[0][1].ToString();
                   bddd.Text = ds.Tables[0].Rows[0][2].ToString();
                   bdss.Text = ds.Tables[0].Rows[0][7].ToString();
                   ssje.Text = ds.Tables[0].Rows[0][8].ToString();
                   hfsj.Text = ds.Tables[0].Rows[0][9].ToString();
                }
                DataSet ds1 = DirectDataAccessor.QueryForDataSet("select top 1* from xlbdxx_llmx where bdid='" + Request.QueryString["bdid"].ToString() + "'");
                cksj.Text = ds1.Tables[0].Rows[0][2].ToString();
                lldw.Text = ds1.Tables[0].Rows[0][3].ToString();
                llr.Text = ds1.Tables[0].Rows[0][4].ToString();
                lxdh.Text = ds1.Tables[0].Rows[0][5].ToString();

            }

                NewsBind();
            }
        }
    }
   
   
    /// <summary>
    /// 获取DataTable
    /// </summary>
    /// <returns></returns>
    private DataTable GetDataTable()
    {
        string sqlStr = "select * from xlbdxx_llmx  ";
        DataSet ds = DirectDataAccessor.QueryForDataSet(sqlStr);
        return ds.Tables[0];
    }
    /// <summary>
    /// repeater分页并绑定
    /// </summary>
    private void NewsBind()
    {
        string sqlStr = "select  row_number() over(order by id ) as rowid,* from xlbdxx_llmx  where bdid= '" + Request.QueryString["bdid"].ToString()+"'" ;
        DataSet ds = DirectDataAccessor.QueryForDataSet(sqlStr);


            repData.DataSource = ds;//这里更改控件名称
            repData.DataBind();//这里更改控件名称

    }
 

}