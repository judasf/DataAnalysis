﻿<%@ Page Language="C#" %>

<% 
    /** 
     *专线客户光缆回单,工单派发
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
    else
    {
        id = string.IsNullOrEmpty(Request.QueryString["id"]) ? "" : Request.QueryString["id"].ToString();
    }
%>
<script type="text/javascript">
    var onFormSubmit = function ($dialog, $grid) {
        var url = './ajax/Srv_LineResource.ashx/DispathSpecialLineOrderByID';
        if ($('form').form('validate')) {
            parent.$.messager.confirm('询问', '确认派发施工单位？', function (r) {
                if (r) {
                    $.post(url, $.serializeObject($('form')), function (result) {
                        if (result.success) {
                            parent.$.messager.alert('提示', result.msg, 'info');
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
        if ($('#id').val().length > 0) {
            parent.$.messager.progress({
                text: '数据加载中....'
            });
            $.post('../ajax/Srv_LineResource.ashx/GetSpecialLineByID', {
                ID: $('#id').val()
            }, function (result) {
                parent.$.messager.progress('close');
                if (result.rows[0].id != undefined) {
                    $('#inputtime').html(result.rows[0].inputtime);
                    $('#bussinesstype').html(result.rows[0].bussinesstype);
                    $('#chargingcode').html(result.rows[0].chargingcode);
                    $('#customername').html(result.rows[0].customername);
                    $('#address').html(result.rows[0].address);
                    $('#customercontact').html(result.rows[0].customercontact);
                    $('#customerphone').html(result.rows[0].customerphone);
                    $('#customermanager').html(result.rows[0].customermanager);
                    $('#direction').html(result.rows[0].direction);
                    $('#route').html(result.rows[0].route);
                    $('#username').html(result.rows[0].username);
                    $('#memo').html(result.rows[0].memo);
                    //$('#constructionunit').html(result.rows[0].constructionunit);
                    //$('#receiptroute').html(result.rows[0].receiptroute);
                    //$('#receiptuser').html(result.rows[0].receiptuser);
                    //$('#receipttime').html(result.rows[0].receipttime);
                    //$('#speciallinestatus').html(result.rows[0].speciallinestatus);
                    //$('#receiptmemo').html(result.rows[0].receiptmemo);
                    //showPhotoList(result.rows[0].id);
                }
            }, 'json');
        }
    });
</script>
<style>
    #LCTable td { padding: 7px 2px; }

    #LCTable .tdinput { text-align: left; }

    #LCTable .left_td { text-align: right; background: #fafafa; width: 100px; }
</style>
<form method="post">
    <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="border-collapse: collapse;" class="table table-bordered table-condensed" style="margin-bottom: 0;" id="LCTable">
        <tr>
            <td colspan="4" style="text-align: center; line-height: 30px; font-size: 16px; font-weight: 700;">专线客户光缆</td>

        </tr>
        <tr>
            <td class="left_td">派单日期：
            </td>
            <td class="tdinput" style="width: 180px;">
                <input type="hidden" value="<%=id %>" name="id" id="id" />
                <span id="inputtime"></span>
            </td>
            <td class="left_td">业务类型：
            </td>
            <td class="tdinput" style="width: 180px;">
                <span id="bussinesstype"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">计费编码：
            </td>
            <td class="tdinput">
                <span id="chargingcode"></span>
            </td>
            <td class="left_td">客户名称：
            </td>
            <td class="tdinput">
                <span id="customername"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">安装地址：
            </td>
            <td class="tdinput" colspan="3">
                <span id="address"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">客户联系人：
            </td>
            <td class="tdinput">
                <span id="customercontact"></span>
            </td>
            <td class="left_td">客户电话：
            </td>
            <td class="tdinput">
                <span id="customerphone"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">联通客户经理：
            </td>
            <td class="tdinput">
                <span id="customermanager"></span>
            </td>
            <td class="left_td">局向：
            </td>
            <td class="tdinput">
                <span id="direction"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">指定路由：
            </td>
            <td class="tdinput" colspan="3">
                <span id="route"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">工单录入人：
            </td>
            <td class="tdinput" colspan="3">
                <span id="username"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">备注：
            </td>
            <td class="tdinput" colspan="3">
                <span id="memo"></span>
            </td>
        </tr>
        <tr>
            <td colspan="4" style="text-align: center; line-height: 20px; font-size: 14px; font-weight: 700;">工单派发</td>
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
    </table>
</form>

