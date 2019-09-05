using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using org.in2bits.MyXls;

public partial class xlzgxxgl_town : System.Web.UI.Page
{    
    
    /// <summary>
    /// 判断是否运维部超管
    /// </summary>
    public bool isAdminYW = false;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');top.location.href='../';</script>");
            else
            {
                BindMonth();
                BindBddw();
                Bindqywh();
                NewsBind();
                //判断是否运维部超管
                isAdminYW = (Session["roleid"].ToString() == "0" && Session["deptname"].ToString() == "网络部") ? true : false;
                //删除
                if (Request.QueryString["action"] == "del")
                {
                    if (Request.QueryString["id"] == null || Request.QueryString["id"].ToString() == "")
                    {
                        Response.Write("参数错误！");
                        Response.End();
                    }
                    else
                    {
                        DirectDataAccessor.Execute("Delete from dlysxx where id='" + Request.QueryString["id"] + "'");
                        ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('删除成功！'); location.href='xlzgxxgl_town.aspx';", true);

                    }
                }
                   //派单人员
                if (Session["roleid"] != null && Session["roleid"].ToString() == "1")
                {
                    //提示未设置确认整改完结时间
                    DataSet ds = DirectDataAccessor.QueryForDataSet("select count(id)  from dlysxx where isnull(wjsj,'')<>'' and isnull(qrwjsj,'')='' and len(id)>13  and pfdw='" + Session["deptname"].ToString() + "'");
                    if (ds.Tables[0].Rows[0][0].ToString() != "0")
                        ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('您有" + ds.Tables[0].Rows[0][0].ToString() + "条电缆延伸未确认完结，请及时处理！')", true);
 
                }
                //库管
                if (Session["roleid"] != null && Session["roleid"].ToString() == "2")
                {
                    //提示未领料出库
                    DataSet ds = DirectDataAccessor.QueryForDataSet("select count(id)  from dlysxx where xgqr=1 and kgck=0 and len(id)>13  and pfdw='" + Session["deptname"].ToString() + "'");
                    if (ds.Tables[0].Rows[0][0].ToString() != "0")
                        ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('您有" + ds.Tables[0].Rows[0][0].ToString() + "条区域领料未出库，请及时处理！')", true);
                }

                //区域维护
                if (Session["roleid"] != null && Session["roleid"].ToString() == "7")
                {
                    //区域维护提示未设置整改完结
                    DataSet ds2 = DirectDataAccessor.QueryForDataSet("select count(id)  from dlysxx where kgck=1 and len(id)>13 and isnull(wjsj,'')='' and qywh='" + Session["uname"].ToString() + "'");
                    if (ds2.Tables[0].Rows[0][0].ToString() != "0")
                        ClientScript.RegisterStartupScript(this.GetType(), "info", "alert('您有" + ds2.Tables[0].Rows[0][0].ToString() + "条未设置完结时间，请及时处理！')", true);

                }

            }
        }
    }
    /// <summary>
    /// 绑定日期
    /// </summary>
    private void BindMonth()
    {
        ddlMonth.Text = ddlMonth.Text == "" ? DateTime.Now.ToString("yyyy-MM") : ddlMonth.Text;
        ddlMonth1.Text = ddlMonth1.Text == "" ? DateTime.Now.ToString("yyyy-MM") : ddlMonth1.Text;
    }
    /// <summary>
    /// 绑定单位
    /// </summary>
    private void BindBddw()
    {
        string sql = "select pfdw from dlysxx  where len(id)>13 ";
        //检查角色：1：派单员，2：库管，8：线管
        if (Session["roleid"] != null && Session["deptname"] != null && (Session["roleid"].ToString() == "1" || Session["roleid"].ToString() == "2" || Session["roleid"].ToString() == "8" ))
            sql += " and pfdw='" + Session["deptname"].ToString() + "'";
        //3:外包单位;
        if (Session["roleid"] != null && Session["deptname"] != null && Session["roleid"].ToString() == "3")
            sql += " and whdw='" + Session["deptname"].ToString() + "'";
        //7：区域维护
        if (Session["roleid"] != null && Session["uname"] != null && Session["roleid"].ToString() == "7")
            sql += " and qywh='" + Session["uname"].ToString() + "'";
       
        sql += " group by pfdw";

        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        ddlpfdw.Items.Add(new ListItem("----全部----", "0"));
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            ddlpfdw.Items.Add(dr[0].ToString());
        }
    }
    /// <summary>
    /// 绑定区域维护
    /// </summary>
    private void Bindqywh()
    {
        string sql = "select qywh from dlysxx where len(id)>13 ";
        //检查角色：1：派单员，2：库管，8：线管
        if (Session["roleid"] != null && Session["deptname"] != null && (Session["roleid"].ToString() == "1" || Session["roleid"].ToString() == "2" || Session["roleid"].ToString() == "8"))
            sql += " and pfdw='" + Session["deptname"].ToString() + "' and qywh<>''";
        //3:外包单位;
        if (Session["roleid"] != null && Session["deptname"] != null && Session["roleid"].ToString() == "3")
            sql += " and whdw='" + Session["deptname"].ToString() + "' and qywh<>''";
        //7：区域维护
        if (Session["roleid"] != null && Session["uname"] != null && Session["roleid"].ToString() == "7")
            sql += " and qywh='" + Session["uname"].ToString() + "' and qywh<>''";
        //0：管理员
        if (Session["roleid"] != null && Session["uname"] != null && Session["roleid"].ToString() == "0")
            sql += " and qywh<>''";
        sql += " group by qywh";

        DataSet ds = DirectDataAccessor.QueryForDataSet(sql);
        ddlqywh.Items.Add(new ListItem("----全部----", "0"));
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            ddlqywh.Items.Add(dr[0].ToString());
        }
    }
    /// <summary>
    /// 获取DataTable
    /// </summary>
    /// <returns></returns>
    private DataTable GetDataTable( string sqlStr)
    {
      
        string whereStr = "where ";
        if (Request.QueryString["qj"] != null)
        {
            ddlMonth.Text = Request.QueryString["qj"].ToString();
            whereStr += "  substring (pdsj,0,8)>='" + Request.QueryString["qj"].ToString() + "' and";
        }
        else
        {
            whereStr += "  substring (pdsj,0,8)>='" + DateTime.Now.ToString("yyyy-MM") + "' and";
        }
        if (Request.QueryString["jz"] != null)
        {
            ddlMonth1.Text = Request.QueryString["jz"].ToString();
            whereStr += "  substring (pdsj,0,8)<='" + Request.QueryString["jz"].ToString() + "' and";
        }
        else
        {
            whereStr += "  substring (pdsj,0,8)<='" + DateTime.Now.ToString("yyyy-MM") + "' and";
        }
        //判断市县派单用户
        if (Session["roleid"] != null  && Session["roleid"].ToString() == "1" )
        {
            whereStr += "  pdr='" +Session["uname"].ToString() + "' and";
        }

        //判断市县派单用户和库管，线管
        if (Session["roleid"] != null && Session["deptname"] != null && (Session["roleid"].ToString() == "1" || Session["roleid"].ToString() == "2" || Session["roleid"].ToString() == "8" ))
        {
            ddlpfdw.Text = Session["deptname"].ToString();
            whereStr += "  pfdw='" + Session["deptname"].ToString() + "' and";
        }
        else
        {
            if (Request.QueryString["dw"] != null)
            {
                ddlpfdw.Text = Server.UrlDecode(Request.QueryString["dw"].ToString());
                whereStr += "  pfdw='" + Server.UrlDecode(Request.QueryString["dw"].ToString()) + "' and";
            }
        }
        //判断角色，3：外包单位
        if (Session["roleid"] != null && Session["roleid"].ToString() == "3")
        {
            whereStr += "  whdw='" + Session["deptname"].ToString() + "' and";
        }
        //判断角色，7：外包区域维护，只看自己工单
        if (Session["roleid"] != null && Session["roleid"].ToString() == "7")
        {
            whereStr += "  qywh='" + Session["uname"].ToString() + "' and";
        }
        //区域维护
        if (Request.QueryString["qywh"] != null)
        {
            ddlqywh.Text = Server.UrlDecode(Request.QueryString["qywh"].ToString());
            whereStr += "  qywh='" + Server.UrlDecode(Request.QueryString["qywh"].ToString()) + "' and";
        }
        //整改编号
        if (Request.QueryString["zgid"] != null)
        {
            zgid.Text = Request.QueryString["zgid"].ToString();
            whereStr += "  id like '%" + Request.QueryString["zgid"].ToString() + "%' and";
        }
        //查询工单状态
        if (Request.QueryString["gdzt"] != null)
        {
            string gdzt_str;
            gdzt.Text = gdzt_str=Request.QueryString["gdzt"].ToString();
            switch (gdzt_str){
                case "qyll":
                    whereStr += " zgll=0  and";
                    break;
                case "kgcl":
                    whereStr += " zgll=1 and kgck=0 and";
                    break;
                case "wbzg":
                    whereStr += "  kgck=1 and isnull(wjsj,'')='' and";
                    break;
                case "zgwj":
                    whereStr += "  isnull(wjsj,'')<>'' and isnull(qrwjsj,'')='' and";
                    break;
                case "sftl":
                    whereStr += " isnull(qrwjsj,'')<>'' and zgtl=0 and";
                    break;
            }
               
        }
        whereStr += " len(id)>13 and";
        if (whereStr != "where")
        {
            whereStr = whereStr.Substring(0, whereStr.Length - 3);
            sqlStr += whereStr;
        }
        sqlStr += " order by id desc";
        DataSet ds = DirectDataAccessor.QueryForDataSet(sqlStr);
        return ds.Tables[0];
    }
    /// <summary>
    /// repeater分页并绑定
    /// </summary>
    private void NewsBind()
    {
        string condition = "";
        if (Request.QueryString["qj"] != null)
        {
            condition += "&qj=" + Request.QueryString["qj"].ToString();
        }
        if (Request.QueryString["jz"] != null)
        {
            condition += "&jz=" + Request.QueryString["jz"].ToString();
        }
        if (Request.QueryString["dw"] != null)
        {
            condition += "&dw=" + Server.UrlEncode(Request.QueryString["dw"].ToString());
        }
        if (Request.QueryString["qywh"] != null)
        {
            condition += "&qywh=" + Server.UrlEncode(Request.QueryString["qywh"].ToString());
        }
        if (Request.QueryString["gdzt"] != null)
        {
            condition += "&gdzt=" + Request.QueryString["gdzt"].ToString();
        }
        if (Request.QueryString["zgid"] != null)
        {
            condition += "&zgid=" + Request.QueryString["zgid"].ToString();
        }
        DataTable dt = GetDataTable("select * from dlysxx  ");
        try
        {

            PagedDataSource objPage = new PagedDataSource();
            objPage.DataSource = dt.DefaultView;
            objPage.AllowPaging = true;
            int CurPage,pagesize;
            if (Request.QueryString["Page"] != null)
            {
                CurPage = Convert.ToInt32(Request.QueryString["page"]);
            }
            else
            {
                CurPage = 1;
            }
            if (Request.QueryString["pagesize"] != null)
            {
                pagesize = Convert.ToInt32(Request.QueryString["pagesize"]);
            }
            else
            {
                pagesize = 10;
            }
            objPage.PageSize = pagesize;
            objPage.CurrentPageIndex = CurPage - 1;
            repData.DataSource = objPage;//这里更改控件名称
            repData.DataBind();//这里更改控件名称
            RecordCount.Text = objPage.DataSourceCount.ToString();
            PageCount.Text = objPage.PageCount.ToString();
            Pageindex.Text = CurPage.ToString();
            Literal1.Text = PageList(objPage.PageCount, CurPage, condition,pagesize);

            FirstPage.NavigateUrl = Request.CurrentExecutionFilePath + "?page=1&pagesize="+pagesize.ToString() + condition;
            PrevPage.NavigateUrl = Request.CurrentExecutionFilePath + "?page=" + (CurPage - 1) + "&pagesize=" + pagesize.ToString() + condition;
            NextPage.NavigateUrl = Request.CurrentExecutionFilePath + "?page=" + (CurPage + 1) + "&pagesize=" + pagesize.ToString() + condition;
            LastPaeg.NavigateUrl = Request.CurrentExecutionFilePath + "?page=" + objPage.PageCount.ToString() + "&pagesize=" + pagesize.ToString() + condition;
            if (CurPage <= 1 && objPage.PageCount <= 1)
            {
                FirstPage.NavigateUrl = "javascript:void(0);";
                PrevPage.NavigateUrl = "javascript:void(0);";
                NextPage.NavigateUrl = "javascript:void(0);";
                LastPaeg.NavigateUrl = "javascript:void(0);";
            }
            if (CurPage <= 1 && objPage.PageCount > 1)
            {
                FirstPage.NavigateUrl = "javascript:void(0);";
                PrevPage.NavigateUrl = "javascript:void(0);";
            }
            if (CurPage >= objPage.PageCount)
            {
                NextPage.NavigateUrl = "javascript:void(0);";
                LastPaeg.NavigateUrl = "javascript:void(0);";
            }
        }
        catch (Exception error)
        {
            Response.Write(error.ToString());
        }

    }
    private string PageList(int Pagecount, int Pageindex, string condition,int pagesieze)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("<select id=\"Page_Jump\" name=\"Page_Jump\" onchange=\"window.location='" + Request.CurrentExecutionFilePath + "?page='+ this.options[this.selectedIndex].value + '&pagesize="+pagesieze + condition + "';\">");

        for (int i = 1; i <= Pagecount; i++)
        {
            if (Pageindex == i)
                sb.Append("<option value='" + i + "' selected>" + i + "</option>");
            else
                sb.Append("<option value='" + i + "'>" + i + "</option>");
        }
        sb.Append("</select>");
        //分页大小
        sb.Append("页  每页显示<select id=\"Pagesize_Jump\" name=\"Pagesize_Jump\" onchange=\"window.location='" + Request.CurrentExecutionFilePath + "?page="+Pageindex+"&pagesize='+ this.options[this.selectedIndex].value + '" + condition + "';\">");
                for (int i = 1; i <= 5; i++)
                {
                    if (pagesieze == i * 10)
                        sb.Append("<option value='" + i*10 + "' selected>" + i*10 + "</option>");
                    else
                        sb.Append("<option value='" + i *10+ "'>" + i*10 + "</option>");
                }
        sb.Append("</select>条记录");
        return sb.ToString();
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string condition = "";
        if (ddlMonth.Text != "0")
            condition += "&qj=" + ddlMonth.Text;
        if (ddlMonth1.Text != "0")
            condition += "&jz=" + ddlMonth1.Text;
        if (ddlpfdw.Text != "0")
            condition += "&dw=" + Server.UrlEncode(ddlpfdw.Text);
        if (ddlqywh.Text != "0")
            condition += "&qywh=" + Server.UrlEncode(ddlqywh.Text);
        if (gdzt.Text != "0")
            condition += "&gdzt=" + gdzt.Text;
        if (zgid.Text != "")
            condition += "&zgid=" + zgid.Text;
        ClientScript.RegisterStartupScript(this.GetType(), "redirect", "window.location='" + Request.CurrentExecutionFilePath + "?page=1" + condition + "'", true);

    }
    protected void btnExportExcel_Click(object sender, EventArgs e)
    {
        string outputFileName = "";
        if (Request.QueryString["qj"] != null)
        {
            outputFileName += Request.QueryString["qj"].ToString()+"-";
        }
        if (Request.QueryString["jz"] != null)
        {
            outputFileName += Request.QueryString["jz"].ToString() + "-";
        }
        outputFileName += "线路整改信息明细表.xls";
        DataTable dt = GetDataTable("select id,pfdw,pdr,pdsj,lxr,lxdh,whdw,fzr,zgqy,czwt,zgyq,zgsx,qywh,zgcs,zgr,tdyy,wjsj,qrwjsj,zgbz,fcyj,fcr,fcsj from dlysxx  ");

        dt.Columns[0].ColumnName = "编号";
        dt.Columns[1].ColumnName = "派单单位";
        dt.Columns[2].ColumnName = "派单人";
        dt.Columns[3].ColumnName = "派单时间";
        dt.Columns[4].ColumnName = "联系人";
        dt.Columns[5].ColumnName = "联系电话";
        dt.Columns[6].ColumnName = "维护单位";
        dt.Columns[7].ColumnName = "负责人";
        dt.Columns[8].ColumnName = "整改区域";
        dt.Columns[9].ColumnName = "存在问题";
        dt.Columns[10].ColumnName = "整改要求";
        dt.Columns[11].ColumnName = "整改时限";
        dt.Columns[12].ColumnName = "区域维护";
        dt.Columns[13].ColumnName = "整改措施";
        dt.Columns[14].ColumnName = "整改人";
        dt.Columns[15].ColumnName = "退单原因";
        dt.Columns[16].ColumnName = "完结时间";
        dt.Columns[17].ColumnName = "确认完结时间";
        dt.Columns[18].ColumnName = "整改备注";
        dt.Columns[19].ColumnName = "复查意见";
        dt.Columns[20].ColumnName = "复查人";
        dt.Columns[21].ColumnName = "复查时间";
        xlsGridview(dt, outputFileName);
    }
    /// <summary>
    /// 绑定数据库生成XLS报表
    /// </summary>
    /// <param name="ds">获取DataSet数据集</param>
    /// <param name="xlsName">报表表名</param>
    private void xlsGridview(DataTable dt, string xlsName)
    {
        XlsDocument xls = new XlsDocument();
        xls.FileName = Server.UrlEncode(xlsName);
        int rowIndex = 1;
        int colIndex = 0;
        Worksheet sheet = xls.Workbook.Worksheets.Add("sheet");//状态栏标题名称
        Cells cells = sheet.Cells;
        //设置样式
        XF xf = xls.NewXF();
        xf.HorizontalAlignment = HorizontalAlignments.Centered;
        xf.VerticalAlignment = VerticalAlignments.Centered;
        xf.TextWrapRight = true;
        xf.UseBorder = true;
        xf.TopLineStyle = 1;
        xf.TopLineColor = Colors.Black;
        xf.BottomLineStyle = 1;
        xf.BottomLineColor = Colors.Black;
        xf.LeftLineStyle = 1;
        xf.LeftLineColor = Colors.Black;
        xf.RightLineStyle = 1;
        xf.RightLineColor = Colors.Black;
        xf.Font.Bold = true;
        foreach (DataColumn col in dt.Columns)
        {
            colIndex++;
            Cell cell = cells.Add(1, colIndex, col.ColumnName,xf);
        }

        foreach (DataRow row in dt.Rows)
        {
            rowIndex++;
            colIndex = 0;
            foreach (DataColumn col in dt.Columns)
            {
                colIndex++;
                Cell cell = cells.Add(rowIndex, colIndex, row[col.ColumnName].ToString(),xf);//转换为数字型
                //如果你数据库里的数据都是数字的话 最好转换一下，不然导入到Excel里是以字符串形式显示。
                cell.Font.FontFamily = FontFamilies.Roman; //字体
                cell.Font.Bold = false;  //字体为粗体            
            }
        }
        xls.Send();
        Response.Flush();
        Response.End();
    }
   
    
    /// <summary>
    /// 处理区域领料
    /// </summary>
    /// <param name="id">整改id</param>
    /// <param name="zgll">整改领料</param>
    /// <param name="zgcs">区域维护</param>
    /// <returns></returns>
    public string handleQYLL(string id, string zgll)
   {
       string str="";
           if (zgll == "1")//已领料
               str = "<a class='gray'   href=\"xlzgllxxxq.aspx?zgid=" + id + "\" target=\"_blank\" title='点击查看领料信息'>已领料</a>";
           else //未领料
           {
               //角色判断，1：派单人
               if (Session["roleid"] != null && Session["roleid"].ToString() == "1")
               {
                       str = "<a class='b_blue' href=\"xlzgxxlllr.aspx?id=" + id + "\" title='点击录入领料信息'>未领料</a>";
               }
               else //非区域维护
                   str = "<span class='b_blue'>未领料</a>";
           }
  
       return str;
    }
  
    /// <summary>
    /// 处理县公司库管对区域维护领料单确认出库(县公司只需要外包确认减少一步操作)
    /// </summary>
    /// <param name="id">整改编号</param>
    /// <param name="kgck">库管确认出库</param>
    /// <param name="zgll">线管确认</param>
    /// <returns></returns>
    public string handleKGQR(string id, string kgck, string zgll)
    {
        string str = "";
        if (kgck == "1")//库管已确认出库
        {
            str = "<a class='gray'   href=\"xlzgxxxq.aspx?zgid=" + id + "\"  title='点击查看整改详情'>已出库</a>";
        }
        else
        {//库管未确认出库
            //角色判断，2：库管有权对线路主管已确认的区域维护领料单进行确认出库
            if (Session["roleid"] != null && Session["roleid"].ToString() == "2")//是库管
            {
                if (zgll == "0")//未领料
                    str = "<a href=\"javascript:alert('没有领料信息，不能进行出库操作！');\" class='b_lightblue'>未出库</a> ";
                else
                    str = "<a class='b_lightblue' href=\"xlzgxxkgllck.aspx?zgid=" + id + "\" title='点击进行区域维护领料单进行出库操作'>未出库</a>";
            }
            else//非库管
                str = "<span class='b_lightblue'>未出库</a>";
        }
        return str;

    }
    /// <summary>
    /// 处理外包单位或区域维护录入整改完结时间
    /// </summary>
    /// <param name="id">整改编号</param>
    /// <param name="wjsj">完结时间</param>
    /// <param name="kgck">库管出库</param>
    /// <returns></returns>
    public string handleWBZGWJ(string id, string wjsj, string kgck)
    {
        string str = "";
        if (wjsj != "")//外包已录入完结时间
        {
            str = "<a class='gray'   href=\"xlzgxxxq.aspx?zgid=" + id + "\"  title='点击查看整改详情'>已整改</a>";
        }
        else
        {//外包未确认
            //角色判断，3||7：外包单位和区域维护有权录入整改完结时间
            if (Session["roleid"] != null &&( Session["roleid"].ToString() == "3"|| Session["roleid"].ToString() == "7"))//是外包或区域主管单位
            {
                if (kgck == "0")//领料未出库
                    str = "<a href=\"javascript:alert('该整改领料还未出库，不能进行设置整改完结！');\" class='b_green'>未整改</a> ";
                else
                    str = "<a class='b_green' href=\"xlzgxxwbzgwj.aspx?zgid=" + id + "\" title='点击进行外包整改完结'>未整改</a>";
            }
            else//非外包
                str = "<span class='b_green'>未整改</a>";
        }
        return str;
    }
    /// <summary>
    /// 处理 派单人确认完结时间和未完结原因
    /// </summary>
    /// <param name="id">编号</param>
    /// <param name="qrwjsj">确认完结时间</param>
    /// <param name="zgbz">整改备注</param>
    /// <param name="wjsj">完结时间</param>
    /// <returns></returns>
    public string handleXGQRWJ(string id, string qrwjsj, string zgbz,string wjsj)
    {
        string str = "";
        if (qrwjsj != "")//已确认完结
            str = "<a class='gray'   href=\"xlzgxxxq.aspx?zgid=" + id + "\"  title='点击查看整改详情'>已完结</a>";
        else
        {
            //派单人有权限确认整改完结
            if (Session["roleid"] != null && Session["roleid"].ToString() == "1")//是派单人
            {
                if (wjsj == "")//外包未设置完结时间
                    str = "<a href=\"javascript:alert('该整改未完成，不能完结！');\" class='b_red'>未完结</a> ";
                else //外包已设置完结时间
                {
                    if (zgbz == "")
                        str = "<a class='b_red' href=\"xlzgxxqrzgwj.aspx?zgid=" + id + "\" title='点击录入确认整改信息'>未完结</a>";
                    else
                         str = "<a class='b_red' href=\"xlzgxxqrzgwj.aspx?bz=1&zgid=" + id + "\" title='点击录入确认整改信息'>未完结</a>";
                }
            }
            else //非派单人
                str = "<span class='b_red'>未完结</a>";
        }
        return str;
    }

    #region 处理整改复查,此流程已取消
    
  /*
    /// <summary>
    /// 处理整改复查
    /// </summary>
    /// <param name="id">编号</param>
    /// <param name="fcr">复查人</param>
    /// <param name="zgtl">整改退料</param>
    /// <returns></returns>
   public string handleFC(string id, string fcr, string qrwjsj)
   {
       string str = "";
       if (fcr != "")//已复查
           str = "<a class='gray'   href=\"xlzgxxxq.aspx?zgid=" + id + "\"  title='点击查看整改详情'>已复查</a>";
       else
       {
           //判断
           if (Session["roleid"] != null && (Session["roleid"].ToString() == "1" || Session["roleid"].ToString() == "5" || Session["roleid"].ToString() == "8"))
           {
               if (qrwjsj == "")//派单人未确认整改完结
                   str = "<a href=\"javascript:alert('该整改确认完结，不能复查！');\" class='b_orange'>未复查</a> ";
               else //派单人已确认整改完结
                   str = "<a class='b_orange' href=\"xlzgxxfc.aspx?id=" + id + "\" title='点击录入整改复查信息'>未复查</a>";
           }
           else //非派单人
               str = "<span class='b_orange'>未复查</a>";
       }
       return str;
   }
   * */
    #endregion
   /// <summary>
   /// 处理退料信息
   /// </summary>
   /// <param name="id">编号</param>
   /// <param name="zgtl">是否退料</param>
   /// <param name="zgtd">整改退单</param>
   /// <returns></returns>
   public string handleTL(string id, string zgtl,string zgtd)
   {
       string str = "";
       if (zgtl == "1")
           str = "<a class='gray'   href=xlzgtlxxxq.aspx?zgid=" + id + " title='点击查看退料信息'>已退料</a>";
       else
       {
           if (Session["roleid"] != null && Session["roleid"].ToString() == "2")//是库管
           {
               if(zgtd=="1")
                   str = "<a href=\"javascript:alert('该整改已退单，不用进行退料操作！');\" class='b_lightblue'>未退料</a> ";
               else
                   str = "<a class='b_lightblue' href=\"xlzgxxtllr.aspx?id=" + id + "\" title='点击录入退料信息'>未退料</a>";
           }
           else //非库管
               str = "<span class='b_lightblue'>未退料</a>";
       }
       return str;
   }
}