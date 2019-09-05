using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.UI.HtmlControls;
using System.Text;
using org.in2bits.MyXls;

public partial class ywbkh_index : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["uname"] == null || Session["uname"].ToString() == "" || Session["roleid"] == null || Session["roleid"].ToString() == "")
                Response.Write("<script type='text/javascript'>alert('请重新登陆！');window.location.href='Default.aspx';</script>");
            else
            {
                if (Session["uname"] != null)
                    lblDeptName.Text = "当前用户：" + Session["uname"].ToString();
                BindDate();
                NewsBind();
            }
        }
    }
    /// <summary>
    /// 绑定日期
    /// </summary>
    private void BindDate()
    {
        DataSet ds = DirectDataAccessor.QueryForDataSet("select distinct  scoremonth from ywbkh_score ");
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            scoredate.Items.Add(new ListItem(dr[0].ToString()));
        }
    }
    private string GetSqlStr()
    {
        string ym = DateTime.Now.AddMonths(-1).ToString("yyyy年MM月");
        sd.InnerText = ym;
        if (Request.QueryString["qj"] != null)
            scoredate.Text = sd.InnerText = ym = Request.QueryString["qj"].ToString();//查询年
        else
            scoredate.SelectedIndex = scoredate.Items.Count - 1;
        string sql = "select * from ywbkh_score where scoremonth='" + ym + "'";
        return sql;
    }
    ///// <summary>
    ///// 绑定repeater
    ///// </summary>
    private void NewsBind()
    {
        DataSet ds = DirectDataAccessor.QueryForDataSet(GetSqlStr());
        repData.DataSource = ds;
        repData.DataBind();
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string condition = "";
        if (scoredate.Text != "0")
            condition += "qj=" + scoredate.Text;
        ClientScript.RegisterStartupScript(this.GetType(), "redirect", "window.location='" + Request.CurrentExecutionFilePath + "?" + condition + "'", true);
    }
    protected void btnExportExcel_Click(object sender, EventArgs e)
    {
        string outputFileName = "";
        if (Request.QueryString["qj"] != null)
        {
            outputFileName += Request.QueryString["qj"].ToString() + "-";
        }
        else
            outputFileName += DateTime.Now.AddMonths(-1).ToString("yyyy年MM月") + "-";
        outputFileName += "网络部部门员工考核办法.xls";
        // 手动生成数据表
        DataTable dt = DirectDataAccessor.QueryForDataSet(GetSqlStr()).Tables[0]; ;
        DataTable dtxls = new DataTable();
        //生成列
        dtxls.Columns.AddRange(new DataColumn[] { new DataColumn("a"), new DataColumn("b"), new DataColumn("c"), new DataColumn("d"), new DataColumn("e"), new DataColumn("f"), new DataColumn("g"), new DataColumn("h"), new DataColumn("i"), new DataColumn("j") });
        foreach (DataRow dr in dt.Rows)
        {
            DataRow row = dtxls.NewRow();
            row[0] = dr["uname"];
            row[1] = dr["score_a"];
            row[2] = dr["score_b"];
            row[3] = dr["score_c"];
            row[4] = dr["score_d"];
            row[5] = dr["score_e"];
            row[6] = dr["score_f1"];
            row[7] = dr["score_f2"];
            row[8] = GetGValue(dr["uname"].ToString()).ToString("f2");
            row[9] = handleZF(dr["uname"].ToString());
            dtxls.Rows.Add(row);
        }
        xlsGridview(dtxls, outputFileName);
    }
    ///// <summary>
    ///// 绑定数据库生成XLS报表
    ///// </summary>
    ///// <param name="ds">获取DataSet数据集</param>
    ///// <param name="xlsName">报表表名</param>
    private void xlsGridview(DataTable dt, string xlsName)
    {
        XlsDocument xls = new XlsDocument();
        xls.FileName = System.Web.HttpUtility.UrlEncode(xlsName, System.Text.Encoding.UTF8);
        int rowIndex = 5;
        int colIndex = 0;
        Worksheet sheet = xls.Workbook.Worksheets.Add("sheet");//状态栏标题名称
        Cells cells = sheet.Cells;
        //设置列格式
        ColumnInfo colInfo = new ColumnInfo(xls, sheet);
        colInfo.ColumnIndexStart = 0;
        colInfo.ColumnIndexEnd = 8;
        colInfo.Width = 18 * 256;
        sheet.AddColumnInfo(colInfo);
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
        //
        MergeRegion(ref sheet, xf, xlsName.Substring(0, xlsName.Length - 4), 1, 1, 1, 10);
        MergeRegion(ref sheet, xf, "姓名", 2, 5, 1, 1);
        MergeRegion(ref sheet, xf, "日常工作（权重30分）", 2, 2, 2, 4);
        MergeRegion(ref sheet, xf, "KPI考核（权重60分）", 2, 2, 5, 8);
        MergeRegion(ref sheet, xf, "胜任度(权重10分)", 2, 2, 9, 9);
        MergeRegion(ref sheet, xf, "得分", 2, 5, 10, 10);

        Cell cell1 = cells.Add(3, 2, "A", xf);
        Cell cell2 = cells.Add(3, 3, "B", xf);
        Cell cell3 = cells.Add(3, 4, "C", xf);
        Cell cell4 = cells.Add(3, 5, "D", xf);
        Cell cell5 = cells.Add(3, 6, "E", xf);
        MergeRegion(ref sheet, xf, "F", 3, 3, 7, 8);
        Cell cell6 = cells.Add(3, 9, "G", xf);
        Cell cell7 = cells.Add(4, 2, "劳动纪律", xf);
        Cell cell8 = cells.Add(4, 3, "信息报道", xf);
        Cell cell9 = cells.Add(4, 4, "基础报表", xf);
        Cell cell10 = cells.Add(4, 5, "网运指标", xf);
        Cell cell11 = cells.Add(4, 6, "工作效率", xf);
        MergeRegion(ref sheet, xf, "其它加扣分", 4, 4, 7, 8);
        Cell cell12 = cells.Add(4, 9, "贡献度胜任度职业道德", xf);

        Cell cell13 = cells.Add(5, 2, "迟到或早退一次扣1分、事假每天扣2分，病假每天扣1分执行。无故旷工半天，扣5分。无故旷工一天，扣10分，扣分随天数增加而增加.", xf);
        Cell cell14 = cells.Add(5, 3, "每人每月至少上报信息1篇，每差一篇扣5分。凡信息被市公司采用的加2分，被省公司采用的加5分。", xf);
        Cell cell15 = cells.Add(5, 4, "未按时出规定报表一次扣2分，被省公司通报一次扣5分。", xf);
        Cell cell16 = cells.Add(5, 5, "本岗位挂靠指标完成情况", xf);
        Cell cell17 = cells.Add(5, 6, "不能按时按要求完成本岗位工作任务（周工作计划内容、日常工作内容），效率低的每次每项扣2分", xf);
        MergeRegion(ref sheet, xf, "全省有通报的各项工作中，排名前三加5分，排名前6加3分，低于全省平均水平扣2分，排名12名之后扣3分，排名后三扣5分", 5, 5, 7, 8);
        Cell cell18 = cells.Add(5, 9, "部门员工得分=部门正职得分*50+部门副职得分*30%+员工互评得分*20%; 部门副职得分=员工打分均值", xf);
        //填充数据
        foreach (DataRow row in dt.Rows)
        {
            rowIndex++;
            colIndex = 0;
            foreach (DataColumn col in dt.Columns)
            {
                colIndex++;
                Cell cell = cells.Add(rowIndex, colIndex, row[col.ColumnName].ToString(), xf);//转换为数字型
                //如果你数据库里的数据都是数字的话 最好转换一下，不然导入到Excel里是以字符串形式显示。
                cell.Font.FontFamily = FontFamilies.Roman; //字体
                cell.Font.Bold = false;  //字体为粗体    
            }
        }
        xls.Send();
        Response.Flush();
        Response.End();
    }
    ///// <summary>
    ///// 合并单元格，参数列表：开始行，结束行，开始列，结束列
    ///// </summary>
    ///// <param name="ws">sheet</param>
    ///// <param name="xf">样式</param>
    ///// <param name="title">新内容</param>
    ///// <param name="startRow">开始行</param>
    ///// <param name="startCol">开始列</param>
    ///// <param name="endRow">结束行</param>
    ///// <param name="endCol">结束列</param>
    public void MergeRegion(ref Worksheet ws, XF xf, string title, int startRow, int endRow, int startCol, int endCol)
    {
        for (int i = startCol; i <= endCol; i++)
        {
            for (int j = startRow; j <= endRow; j++)
            {
                ws.Cells.Add(j, i, title, xf);
            }
        }
        ws.Cells.Merge(startRow, endRow, startCol, endCol);
    }
    private string GetRoleIDByUname(string uname)
    {
        DataSet ds = DirectDataAccessor.QueryForDataSet("select roleid from ywbkh_userinfo where username='" + uname + "'");
        return ds.Tables[0].Rows[0][0].ToString();
    }
    //处理胜任度得分
    public string handleSRD(string uname)
    {

        string str = "";
        StringBuilder sql = new StringBuilder();
       // string roleid = GetRoleIDByUname(uname);
        string tipstr = "";
        double total = 0;
        if (uname=="白凌峰"|| uname=="李常欣")
        {
            sql.Append("select username,isnull(id,'') as id ,isnull(score,'') as score from ");
            sql.Append(" (select  username  from ywbkh_userinfo where roleid='2') as a left join  ");
            sql.Append("ywbkh_marking as b on a.username=b.markinguser and b.itemid='g' and b.uname='" + uname + "' ");
            sql.Append(" and  b.scoremonth='" + sd.InnerText + "'");
           DataSet ds = DirectDataAccessor.QueryForDataSet(sql.ToString());
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                if (dr["id"].ToString() == "0")
                    tipstr += dr["username"].ToString() + ",";
                total += float.Parse(dr["score"].ToString()) / 6;
            }
            if (tipstr == "")
                str = total.ToString("f2");
            else
                str = tipstr.Substring(0, tipstr.Length - 1) + "未打分；当前得分：" + total.ToString("f2");
        }
        else
        {
            sql.Append("select username,roleid,isnull(id,'') as id ,isnull(score,'') as score  from ");
            sql.Append(" (select  username,roleid  from ywbkh_userinfo where username<>'" + uname + "') as a left join  ");
            sql.Append("ywbkh_marking as b on a.username=b.markinguser and b.itemid='g' and b.uname='" + uname + "'");
            sql.Append(" and  b.scoremonth='" + sd.InnerText + "'");
            DataSet ds = DirectDataAccessor.QueryForDataSet(sql.ToString());
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                if (dr["id"].ToString() == "0")
                    tipstr += dr["username"].ToString() + ",";
                if (dr["roleid"].ToString() == "0")
                    total += float.Parse(dr["score"].ToString()) * 0.5;
                if (dr["roleid"].ToString() == "1")
                    total += float.Parse(dr["score"].ToString()) / 2 * 0.3;
                if (dr["roleid"].ToString() == "2")
                    total += float.Parse(dr["score"].ToString()) / 5 * 0.2;
            }
            if (tipstr == "")
                str = total.ToString("f2");
            else
                str = tipstr.Substring(0, tipstr.Length - 1) + "未打分；当前得分：" + total.ToString("f2");
        }

        return str;
    }
    //处理总得分
    public string handleZF(string uname)
    {
        StringBuilder sql = new StringBuilder();
        double total = 0;
        sql.Append("select * from  ywbkh_score where  uname='" + uname + "' and scoremonth='" + sd.InnerText + "'");
        DataSet ds = DirectDataAccessor.QueryForDataSet(sql.ToString());
        if (ds.Tables[0].Rows.Count > 0)
        {
            total = 90 - float.Parse(ds.Tables[0].Rows[0]["score_a"].ToString()) - float.Parse(ds.Tables[0].Rows[0]["score_b"].ToString());
            total = total - float.Parse(ds.Tables[0].Rows[0]["score_c"].ToString()) - float.Parse(ds.Tables[0].Rows[0]["score_d"].ToString());
            total = total - float.Parse(ds.Tables[0].Rows[0]["score_e"].ToString()) - float.Parse(ds.Tables[0].Rows[0]["score_f1"].ToString()) + float.Parse(ds.Tables[0].Rows[0]["score_f2"].ToString());
        }
        total += GetGValue(uname);
        return total.ToString("f2");

    }
    public double GetGValue(string uname)
    {
        StringBuilder sql = new StringBuilder();
        double total = 0;
        //string roleid = GetRoleIDByUname(uname);
        if (uname == "白凌峰" || uname == "李常欣")
        {
            sql.Append("select username,isnull(id,'') as id ,isnull(score,'') as score from ");
            sql.Append(" (select  username  from ywbkh_userinfo where roleid='2') as a left join  ");
            sql.Append("ywbkh_marking as b on a.username=b.markinguser and b.itemid='g' and b.uname='" + uname + "' ");
            sql.Append(" and  b.scoremonth='" + sd.InnerText + "'");
            DataSet ds = DirectDataAccessor.QueryForDataSet(sql.ToString());
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                total += float.Parse(dr["score"].ToString()) / 6;
            }

        }
        else
        {
            sql.Append("select username,roleid,isnull(id,'') as id ,isnull(score,'') as score  from ");
            sql.Append(" (select  username,roleid  from ywbkh_userinfo where username<>'" + uname + "') as a left join  ");
            sql.Append("ywbkh_marking as b on a.username=b.markinguser and b.itemid='g' and b.uname='" + uname + "'");
            sql.Append(" and  b.scoremonth='" + sd.InnerText + "'");
            DataSet ds = DirectDataAccessor.QueryForDataSet(sql.ToString());
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                if (dr["roleid"].ToString() == "0")
                    total += float.Parse(dr["score"].ToString()) * 0.5;
                if (dr["roleid"].ToString() == "1")
                    total += float.Parse(dr["score"].ToString()) / 2 * 0.3;
                if (dr["roleid"].ToString() == "2")
                    total += float.Parse(dr["score"].ToString()) / 5 * 0.2;
            }

        }
        return total;
    }
}
