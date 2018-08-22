<%@ Page Language="C#" %>

<% 
    /** 
     * 专项整治物料库存录入
     *NSP_MaintainMaterial_Stock表操作对话框
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
%>
<script type="text/javascript">
    var onFormSubmit = function ($dialog, $grid) {
        if ($('form').form('validate')) {
            parent.$.messager.confirm('询问', '您确定要提交专项整治物料入库信息？提交后则不能修改！', function (r) {
                if (r) {
                    var url = 'ajax/Srv_NetWorkSpecialProject.ashx/SaveUnitStockInfo';
                    //要post的json数据
                    var postDate = {};
                    //有数据的行编号
                    var rowsNum = 0;
                    //遍历每一行表格
                    $.each($('tr', '#stockList'), function (index) {
                        //剔除标题行
                        if (index > 0) {
                            //获取物料型号的值
                            var typeid = $('input[name="typeid"]', this).val();
                            //剔除物料型号为空的行数据
                            if (typeid != undefined && typeid.trim().length > 0) {
                                rowsNum++;
                                //遍历每一行要提交的数据
                                $.each($(':input', this).serializeArray(), function (i) {
                                    //设置要提交的键/值对
                                    postDate[this['name'] + rowsNum] = encodeURIComponent(this['value']);
                                });
                            }
                        }
                    })
                    //插入总数据行数
                    postDate['rowsCount'] = rowsNum;
                    //插入领料日期
                    postDate['llrq'] = $('#llrq').val();
                    //插入领料单位
                    postDate['unitname'] = encodeURIComponent($('#unitname').val());
                    //插入备注
                    postDate['memo'] = encodeURIComponent($('input[name="memo"]').val());
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
            });
        }
    };
    var setUnits = function (index, id) {
        $.post('ajax/Srv_NetWorkSpecialProject.ashx/GetTypeInfoByID', {
            id: id
        }, function (result) {
            if (result.rows[0] && result.rows[0].id != undefined) {
                $('#units' + index).html(result.rows[0].units);
            }
            else {
                parent.$.messager.alert('提示', result.msg, 'error');
            }
        }, 'json');

    };
    var addStock = function () {
        var index = $('#index').val();
        index++;
        var insertEle = $('<tr align="center"><td><input type="text" name="storeorderno" class="inputBorder easyui-validatebox" style="width: 160px" data-options="required:true" /></td><td><select id="classname" class="combo easyui-combobox" name="classname" style="width: 100px;" data-options="panelHeight:\'auto\',editable: false,required:true,onSelect:function(rec){ var url = \'../ajax/Srv_NetWorkSpecialProject.ashx/GetNSP_MaintainMaterial_TypeInfoComboboxForIn?classname=\'+encodeURIComponent(rec.value);$(\'#typeid' + index + '\').combobox(\'setValue\',\'\').combobox(\'reload\', url); }"> <option value=""></option><option>光缆</option><option>电力电缆</option><option>双绞线</option><option>光跳纤</option><option>光缆接头盒</option><option>分光器</option><option>电杆</option><option>井盖</option><option>铁件</option><option>工器具</option><option>其他</option></select></td><td><input type="text" name="typeid" id="typeid' + index + '" style="width: 280px;" class="combo easyui-combobox" data-options="valueField: \'id\',textField: \'text\',editable: true,panelHeight: \'200\',required:true,url: \'ajax/Srv_NetWorkSpecialProject.ashx/GetTypeInfoCombobox\',onSelect:function(rec){setUnits(' + index + ',rec.id);},filter: function (q, row) {var opts = $(this).combobox(\'options\');return row[opts.textField].indexOf(q) > -1;},onHidePanel: function () {var valueField = $(this).combobox(\'options\').valueField;var val = $(this).combobox(\'getValue\');var allData = $(this).combobox(\'getData\');var result = true;for (var i = 0; i < allData.length; i++) {if (val == allData[i][valueField]) {result = false;}} if (result) {$(this).combobox(\'clear\');}}" /></td><td><input type="text" name="amount" class="inputBorder easyui-numberbox" style="width: 60px" data-options="min:0,required:true" /></td><td><input type="text" name="price" class="inputBorder easyui-numberbox" style="width: 60px" data-options="min:0,precision:2,required:true" /></td><td><label id="units' + index + '"></label></td><td><img src="../../Script/easyui/themes/icons/edit_remove.png" onclick="delStock(this);" style="cursor: pointer;" /></td></tr>').insertBefore($('#memoTr'));
        $('#index').val(index);
        $.parser.parse(insertEle);
    };
    var delStock = function (obj) {
        $(obj).parent().parent().remove();
    };
    $(function () {
        ////初始化型号下拉框
        //var options = $('input[name="typeid"]').combobox({
        //    editable: true
        //});
        //console.log(options);
    });
</script>
<form method="post">
    <input type="hidden" id="index" value="1">
    <table class="doc-table" id="stockList">
        <caption style="font-size: 14px; line-height: 35px; font-weight: 700;">
            专项整治物料库存录入
        </caption>
        <tr>
            <td style="text-align: left" colspan="7">入库日期：
                 <input style="width: 120px;" name="llrq" id="llrq" class="easyui-validatebox Wdate" onfocus="WdatePicker({isShowClear:false,readOnly:true})" required />
                入库单位：<input style="width: 120px;" name="unitname" id="unitname" class="easyui-validatebox" required readonly value="<%=Session["deptname"] %>" />
            </td>
        </tr>
        <tr>
            <th>商城出库单号：
            </th>
            <th>物料类型：
            </th>
            <th>物料型号：
            </th>
            <th>数量
            </th>
            <th>单价
            </th>
            <th>单位
            </th>
            <th>操作
            </th>
        </tr>
        <tr align="center">
            <td>
                <input type="text" name="storeorderno" class="inputBorder easyui-validatebox" style="width: 160px" data-options="required:true" />
            </td>
            <td>
                 <select id="classname" class="combo easyui-combobox" name="classname" style="width: 100px;" data-options="panelHeight:'auto',editable: false,required:true,onSelect:function(rec){ var url = '../ajax/Srv_NetWorkSpecialProject.ashx/GetNSP_MaintainMaterial_TypeInfoComboboxForIn?classname='+encodeURIComponent(rec.value);$('#typeid1').combobox('setValue','').combobox('reload', url); }">
                            <option value=""></option>
                            <option>光缆</option>
                            <option>电力电缆</option>
                     <option>双绞线</option>
                            <option>光跳纤</option>
                            <option>光缆接头盒</option>
                            <option>分光器</option>
                            <option>电杆</option>
                            <option>井盖</option>
                            <option>铁件</option>
                            <option>工器具</option>
                            <option>其他</option>
                        </select>
            </td>
            <td>
                <input type="text" name="typeid" id="typeid1" style="width: 280px;" class="combo easyui-combobox" data-options="
                    valueField: 'id',
                    textField: 'text',
                    editable: true,
                    panelHeight: '200',
                    required:true,
                    url: 'ajax/Srv_NetWorkSpecialProject.ashx/GetTypeInfoCombobox',
                    onSelect:function(rec){setUnits('1',rec.id);},
                    filter: function (q, row) {
                    var opts = $(this).combobox('options');
                    return row[opts.textField].indexOf(q) > -1;},
                    onHidePanel: function () {
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
                }
                    " />
            </td>
            <td>
                <input type="text" name="amount" class="inputBorder easyui-numberbox" style="width: 60px" data-options="min:0,required:true" />
            </td>
            <td>
                <input type="text" name="price" class="inputBorder easyui-numberbox" style="width: 60px" data-options="min:0,precision:2,required:true" />
            </td>
            <td>
                <label id="units1"></label>
            </td>
            <td>
                <img src="../../Script/easyui/themes/icons/edit_add.png" onclick="addStock();" style="cursor: pointer;" />
            </td>
        </tr>
        <tr id="memoTr">
            <td style="text-align: left" colspan="7">备注：<input type="text" name="memo" value=" " style="width: 600px;" class="inputBorder" /></td>
        </tr>
    </table>
</form>
