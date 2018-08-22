using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;

public partial class xlzgxxkgllck : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
                //判断权限,库管有权对线路主管已确认的区域维护领料单进行出库
                if (Session["roleid"] == null || Session["roleid"].ToString() != "2")
                    Response.Write("<script type='text/javascript'>alert('您没有相应的权限，请重新登陆！');top.location.href='../';</script>");
                if (Request.QueryString["zgid"] == null)
                {
                    Response.Write("参数错误！");
                    Response.End();
                }
                else
                {
                    zgid.InnerHtml = Request.QueryString["zgid"].ToString();
                    DataSet ds = DirectDataAccessor.QueryForDataSet("select * from dlysxx where id='" + Request.QueryString["zgid"].ToString() + "'");
                    if (ds.Tables[0].Rows.Count < 1)
                    {
                        Response.Write("参数错误！");
                        Response.End();
                    }
                    else
                    {
                        whdw.InnerHtml = ds.Tables[0].Rows[0][1].ToString();
                        fzr.InnerHtml = ds.Tables[0].Rows[0][2].ToString();
                        zgcs.InnerHtml = ds.Tables[0].Rows[0][7].ToString();
                        zgr.InnerHtml = ds.Tables[0].Rows[0][8].ToString();
                        pdr.InnerHtml = ds.Tables[0].Rows[0][13].ToString();
                        pdsj.InnerHtml = ds.Tables[0].Rows[0][16].ToString();
                        pddw.InnerHtml = ds.Tables[0].Rows[0][18].ToString();
                        lxr.InnerHtml = ds.Tables[0].Rows[0]["lxr"].ToString();
                        lxdh.InnerHtml = ds.Tables[0].Rows[0]["lxdh"].ToString();
                        qywh.InnerHtml = ds.Tables[0].Rows[0]["qywh"].ToString();
                        DataSet ds1 = DirectDataAccessor.QueryForDataSet("select top 1  llr,lxdh from dlysxx_llmx where zgid='" + Request.QueryString["zgid"].ToString() + "'");
                        llr.InnerHtml = ds1.Tables[0].Rows[0][0].ToString();
                        llrlxdh.InnerHtml = ds1.Tables[0].Rows[0][1].ToString();

                        NewsBind();
                    }
                }

            }
        }
    }
    private void NewsBind()
    {
        string sqlStr = "select  row_number() over(order by id ) as rowid,* from dlysxx_llmx  where zgid='" + Request.QueryString["zgid"].ToString() + "'";
        DataSet ds = DirectDataAccessor.QueryForDataSet(sqlStr);
        repData.DataSource = ds;
        repData.DataBind();

    }


    protected void Button1_Click(object sender, EventArgs e)
    {
        StringBuilder sql = new StringBuilder();
        DataSet ds = DirectDataAccessor.QueryForDataSet("select amount,classname,typename,panhao from dlysxx_llmx where zgid='" + zgid.InnerText + "'");
        foreach (DataRow dr in ds.Tables[0].Rows)
        {//增加库管出料时对当前库存先判断库存是否充足，然后再出料
            DataSet dsck = DirectDataAccessor.QueryForDataSet("select  amount from " + Session["pre"].ToString() + "yjylkc_kcmx  where classname='" + dr[1].ToString() + "'  and typename ='" + dr[2].ToString() + "' and panhao='" + dr[3].ToString() + "'");
            if (dsck.Tables[0].Rows.Count < 1)//当前领用物资的类别或者型号或者盘号不存在
            {
                string info = "领料物资的类别为：" + dr[1].ToString() + "； 型号为：" + dr[2].ToString() + "；" + (dr[3].ToString() == "" ? "" : " 盘号为：" + dr[3].ToString() + "") + ",请确认当前库存中该物资是否存在，若不存在需增加该物资库存信息后再进行出库操作！";
                ClientScript.RegisterStartupScript(this.GetType(), "error", "alert('" + info + "');", true);
                return;
            }
            else
            {
                if ((int)dsck.Tables[0].Rows[0][0] < (int)dr[0])//当前库存不足
                {
                    string info = "领料物资：类别【" + dr[1].ToString() + "】— 型号【" + dr[2].ToString() + "】" + (dr[3].ToString() == "" ? "" : "— 盘号【" + dr[3].ToString() + "】") + ",当前库存为";
                    info += dsck.Tables[0].Rows[0][0].ToString() + ",库存不足，请补充库存后再进行出库操作！";
                    ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('" + info + "');", true);
                    return;
                }

                sql.Append("update " + Session["pre"].ToString() + "yjylkc_kcmx set amount=amount-" + dr[0].ToString() + " where classname='" + dr[1].ToString() + "' ");
                sql.Append(" and typename ='" + dr[2].ToString() + "' and panhao='" + dr[3].ToString() + "' ;");
            }
        }
        sql.Append("update dlysxx set kgck=1,kgcksj='"+DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")+"' where id='" + zgid.InnerText + "'");
        //写入sql日志
        DirectDataAccessor.writeLog("DLYS_KG", Session["pre"].ToString() == "" ? "SQ_" : Session["pre"].ToString(), sql.ToString());
        DirectDataAccessor.Execute(sql.ToString());
        if (Session["pre"] != null && Session["pre"].ToString().Trim() == "")
            ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('该区域维护领料单确认成功！');location.href=\"xlzgxxgl.aspx\";", true);
        if (Session["pre"] != null && Session["pre"].ToString().Trim() != "")
            ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('该区域维护领料单确认成功！');location.href=\"xlzgxxgl_town.aspx\";", true);
    }
}
