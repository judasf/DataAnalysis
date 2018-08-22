<%@ Page Language="C#" %>

<style type="text/css">
    #detailTable td { padding: 7px 2px; }
    #detailTable .tdinput { text-align: left; }
    #detailTable .left_td { text-align: right; background: #fafafa; width: 100px; }
</style>
<% 
    /** 
     *查看接入网局站信息
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
            $.post('../ajax/Srv_EnergyConsumption.ashx/GetAccessStationInfoByID', {
                ID: $('#id').val()
            }, function (result) {
                parent.$.messager.progress('close');
                if (result.rows[0].id != undefined) {
                    $('#stationid').html(result.rows[0].stationid);
                    $('#roomname').html(result.rows[0].roomname);
                    $('#housestructure').html(result.rows[0].housestructure);
                    $('#pointtype').html(result.rows[0].pointtype);
                    $('#pointcategory').html(result.rows[0].pointcategory);
                    $('#cityname').html(result.rows[0].cityname);
                    $('#powersupplymode').html(result.rows[0].powersupplymode);
                    $('#hasinvoice').html(result.rows[0].hasinvoice);
                    $('#propertyright').html(result.rows[0].propertyright);
                    $('#energysaving').html(result.rows[0].energysaving);
                    $('#signpost').html(result.rows[0].signpost);
                    $('#loadcurrent').html(result.rows[0].loadcurrent);
                    $('#dcpower').html(result.rows[0].dcpower);
                    $('#acpower').html(result.rows[0].acpower);
                    $('#airconditionnum').html(result.rows[0].airconditionnum);
                    $('#airconditionpower').html(result.rows[0].airconditionpower);
                    $('#hasenergysaving').html(result.rows[0].hasenergysaving);
                    $('#energysavingname').html(result.rows[0].energysavingname);
                    $('#issignpost').html(result.rows[0].issignpost);
                    $('#elecprice').html(result.rows[0].elecprice);
                    $('#paymentcycle').html(result.rows[0].paymentcycle);
                    $('#electype').html(result.rows[0].electype);
                    $('#electriccontract').html(result.rows[0].electriccontract);
                    $('#ammeterno').html(result.rows[0].ammeterno);
                    $('#rate').html(result.rows[0].rate);
                    $('#memo1').html(result.rows[0].memo1);
                    $('#memo2').html(result.rows[0].memo2);
                }
            }, 'json');
        }
    });

</script>
<table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="border-collapse: collapse;" id="detailTable">
   <tr>
            <td class="left_td">局站编码：
            </td>
            <td class="tdinput" style="width:190px;">
                <input type="hidden" id="id" name="id" value="<%=id %>" />
                <span id="stationid"></span>
            </td>
            <td class="left_td">机房名称：
            </td>
            <td class="tdinput" style="width:190px;">
                <span id="roomname"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">房屋结构：
            </td>
            <td class="tdinput">
                <span id="housestructure"></span>
            </td>
            <td class="left_td">网点类型：
            </td>
            <td class="tdinput">
                <span id="pointtype"></span>
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
                <div id="powersupplymode"></div>
            </td>
             <td class="left_td">是否提供发票：
            </td>
            <td class="tdinput">
                <div id="hasinvoice"></div>
            </td>
        </tr>
        <tr>

            <td class="left_td">产权性质：
            </td>
            <td class="tdinput">
                <span id="propertyright"></span>
            </td>

            <td class="left_td">节能：
            </td>
            <td class="tdinput">
                <span id="energysaving"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">标杆：
            </td>
            <td class="tdinput">
                <span id="signpost"></span>
            </td>
            <td class="left_td">负载电流（直流电流）：
            </td>
            <td class="tdinput">
                <span id="loadcurrent"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">直流设备功率（KW）：
            </td>
            <td class="tdinput">
                <span id="dcpower"></span>
            </td>
            <td class="left_td">交流设备功率（KW）：
            </td>
            <td class="tdinput">
                <span id="acpower"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">机房空调台数：
            </td>
            <td class="tdinput">
                <span id="airconditionnum"></span>
            </td>
            <td class="left_td">机房空调制冷功率累计（KW）：
            </td>
            <td class="tdinput">
                <span id="airconditionpower"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">是否应用节能技术：
            </td>
            <td class="tdinput">
                <span id="hasenergysaving"></span>
            </td>
            <td class="left_td">应用的节能技术名称：
            </td>
            <td class="tdinput">
                <span id="energysavingname"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">是否标杆：
            </td>
            <td class="tdinput">
                <span id="issignpost"></span>
            </td>
            <td class="left_td">单价：
            </td>
            <td class="tdinput">
                <span id="elecprice"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">交费周期：
            </td>
            <td class="tdinput">
                <span id="paymentcycle"></span>
            </td>

            <td class="left_td" valign="top">用电类别：
                  
            </td>
            <td class="tdinput">
                <span id="electype"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">用电合同号：
            </td>
            <td class="tdinput">
                <span id="electriccontract"></span>
            </td>

            <td class="left_td" valign="top">电表户号：
            </td>
            <td class="tdinput">
                <span id="ammeterno"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td" valign="top">倍率：
            </td>
            <td class="tdinput" colspan="3">
                <div id="rate"></div>
            </td>
        </tr>
        <tr>
            <td class="left_td">备注1：
            </td>
            <td class="tdinput" colspan="3">
                <div id="memo1"></div>
            </td>
        </tr>
        <tr>
            <td class="left_td" valign="top">备注2：
                
            </td>
            <td class="tdinput" colspan="3">
                <div id="memo2"></div>
            </td>
        </tr>
</table>
