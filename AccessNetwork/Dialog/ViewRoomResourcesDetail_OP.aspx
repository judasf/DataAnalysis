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
                    $('#address').html(result.rows[0].address);
                    $('#eqtype').html(result.rows[0].eqtype);
                    $('#pointtype').html(result.rows[0].pointtype);
                    $('#longitude').html(result.rows[0].longitude);
                    $('#dimension').html(result.rows[0].dimension);
                    $('#area').html(result.rows[0].area);
                    $('#propertyright').html(result.rows[0].propertyright);
                    $('#demstatus').html(result.rows[0].demstatus);
                    $('#demem').html(result.rows[0].demem);
                    $('#powersupplymode').html(result.rows[0].powersupplymode);
                    $('#memo1').html(result.rows[0].memo1);
                    $('#memo2').html(result.rows[0].memo2);
                    $('#memo3').html(result.rows[0].memo3);
                    $('#memo4').html(result.rows[0].memo4);
                }
            }, 'json');
        }
    });

</script>
<table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="border-collapse: collapse;" id="detailTable">
   <tr>
            <td class="left_td">局站编码：
            </td>
            <td class="tdinput"  colspan="3">
                <input type="hidden" id="id" name="id" value="<%=id %>" />
                <span id="anid"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">机房名称：
            </td>
            <td class="tdinput"  colspan="3">
                <span id="roomname"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">所属县市：
            </td>
            <td class="tdinput" style="width:180px;">
                <span id="cityname"></span>
            </td>
          
            <td class="left_td">网点类别：
            </td>
            <td class="tdinput" style="width:180px;">
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
            <td class="left_td">设备分类：
            </td>
            <td class="tdinput" colspan="3">
                <span id="eqtype"></span>
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
            <td class="left_td">机房供电方式：
            </td>
            <td class="tdinput">
                <span id="powersupplymode"></span>
            </td>

          
            <td class="left_td" valign="top">机房负载电流：
            </td>
            <td class="tdinput">
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
     <tr>
            <td class="left_td" valign="top">备注3：
                   
            </td>
            <td class="tdinput" colspan="3">
                <div id="memo4"></div>
            </td>
        </tr>
</table>
