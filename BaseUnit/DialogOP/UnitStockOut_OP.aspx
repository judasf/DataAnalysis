<%@ Page Language="C#" %>

<% 
/** 
 * 装维片区领料信息
 *KHJR_Stock表操作对话框
 *
 */
%>

<script type="text/javascript">
    //得到重复得分信息
    var getRepeatNum = function (arr) {
        var res = [];
        var ary = arr.sort();
        for (var i = 0; i < ary.length;) {
            var count = 0;
            for (var j = i; j < ary.length; j++) {
                if (ary[i] == ary[j])
                    count++;
            }
            res.push(count);
            i += count;
        }
        return res;
    };
    var onFormSubmit = function ($dialog, $grid) {
        if ($('form').form('validate')) {
            parent.$.messager.confirm('询问', '您确定要提交装维片区领料信息？提交后则不能修改！', function (r) {
                if (r) {
                    var url = 'ajax/Srv_khjr_Stock.ashx/SaveUnitStockOutInfo';
                    //要post的json数据
                    var postDate = {};
                    //有数据的行编号
                    var rowsNum = 0;
                    // 选择的物料型号数组，用来检测是否重复选择同一型号
                    var typeidArr = [];
                    var repeatTypeIDArr = [];
                    //遍历每一行表格
                    $.each($('tr', '#stockList'), function (index) {
                        //剔除标题行
                        if (index > 0) {
                            //获取物料型号的值
                            var typeid = $('input[name="typeid"]', this).val();
                            //剔除物料型号为空的行数据
                            if (typeid != undefined && typeid.trim().length > 0) {
                                //插入物料型号数组
                                typeidArr.push(typeid);
                                rowsNum++;
                                //遍历每一行要提交的数据
                                $.each($(':input', this).serializeArray(), function (i) {
                                    //设置要提交的键/值对
                                    postDate[this['name'] + rowsNum] = this['value'];
                                });
                            }
                        }
                    })
                    //插入总数据行数
                    postDate['rowsCount'] = rowsNum;
                    //插入出库日期
                    postDate['ckrq'] = $('#ckrq').val();
                    //插入领料片区
                    postDate['areaid'] = $('input[name="areaId"]').val();
                    //插入领料人
                    postDate['llr'] = $('#llr').val();
                    //插入备注
                    postDate['memo'] = $('input[name="memo"]').val();
                    //判断是否重复选择同一型号
                    repeatTypeIDArr = getRepeatNum(typeidArr);
                    var canSubmit = true;
                    $.each(repeatTypeIDArr, function (i, n) {
                        if (n > 1) {
                            parent.$.messager.alert('提示', '请不要重复选择物料型号！', 'error');
                            canSubmit = false;
                            return false;
                        }
                    });
                    if (canSubmit) {
                        parent.$.messager.progress({
                            title: '提示',
                            text: '数据提交中，请稍后....'
                        });
                        $.post(url, postDate, function (result) {
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
                }
            });
        }
    };
    //设置当前选择型号的库存和单位
    var setUnitsAndStock = function (index, id) {
        $.post('ajax/Srv_khjr_Stock.ashx/GetCurrentStockByUnitNameAndTypeId', {
            typeid: id
        }, function (result) {
            if (result.rows[0] && result.rows[0].units != undefined) {
                $('#stock' + index).html(result.rows[0].amount);
                $('#units' + index).html(result.rows[0].units);
            }
            else {
                parent.$.messager.alert('提示', result.msg, 'error');
            }
        }, 'json');

    };
    //增加领料列表项
    var addList = function () {
        var index = $('#index').val();
        index++;
        var insertEle = $('<tr align="center"><td><input type="text" name="typeid" style="width: 200px;" class="combo easyui-combobox" data-options="valueField: \'id\',textField: \'text\',editable: false,panelHeight: \'200\',required:true,url: \'ajax/Srv_khjr.ashx/GetWlxhComboboxForStockOut\',onSelect:function(rec){setUnitsAndStock(' + index + ',rec.id);}" /></td><td><input type="text" name="amount" class="inputBorder easyui-numberbox" style="width: 100px" data-options="min:0,required:true" onblur="checkStock(' + index + ',this);"/></td><td><label id="stock' + index + '"></label></td><td><label id="units' + index + '"></label></td><td><img src="../../Script/easyui/themes/icons/edit_remove.png" onclick="delList(this);" style="cursor: pointer;" /></td></tr>').insertBefore($('#memoTr'));
        $('#index').val(index);
        $.parser.parse(insertEle);
    };
    //删除列表项
    var delList = function (obj) {
        $(obj).parent().parent().remove();
    };
    //检查当前物料库存
    var checkStock = function (index, obj) {
        //当前库存
        var stock = $('#stock' + index).html();
        if (stock == '') {
            parent.$.messager.alert('提示', '请选择物料型号！', 'error');
            $(obj).val('');
        }
        else {
            if (parseInt(stock) < parseInt($(obj).val())) {
                parent.$.messager.alert('提示', '物料库存不足，请检查输入！', 'error');
                $(obj).val('');
            }
            if (0 >= parseInt($(obj).val())) {
                parent.$.messager.alert('提示', '领取数量不能为0，请检查输入！', 'error');
                $(obj).val('');
            }
        }
    }
    $(function () {

    });
</script>
<form method="post">
    <input type="hidden" id="index" value="1">
    <table class="doc-table" id="stockList">
        <caption style="font-size: 14px; line-height: 35px; font-weight: 700;">
            装维片区领料信息录入
        </caption>
        <tr>
            <td style="text-align: left" colspan="5">出库日期：
                 <input style="width: 140px;" name="ckrq" id="ckrq" class="easyui-validatebox Wdate" onfocus="WdatePicker({isShowClear:false,readOnly:true})" required />
            </td>
        </tr>
        <tr>
            <td style="text-align: left" colspan="5">领料片区：
               <%if (Session["roleid"].ToString() == "14")
                   { %>

                <select id="areaId" name="areaId" style="width: 140px;" class="combo easyui-combobox">
                    <option value="<%=Session["areaid"] %>"><%=Session["areaname"] %></option>
                </select>
                <%}
                else
                { %>
                <input id="areaId" type="text" name="areaId" style="width: 140px;" class="combo easyui-combobox" data-options="
                    valueField: 'id',
                    textField: 'text',
                    editable: false,
                    required:true,
                    panelHeight: '200',
                    url: 'ajax/Srv_khjr.ashx/GetKHJR_UnitAreaCombobox'
                      " />
                <%} %>
            </td>
        </tr>
        <tr>
            <td style="text-align: left" colspan="5">领 料 人：
                 <input style="width: 140px;" name="llr" id="llr" class="inputBorder easyui-validatebox" required />
            </td>
        </tr>
        <tr>
            <th width="40%">物料型号：
            </th>
            <th width="20%">领取数量
            </th>
            <th width="16%">库存
            </th>
            <th width="11%">单位
            </th>
            <th width="11%">操作
            </th>
        </tr>
        <tr align="center">
            <td>
                <input type="text" name="typeid" style="width: 200px;" class="combo easyui-combobox" data-options="
                    valueField: 'id',
                    textField: 'text',
                    editable: false,
                    panelHeight: '200',
                    required:true,
                    url: 'ajax/Srv_khjr.ashx/GetWlxhComboboxForStockOut',
                    onSelect:function(rec){setUnitsAndStock('1',rec.id);}" />
            </td>
            <td>
                <input type="text" name="amount" class="inputBorder easyui-numberbox" style="width: 100px" data-options="min:0,required:true" onblur="checkStock(1,this);" />
            </td>
            <td>
                <label id="stock1"></label>
            </td>
            <td>
                <label id="units1"></label>
            </td>
            <td>
                <img src="../../Script/easyui/themes/icons/edit_add.png" onclick="addList();" style="cursor: pointer;" />
            </td>
        </tr>
        <tr id="memoTr">
            <td style="text-align: left" colspan="5">备注：<input type="text" name="memo" value=" " style="width: 400px;" class="inputBorder" /></td>
        </tr>
    </table>
</form>
