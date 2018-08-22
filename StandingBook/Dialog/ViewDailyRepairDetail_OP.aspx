<%@ Page Language="C#" %>

<style type="text/css">
    #detailTable td, #detailTable th { padding: 7px 2px; }

    #detailTable .tdinput { text-align: left; }

    #detailTable .left_td { text-align: right; background: #fafafa; width: 190px; }
</style>
<% 
    /** 
     *查看日常维修台账详情
     * 
     */
    string id = "";
    if (Session["uname"] == null || Session["uname"].ToString() == "")
    {%>
<script type="text/javascript">
    $(function () {
        parent.$.messager.alert('提示', '登陆超时，请重新登陆再进行操作！', 'error', function () {
            parent.location.replace('logout.aspx');
        });
    });

</script>
<%}
    else
    {
        id = string.IsNullOrEmpty(Request.QueryString["id"]) ? "" : Request.QueryString["id"].ToString();
    }
%>
<script type="text/javascript">
    var showPJAttList = function (filename, filepath) {
        /// <summary>显示已上传项目附件</summary>
        $('#ProjectAttList').empty();
        $('#ProjectAttList').append('<span style="margin-right:10px;"><a class="ext-icon-attach" style="padding-left:20px;" target="_blank" href="' + filepath + '"   title="' + filename + '">' + filename + '</a></span>');
    };
    //显示物料使用信息
    var showMaterialList = function (repairorderno) {
        $.post('../ajax/Srv_StandingBook.ashx/GetRepairMaterialListByNo', { no: repairorderno }, function (nodeRes) {
            if (nodeRes.total > 0) {
                $.each(nodeRes.rows, function (i, item) {
                    if (i >= 0) {
                        var elE = $.formatString('<tr style="text-align:center;background: #f0f0f0;"><td>{0}</td><td>{1}</td><td>{2}</td><td>{3}</td></tr>', item.classname, item.typename, item.amount, item.units);
                        $(elE).insertAfter($('#wxylList'));
                    }
                });
            }
        }, 'json');
    };
    $(function () {
        if ($('#id').val().length > 0) {
            parent.$.messager.progress({
                text: '数据加载中....'
            });
            $.post('../ajax/Srv_StandingBook.ashx/GetDailyRepairInfoByID', {
                ID: $('#id').val()
            }, function (result) {
                parent.$.messager.progress('close');
                if (result.rows[0].id != undefined) {
                    $('#repairorderno').html(result.rows[0].repairorderno);
                    $('#repairdate').html(result.rows[0].repairdate);
                    $('#stationid').html(result.rows[0].stationid);
                    $('#roomname').html(result.rows[0].roomname);
                    $('#repairplace').html(result.rows[0].repairplace);
                    $('#cityname').html(result.rows[0].cityname);
                    $('#pointtype').html(result.rows[0].pointtype);
                    $('#eqtype').html(result.rows[0].eqtype);
                    $('#repairitem').html(result.rows[0].repairitem);
                    $('#reimmoney').html(result.rows[0].reimmoney);
                    $('#reimtime').html(result.rows[0].reimtime);
                    $('#faultorderno').html(result.rows[0].faultorderno);
                    $('#jobplanno').html(result.rows[0].jobplanno);
                    $('#reportno').html(result.rows[0].reportno);
                    $('#memo1').html(result.rows[0].memo1);
                    $('#memo2').html(result.rows[0].memo2);
                    $('#memo3').html(result.rows[0].memo3);
                    //$('#isusematerial').html(result.rows[0].isusematerial);
                    //根据是否使用物料情况显示用料信息
                    if (result.rows[0].isusematerial != '否') {
                        //判断显示新旧维修用料信息
                        if (result.rows[0].repairmaterials != undefined && result.rows[0].repairmaterials.length > 0) {
                            $('#wxylListTitle').hide();
                            $('#wxylList').hide();
                            $('#repairmaterials').html(result.rows[0].repairmaterials);
                        } else {

                            $('#old_repairmaterials').hide();
                            showMaterialList(result.rows[0].repairorderno);
                        }
                    }
                    else
                    {
                       
                        $('#wxylListTitle').hide();
                        $('#wxylList').hide();
                        $('#old_repairmaterials').show();
                        $('#repairmaterials').html('未用料');
                    }
                    showPJAttList(result.rows[0].attachfile, result.rows[0].attachfilepath);
                }
            }, 'json');
        }
    });

