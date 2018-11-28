<%@ Page Language="C#" %>

<% 
    /** 
     *建设施工回单
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
        var url = './ajax/Srv_LineResource.ashx/FinishLineResourceByID';
        if ($('form').form('validate')) {
            parent.$.messager.confirm('询问', '确认提交建设信息？', function (r) {
                if (r) {
                    if ($('#isNext').combobox('getValues')=="1" && $('#report').val() == "") {
                        parent.$.messager.alert('提示', '请上传资料后再提交！', 'error');
                        return;
                    }
                    $.post(url, $.serializeObject($('form')), function (result) {
                        if (result.success) {
                            parent.$.messager.alert('提示', result.msg, 'info');
                            $grid.datagrid('reload');
                            $dialog.dialog('close');
                        } else
                            parent.$.messager.alert('提示', result.msg, 'error');
                    }, 'json');
                }
            });
        }
    };
    $(function () {
        //上报施工资料
        var el = $('tr:eq(14)', '#LFTable');
        //退回发起单位
        var backEl = $('tr:eq(13)', '#LFTable');
        if ($('#id').val().length > 0) {
            parent.$.messager.progress({
                text: '数据加载中....'
            });
            $.post('../ajax/Srv_LineResource.ashx/GetLineExtensionByID', {
                ID: $('#id').val()
            }, function (result) {
                parent.$.messager.progress('close');
                if (result.rows[0].id != undefined) {
                    $('#inputtime').html(result.rows[0].inputtime);
                    $('#deptname').html(result.rows[0].deptname);
                    $('#account').html(result.rows[0].account);
                    $('#address').html(result.rows[0].address);
                    $('#boxno').html(result.rows[0].boxno);
                    $('#terminalnumber').html(result.rows[0].terminalnumber);
                    $('#linkman').html(result.rows[0].linkman);
                    $('#linkphone').html(result.rows[0].linkphone);
                    $('#username').html(result.rows[0].username);
                    $('#memo').html(result.rows[0].memo);
                    $('#checkuser').html(result.rows[0].checkuser);
                    $('#checkinfo').html(result.rows[0].checkinfo);
                    $('#checktime').html(result.rows[0].checktime);
                    $('#constructionunit').html(result.rows[0].constructionunit);
                }
            }, 'json');
        }
        //默认隐藏退回信息
        backEl.detach();
        el.hide();
        $('#isNext').combobox({
            editable: false,
            onSelect: function (rec) {
                if (rec.value == '1') {
                    el.show();
                    backEl.insertAfter($('tr:eq(12)', '#LFTable'));
                    $.parser.parse(backEl);
                }
                else {
                    backEl.insertAfter($('tr:eq(12)', '#LFTable'));
                    $.parser.parse(backEl);
                    el.hide();
                }

            }
        });
        //初始化上传插件
        $("#file_upload").uploadify({
            //开启调试
            'debug': false,
            //是否自动上传
            'auto': false,
            //上传成功后是否在列表中删除
            'removeCompleted': false,
            //在文件上传时需要一同提交的数据
            'formData': { 'floderName': 'LineResourceManager' },
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
            'fileTypeExts': '*.xls;*.xlsx',
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
<style>
    #LFTable td {
        padding: 7px 2px;
    }

    #LFTable .tdinput {
        text-align: left;
    }

    #LFTable .left_td {
        text-align: right;
        background: #fafafa;
        width: 100px;
    }
</style>
<form method="post">
    <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="border-collapse: collapse;" class="table table-bordered table-condensed" style="margin-bottom: 0;" id="LFTable">
        <tr>
            <td colspan="4" style="text-align: center; line-height: 30px; font-size: 16px; font-weight: 700;">光缆延伸需求单</td>

        </tr>
        <tr>
            <td class="left_td">日期：
            </td>
            <td class="tdinput" style="width: 180px;">
                <input type="hidden" value="<%=id %>" name="id" id="id" />
                <span id="inputtime"></span>
            </td>
            <td class="left_td">单位：
            </td>
            <td class="tdinput" style="width: 180px;">
                <span id="deptname"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">宽带账号：
            </td>
            <td class="tdinput" colspan="3">
                <span id="account"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">标准地址：
            </td>
            <td class="tdinput" colspan="3">
                <span id="address"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">分纤箱号：
            </td>
            <td class="tdinput">
                <span id="boxno"></span>
            </td>
            <td class="left_td">终端数量：
            </td>
            <td class="tdinput">
                <span id="terminalnumber"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">装维经理：
            </td>
            <td class="tdinput">
                <span id="linkman"></span>
            </td>
            <td class="left_td">联系电话：
            </td>
            <td class="tdinput">
                <span id="linkphone"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">工单录入人：
            </td>
            <td class="tdinput" colspan="3">
                <span id="username"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">备注：
            </td>
            <td class="tdinput" colspan="3">
                <span id="memo"></span>
            </td>
        </tr>
        <tr>
            <td colspan="4" style="text-align: center; line-height: 16px; font-size: 14px; font-weight: 700;">资源核查信息</td>
        </tr>
        <tr>

            <td class="left_td">核查人：
            </td>
            <td class="tdinput">
                <span id="checkuser"></span>
            </td>

            <td class="left_td">核查时间：
            </td>
            <td class="tdinput">
                <span id="checktime"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">核查信息：</td>
            <td class="tdinput" colspan="3">
                <div id="checkinfo"></div>
            </td>
        </tr>
        <tr>
            <td colspan="4" style="text-align: center; line-height:16px; font-size: 14px; font-weight: 700;">建设施工信息</td>
        </tr>
        <tr>
            <td class="left_td">施工单位：</td>
            <td class="tdinput">
                <div id="constructionunit"></div>
            </td>

            <td class="left_td">施工完成情况：
            </td>
            <td>
                <select name="isNext" id="isNext" class="easyui-combobox" data-options="required:true,panelHeight:'auto',editable:true">
                    <option></option>
                    <option value="0">退回发起单位</option>
                    <option value="1">建设施工完成</option>
                </select>
            </td>
        </tr>
        <tr>
            <td class="left_td">施工信息：</td>
            <td class="tdinput" colspan="3">
                <textarea name="backinfo" id="backinfo" cols="" style="width: 400px;" class="easyui-validatebox" required rows="2"></textarea>
            </td>
        </tr>
        <tr>
            <td colspan="4" style="padding: 10px;">上传资料：<br />
                <div id="ProjectAttList"></div>
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

