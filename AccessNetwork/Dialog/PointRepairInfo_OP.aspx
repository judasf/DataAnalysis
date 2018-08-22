<%@ Page Language="C#" %>

<style type="text/css">
    #resForm td { padding: 7px 2px; }
    #resForm .tdinput { text-align: left; }
    #resForm .left_td { text-align: right; background: #fafafa; width: 100px; }
</style>
<% 
    /** 
     *网点维修台账操作对话框
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
    var onFormSubmit = function ($dialog, $grid) {
        if ($('#resForm').form('validate')) {
            var url;
            if ($('#id').val().length == 0) {
                url = '../ajax/Srv_AccessNetwork.ashx/SavePointRepairInfo';
            } else {
                url = '../ajax/Srv_AccessNetwork.ashx/UpdatePointRepairInfo';
            }
            parent.$.messager.progress({
                title: '提示',
                text: '数据处理中，请稍后....'
            });
            $.post(url, $.serializeObject($('#resForm')), function (result) {
                parent.$.messager.progress('close');
                if (result.success) {
                    $.messager.show({
                        title: '提示',
                        msg: result.msg,
                        showType: 'slide',
                        timeout: '2000',
                        style: {
                            top: document.body.scrollTop + document.documentElement.scrollTop
                        }
                    });
                    $grid.datagrid('load');
                    $dialog.dialog('close');
                } else {
                    parent.$.messager.alert('提示', result.msg, 'error');
                }
            }, 'json');
        }
    };

    $(function () {

        if ($('#id').val().length > 0) {
            parent.$.messager.progress({
                text: '数据加载中....'
            });
            $.post('../ajax/Srv_AccessNetwork.ashx/GetPointRepairInfoByID', {
                ID: $('#id').val()
            }, function (result) {
                if (result.rows[0].id != undefined) {
                    $('#resForm').form('load', {
                        'deptname': result.rows[0].deptname,
                        'anid': result.rows[0].anid,
                        'roomname': result.rows[0].roomname,
                        'cityname': result.rows[0].cityname,
                        'repairinfo': result.rows[0].repairinfo,
                        'repairreportno': result.rows[0].repairreportno,
                        'applytime': result.rows[0].applytime,
                        'noticerepairtime': result.rows[0].noticerepairtime,
                        'repairfinishtime': result.rows[0].repairfinishtime,
                        'warrantyexpirationdate': result.rows[0].warrantyexpirationdate,
                        'repaircontent': result.rows[0].repaircontent,
                        'checkinfo': result.rows[0].checkinfo,
                        'repairperson': result.rows[0].repairperson,
                        'repairpersontel': result.rows[0].repairpersontel,
                        'applymoney': result.rows[0].applymoney,
                        'reimnursemoney': result.rows[0].reimnursemoney,
                        'projecttime': result.rows[0].projecttime,
                        'reimbursetime': result.rows[0].reimbursetime,
                        'memo': result.rows[0].memo
                    });
                }
                parent.$.messager.progress('close');
            }, 'json');
        }
    });

</script>
<form method="post" id="resForm">
    <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="border-collapse: collapse;">
        <tr>
            <td class="left_td">单位：
            </td>
            <td class="tdinput">
                <input type="hidden" id="id" name="id" value="<%=id %>" />
                <input name="deptname" id="deptname" class="inputBorder easyui-validatebox" data-options="required:true" />
            </td>
            <td class="left_td">机房编号：
            </td>
            <td class="tdinput">
                <input name="anid" id="anid" class="inputBorder easyui-validatebox" data-options="required:true" />
            </td>
        </tr>
        <tr>
            <td class="left_td">机房名称：
            </td>
            <td class="tdinput">
                <input name="roomname" id="roomname" class="inputBorder easyui-validatebox" />
            </td>
            <td class="left_td">所属县市：
            </td>
            <td class="tdinput">
                <select id="cityname" class="easyui-combobox" name="cityname" data-options="panelHeight:'auto',editable:false">
                    <option>安阳市</option>
                    <option>安阳县</option>
                    <option>汤阴县</option>
                    <option>内黄县</option>
                    <option>滑县</option>
                    <option>林州市</option>
                </select>
            </td>
            
        </tr>

        <tr>
            <td class="left_td">维修事项：
            </td>
            <td class="tdinput" colspan="3">
                <textarea name="repairinfo" id="repairinfo" class="easyui-validatebox" style="width: 400px" rows="2" />
            </td>
        </tr>
        <tr>

            <td class="left_td">维修签报单号：
            </td>
            <td class="tdinput">
                <input name="repairreportno" id="repairreportno" class="inputBorder easyui-validatebox" />
            </td>

            <td class="left_td">申请时间：
            </td>
            <td class="tdinput">
                <input name="applytime" id="applytime" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
        <tr>
            <td class="left_td">通知维修时间：
            </td>
            <td class="tdinput">
                <input name="noticerepairtime" id="noticerepairtime" class="inputBorder easyui-validatebox" />
            </td>
            <td class="left_td">维修完成时间：
            </td>
            <td class="tdinput">
                <input name="repairfinishtime" id="repairfinishtime" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
        <tr>
            <td class="left_td">保修截止日期：
            </td>
            <td class="tdinput" colspan="3">
                <input name="warrantyexpirationdate" id="warrantyexpirationdate" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
        <tr>
            <td class="left_td">维修内容：
            </td>
            <td class="tdinput" colspan="3">
                 <textarea name="repaircontent" id="repaircontent" class="easyui-validatebox" style="width: 400px" rows="2" />
            </td>
        </tr>
        <tr>
            <td class="left_td">验收情况(包括验收人员名单)：
            </td>
            <td class="tdinput" colspan="3">
                 <textarea name="checkinfo" id="checkinfo" class="easyui-validatebox" style="width: 400px" rows="2" />
            </td>
        </tr>
        <tr>
            <td class="left_td">维修方名称：
            </td>
            <td class="tdinput">
                <input name="repairperson" id="repairperson" class="inputBorder easyui-validatebox" />
            </td>
            <td class="left_td">维修方联系方式：
            </td>
            <td class="tdinput">
                <input name="repairpersontel" id="repairpersontel" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
        <tr>
            <td class="left_td">申请金额：
            </td>
            <td class="tdinput">
                <input name="applymoney" id="applymoney" class="inputBorder easyui-validatebox" />
            </td>
            <td class="left_td">报账金额：
            </td>
            <td class="tdinput">
                <input name="reimnursemoney" id="reimnursemoney" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
        <tr>
            <td class="left_td">立项时间：
            </td>
            <td class="tdinput">
                <input name="projecttime" id="projecttime" class="inputBorder easyui-validatebox" />
            </td>
            <td class="left_td">报账时间：
            </td>
            <td class="tdinput">
                <input name="reimbursetime" id="reimbursetime" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
        <tr>
            <td class="left_td">备注：
            </td>
            <td class="tdinput" colspan="3">
                 <textarea name="memo" id="memo" class="easyui-validatebox" style="width: 400px" rows="2" />
            </td>
        </tr>
    </table>
</form>
