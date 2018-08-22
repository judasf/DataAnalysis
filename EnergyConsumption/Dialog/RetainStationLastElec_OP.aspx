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
     *保留站上年最后一次缴费操作对话框
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
                url = '../ajax/Srv_EnergyConsumption.ashx/SaveRetainStationLastElec';
            } else {
                url = '../ajax/Srv_EnergyConsumption.ashx/UpdateRetainStationLastElec';
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
            $.post('../ajax/Srv_EnergyConsumption.ashx/GetRetainStationLastElecByID', {
                ID: $('#id').val()
            }, function (result) {
                if (result.rows[0].id != undefined) {
                    $('#stationid').html(result.rows[0].stationid);
                    $('#stationname').html(result.rows[0].stationname);
                    $('#sharedrelation').html(result.rows[0].sharedrelation);
                    $('#stationtype').html(result.rows[0].stationtype);
                    $('#cityname').html(result.rows[0].cityname);
                    $('#electype').html(result.rows[0].electype);
                    $('#ammeterno').html(result.rows[0].ammeterno);
                    $('#paymentyearmonth').html(result.rows[0].paymentyearmonth);
                    $('#resForm').form('load', {
                        'startdegrees': result.rows[0].startdegrees,
                        'enddegrees': result.rows[0].enddegrees,
                        'powerusage': result.rows[0].powerusage,
                        'rate': result.rows[0].rate,
                        'loss': result.rows[0].loss,
                        'elecprice': result.rows[0].elecprice,
                        'amount': result.rows[0].amount,
                        'meterperiod': result.rows[0].meterperiod,
                        'convertmonth': result.rows[0].convertmonth
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

            <td class="left_td">基站名称：
            </td>
            <td class="tdinput" style="width: 190px;">
                <span id="stationname"></span>
            </td>
            <td class="left_td">物理站址编码：
            </td>
            <td class="tdinput" style="width: 190px;">
                <input type="hidden" id="id" name="id" value="<%=id %>" />
                <span id="stationid"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">共享情况：
            </td>
            <td class="tdinput">
                <span id="sharedrelation"></span>
            </td>
            <td class="left_td">站型：
            </td>
            <td class="tdinput">
                <span id="stationtype"></span>
            </td>
        </tr>

        <tr>
            <td class="left_td">所属县市：
            </td>
            <td class="tdinput">
                <span id="cityname"></span>
            </td>
            <td class="left_td">用电形式：
            </td>
            <td class="tdinput">
                <span id="electype"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">电表户号：
            </td>
            <td class="tdinput">
                <span id="ammeterno"></span>
            </td>
            <td class="left_td">缴费年月：
            </td>
            <td class="tdinput">
                <span id="paymentyearmonth"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">起度：
            </td>
            <td class="tdinput">
                <input type="text" id="startdegrees" name="startdegrees" class="inputBorder easyui-numberbox" data-options="min:0,required:true,precision:2" />
            </td>
            <td class="left_td">止度：
            </td>
            <td class="tdinput">
                <input type="text" id="enddegrees" name="enddegrees" class="inputBorder easyui-numberbox" data-options="min:0,required:true,precision:2" />
            </td>
        </tr>
        <tr>

            <td class="left_td">用电量：
            </td>
            <td class="tdinput">
                <input type="text" id="powerusage" name="powerusage" class="inputBorder easyui-numberbox" data-options="min:0,required:true,precision:2" />
            </td>

            <td class="left_td">倍率：
            </td>
            <td class="tdinput">
                <input type="text" id="rate" name="rate" class="inputBorder easyui-numberbox" data-options="min:1,required:true" />
            </td>
        </tr>
        <tr>
            <td class="left_td">损耗：
            </td>
            <td class="tdinput">
                <input type="text" id="loss" name="loss" class="inputBorder easyui-numberbox" data-options="min:0,required:true,precision:2" />
            </td>
            <td class="left_td">单价（元）：
            </td>
            <td class="tdinput">
                <input type="text" id="elecprice" name="elecprice" class="inputBorder easyui-numberbox" data-options="min:0,required:true,precision:5" />
            </td>
        </tr>
        <tr>
            <td class="left_td">金额（元）：
            </td>
            <td class="tdinput" colspan="3">
                <input type="text" id="amount" name="amount" class="inputBorder easyui-numberbox" data-options="required:true,precision:2" />
            </td>

        </tr>
        <tr>
            <td class="left_td">抄表期间：
            </td>
            <td class="tdinput">
                <input name="meterperiod" id="meterperiod" class="inputBorder easyui-validatebox" />
            </td>
            <td class="left_td">折月：
            </td>
            <td class="tdinput">
                <input name="convertmonth" id="convertmonth" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
    </table>
</form>
