<%@ Page Language="C#" %>

<style type="text/css">
    #resForm td { padding: 7px 2px; }
    #resForm .tdinput { text-align: left;width:160px; }
    #resForm .left_td { text-align: right; background: #fafafa; width: 160px; }
</style>
<% 
    /** 
     *接入网机房动力信息表操作对话框
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
                url = '../ajax/Srv_EnergyConsumption.ashx/SaveAccessStationInfo';
            } else {
                url = '../ajax/Srv_EnergyConsumption.ashx/UpdateAccessStationInfo';
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
            $.post('../ajax/Srv_EnergyConsumption.ashx/GetAccessStationInfoByID', {
                ID: $('#id').val()
            }, function (result) {
                if (result.rows[0].id != undefined) {
                    $('#resForm').form('load', {
                        'stationid': result.rows[0].stationid,
                        'roomname': result.rows[0].roomname,
                        'housestructure': result.rows[0].housestructure,
                        'pointtype': result.rows[0].pointtype,
                        'pointcategory': result.rows[0].pointcategory,
                        'cityname': result.rows[0].cityname,
                        'powersupplymode': result.rows[0].powersupplymode,
                        'hasinvoice': result.rows[0].hasinvoice,
                        'propertyright': result.rows[0].propertyright,
                        'energysaving': result.rows[0].energysaving,
                        'signpost': result.rows[0].signpost,
                        'loadcurrent': result.rows[0].loadcurrent,
                        'dcpower': result.rows[0].dcpower,
                        'acpower': result.rows[0].acpower,
                        'airconditionnum': result.rows[0].airconditionnum,
                        'airconditionpower': result.rows[0].airconditionpower,
                        'hasenergysaving': result.rows[0].hasenergysaving,
                        'energysavingname': result.rows[0].energysavingname,
                        'issignpost': result.rows[0].issignpost,
                        'elecprice': result.rows[0].elecprice,
                        'paymentcycle': result.rows[0].paymentcycle,
                        'electype': result.rows[0].electype,
                        'electriccontract': result.rows[0].electriccontract,
                        'ammeterno': result.rows[0].ammeterno,
                        'rate': result.rows[0].rate,
                        'memo1': result.rows[0].memo1,
                        'memo2': result.rows[0].memo2
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
            <td class="left_td">局站编码：
            </td>
            <td class="tdinput">
                <input type="hidden" id="id" name="id" value="<%=id %>" />
                <input name="stationid" id="stationid" class="inputBorder easyui-validatebox" data-options="required:true" <%=(id!="")?"readonly":"" %>/>
            </td>
            <td class="left_td">机房名称：
            </td>
            <td class="tdinput">
                <input name="roomname" id="roomname" class="inputBorder easyui-validatebox" data-options="required:true" />
            </td>
        </tr>
         <tr>
            <td class="left_td">房屋结构：
            </td>
            <td class="tdinput">
                 <input name="housestructure" id="housestructure" class="inputBorder easyui-validatebox" />
            </td>
            <td class="left_td">网点类型：
            </td>
            <td class="tdinput">
                 <input name="pointtype" id="pointtype" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
        <tr>
            <td class="left_td">网点分类：
            </td>
            <td class="tdinput">
                 <input name="pointcategory" id="pointcategory" class="inputBorder easyui-validatebox" />
            </td>
            <td class="left_td">所属市县：
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
        </tr>
         <tr>
            <td class="left_td">供电方式：
            </td>
            <td class="tdinput">
                 <select id="powersupplymode" class="easyui-combobox" name="powersupplymode" data-options="panelHeight:'auto',editable:false">
                    <option>直供电</option>
                    <option>转供电</option>
                </select>
            </td>
             <td class="left_td">是否提供发票：
            </td>
            <td class="tdinput">
                 <select id="hasinvoice" class="easyui-combobox" name="hasinvoice" data-options="panelHeight:'auto',editable:false">
                    <option>是</option>
                    <option>否</option>
                </select>
            </td>
        </tr>
         <tr>

            <td class="left_td">产权性质：
            </td>
            <td class="tdinput">
                 <input name="propertyright" id="propertyright" class="inputBorder easyui-validatebox" />
            </td>

            <td class="left_td">节能：
            </td>
            <td class="tdinput">
                 <select id="energysaving" class="easyui-combobox" name="energysaving" data-options="panelHeight:'auto',editable:false">
                    <option>节能</option>
                    <option>非节能</option>
                </select>
            </td>
        </tr>
        <tr>
            <td class="left_td">标杆：
            </td>
            <td class="tdinput">
                <select id="signpost" class="easyui-combobox" name="signpost" data-options="panelHeight:'auto',editable:false">
                    <option>标杆</option>
                    <option>非标杆</option>
                </select>
            </td>
            <td class="left_td">负载电流（直流电流）：
            </td>
            <td class="tdinput">
                 <input name="loadcurrent" id="loadcurrent" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
        <tr>
            <td class="left_td">直流设备功率（KW）：
            </td>
            <td class="tdinput">
                 <input name="dcpower" id="dcpower" class="inputBorder easyui-validatebox" />
            </td>
            <td class="left_td">交流设备功率（KW）：
            </td>
            <td class="tdinput">
                 <input name="acpower" id="acpower" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
         <tr>
            <td class="left_td">机房空调台数：
            </td>
            <td class="tdinput">
                 <input name="airconditionnum" id="airconditionnum" class="inputBorder easyui-validatebox" />
            </td>
            <td class="left_td">机房空调制冷功率累计（KW）：
            </td>
            <td class="tdinput">
                <input name="airconditionpower" id="airconditionpower" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
         <tr>
            <td class="left_td">是否应用节能技术：
            </td>
            <td class="tdinput">
                <select id="hasenergysaving" class="easyui-combobox" name="hasenergysaving" data-options="panelHeight:'auto',editable:false">
                    <option>是</option>
                    <option>否</option>
                </select>
            </td>
            <td class="left_td">应用的节能技术名称：
            </td>
            <td class="tdinput">
                <input name="energysavingname" id="energysavingname" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
        <tr>
            <td class="left_td">是否标杆：
            </td>
            <td class="tdinput">
                  <select id="issignpost" class="easyui-combobox" name="issignpost" data-options="panelHeight:'auto',editable:false">
                    <option>是</option>
                    <option>否</option>
                </select>
            </td>
            <td class="left_td">单价：
            </td>
            <td class="tdinput">
                <input name="elecprice" id="elecprice" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
         <tr>
            <td class="left_td">交费周期：
            </td>
            <td class="tdinput">
                <input name="paymentcycle" id="paymentcycle" class="inputBorder easyui-validatebox" />
            </td>

            <td class="left_td" valign="top">用电类别：
                  
            </td>
            <td class="tdinput">
                <select id="electype" class="easyui-combobox" name="electype" data-options="panelHeight:'auto',editable:false">
                    <option>生产用电/非生产用电</option>
                    <option>生产用电</option>
                    <option>非生产用电</option>
                </select>
            </td>
        </tr>
         <tr>
            <td class="left_td">用电合同号：
            </td>
            <td class="tdinput">
                <input name="electriccontract" id="electriccontract" class="inputBorder easyui-validatebox" />
            </td>

            <td class="left_td" valign="top">电表户号：
            </td>
            <td class="tdinput">
                <input name="ammeterno" id="ammeterno" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
        <tr>
            <td class="left_td" valign="top">倍率：
            </td>
            <td class="tdinput" colspan="3">
                <input name="rate" id="rate" class="inputBorder easyui-numberbox" data-options="min:1"/>
            </td>
        </tr>
        <tr>
            <td class="left_td">备注1：
            </td>
            <td class="tdinput" colspan="3">
                <input name="memo1" id="memo1" class="inputBorder easyui-validatebox" style="width: 400px" />
            </td>
        </tr>
        <tr>
            <td class="left_td" valign="top">备注2：
                
            </td>
            <td class="tdinput" colspan="3">
                <input name="memo2" id="memo2" class="inputBorder easyui-validatebox" style="width: 400px" />
            </td>
        </tr>
    </table>
</form>
