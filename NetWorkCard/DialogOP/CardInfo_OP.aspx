<%@ Page Language="C#" %>

<% 
    /** 
     * 上网卡信息操作对话框
     * 
     */
    string id = string.IsNullOrEmpty(Request.QueryString["id"]) ? "" : Request.QueryString["id"].ToString();
    int roleid = -1;
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
            roleid = int.Parse(Session["roleid"].ToString());
        }
%>
<script type="text/javascript">
    var onClassFormSubmit = function ($dialog, $grid) {
        if ($('form').form('validate')) {
            var url;
            if ($('#id').val().length == 0) {
                url = '../ajax/Srv_NetWorkCard.ashx/SaveCardInfo';
            } else {
                url = '../ajax/Srv_NetWorkCard.ashx/UpdateCardInfo';
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
            $.post('../ajax/Srv_NetWorkCard.ashx/GetCardInfoByID', {
                id: $('#id').val()
            }, function (result) {
                if (result.rows[0] && result.rows[0].id != undefined) {
                    $('form').form('load', {
                        'id': result.rows[0].id,
                        'unitname': result.rows[0].unitname,
                        'imei': result.rows[0].imei
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
            <td style="text-align: right">基层装维单元：
            </td>
            <td style="width: 200px; text-align: left;">
                <input type="hidden" id="id" name="id" value="<%=id %>" />
                <select id="unitname" class="combo easyui-combobox" name="unitname" style="width: 150px;" data-options="panelHeight:'auto'">
                    <%if (roleid == 12)
                      { %>
                    <option><%=Session["deptname"] %></option>

                    <%}
                      else
                      { %>
                    <option>东风路装维单元</option>
                    <option>红旗路装维单元</option>
                    <option>相一路装维单元</option>
                    <option>东区装维单元</option>
                    <option>开发区装维单元</option>
                    <option>铁西区装维单元</option>
                    <%} %>
                </select>
            </td>
        </tr>
        <tr>
            <td style="text-align: right">IMEI：
            </td>
            <td style="width: 200px; text-align: left;">
                <input id="imei" type="text" name="imei" style="width: 150px" class="inputBorder easyui-validatebox" required />
            </td>
        </tr>
    </table>
</form>
