<%@ Page Language="C#" %>

<style type="text/css">
    #detailTable td { padding: 7px 2px; }
    #detailTable .tdinput { text-align: left; }
    #detailTable .left_td { text-align: right; background: #fafafa; width: 100px; }
</style>
<% 
    /** 
     *查看机房资源详情
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
            $.post('../ajax/Srv_AccessNetwork.ashx/GetRoomResourcesInfoByID', {
                ID: $('#id').val()
            }, function (result) {
                parent.$.messager.progress('close');
                if (result.rows[0].id != undefined) {
                    $('#anid').html(result.rows[0].anid);
                    $('#roomname').html(result.rows[0].roomname);
                    $('#cityname').html(result.rows[0].cityname);
                    $('#regionname').html(result.rows[0].regionname);
                    $('#anlevel').html(result.rows[0].anlevel);
                    $('#address').html(result.rows[0].address);
                    $('#pointtype').html(result.rows[0].pointtype);
                    $('#longitude').html(result.rows[0].longitude);
                    $('#dimension').html(result.rows[0].dimension);
                    $('#area').html(result.rows[0].area);
                    $('#propertyright').html(result.rows[0].propertyright);
                    $('#contractno').html(result.rows[0].contractno);
                    $('#contractpriod').html(result.rows[0].contractpriod);
                    $('#lessortype').html(result.rows[0].lessortype);
                    $('#rentpayment').html(result.rows[0].rentpayment);
                    $('#rent').html(result.rows[0].rent);
                    $('#lastpaydate').html(result.rows[0].lastpaydate);
                    $('#demstatus').html(result.rows[0].demstatus);
                    $('#demem').html(result.rows[0].demem);
                    $('#roomplan').html(result.rows[0].roomplan);
                    $('#roomresistance').html(result.rows[0].roomresistance);
                    $('#powersupplymode').html(result.rows[0].powersupplymode);
                    $('#electricityprice').html(result.rows[0].electricityprice);
                    $('#roomloadcurrent').html(result.rows[0].roomloadcurrent);
                    $('#memo1').html(result.rows[0].memo1);
                    $('#memo2').html(result.rows[0].memo2);
                    $('#memo3').html(result.rows[0].memo3);
                }
            }, 'json');
        }
    });

</script>
<table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="border-collapse: collapse;" id="detailTable">
   <tr>
            <td class="left_td">接入网编号：
            </td>
            <td class="tdinput" style="width:190px;">
                <input type="hidden" id="id" name="id" value="<%=id %>" />
                <span id="anid"></span>
            </td>
            <td class="left_td">机房名称：
            </td>
            <td class="tdinput" style="width:190px;">
                <span id="roomname"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">所属县市：
            </td>
            <td class="tdinput">
                <span id="cityname"></span>
            </td>
            <td class="left_td">行政区域：
            </td>
            <td class="tdinput">
                <span id="regionname"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">接入网级别：
            </td>
            <td class="tdinput">
                <span id="anlevel"></span>
            </td>
            <td class="left_td">网点类型：
            </td>
            <td class="tdinput">
                <span id="pointtype"></span>
            </td>
        </tr>

        <tr>
            <td class="left_td">详细地址：
            </td>
            <td class="tdinput" colspan="3">
                <div id="address"></div>
            </td>
        </tr>
        <tr>

            <td class="left_td">经度：
            </td>
            <td class="tdinput">
                <span id="longitude"></span>
            </td>

            <td class="left_td">纬度：
            </td>
            <td class="tdinput">
                <span id="dimension"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">面积：
            </td>
            <td class="tdinput">
                <span id="area"></span>
            </td>
            <td class="left_td">产权性质：
            </td>
            <td class="tdinput">
                <span id="propertyright"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">租赁合同编号：
            </td>
            <td class="tdinput">
                <span id="contractno"></span>
            </td>
            <td class="left_td">合同期限（起止时间）：
            </td>
            <td class="tdinput">
                <span id="contractpriod"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">租赁合同方：
            </td>
            <td class="tdinput">
                <span id="lessortype"></span>
            </td>
            <td class="left_td">租金付款方式：
            </td>
            <td class="tdinput">
                <span id="rentpayment"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">年租金：
            </td>
            <td class="tdinput">
                <span id="rent"></span>
            </td>
            <td class="left_td">最近一次交费日期：
            </td>
            <td class="tdinput">
                <span id="lastpaydate"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">动环监控：
            </td>
            <td class="tdinput">
                <span id="demstatus"></span>
            </td>
            <td class="left_td">动环设备厂家：
            </td>
            <td class="tdinput">
                <span id="demem"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">机房平面图：
            </td>
            <td class="tdinput">
                <span id="roomplan"></span>
            </td>

            <td class="left_td" valign="top">机房接地电阻：
                  
            </td>
            <td class="tdinput">
                <span id="roomresistance"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">机房供电方式：
            </td>
            <td class="tdinput">
                <span id="powersupplymode"></span>
            </td>

            <td class="left_td" valign="top">电费单价：
            </td>
            <td class="tdinput">
                <span id="electricityprice"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td" valign="top">机房负载电流：
            </td>
            <td class="tdinput" colspan="3">
                <div id="roomloadcurrent"></div>
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
        <tr>
            <td class="left_td" valign="top">备注3：
                   
            </td>
            <td class="tdinput" colspan="3">
                <div id="memo3"></div>
            </td>
        </tr>
</table>
