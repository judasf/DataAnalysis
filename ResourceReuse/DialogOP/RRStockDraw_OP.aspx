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
            parent.$.messager.confirm('询问', '您确定要提交领用信息？', function (r) {
                if (r) {
                    var url = 'ajax/Srv_ResourceReuse.ashx/SaveRRReceiveInfo';
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
                parent.$.messager.alert('提示', '领用数量不能为0，请检查输入！', 'error');
                $(obj).val('');
            }
        }
    }
    $(function () {
        if ($('#id').val().length > 0) {
            parent.$.messager.progress({
                text: '数据加载中....'
            });
            $.post('../ajax/Srv_ResourceReuse.ashx/GetResourceReuseStockById', {
                ID: $('#id').val()
            }, function (result) {
                if (result.rows[0].id != undefined) {
                    $('#unitname').html(result.rows[0].unitname);
                    $('#rrid').html(result.rows[0].rrid);
                    $('#typename').html(result.rows[0].typename);
                    $('#amountstr').html(result.rows[0].currentstock);
                    $('#amount').val(result.rows[0].currentstock);
                    $('#units').html(result.rows[0].units);
                }
                parent.$.messager.progress('close');
            }, 'json');
        }
    });
</script>
<form method="post" id="allotstockInfo">
    <table class="doc-table">
        <caption style="font-size: 14px; line-height: 35px; font-weight: 700;">
            物资领用
        </caption>
        <tr>
            <th colspan="2">资源信息</th>
        </tr>
        <tr>
            <td style="text-align: right">入库单位：</td>
            <td>
                <input type="hidden" id="id" name="id" value="<%=id %>" /><span id="unitname"></span></td>
        </tr>
        <tr>
            <td style="text-align: right">资源编号：</td>
            <td><span id="rrid"></span></td>
        </tr>
        <tr>
            <td style="text-align: right">资源名称：</td>
            <td><span id="typename"></span></td>
        </tr>
        <tr>
            <td style="text-align: right">当前库存：</td>
            <td><span id="amountstr"></span><span id="units"></span>
                <input type="hidden" id="amount" />
            </td>
        </tr>
        <tr>
            <th colspan="2">领用信息</th>
        </tr>
         <tr>
            <td style="text-align: right">领用日期：
            </td>
            <td style="width: 180px;">
                <input name="outdate" id="outdate" class="easyui-validatebox Wdate" style="width: 180px;"onfocus="WdatePicker({isShowClear:false,readOnly:true})" required />
            </td>
        </tr>
        <tr>
            <td style="text-align: right">领用单位：</td>
            <td>
                 <select id="receiveunitname" class="combo easyui-combobox" name="receiveunitname" style="width: 180px;" data-options="panelHeight:'auto',editable: false" required>
                            <option value=""></option>
                            <option>网络管理中心</option>
                            <option>网络优化/客户响应中心</option>
                            <option>安阳县</option>
                            <option>滑县</option>
                            <option>内黄县</option>
                            <option>林州市</option>
                            <option>汤阴县</option>
                        </select>
            </td>
        </tr>
        
        <tr>
            <td style="text-align: right">领用数量：</td>
            <td>
                <input type="text" id="receivenum" name="receivenum" class="inputBorder easyui-numberbox" style="width: 180px" data-options="min:0,required:true" onblur="checkStock(this);" />
            </td>
        </tr>
        <tr>
            <td style="text-align: right">计费编码/签报编号：
            </td>
            <td >
                <input name="signno" id="signno" class="inputBorder easyui-validatebox" style="width: 180px;" data-options="required:true" />
            </td>
        </tr>
         <tr>
            <td style="text-align: right">用途：
            </td>
            <td class="tdinput">
                <textarea name="usefor" style="width: 300px" rows="3" id="usefor" class="easyui-validatebox" required></textarea>
            </td>
        </tr>
         <tr>
            <td style="text-align: right">使用地点：
            </td>
            <td class="tdinput">
                <textarea name="useplace" style="width: 300px" rows="3" id="useplace" class="easyui-validatebox" required></textarea>
            </td>
        </tr>
        <tr>
            <td style="text-align: right">领用人：
            </td>
            <td >
                <input name="receiveman" id="receiveman" class="inputBorder easyui-validatebox" style="width: 180px;" data-options="required:true" />
            </td>
        </tr>
        <tr>
            <td style="text-align: right">联系电话：
            </td>
            <td>
                <input name="receivephone" id="receivephone" style="width: 180px;" class="inputBorder easyui-validatebox" data-options="required:true" />
            </td>
        </tr>
        <tr>
            <td style="text-align: right">备注：</td>
            <td>
                <input type="text" name="memo" value=" " style="width: 400px;" class="inputBorder" /></td>
        </tr>
    </table>
</form>
