<%@ Page Language="C#" %>

<style type="text/css">
    #resForm td { padding: 7px 2px; }

    #resForm .tdinput { text-align: left; }

    #resForm .left_td { text-align: right; background: #fafafa; width: 100px; }
</style>
<% 
    /** 
     *专项整治故障工单操作对话框
     * 
     */
    string id = "";
    int roleid = -1;
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
        roleid = int.Parse(Session["roleid"].ToString());
    }
%>
<script type="text/javascript">
    var onFormSubmit = function ($dialog, $grid) {
        if ($('#resForm').form('validate')) {
            var url;
            if ($('#id').val().length == 0) {
                url = '../ajax/Srv_NetWorkSpecialProject.ashx/SaveFaultOrderInfo';
            } else {
                url = '../ajax/Srv_NetWorkSpecialProject.ashx/UpdateFaultOrderInfo';
            }
            if ($('#report_order').val() == "") {
                parent.$.messager.alert('提示', '请上传故障确认单扫描件！', 'error');
                return;
            }
            if ($('#report').val() == "") {
                parent.$.messager.alert('提示', '请上传维修前照片！', 'error');
                return;
            }
            parent.$.messager.progress({
                title: '提示',
                text: '数据处理中，请稍后....'
            });
            $.post(url, $.serializeObject($('#resForm')), function (result) {
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
                    $grid.datagrid('load');
                    $dialog.dialog('close');
                } else {
                    parent.$.messager.alert('提示', result.msg, 'error');
                }
            }, 'json');
        }
    };
    var showFileList = function (id, filename, filepath) {
        /// <summary>显示已上传附件</summary>
        /// <param name="pjno" type="String">项目编号</param>
        $('#ProjectAttList').empty();
        $('#ProjectAttList').append('<span style="margin-right:10px;"><a class="ext-icon-attach" style="padding-left:20px;" href="' + filepath + '"   title="' + filename + '">' + filename + '</a><img src="css/images/cross.png" title="删除" onclick="javascript:delPJAttach(' + id + ');"/></span>');
    };
    //删除已上传附件
    var delPJAttach = function (id) {
        parent.$.messager.confirm('询问', '您确定要删除该附件？', function (r) {
            if (r) {
                $.post('../service/Srv_NetWorkSpecialProject.ashx/RemovePJAttachById1', {
                    id: id
                }, function (result) {
                    if (result.success) {
                        showFileList($('#pjno').val());
                    } else {
                        parent.$.messager.alert('提示', result.msg, 'error');
                    }
                }, 'json');
            }
        });
    };
    //生成故障单号
    var getFaultOrderNo = function () {
        parent.$.messager.progress({
            text: '数据加载中....'
        });
        $.post('../ajax/Srv_NetWorkSpecialProject.ashx/GetFaultOrderNo', function (result) {
            if (result.success) {
                $('#faultorderno').val(result.autono);
            }
            else {
                parent.$.messager.alert('提示', '登陆超时，请重新登陆再进行操作！', 'error', function () {
                    window.top.location.replace('../Default.aspx');
                });
            }
            parent.$.messager.progress('close');

        }, 'json');
    };
    $(function () {
        //生成故障单号
        getFaultOrderNo();
        //根据机房名称设置局站编码
        $('#roomname').combogrid({
            //url: 'ajax/Srv_AccessNetwork.ashx/GetStationInfoForCombogridByRoomname',
            panelWidth: 400,
            panelHeight: 200,
            idField: 'roomname', //form提交时的值
            textField: 'roomname',
            mode: 'remote',
            editable: true,
            pagination: true,
            required: true,
            rownumbers: true,
            sortName: 'id',
            sortOrder: 'asc',
            pageSize: 5,
            pageList: [5, 10],
            columns: [[{
                field: 'anid',
                title: '局站编码',
                width: 160,
                halign: 'center',
                align: 'center',
            }, {
                field: 'roomname',
                title: '机房名称',
                width: 200,
                halign: 'center',
                align: 'center',
            }]],
            onShowPanel: function () {
                $('#roomname').combogrid('grid').datagrid('options').url = 'ajax/Srv_AccessNetwork.ashx/GetStationInfoForCombogridByRoomname';
                $('#roomname').combogrid('grid').datagrid('reload');

            },
            onSelect: function (i, row) {
                if (row) {
                    $('#stationid').val(row.anid);
                }
            },
            onHidePanel: function () {
                var grid = $(this).combogrid('grid');
                if (!grid.datagrid('getSelected')) {
                    $(this).combogrid('clear');
                    $('#stationid').val('');
                }
            }
        });
        var g = $('#roomname').combogrid('grid');
        g.datagrid('getPager').pagination({ layout: ['first', 'prev', 'links', 'next', 'last'], displayMsg: '' });
        //end
        //if ($('#id').val().length > 0) {
        //    parent.$.messager.progress({
        //        text: '数据加载中....'
        //    });
        //    $.post('../ajax/Srv_NetWorkSpecialProject.ashx/GetFaultOrderInfoByID', {
        //        ID: $('#id').val()
        //    }, function (result) {
        //        if (result.rows[0].id != undefined) {
        //            $('#resForm').form('load', {
        //                'stationid': result.rows[0].stationid,
        //                'roomname': result.rows[0].roomname,
        //                'cityname': result.rows[0].cityname,
        //                'repairplace': result.rows[0].repairplace,
        //                'pointtype': result.rows[0].pointtype,
        //                'jobplanno': result.rows[0].jobplanno,
        //                'eqtype': result.rows[0].eqtype,
        //                'asssetsno': result.rows[0].asssetsno,
        //                'repairitem': result.rows[0].repairitem,
        //                'repaircontent': result.rows[0].repaircontent,
        //                'reimmoney': result.rows[0].reimmoney,
        //                'reimtime': result.rows[0].reimtime,
        //                'memo1': result.rows[0].memo1,
        //                'memo2': result.rows[0].memo2,
        //                'memo3': result.rows[0].memo3,
        //                'memo4': result.rows[0].memo4
        //            });
        //            showFileList(result.rows[0].id, result.rows[0].attachfile, result.rows[0].attachfilepath);
        //        }
        //        parent.$.messager.progress('close');
        //    }, 'json');
        //}
        //初始化故障确认单上传
        $("#file_upload_order").uploadify({
            //开启调试
            'debug': false,
            //是否自动上传
            'auto': false,
            //上传成功后是否在列表中删除
            'removeCompleted': false,
            //在文件上传时需要一同提交的数据
            'formData': { 'floderName': 'StandingBook' },
            'buttonText': '浏览',
            //flash
            'swf': "Script/uploadify/uploadify.swf?var=" + (new Date()).getTime(),
            //文件选择后的容器ID
            'queueID': 'uploadfileQueue_order',
            'uploader': 'Script/uploadify/uploadify.ashx',
            'width': '75',
            'height': '24',
            'multi': true,
            'fileTypeDesc': '支持的格式：',
            'fileTypeExts': '*.jpg;*.jpeg;*.bmp;*.png;*.gif',
            'fileSizeLimit': '2MB',
            'removeTimeout': 1,
            'queueSizeLimit': 1,
            'uploadLimit': 1,
            'overrideEvents': ['onDialogClose', 'onSelectError', 'onUploadError'],
            'onDialogClose': function (queueData) {
                $('#reportNum_order').val(queueData.queueLength);
            },
            'onCancel': function (file) {
                $('#reportNum_order').val($('#reportNum_order').val() - 1);
            },
            //返回一个错误，选择文件的时候触发
            'onSelectError': function (file, errorCode, errorMsg) {
                switch (errorCode) {
                    case -100:
                        parent.$.messager.alert('出错', '只能上传' + $('#file_upload_order').uploadify('settings', 'queueSizeLimit') + '个附件！', 'error');
                        break;
                    case -110:
                        parent.$.messager.alert('出错', '文件“' + file.name + '”大小超出系统限制的' + $('#file_upload_order').uploadify('settings', 'fileSizeLimit') + '大小！', 'error');
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
                        var fp = $('#report_order').val();
                        if (fp)
                            fp += ',' + result.filepath
                        else
                            fp = result.filepath;
                        $('#report_order').val(fp);
                        $('#reportName_order').val(function () {
                            return ($(this).val().length > 0) ? this.value + ',' + file.name : file.name;
                        });
                    }
                    else
                        parent.$.messager.alert('出错', result.msg, 'error');
                }
            }
        });
        //初始化维修前照片上传
        $("#file_upload").uploadify({
            //开启调试
            'debug': false,
            //是否自动上传
            'auto': false,
            //上传成功后是否在列表中删除
            'removeCompleted': false,
            //在文件上传时需要一同提交的数据
            'formData': { 'floderName': 'StandingBook' },
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
            'queueSizeLimit': 5,
            'uploadLimit': 5,
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
<form method="post" id="resForm">
    <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="border-collapse: collapse;">
        <tr>
            <td class="left_td">故障单编号：
            </td>
            <td class="tdinput" style="width: 180px;">
                <input name="faultorderno" id="faultorderno" class="inputBorder" readonly /><input type="hidden" id="id" name="id" value="<%=id %>" />
            </td>
            <td class="left_td">故障日期：
            </td>
            <td class="tdinput" style="width: 180px;">
                <input name="faultdate" id="faultdate" class="easyui-validatebox Wdate" onfocus="WdatePicker({isShowClear:false,readOnly:true})" required />
            </td>
        </tr>
         <tr>
            <td class="left_td">隐患编号：
            </td>
            <td class="tdinput" colspan="3">
                <input name="riskno"  id="riskno" class="inputBorder easyui-validatebox" required />
            </td>
        </tr>
        <tr>
            <td class="left_td">机房名称：
            </td>
            <td class="tdinput" colspan="3">
                <input name="roomname" style="width: 400px" id="roomname" class="inputBorder" />
            </td>
        </tr>
        <tr>
            <td class="left_td">局站编码：
            </td>
            <td class="tdinput" colspan="3">
                <input name="stationid" style="width: 400px" id="stationid" class="inputBorder easyui-validatebox" data-options="required:true" />
            </td>
        </tr>
        <tr>
            <td class="left_td">故障地点：
            </td>
            <td class="tdinput" colspan="3">
                <input name="faultplace" id="faultplace" class="inputBorder easyui-validatebox" style="width: 435px" data-options="required:true" />
            </td>
        </tr>
        <tr>
            <td class="left_td">单位：
            </td>
            <td class="tdinput">
                <select id="cityname" class="easyui-combobox" name="cityname" style="width: 150px;" data-options="panelHeight:'auto',editable:false,required:true">
                    <option></option>
                    <%if (roleid != 4)//除运维部别的单位只能建立本单位的故障工单
                        { %>
                    <option><%=Session["deptname"] %></option>

                    <%}
                        else
                        { %>
                    <option>运行维护部</option>
                    <option>客户支撑中心</option>
                    <option>网络维护中心</option>
                    <option>网络优化中心</option>
                    <option>安阳县</option>
                    <option>汤阴县</option>
                    <option>内黄县</option>
                    <option>滑县</option>
                    <option>林州市</option>
                    <option>创新业务支撑中心</option>
                    <%} %>
                </select>
            </td>
            <td class="left_td">网点类别：
            </td>
            <td class="tdinput">
                <select id="pointtype" class="easyui-combobox" name="pointtype" style="width: 150px;" data-options="panelHeight:'auto',editable:false,required:true">
                    <option></option>
                    <option>支局</option>
                    <option>基站</option>
                    <option>综合接入点</option>
                    <option>其他</option>
                </select>
            </td>
        </tr>
        <tr>
            <td class="left_td">设备类型：
            </td>
            <td class="tdinput">
                <select id="eqtype" class="easyui-combobox" name="eqtype" style="width: 150px;" data-options="panelHeight:'auto',editable:false,required:true">
                    <option></option>
                    <option>光缆线路</option>
                    <option>空调</option>
                    <option>发电机</option>
                    <option>其他</option>
                </select>
            </td>
            <td class="left_td">设备型号：
            </td>
            <td class="tdinput">
                <input name="eqmodel" id="eqmodel" class="inputBorder easyui-validatebox" required />
            </td>
        </tr>
        <tr>
            <td class="left_td">故障现象：
            </td>
            <td class="tdinput" colspan="3">
                <input name="faultmsg" id="faultmsg" style="width: 435px" class=" inputBorder easyui-validatebox" required />
            </td>
        </tr>
        <tr>
            <td class="left_td">是否外包范围：
            </td>
            <td class="tdinput" colspan="3">
                <select id="inscope" class="easyui-combobox" name="inscope" style="width: 150px;" data-options="panelHeight:'auto',editable:false,required:true">
                    <option></option>
                    <option>是</option>
                    <option>否</option>
                </select>
            </td>
        </tr>
        <tr>

            <td class="left_td">报障人：
            </td>
            <td class="tdinput">
                <input name="faultuser" id="faultuser" class="inputBorder easyui-validatebox" required />
            </td>

            <td class="left_td">确认人：
            </td>
            <td class="tdinput">
                <input name="confirmuser" id="confirmuser" class="inputBorder easyui-validatebox" required />
            </td>
        </tr>
        <tr>
            <td class="left_td">故障确认单：</td>
            <td class="tdinput" colspan="3">
                <div id="orderList"></div>
                <input type="hidden" name="report_order" id="report_order" />
                <input type="hidden" name="reportName_order" id="reportName_order" />
                <input type="hidden" name="reportNum_order" id="reportNum_order" value="0" />
                <div class="clearfix">
                    <div id="uploadfileQueue_order" style="width: 370px;">
                    </div>
                    <div style="width: 75px; float: left; text-align: center;">
                        <input id="file_upload_order" name="file_upload_order" type="file" style="text-align: left;" />
                        <div class="uploadify-button" style="height: 24px; cursor: pointer; line-height: 24px; width: 75px;"
                            onclick="$('#file_upload_order').uploadify('upload', '*');">
                            <span class="uploadify-button-text">上传</span>
                        </div>
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td class="left_td">维修前照片：</td>
            <td class="tdinput" colspan="3">
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
        <tr>
            <td class="left_td">备注：
            </td>
            <td class="tdinput" colspan="3">
                <input name="memo" id="memo" class="inputBorder easyui-validatebox" style="width: 435px" />
            </td>
        </tr>
    </table>
</form>
