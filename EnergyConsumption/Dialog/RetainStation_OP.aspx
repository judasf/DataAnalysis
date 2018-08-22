<%@ Page Language="C#" %>

<style type="text/css">
    #resForm td {
        padding: 7px 2px;
    }

    #resForm .tdinput {
        text-align: left;
        width: 160px;
    }

    #resForm .left_td {
        text-align: right;
        background: #fafafa;
        width: 160px;
    }
</style>
<% 
    /** 
     *保留基站信息表操作对话框
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
        if ($('#resForm').form('validate')) {
            var url;
            if ($('#id').val().length == 0) {
                url = '../ajax/Srv_EnergyConsumption.ashx/SaveRetainStationInfo';
            } else {
                url = '../ajax/Srv_EnergyConsumption.ashx/UpdateRetainStationInfo';
            }
            parent.$.messager.progress({
                title: '提示',
                text: '数据处理中，请稍后....'
            });
            $.post(url, $.serializeObject($('#resForm')), function (result) {
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

    $(function () {

        if ($('#id').val().length > 0) {
            parent.$.messager.progress({
                text: '数据加载中....'
            });
            $.post('../ajax/Srv_EnergyConsumption.ashx/GetRetainStationInfoByID', {
                ID: $('#id').val()
            }, function (result) {
                if (result.rows[0].id != undefined) {
                    $('#resForm').form('load', {
                        'id': result.rows[0].id,
                        'stationname': result.rows[0].stationname,
                        'stationid': result.rows[0].stationid,
                        'sharedrelation': result.rows[0].sharedrelation,
                        'stationtype': result.rows[0].stationtype,
                        'stationcategory': result.rows[0].stationcategory,
                        'fannum': result.rows[0].fannum,
                        'switchcurrent': result.rows[0].switchcurrent,
                        'airconditionpower': result.rows[0].airconditionpower,
                        'cityname': result.rows[0].cityname,
                        'electype': result.rows[0].electype,
                        'ammeterno': result.rows[0].ammeterno,
                        'elecprice': result.rows[0].elecprice,
                        'paymentcycle': result.rows[0].paymentcycle
                    });
                }
                parent.$.messager.progress('close');
            }, 'json');
        }
    });

</script>
<form method="post" id="resForm">
    <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="border-collapse: collapse;">
        <tr>
            <td class="left_td">物理站址编码：
            </td>
            <td class="tdinput">
                <input type="hidden" id="id" name="id" value="<%=id %>" />
                <input name="stationid" id="stationid" class="inputBorder easyui-validatebox" data-options="required:true" <%--<%=(id!="")?"readonly":"" %>--%> />
            </td>
            <td class="left_td">基站名称：
            </td>
            <td class="tdinput">
                <input name="stationname" id="stationname" class="inputBorder easyui-validatebox" data-options="required:true" />
            </td>
        </tr>
        <tr>
            <td class="left_td">共享情况：
            </td>
            <td class="tdinput">
                <select id="sharedrelation" class="easyui-combobox" name="sharedrelation" data-options="panelHeight:'auto',editable:false">
                    <option>联通</option>
                    <option>联通+电信</option>
                    <option>联通+移动</option>
                    <option>联通+电信+移动</option>
                </select>
            </td>
            <td class="left_td">站型：
            </td>
            <td class="tdinput">
                <input name="stationtype" id="stationtype" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
        <tr>
            <td class="left_td">基站分类：
            </td>
            <td class="tdinput">
                <input name="stationcategory" id="stationcategory" class="inputBorder easyui-validatebox" />
            </td>
            <td class="left_td">载频/载扇数：
            </td>
            <td class="tdinput">
                <input name="fannum" id="fannum" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
        <tr>
            <td class="left_td">开关电源输出电流（A）：
            </td>
            <td class="tdinput">
                <input name="switchcurrent" id="switchcurrent" class="inputBorder easyui-validatebox" />
            </td>
            <td class="left_td">基站空调制冷功率累计（KW）：
            </td>
            <td class="tdinput">
                <input name="airconditionpower" id="airconditionpower" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
        <tr>
            <td class="left_td">所属区域：
            </td>
            <td class="tdinput">
                <select id="cityname" class="easyui-combobox" name="cityname" data-options="panelHeight:'auto',editable:false">
                    <option>市区</option>
                    <option>安阳县</option>
                    <option>汤阴县</option>
                    <option>内黄县</option>
                    <option>滑县</option>
                    <option>林州</option>
                </select>
            </td>
            <td class="left_td">用电形式：
            </td>
            <td class="tdinput">
                <select id="electype" class="easyui-combobox" name="electype" data-options="panelHeight:'auto',editable:false">
                    <option>直供电</option>
                    <option>转供电</option>
                </select>
            </td>
        </tr>
        <tr>
            <td class="left_td">电表户号：
            </td>
            <td class="tdinput">
                <input name="ammeterno" id="ammeterno" class="inputBorder easyui-validatebox" />
            </td>
            <td class="left_td">电费单价：
            </td>
            <td class="tdinput">
                <input name="elecprice" id="elecprice" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
        <tr>
            <td class="left_td">交费周期（月）：
            </td>
            <td class="tdinput" colspan="3">
                <input name="paymentcycle" id="paymentcycle" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
    </table>
</form>
