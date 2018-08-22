using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

public partial class gzbb_wbzbsc : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "" || Session["deptname"] == null)
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
                //外包单位周报上传
                if (Session["roleid"] == null || Session["roleid"].ToString() != "3")
                    Response.Write("<script type='text/javascript'>alert('您没有相应的权限，请重新登陆！');top.location.href='../';</script>");
            }
        }
    }
    protected void upload_Click(object sender, EventArgs e)
    {
        if (!FileUpload1.HasFile)
        {
            ClientScript.RegisterStartupScript(this.GetType(), "Error", "alert( '请先选择您要上传的文件! ');", true);
            return;
        }
        if (Path.GetExtension(FileUpload1.PostedFile.FileName) != ".doc" && Path.GetExtension(FileUpload1.PostedFile.FileName) != ".docx")
        {
            ClientScript.RegisterStartupScript(this.GetType(), "Error", "alert( '文件格式不正确!请选择正确的word文件! ');", true);
            return;
        }
        string fileName = FileUpload1.PostedFile.FileName;
        string filepath = Server.MapPath("~/gzbb/uploadfiles") + "/" + fileName;
        if (File.Exists(filepath))
        {
            ClientScript.RegisterStartupScript(this.GetType(), "Error", "alert( '该文件已上传，请选择其他文件! ');", true);
            return;
        }
        try
        {
            FileUpload1.PostedFile.SaveAs(Server.MapPath("~/gzbb/uploadfiles") + "/" + fileName);
            string sql = "insert into upfilelist(type,filename,userdept,username,uptime) values('工作周报','" + fileName + "','" + Session["deptname"].ToString() + "'";
            sql += ",'" + Session["uname"].ToString() + "','"+DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")+"')";
            DirectDataAccessor.Execute(sql);
            ClientScript.RegisterStartupScript(this.GetType(), "info", "alert( '文件上传成功! ');", true);
        }
        catch (Exception ex)
        {
            ClientScript.RegisterStartupScript(this.GetType(), "info", "alert( '上传出错，请检查服务器配置，详情:" + ex.ToString() + "');", true);
        }
    }
}
