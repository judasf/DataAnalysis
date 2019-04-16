<%@ Page Language="C#" %>

<% 
    /** 
     * 客户接入库存型号操作对话框
     * 
     */
    string id = string.IsNullOrEmpty(Request.QueryString["id"]) ? "" : Request.QueryString["id"].ToString();
%>
<script type="text/javascript">
    var onClassFormSubmit = function ($dialog, $grid) {
        if ($('form').form('validate')) {
            var url;
            if ($('#id').val().length == 0) {
                url = '../ajax/Srv_CustomAccess.ashx/SaveWlxh';
            } else {
                url = '../ajax/Srv_CustomAccess.ashx/UpdateWlxh';
            }
            $.post(url, $.serializeObject($('form')), function (result) {
                if (result.success) {
                    $grid.datagrid('reload');
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
            $.post('../ajax/Srv_CustomAccess.ashx/GetWlxhByID', {
                id: $('#id').val()
            }, function (result) {
                if (result.rows[0]&&result.rows[0].id != undefined) {
                    $('form').form('load', {
                        'id': result.rows[0].id,
                        'typename': result.rows[0].typename,
                        'units': result.rows[0].units
                    });
                }
                else {
                    parent.$.messager.alert('提示', result.msg, 'error');
                }
                parent.$.messager.progress('close');
            }, 'json');
        }
    });
</script>
<form method="post">
    <table class="table table-bordered  table-hover">
        <tr>
            <td style="text-align: right">型号：
            </td>
            <td style="width: 250px;text-align:left;">
                <input type="hidden" id="id" name="id" value="<%=id %>" />
                <input id="TypeName" type="text" name="typename" style="width:200px" class="inputBorder easyui-validatebox"   required/>
            </td>
        </tr>
        <tr>
            <td style="text-align: right">单位：
            </td>
            <td style="width: 250px;text-align:left;">
                <input id="units" type="text" name="units" style="width:200px" class="inputBorder easyui-validatebox" required/>
            </td>
        </tr>
    </table>
</form>
