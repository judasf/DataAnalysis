<%@ Page Language="C#" %>

<style type="text/css">
    #slForm td {
        padding: 7px 2px;
    }

    #slForm .tdinput {
        text-align: left;
    }

    #slForm .left_td {
        text-align: right;
        background: #fafafa;
        width: 100px;
    }
</style>
<% 
    /** 
     *专线客户光缆操作对话框
     * 
     */
    string id = "";
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
        id = string.IsNullOrEmpty(Request.QueryString["id"]) ? "" : Request.QueryString["id"].ToString();
        roleid = int.Parse(Session["roleid"].ToString());
    }
%>
<script type="text/javascript">
    var onFormSubmit = function ($dialog, $grid) {
        if ($('#slForm').form('validate')) {
            var url;
            if ($('#id').val().length == 0) {
                url = '../ajax/Srv_LineResource.ashx/SaveSpecialLineInfo';
            } else {
                url = '../ajax/Srv_LineResource.ashx/UpdateSpecialLineInfo';
            }

            parent.$.messager.progress({
                title: '提示',
                text: '数据处理中，请稍后....'
            });
            $.post(url, $.serializeObject($('#slForm')), function (result) {
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
</script>
<form method="post" id="slForm">
    <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="border-collapse: collapse;">
        <tr>
            <td colspan="4" style="text-align: center; line-height: 30px; font-size: 16px; font-weight: 700;">专线客户光缆</td>

        </tr>
        <tr>
            <td class="left_td">业务类型：
            </td>
            <td class="tdinput">
                <input name="bussinesstype" id="bussinesstype" style="width: 180px" class="inputBorder easyui-validatebox" data-options="required:true" /><input type="hidden" id="id" name="id" value="<%=id %>" />
            </td>
            <td class="left_td">计费编码：
            </td>
            <td class="tdinput">
                <input name="chargingcode" id="chargingcode" style="width: 180px" class="inputBorder easyui-validatebox" data-options="required:true" />
            </td>
        </tr>
        <tr>
            <td class="left_td">客户名称：
            </td>
            <td class="tdinput" colspan="3">
                <input name="customername" id="customername" style="width: 400px" class="inputBorder easyui-validatebox" data-options="required:true" />

            </td>
        </tr>
        <tr>
            <td class="left_td">安装地址：
            </td>
            <td class="tdinput" colspan="3">
                <textarea name="address" id="address" class="inputBorder easyui-validatebox" data-options="required:true" style="width: 400px; height: 50px;" cols="" rows="3"></textarea>
            </td>
        </tr>
        <tr>
            <td class="left_td">客户联系人： </td>
            <td class="tdinput">
                <input name="customercontact" style="width: 180px" id="customercontact" class="inputBorder easyui-validatebox" data-options="required:true" />
            </td>
            <td class="left_td">客户电话： </td>
            <td class="tdinput">
                <input name="customerphone" style="width: 180px" id="customerphone" class="inputBorder easyui-validatebox" data-options="required:true" />
            </td>
        </tr>
        <tr>
            <td class="left_td">联通客户经理： </td>
            <td class="tdinput">
                <input name="customermanager" style="width: 180px" id="customermanager" class="inputBorder easyui-validatebox" data-options="required:true" />
            </td>
            <td class="left_td">局向： </td>
            <td class="tdinput">
                <input name="direction" style="width: 180px" id="direction" class="inputBorder easyui-validatebox" data-options="required:true" />
            </td>
        </tr>
        <tr>
            <td class="left_td">指定路由：
            </td>
            <td class="tdinput" colspan="3">
                <textarea name="route" id="route" class="inputBorder easyui-validatebox" data-options="required:true" style="width: 400px; height: 50px;" cols="" rows="3"></textarea>
            </td>
        </tr>
        <tr>
            <td class="left_td">指派施工单位：
            </td>
            <td colspan="3">
                <select name="constructionunit" id="constructionunit" class="easyui-combobox" style="width: 180px;" data-options="required:true,panelHeight:'auto',editable:false">
                    <option></option>
                    <option>文峰浩翔</option>
                    <option>中通服</option>
                    <option>长线局</option>
                    <option>北关浩翔</option>
                     <option>安阳县浩翔</option>
                    <option>客户支撑中心</option>
                    <option>设计院</option>
                </select>
            </td>
        </tr>
        <tr>
            <td class="left_td">备注：
            </td>
            <td class="tdinput" colspan="3">
                <input name="memo" id="memo" class="inputBorder easyui-validatebox" style="width: 400px" />
            </td>
        </tr>
    </table>
</form>
