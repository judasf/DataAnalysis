<%@ Page Language="C#" %>

<style type="text/css">
    #detailTable td { padding: 7px 2px; }
    #detailTable .tdinput { text-align: left; }
    #detailTable .left_td { text-align: right; background: #fafafa; width: 100px; }
</style>
<% 
    /** 
     *查看保留基站信息
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
            $.post('../ajax/Srv_EnergyConsumption.ashx/GetRetainStationInfoByID', {
                ID: $('#id').val()
            }, function (result) {
                parent.$.messager.progress('close');
                if (result.rows[0].id != undefined) {
                    $('#stationname').html(result.rows[0].stationname);
                    $('#stationid').html(result.rows[0].stationid);
                    $('#sharedrelation').html(result.rows[0].sharedrelation);
                    $('#stationtype').html(result.rows[0].stationtype);
                    $('#stationcategory').html(result.rows[0].stationcategory);
                    $('#fannum').html(result.rows[0].fannum);
                    $('#switchcurrent').html(result.rows[0].switchcurrent);
                    $('#airconditionpower').html(result.rows[0].airconditionpower);
                    $('#cityname').html(result.rows[0].cityname);
                    $('#electype').html(result.rows[0].electype);
                    $('#ammeterno').html(result.rows[0].ammeterno);
                    $('#elecprice').html(result.rows[0].elecprice);
                    $('#paymentcycle').html(result.rows[0].paymentcycle);
                }
            }, 'json');
        }
    });

</script>
<table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="border-collapse: collapse;" id="detailTable">
    <tr>
            <td class="left_td"  style="width:130px;">物理站址编码：
            </td>
            <td class="tdinput"  style="width:190px;">
                <input type="hidden" id="id" name="id" value="<%=id %>" />
                <span id="stationid"></span>
            </td>
            <td class="left_td"  style="width:130px;">基站名称：
            </td>
            <td class="tdinput"  style="width:190px;">
                <span id="stationname"></span>
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
            <td class="left_td">基站分类：
            </td>
            <td class="tdinput">
                <span id="stationcategory"></span>
            </td>
            <td class="left_td">载频/载扇数：
            </td>
            <td class="tdinput">
                <span id="fannum"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">开关电源输出电流（A）：
            </td>
            <td class="tdinput">
                <span id="switchcurrent"></span>
            </td>
            <td class="left_td">基站空调制冷功率累计（KW）：
            </td>
            <td class="tdinput">
                <span id="airconditionpower"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">所属区域：
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
            <td class="left_td">电费单价：
            </td>
            <td class="tdinput">
                <span id="elecprice"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">交费周期（月）：
            </td>
            <td class="tdinput" colspan="3">
                <span id="paymentcycle"></span>
            </td>
        </tr>
</table>
