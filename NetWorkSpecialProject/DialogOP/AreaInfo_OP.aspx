<%@ Page Language="C#" %>

<% 
    /** 
     * 领料单位操作对话框
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
    id = string.IsNullOrEmpty(Request.QueryString["id"]) ? "" : Request.QueryString["id"].ToString();
%>
<script type="text/javascript">
    var onClassFormSubmit = function ($dialog, $grid) {
        if ($('form').form('validate')) {
            var url;
            if ($('#id').val().length == 0) {
                url = '../ajax/Srv_NetWorkSpecialProject.ashx/SaveAreaInfo';
            } else {
                url = '../ajax/Srv_NetWorkSpecialProject.ashx/UpdateAreaInfo';
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
            $.post('../ajax/Srv_NetWorkSpecialProject.ashx/GetAreaInfoByID', {
                id: $('#id').val()
            }, function (result) {
                if (result.rows[0] && result.rows[0].id != undefined) {
                    $('form').form('load', {
                        'id': result.rows[0].id,
                        'unitname': result.rows[0].unitname,
                        'areaname': result.rows[0].areaname
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
            <td style="text-align: right">领料单位名称：
            </td>
            <td style="width: 200px; text-align: left;">
                <input id="areaname" type="text" name="areaname" style="width: 150px" class="inputBorder easyui-validatebox" required />
                <input type="hidden" id="id" name="id" value="<%=id %>" />
            </td>
        </tr>
    </table>
</form>
