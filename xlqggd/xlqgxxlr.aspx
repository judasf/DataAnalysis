<%@ Page Language="C#" AutoEventWireup="true" CodeFile="xlqgxxlr.aspx.cs" Inherits="xlqgxxlr" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>迁改事项管理</title>
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
    <script type="text/javascript">
        var chkInput = function () {
            if ($('#lxr').val() == "") {
                parent.$.messager.alert('提示', '请录入联系人！', 'question', function () {
                    $('#lxr').focus();
                });
                return false;
            }
            if ($('#lxdh').val() == "") {
                parent.$.messager.alert('提示', '请录入联系电话！', 'question', function () {
                    $('#lxdh').focus();
                });
                return false;
            }
            if ($('#sy').val() == "") {
                parent.$.messager.alert('提示', '请录入事由！', 'question', function () {
                    $('#sy').focus();
                });
                return false;
            }
            if ($('#ysje').val() == "") {
                parent.$.messager.alert('提示', '请录入预算金额！', 'question', function () {
                    $('#ysje').focus();
                });
                return false;
            }
            //判断是否有附件上传
            if ($('#report').val() == "") {
                parent.$.messager.alert('提示', '请上传迁改现场照片！', 'question');
                return false;
            }
            if (confirm("提交前请确认信息无误！"))
                return true;
            else
                return false;
        };
        $(function () {
            //初始化上传插件
            $("#file_upload").uploadify({
                //开启调试
                'debug': false,
                //是否自动上传
                'auto': false,
                //上传成功后是否在列表中删除
                'removeCompleted': false,
                //在文件上传时需要一同提交的数据
                'formData': { 'floderName': 'xlqggd' },
                'buttonText': '浏览',
                //flash
                'swf': "../Script/uploadify/uploadify.swf?var=" + (new Date()).getTime(),
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
                        }
                        else
                            $.messager.alert('出错', result.msg, 'error');
                    }
                }
            });
        });
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div id="content">
            <p class="sitepath"><b>当前位置：</b>迁改事项处理 > <a href="xlqgxxlr.aspx">迁改信息录入</a> </p>
            <br />
            <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" class="tablewidth">
                <tr style="background-color: #eeeeee; line-height: 30px;">
                    <td colspan="4" align="center">迁改信息录入
                    </td>
                </tr>
                <tr>
                    <td class="tdtitle">编号：
                    </td>
                    <td class="tdinput" id="id" runat="server"></td>
                    <td class="tdtitle" height="30">发生时间：
                    </td>
                    <td class="tdinput" id="fssj" runat="server"></td>
                </tr>
                <tr>
                    <td class="tdtitle" height="30">发生单位：
                    </td>
                    <td class="tdinput" colspan="3" id="fsdw" runat="server" ></td>
                </tr>
                <tr>
                    <td class="tdtitle" height="30">联系人：
                    </td>
                    <td class="tdinput">
                        <asp:TextBox ID="lxr" runat="server" CssClass="inputBorder"></asp:TextBox>
                        <span style="color: #F00;">*</span>
                    </td>
                    <td class="tdtitle">联系电话：
                    </td>
                    <td class="tdinput">
                        <asp:TextBox ID="lxdh" runat="server" CssClass="inputBorder"></asp:TextBox>
                        <span style="color: #F00;">*</span>
                    </td>
                </tr>
                <tr>
                    <td class="tdtitle" height="60">事由：
                    </td>
                    <td class="tdinput" colspan="3">
                        <asp:TextBox ID="sy" runat="server" Rows="4" MaxLength="2000" TextMode="MultiLine"
                            Width="441px"></asp:TextBox>
                        <span style="color: #F00;">*</span>
                    </td>
                </tr>
                <tr>
                    <td class="tdtitle" height="30">预算金额：
                    </td>
                    <td class="tdinput" colspan="3">
                        <asp:TextBox ID="ysje" runat="server" CssClass="inputBorder easyui-numberbox"></asp:TextBox>
                        <span style="color: #F00;">*</span>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right;">现场照片：
                    </td>
                    <td colspan="3">
                        <div id="filesList"></div>
                        <asp:HiddenField ID="report" runat="server" />
                        <asp:HiddenField ID="reportNum" runat="server" Value="0" />
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
                        <asp:Button ID="Button1" runat="server" Text="提交迁改信息" OnClientClick="return chkInput();"
                            OnClick="Button1_Click" />
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
