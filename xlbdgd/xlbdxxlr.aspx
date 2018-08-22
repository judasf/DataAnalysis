<%@ Page Language="C#" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>被盗事项管理</title>
    <%--引入My97日期文件--%>
    <script src="../Script/My97DatePicker/WdatePicker.js" type="text/javascript"></script>
    <%--引入Jquery文件--%>
    <script src="../Script/easyui/jquery-1.10.2.min.js" type="text/javascript"></script>
    <script src="../Script/easyui/jquery.easyui.min.js" type="text/javascript"></script>
    <%--引入uploadify文件--%>
    <link rel="stylesheet" type="text/css" href="../Script/uploadify/uploadify.css" />
    <script type="text/javascript" src="../Script/uploadify/jquery.uploadify.js"></script>
    <%--引入easyui文件--%>
    <link href="../Script/easyui/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../Script/easyui/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../Script/easyui/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../Script/extJquery.js" type="text/javascript"></script>
    <script src="../Script/extEasyUI.js" type="text/javascript"></script>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />
    <script>
        //保存
        var onSave = function () {
            if ($('form').form('validate')) {
                var url = '../ajax/Xlbd_Srv.ashx/SaveInfo';
                //判断是否有附件上传
                if ($('#report').val() == "") {
                    parent.$.messager.alert('提示', '请上传被盗现场照片！', 'error');
                    return;
                }
                parent.$.messager.progress({
                    title: '提示',
                    text: '数据处理中，请稍后....'
                });
                $.post(url, $.serializeObject($('form')), function (result) {
                    parent.$.messager.progress('close');
                    if (result.success) {
                        parent.$.messager.alert('提示', result.msg, 'info', function () {
                            location.href = location.href;
                        });
                    } else {
                        parent.$.messager.alert('提示', result.msg, 'error');
                    }
                }, 'json');
            }
        };
        $(function () {
            //获取被盗序号
            parent.$.messager.progress({
                text: '数据加载中....'
            });
            $.post('../ajax/Xlbd_Srv.ashx/GetBDxxAutoID', function (result) {
                if (result.success) {
                    $('#id').val(result.autoid);
                    $('#idStr').html(result.autoid);
                }
                else {
                    parent.$.messager.alert('提示', '登陆超时，请重新登陆再进行操作！', 'error', function () {
                        window.top.location.replace('../Default.aspx');
                    });
                }
                parent.$.messager.progress('close');

            }, 'json');
            //初始化上传插件
            $("#file_upload").uploadify({
                //开启调试
                'debug': false,
                //是否自动上传
                'auto': false,
                //上传成功后是否在列表中删除
                'removeCompleted': false,
                //在文件上传时需要一同提交的数据
                'formData': { 'floderName': 'xlbdgd' },
                'buttonText': '浏览',
                //flash
                'swf': "../Script/uploadify/uploadify.swf",
                //文件选择后的容器ID
                'queueID': 'uploadfileQueue',
                'uploader': '../Script/uploadify/uploadify.ashx',
                'width': '75',
                'height': '24',
                'multi': true,
                'fileTypeDesc': '支持的格式：',
                'fileTypeExts': '*.jpg;*.png;*.gif',
                'fileSizeLimit': '10MB',
                'removeTimeout': 1,
                'queueSizeLimit': 2,
                'uploadLimit': 2,
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
                            parent.$.messager.alert('出错', '文件“' + file.name + '”类型不正确，请选择正确的Excel文件,Word文件或者压缩包文件！', 'error');
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
                    parent.parent.$.messager.alert('出错', '您未安装FLASH控件，无法上传图片！请安装FLASH控件后再试!', 'error');
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
                            $('#reportName').html(file.name);
                            //$('#reportTr').show();
                        }
                        else
                            $.messager.alert('出错', result.msg, 'error');
                    }
                }
                });
        });
    </script>
</head>
<body class="easyui-layout">
    <div data-options="region:'center',fit:true,border:false">
        <div id="content">
            <p class="sitepath">
                <b>当前位置：</b>被盗事项管理 > <a href="xlbdxxlr.aspx">被盗信息录入</a>
            </p>
            <br />
            <form method="post">
                <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" class="tablewidth">
                    <tr style="background-color: #eeeeee; line-height: 30px;">
                        <td colspan="4" align="center">被盗信息录入
                        </td>
                    </tr>
                    <tr>
                        <td class="tdtitle" height="30">序号：
                        </td>
                        <td class="tdinput">
                            <input type="hidden" id="id" name="id" />
                            <span id="idStr"></span>

                        </td>

                        <td class="tdtitle">被盗日期：
                        </td>
                        <td class="tdinput">
                            <input style="width: 120px;" name="bdrq" id="bdrq" class="easyui-validatebox Wdate" onfocus="WdatePicker({isShowClear:false,readOnly:true})" required />

                        </td>
                    </tr>
                    <tr>
                        <td class="tdtitle" height="30">被盗地点：
                        </td>
                        <td class="tdinput" colspan="3">
                            <input id="bddd" name="bddd" class="inputBorder easyui-validatebox " style="width: 398px;" required />
                        </td>
                    </tr>
                    <tr>
                        <td class="tdtitle" height="30">报公安日期：
                        </td>
                        <td class="tdinput">
                            <input style="width: 120px;" name="bgarq" id="bgarq" class="easyui-validatebox Wdate" onfocus="WdatePicker({isShowClear:false,readOnly:true})" />
                        </td>

                        <td class="tdtitle">报保险公司日期：
                        </td>
                        <td class="tdinput">
                            <input style="width: 120px;" name="bbxgsrq" id="bbxgsrq" class="easyui-validatebox Wdate" onfocus="WdatePicker({isShowClear:false,readOnly:true})" />
                        </td>
                    </tr>
                    <tr>
                        <td class="tdtitle" height="30">保险公司是否出现场：</td>
                        <td class="tdinput">
                            <select id="bxgscxc" name="bxgscxc">
                                <option value="否">否</option>
                                <option value="是">是</option>
                            </select>
                        </td>
                        <td class="tdtitle">直接损失金额：</td>
                        <td class="tdinput">
                            <input name="ssje" id="ssje" class="inputBorder easyui-numberbox" style="width: 120px;" data-options="min:0,required:true" />
                        </td>
                    </tr>
                    <tr>
                        <td class="tdtitle" height="60">被盗损失：
                        </td>
                        <td class="tdinput" colspan="3">
                            <textarea name="bdss" style="width: 398px;" id="bdss" rows="4" class="easyui-validatebox"
                                data-options="required:true"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right;">被盗现场照片：
                        </td>
                        <td colspan="3">
                            <div id="filesList"></div>
                            <input type="hidden" name="report" id="report" />
                            <input type="hidden" name="reportNum" id="reportNum" value="0" />
                            <div class="clearfix">
                                <div id="uploadfileQueue" style="float: right; width: 420px;">
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
                    <tr>
                        <td colspan="4" align="center" class="btnp">
                            <input type="button" value="提交被盗信息" onclick="onSave()" />
                        </td>
                    </tr>
                </table>
            </form>
        </div>


    </div>
</body>
</html>
