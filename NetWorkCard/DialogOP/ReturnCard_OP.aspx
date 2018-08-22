<%@ Page Language="C#" %>

<% 
    /** 
     * 上网卡归还
     * NetWorkCardLog表操作对话框
     *
     */
    string imei = string.IsNullOrEmpty(Request.QueryString["imei"]) ? "" : Request.QueryString["imei"].ToString();
%>

<script type="text/javascript">
    var onFormSubmit = function ($dialog, $grid) {
        if ($('form').form('validate')) {
            parent.$.messager.confirm('询问', '您确认要归还此上网卡？', function (r) {
                if (r) {
                    var url = 'ajax/Srv_NetWorkCard.ashx/SaveReturnCardInfo';
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
    $(function () {
        if ($('#imei').val().length > 0) {
            parent.$.messager.progress({
                text: '数据加载中....'
            });
            $.post('../ajax/Srv_NetWorkCard.ashx/GetUsingCardInfoByIMEI', {
                imei: $('#imei').val()
            }, function (result) {
                if (result.rows[0] && result.rows[0].id != undefined) {
                    $('#usernum').html(result.rows[0].usernum);
                    $('#receivepeople').html(result.rows[0].receivepeople);
                    $('#receivedate').html(result.rows[0].receivedate);
                    $('#memo').val(result.rows[0].memo);
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
    <table class="doc-table" id="stockList">
        <caption style="font-size: 14px; line-height: 35px; font-weight: 700;">
            归还上网卡
        </caption>
        <tr>
            <td style="text-align: right">IMEI：
            </td>
            <td>
                <input type="hidden" name="imei" id="imei" value="<%=imei %>" />
                <%=imei %>
            </td>
        </tr>
        <tr>
            <td style="text-align: right">用户号码：
            </td>
            <td>
                <span id="usernum"></span>
            </td>
        </tr>
        <tr>
            <td style="text-align: right">领 用 人：
            </td>
            <td>
                <span id="receivepeople"></span>
            </td>
        </tr>
        <tr>
            <td style="text-align: right">领用日期：
            </td>
            <td>
                <span id="receivedate"></span>
            </td>
        </tr>
        <tr>
            <td style="text-align: right">归 还 人：
            </td>
            <td>
                <input style="width: 200px;" name="returnpeople" id="returnpeople" class="inputBorder easyui-validatebox" required /></td>
        </tr>
        <tr>
            <td style="text-align: right">备    注：
            </td>
            <td>
                <textarea style="width: 200px;" rows="2" name="memo" id="memo"/></td>
        </tr>
    </table>
</form>
