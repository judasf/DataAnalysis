<%@ Page Language="C#" %>

<style type="text/css">
    #detailTable td { padding: 7px 2px; }
    #detailTable .tdinput { text-align: left; }
    #detailTable .left_td { text-align: right; background: #fafafa; width: 100px; }
</style>
<% 
    /** 
     *查看网点维修台账详情
     * 
     */
    string id = string.IsNullOrEmpty(Request.QueryString["id"]) ? "" : Request.QueryString["id"].ToString();
%>
<script type="text/javascript">
    $(function () {
        if ($('#id').val().length > 0) {
            parent.$.messager.progress({
                text: '数据加载中....'
            });
            $.post('../ajax/Srv_AccessNetwork.ashx/GetPointRepairInfoByID', {
                ID: $('#id').val()
            }, function (result) {
                parent.$.messager.progress('close');
                if (result.rows[0].id != undefined) {
                    $('#deptname').html(result.rows[0].deptname);
                    $('#anid').html(result.rows[0].anid);
                    $('#roomname').html(result.rows[0].roomname);
                    $('#cityname').html(result.rows[0].cityname);
                    $('#repairinfo').html(result.rows[0].repairinfo);
                    $('#repairreportno').html(result.rows[0].repairreportno);
                    $('#applytime').html(result.rows[0].applytime);
                    $('#noticerepairtime').html(result.rows[0].noticerepairtime);
                    $('#repairfinishtime').html(result.rows[0].repairfinishtime);
                    $('#warrantyexpirationdate').html(result.rows[0].warrantyexpirationdate);
                    $('#repaircontent').html(result.rows[0].repaircontent);
                    $('#checkinfo').html(result.rows[0].checkinfo);
                    $('#repairperson').html(result.rows[0].repairperson);
                    $('#repairpersontel').html(result.rows[0].repairpersontel);
                    $('#applymoney').html(result.rows[0].applymoney);
                    $('#reimnursemoney').html(result.rows[0].reimnursemoney);
                    $('#projecttime').html(result.rows[0].projecttime);
                    $('#reimbursetime').html(result.rows[0].reimbursetime);
                    $('#memo').html(result.rows[0].memo);
                }
            }, 'json');
        }
    });

</script>
<table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="border-collapse: collapse;" id="detailTable">
    <tr>
        <td class="left_td">单位：
        </td>
        <td class="tdinput" style="width:190px;">
            <input type="hidden" value="<%=id %>" id="id" name="id" />
            <span id="deptname"></span>
        </td>
        <td class="left_td">机房编号：
        </td>
        <td class="tdinput" style="width:190px;">
            <span id="anid"></span>
        </td>
    </tr>
    <tr>
        <td class="left_td">机房名称：
        </td>
        <td class="tdinput">
            <span id="roomname"></span>
        </td>
        <td class="left_td">所属县市：
        </td>
        <td class="tdinput">
            <span id="cityname"></span>
        </td>

    </tr>

    <tr>
        <td class="left_td">维修事项：
        </td>
        <td class="tdinput" colspan="3">
            <div id="repairinfo"></div>
        </td>
    </tr>
    <tr>

        <td class="left_td">维修签报单号：
        </td>
        <td class="tdinput">
            <span id="repairreportno"></span>
        </td>

        <td class="left_td">申请时间：
        </td>
        <td class="tdinput">
            <span id="applytime"></span>
        </td>
    </tr>
    <tr>
        <td class="left_td">通知维修时间：
        </td>
        <td class="tdinput">
            <span id="noticerepairtime"></span>
        </td>
        <td class="left_td">维修完成时间：
        </td>
        <td class="tdinput">
            <span id="repairfinishtime"></span>
        </td>
    </tr>
    <tr>
        <td class="left_td">保修截止日期：
        </td>
        <td class="tdinput" colspan="3">
            <span id="warrantyexpirationdate"></span>
        </td>
    </tr>
    <tr>
        <td class="left_td">维修内容：
        </td>
        <td class="tdinput" colspan="3">
            <div id="repaircontent"></div>
        </td>
    </tr>
    <tr>
        <td class="left_td">验收情况(包括验收人员名单)：
        </td>
        <td class="tdinput" colspan="3">
            <div id="checkinfo"></div>
        </td>
    </tr>
    <tr>
        <td class="left_td">维修方名称：
        </td>
        <td class="tdinput">
            <span id="repairperson"></span>
        </td>
        <td class="left_td">维修方联系方式：
        </td>
        <td class="tdinput">
            <span id="repairpersontel"></span>
        </td>
    </tr>
    <tr>
        <td class="left_td">申请金额：
        </td>
        <td class="tdinput">
            <span id="applymoney"></span>
        </td>
        <td class="left_td">报账金额：
        </td>
        <td class="tdinput">
            <span id="reimnursemoney"></span>
        </td>
    </tr>
    <tr>
        <td class="left_td">立项时间：
        </td>
        <td class="tdinput">
            <span id="projecttime"></span>
        </td>
        <td class="left_td">报账时间：
        </td>
        <td class="tdinput">
            <span id="reimbursetime"></span>
        </td>
    </tr>
    <tr>
        <td class="left_td">备注：
        </td>
        <td class="tdinput" colspan="3">
            <div id="memo"></div>
        </td>
    </tr>
</table>
