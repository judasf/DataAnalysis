<%@ WebHandler Language="C#" Class="EditKgck" %>

using System;
using System.Web;
using System.Web.SessionState;
using System.Data;
public class EditKgck : IHttpHandler, IRequiresSessionState
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        if (context.Session["uname"] == null || context.Session["uname"].ToString() == "" || context.Session["roleid"] == null || context.Session["roleid"].ToString() != "2")
            context.Response.Write("NoPrivilege");
        else
            Edit(context);
    }
    private void Edit(HttpContext context)
    {
        string action = context.Request.Form["action"];
        if (action != "EditKgck")
            context.Response.Write("NoPrivilege");
        else
        {
            string id = context.Request.Form["id"];
            int amount = 0;
            if (!Int32.TryParse(context.Request.Form["amount"], out amount))
            {
                context.Response.Write("ErrorNum");
            }
            else
            {
                string sql = "select b.amount,a.zgid,a.classname,a.typename,a.panhao,a.amount from xlzgxx_llmx  as a join " + context.Session["pre"].ToString() + "yjylkc_kcmx as  b on a.classname=b.classname and ";
                sql += "a.typename=b.typename and a.panhao=b.panhao and a.units=b.units and a.id=@id";
                DataSet ds = DirectDataAccessor.QueryForDataSet(sql, new System.Data.SqlClient.SqlParameter("@id", id));
                if (amount > (int)ds.Tables[0].Rows[0][0])
                    context.Response.Write("NoEnoughStock");
                else
                {

                    string updateSql = "update  xlzgxx_llmx set amount=" + amount.ToString() + " where id=" + id.ToString() + ";";
                    if (amount != (int)ds.Tables[0].Rows[0][5])
                    {
                        string zgbz = "库管修改领料信息：将类别为：[" + ds.Tables[0].Rows[0][2] + "]，型号为：[" + ds.Tables[0].Rows[0][3] + "]，盘号为：[";
                        zgbz += ds.Tables[0].Rows[0][4] + "]的领料数量由[" + ds.Tables[0].Rows[0][5] + "]修改为[" + amount + "]。";
                        zgbz += "操作时间：" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "；";
                        
                        updateSql += "update  xlzgxx set zgbz=isnull(zgbz,'')+'" + zgbz + "' where id='" + ds.Tables[0].Rows[0][1] + "'";
                    }
                    try
                    {
                        DirectDataAccessor.Execute(updateSql);
                        context.Response.Write("Succ");
                    }
                    catch (Exception)
                    {
                        context.Response.Write("ResponseError");
                    }

                }

            }


        }

    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}