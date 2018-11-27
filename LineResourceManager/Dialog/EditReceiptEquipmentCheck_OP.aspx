<%@ Page Language="C#" %>

<% 
    /** 
     *设备核查岗,编辑设备核查回单信息
     */
    //id
    string id = string.IsNullOrEmpty(Request.QueryString["id"]) ? "" : Request.QueryString["id"].ToString();
%>
<script type="text/javascript">
    var onFormSubmit = function ($dialog, $grid) {
        var url = 'service/BusinessOrder.ashx/ReceiptEquipmentCheckByID';
        if ($('form').form('validate')) {
            parent.$.messager.confirm('询问', '保存设备核查回单？', function (r) {
                if (r) {
                    $.post(url, $.serializeObject($('form')), function (result) {
                        if (result.success) {
                            $grid.datagrid('reload');
                            $dialog.dialog('close');
                        } else
                            parent.$.messager.alert('提示', result.msg, 'error');
                    }, 'json');
                }
            });
        }
    };
    $(function () {
        //核查回单信息
        var el = $('tr:gt(6)', '#ECTable');
        //退回行业支撑信息
        var backEl = $('tr:eq(6)', '#ECTable');
        if ($('#id').val().length > 0) {
            parent.$.messager.progress({
                text: '数据加载中....'
            });
            $.post('service/BusinessOrder.ashx/GetEquipmentCheckInfoById', {
                ID: $('#id').val()
            }, function (result) {
                if (result.rows[0].id != undefined) {
                    $('form').form('load', {
                        'id': result.rows[0].id
                    });
                    $('#e_isrequirequipmentcheck').html(result.rows[0].e_isrequirequipmentcheck);
                    $('#e_checkrequire').html(result.rows[0].e_checkrequire);
                    $('#e_isrequire2route').html(result.rows[0].e_isrequire2route);
                    $('#e_isconvergence').html(result.rows[0].e_isconvergence);
                    $('#e_vlanno').html(result.rows[0].e_vlanno);

                    $('#er_isbacktosupport').combobox('setValue', result.rows[0].er_isbacktosupport);
                    $('#er_isequipmentsatisfy').combobox('setValue', result.rows[0].er_isequipmentsatisfy);
                    $('#er_checkuser').val(result.rows[0].er_checkuser);
                    $('#er_chechresult').val(result.rows[0].er_chechresult);
                    $('#isequipmentsatisfyvalue').val(result.rows[0].er_isequipmentsatisfy);

                }
                parent.$.messager.progress('close');
            }, 'json');
        }
        //默认隐藏退回信息
        backEl.detach();
        $('#er_isbacktosupport').combobox({
            editable: false,
            onSelect: function (rec) {
                if (rec.text == '是') {
                    backEl.insertAfter($('tr:eq(5)', '#ECTable'));
                    $.parser.parse(backEl);
                    el.detach();
                }
                else {
                    el.insertAfter($('tr:eq(5)', '#ECTable'));
                    $.parser.parse(el);
                    $('#er_isequipmentsatisfy').combobox('setValue', $('#isequipmentsatisfyvalue').val());
                    backEl.detach();
                }
                    
            }
        });
        $('#er_isequipmentsatisfy').combobox({
            editable: false,
            onSelect: function (rec) {
                $('#isequipmentsatisfyvalue').val(rec.text)
            }
        });
    });
</script>
<style>
    #ECTable .text-right { text-align: right; vertical-align: middle; width: 130px; }
    #ECTable input[readonly] { background-color: #fff; }
</style>
<form method="post">
    <table class="table table-bordered table-condensed" style="margin-bottom: 0;" id="ECTable">
        <tr>
            <td colspan="4" style="text-align: center; line-height: 30px; font-size: 16px; font-weight: 700;">设备核查</td>
        </tr>
        <tr>
            <td class="text-right">集响方案核查需求：</td>
            <td colspan="3">
                 <input type="hidden" id="id" name="id" value="<%=id %>" />
                 <input type="hidden" id="isequipmentsatisfyvalue" name="isequipmentsatisfyvalue"/>
                <div id="e_checkrequire"></div>
                </td>
        </tr>
        <tr>
            <td  class="text-right">双保护要求：
            </td>
            <td style="width:200px;">
                <span id="e_isrequire2route"></span>
            </td>
            <td class="text-right">是否汇聚：
            </td>
            <td>
                <span id="e_isconvergence"></span>
            </td>
        </tr>
        <tr>
            <td class="text-right">VLAN编号：
            </td>
            <td colspan="3">
                <span id="e_vlanno"></span>
            </td>
        </tr>
        <tr>
            <td colspan="4" style="text-align: center; line-height: 30px; font-size: 16px; font-weight: 700;">设备核查回单</td>
        </tr>
         <tr>
            <td class="text-right">是否退回行业支撑：
            </td>
            <td colspan="3">
                <select name="er_isbacktosupport" id="er_isbacktosupport" class="easyui-combobox" data-options="required:true,panelHeight:'auto'">
                    <option></option>
                    <option>是</option>
                    <option>否</option>
                </select>
            </td>
        </tr>
         <tr>
            <td class="text-right">退回原因：
            </td>
            <td colspan="3">
                 <textarea name="er_backtosupportreason" id="er_backtosupportreason" rows="4" class="easyui-validatebox span5" style="border-color: #ccc; background-color: #fff;" data-options="required:true"></textarea>
            </td>
        </tr>
        <tr>
            <td class="text-right">设备资源是否满足：
            </td>
            <td colspan="3">
                <select name="er_isequipmentsatisfy" id="er_isequipmentsatisfy" class="easyui-combobox" data-options="required:true,panelHeight:'auto',editable:true">
                    <option></option>
                    <option>是</option>
                    <option>否</option>
                </select>
            </td>
        </tr>
        <tr>
            <td class="text-right">设备资源核查人：</td>
            <td colspan="3">
                <input type="text" name="er_checkuser" id="er_checkuser" class="easyui-validatebox span3" data-options="required:true" /></td>
        </tr>
        <tr>
            <td class="text-right">设备核查结果详情：</td>
            <td colspan="3">
                <textarea name="er_chechresult" id="er_chechresult" rows="4" class="easyui-validatebox span5" style="border-color: #ccc; background-color: #fff;" data-options="required:true"></textarea>
            </td>
        </tr>
    </table>
</form>

