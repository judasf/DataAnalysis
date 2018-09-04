<%@ Page Language="C#" %>

<style type="text/css">
    #resForm td {
        padding: 7px 2px;
    }

    #resForm .tdinput {
        text-align: left;
    }

    #resForm .left_td {
        text-align: right;
        background: #fafafa;
        width: 100px;
    }
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
                        'pointtype': result.rows[0].pointtype,
                        'address': result.rows[0].address,
                        'eqtype': result.rows[0].eqtype,
                        'longitude': result.rows[0].longitude,
                        'dimension': result.rows[0].dimension,
                        'area': result.rows[0].area,
                        'propertyright': result.rows[0].propertyright,
                        'demstatus': result.rows[0].demstatus,
                        'demem': result.rows[0].demem,
                        'roomresistance': result.rows[0].roomresistance,
                        'powersupplymode': result.rows[0].powersupplymode,
                        'roomloadcurrent': result.rows[0].roomloadcurrent,
                        'memo1': result.rows[0].memo1,
                        'memo2': result.rows[0].memo2,
                        'memo3': result.rows[0].memo3,
                        'memo4': result.rows[0].memo4
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
            <td class="tdinput" colspan="3">
                <input type="hidden" id="id" name="id" value="<%=id %>" />
                <input name="anid" id="anid" class="inputBorder easyui-validatebox" style="width:400px;" data-options="required:true" />
            </td>
            </tr>
        <tr>
            <td class="left_td">局站名称：
            </td>
            <td class="tdinput"  colspan="3">
                <input name="roomname" id="roomname" class="inputBorder easyui-validatebox" style="width:400px;" data-options="required:true" />
            </td>
        </tr>
        <tr>
            <td class="left_td">所属县市：
            </td>
            <td class="tdinput" colspan="3">
                <select id="cityname" class="easyui-combobox" name="cityname" data-options="panelHeight:'auto',editable:false">
                    <option>市区</option>
                    <option>安阳县</option>
                    <option>汤阴县</option>
                    <option>内黄县</option>
                    <option>滑县</option>
                    <option>林州市</option>
                </select>
            </td>
        </tr>
        <tr>
            <td class="left_td">网点类别：
            </td>
            <td class="tdinput" style="width:170px;">
                <select id="pointtype" class="easyui-combobox" name="pointtype" data-options="panelHeight:'auto',editable:false">
                    <option>支局</option>
                    <option>基站</option>
                    <option>综合接入点</option>
                    <option>其他</option>
                </select>
            </td>
            <td class="left_td">设备分类：
            </td>
            <td class="tdinput" style="width:170px;">
                <select id="eqtype" class="easyui-combobox" name="eqtype" data-options="panelHeight:'auto',editable:false">
                    <option>固网+基站</option>
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
            <td class="left_td" valign="top">机房接地电阻：
            </td>
            <td class="tdinput" colspan="3">
                <input name="roomresistance" id="roomresistance" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
        <tr>
            <td class="left_td">供电方式：
            </td>
            <td class="tdinput">
                <select id="powersupplymode" class="easyui-combobox" name="powersupplymode" data-options="panelHeight:'auto',editable:false,required:true">
                    <option>直供电</option>
                    <option>转供电</option>
                </select>
            </td>
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
        <tr>
            <td class="left_td" valign="top">备注4：
            </td>
            <td class="tdinput" colspan="3">
                <input name="memo4" id="memo4" class="inputBorder easyui-validatebox" style="width: 400px" />

            </td>
        </tr>
    </table>
</form>
