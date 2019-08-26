<%@ Page Language="C#" %>

<% 
    /** 
     * 物料型号操作对话框
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
                url = '../ajax/Srv_ResourceReuse.ashx/SaveTypeInfo';
            } else {
                url = '../ajax/Srv_ResourceReuse.ashx/UpdateTypeInfo';
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
            $.post('../ajax/Srv_ResourceReuse.ashx/GetTypeInfoByID', {
                id: $('#id').val()
            }, function (result) {
                if (result.rows[0]&&result.rows[0].id != undefined) {
                    $('form').form('load', {
                        'id': result.rows[0].id,
                        'price': result.rows[0].price,
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
    <table class="doc-table">
       
        <tr>
            <td style="width: 80px;text-align: right">资源类别：
            </td>
            <td style="width: 250px;text-align:left;">
                 <input type="hidden" id="id" name="id" value="<%=id %>" />
                <input id="TypeName" type="text" name="typename" style="width:200px" class="inputBorder easyui-validatebox"   required/>
            </td>
        </tr>
        <tr>
            <td style="text-align: right">采购单价（元）：
            </td>
            <td style="width: 250px;text-align:left;">
                <input id="price" type="text" name="price"  class="inputBorder easyui-validatebox" required/>
            </td>
        </tr>
         <tr>
            <td style="text-align: right">计量单位：
            </td>
            <td style="width: 250px;text-align:left;">
                <input id="units" type="text" name="units"  class="inputBorder easyui-validatebox" required/>
            </td>
        </tr>
    </table>
</form>
