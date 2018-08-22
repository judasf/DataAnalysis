<%@ Page Language="C#" %>

<% 
    /** 
     * CustomAccess_Picker表操作对话框
     * 
     */
    string ID = string.IsNullOrEmpty(Request.QueryString["ID"]) ? "" : Request.QueryString["ID"].ToString();
%>
<script type="text/javascript">

    var onFormSubmit = function ($dialog, $grid) {
        if ($('form').form('validate')) {
            var url;
            if ($('#ID').val().length == 0) {
                url = 'ajax/Srv_CustomAccess.ashx/SaveUnitPickerInfo';
            } else {
                url = 'ajax/Srv_CustomAccess.ashx/UpdateUnitPickerInfo';
            }
            $.post(url, $.serializeObject($('form')), function (result) {
                if (result.success) {
                    $grid.datagrid('reload'); 
                    $grid.datagrid('unselectAll');
                    $dialog.dialog('close');
                } else {
                    parent.$.messager.alert('提示', result.msg, 'error');
                }
            }, 'json');
        }
    };
    $(function () {
        if ($('#ID').val().length > 0) {
            parent.$.messager.progress({
                text: '数据加载中....'
            });
            $.post('ajax/Srv_CustomAccess.ashx/GetUnitPickerInfoByID', {
                ID: $('#ID').val()
            }, function (result) {
                parent.$.messager.progress('close');
                if (result.success||result.rows[0]) {
                    if (result.rows[0].id != undefined) {
                        $('form').form('load', {
                            'ID': result.rows[0].id,
                            'pickername': result.rows[0].pickername,
                            'areaId': result.rows[0].areaid
                        });
                    }
                } else {
                    parent.$.messager.alert('提示', result.msg, 'error');
                }
               
            }, 'json');
        }
    });
</script>
<form method="post">
    <table class="doc-table">
        <tr>
            <td style="text-align: right">领料人姓名：
            </td>
            <td>
                <input type="hidden" value="<%= ID%>" id="ID" name="ID" />
                <input id="pickername" type="text" name="pickername" class="inputBorder easyui-validatebox " required placeholder="领料人姓名" />
            </td>
        </tr>
        <tr>
            <td style="text-align: right">所在营业部：
            </td>
            <td>
                <input id="areaId" type="text" name="areaId" class="combo easyui-combobox" data-options="
                    valueField: 'id',
                    textField: 'text',
                    editable: false,
                    required:true,
                    panelHeight: 200,
                    url: 'ajax/Srv_CustomAccess.ashx/GetCustomAccess_UnitAreaCombobox'" />
            </td>
        </tr>
    </table>
</form>
