<%@ Page Language="C#" %>

<% 
    /** 
     * 上网卡领取
     * NetWorkCardLog表操作对话框
     *
     */
    string imei = string.IsNullOrEmpty(Request.QueryString["imei"]) ? "" : Request.QueryString["imei"].ToString();
%>

<script type="text/javascript">
    var onFormSubmit = function ($dialog, $grid) {
        if ($('form').form('validate')) {
            parent.$.messager.confirm('询问', '您确认要领用此上网卡？', function (r) {
                if (r) {
                    var url = 'ajax/Srv_NetWorkCard.ashx/SaveReciveCardInfo';
                    parent.$.messager.progress({
                        title: '提示',
                        text: '数据提交中，请稍后....'
                    });
                    $.post(url, $.serializeObject($('form')), function (result) {
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
                            $grid.datagrid('reload');
                            $grid.datagrid('unselectAll');
                            $dialog.dialog('close');
                        } else {
                            parent.$.messager.alert('提示', result.msg, 'error');
                        }
                    }, 'json');
                }
            });
        }
    };
</script>
<form method="post">
    <table class="doc-table" id="stockList">
        <caption style="font-size: 14px; line-height: 35px; font-weight: 700;">
            领用上网卡
        </caption>
        <tr>
            <td style="text-align: right">IMEI：
            </td>
            <td>
                <input style="width: 200px;" name="imei" id="imei" class="inputBorder" readonly="readonly" value="<%=imei %>" /></td>
        </tr>
        <tr>
            <td style="text-align: right">用户号码：
            </td>
            <td>
                <input id="usernum" type="text" name="usernum" style="width: 200px;" class="inputBorder easyui-validatebox" data-options="required:true,validType:'BroadbandAccount'" /></td>
        </tr>
        <tr>
            <td style="text-align: right">领 用 人：
            </td>
            <td>
                <input style="width: 200px;" name="receivepeople" id="receivepeople" class="inputBorder easyui-validatebox" required /></td>
        </tr>
        <tr>
            <td style="text-align: right">备    注：
            </td>
            <td>
                <textarea style="width: 200px;" rows="2" name="memo" id="memo"/></td>
        </tr>
    </table>
</form>
