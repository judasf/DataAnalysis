<%@ Page Language="C#" %>

<% 
    /** 
     * 专项整治物料调拨
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
                    var url = 'ajax/Srv_NetWorkSpecialProject.ashx/SaveUnitAllotStockInfo';
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
            $.post('../ajax/Srv_NetWorkSpecialProject.ashx/GetMaintainMaterialStockById', {
                ID: $('#id').val()
            }, function (result) {
                if (result.rows[0].id != undefined) {
                    $('#unitname').html(result.rows[0].unitname);
                    $('#storeorderno').html(result.rows[0].storeorderno);
                    $('#classname').html(result.rows[0].classname);
                    $('#typename').html(result.rows[0].typename);
                    $('#amountstr').html(result.rows[0].amount);
                    $('#amount').val(result.rows[0].amount);
                    $('#units').html(result.rows[0].units);
                    //初始化被调拨单位
                    $('#allotunitid').combobox({
                        valueField: 'id',
                        textField: 'text',
                        editable: false,
                        panelHeight: 'auto',
                        required: true,
                        url: 'ajax/Srv_NetWorkSpecialProject.ashx/GetAllotUnitInfoCombobox?id=' + encodeURIComponent(result.rows[0].unitname)
                    });

                }
                parent.$.messager.progress('close');
            }, 'json');
        }
        $("#file_upload").uploadify({
            //开启调试
            'debug': false,
            //是否自动上传
            'auto': false,
            //上传成功后是否在列表中删除
            'removeCompleted': false,
            //在文件上传时需要一同提交的数据
            'formData': { 'floderName': 'NetWorkSpecialProject' },
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
            'queueSizeLimit': 1,
            'uploadLimit': 1,
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
<form method="post" id="allotstockInfo">
    <table class="doc-table">
        <caption style="font-size: 14px; line-height: 35px; font-weight: 700;">
            物料调拨
        </caption>
        <tr>
            <th colspan="2">物料信息</th>
        </tr>
        <tr>
            <td style="text-align: right">单位名称：</td>
            <td>
                <input type="hidden" id="id" name="id" value="<%=id %>" /><span id="unitname"></span></td>
        </tr>
        <tr>
            <td style="text-align: right">商城出库单号：</td>
            <td><span id="storeorderno"></span></td>
        </tr>
        <tr>
            <td style="text-align: right">物料类型：</td>
            <td><span id="classname"></span></td>
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
            <td style="text-align: right">目的单位：</td>
            <td>
                <input id="allotunitid" name="allotunitid" style="width: 140px;" class="combo" />
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
         <tr>
            <td style="text-align: right">调拨单上传：</td>
            <td class="tdinput">
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
