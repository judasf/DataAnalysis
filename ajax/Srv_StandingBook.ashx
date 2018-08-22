<%@ WebHandler Language="C#" Class="Srv_StandingBook" %>

using System;
using System.Web;
using System.Web.SessionState;
using System.Reflection;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Generic;
/// <summary>
/// 故障维修台账管理
/// </summary>
public class Srv_StandingBook : IHttpHandler, IRequiresSessionState
{
    HttpRequest Request;
    HttpResponse Response;
    HttpSessionState Session;
    HttpServerUtility Server;
    HttpCookie Cookie;


    /// <summary>
    /// 所在部门
    /// </summary>
    string deptname;
    /// <summary>
    /// 岗位
    /// </summary>
    string roleid;

    public void ProcessRequest(HttpContext context)
    {
        //不让浏览器缓存
        context.Response.Buffer = true;
        context.Response.ExpiresAbsolute = DateTime.Now.AddDays(-1);
        context.Response.AddHeader("pragma", "no-cache");
        context.Response.AddHeader("cache-control", "");
        context.Response.CacheControl = "no-cache";
        context.Response.ContentType = "text/plain";

        Request = context.Request;
        Response = context.Response;
        Session = context.Session;
        Server = context.Server;
        //验证token,防止CRSF
        string token = "";
        if (string.IsNullOrEmpty(Request.Headers["token"]))
            token = Request.Form["token"];
        else
            token = Request.Headers["token"];

        if (Session["_token"] == null || string.IsNullOrEmpty(token) || token != Session["_token"].ToString())
        {
            Response.Write("{\"success\":false,\"msg\":\"非法登录，请重新登陆后再进行操作！\",\"total\":-1,\"rows\":[]}");
            return;
        }
        //判断登陆状态
        if (Session["uname"] == null || Session["uname"].ToString() == "")
        {
            Response.Write("{\"success\":false,\"msg\":\"登陆超时，请重新登陆后再进行操作！\",\"total\":-1,\"rows\":[]}");
            return;
        }
        else
        {
            deptname = Session["deptname"].ToString();
            roleid = Session["roleid"].ToString();
        }
        string method = HttpContext.Current.Request.PathInfo.Substring(1);
        if (method.Length != 0)
        {
            MethodInfo methodInfo = this.GetType().GetMethod(method);
            if (methodInfo != null)
            {
                methodInfo.Invoke(this, null);
            }
            else
                Response.Write("{\"success\":false,\"msg\":\"Method Not Matched !\"}");
        }
        else
        {
            Response.Write("{\"success\":false,\"msg\":\"Method not Found !\"}");
        }
    }
    #region 故障工单管理
    /// <summary>
    /// 设置故障工单查询条件
    /// </summary>
    /// <returns></returns>
    public string SetQueryConditionForFault()
    {
        string queryStr = "";
        //设置查询条件
        List<string> list = new List<string>();
        //提交开始日期
        if (!string.IsNullOrEmpty(Request.Form["sdate"]))
            list.Add(" FaultDate >='" + Request.Form["sdate"] + "'");
        //提交截止日期
        if (!string.IsNullOrEmpty(Request.Form["edate"]))
            list.Add(" FaultDate <='" + Request.Form["edate"] + "'");
        //按所属县市
        if (!string.IsNullOrEmpty(Request.Form["cityname"]))
            list.Add(" cityname ='" + Request.Form["cityname"] + "'");
        //按局站编码
        if (!string.IsNullOrEmpty(Request.Form["stationid"]))
            list.Add(" stationid like'%" + Request.Form["stationid"] + "%'");
        //按机房名称
        if (!string.IsNullOrEmpty(Request.Form["roomname"]))
            list.Add(" roomname like'%" + Request.Form["roomname"] + "%'");
        //按故障单号
        if (!string.IsNullOrEmpty(Request.Form["faultorderno"]))
            list.Add(" faultorderno like'%" + Request.Form["faultorderno"] + "%'");
        //管理员和运维部查看所有，其余只看本部门
        if (roleid != "0" && roleid != "4")
        {
            list.Add(" cityname='" + deptname + "' ");
        }
        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 获取故障工单 数据page:1 rows:10 sort:id order:asc
    /// </summary>
    public void GetFaultOrder()
    {
        int total = 0;
        string where = SetQueryConditionForFault();
        string tableName = " SB_FaultOrderInfo ";
        string fieldStr = "*,CONVERT(VARCHAR(50),inputtime,23) as inputdate";
        DataSet ds = SqlHelper.GetPagination(tableName, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    ///  SB_FaultOrderInfo
    /// </summary>
    public void GetFaultOrderInfoByID()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = id;
        string sql = "SELECT * FROM SB_FaultOrderInfo  where ID=@id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    /// <summary>
    ///  通过故障单号获取信息详情
    /// </summary>
    public void GetFaultOrderInfoByFaultNo()
    {
        string faultno = Convert.ToString(Request.Form["faultno"]);
        SqlParameter paras = new SqlParameter("@faultno", SqlDbType.VarChar);
        paras.Value = faultno;
        //本单位的维修台账只能从本单位的故障工单信息获取，并且一张故障工单只能生成一张维修台账
        string where = " and cityname='" + deptname + "'";
        string sql = "IF NOT  EXISTS(SELECT * FROM dbo.SB_DailyRepairInfo WHERE faultorderno=@faultno) ";
        sql += "SELECT * FROM SB_FaultOrderInfo  where FaultOrderNo=@faultno" + where;
        sql += " else  select * from SB_FaultOrderInfo where id=0";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }

    /// <summary>
    /// 导出故障工单明细
    /// </summary>
    public void ExportFaultOrder()
    {
        string where = SetQueryConditionForFault();
        if (where != "")
            where = " where " + where;
        StringBuilder sql = new StringBuilder();
        sql.Append("select FaultOrderNo,FaultDate,StationID,RoomName,FaultPlace,CityName,PointType,EqType,EqModel,FaultMsg,InScope,FaultUser,ConfirmUser,ConfirmOrderName,Memo,InputTime ");
        sql.Append(" from SB_FaultOrderInfo ");
        sql.Append(where);
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.Columns[0].ColumnName = "故障单号";
        dt.Columns[1].ColumnName = "故障日期";
        dt.Columns[2].ColumnName = "局站编码";
        dt.Columns[3].ColumnName = "机房名称";
        dt.Columns[4].ColumnName = "故障地点";
        dt.Columns[5].ColumnName = "单位";
        dt.Columns[6].ColumnName = "网点类别";
        dt.Columns[7].ColumnName = "设备类型";
        dt.Columns[8].ColumnName = "设备型号";
        dt.Columns[9].ColumnName = "故障现象";
        dt.Columns[10].ColumnName = "是否外包范围";
        dt.Columns[11].ColumnName = "报障人";
        dt.Columns[12].ColumnName = "确认人";
        dt.Columns[13].ColumnName = "确认单扫描件";
        dt.Columns[14].ColumnName = "备注";
        dt.Columns[15].ColumnName = "录单日期";
        ExcelHelper.ExportByWeb(dt, "", "故障工单台账.xls", "故障工单台账");
    }
    /*
   /// <summary>
   /// 更新故障工单信息
   /// </summary>
   public void UpdateFaultOrderInfo()
   {
       int id = Convert.ToInt32(Request.Form["id"]);
       //局站编码
       string anid = Convert.ToString(Request.Form["anid"]);
       //机房名称
       string roomname = Convert.ToString(Request.Form["roomname"]);
       //所属县市
       string cityname = Convert.ToString(Request.Form["cityname"]);
       //详细地址
       string address = Convert.ToString(Request.Form["address"]);
       //网点类型
       string pointtype = Convert.ToString(Request.Form["pointtype"]);
       //设备分类
       string eqtype = Convert.ToString(Request.Form["eqtype"]);
       //经度
       string longitude = Convert.ToString(Request.Form["longitude"]);
       //纬度
       string dimension = Convert.ToString(Request.Form["dimension"]);
       //面积
       string area = Convert.ToString(Request.Form["area"]);
       //产权性质
       string propertyright = Convert.ToString(Request.Form["propertyright"]);
       //动环监控
       string demstatus = Convert.ToString(Request.Form["demstatus"]);
       //动环设备厂家
       string demem = Convert.ToString(Request.Form["demem"]);
       //机房接地电阻
       string roomresistance = Convert.ToString(Request.Form["roomresistance"]);
       //机房供电方式
       string powersupplymode = Convert.ToString(Request.Form["powersupplymode"]);
       //机房负载电流
       string roomloadcurrent = Convert.ToString(Request.Form["roomloadcurrent"]);
       string memo1 = Convert.ToString(Request.Form["memo1"]);
       string memo2 = Convert.ToString(Request.Form["memo2"]);
       string memo3 = Convert.ToString(Request.Form["memo3"]);
       string memo4 = Convert.ToString(Request.Form["memo4"]);
       List<SqlParameter> _paras = new List<SqlParameter>();
       _paras.Add(new SqlParameter("@id", id));
       _paras.Add(new SqlParameter("@anid", anid));
       _paras.Add(new SqlParameter("@roomname", roomname));
       _paras.Add(new SqlParameter("@cityname", cityname));
       _paras.Add(new SqlParameter("@address", address));
       _paras.Add(new SqlParameter("@eqtype", eqtype));
       _paras.Add(new SqlParameter("@pointtype", pointtype));
       _paras.Add(new SqlParameter("@longitude", longitude));
       _paras.Add(new SqlParameter("@dimension", dimension));
       _paras.Add(new SqlParameter("@area", area));
       _paras.Add(new SqlParameter("@propertyright", propertyright));
       _paras.Add(new SqlParameter("@demstatus", demstatus));
       _paras.Add(new SqlParameter("@demem", demem));
       _paras.Add(new SqlParameter("@roomresistance", roomresistance));
       _paras.Add(new SqlParameter("@powersupplymode", powersupplymode));
       _paras.Add(new SqlParameter("@roomloadcurrent", roomloadcurrent));
       _paras.Add(new SqlParameter("@memo1", memo1));
       _paras.Add(new SqlParameter("@memo2", memo2));
       _paras.Add(new SqlParameter("@memo3", memo3));
       _paras.Add(new SqlParameter("@memo4", memo3));
       StringBuilder sql = new StringBuilder();
       sql.Append("update  SB_FaultOrderInfo set anid=@anid,roomname=@roomname,cityname=@cityname,pointtype=@pointtype,address=@address,eqtype=@eqtype,longitude=@longitude,dimension=@dimension,area=@area,propertyright=@propertyright,demstatus=@demstatus,demem=@demem,roomresistance=@roomresistance,powersupplymode=@powersupplymode,roomloadcurrent=@roomloadcurrent,memo1=@memo1,memo2=@memo2,memo3=@memo3,memo4=@memo4,InputTime=getdate()  where id=@id");
       int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), _paras.ToArray());
       if (result == 1)
           Response.Write("{\"success\":true,\"msg\":\"资源更新成功！\"}");
       else
           Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
   }
       */
    /// <summary>
    /// 获取故障单自动编号
    /// </summary>
    public void GetFaultOrderNo()
    {
        DataSet dr = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, "SELECT faultorderno  FROM SB_AutoNo");
        string currentId = dr.Tables[0].Rows[0][0].ToString();
        int newno = 0;
        string datePre = DateTime.Now.ToString("yyyyMM");
        string autono = "GZ";
        if (currentId.Substring(0, 6) == datePre)
            newno = int.Parse(currentId.Substring(6)) + 1;

        else
            newno = 1;
        autono += datePre + newno.ToString().PadLeft(5, '0');
        SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, "update SB_AutoNo set faultorderno =" + datePre + newno.ToString().PadLeft(5, '0'));
        Response.Write("{\"success\":true,\"msg\":\"成功\",\"autono\":\"" + autono + "\"}");
    }
    //<summary>
    //新增故障工单
    //</summary>
    public void SaveFaultOrderInfo()
    {
        StringBuilder sql = new StringBuilder();
        string faultorderno = Convert.ToString(Request.Form["faultorderno"]);
        string faultdate = Convert.ToString(Request.Form["faultdate"]);
        string stationid = Convert.ToString(Request.Form["stationid"]);
        string roomname = Convert.ToString(Request.Form["roomname"]);
        string faultplace = Convert.ToString(Request.Form["faultplace"]);
        string cityname = Convert.ToString(Request.Form["cityname"]);
        string pointtype = Convert.ToString(Request.Form["pointtype"]);
        string eqtype = Convert.ToString(Request.Form["eqtype"]);
        string eqmodel = Convert.ToString(Request.Form["eqmodel"]);
        string faultmsg = Convert.ToString(Request.Form["faultmsg"]);
        string inscope = Convert.ToString(Request.Form["inscope"]);
        string faultuser = Convert.ToString(Request.Form["faultuser"]);
        string confirmuser = Convert.ToString(Request.Form["confirmuser"]);
        string memo = Convert.ToString(Request.Form["memo"]);

        //故障确认单扫描件
        string confirmorderpath = Convert.ToString(Request.Form["report_order"]);
        string confirmordername = "";
        //保存故障确认单扫描件
        if (string.IsNullOrEmpty(confirmorderpath))
        {
            Response.Write("{\"success\":false,\"msg\":\"请上传故障确认单扫描件！\"}");
            return;
        }
        else
        {
            confirmordername = confirmorderpath.Substring(confirmorderpath.LastIndexOf('/') + 1);
        }
        //维修前现场照片
        string filesStr = Convert.ToString(Request.Form["report"]);
        //保存维修前现场照片
        if (string.IsNullOrEmpty(filesStr))
        {
            Response.Write("{\"success\":false,\"msg\":\"请上传维修前照片！\"}");
            return;
        }
        else
        {
            string[] filesPath = filesStr.Split(new String[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            foreach (string path in filesPath)
            {
                string fileName = path.Substring(path.LastIndexOf('/') + 1);
                sql.Append("Insert into SB_Attachment values(@faultorderno,'" + fileName + "','" + path + "',0);");
            }
        }
        //3、保存信息
        sql.Append("insert SB_FaultOrderInfo values(@faultorderno,@faultdate,@stationid,@roomname,@faultplace,@cityname,@pointtype,@eqtype,@eqmodel,@faultmsg,@inscope,@faultuser,@confirmuser,@confirmordername,@confirmorderpath,@memo,@inputuser,getdate());");

        //设定参数
        List<SqlParameter> _paras = new List<SqlParameter>();
        _paras.Add(new SqlParameter("@faultorderno", faultorderno));
        _paras.Add(new SqlParameter("@faultdate", faultdate));
        _paras.Add(new SqlParameter("@stationid", stationid));
        _paras.Add(new SqlParameter("@roomname", roomname));
        _paras.Add(new SqlParameter("@faultplace", faultplace));
        _paras.Add(new SqlParameter("@cityname", cityname));
        _paras.Add(new SqlParameter("@pointtype", pointtype));
        _paras.Add(new SqlParameter("@eqtype", eqtype));
        _paras.Add(new SqlParameter("@eqmodel", eqmodel));
        _paras.Add(new SqlParameter("@faultmsg", faultmsg));
        _paras.Add(new SqlParameter("@inscope", inscope));
        _paras.Add(new SqlParameter("@faultuser", faultuser));
        _paras.Add(new SqlParameter("@confirmuser", confirmuser));
        _paras.Add(new SqlParameter("@confirmordername", confirmordername));
        _paras.Add(new SqlParameter("@confirmorderpath", confirmorderpath));
        _paras.Add(new SqlParameter("@memo", memo));
        _paras.Add(new SqlParameter("@inputuser", Session["uname"].ToString()));

        //使用事务提交操作
        using (SqlConnection conn = SqlHelper.GetConnection())
        {
            conn.Open();
            using (SqlTransaction trans = conn.BeginTransaction())
            {
                try
                {
                    SqlHelper.ExecuteNonQuery(trans, CommandType.Text, sql.ToString(), _paras.ToArray());
                    trans.Commit();
                    Response.Write("{\"success\":true,\"msg\":\"故障工单录入成功!\"}");
                }
                catch
                {
                    trans.Rollback();
                    Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
                    throw;
                }
            }
        }
    }
    /// <summary>
    /// 通过工单自动编号AutoNo获取附件列表
    /// </summary>
    public void GetAttachmentByAutoNo()
    {
        string InfoAutoID = Convert.ToString(Request.Form["no"]);
        SqlParameter paras = new SqlParameter("@InfoAutoID", SqlDbType.VarChar);
        paras.Value = InfoAutoID;
        string sql = "SELECT * FROM SB_Attachment  where InfoAutoID=@InfoAutoID";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }

    /// <summary>
    /// 删除故障工单；1、工单信息；2、上传的维修前照片附件
    /// </summary>
    public void RemoveFaultOrderByOrderNo()
    {
        string orderno = Convert.ToString(Request.Form["orderno"]);
        SqlParameter paras = new SqlParameter("@orderno", SqlDbType.VarChar);
        paras.Value = orderno;
        StringBuilder sql = new StringBuilder();
        sql.Append("DELETE FROM SB_FaultOrderInfo WHERE faultorderno=@orderno;");
        sql.Append("DELETE FROM SB_Attachment WHERE InfoAutoID=@orderno;");
        //使用事务提交操作
        using (SqlConnection conn = SqlHelper.GetConnection())
        {
            conn.Open();
            using (SqlTransaction trans = conn.BeginTransaction())
            {
                try
                {
                    SqlHelper.ExecuteNonQuery(trans, CommandType.Text, sql.ToString(), paras);
                    trans.Commit();
                    Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
                }
                catch
                {
                    trans.Rollback();
                    Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
                    throw;
                }
            }
        }
    }
    /*
/// <summary>
/// 通过id删除附件
/// </summary>
public void RemoveAttachById()
{
int id = 0;
int.TryParse(Request.Form["id"], out id);
SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
paras.Value = id;
string sql = "DELETE FROM Attachment WHERE id=@id";
int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
if (result == 1)
    Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
else
    Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
}
*/

    #endregion 故障工单管理
    #region 日常维修台账
    /// <summary>
    /// 设置日常维修台账查询条件
    /// </summary>
    /// <returns></returns>
    public string SetQueryConditionForRepair()
    {
        string queryStr = "";
        //设置查询条件
        List<string> list = new List<string>();
        //提交开始日期
        if (!string.IsNullOrEmpty(Request.Form["sdate"]))
            list.Add(" repairdate >='" + Request.Form["sdate"] + "'");
        //提交截止日期
        if (!string.IsNullOrEmpty(Request.Form["edate"]))
            list.Add(" repairdate <='" + Request.Form["edate"] + "'");
        //按所属县市
        if (!string.IsNullOrEmpty(Request.Form["cityname"]))
            list.Add(" cityname ='" + Request.Form["cityname"] + "'");
        //按局站编码
        if (!string.IsNullOrEmpty(Request.Form["stationid"]))
            list.Add(" stationid like'%" + Request.Form["stationid"] + "%'");
        //按机房名称
        if (!string.IsNullOrEmpty(Request.Form["roomname"]))
            list.Add(" roomname like'%" + Request.Form["roomname"] + "%'");
        //按维修单号
        if (!string.IsNullOrEmpty(Request.Form["repairorderno"]))
            list.Add(" repairorderno like'%" + Request.Form["repairorderno"] + "%'");
        //按故障单号
        if (!string.IsNullOrEmpty(Request.Form["faultorderno"]))
            list.Add(" faultorderno like'%" + Request.Form["faultorderno"] + "%'");
        //管理员和运维部查看所有，其余只看本部门
        if (roleid != "0" && roleid != "4")
        {
            list.Add(" cityname='" + deptname + "' ");
        }
        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 获取日常维修台账 数据page:1 rows:10 sort:id order:asc
    /// </summary>
    public void GetDailyRepairInfo()
    {
        int total = 0;
        string where = SetQueryConditionForRepair();
        string tableName = " SB_DailyRepairInfo ";
        string fieldStr = "*";
        DataSet ds = SqlHelper.GetPagination(tableName, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    ///  SB_DailyRepairInfo
    /// </summary>
    public void GetDailyRepairInfoByID()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = id;
        string sql = "SELECT * FROM SB_DailyRepairInfo  where ID=@id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    /// <summary>
    /// 获取维修单自动编号
    /// </summary>
    public void GetRepairOrderNo()
    {
        DataSet dr = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, "SELECT RepairOrderNo  FROM SB_AutoNo");
        string currentId = dr.Tables[0].Rows[0][0].ToString();
        int newno = 0;
        string datePre = DateTime.Now.ToString("yyyyMM");
        string autono = "WX";
        if (currentId.Substring(0, 6) == datePre)
            newno = int.Parse(currentId.Substring(6)) + 1;

        else
            newno = 1;
        autono += datePre + newno.ToString().PadLeft(5, '0');
        SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, "update SB_AutoNo set RepairOrderNo =" + datePre + newno.ToString().PadLeft(5, '0'));
        Response.Write("{\"success\":true,\"msg\":\"成功\",\"autono\":\"" + autono + "\"}");
    }
    /// <summary>
    /// 通过维修台账编号repairorderno获取采购项目列表
    /// </summary>
    public void GetRepairMaterialListByNo()
    {
        string repairorderno = Convert.ToString(Request.Form["no"]);
        SqlParameter paras = new SqlParameter("@repairorderno", SqlDbType.VarChar);
        paras.Value = repairorderno;
        string sql = "SELECT b.ClassName,b.TypeName,a.amount,b.Units FROM dbo.SB_DailyRepairInfo_Material AS a LEFT JOIN dbo.MaintainMaterial_TypeInfo b ON a.TypeID=b.ID  WHERE a.repairorderno=@repairorderno";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    // <summary>
    // 导出日常维修台账
    // </summary>
    public void ExportDailyRepairInfo()
    {
        string where = SetQueryConditionForRepair();
        if (where != "")
            where = " where " + where;
        StringBuilder sql = new StringBuilder();
        sql.Append("select repairorderno,repairdate,stationid,RoomName,repairplace,CityName,pointtype,eqtype,repairitem,RepairMaterials,reimmoney,reimtime,faultorderno,jobplanno,reportno,memo1,memo2,memo3 ");
        sql.Append(" from SB_DailyRepairInfo ");
        sql.Append(where);
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.Columns[0].ColumnName = "维修单号";
        dt.Columns[1].ColumnName = "维修日期";
        dt.Columns[2].ColumnName = "局站编码";
        dt.Columns[3].ColumnName = "机房名称";
        dt.Columns[4].ColumnName = "维修地点";
        dt.Columns[5].ColumnName = "单位";
        dt.Columns[6].ColumnName = "网点类别";
        dt.Columns[7].ColumnName = "设备类型";
        dt.Columns[8].ColumnName = "维修事项";
        dt.Columns[9].ColumnName = "维修用料";
        dt.Columns[10].ColumnName = "报账金额";
        dt.Columns[11].ColumnName = "报账时间";
        dt.Columns[12].ColumnName = "故障单号";
        dt.Columns[13].ColumnName = "作业计划编号";
        dt.Columns[14].ColumnName = "签报编号";
        dt.Columns[15].ColumnName = "备注1";
        dt.Columns[16].ColumnName = "备注2";
        dt.Columns[17].ColumnName = "备注3";
        ExcelHelper.ExportByWeb(dt, "", "日常维修台账.xls", "日常维修台账");
    }
    /*
/// <summary>
/// 更新日常维修台账
/// </summary>
public void UpdateDailyRepairInfo()
{
int id = Convert.ToInt32(Request.Form["id"]);
//单位
string deptname = Convert.ToString(Request.Form["deptname"]);
//接入网机房编号
string anid = Convert.ToString(Request.Form["anid"]);
//接入机房名称
string roomname = Convert.ToString(Request.Form["roomname"]);
//所属县市
string cityname = Convert.ToString(Request.Form["cityname"]);
//维修事项
string repairinfo = Convert.ToString(Request.Form["repairinfo"]);
//维修签报单号
string repairreportno = Convert.ToString(Request.Form["repairreportno"]);
//申请时间
string applytime = Convert.ToString(Request.Form["applytime"]);
//通知维修时间
string noticerepairtime = Convert.ToString(Request.Form["noticerepairtime"]);
//维修完成时间
string repairfinishtime = Convert.ToString(Request.Form["repairfinishtime"]);
//保修截止日期
string warrantyexpirationdate = Convert.ToString(Request.Form["warrantyexpirationdate"]);
//维修内容
string repaircontent = Convert.ToString(Request.Form["repaircontent"]);
//验收情况(包括验收人员名单)
string checkinfo = Convert.ToString(Request.Form["checkinfo"]);
//维修方名称
string repairperson = Convert.ToString(Request.Form["repairperson"]);
//维修方联系方式
string repairpersontel = Convert.ToString(Request.Form["repairpersontel"]);
//申请金额
string applymoney = Convert.ToString(Request.Form["applymoney"]);
//报账金额
string reimnursemoney = Convert.ToString(Request.Form["reimnursemoney"]);
//立项时间
string projecttime = Convert.ToString(Request.Form["projecttime"]);
//报账时间
string reimbursetime = Convert.ToString(Request.Form["reimbursetime"]);
//备注
string memo = Convert.ToString(Request.Form["memo"]);
List<SqlParameter> _paras = new List<SqlParameter>();
_paras.Add(new SqlParameter("@id", id));
_paras.Add(new SqlParameter("@deptname", deptname));
_paras.Add(new SqlParameter("@anid", anid));
_paras.Add(new SqlParameter("@roomname", roomname));
_paras.Add(new SqlParameter("@cityname", cityname));
_paras.Add(new SqlParameter("@repairinfo", repairinfo));
_paras.Add(new SqlParameter("@repairreportno", repairreportno));
_paras.Add(new SqlParameter("@applytime", applytime));
_paras.Add(new SqlParameter("@noticerepairtime", noticerepairtime));
_paras.Add(new SqlParameter("@repairfinishtime", repairfinishtime));
_paras.Add(new SqlParameter("@warrantyexpirationdate", warrantyexpirationdate));
_paras.Add(new SqlParameter("@repaircontent", repaircontent));
_paras.Add(new SqlParameter("@checkinfo", checkinfo));
_paras.Add(new SqlParameter("@repairperson", repairperson));
_paras.Add(new SqlParameter("@repairpersontel", repairpersontel));
_paras.Add(new SqlParameter("@applymoney", applymoney));
_paras.Add(new SqlParameter("@reimnursemoney", reimnursemoney));
_paras.Add(new SqlParameter("@projecttime", projecttime));
_paras.Add(new SqlParameter("@reimbursetime", reimbursetime));
_paras.Add(new SqlParameter("@memo", memo));
StringBuilder sql = new StringBuilder();
sql.Append("UPDATE SB_DailyRepairInfo SET  DeptName = @deptname,  ANID = @anid, ");
sql.Append(" RoomName = @roomname,  CityName = @cityname,  RepairInfo = @repairinfo,  ");
sql.Append("RepairReportNo = @repairreportno,  ApplyTime = @applytime,  NoticeRepairTime = @noticerepairtime,");
sql.Append("  RepairFinishTime = @repairfinishtime,  WarrantyExpirationDate = @warrantyexpirationdate,");
sql.Append("  RepairContent = @repaircontent,  CheckInfo = @checkinfo,  RepairPerson = @repairperson, ");
sql.Append(" RepairPersonTel = @repairpersontel,  ApplyMoney = @applymoney,  ReimnurseMoney = @reimnursemoney, ");
sql.Append(" ProjectTime = @projecttime,  ReimburseTime = @reimbursetime,  Memo = @memo,InputTime=getdate()  where id=@id");
int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), _paras.ToArray());
if (result == 1)
Response.Write("{\"success\":true,\"msg\":\"台账更新成功！\"}");
else
Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
}

    //<summary>
    //新增日常维修台账
    //</summary>
    public void SaveDailyRepairInfo()
    {
        //1、获取参数
        string repairorderno = Convert.ToString(Request.Form["repairorderno"]);
        string repairdate = Convert.ToString(Request.Form["repairdate"]);
        string stationid = Convert.ToString(Request.Form["stationid"]);
        string roomname = Convert.ToString(Request.Form["roomname"]);
        string repairplace = Convert.ToString(Request.Form["repairplace"]);
        string cityname = Convert.ToString(Request.Form["cityname"]);
        string pointtype = Convert.ToString(Request.Form["pointtype"]);
        string eqtype = Convert.ToString(Request.Form["eqtype"]);
        string repairitem = Convert.ToString(Request.Form["repairitem"]);
        string repairmaterials = Convert.ToString(Request.Form["repairmaterials"]);
        string reimmoney = Convert.ToString(Request.Form["reimmoney"]);
        string reimtime = Convert.ToString(Request.Form["reimtime"]);
        string faultorderno = Convert.ToString(Request.Form["faultorderno"]);
        string jobplanno = Convert.ToString(Request.Form["jobplanno"]);
        string reportno = Convert.ToString(Request.Form["reportno"]);
        string memo1 = Convert.ToString(Request.Form["memo1"]);
        string memo2 = Convert.ToString(Request.Form["memo2"]);
        string memo3 = Convert.ToString(Request.Form["memo3"]);
        //资料扫描件
        string attachfilepath = Convert.ToString(Request.Form["report"]);
        string attachfile = "";
        //保存故障确认单扫描件
        if (string.IsNullOrEmpty(attachfilepath))
        {
            Response.Write("{\"success\":false,\"msg\":\"请上传扫描件资料！\"}");
            return;
        }
        else
        {
            attachfile = attachfilepath.Substring(attachfilepath.LastIndexOf('/') + 1);
        }


        //设定参数
        List<SqlParameter> _paras = new List<SqlParameter>();
        _paras.Add(new SqlParameter("@repairorderno", repairorderno));
        _paras.Add(new SqlParameter("@repairdate", repairdate));
        _paras.Add(new SqlParameter("@stationid", stationid));
        _paras.Add(new SqlParameter("@roomname", roomname));
        _paras.Add(new SqlParameter("@repairplace", repairplace));
        _paras.Add(new SqlParameter("@cityname", cityname));
        _paras.Add(new SqlParameter("@pointtype", pointtype));
        _paras.Add(new SqlParameter("@eqtype", eqtype));
        _paras.Add(new SqlParameter("@repairitem", repairitem));
        _paras.Add(new SqlParameter("@repairmaterials", repairmaterials));
        _paras.Add(new SqlParameter("@reimmoney", reimmoney));
        _paras.Add(new SqlParameter("@reimtime", reimtime));
        _paras.Add(new SqlParameter("@attachfile", attachfile));
        _paras.Add(new SqlParameter("@attachfilepath", attachfilepath));
        _paras.Add(new SqlParameter("@faultorderno", faultorderno));
        _paras.Add(new SqlParameter("@jobplanno", jobplanno));
        _paras.Add(new SqlParameter("@reportno", reportno));
        _paras.Add(new SqlParameter("@memo1", memo1));
        _paras.Add(new SqlParameter("@memo2", memo2));
        _paras.Add(new SqlParameter("@memo3", memo3));
        _paras.Add(new SqlParameter("@inputuser", Session["uname"].ToString()));


        //2、保存
        StringBuilder sql = new StringBuilder();
        sql.Append("if exists(select * from SB_FaultOrderInfo where faultorderno=@faultorderno)");
        sql.Append("insert SB_DailyRepairInfo(repairorderno,repairdate,stationid,roomname,repairplace,cityname,pointtype,eqtype,repairitem,repairmaterials,reimmoney,reimtime,attachfile,attachfilepath,faultorderno,jobplanno,reportno,memo1,memo2,memo3,inputUser) values(");
        sql.Append("@repairorderno,@repairdate,@stationid,@roomname,@repairplace,@cityname,@pointtype,@eqtype,@repairitem,@repairmaterials,@reimmoney,@reimtime,@attachfile,@attachfilepath,@faultorderno,@jobplanno,@reportno,@memo1,@memo2,@memo3,inputuser);");

        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), _paras.ToArray());
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"新增日常维修台账成功！\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"故障单编号不存在！！\"}");
    }
        */
    //<summary>
    //新增日常维修台账,选择用料情况并出库
    //</summary>
    public void SaveDailyRepairInfo()
    {
        //1、获取参数
        string repairorderno = Convert.ToString(Request.Form["repairorderno"]);
        string repairdate = Convert.ToString(Request.Form["repairdate"]);
        string stationid = Convert.ToString(Request.Form["stationid"]);
        string roomname = Convert.ToString(Request.Form["roomname"]);
        string repairplace = Convert.ToString(Request.Form["repairplace"]);
        string cityname = Convert.ToString(Request.Form["cityname"]);
        string pointtype = Convert.ToString(Request.Form["pointtype"]);
        string eqtype = Convert.ToString(Request.Form["eqtype"]);
        string repairitem = Convert.ToString(Request.Form["repairitem"]);
        string reimmoney = Convert.ToString(Request.Form["reimmoney"]);
        string reimtime = Convert.ToString(Request.Form["reimtime"]);
        string faultorderno = Convert.ToString(Request.Form["faultorderno"]);
        string jobplanno = Convert.ToString(Request.Form["jobplanno"]);
        string reportno = Convert.ToString(Request.Form["reportno"]);
        string memo1 = Convert.ToString(Request.Form["memo1"]);
        string memo2 = Convert.ToString(Request.Form["memo2"]);
        string memo3 = Convert.ToString(Request.Form["memo3"]);
        //是否使用物料
        string isusematerial = Convert.ToString(Request.Form["isusematerial"]);
        //获取数据行数
        int rowsCount = 0;
        Int32.TryParse(Request.Form["rowsCount"], out rowsCount);
        if (rowsCount == 0 && isusematerial == "是")
        {
            Response.Write("{\"success\":false,\"msg\":\"请录入用料信息\"}");
            return;
        }
        //资料扫描件
        string attachfilepath = Convert.ToString(Request.Form["report"]);
        string attachfile = "";
        //保存维修资料
        if (string.IsNullOrEmpty(attachfilepath))
        {
            Response.Write("{\"success\":false,\"msg\":\"请上传扫描件资料！\"}");
            return;
        }
        else
        {
            attachfile = attachfilepath.Substring(attachfilepath.LastIndexOf('/') + 1);
        }
        //物料编号集合
        ArrayList stockDrawIDList = new ArrayList();
        //当前物料编号
        string stockDrawID;
        if (isusematerial == "是")
        {
            //判断重复物料编号
            for (int i = 1; i <= rowsCount; i++)
            {
                stockDrawID = Request.Form["stockdrawid" + i.ToString()].ToString();
                //页面录入的物料编号判断
                if (stockDrawIDList.Contains(stockDrawID))
                {
                    Response.Write("{\"success\":false,\"msg\":\"请不要重复选择物料编号：" + stockDrawID + "！\"}");
                    return;
                }
                else
                    stockDrawIDList.Add(stockDrawID);
            }
        }
        //根据数据行数生成sql语句和参数列表
        StringBuilder sql = new StringBuilder();
        List<SqlParameter> paras = new List<SqlParameter>();
        paras.Add(new SqlParameter("@repairorderno", repairorderno));
        paras.Add(new SqlParameter("@repairdate", repairdate));
        paras.Add(new SqlParameter("@stationid", stationid));
        paras.Add(new SqlParameter("@roomname", roomname));
        paras.Add(new SqlParameter("@repairplace", repairplace));
        paras.Add(new SqlParameter("@cityname", cityname));
        paras.Add(new SqlParameter("@pointtype", pointtype));
        paras.Add(new SqlParameter("@eqtype", eqtype));
        paras.Add(new SqlParameter("@repairitem", repairitem));
        paras.Add(new SqlParameter("@reimmoney", reimmoney));
        paras.Add(new SqlParameter("@reimtime", reimtime));
        paras.Add(new SqlParameter("@attachfile", attachfile));
        paras.Add(new SqlParameter("@attachfilepath", attachfilepath));
        paras.Add(new SqlParameter("@faultorderno", faultorderno));
        paras.Add(new SqlParameter("@jobplanno", jobplanno));
        paras.Add(new SqlParameter("@reportno", reportno));
        paras.Add(new SqlParameter("@memo1", memo1));
        paras.Add(new SqlParameter("@memo2", memo2));
        paras.Add(new SqlParameter("@memo3", memo3));
        paras.Add(new SqlParameter("@inputuser", Session["uname"].ToString()));
        paras.Add(new SqlParameter("@isusematerial", isusematerial));
        //生成维修台账记录
        sql.Append("if exists(select * from SB_FaultOrderInfo where faultorderno=@faultorderno)");
        sql.Append(" begin ");
        sql.Append(" if not exists(select * from  SB_DailyRepairInfo where faultorderno=@faultorderno)  ");
        sql.Append(" begin ");
        sql.Append("insert SB_DailyRepairInfo(repairorderno,repairdate,stationid,roomname,repairplace,cityname,pointtype,eqtype,repairitem,reimmoney,reimtime,attachfile,attachfilepath,faultorderno,jobplanno,reportno,memo1,memo2,memo3,inputUser,isusematerial) values(");
        sql.Append("@repairorderno,@repairdate,@stationid,@roomname,@repairplace,@cityname,@pointtype,@eqtype,@repairitem,@reimmoney,@reimtime,@attachfile,@attachfilepath,@faultorderno,@jobplanno,@reportno,@memo1,@memo2,@memo3,@inputuser,@isusematerial) ");
        if (isusematerial == "是")
        {
            for (int i = 1; i <= rowsCount; i++)
            {
                paras.Add(new SqlParameter("@typeid" + i.ToString(), Request.Form["typeid" + i.ToString()]));
                paras.Add(new SqlParameter("@stockdrawid" + i.ToString(), Server.UrlDecode(Request.Form["stockdrawid" + i.ToString()])));
                paras.Add(new SqlParameter("@amount" + i.ToString(), Request.Form["amount" + i.ToString()]));
                sql.Append(" UPDATE MaintainMaterial_StockDraw 	SET currentstock =currentstock-@amount" + i.ToString() + "	where id = @stockdrawid" + i.ToString() + "; ");
                sql.Append("INSERT INTO SB_DailyRepairInfo_Material values(@stockdrawid" + i.ToString() + ",@typeid" + i.ToString() + ",@repairorderno,@amount" + i.ToString() + ");");
            }
        }
        sql.Append(" end ");
        sql.Append(" end ");
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), paras.ToArray());
        if (result >= 1)
            Response.Write("{\"success\":true,\"msg\":\"日常维修台账添加成功！\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"添加失败,故障单号不存在或已生成维修台账！\"}");
    }
    /*
/// <summary>
/// 根据维修单生成运维物料领料单
/// </summary>
public void ExportWordByID()
{
    int id = Convert.ToInt32(Request.Form["id"]);
    Random myrdn = new Random();//产生随机数
                                //新文件名
    string lldh = DateTime.Now.ToString("yyyyMMdd") + myrdn.Next(1000);
    SqlParameter[] paras = new SqlParameter[]
    {
        new SqlParameter("@id", id),
        new SqlParameter("@lldh", lldh)
    };
    string sql = "SELECT @lldh as lldh,faultorderno,FaultPlace,FaultMsg FROM SB_FaultOrderInfo  where ID=@id";
    DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), paras);
    if (ds.Tables[0].Rows.Count == 1)
    {

        WordHelper wop = new WordHelper();
        try
        {

            string path = Server.MapPath("../StandingBook/TPL/"); //目录地址
            string templatePath = path + "Template.doc";  //自己做好的word
                                                          //Response.Write(templatePath);
            wop.OpenTempelte(templatePath); //打开模板文件
                                            //以下为添加内容到Word
            string FileName = "安阳联通运维物料领料单.doc";

            DataRow dr = ds.Tables[0].Rows[0];
            //遍历数据
            foreach (DataColumn dc in ds.Tables[0].Columns)
            {
                wop.FillLable(dc.ColumnName, dr[dc.ColumnName].ToString()); //替换word中指定书签的位置
            }

            wop.ResponseOut(FileName); //传入的是导出文档的文件名，导出文件
        }
        catch
        {

        }
    }

}
    */
    /// <summary>
    /// 删除维修台账
    /// </summary>
    public void RemoveRepairOrderByOrderNo()
    {
        string orderno = Convert.ToString(Request.Form["orderno"]);
        SqlParameter paras = new SqlParameter("@orderno", SqlDbType.VarChar);
        paras.Value = orderno;
        StringBuilder sql = new StringBuilder();
        sql.Append("DELETE FROM SB_DailyRepairInfo WHERE repairorderno=@orderno;");
        //使用事务提交操作
        using (SqlConnection conn = SqlHelper.GetConnection())
        {
            conn.Open();
            using (SqlTransaction trans = conn.BeginTransaction())
            {
                try
                {
                    SqlHelper.ExecuteNonQuery(trans, CommandType.Text, sql.ToString(), paras);
                    trans.Commit();
                    Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
                }
                catch
                {
                    trans.Rollback();
                    Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
                    throw;
                }
            }
        }
    }
    /// <summary>
    /// 设置物料领取页面显示在维修台账中的用料明细的查询条件
    /// </summary>
    /// <returns></returns>
    public string SetQueryConditionForDrawMaterial()
    {
        //设置查询条件
        string queryStr = "";
        //设置查询条件
        List<string> list = new List<string>();
        //当前领料编号
        if (!string.IsNullOrEmpty(Request.QueryString["id"]))
            list.Add(" a.StockDrawID='" + Request.QueryString["id"] + "' ");
        //维修台账开始日期
        if (!string.IsNullOrEmpty(Request.Form["sdate"]))
            list.Add(" c.repairdate >='" + Request.Form["sdate"] + "'");
        //维修台账截止日期
        if (!string.IsNullOrEmpty(Request.Form["edate"]))
            list.Add(" repairdate <='" + Request.Form["edate"] + "'");
        //按机房名称
        if (!string.IsNullOrEmpty(Request.Form["roomname"]))
            list.Add(" c.roomname like'%" + Request.Form["roomname"] + "%'");
        //按维修单号
        if (!string.IsNullOrEmpty(Request.Form["repairorderno"]))
            list.Add(" a.repairorderno like'%" + Request.Form["repairorderno"] + "%'");
        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    ///  在物料领取页面显示在维修台账中的用料明细 数据page:1 rows:10 sort:id order:asc
    /// </summary>
    public void GetStockDrawMaterialInfo()
    {
        int total = 0;
        string where = SetQueryConditionForDrawMaterial();
        StringBuilder sql = new StringBuilder(" dbo.SB_DailyRepairInfo_Material a");
        sql.Append(" LEFT JOIN dbo.MaintainMaterial_StockDraw b ON a.StockDrawID=b.id ");
        sql.Append(" LEFT JOIN dbo.SB_DailyRepairInfo c ON a.repairorderno=c.repairorderno ");
        sql.Append(" LEFT JOIN dbo.MaintainMaterial_TypeInfo d ON a.TypeID=d.ID ");
        string tableName = sql.ToString();
        string fieldStr = "c.id,a.repairorderno,c.repairdate,c.stationid,c.RoomName,c.repairplace,c.repairitem,d.TypeName,a.amount";
        DataSet ds = SqlHelper.GetPagination(tableName, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds.Tables[0], total, true, "amount", "repairorderno", "合计"));
    }
    // <summary>
    // 导出领料信息的维修台账使用明细
    // </summary>
    public void ExportStockDrawMaterialInfo()
    {
        string where = SetQueryConditionForDrawMaterial();
        if (where != "")
            where = " where " + where;
        StringBuilder sql = new StringBuilder();
        sql.Append("select a.repairorderno,c.repairdate,c.RoomName,c.repairplace,c.repairitem,d.TypeName,a.amount  ");
        sql.Append(" from dbo.SB_DailyRepairInfo_Material a ");
        sql.Append(" LEFT JOIN dbo.MaintainMaterial_StockDraw b ON a.StockDrawID=b.id ");
        sql.Append(" LEFT JOIN dbo.SB_DailyRepairInfo c ON a.repairorderno=c.repairorderno ");
        sql.Append(" LEFT JOIN dbo.MaintainMaterial_TypeInfo d ON a.TypeID=d.ID ");
        sql.Append(where);
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.Columns[0].ColumnName = "维修单号";
        dt.Columns[1].ColumnName = "维修日期";
        dt.Columns[2].ColumnName = "机房名称";
        dt.Columns[3].ColumnName = "维修地点";
        dt.Columns[4].ColumnName = "维修事项";
        dt.Columns[5].ColumnName = "物料型号";
        dt.Columns[6].ColumnName = "用料数量";
        ExcelHelper.ExportByWeb(dt, "", "物料使用明细.xls", "物料使用明细");
    }
    #endregion 日常维修台账

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}