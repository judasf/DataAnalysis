<%@ Page Language="C#" %>

<% 
    /** 
     * 客户接入领料信息录入
     *CustomAccess_Stock表操作对话框
     *
     */
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

    string areaid = string.IsNullOrEmpty(Request.QueryString["areaid"]) ? Session["areaid"] != null && Session["areaid"].ToString() != "" ? Session["areaid"].ToString() : "" : Request.QueryString["areaid"].ToString();
    string areaname = string.IsNullOrEmpty(Request.QueryString["areaname"]) ? Session["areaname"] != null && Session["areaname"].ToString() != "" ? Session["areaname"].ToString() : "" : Server.UrlDecode(Request.QueryString["areaname"].ToString());
%>

<script type="text/javascript">
    //得到重复数组
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
            parent.$.messager.confirm('询问', '您确定要提交领料信息？提交后则不能修改！', function (r) {
                if (r) {
                    var url = 'ajax/Srv_CustomAccess.ashx/SaveUnitStockOutInfo';
                    //要post的json数据
                    var postDate = {};
                    //有数据的行编号
                    var rowsNum = 0;
                    // 选择的商城出库单号数组，用来检测是否重复选择同一商城出库单号
                    var orderNoArr = [];
                    var repeatorderNoArr = [];
                    //遍历每一行表格
                    $.each($('tr', '#stockList'), function (index) {
                        //剔除标题行
                        if (index > 0) {
                            //获取每行商城出库单号的值
                            var orderno = $('input[name="storeorderno"]', this).val();
                            //剔除商城出库单号为空的行数据
                            if (orderno != undefined && orderno.trim().length > 0) {
                                //插入商城出库单号数组
                                orderNoArr.push(orderno);
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
                    //插入领料营业部
                    postDate['areaid'] = $('input[name="areaId"]').val();
                    //插入领料人
                    postDate['llr'] = $('#llr').combobox('getText');
                    //插入备注
                    postDate['memo'] = $('input[name="memo"]').val();
                    //判断是否重复选择同一商城出库单号
                    repeatorderNoArr = getRepeatNum(orderNoArr);
                    var canSubmit = true;
                    $.each(repeatorderNoArr, function (i, n) {
                        if (n > 1) {
                            parent.$.messager.alert('提示', '请不要重复选择商城出库单号！', 'error');
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
    //设置当前选择型号物料的商城出库单号、库存和对应的单位
    var setOrderStock = function (index, id, areaid) {
        $('#storeorderno' + index).combogrid({
            url: 'ajax/Srv_CustomAccess.ashx/GetOrderCombogridForStockOut',
            panelWidth: 280,
            panelHeight: 140,
            idField: 'storeorderno', //form提交时的值
            textField: 'storeorderno',
            editable: false,
            pagination: true,
            required: true,
            rownumbers: true,
            queryParams: { typeid: id, areaid: areaid },
            sortName: 'amount',
            sortOrder: 'asc',
            pageSize: 3,
            pageList: [3, 6],
            columns: [[{
                field: 'storeorderno',
                title: '商城出库单号',
                width: 180,
                halign: 'center',
                align: 'center',
                sortable: true
            }, {
                field: 'amount',
                title: '库存',
                width: 60,
                halign: 'center',
                align: 'center',
                sortable: true
            }]],
            onSelect: function (i, row) {
                if (row) {
                    $('#stock' + index).html(row.amount);
                    $('#units' + index).html(row.units);
                    $('#amount' + index).numberbox('setValue', '');
                }
            }
        });
        var g = $('#storeorderno' + index).combogrid('grid');
        g.datagrid('getPager').pagination({ layout: ['first', 'prev', 'links', 'next', 'last'], displayMsg: '' });
    };
    //增加领料列表项
    var addList = function () {
        var index = $('#index').val();
        index++;
        var insertEle = $('<tr align="center"><td><input type="text" id="typeid" name="typeid" style="width: 320px;" class="combo easyui-combobox" data-options="url:\'ajax/Srv_CustomAccess.ashx/GetWlxhComboboxForStockOutByAreaID?areaid=\'+$(\'#areaId\').val(),valueField: \'id\',textField: \'text\',editable: false,panelHeight: \'200\',required:true,onSelect:function(rec){setOrderStock(' + index + ',rec.id,$(\'#areaId\').val());}" /></td> <td><input type="text" id="storeorderno' + index + '" name="storeorderno" style="width: 210px;" /></td><td><input type="text" id="amount' + index + '" name="amount" class="inputBorder easyui-numberbox" style="width: 60px" data-options="min:0,required:true" onblur="checkStock(' + index + ',this);"/></td><td><label id="stock' + index + '"></label></td><td><label id="units' + index + '"></label></td><td><img src="../../Script/easyui/themes/icons/edit_remove.png" onclick="delList(this);" style="cursor: pointer;" /></td></tr>').insertBefore($('#memoTr'));
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
            领料信息录入
        </caption>
        <tr>
            <td style="text-align: left" colspan="6">出库日期：
                 <input style="width: 140px;" name="ckrq" id="ckrq" class="easyui-validatebox Wdate" onfocus="WdatePicker({isShowClear:false,readOnly:true})" required />
                <span style="margin-left: 30px;">领料单位：</span>
                <select id="areaId" name="areaId" style="width: 140px;" class="combo easyui-combobox" data-options="editable:false,panelHeight: 'auto'">
                    <option value="<%=areaid %>"><%=areaname %></option>
                </select>
                <span style="margin-left: 30px;">领 料 人：</span>
                <input type="text" id="llr" name="llr" style="width: 140px;" class="combo easyui-combobox" data-options="
                    url:'ajax/Srv_CustomAccess.ashx/GetPickerComboboxForStockOutByAreaID?areaid='+$('#areaId').val(),
                    valueField: 'id',
                    textField: 'text',
                    editable: true,
                    panelHeight: '200',
                    required:true,
                    filter: function(q, row){  
        var opts = $(this).combobox('options');  
        return row[opts.textField].indexOf(q)>-1;},onHidePanel: function() {
                var valueField = $(this).combobox('options').valueField;
                var val = $(this).combobox('getValue');  //当前combobox的值
                var allData = $(this).combobox('getData');   //获取combobox所有数据
                var result = true;      //为true说明输入的值在下拉框数据中不存在
                for (var i = 0; i < allData.length; i++) {
                    if (val == allData[i][valueField]) {
                        result = false;
                    }
                }
                if (result) {
                    $(this).combobox('clear');
                }
            }" />
            </td>
        </tr>
        <tr>
            <th width="40%">物料型号：
            </th>
            <th>商城出库单号：
            </th>
            <th>领取数量
            </th>
            <th>库存
            </th>
            <th>单位
            </th>
            <th>操作
            </th>
        </tr>
        <tr align="center">
            <td>
                <input type="text" id="typeid" name="typeid" style="width: 320px;" class="combo easyui-combobox" data-options="
                    url:'ajax/Srv_CustomAccess.ashx/GetWlxhComboboxForStockOutByAreaID?areaid='+$('#areaId').val(),
                    valueField: 'id',
                    textField: 'text',
                    editable: false,
                    panelHeight: '200',
                    required:true,
                    onSelect:function(rec){setOrderStock('1',rec.id,$('#areaId').val());}
                   " />
            </td>
            <td>
                <input type="text" id="storeorderno1" name="storeorderno" style="width: 210px;" />
            </td>
            <td>
                <input type="text" id="amount1" name="amount" class="inputBorder easyui-numberbox" style="width: 60px" data-options="min:0,required:true" onblur="checkStock(1,this);" />
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
            <td style="text-align: left" colspan="6">备注：<input type="text" name="memo" value=" " style="width: 400px;" class="inputBorder" /></td>
        </tr>
    </table>
</form>
