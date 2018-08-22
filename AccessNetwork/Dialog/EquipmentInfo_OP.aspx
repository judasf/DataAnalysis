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
     *设备资源信息表操作对话框
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
                url = '../ajax/Srv_AccessNetwork.ashx/SaveEquipmentInfo';
            } else {
                url = '../ajax/Srv_AccessNetwork.ashx/UpdateEquipmentInfo';
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
        //根据机房名称设置局站编码
        $('#roomname').combogrid({
            //url: 'ajax/Srv_AccessNetwork.ashx/GetStationInfoForCombogridByRoomname',
            panelWidth: 400,
            panelHeight: 200,
            idField: 'roomname', //form提交时的值
            textField: 'roomname',
            mode: 'remote',
            editable: true,
            pagination: true,
            required: true,
            rownumbers: true,
            sortName: 'id',
            sortOrder: 'asc',
            pageSize: 5,
            pageList: [5, 10],
            columns: [[{
                field: 'anid',
                title: '局站编码',
                width: 160,
                halign: 'center',
                align: 'center',
            }, {
                field: 'roomname',
                title: '机房名称',
                width: 200,
                halign: 'center',
                align: 'center',
            }]],
            onShowPanel: function () {
                $('#roomname').combogrid('grid').datagrid('options').url = 'ajax/Srv_AccessNetwork.ashx/GetStationInfoForCombogridByRoomname';
                $('#roomname').combogrid('grid').datagrid('reload');

            },
            onSelect: function (i, row) {
                if (row) {
                    $('#anid').val(row.anid);
                }
            },
            onHidePanel: function () {
                var grid = $(this).combogrid('grid');
                if (!grid.datagrid('getSelected')) {
                    $(this).combogrid('clear');
                    $('#anid').val('');
                }
            }
        });
        var g = $('#roomname').combogrid('grid');
        g.datagrid('getPager').pagination({ layout: ['first', 'prev', 'links', 'next', 'last'], displayMsg: '' });
        //end
        if ($('#id').val().length > 0) {
            parent.$.messager.progress({
                text: '数据加载中....'
            });
            $.post('../ajax/Srv_AccessNetwork.ashx/GetEqInfoByID', {
                ID: $('#id').val()
            }, function (result) {
                if (result.rows[0].id != undefined) {
                    $('#resForm').form('load', {
                        'anid': result.rows[0].anid,
                        'roomname': result.rows[0].roomname,
                        'cityname': result.rows[0].cityname,
                        'eqtype': result.rows[0].eqtype,
                        'mfrs': result.rows[0].mfrs,
                        'model': result.rows[0].model,
                        'enabledate': result.rows[0].enabledate,
                        'capacity1': result.rows[0].capacity1,
                        'capacity2': result.rows[0].capacity2,
                        'capacity3': result.rows[0].capacity3,
                        'capacity4': result.rows[0].capacity4
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
            <td class="left_td">机房名称：
            </td>
            <td class="tdinput" colspan="3">
                <input name="roomname" id="roomname" class="inputBorder" style="width: 400px;" />
            </td>
        </tr>
        <tr>
            <td class="left_td">局站编码：
            </td>
            <td class="tdinput" colspan="3">
                <input type="hidden" id="id" name="id" value="<%=id %>" />
                <input name="anid" id="anid" class="inputBorder easyui-validatebox" readonly style="width: 400px;" data-options="required:true" />
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
            <td class="left_td">设备类型：
            </td>
            <td class="tdinput" style="width:180px;">
                <input name="eqtype" id="eqtype" class="inputBorder easyui-validatebox" />
            </td>
            <td class="left_td">厂家：
            </td>
            <td class="tdinput" style="width:180px;">
                <input name="mfrs" id="mfrs" class="inputBorder easyui-validatebox" />
            </td>


        </tr>
        <tr>
            <td class="left_td">型号：
            </td>
            <td class="tdinput">
                <input name="model" id="model" class="inputBorder easyui-validatebox" />
            </td>
            <td class="left_td">启用日期：
            </td>
            <td class="tdinput">
                <input name="enabledate" id="enabledate" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
        <tr>
            <td class="left_td">容量信息1：
            </td>
            <td class="tdinput">
                <input name="capacity1" id="capacity1" class="inputBorder easyui-validatebox" />
            </td>
            <td class="left_td">容量信息2：
            </td>
            <td class="tdinput">
                <input name="capacity2" id="capacity2" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
        <tr>
            <td class="left_td">容量信息3：
            </td>
            <td class="tdinput">
                <input name="capacity3" id="capacity3" class="inputBorder easyui-validatebox" />
            </td>
            <td class="left_td">容量信息4：
            </td>
            <td class="tdinput">
                <input name="capacity4" id="capacity4" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
    </table>
</form>
