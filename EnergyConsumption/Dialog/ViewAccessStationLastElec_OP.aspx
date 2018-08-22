<%@ Page Language="C#" %>

<style type="text/css">
    #detailTable td {
        padding: 7px 2px;
    }

    #detailTable .tdinput {
        text-align: left;
    }

    #detailTable .left_td {
        text-align: right;
        background: #fafafa;
        width: 100px;
    }
</style>
<% 
    /** 
     *查看接入网上年最后一次缴费信息
     * 
     */
    string id = string.IsNullOrEmpty(Request.QueryString["id"]) ? "" : Request.QueryString["id"].ToString();
%>
<script type="text/javascript">
    $(function () {
        if ($('#id').val().length > 0) {
            parent.$.messager.progress({
                text: '数据加载中....'
            });
            $.post('../ajax/Srv_EnergyConsumption.ashx/GetAccessStationLastElecByID', {
                ID: $('#id').val()
            }, function (result) {
                parent.$.messager.progress('close');
                if (result.rows[0].id != undefined) {
                    $('#stationid').html(result.rows[0].stationid);
                    $('#roomname').html(result.rows[0].roomname);
                    $('#pointcategory').html(result.rows[0].pointcategory);
                    $('#cityname').html(result.rows[0].cityname);
                    $('#powersupplymode').html(result.rows[0].powersupplymode);
                    $('#electype').html(result.rows[0].electype);
                    $('#ammeterno').html(result.rows[0].ammeterno);
                    $('#paymentyearmonth').html(result.rows[0].paymentyearmonth);
                    $('#startdegrees').html(result.rows[0].startdegrees);
                    $('#enddegrees').html(result.rows[0].enddegrees);
                    $('#powerusage').html(result.rows[0].powerusage);
                    $('#elecprice').html(result.rows[0].elecprice);
                    $('#amount').html(result.rows[0].amount);
                    $('#meterperiod').html(result.rows[0].meterperiod);
                    $('#convertmonth').html(result.rows[0].convertmonth);
                    $('#memo').html(result.rows[0].memo);
                }
            }, 'json');
        }
    });

</script>
<table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="border-collapse: collapse;" id="detailTable">
    <tr>
        <td class="left_td">局站编码：
        </td>
        <td class="tdinput" style="width: 190px;">
            <input type="hidden" id="id" name="id" value="<%=id %>" />
            <span id="stationid"></span>
        </td>
        <td class="left_td">机房名称：
        </td>
        <td class="tdinput" style="width: 190px;">
            <span id="roomname"></span>
        </td>
    </tr>
    <tr>
        <td class="left_td">网点分类：
        </td>
        <td class="tdinput">
            <span id="pointcategory"></span>
        </td>
        <td class="left_td">所属市县：
        </td>
        <td class="tdinput">
            <span id="cityname"></span>
        </td>
    </tr>
    <tr>
        <td class="left_td">供电方式：
        </td>
        <td class="tdinput">
            <span id="powersupplymode"></span>
        </td>
        <td class="left_td">用电类别：
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
            <span id="startdegrees"></span>
        </td>
        <td class="left_td">止度：
        </td>
        <td class="tdinput">
            <span id="enddegrees"></span>
        </td>
    </tr>
    <tr>

        <td class="left_td">用电量：
        </td>
        <td class="tdinput">
            <span id="powerusage"></span>
        </td>
        <td class="left_td">单价（元）：
        </td>
        <td class="tdinput">
            <span id="elecprice"></span>
        </td>
    </tr>
    <tr>
        <td class="left_td">金额（元）：
        </td>
        <td class="tdinput" colspan="3">
            <span id="amount"></span>
        </td>

    </tr>
    <tr>
        <td class="left_td">抄表期间：
        </td>
        <td class="tdinput">
            <span id="meterperiod"></span>
        </td>
        <td class="left_td">折月：
        </td>
        <td class="tdinput">
            <span id="convertmonth"></span>
        </td>
    </tr>
</table>
