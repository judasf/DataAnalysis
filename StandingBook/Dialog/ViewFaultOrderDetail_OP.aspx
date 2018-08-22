<%@ Page Language="C#" %>

<style type="text/css">
    #detailTable td {
        padding: 7px 2px;
    }

    #detailTable .tdinput {
        text-align: left;
    }

    #detailTable .left_td {
        text-align: right;
        background: #fafafa;
        width: 100px;
    }
</style>
<% 
    /** 
     *查看日常维修台账详情
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
    var showOrderList = function (filename, filepath, no) {
        /// <summary>显示故障确认单，维修前照片</summary>
        $('#orderList').empty();
        $('#orderList').append('<span style="margin-right:10px;"><a class="ext-icon-attach" style="padding-left:20px;" href="' + filepath + '"  title="' + filename + '">' + filename + '</a></span>');
        //获取维修前前照片
        $.post('../ajax/Srv_StandingBook.ashx/GetAttachmentByAutoNo', { no: no }, function (fileRes) {
            if (fileRes.total > 0) {
                $.each(fileRes.rows, function (i, item) {
                    $('#photoList').append('<span style="margin-right:10px;float:left;"><a class="ext-icon-attach" style="padding-left:20px;" href="' + item.filepath + '"   title="' + item.filename + '">' + item.filename + '</a></span>');
                });
            }
        }, 'json');
        //故障确认单展示插件
        $('#orderList').magnificPopup({
            delegate: 'a',
            type: 'image',
            tLoading: 'Loading image #%curr%...',
            mainClass: 'mfp-img-mobile',
            gallery: {
                enabled: true,
                navigateByImgClick: true,
                preload: [0, 1] // Will preload 0 - before current, and 1 after the current image
            },
            image: {
                tError: '<a href="%url%">The image #%curr%</a> could not be loaded.',
                titleSrc: function (item) {
                    return item.el.attr('title') + '<small> 故障确认单 </small>';
                }
            }
        });
        //维修过程照片展示插件
        $('#photoList').magnificPopup({
            delegate: 'a',
            type: 'image',
            tLoading: 'Loading image #%curr%...',
            mainClass: 'mfp-img-mobile',
            gallery: {
                enabled: true,
                navigateByImgClick: true,
                preload: [0, 1] // Will preload 0 - before current, and 1 after the current image
            },
            image: {
                tError: '<a href="%url%">The image #%curr%</a> could not be loaded.',
                titleSrc: function (item) {
                    return item.el.attr('title') + '<small> 维修前照片 </small>';
                }
            }
        });

    };
    $(function () {
        if ($('#id').val().length > 0) {
            parent.$.messager.progress({
                text: '数据加载中....'
            });
            $.post('../ajax/Srv_StandingBook.ashx/GetFaultOrderInfoByID', {
                ID: $('#id').val()
            }, function (result) {
                parent.$.messager.progress('close');
                if (result.rows[0].id != undefined) {
                    $('#faultorderno').html(result.rows[0].faultorderno);
                    $('#faultdate').html(result.rows[0].faultdate);
                    $('#stationid').html(result.rows[0].stationid);
                    $('#roomname').html(result.rows[0].roomname);
                    $('#faultplace').html(result.rows[0].faultplace);
                    $('#cityname').html(result.rows[0].cityname);
                    $('#pointtype').html(result.rows[0].pointtype);
                    $('#eqtype').html(result.rows[0].eqtype);
                    $('#eqmodel').html(result.rows[0].eqmodel);
                    $('#faultmsg').html(result.rows[0].faultmsg);
                    $('#inscope').html(result.rows[0].inscope);
                    $('#faultuser').html(result.rows[0].faultuser);
                    $('#confirmuser').html(result.rows[0].confirmuser);
                    $('#memo').html(result.rows[0].memo);
                    showOrderList(result.rows[0].confirmordername, result.rows[0].confirmorderpath, result.rows[0].faultorderno);
                }
            }, 'json');
        }
    });

</script>
<table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="border-collapse: collapse;" id="detailTable">
    <tr>
        <td class="left_td">故障单编号：
        </td>
        <td class="tdinput" style="width: 180px;">
            <span id="faultorderno"></span>
            <input type="hidden" id="id" name="id" value="<%=id %>" />
        </td>
        <td class="left_td">故障日期：
        </td>
        <td class="tdinput" style="width: 180px;">
            <span id="faultdate"></span>
        </td>
    </tr>
    <tr>
        <td class="left_td">局站编码：
        </td>
        <td class="tdinput" colspan="3">
            <span id="stationid"></span>
        </td>
    </tr>
    <tr>
        <td class="left_td">机房名称：
        </td>
        <td class="tdinput" colspan="3">
            <span id="roomname"></span>
        </td>
    </tr>
    <tr>
        <td class="left_td">故障地点：
        </td>
        <td class="tdinput" colspan="3">
            <span id="faultplace"></span>
        </td>
    </tr>
    <tr>
        <td class="left_td">单位：
        </td>
        <td class="tdinput">
            <span id="cityname"></span>
        </td>
        <td class="left_td">网点类别：
        </td>
        <td class="tdinput">
            <span id="pointtype"></span>
        </td>
    </tr>
    <tr>
        <td class="left_td">设备类型：
        </td>
        <td class="tdinput">
            <span id="eqtype"></span>
        </td>
        <td class="left_td">设备型号：
        </td>
        <td class="tdinput">
            <span id="eqmodel"></span>
        </td>
    </tr>
    <tr>
        <td class="left_td">故障现象：
        </td>
        <td class="tdinput" colspan="3">
            <span id="faultmsg"></span>
        </td>
    </tr>
    <tr>
        <td class="left_td">是否外包范围：
        </td>
        <td class="tdinput" colspan="3">
            <span id="inscope"></span>
        </td>
    </tr>
    <tr>

        <td class="left_td">报障人：
        </td>
        <td class="tdinput">
            <span id="faultuser"></span>
        </td>

        <td class="left_td">确认人：
        </td>
        <td class="tdinput">
            <span id="confirmuser"></span>
        </td>
    </tr>
    <tr>
        <td class="left_td">故障确认单：</td>
        <td class="tdinput" colspan="3">
            <div id="orderList"></div>
        </td>
    </tr>
    <tr>
        <td class="left_td">维修前照片：</td>
        <td class="tdinput" colspan="3">
            <div id="photoList"></div>
        </td>
    </tr>
    <tr>
        <td class="left_td">备注：
        </td>
        <td class="tdinput" colspan="3">
            <span id="memo"></span>
        </td>
    </tr>
</table>
