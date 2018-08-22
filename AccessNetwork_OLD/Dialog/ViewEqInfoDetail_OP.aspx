<%@ Page Language="C#" %>

<style type="text/css">
    #detailTable td { padding: 7px 2px; }
    #detailTable .tdinput { text-align: left; }
    #detailTable .left_td { text-align: right; background: #fafafa; width: 100px; }
</style>
<% 
    /** 
     *查看设备资源详情
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
            $.post('../ajax/Srv_AccessNetwork.ashx/GetEqInfoByID', {
                ID: $('#id').val()
            }, function (result) {
                parent.$.messager.progress('close');
                if (result.rows[0].id != undefined) {
                    $('#anid').html(result.rows[0].anid);
                    $('#pointname').html(result.rows[0].pointname);
                    $('#cityname').html(result.rows[0].cityname);
                    $('#anlevel').html(result.rows[0].anlevel);
                    $('#rackno').html(result.rows[0].rackno);
                    $('#rackspace').html(result.rows[0].rackspace);
                    $('#frameno').html(result.rows[0].frameno);
                    $('#ipaddr').html(result.rows[0].ipaddr);
                    $('#eqtype').html(result.rows[0].eqtype);
                    $('#mfrs').html(result.rows[0].mfrs);
                    $('#model').html(result.rows[0].model);
                    $('#enabledate').html(result.rows[0].enabledate);
                    $('#capacity1').html(result.rows[0].capacity1);
                    $('#capacity2').html(result.rows[0].capacity2);
                    $('#capacity3').html(result.rows[0].capacity3);
                    $('#capacity4').html(result.rows[0].capacity4);
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
            <td class="left_td">网点名称：
            </td>
            <td class="tdinput" style="width:190px;">
                <span id="pointname"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">所属县市：
            </td>
            <td class="tdinput">
                <span id="cityname"></span>
            </td>
            <td class="left_td">接入网级别：
            </td>
            <td class="tdinput">
                <span id="anlevel"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">机架编号：
            </td>
            <td class="tdinput">
                <span id="rackno"></span>
            </td>
            <td class="left_td">机架空余空间（U单位）：
            </td>
            <td class="tdinput">
                <span id="rackspace"></span>
            </td>
        </tr>
        <tr>

            <td class="left_td">机框号：
            </td>
            <td class="tdinput">
                <span id="frameno"></span>
            </td>
            <td class="left_td">IP地址：
            </td>
            <td class="tdinput">
                <span id="ipaddr"></span>
            </td>
           
        </tr>
        <tr>
             <td class="left_td">设备类型：
            </td>
            <td class="tdinput">
                <span id="eqtype"></span>
            </td>
            <td class="left_td">厂家：
            </td>
            <td class="tdinput">
                <span id="mfrs"></span>
            </td>
          
        </tr>
        <tr>
              <td class="left_td">型号：
            </td>
            <td class="tdinput">
                <span id="model"></span>
            </td>
            <td class="left_td">启用日期：
            </td>
            <td class="tdinput" >
                <span id="enabledate"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">容量信息1：
            </td>
            <td class="tdinput">
                <span id="capacity1"></span>
            </td>
            <td class="left_td">容量信息2：
            </td>
            <td class="tdinput">
                <span id="capacity2"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">容量信息3：
            </td>
            <td class="tdinput">
                <span id="capacity3"></span>
            </td>
            <td class="left_td">容量信息4：
            </td>
            <td class="tdinput">
                <span id="capacity4"></span>
            </td>
        </tr>
</table>
