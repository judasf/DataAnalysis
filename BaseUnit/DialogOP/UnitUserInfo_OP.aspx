<%@ Page Language="C#" %>

<% 
    /** 
     * UserInfo表操作对话框
     * 
     */
    string uid = string.IsNullOrEmpty(Request.QueryString["UID"]) ? "" : Request.QueryString["UID"].ToString();
%>
<script type="text/javascript">

    var onFormSubmit = function ($dialog, $grid) {
        if ($('form').form('validate')) {
            var url;
            if ($('#UID').val().length == 0) {
                url = 'ajax/Srv_khjr.ashx/SaveUnitUserInfo';
            } else {
                url = 'ajax/Srv_khjr.ashx/UpdateUnitUserInfo';
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
        //初始化所在岗位
        $('#roleId').combobox({
            required: true,
            valueField: 'id',
            textField: 'text',
            editable: false,
            panelHeight: 'auto',
            data: [{ id: '13', text: '基层装维单元库管' }, { id: '14', text: '装维片区工号' }, { id: '17', text: '装维片区领料工号' }],
            onSelect: function (rec) {
                if (rec.id == '14') {
                    $('#areaTr').show();
                    $('#areaId').combobox({ required: true });
                }
                else {
                    $('#areaId').combobox({ required: false });
                    $('#areaTr').hide();
                }

            }
        });
        if ($('#UID').val().length > 0) {
            parent.$.messager.progress({
                text: '数据加载中....'
            });
            $.post('ajax/Srv_khjr.ashx/GetUnitUserInfoByID', {
                UID: $('#UID').val()
            }, function (result) {
                parent.$.messager.progress('close');
                if (result.success||result.rows[0]) {
                    if (result.rows[0].uid != undefined) {
                        $('form').form('load', {
                            'UID': result.rows[0].uid,
                            'uname': result.rows[0].uname,
                            'roleId': result.rows[0].roleid
                        });
                        if (result.rows[0].roleid == 14) {
                            $('#areaTr').show();
                            $('#areaId').combobox({ required: true }).combobox('setValue', result.rows[0].areaid);
                        }
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
            <td style="text-align: right">用户名：
            </td>
            <td>
                <input type="hidden" value="<%= uid%>" id="UID" name="UID" />
                <input id="uname" type="text" name="uname" class="inputBorder easyui-validatebox " required placeholder="用户名" />
            </td>
        </tr>
        <tr>
            <td style="text-align: right">所在岗位：
            </td>
            <td>
                <input id="roleId" class="combo" type="text" name="roleId" />
            </td>
        </tr>
        <tr id="areaTr" style="display: none;">
            <td style="text-align: right">所在片区：
            </td>
            <td>
                <input id="areaId" type="text" name="areaId" class="combo easyui-combobox" data-options="
                    valueField: 'id',
                    textField: 'text',
                    editable: false,
                    panelHeight: 200,
                    url: 'ajax/Srv_khjr.ashx/GetKHJR_UnitAreaCombobox'" />
            </td>
        </tr>
    </table>
</form>
