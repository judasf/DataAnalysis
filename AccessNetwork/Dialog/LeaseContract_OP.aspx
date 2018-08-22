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
     *机房租赁台账操作对话框
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
                url = '../ajax/Srv_AccessNetwork.ashx/SaveLeaseContractInfo';
            } else {
                url = '../ajax/Srv_AccessNetwork.ashx/UpdateLeaseContractInfo';
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
            $.post('../ajax/Srv_AccessNetwork.ashx/GetLeaseContractfoByID', {
                ID: $('#id').val()
            }, function (result) {
                if (result.rows[0].id != undefined) {
                    $('#resForm').form('load', {
                        'anid': result.rows[0].anid,
                        'roomname': result.rows[0].roomname,
                        'cityname': result.rows[0].cityname,
                        'address': result.rows[0].address,
                        'contractno': result.rows[0].contractno,
                        'contractstart': result.rows[0].contractstart,
                        'contractend': result.rows[0].contractend,
                        'contractor': result.rows[0].contractor,
                        'rent': result.rows[0].rent,
                        'allrent': result.rows[0].allrent,
                        'payclosingdate': result.rows[0].payclosingdate,
                        'lastpaydate': result.rows[0].lastpaydate,
                        'payamount': result.rows[0].payamount,
                        'paymonth': result.rows[0].paymonth,
                        'thispaydate': result.rows[0].thispaydate,
                        'thispayamount': result.rows[0].thispayamount,
                        'otheraccount': result.rows[0].otheraccount,
                        'accountnumber': result.rows[0].accountnumber,
                        'openingbank': result.rows[0].openingbank,
                        'contact': result.rows[0].contact,
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
            <td class="tdinput" style="width:180px;">
                <select id="cityname" class="easyui-combobox" name="cityname" data-options="panelHeight:'auto',editable:false">
                    <option>市区</option>
                    <option>安阳县</option>
                    <option>汤阴县</option>
                    <option>内黄县</option>
                    <option>滑县</option>
                    <option>林州市</option>
                </select>
            </td>
            <td class="left_td">租赁合同编号：
            </td>
            <td class="tdinput" style="width:180px;">
                <input name="contractno" id="contractno" class="inputBorder easyui-validatebox" />
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

            <td class="left_td">合同开始日期：
            </td>
            <td class="tdinput">
                <input name="contractstart" id="contractstart" class="inputBorder easyui-validatebox" />
            </td>
            <td class="left_td">合同截止日期：
            </td>
            <td class="tdinput">
                <input name="contractend" id="contractend" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
        <tr>
            <td class="left_td">租赁合同方：
            </td>
            <td class="tdinput" colspan="3">
                <input name="contractor" id="contractor" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
        <tr>
            <td class="left_td">合同年租金：
            </td>
            <td class="tdinput">
                <input name="rent" id="rent" class="inputBorder easyui-validatebox" />
            </td>
            <td class="left_td">合同总金额：
            </td>
            <td class="tdinput">
                <input name="allrent" id="allrent" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
        <tr>
            <td class="left_td">付款截止日期：
            </td>
            <td class="tdinput">
                <input name="payclosingdate" id="payclosingdate" class="inputBorder easyui-validatebox" />
            </td>

            <td class="left_td">上一年付款日期：
            </td>
            <td class="tdinput">
                <input name="lastpaydate" id="lastpaydate" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
        <tr>
            <td class="left_td">付款总额：
            </td>
            <td class="tdinput">
                <input name="payamount" id="payamount" class="inputBorder easyui-validatebox" />
            </td>

            <td class="left_td">应付款月份：
            </td>
            <td class="tdinput">
                <input name="paymonth" id="paymonth" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
        <tr>
            <td class="left_td">本年付款日期：
                  
            </td>
            <td class="tdinput">
                <input name="thispaydate" id="thispaydate" class="inputBorder easyui-validatebox" />
            </td>

            <td class="left_td">付款总额：
            </td>
            <td class="tdinput">
                <input name="thispayamount" id="thispayamount" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
        <tr>
            <td class="left_td">对方账户：
            </td>
            <td class="tdinput">
                <input name="otheraccount" id="otheraccount" class="inputBorder easyui-validatebox" />
            </td>

            <td class="left_td">对方账号：
            </td>
            <td class="tdinput">
                <input name="accountnumber" id="accountnumber" class="inputBorder easyui-validatebox" />
            </td>
        </tr>
        <tr>
            <td class="left_td">对方开户行：
            </td>
            <td class="tdinput">
                <input name="openingbank" id="openingbank" class="inputBorder easyui-validatebox" />
            </td>

            <td class="left_td">联系方式：
            </td>
            <td class="tdinput">
                <input name="contact" id="contact" class="inputBorder easyui-validatebox" />
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
            <td class="left_td" valign="top">票据类型：
                   
            </td>
            <td class="tdinput" colspan="3">
                <input name="memo4" id="memo4" class="inputBorder easyui-validatebox" style="width: 400px" />

            </td>
        </tr>
    </table>
</form>
