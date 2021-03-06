﻿<%@ Page Language="C#" %>

<% 
    /** 
     * 运维物料物料领取
     *ReuseMaintainMaterial_StockDraw表操作对话框
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
<%}%>

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
                    var url = 'ajax/Srv_ReuseMaintainMaterial.ashx/SaveReuseStockDrawInfo';
                    //判断领料单上传
                    if ($('#report').val() == "") {
                        parent.$.messager.alert('提示', '请上传领料单照片！', 'error');
                        return;
                    }
                    //要post的json数据
                    var postDate = {};
                    //有数据的行编号
                    var rowsNum = 0;
                    // 选择的利旧物料编号数组，用来检测是否重复选择同一利旧物料编号
                    var orderNoArr = [];
                    var repeatorderNoArr = [];
                    //遍历每一行表格
                    $.each($('tr', '#stockList'), function (index) {
                        //剔除标题行
                        if (index > 0) {
                            //获取每行利旧物料编号的值
                            var orderno = $('input[name="storeorderno"]', this).val();

                            //剔除利旧物料编号为空的行数据
                            if (orderno != undefined && orderno.trim().length > 0) {
                                //插入利旧物料编号数组
                                orderNoArr.push(orderno);
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
                    postDate['lldw'] = encodeURIComponent($('#lldw').combobox('getText'));
                    //插入领料人
                    postDate['llr'] = encodeURIComponent($('#llr').combobox('getText'));
                    //插入备注
                    postDate['memo'] = encodeURIComponent($('input[name="memo"]').val());
                    //插入领料单照片路径
                    postDate['lldpath'] = $('#report').val();
                    //判断是否重复选择同一利旧物料编号
                    repeatorderNoArr = getRepeatNum(orderNoArr);
                    var canSubmit = true;
                    $.each(repeatorderNoArr, function (i, n) {
                        if (n > 1) {
                            parent.$.messager.alert('提示', '请不要重复选择利旧物料编号！', 'error');
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
    //设置当前选择型号物料的利旧物料编号、库存和对应的单位
    var setOrderStock = function (index, id) {
        $('#storeorderno' + index).combogrid({
            url: 'ajax/Srv_ReuseMaintainMaterial.ashx/GetOrderCombogridForStockOut',
            panelWidth: 280,
            panelHeight: 140,
            idField: 'storeorderno', //form提交时的值
            textField: 'storeorderno',
            editable: false,
            pagination: true,
            required: true,
            rownumbers: true,
            queryParams: { typeid: id },
            sortName: 'amount',
            sortOrder: 'asc',
            pageSize: 3,
            pageList: [3, 6],
            columns: [[{
                field: 'storeorderno',
                title: '利旧物料编号',
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
        var insertEle = $('<tr align="center"><td> <input type="text" class="combo easyui-combobox" name="classname" style="width: 100px;" data-options="url:\'../ajax/Srv_ReuseMaintainMaterial.ashx/GetClassInfoComboboxForStockOut\',valueField: \'id\',textField: \'text\',panelHeight:\'auto\',editable: false,required:true,onSelect:function(rec){ var url = \'../ajax/Srv_ReuseMaintainMaterial.ashx/GetTypeInfoComboboxForStockOut?classname=\'+encodeURIComponent(rec.text);$(\'#typeid' + index + '\').combobox(\'setValue\',\'\').combobox(\'reload\', url); }"/> </td><td><input type="text" id="typeid' + index + '" name="typeid" style="width: 280px;" class="combo easyui-combobox" data-options="valueField: \'id\',textField: \'text\',editable: false,panelHeight: \'200\',required:true,onSelect:function(rec){setOrderStock(' + index + ',rec.id);}" /></td> <td><input type="text" id="storeorderno' + index + '" name="storeorderno" style="width: 160px;" /></td><td><input type="text" id="amount' + index + '" name="amount" class="inputBorder easyui-numberbox" style="width: 50px" data-options="min:0,required:true" onblur="checkStock(' + index + ',this);"/></td><td><label id="stock' + index + '"></label></td><td><label id="units' + index + '"></label></td><td><img src="../../Script/easyui/themes/icons/edit_remove.png" onclick="delList(this);" style="cursor: pointer;" /></td></tr>').insertBefore($('#memoTr'));
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
        //初始化领料单照片上传
        $("#file_upload").uploadify({
            //开启调试
            'debug': false,
            //是否自动上传
            'auto': false,
            //上传成功后是否在列表中删除
            'removeCompleted': false,
            //在文件上传时需要一同提交的数据
            'formData': { 'floderName': 'ReuseMaintainMaterial' },
            'buttonText': '浏览',
            //flash
            'swf': "Script/uploadify/uploadify.swf?var=" + (new Date()).getTime(),
            //文件选择后的容器ID
            'queueID': 'uploadfileQueue',
            'uploader': 'Script/uploadify/uploadify.ashx',
            'width': '75',
            'height': '24',
            'multi': true,
            'fileTypeDesc': '支持的格式：',
            'fileTypeExts': '*.jpg;*.jpeg;*.bmp;*.png;*.gif',
            'fileSizeLimit': '5MB',
            'removeTimeout': 1,
            'queueSizeLimit': 3,
            'uploadLimit': 3,
            'overrideEvents': ['onDialogClose', 'onSelectError', 'onUploadError'],
            'onDialogClose': function (queueData) {
                $('#reportNum').val(queueData.queueLength);
            },
            'onCancel': function (file) {
                $('#reportNum').val($('#reportNum').val() - 1);
            },
            //返回一个错误，选择文件的时候触发
            'onSelectError': function (file, errorCode, errorMsg) {
                switch (errorCode) {
                    case -100:
                        parent.$.messager.alert('出错', '只能上传' + $('#file_upload').uploadify('settings', 'queueSizeLimit') + '个附件！', 'error');
                        break;
                    case -110:
                        parent.$.messager.alert('出错', '文件“' + file.name + '”大小超出系统限制的' + $('#file_upload').uploadify('settings', 'fileSizeLimit') + '大小！', 'error');
                        break;
                    case -120:
                        parent.$.messager.alert('出错', '文件“' + file.name + '”大小异常！', 'error');
                        break;
                    case -130:
                        parent.$.messager.alert('出错', '文件“' + file.name + '”类型不正确，请选择文件格式！', 'error');
                        break;
                }
            },
            //返回一个错误，文件上传出错的时候触发
            'onUploadError': function (file, errorCode, errorMsg) {
                switch (errorCode) {
                    case -200:
                        parent.$.messager.alert('出错', '网络错误请重试,错误代码：' + errorMsg, 'error');
                        break;
                    case -210:
                        parent.$.messager.alert('出错', '上传地址不存在，请检查！', 'error');
                        break;
                    case -220:
                        parent.$.messager.alert('出错', '系统IO错误！', 'error');
                        break;
                    case -230:
                        parent.$.messager.alert('出错', '系统安全错误！', 'error');
                        break;
                    case -240:
                        parent.$.messager.alert('出错', '请检查文件格式！', 'error');
                        break;
                }
            },
            //检测FLASH失败调用
            'onFallback': function () {
                parent.$.messager.alert('出错', '您未安装FLASH控件，无法上传！请安装FLASH控件后再试!', 'error');
            },
            //上传到服务器，服务器返回相应信息到data里
            'onUploadSuccess': function (file, data, response) {
                if (data) {
                    var result = $.parseJSON(data);
                    if (result.success) {
                        var fp = $('#report').val();
                        if (fp)
                            fp += ',' + result.filepath
                        else
                            fp = result.filepath;
                        $('#report').val(fp);
                        $('#reportName').val(function () {
                            return ($(this).val().length > 0) ? this.value + ',' + file.name : file.name;
                        });
                    }
                    else
                        parent.$.messager.alert('出错', result.msg, 'error');
                }
            }
        });
    });
</script>
<form method="post">
    <input type="hidden" id="index" value="1">
    <table class="doc-table" id="stockList">
        <caption style="font-size: 14px; line-height: 35px; font-weight: 700;">
            领料信息录入
        </caption>
        <tr>
            <td style="text-align: left" colspan="7">领料日期：
                 <input style="width: 80px;" name="llrq" id="llrq" class="easyui-validatebox Wdate" onfocus="WdatePicker({isShowClear:false,readOnly:true})" required />
                <span style="margin-left: 10px;">领料单位：</span>
                <input id="lldw" type="text" name="lldw" style="width: 140px;" class="combo easyui-combobox" data-options="
                    valueField: 'id',
                    textField: 'text',
                    editable: false,
                    required:true,
                    panelHeight: 'auto',
                    url: 'ajax/Srv_ReuseMaintainMaterial.ashx/GetReuseMaintainMaterial_lldwCombobox',
                    onSelect:function(rec){ var url = '../ajax/Srv_ReuseMaintainMaterial.ashx/GetllrComboboxForStockDraw?lldw='+encodeURIComponent(rec.text);$('#llr').combobox('setValue','').combobox('reload', url); }
                      " />
                <span style="margin-left: 10px;">领 料 人：</span>
                <input type="text" id="llr" name="llr" style="width: 120px;" class="combo inputBorder easyui-combobox" data-options="
                    valueField: 'id',
                    textField: 'text',
                    editable: false,
                    panelHeight: 'auto',
                    required:true" />
            </td>
        </tr>
        <tr>
            <th>物料类型
            </th>
            <th>物料型号
            </th>
            <th>利旧物料编号
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
                <%--<select id="classname" class="combo easyui-combobox" name="classname" style="width: 100px;" data-options="panelHeight:'auto',editable: false,required:true,onSelect:function(rec){ var url = '../ajax/Srv_ReuseMaintainMaterial.ashx/GetTypeInfoComboboxForStockOut?classname='+encodeURIComponent(rec.value);$('#typeid1').combobox('setValue','').combobox('reload', url); }">
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
                </select>--%>
                <input type="text" class="combo easyui-combobox" name="classname" style="width: 100px;" data-options="
                    url:'../ajax/Srv_ReuseMaintainMaterial.ashx/GetClassInfoComboboxForStockOut',
                    valueField: 'id',
                    textField: 'text',
                    panelHeight:'auto',
                    editable: false,
                    required:true,
                    onSelect:function(rec){
                     var url = '../ajax/Srv_ReuseMaintainMaterial.ashx/GetTypeInfoComboboxForStockOut?classname='+encodeURIComponent(rec.text);
                    $('#typeid1').combobox('setValue','').combobox('reload', url); 
                    }" />
            </td>
            <td>
                <input type="text" id="typeid1" name="typeid" style="width: 280px;" class="combo easyui-combobox" data-options="
                    valueField: 'id',
                    textField: 'text',
                    editable: false,
                    panelHeight: '200',
                    required:true,
                    onSelect:function(rec){setOrderStock('1',rec.id,$('#areaId').val());}
                   " />
            </td>
            <td>
                <input type="text" id="storeorderno1" name="storeorderno" style="width: 160px;" />
            </td>
            <td>
                <input type="text" id="amount1" name="amount" class="inputBorder easyui-numberbox" style="width: 50px" data-options="min:0,required:true" onblur="checkStock(1,this);" />
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
            <td style="text-align: left" colspan="7">备注：<input type="text" name="memo" value=" " style="width: 400px;" class="inputBorder" /></td>
        </tr>
        <tr>
            <td class="left_td">领料单照片：</td>
            <td class="tdinput" colspan="6">
                <input type="hidden" name="report" id="report" />
                <input type="hidden" name="reportName" id="reportName" />
                <input type="hidden" name="reportNum" id="reportNum" value="0" />
                <div class="clearfix">
                    <div id="uploadfileQueue" style="width: 370px;">
                    </div>
                    <div style="width: 75px; float: left; text-align: center;">
                        <input id="file_upload" name="file_upload" type="file" style="text-align: left;" />
                        <div class="uploadify-button" style="height: 24px; cursor: pointer; line-height: 24px; width: 75px;"
                            onclick="$('#file_upload').uploadify('upload', '*');">
                            <span class="uploadify-button-text">上传</span>
                        </div>
                    </div>
                </div>
            </td>
        </tr>
    </table>
</form>
