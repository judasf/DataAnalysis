<%@ Page Language="C#" %>

<% 
    /** 
     * 物料调拨
     *CustomAccess_Stock表操作对话框
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

    id = string.IsNullOrEmpty(Request.QueryString["id"]) ? "" : Request.QueryString["id"].ToString();
%>

<script type="text/javascript">
    var onFormSubmit = function ($dialog, $grid) {
        if ($('form').form('validate')) {
            parent.$.messager.confirm('询问', '您确定要提交调拨信息？提交后则不能修改！', function (r) {
                if (r) {
                    var url = 'ajax/Srv_CustomAccess.ashx/SaveUnitAllotStockInfo';
                    $.post(url, $.serializeObject($('#allotstockInfo')), function (result) {
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
                            $grid.datagrid('reload');
                            $grid.datagrid('unselectAll');
                            $dialog.dialog('close');
                        } else {
                            parent.$.messager.alert('提示', result.msg, 'error');
                        }
                    }, 'json');
                }
            });
        }
    };
    //检查当前物料库存
    var checkStock = function (obj) {
        //当前库存
        var stock = $('#amount').val();
        if (stock == '') {
            parent.$.messager.alert('提示', '数据有误，请重试！', 'error');
            $(obj).val('');
        }
        else {
            if (parseInt(stock) < parseInt($(obj).val())) {
                parent.$.messager.alert('提示', '当前库存不足，请检查输入！', 'error');
                $(obj).val('');
            }
            if (0 >= parseInt($(obj).val())) {
                parent.$.messager.alert('提示', '调拨数量不能为0，请检查输入！', 'error');
                $(obj).val('');
            }
        }
    }
    $(function () {
        if ($('#id').val().length > 0) {
            parent.$.messager.progress({
                text: '数据加载中....'
            });
            $.post('../ajax/Srv_CustomAccess.ashx/GetCustomAccessUnitStockById', {
                ID: $('#id').val()
            }, function (result) {
                if (result.rows[0].id != undefined) {
                    $('#areaname').html(result.rows[0].areaname);
                    $('#storeorderno').html(result.rows[0].storeorderno);
                    $('#typename').html(result.rows[0].typename);
                    $('#amountstr').html(result.rows[0].amount);
                    $('#amount').val(result.rows[0].amount);
                    $('#units').html(result.rows[0].units);
                    //初始化被调拨营业部
                    $('#areaId').combobox({
                        valueField: 'id',
                        textField: 'text',
                        editable: false,
                        panelHeight: 'auto',
                        required: true,
                        url: 'ajax/Srv_CustomAccess.ashx/GetCustomAccess_AllotUnitAreaCombobox?id=' + result.rows[0].areaid
                    });

                }
                parent.$.messager.progress('close');
            }, 'json');
        }
    });
</script>
<form method="post" id="allotstockInfo">
    <table class="doc-table">
        <caption style="font-size: 14px; line-height: 35px; font-weight: 700;">
            物料调拨
        </caption>
        <tr>
            <th colspan="2">物料信息</th>
        </tr>
        <tr>
            <td style="text-align: right">营业部：</td>
            <td>
                <input type="hidden" id="id" name="id" value="<%=id %>" /><span id="areaname"></span></td>
        </tr>
        <tr>
            <td style="text-align: right">商城出库单号：</td>
            <td><span id="storeorderno"></span></td>
        </tr>
        <tr>
            <td style="text-align: right">物料型号：</td>
            <td><span id="typename"></span></td>
        </tr>
        <tr>
            <td style="text-align: right">当前库存：</td>
            <td><span id="amountstr"></span><span id="units"></span>
                <input type="hidden" id="amount" />
            </td>
        </tr>
        <tr>
            <th colspan="2">调拨信息</th>
        </tr>
        <tr>
            <td style="text-align: right">调拨营业部：</td>
            <td>
                <input id="areaId" name="areaId" style="width: 140px;" class="combo" />
            </td>
        </tr>
        <tr>
            <td style="text-align: right">调拨数量：</td>
            <td>
                <input type="text" id="allotnum" name="allotnum" class="inputBorder easyui-numberbox" style="width: 140px" data-options="min:0,required:true" onblur="checkStock(this);" />
            </td>
        </tr>
        <tr>
            <td style="text-align: right">备注：</td>
            <td>
                <input type="text" name="memo" value=" " style="width: 400px;" class="inputBorder" /></td>
        </tr>
    </table>
</form>