</script>
<table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="border-collapse: collapse;" id="detailTable">
    <tr>
        <td class="left_td">维修单编号：
        </td>
        <td class="tdinput" style="width: 180px;">
            <span id="repairorderno"></span>
            <input type="hidden" id="id" name="id" value="<%=id %>" />
        </td>
        <td class="left_td">维修日期：
        </td>
        <td class="tdinput" style="width: 180px;">
            <span id="repairdate"></span>
        </td>
    </tr>
    <tr>
        <td class="left_td">局站编码：
        </td>
        <td class="tdinput" colspan="3">
            <span id="stationid"></span>
        </td>
    </tr>
    <tr>
        <td class="left_td">机房名称：
        </td>
        <td class="tdinput" colspan="3">
            <span id="roomname"></span>
        </td>
    </tr>
    <tr>
        <td class="left_td">维修地点：
        </td>
        <td class="tdinput" colspan="3">
            <span id="repairplace"></span>
        </td>
    </tr>
    <tr>
        <td class="left_td">单位：
        </td>
        <td class="tdinput">
            <span id="cityname"></span>
        </td>
        <td class="left_td">网点类别：
        </td>
        <td class="tdinput">
            <span id="pointtype"></span>
        </td>
    </tr>
    <tr>

        <td class="left_td">设备类型：
        </td>
        <td class="tdinput" colspan="3">
            <span id="eqtype"></span>
        </td>
    </tr>
    <tr>
        <td class="left_td">维修事项：
        </td>
        <td class="tdinput" colspan="3">
            <span id="repairitem"></span>
        </td>
    </tr>
   <%-- <tr>
        <td class="left_td">是否使用物料：
        </td>
        <td class="tdinput" colspan="3">
            <span id="isusematerial"></span>
        </td>
    </tr>--%>
    <tr id="old_repairmaterials">
        <td class="left_td">维修用料：
        </td>
        <td class="tdinput" colspan="3">
            <span id="repairmaterials"></span>
        </td>
    </tr>
    <tr id="wxylListTitle">
        <td colspan="4" style="font-size: 12px; font-weight: 700; text-align: center; background: #fafafa;">维修用料
        </td>
    </tr>
    <tr id="wxylList" style="text-align: center; background: #fafafa;">
        <th>物料类型
        </th>
        <th style="width: 420px;">物料型号
        </th>
        <th style="width: 100px;">使用数量
        </th>
        <th style="width: 60px;">单位
        </th>
    </tr>
    <tr>
        <td class="left_td">报账金额：
        </td>
        <td class="tdinput">
            <span id="reimmoney"></span>
        </td>

        <td class="left_td">报账时间：
        </td>
        <td class="tdinput">
            <span id="reimtime"></span>
        </td>
    </tr>
    <tr>
        <td class="left_td">上传资料：            
        </td>
        <td class="tdinput">
            <div id="ProjectAttList"></div>
        </td>
        <td class="left_td">故障单号：
        </td>
        <td class="tdinput">
            <span id="faultorderno"></span>
        </td>
    </tr>
    <tr>
        <td class="left_td">作业计划编号：
        </td>
        <td class="tdinput">
            <span id="jobplanno"></span>
        </td>
        <td class="left_td">签报编号：
        </td>
        <td class="tdinput">
            <span id="reportno"></span>
        </td>
    </tr>
    <tr>
        <td class="left_td">备注1：
        </td>
        <td class="tdinput" colspan="3">
            <div id="memo1"></div>
        </td>
    </tr>
    <tr>
        <td class="left_td">备注2：
        </td>
        <td class="tdinput" colspan="3">
            <div id="memo2"></div>
        </td>
    </tr>
    <tr>
        <td class="left_td">备注3：
        </td>
        <td class="tdinput" colspan="3">
            <div id="memo3"></div>
        </td>
    </tr>

</table>
