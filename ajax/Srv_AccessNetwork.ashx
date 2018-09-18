<%@ WebHandler Language="C#" Class="Srv_AccessNetwork" %>

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
/// 接入网资源管理
/// </summary>
public class Srv_AccessNetwork : IHttpHandler, IRequiresSessionState
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
    #region 接入网机房资源管理
    /// <summary>
    /// 设置接入网机房资源查询条件
    /// </summary>
    /// <returns></returns>
    public string SetQueryConditionForRoom()
    {
        string queryStr = "";
        //设置查询条件
        List<string> list = new List<string>();
        //按所属县市
        if (!string.IsNullOrEmpty(Request.Form["cityname"]))
        {
            list.Add(" cityname ='" + Request.Form["cityname"] + "'");
        }

        //按局站编码
        if (!string.IsNullOrEmpty(Request.Form["anid"]))
            list.Add(" anid like'%" + Request.Form["anid"] + "%'");
        //按机房名称
        if (!string.IsNullOrEmpty(Request.Form["roomname"]))
            list.Add(" roomname like'%" + Request.Form["roomname"] + "%'");
        if (roleid != "0" && roleid != "4")
        {
            if (deptname == "网络维护中心")
                list.Add(" cityname ='市区'");
            else
                list.Add(" cityname='" + deptname + "' ");
        }

        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 获取接入网机房资源 数据page:1 rows:10 sort:id order:asc
    /// </summary>
    public void GetRoomResources()
    {
        int total = 0;
        string where = SetQueryConditionForRoom();
        string tableName = " AccessNetWork_RoomResources ";
        string fieldStr = "*,CONVERT(VARCHAR(50),inputtime,23) as inputdate";
        DataSet ds = SqlHelper.GetPagination(tableName, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    ///  AccessNetWork_RoomResources
    /// </summary>
    public void GetRoomResourcesInfoByID()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = id;
        string sql = "SELECT * FROM AccessNetWork_RoomResources  where ID=@id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    /// <summary>
    /// 导入上传的机房资源台账
    /// </summary>
    public void ImportRoomResourcesInfo()
    {
        string reportPath = "";
        if (!string.IsNullOrEmpty(Request.Form["report"]))
            reportPath = Server.MapPath("~") + Request.Form["report"].ToString();
        if (ExcelHelper.CheckFileExists(reportPath) == -1)
        {
            Response.Write("{\"success\":false,\"msg\":\"上传文件不存在，请检查！\"}");
            return;
        }
        string sn = "机房资源基础台帐";
        DataTable dt = new DataTable();
        if (ExcelHelper.CheckSheetContains(reportPath, sn) == -1)
        {
            Response.Write("{\"success\":false,\"msg\":\"单元表“" + sn + "”不存在，请检查文件！\"}");
            return;
        }
        else
        {
            dt = ExcelHelper.RenderDataTableFromExcel(reportPath, sn, 1, false, 1, 0);
        }
        if (dt.TableName == "Error")
        {
            Response.Write("{\"success\":false,\"msg\":\"" + dt.Rows[0][0].ToString() + ",请检查文件！\"}");
            return;
        }
        //定义sqlparameter 
        List<SqlParameter> _paras = new List<SqlParameter>();
        StringBuilder sql = new StringBuilder();
        //遍历数据
        if (dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                try
                {
                    _paras.Add(new SqlParameter("@anid", String.IsNullOrEmpty(dr[0].ToString()) ? "" : dr[0].ToString()));
                    _paras.Add(new SqlParameter("@roomname", String.IsNullOrEmpty(dr[1].ToString()) ? "" : dr[1].ToString()));
                    _paras.Add(new SqlParameter("@cityname", String.IsNullOrEmpty(dr[2].ToString()) ? "" : dr[2].ToString()));
                    _paras.Add(new SqlParameter("@pointtype", String.IsNullOrEmpty(dr[3].ToString()) ? "" : dr[3].ToString()));
                    _paras.Add(new SqlParameter("@address", String.IsNullOrEmpty(dr[4].ToString()) ? "" : dr[4].ToString()));
                    _paras.Add(new SqlParameter("@eqtype", String.IsNullOrEmpty(dr[5].ToString()) ? "" : dr[5].ToString()));
                    _paras.Add(new SqlParameter("@longitude", String.IsNullOrEmpty(dr[6].ToString()) ? "" : dr[6].ToString()));
                    _paras.Add(new SqlParameter("@dimension", String.IsNullOrEmpty(dr[7].ToString()) ? "" : dr[7].ToString()));
                    _paras.Add(new SqlParameter("@area", String.IsNullOrEmpty(dr[8].ToString()) ? "" : dr[8].ToString()));
                    _paras.Add(new SqlParameter("@propertyright", String.IsNullOrEmpty(dr[9].ToString()) ? "" : dr[9].ToString()));
                    _paras.Add(new SqlParameter("@demstatus", String.IsNullOrEmpty(dr[10].ToString()) ? "" : dr[10].ToString()));
                    _paras.Add(new SqlParameter("@demem", String.IsNullOrEmpty(dr[11].ToString()) ? "" : dr[11].ToString()));
                    _paras.Add(new SqlParameter("@roomresistance", String.IsNullOrEmpty(dr[12].ToString()) ? "" : dr[12].ToString()));
                    _paras.Add(new SqlParameter("@powersupplymode", String.IsNullOrEmpty(dr[13].ToString()) ? "" : dr[13].ToString()));
                    _paras.Add(new SqlParameter("@roomloadcurrent", String.IsNullOrEmpty(dr[14].ToString()) ? "" : dr[14].ToString()));
                    _paras.Add(new SqlParameter("@memo1", String.IsNullOrEmpty(dr[15].ToString()) ? "" : dr[15].ToString()));
                    _paras.Add(new SqlParameter("@memo2", String.IsNullOrEmpty(dr[16].ToString()) ? "" : dr[16].ToString()));
                    _paras.Add(new SqlParameter("@memo3", String.IsNullOrEmpty(dr[17].ToString()) ? "" : dr[17].ToString()));
                    _paras.Add(new SqlParameter("@memo4", String.IsNullOrEmpty(dr[18].ToString()) ? "" : dr[18].ToString()));



                    sql.Append(" IF NOT EXISTS(SELECT * FROM AccessNetWork_RoomResources WHERE anid=@anid and roomname=@roomname) ");
                    sql.Append("INSERT INTO AccessNetWork_RoomResources (anid,roomname,cityname,pointtype,address,eqtype,longitude,dimension,area,propertyright,demstatus,demem,roomresistance,powersupplymode,roomloadcurrent,memo1,memo2,memo3,memo4)");
                    sql.Append(" VALUES (@anid,@roomname,@cityname,@pointtype,@address,@eqtype,@longitude,@dimension,@area,@propertyright,@demstatus,@demem,@roomresistance,@powersupplymode,@roomloadcurrent,@memo1,@memo2,@memo3,@memo4) ");
                    sql.Append(" ELSE ");
                    sql.Append("Update AccessNetWork_RoomResources  set  cityname=@cityname,pointtype=@pointtype,address=@address,eqtype=@eqtype,longitude=@longitude,dimension=@dimension,area=@area,propertyright=@propertyright,demstatus=@demstatus,demem=@demem,roomresistance=@roomresistance,powersupplymode=@powersupplymode,roomloadcurrent=@roomloadcurrent,memo1=@memo1,memo2=@memo2,memo3=@memo3,memo4=@memo4");
                    sql.Append(" WHERE anid=@anid and roomname=@roomname ");

                    SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), _paras.ToArray());
                }
                catch (Exception ex)
                {
                    Response.Write("{\"success\":false,\"msg\":\"执行出错，错误信息：" + ex.Message + ",请检查文件！\"}");
                    return;
                }
                finally
                {
                    sql.Length = 0;
                    _paras.Clear();
                }
            }
        }
        Response.Write("{\"success\":true,\"msg\":\"数据导入成功！\"}");
    }
    /// <summary>
    /// 导出接入网机房资源明细
    /// </summary>
    public void ExportRoomResources()
    {
        string where = SetQueryConditionForRoom();
        if (where != "")
            where = " where " + where;
        StringBuilder sql = new StringBuilder();
        sql.Append("select anid,roomname,cityname,pointtype,address,eqtype,longitude,dimension,area,propertyright,demstatus,demem,roomresistance,powersupplymode,roomloadcurrent,memo1,memo2,memo3,memo4 ");
        sql.Append(" from AccessNetWork_RoomResources ");
        sql.Append(where);
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.Columns[0].ColumnName = "局站编码";
        dt.Columns[1].ColumnName = "机房名称";
        dt.Columns[2].ColumnName = "所属县市";
        dt.Columns[3].ColumnName = "网点类别";
        dt.Columns[4].ColumnName = "详细地址";
        dt.Columns[5].ColumnName = "设备分类";
        dt.Columns[6].ColumnName = "经度";
        dt.Columns[7].ColumnName = "纬度";
        dt.Columns[8].ColumnName = "面积";
        dt.Columns[9].ColumnName = "产权性质";
        dt.Columns[10].ColumnName = "动环监控";
        dt.Columns[11].ColumnName = "动环设备厂家";
        dt.Columns[12].ColumnName = "机房接地电阻";
        dt.Columns[13].ColumnName = "供电方式";
        dt.Columns[14].ColumnName = "机房负载电流（直流电流A）";
        dt.Columns[15].ColumnName = "备注1";
        dt.Columns[16].ColumnName = "备注2";
        dt.Columns[17].ColumnName = "备注3";
        dt.Columns[18].ColumnName = "备注4";

        ExcelHelper.ExportByWeb(dt, "", "机房资源基础台帐.xls", "机房资源基础台帐");
    }
    /// <summary>
    /// 更新接入网机房资源信息
    /// </summary>
    public void UpdateRoomResourcesInfo()
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
        _paras.Add(new SqlParameter("@memo4", memo4));
        StringBuilder sql = new StringBuilder();
        sql.Append("update  AccessNetWork_RoomResources set anid=@anid,roomname=@roomname,cityname=@cityname,pointtype=@pointtype,address=@address,eqtype=@eqtype,longitude=@longitude,dimension=@dimension,area=@area,propertyright=@propertyright,demstatus=@demstatus,demem=@demem,roomresistance=@roomresistance,powersupplymode=@powersupplymode,roomloadcurrent=@roomloadcurrent,memo1=@memo1,memo2=@memo2,memo3=@memo3,memo4=@memo4,InputTime=getdate()  where id=@id");
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), _paras.ToArray());
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"资源更新成功！\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    //<summary>
    //新增接入网机房资源
    //</summary>
    public void SaveRoomResourcesInfo()
    {
        //1、获取参数
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
        //设定参数
        List<SqlParameter> _paras = new List<SqlParameter>();
        _paras.Add(new SqlParameter("@anid", anid));
        _paras.Add(new SqlParameter("@roomname", roomname));
        _paras.Add(new SqlParameter("@cityname", cityname));
        _paras.Add(new SqlParameter("@address", address));
        _paras.Add(new SqlParameter("@pointtype", pointtype));
        _paras.Add(new SqlParameter("@eqtype", eqtype));
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
        _paras.Add(new SqlParameter("@memo4", memo4));
        //2、保存
        StringBuilder sql = new StringBuilder();
        sql.Append("if not exists(select * from AccessNetWork_RoomResources where anid=@anid)");
        sql.Append("insert AccessNetWork_RoomResources(anid,roomname,cityname,pointtype,address,eqtype,longitude,dimension,area,propertyright,demstatus,demem,roomresistance,powersupplymode,roomloadcurrent,memo1,memo2,memo3,memo4) ");
        sql.Append(" values(@anid,@roomname,@cityname,@pointtype,@address,@eqtype,@longitude,@dimension,@area,@propertyright,@demstatus,@demem,@roomresistance,@powersupplymode,@roomloadcurrent,@memo1,@memo2,@memo3,@memo4);");

        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), _paras.ToArray());
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"新增接入网机房资源成功！\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"该局站编码已存在，请检查输入！\"}");
    }
    public void RemoveRoomAndEqResourcesInfoByAnID()
    {
        string anid = Convert.ToString(Request.Form["anid"]);
        SqlParameter paras = new SqlParameter("@anid", SqlDbType.VarChar);
        paras.Value = anid;
        StringBuilder sql = new StringBuilder();
        sql.Append("delete from  AccessNetWork_RoomResources  where anid=@anid;");
        //sql.Append("Update AccessNetWork_EqInfo set IsDel=1 Where anid=@anid;");
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), paras);
        if (result >= 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    /// <summary>
    ///  根据用户输入的机房名称获取局站编码信息combogrid使用的json字符串
    /// </summary>
    public void GetStationInfoForCombogridByRoomname()
    {
        string where = "";
        //combobox自动补全模式下获查询变量q
        if (!string.IsNullOrEmpty(Request.Form["q"]))
            where = "roomname like'%" + Request.Form["q"].ToString() + "%'";
        int total = 0;
        string table = "AccessNetWork_RoomResources";
        string fieldStr = "id,anid,roomname";
        DataSet ds = SqlHelper.GetPagination(table, fieldStr, Request["sort"].ToString(), Request["order"].ToString(), where, Convert.ToInt32(Request["rows"]), Convert.ToInt32(Request["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    #endregion 接入网机房资源管理
    #region 接入网设备管理
    /// <summary>
    /// 设置接入网设备管理查询条件
    /// </summary>
    /// <returns></returns>
    public string SetQueryConditionForEq()
    {
        string queryStr = "";
        //设置查询条件
        List<string> list = new List<string>();
        //按局站编码
        if (!string.IsNullOrEmpty(Request.Form["anid"]))
            list.Add(" anid like'%" + Request.Form["anid"] + "%'");
        //按机房名称
        if (!string.IsNullOrEmpty(Request.Form["roomname"]))
            list.Add(" roomname like'%" + Request.Form["roomname"] + "%'");
        //按所属市县
        if (roleid == "20")
        {
            if (deptname == "网络维护中心")
                list.Add(" cityname='市区' ");
            else
                list.Add(" cityname='" + deptname + "' ");
        }

        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 获取接入网设备信息 数据page:1 rows:10 sort:id order:asc
    /// </summary>
    public void GetEquipmentInfo()
    {
        int total = 0;
        string where = SetQueryConditionForEq();
        string tableName = " AccessNetWork_EqInfo ";
        string fieldStr = "*,CONVERT(VARCHAR(50),inputtime,23) as inputdate";
        DataSet ds = SqlHelper.GetPagination(tableName, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    ///  AccessNetWork_EqInfo
    /// </summary>
    public void GetEqInfoByID()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = id;
        string sql = "SELECT * FROM AccessNetWork_EqInfo  where ID=@id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    /// <summary>
    /// 导入上传的设备信息
    /// </summary>
    public void ImportEquipmentInfo()
    {
        string reportPath = "";
        if (!string.IsNullOrEmpty(Request.Form["report"]))
            reportPath = Server.MapPath("~") + Request.Form["report"].ToString();
        if (ExcelHelper.CheckFileExists(reportPath) == -1)
        {
            Response.Write("{\"success\":false,\"msg\":\"上传文件不存在，请检查！\"}");
            return;
        }
        string sn = "机房设备信息";
        DataTable dt = new DataTable();
        if (ExcelHelper.CheckSheetContains(reportPath, sn) == -1)
        {
            Response.Write("{\"success\":false,\"msg\":\"单元表“" + sn + "”不存在，请检查文件！\"}");
            return;
        }
        else
        {
            dt = ExcelHelper.RenderDataTableFromExcel(reportPath, sn, 0, false, 1, 0);
        }
        if (dt.TableName == "Error")
        {
            Response.Write("{\"success\":false,\"msg\":\"" + dt.Rows[0][0].ToString() + ",请检查文件！\"}");
            return;
        }
        //定义sqlparameter 
        List<SqlParameter> _paras = new List<SqlParameter>();
        StringBuilder sql = new StringBuilder();
        //遍历数据
        if (dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                try
                {
                    _paras.Add(new SqlParameter("@ANID", String.IsNullOrEmpty(dr[0].ToString()) ? "" : dr[0].ToString()));
                    _paras.Add(new SqlParameter("@RoomName", String.IsNullOrEmpty(dr[1].ToString()) ? "" : dr[1].ToString()));
                    _paras.Add(new SqlParameter("@CityName", String.IsNullOrEmpty(dr[2].ToString()) ? "" : dr[2].ToString()));
                    _paras.Add(new SqlParameter("@EqType", String.IsNullOrEmpty(dr[3].ToString()) ? "" : dr[3].ToString()));
                    _paras.Add(new SqlParameter("@Mfrs", String.IsNullOrEmpty(dr[4].ToString()) ? "" : dr[4].ToString()));
                    _paras.Add(new SqlParameter("@model", String.IsNullOrEmpty(dr[5].ToString()) ? "" : dr[5].ToString()));
                    _paras.Add(new SqlParameter("@EnableDate", String.IsNullOrEmpty(dr[6].ToString()) ? "" : dr[6].ToString()));
                    _paras.Add(new SqlParameter("@Capacity1", String.IsNullOrEmpty(dr[7].ToString()) ? "" : dr[7].ToString()));
                    _paras.Add(new SqlParameter("@Capacity2", String.IsNullOrEmpty(dr[8].ToString()) ? "" : dr[8].ToString()));
                    _paras.Add(new SqlParameter("@Capacity3", String.IsNullOrEmpty(dr[9].ToString()) ? "" : dr[9].ToString()));
                    _paras.Add(new SqlParameter("@Capacity4", String.IsNullOrEmpty(dr[10].ToString()) ? "" : dr[10].ToString()));
                    sql.Append(" IF NOT EXISTS(SELECT * FROM AccessNetWork_EqInfo WHERE anid=@anid and roomname=@roomname) ");
                    sql.Append("INSERT INTO AccessNetWork_EqInfo (anid,roomname,cityname,eqtype,mfrs,model,enabledate,capacity1,capacity2,capacity3,capacity4)");
                    sql.Append(" VALUES (@anid,@roomname,@cityname,@eqtype,@mfrs,@model,@enabledate,@capacity1,@capacity2,@capacity3,@capacity4) ");
                    sql.Append(" ELSE ");
                    sql.Append("Update AccessNetWork_EqInfo  set  cityname=@cityname,eqtype=@eqtype,mfrs=@mfrs,model=@model,enabledate=@enabledate,capacity1=@capacity1,capacity2=@capacity2,capacity3=@capacity3,capacity4=@capacity4");
                    sql.Append(" WHERE anid=@anid and roomname=@roomname ");

                    SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), _paras.ToArray());
                }
                catch (Exception ex)
                {
                    Response.Write("{\"success\":false,\"msg\":\"执行出错，错误信息：" + ex.Message + ",请检查文件！\"}");
                    return;
                }
                finally
                {
                    sql.Length = 0;
                    _paras.Clear();
                }
            }
        }
        Response.Write("{\"success\":true,\"msg\":\"数据导入成功！\"}");
    }
    /// <summary>
    /// 导出接入网机房资源明细
    /// </summary>
    public void ExportEqInfo()
    {
        string where = SetQueryConditionForEq();
        if (where != "")
            where = " where " + where;
        StringBuilder sql = new StringBuilder();
        sql.Append("select anid,roomname,cityname,eqtype,mfrs,model,enabledate,capacity1,capacity2,capacity3,capacity4");
        sql.Append(" from AccessNetWork_EqInfo ");
        sql.Append(where);
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.Columns[0].ColumnName = "局站编码";
        dt.Columns[1].ColumnName = "机房名称";
        dt.Columns[2].ColumnName = "所属县市";
        dt.Columns[3].ColumnName = "设备类型";
        dt.Columns[4].ColumnName = "厂家";
        dt.Columns[5].ColumnName = "型号";
        dt.Columns[6].ColumnName = "启用日期";
        dt.Columns[7].ColumnName = "容量信息1";
        dt.Columns[8].ColumnName = "容量信息2";
        dt.Columns[9].ColumnName = "容量信息3";
        dt.Columns[10].ColumnName = "容量信息4";

        ExcelHelper.ExportByWeb(dt, "", "机房设备信息.xls", "机房设备信息");
    }
    /// <summary>
    /// 更新设备资源信息
    /// </summary>
    public void UpdateEquipmentInfo()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        //局站编码
        string anid = Convert.ToString(Request.Form["anid"]);
        //网点名称
        string roomname = Convert.ToString(Request.Form["roomname"]);
        //所属县市
        string cityname = Convert.ToString(Request.Form["cityname"]);
        //设备类型
        string eqtype = Convert.ToString(Request.Form["eqtype"]);
        //厂家
        string mfrs = Convert.ToString(Request.Form["mfrs"]);
        //型号
        string model = Convert.ToString(Request.Form["model"]);
        //启用日期
        string enabledate = Convert.ToString(Request.Form["enabledate"]);
        //容量信息1
        string capacity1 = Convert.ToString(Request.Form["capacity1"]);
        //容量信息2
        string capacity2 = Convert.ToString(Request.Form["capacity2"]);
        //容量信息3
        string capacity3 = Convert.ToString(Request.Form["capacity3"]);
        //容量信息4
        string capacity4 = Convert.ToString(Request.Form["capacity4"]);
        List<SqlParameter> _paras = new List<SqlParameter>();
        _paras.Add(new SqlParameter("@id", id));
        _paras.Add(new SqlParameter("@anid", anid));
        _paras.Add(new SqlParameter("@roomname", roomname));
        _paras.Add(new SqlParameter("@cityname", cityname));
        _paras.Add(new SqlParameter("@eqtype", eqtype));
        _paras.Add(new SqlParameter("@mfrs", mfrs));
        _paras.Add(new SqlParameter("@model", model));
        _paras.Add(new SqlParameter("@enabledate", enabledate));
        _paras.Add(new SqlParameter("@capacity1", capacity1));
        _paras.Add(new SqlParameter("@capacity2", capacity2));
        _paras.Add(new SqlParameter("@capacity3", capacity3));
        _paras.Add(new SqlParameter("@capacity4", capacity4));
        StringBuilder sql = new StringBuilder();
        sql.Append("if exists(select * from AccessNetWork_RoomResources where anid=@anid)");
        sql.Append("UPDATE AccessNetWork_EqInfo SET anid=@anid,roomname=@roomname,cityname=@cityname,eqtype=@eqtype,mfrs=@mfrs,model=@model,enabledate=@enabledate,capacity1=@capacity1,capacity2=@capacity2,capacity3=@capacity3,capacity4=@capacity4  where id=@id");
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), _paras.ToArray());
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"设备信息更新成功！\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"该局站编码不存在，请检查输入！\"}");
    }
    //<summary>
    //新增设备资源信息
    //</summary>
    public void SaveEquipmentInfo()
    {
        //1、获取参数
        //局站编码
        string anid = Convert.ToString(Request.Form["anid"]);
        //网点名称
        string roomname = Convert.ToString(Request.Form["roomname"]);
        //所属县市
        string cityname = Convert.ToString(Request.Form["cityname"]);
        //设备类型
        string eqtype = Convert.ToString(Request.Form["eqtype"]);
        //厂家
        string mfrs = Convert.ToString(Request.Form["mfrs"]);
        //型号
        string model = Convert.ToString(Request.Form["model"]);
        //启用日期
        string enabledate = Convert.ToString(Request.Form["enabledate"]);
        //容量信息1
        string capacity1 = Convert.ToString(Request.Form["capacity1"]);
        //容量信息2
        string capacity2 = Convert.ToString(Request.Form["capacity2"]);
        //容量信息3
        string capacity3 = Convert.ToString(Request.Form["capacity3"]);
        //容量信息4
        string capacity4 = Convert.ToString(Request.Form["capacity4"]);
        //设定参数
        List<SqlParameter> _paras = new List<SqlParameter>();
        _paras.Add(new SqlParameter("@anid", anid));
        _paras.Add(new SqlParameter("@roomname", roomname));
        _paras.Add(new SqlParameter("@cityname", cityname));
        _paras.Add(new SqlParameter("@eqtype", eqtype));
        _paras.Add(new SqlParameter("@mfrs", mfrs));
        _paras.Add(new SqlParameter("@model", model));
        _paras.Add(new SqlParameter("@enabledate", enabledate));
        _paras.Add(new SqlParameter("@capacity1", capacity1));
        _paras.Add(new SqlParameter("@capacity2", capacity2));
        _paras.Add(new SqlParameter("@capacity3", capacity3));
        _paras.Add(new SqlParameter("@capacity4", capacity4));
        //2、保存
        StringBuilder sql = new StringBuilder();
        sql.Append("if exists(select * from AccessNetWork_RoomResources where anid=@anid)");
        sql.Append("INSERT INTO AccessNetWork_EqInfo(anid,roomname,cityname,eqtype,mfrs,model,enabledate,capacity1,capacity2,capacity3,capacity4)");
        sql.Append(" VALUES(@anid,@roomname,@cityname,@eqtype,@mfrs,@model,@enabledate,@capacity1,@capacity2,@capacity3,@capacity4)");

        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), _paras.ToArray());
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"新增设备资源成功！\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"该局站编码不存在，请检查输入！\"}");
    }
    /// <summary>
    /// 删除接入网设备资源信息
    /// </summary>
    public void RemoveEqResourcesInfoByID()
    {
        string id = Convert.ToString(Request.Form["id"]);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = id;
        StringBuilder sql = new StringBuilder();
        sql.Append("Update AccessNetWork_EqInfo set IsDel=1 Where id=@id;");
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    /// <summary>
    ///清除接入网设备资源信息，针对市区未删除的数据
    /// </summary>
    public void ClearEqResourcesInfo()
    {
        StringBuilder sql = new StringBuilder();
        sql.Append("DELETE FROM AccessNetWork_EqInfo  WHERE IsDel=0 AND CityName='安阳市';");
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        if (result >= 0)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    #endregion 接入网设备管理
    #region 租赁合同台账
    /// <summary>
    /// 设置租赁合同台账查询条件
    /// </summary>
    /// <returns></returns>
    public string SetQueryConditionForContract()
    {
        string queryStr = "";
        //设置查询条件
        List<string> list = new List<string>();
        //按所属县市
        if (!string.IsNullOrEmpty(Request.Form["cityname"]))
            list.Add(" cityname ='" + Request.Form["cityname"] + "'");
        //按局站编码
        if (!string.IsNullOrEmpty(Request.Form["anid"]))
            list.Add(" anid like'%" + Request.Form["anid"] + "%'");
        //按机房名称
        if (!string.IsNullOrEmpty(Request.Form["roomname"]))
            list.Add(" roomname like'%" + Request.Form["roomname"] + "%'");
        //按所属市县
        if (roleid == "20")
        {
            if (deptname == "网络维护中心")
                list.Add(" cityname='市区' ");
            else

                list.Add(" cityname='" + deptname + "' ");
        }
        if (list.Count > 0)
            queryStr = string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 获取租赁合同台账 数据page:1 rows:10 sort:id order:asc
    /// </summary>
    public void GetLeaseContractInfo()
    {
        int total = 0;
        string where = SetQueryConditionForContract();
        string tableName = " AccessNetWork_LeaseContract ";
        string fieldStr = "*";
        DataSet ds = SqlHelper.GetPagination(tableName, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    ///  AccessNetWork_LeaseContract
    /// </summary>
    public void GetLeaseContractfoByID()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = id;
        string sql = "SELECT * FROM AccessNetWork_LeaseContract  where ID=@id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    /// <summary>
    /// 导入租赁合同台账
    /// </summary>
    public void ImportLeaseContract()
    {
        string reportPath = "";
        if (!string.IsNullOrEmpty(Request.Form["report"]))
            reportPath = Server.MapPath("~") + Request.Form["report"].ToString();
        if (ExcelHelper.CheckFileExists(reportPath) == -1)
        {
            Response.Write("{\"success\":false,\"msg\":\"上传文件不存在，请检查！\"}");
            return;
        }
        string sn = "租赁合同台账";
        DataTable dt = new DataTable();
        if (ExcelHelper.CheckSheetContains(reportPath, sn) == -1)
        {
            Response.Write("{\"success\":false,\"msg\":\"单元表“" + sn + "”不存在，请检查文件！\"}");
            return;
        }
        else
        {
            dt = ExcelHelper.RenderDataTableFromExcel(reportPath, sn, 0, false, 1, 0);
        }
        if (dt.TableName == "Error")
        {
            Response.Write("{\"success\":false,\"msg\":\"" + dt.Rows[0][0].ToString() + ",请检查文件！\"}");
            return;
        }
        //定义sqlparameter 
        List<SqlParameter> _paras = new List<SqlParameter>();
        StringBuilder sql = new StringBuilder();
        //遍历数据
        if (dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                try
                {
                    _paras.Add(new SqlParameter("@anid", String.IsNullOrEmpty(dr[0].ToString()) ? "" : dr[0].ToString()));
                    _paras.Add(new SqlParameter("@roomname", String.IsNullOrEmpty(dr[1].ToString()) ? "" : dr[1].ToString()));
                    _paras.Add(new SqlParameter("@cityname", String.IsNullOrEmpty(dr[2].ToString()) ? "" : dr[2].ToString()));
                    _paras.Add(new SqlParameter("@address", String.IsNullOrEmpty(dr[3].ToString()) ? "" : dr[3].ToString()));
                    _paras.Add(new SqlParameter("@contractno", String.IsNullOrEmpty(dr[4].ToString()) ? "" : dr[4].ToString()));
                    _paras.Add(new SqlParameter("@contractstart", String.IsNullOrEmpty(dr[5].ToString()) ? "" : dr[5].ToString()));
                    _paras.Add(new SqlParameter("@contractend", String.IsNullOrEmpty(dr[6].ToString()) ? "" : dr[6].ToString()));
                    _paras.Add(new SqlParameter("@contractor", String.IsNullOrEmpty(dr[7].ToString()) ? "" : dr[7].ToString()));
                    _paras.Add(new SqlParameter("@rent", String.IsNullOrEmpty(dr[8].ToString()) ? "" : dr[8].ToString()));
                    _paras.Add(new SqlParameter("@allrent", String.IsNullOrEmpty(dr[9].ToString()) ? "" : dr[9].ToString()));
                    _paras.Add(new SqlParameter("@payclosingdate", String.IsNullOrEmpty(dr[10].ToString()) ? "" : dr[10].ToString()));
                    _paras.Add(new SqlParameter("@lastpaydate", String.IsNullOrEmpty(dr[11].ToString()) ? "" : dr[11].ToString()));
                    _paras.Add(new SqlParameter("@payamount", String.IsNullOrEmpty(dr[12].ToString()) ? "" : dr[12].ToString()));
                    _paras.Add(new SqlParameter("@paymonth", String.IsNullOrEmpty(dr[13].ToString()) ? "" : dr[13].ToString()));
                    _paras.Add(new SqlParameter("@thispaydate", String.IsNullOrEmpty(dr[14].ToString()) ? "" : dr[14].ToString()));
                    _paras.Add(new SqlParameter("@thispayamount", String.IsNullOrEmpty(dr[15].ToString()) ? "" : dr[15].ToString()));
                    _paras.Add(new SqlParameter("@otheraccount", String.IsNullOrEmpty(dr[16].ToString()) ? "" : dr[16].ToString()));
                    _paras.Add(new SqlParameter("@accountnumber", String.IsNullOrEmpty(dr[17].ToString()) ? "" : dr[17].ToString()));
                    _paras.Add(new SqlParameter("@openingbank", String.IsNullOrEmpty(dr[18].ToString()) ? "" : dr[18].ToString()));
                    _paras.Add(new SqlParameter("@contact", String.IsNullOrEmpty(dr[19].ToString()) ? "" : dr[19].ToString()));
                    _paras.Add(new SqlParameter("@memo1", String.IsNullOrEmpty(dr[20].ToString()) ? "" : dr[20].ToString()));
                    _paras.Add(new SqlParameter("@memo2", String.IsNullOrEmpty(dr[21].ToString()) ? "" : dr[21].ToString()));
                    _paras.Add(new SqlParameter("@memo3", String.IsNullOrEmpty(dr[22].ToString()) ? "" : dr[22].ToString()));
                    _paras.Add(new SqlParameter("@memo4", String.IsNullOrEmpty(dr[23].ToString()) ? "" : dr[23].ToString()));

                    sql.Append(" IF NOT EXISTS(SELECT * FROM AccessNetWork_LeaseContract WHERE anid=@anid and roomname=@roomname) ");
                    sql.Append("INSERT INTO AccessNetWork_LeaseContract (anid,roomname,cityname,address,contractno,contractstart,contractend,contractor,rent,allrent,payclosingdate,lastpaydate,payamount,paymonth,thispaydate,thispayamount,otheraccount,accountnumber,openingbank,contact,memo1,memo2,memo3,memo4)");
                    sql.Append(" VALUES (@anid,@roomname,@cityname,@address,@contractno,@contractstart,@contractend,@contractor,@rent,@allrent,@payclosingdate,@lastpaydate,@payamount,@paymonth,@thispaydate,@thispayamount,@otheraccount,@accountnumber,@openingbank,@contact,@memo1,@memo2,@memo3,@memo4) ");
                    sql.Append(" ELSE ");
                    sql.Append("Update AccessNetWork_LeaseContract  set  cityname=@cityname,address=@address,contractno=@contractno,contractstart=@contractstart,contractend=@contractend,contractor=@contractor,rent=@rent,allrent=@allrent,payclosingdate=@payclosingdate,lastpaydate=@lastpaydate,payamount=@payamount,paymonth=@paymonth,thispaydate=@thispaydate,thispayamount=@thispayamount,otheraccount=@otheraccount,accountnumber=@accountnumber,openingbank=@openingbank,contact=@contact,memo1=@memo1,memo2=@memo2,memo3=@memo3,memo4=@memo4");
                    sql.Append(" WHERE anid=@anid and roomname=@roomname ");

                    SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), _paras.ToArray());
                }
                catch (Exception ex)
                {
                    Response.Write("{\"success\":false,\"msg\":\"执行出错，错误信息：" + ex.Message + ",请检查文件！\"}");
                    return;
                }
                finally
                {
                    sql.Length = 0;
                    _paras.Clear();
                }
            }
        }
        Response.Write("{\"success\":true,\"msg\":\"数据导入成功！\"}");
    }
    /// <summary>
    /// 更新租赁合同台账
    /// </summary>
    public void UpdateLeaseContractInfo()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        //局站编码
        string anid = Convert.ToString(Request.Form["anid"]);
        //网点名称
        string roomname = Convert.ToString(Request.Form["roomname"]);
        //所属县市
        string cityname = Convert.ToString(Request.Form["cityname"]);
        string address = Convert.ToString(Request.Form["address"]);
        string contractno = Convert.ToString(Request.Form["contractno"]);
        string contractstart = Convert.ToString(Request.Form["contractstart"]);
        string contractend = Convert.ToString(Request.Form["contractend"]);
        string contractor = Convert.ToString(Request.Form["contractor"]);
        string rent = Convert.ToString(Request.Form["rent"]);
        string allrent = Convert.ToString(Request.Form["allrent"]);
        string payclosingdate = Convert.ToString(Request.Form["payclosingdate"]);
        string lastpaydate = Convert.ToString(Request.Form["lastpaydate"]);
        string payamount = Convert.ToString(Request.Form["payamount"]);
        string paymonth = Convert.ToString(Request.Form["paymonth"]);
        string thispaydate = Convert.ToString(Request.Form["thispaydate"]);
        string thispayamount = Convert.ToString(Request.Form["thispayamount"]);
        string otheraccount = Convert.ToString(Request.Form["otheraccount"]);
        string accountnumber = Convert.ToString(Request.Form["accountnumber"]);
        string openingbank = Convert.ToString(Request.Form["openingbank"]);
        string contact = Convert.ToString(Request.Form["contact"]);
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
        _paras.Add(new SqlParameter("@contractno", contractno));
        _paras.Add(new SqlParameter("@contractstart", contractstart));
        _paras.Add(new SqlParameter("@contractend", contractend));
        _paras.Add(new SqlParameter("@contractor", contractor));
        _paras.Add(new SqlParameter("@rent", rent));
        _paras.Add(new SqlParameter("@allrent", allrent));
        _paras.Add(new SqlParameter("@payclosingdate", payclosingdate));
        _paras.Add(new SqlParameter("@lastpaydate", lastpaydate));
        _paras.Add(new SqlParameter("@payamount", payamount));
        _paras.Add(new SqlParameter("@paymonth", paymonth));
        _paras.Add(new SqlParameter("@thispaydate", thispaydate));
        _paras.Add(new SqlParameter("@thispayamount", thispayamount));
        _paras.Add(new SqlParameter("@otheraccount", otheraccount));
        _paras.Add(new SqlParameter("@accountnumber", accountnumber));
        _paras.Add(new SqlParameter("@openingbank", openingbank));
        _paras.Add(new SqlParameter("@contact", contact));
        _paras.Add(new SqlParameter("@memo1", memo1));
        _paras.Add(new SqlParameter("@memo2", memo2));
        _paras.Add(new SqlParameter("@memo3", memo3));
        _paras.Add(new SqlParameter("@memo4", memo4));

        StringBuilder sql = new StringBuilder();
        sql.Append("if exists(select * from AccessNetWork_RoomResources where anid=@anid)");
        sql.Append("UPDATE AccessNetWork_LeaseContract SET anid=@anid,roomname=@roomname,cityname=@cityname,address=@address,contractno=@contractno,contractstart=@contractstart,contractend=@contractend,contractor=@contractor,rent=@rent,allrent=@allrent,payclosingdate=@payclosingdate,lastpaydate=@lastpaydate,payamount=@payamount,paymonth=@paymonth,thispaydate=@thispaydate,thispayamount=@thispayamount,otheraccount=@otheraccount,accountnumber=@accountnumber,openingbank=@openingbank,contact=@contact,memo1=@memo1,memo2=@memo2,memo3=@memo3,memo4=@memo4  where id=@id");
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), _paras.ToArray());
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"租赁合同信息更新成功！\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"该局站编码不存在，请检查输入！\"}");
    }
    //<summary>
    //新增租赁合同台账
    //</summary>
    public void SaveLeaseContractInfo()
    {
        //1、获取参数
        //局站编码
        string anid = Convert.ToString(Request.Form["anid"]);
        //网点名称
        string roomname = Convert.ToString(Request.Form["roomname"]);
        //所属县市
        string cityname = Convert.ToString(Request.Form["cityname"]);
        string address = Convert.ToString(Request.Form["address"]);
        string contractno = Convert.ToString(Request.Form["contractno"]);
        string contractstart = Convert.ToString(Request.Form["contractstart"]);
        string contractend = Convert.ToString(Request.Form["contractend"]);
        string contractor = Convert.ToString(Request.Form["contractor"]);
        string rent = Convert.ToString(Request.Form["rent"]);
        string allrent = Convert.ToString(Request.Form["allrent"]);
        string payclosingdate = Convert.ToString(Request.Form["payclosingdate"]);
        string lastpaydate = Convert.ToString(Request.Form["lastpaydate"]);
        string payamount = Convert.ToString(Request.Form["payamount"]);
        string paymonth = Convert.ToString(Request.Form["paymonth"]);
        string thispaydate = Convert.ToString(Request.Form["thispaydate"]);
        string thispayamount = Convert.ToString(Request.Form["thispayamount"]);
        string otheraccount = Convert.ToString(Request.Form["otheraccount"]);
        string accountnumber = Convert.ToString(Request.Form["accountnumber"]);
        string openingbank = Convert.ToString(Request.Form["openingbank"]);
        string contact = Convert.ToString(Request.Form["contact"]);
        string memo1 = Convert.ToString(Request.Form["memo1"]);
        string memo2 = Convert.ToString(Request.Form["memo2"]);
        string memo3 = Convert.ToString(Request.Form["memo3"]);
        string memo4 = Convert.ToString(Request.Form["memo4"]);
        //设定参数
        List<SqlParameter> _paras = new List<SqlParameter>();
        _paras.Add(new SqlParameter("@anid", anid));
        _paras.Add(new SqlParameter("@roomname", roomname));
        _paras.Add(new SqlParameter("@cityname", cityname));
        _paras.Add(new SqlParameter("@address", address));
        _paras.Add(new SqlParameter("@contractno", contractno));
        _paras.Add(new SqlParameter("@contractstart", contractstart));
        _paras.Add(new SqlParameter("@contractend", contractend));
        _paras.Add(new SqlParameter("@contractor", contractor));
        _paras.Add(new SqlParameter("@rent", rent));
        _paras.Add(new SqlParameter("@allrent", allrent));
        _paras.Add(new SqlParameter("@payclosingdate", payclosingdate));
        _paras.Add(new SqlParameter("@lastpaydate", lastpaydate));
        _paras.Add(new SqlParameter("@payamount", payamount));
        _paras.Add(new SqlParameter("@paymonth", paymonth));
        _paras.Add(new SqlParameter("@thispaydate", thispaydate));
        _paras.Add(new SqlParameter("@thispayamount", thispayamount));
        _paras.Add(new SqlParameter("@otheraccount", otheraccount));
        _paras.Add(new SqlParameter("@accountnumber", accountnumber));
        _paras.Add(new SqlParameter("@openingbank", openingbank));
        _paras.Add(new SqlParameter("@contact", contact));
        _paras.Add(new SqlParameter("@memo1", memo1));
        _paras.Add(new SqlParameter("@memo2", memo2));
        _paras.Add(new SqlParameter("@memo3", memo3));
        _paras.Add(new SqlParameter("@memo4", memo4));
        //2、保存
        StringBuilder sql = new StringBuilder();
        sql.Append("if exists(select * from AccessNetWork_RoomResources where anid=@anid)");
        sql.Append("INSERT INTO AccessNetWork_LeaseContract(anid,roomname,cityname,address,contractno,contractstart,contractend,contractor,rent,allrent,payclosingdate,lastpaydate,payamount,paymonth,thispaydate,thispayamount,otheraccount,accountnumber,openingbank,contact,memo1,memo2,memo3,memo4)");
        sql.Append(" VALUES(@anid,@roomname,@cityname,@address,@contractno,@contractstart,@contractend,@contractor,@rent,@allrent,@payclosingdate,@lastpaydate,@payamount,@paymonth,@thispaydate,@thispayamount,@otheraccount,@accountnumber,@openingbank,@contact,@memo1,@memo2,@memo3,@memo4)");

        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), _paras.ToArray());
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"新增租赁合同台账成功！\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"该局站编码不存在，请检查输入！\"}");
    }
    /// <summary>
    /// 删除租赁合同台账
    /// </summary>
    public void RemoveLeaseContractByID()
    {
        string id = Convert.ToString(Request.Form["id"]);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = id;
        StringBuilder sql = new StringBuilder();
        sql.Append("delete from  AccessNetWork_LeaseContract Where id=@id;");
        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), paras);
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"执行成功\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"执行出错\"}");
    }
    /// <summary>
    /// 导出租赁合同台账
    /// </summary>
    public void ExportLeaseContractInfo()
    {
        string where = SetQueryConditionForContract();
        if (where != "")
            where = " where " + where;
        StringBuilder sql = new StringBuilder();
        sql.Append("select anid,roomname,cityname,address,contractno,contractstart,contractend,contractor,rent,allrent,payclosingdate,lastpaydate,payamount,paymonth,thispaydate,thispayamount,otheraccount,accountnumber,openingbank,contact,memo1,memo2,memo3,memo4");
        sql.Append(" from AccessNetWork_LeaseContract ");
        sql.Append(where);
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.Columns[0].ColumnName = "局站编码";
        dt.Columns[1].ColumnName = "局址名称";
        dt.Columns[2].ColumnName = "所属县市";
        dt.Columns[3].ColumnName = "详细地址";
        dt.Columns[4].ColumnName = "租赁合同编号";
        dt.Columns[5].ColumnName = "合同开始日期";
        dt.Columns[6].ColumnName = "合同截止日期";
        dt.Columns[7].ColumnName = "租赁合同对方单位或个人";
        dt.Columns[8].ColumnName = "合同年租金额";
        dt.Columns[9].ColumnName = "合同总金额";
        dt.Columns[10].ColumnName = "付款截止日期";
        dt.Columns[11].ColumnName = "上一年付款日期";
        dt.Columns[12].ColumnName = "付款总额";
        dt.Columns[13].ColumnName = "应付款月份";
        dt.Columns[14].ColumnName = "本年付款日期";
        dt.Columns[15].ColumnName = "本年付款总额";
        dt.Columns[16].ColumnName = "对方账户";
        dt.Columns[17].ColumnName = "对方帐号";
        dt.Columns[18].ColumnName = "对方开户行";
        dt.Columns[19].ColumnName = "联系方式";
        dt.Columns[20].ColumnName = "备注1";
        dt.Columns[21].ColumnName = "备注2";
        dt.Columns[22].ColumnName = "备注3";
        dt.Columns[23].ColumnName = "票据类型";


        ExcelHelper.ExportByWeb(dt, "", "租赁合同台账.xls", "租赁合同台账");
    }
    #endregion 租赁合同台账
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
        //按所属县市
        if (!string.IsNullOrEmpty(Request.Form["cityname"]))
            list.Add(" cityname ='" + Request.Form["cityname"] + "'");
        //按局站编码
        if (!string.IsNullOrEmpty(Request.Form["anid"]))
            list.Add(" anid like'%" + Request.Form["anid"] + "%'");
        //if (roleid == "20")
        //{
        //    if (deptname == "网络维护中心")
        //        list.Add(" cityname='市区' ");
        //    else
        //        list.Add(" cityname='" + deptname + "' ");
        //}
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
        string tableName = " AccessNetWork_DailyRepairInfo ";
        string fieldStr = "*";
        DataSet ds = SqlHelper.GetPagination(tableName, fieldStr, Request.Form["sort"].ToString(), Request.Form["order"].ToString(), where, Convert.ToInt32(Request.Form["rows"]), Convert.ToInt32(Request.Form["page"]), out total);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds, total));
    }
    /// <summary>
    ///  AccessNetWork_DailyRepairInfo
    /// </summary>
    public void GetDailyRepairInfoByID()
    {
        int id = Convert.ToInt32(Request.Form["id"]);
        SqlParameter paras = new SqlParameter("@id", SqlDbType.Int);
        paras.Value = id;
        string sql = "SELECT * FROM AccessNetWork_DailyRepairInfo  where ID=@id";
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql, paras);
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    /// <summary>
    /// 导入上传的日常维修台账
    /// </summary>
    public void ImportDailyRepairInfo()
    {
        string reportPath = "";
        if (!string.IsNullOrEmpty(Request.Form["report"]))
            reportPath = Server.MapPath("~") + Request.Form["report"].ToString();
        int checkFile = MyXls.ChkSheet(reportPath, "日常维修台账");
        if (checkFile == -1)
        {
            Response.Write("{\"success\":false,\"msg\":\"上传文件不存在，请检查！\"}");
            return;
        }
        if (checkFile == 0)
        {
            Response.Write("{\"success\":false,\"msg\":\"请检查excel文件中单元表的名字是否正确！\"}");
            return;
        }
        //验证要导入的列在单元表中是否存在
        List<string> columnsName = new List<string>();
        columnsName.Add("局站编码");
        List<int> columnsExists = MyXls.ChkSheetColumns(reportPath, "日常维修台账", columnsName);
        if (columnsExists.Contains(0))
        {
            Response.Write("{\"success\":false,\"msg\":\"请检查excel文件内容格式是否正确！\"}");
            return;
        }
        SqlParameter[] paras = new SqlParameter[]{
            new SqlParameter("@filePath",reportPath),
            new SqlParameter("@sheetName","日常维修台账")
        };
        SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.StoredProcedure, "ImportPointRepairFromExcelAndUpdate", paras);
        //SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.StoredProcedure, "ImportPointRepairFromExcelAndUpdate_x64", paras);
        Response.Write("{\"success\":true,\"msg\":\"数据导入成功！\"}");
    }
    /// <summary>
    /// 导出日常维修台账
    /// </summary>
    public void ExportDailyRepairInfo()
    {
        string where = SetQueryConditionForRepair();
        if (where != "")
            where = " where " + where;
        StringBuilder sql = new StringBuilder();
        sql.Append("select DeptName,ANID,RoomName,CityName,RepairInfo,RepairReportNo,ApplyTime,");
        sql.Append("NoticeRepairTime,RepairFinishTime,WarrantyExpirationDate,RepairContent,");
        sql.Append("CheckInfo,RepairPerson,RepairPersonTel,ApplyMoney,ReimnurseMoney,ProjectTime,");
        sql.Append("ReimburseTime,Memo");
        sql.Append(" from AccessNetWork_DailyRepairInfo ");
        sql.Append(where);
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        DataTable dt = ds.Tables[0];
        dt.Columns[0].ColumnName = "单位";
        dt.Columns[1].ColumnName = "接入网机房编号";
        dt.Columns[2].ColumnName = "接入机房名称";
        dt.Columns[3].ColumnName = "所属县市";
        dt.Columns[4].ColumnName = "维修事项";
        dt.Columns[5].ColumnName = "维修签报单号";
        dt.Columns[6].ColumnName = "申请时间";
        dt.Columns[7].ColumnName = "通知维修时间";
        dt.Columns[8].ColumnName = "维修完成时间";
        dt.Columns[9].ColumnName = "保修截止日期";
        dt.Columns[10].ColumnName = "维修内容";
        dt.Columns[11].ColumnName = "验收情况(包括验收人员名单)";
        dt.Columns[12].ColumnName = "维修方名称";
        dt.Columns[13].ColumnName = "维修方联系方式";
        dt.Columns[14].ColumnName = "申请金额";
        dt.Columns[15].ColumnName = "报账金额";
        dt.Columns[16].ColumnName = "立项时间";
        dt.Columns[17].ColumnName = "报账时间";
        dt.Columns[18].ColumnName = "备注";

        ExcelHelper.ExportByWeb(dt, "", "日常维修台账.xls", "日常维修台账");
    }
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
        sql.Append("UPDATE AccessNetWork_DailyRepairInfo SET  DeptName = @deptname,  ANID = @anid, ");
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
        string anid = Convert.ToString(Request.Form["anid"]);
        string roomname = Convert.ToString(Request.Form["roomname"]);
        string cityname = Convert.ToString(Request.Form["cityname"]);
        string repairplace = Convert.ToString(Request.Form["repairplace"]);
        string pointtype = Convert.ToString(Request.Form["pointtype"]);
        string jobplanno = Convert.ToString(Request.Form["jobplanno"]);
        string eqtype = Convert.ToString(Request.Form["eqtype"]);
        string asssetsno = Convert.ToString(Request.Form["asssetsno"]);
        string repairitem = Convert.ToString(Request.Form["repairitem"]);
        string repaircontent = Convert.ToString(Request.Form["repaircontent"]);
        string reimmoney = Convert.ToString(Request.Form["reimmoney"]);
        string reimtime = Convert.ToString(Request.Form["reimtime"]);
        string attachfile = Convert.ToString(Request.Form["reportName"]);
        string attachfilepath = Convert.ToString(Request.Form["report"]);
        string memo1 = Convert.ToString(Request.Form["memo1"]);
        string memo2 = Convert.ToString(Request.Form["memo2"]);
        string memo3 = Convert.ToString(Request.Form["memo3"]);
        string memo4 = Convert.ToString(Request.Form["memo4"]);


        //设定参数
        List<SqlParameter> _paras = new List<SqlParameter>();
        _paras.Add(new SqlParameter("@anid", anid));
        _paras.Add(new SqlParameter("@roomname", roomname));
        _paras.Add(new SqlParameter("@cityname", cityname));
        _paras.Add(new SqlParameter("@repairplace", repairplace));
        _paras.Add(new SqlParameter("@pointtype", pointtype));
        _paras.Add(new SqlParameter("@jobplanno", jobplanno));
        _paras.Add(new SqlParameter("@eqtype", eqtype));
        _paras.Add(new SqlParameter("@asssetsno", asssetsno));
        _paras.Add(new SqlParameter("@repairitem", repairitem));
        _paras.Add(new SqlParameter("@repaircontent", repaircontent));
        _paras.Add(new SqlParameter("@reimmoney", reimmoney));
        _paras.Add(new SqlParameter("@reimtime", reimtime));
        _paras.Add(new SqlParameter("@attachfile", attachfile));
        _paras.Add(new SqlParameter("@attachfilepath", attachfilepath));
        _paras.Add(new SqlParameter("@memo1", memo1));
        _paras.Add(new SqlParameter("@memo2", memo2));
        _paras.Add(new SqlParameter("@memo3", memo3));
        _paras.Add(new SqlParameter("@memo4", memo4));

        //2、保存
        StringBuilder sql = new StringBuilder();
        sql.Append("if exists(select * from AccessNetWork_RoomResources where anid=@anid)");
        sql.Append("insert AccessNetWork_DailyRepairInfo(anid,roomname,cityname,repairplace,pointtype,jobplanno,eqtype,asssetsno,repairitem,repaircontent,reimmoney,reimtime,attachfile,attachfilepath,memo1,memo2,memo3,memo4) values(");
        sql.Append("@anid,@roomname,@cityname,@repairplace,@pointtype,@jobplanno,@eqtype,@asssetsno,@repairitem,@repaircontent,@reimmoney,@reimtime,@attachfile,@attachfilepath,@memo1,@memo2,@memo3,@memo4);");

        int result = SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql.ToString(), _paras.ToArray());
        if (result == 1)
            Response.Write("{\"success\":true,\"msg\":\"新增日常维修台账成功！\"}");
        else
            Response.Write("{\"success\":false,\"msg\":\"该局站编码不存在！！\"}");
    }
    #endregion 日常维修台账
    #region 资源更新数量统计
    /// <summary>
    /// 设置信息更新数量查询条件
    /// </summary>
    /// <returns></returns>
    public string SetQueryConditionForInfoUpdate()
    {
        string queryStr = "";
        //设置查询条件
        List<string> list = new List<string>();
        //按日期查询
        //提交开始日期
        if (!string.IsNullOrEmpty(Request.Form["sdate"]))
            list.Add(" CONVERT(VARCHAR(50),inputtime,23) >='" + Request.Form["sdate"] + "'");
        //提交截止日期
        if (!string.IsNullOrEmpty(Request.Form["edate"]))
            list.Add(" CONVERT(VARCHAR(50),inputtime,23) <='" + Request.Form["edate"] + "'");
        if (list.Count > 0)
            queryStr = "where " + string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 获取资源更新数量统计 sort:id order:asc
    /// </summary>
    public void GetUpdateStatistics()
    {

        string where = SetQueryConditionForInfoUpdate();
        StringBuilder sql = new StringBuilder("SELECT a.cityname AS cityname,ISNULL(num1,'0') AS num1,ISNULL(num2,'0') AS num2 FROM ");
        sql.Append("(SELECT Cityname FROM citylist) AS a LEFT JOIN ");
        sql.Append(" (SELECT cityname,COUNT(1) as num1 FROM AccessNetWork_RoomResources ");
        sql.Append(where);
        sql.Append(" GROUP BY CityName) AS b ON a.Cityname=b.cityname LEFT JOIN ");
        sql.Append(" (SELECT cityname,COUNT(1) as num2 FROM AccessNetWork_EqInfo ");
        sql.Append(where);
        sql.Append(" GROUP BY CityName) AS c ON a.Cityname=c.cityname ");
        sql.Append("order by ");
        sql.Append(Request.Form["sort"].ToString());
        sql.Append(" ");
        sql.Append(Request.Form["order"].ToString());
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    #endregion 资源更新数量统计
    #region 用户操作记录
    /// <summary>
    /// 保存操作记录
    /// </summary>
    private void SaveOPerationLog()
    {
        List<SqlParameter> _paras = new List<SqlParameter>();
        _paras.Add(new SqlParameter("@cityname", Session["deptname"].ToString() == "网络维护中心" ? "安阳市" : Session["deptname"].ToString()));
        _paras.Add(new SqlParameter("@username", Session["uname"].ToString()));
        _paras.Add(new SqlParameter("@operationdate", DateTime.Now.ToString("yyyy-MM-dd")));
        string sql = "if not exists(select * from AccessNetWork_OperationLog where cityname=@cityname and username=@username and operationdate=@operationdate) ";
        sql += "INSERT AccessNetWork_OperationLog values(@cityname,@username,@operationdate)";
        SqlHelper.ExecuteNonQuery(SqlHelper.GetConnection(), CommandType.Text, sql, _paras.ToArray());
    }
    /// <summary>
    /// 设置操作记录查询条件
    /// </summary>
    /// <returns></returns>
    public string SetQueryConditionForOPLog()
    {
        string queryStr = "";
        //设置查询条件
        List<string> list = new List<string>();
        //按日期查询
        //提交开始日期
        if (!string.IsNullOrEmpty(Request.Form["sdate"]))
            list.Add(" OperationDate >='" + Request.Form["sdate"] + "'");
        //提交截止日期
        if (!string.IsNullOrEmpty(Request.Form["edate"]))
            list.Add(" OperationDate <='" + Request.Form["edate"] + "'");
        if (list.Count > 0)
            queryStr = "where " + string.Join(" and ", list.ToArray());
        return queryStr;
    }
    /// <summary>
    /// 获取操作记录数量统计 sort:id order:asc
    /// </summary>
    public void GetOPStatistics()
    {

        string where = SetQueryConditionForOPLog();
        StringBuilder sql = new StringBuilder("SELECT a.cityname AS cityname,ISNULL(num1,'0') AS num1 FROM ");
        sql.Append("(SELECT Cityname FROM citylist) AS a LEFT JOIN ");
        sql.Append(" (SELECT cityname,COUNT(1) as num1 FROM AccessNetWork_OperationLog ");
        sql.Append(where);
        sql.Append(" GROUP BY CityName) AS b ON a.Cityname=b.cityname ");
        sql.Append("order by ");
        sql.Append(Request.Form["sort"].ToString());
        sql.Append(" ");
        sql.Append(Request.Form["order"].ToString());
        DataSet ds = SqlHelper.ExecuteDataset(SqlHelper.GetConnection(), CommandType.Text, sql.ToString());
        Response.Write(JsonConvert.GetJsonFromDataTable(ds));
    }
    #endregion 用户操作记录
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}