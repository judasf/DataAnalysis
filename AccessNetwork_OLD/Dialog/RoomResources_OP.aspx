<%@ Page Language="C#" %>

<style type="text/css">
    #resForm td { padding: 7px 2px; }
    #resForm .tdinput { text-align: left; }
    #resForm .left_td { text-align: right; background: #fafafa; width: 100px; }
</style>
<% 
    /** 
     *机房资源信息表操作对话框
     * 
     */
    string id = "";
    if (Session["uname"] == null || Session["uname"].ToString() == "")
    {%>
<script type="text/javascript">
    $(function () {
        parent.$.messager.alert('提示', '登陆超时，请重新登陆再进行操作！', 'error', function () {
            parent.location.replace('default.aspx');
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
                url = '../ajax/Srv_AccessNetwork.ashx/SaveRoomResourcesInfo';
            } else {
                url = '../ajax/Srv_AccessNetwork.ashx/UpdateRoomResourcesInfo';
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
            $.post('../ajax/Srv_AccessNetwork.ashx/GetRoomResourcesInfoByID', {
                ID: $('#id').val()
            }, function (result) {
                if (result.rows[0].id != undefined) {
                    $('#resForm').form('load', {
                        'anid': result.rows[0].anid,
                        'roomname': result.rows[0].roomname,
                        'cityname': result.rows[0].cityname,
                        'regionname': result.rows[0].regionname,
                        'anlevel': result.rows[0].anlevel,
                        'address': result.rows[0].address,
                        'pointtype': result.rows[0].pointtype,
                        'longitude': result.rows[0].longitude,
                        'dimension': result.rows[0].dimension,
                        'area': result.rows[0].area,
                        'propertyright': result.rows[0].propertyright,
                        'contractno': result.rows[0].contractno,
                        'contractpriod': result.rows[0].contractpriod,
                        'lessortype': result.rows[0].lessortype,
                        'rentpayment': result.rows[0].rentpayment,
                        'rent': result.rows[0].rent,
                        'lastpaydate': result.rows[0].lastpaydate,
                        'demstatus': result.rows[0].demstatus,
                        'demem': result.rows[0].demem,
                        'roomplan': result.rows[0].roomplan,
                        'roomresistance': result.rows[0].roomresistance,
                        'powersupplymode': result.rows[0].powersupplymode,
                        'electricityprice': result.rows[0].electricityprice,
                        'roomloadcurrent': result.rows[0].roomloadcurrent,
                        'memo1': result.rows[0].memo1,
                        'memo2': result.rows[0].memo2,
                        'memo3': result.rows[0].memo3
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
            <td class="left_td">接入网编号：
            </td>
            <td class="tdinput">
                <input type="hidden" id="id" name="id" value="<%=id %>" />
                <input name="anid" id="anid" class="inputBorder easyui-validatebox" data-options="required:true" />
            </td>
            <td class="left_td">机房名称：
            </td>
            <td class="tdinput">
                <input name="roomname" id="roomname" class="inputBorder easyui-validatebox" data-options="required:true" />
            </td>
        </tr>
        <tr>
            <td class="left_td">所属县市：
            </td>
            <td class="tdinput">
                <select id="cityname" class="easyui-combobox" name="cityname" data-options="panelHeight:'auto',editable:false">
                    <option>安阳市</option>
                    <option>安阳县</option>
                    <option>汤阴县</option>
                    <option>内黄县</option>
                    <option>滑县</option>
                    <option>林州市</option>
                </select>
            </td>
            <td class="left_td">行政区域：
            </td>
            <td class="tdinput">
                <input name="regionname" id="regionname" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
        <tr>
            <td class="left_td">接入网级别：
            </td>
            <td class="tdinput">
                <select id="anlevel" class="easyui-combobox" name="anlevel" data-options="panelHeight:'auto',editable:false">
                    <option>C1</option>
                    <option>C2</option>
                    <option>C3</option>
                </select>
            </td>
            <td class="left_td">网点类型：
            </td>
            <td class="tdinput">
                <select id="pointtype" class="easyui-combobox" name="pointtype" data-options="panelHeight:'auto',editable:false">
                    <option>室内型</option>
                    <option>立柜型</option>
                    <option>壁挂型</option>
                </select>
            </td>
        </tr>

        <tr>
            <td class="left_td">详细地址：
            </td>
            <td class="tdinput" colspan="3">
                <input name="address" id="address" class="inputBorder easyui-validatebox" style="width: 400px" />
            </td>
        </tr>
        <tr>

            <td class="left_td">经度：
            </td>
            <td class="tdinput">
                <input name="longitude" id="longitude" class="inputBorder easyui-validatebox" />
            </td>

            <td class="left_td">纬度：
            </td>
            <td class="tdinput">
                <input name="dimension" id="dimension" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
        <tr>
            <td class="left_td">面积：
            </td>
            <td class="tdinput">
                <input name="area" id="area" class="inputBorder easyui-validatebox" />
            </td>
            <td class="left_td">产权性质：
            </td>
            <td class="tdinput">
                <select id="propertyright" class="easyui-combobox" name="propertyright" data-options="panelHeight:'auto',editable:false">
                    <option>自有</option>
                    <option>租赁</option>
                </select>
            </td>
        </tr>
        <tr>
            <td class="left_td">租赁合同编号：
            </td>
            <td class="tdinput">
                <input name="contractno" id="contractno" class="inputBorder easyui-validatebox" />
            </td>
            <td class="left_td">合同期限（起止时间）：
            </td>
            <td class="tdinput">
                <input name="contractpriod" id="contractpriod" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
        <tr>
            <td class="left_td">租赁合同方：
            </td>
            <td class="tdinput">
                <input name="lessortype" id="lessortype" class="inputBorder easyui-validatebox" />
            </td>
            <td class="left_td">租金付款方式：
            </td>
            <td class="tdinput">
                <input name="rentpayment" id="rentpayment" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
        <tr>
            <td class="left_td">年租金：
            </td>
            <td class="tdinput">
                <input name="rent" id="rent" class="inputBorder easyui-validatebox" />
            </td>
            <td class="left_td">最近一次交费日期：
            </td>
            <td class="tdinput">
                <input name="lastpaydate" id="lastpaydate" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
        <tr>
            <td class="left_td">动环监控：
            </td>
            <td class="tdinput">
                <select id="demstatus" class="easyui-combobox" name="demstatus" data-options="panelHeight:'auto',editable:false,required:true">
                    <option>有</option>
                    <option>无</option>
                </select>
            </td>
            <td class="left_td">动环设备厂家：
            </td>
            <td class="tdinput">
                <input name="demem" id="demem" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
        <tr>
            <td class="left_td">机房平面图：
            </td>
            <td class="tdinput">
                <input name="roomplan" id="roomplan" class="inputBorder easyui-validatebox" />
            </td>

            <td class="left_td" valign="top">机房接地电阻：
                  
            </td>
            <td class="tdinput">
                <input name="roomresistance" id="roomresistance" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
        <tr>
            <td class="left_td">机房供电方式：
            </td>
            <td class="tdinput">
                <select id="powersupplymode" class="easyui-combobox" name="powersupplymode" data-options="panelHeight:'auto',editable:false,required:true">
                    <option>直供电</option>
                    <option>转供电</option>
                </select>
            </td>

            <td class="left_td" valign="top">电费单价：
            </td>
            <td class="tdinput">
                <input name="electricityprice" id="electricityprice" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
        <tr>
            <td class="left_td" valign="top">机房负载电流：
            </td>
            <td class="tdinput" colspan="3">
                <input name="roomloadcurrent" id="roomloadcurrent" class="inputBorder easyui-validatebox" />
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
        <tr>
            <td class="left_td" valign="top">备注3：
                   
            </td>
            <td class="tdinput" colspan="3">
                <input name="memo3" id="memo3" class="inputBorder easyui-validatebox" style="width: 400px" />

            </td>
        </tr>
    </table>
</form>
