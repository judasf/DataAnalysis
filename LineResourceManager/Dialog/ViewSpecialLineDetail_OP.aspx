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
     *查看专线客户光缆详情
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
    var showPhotoList = function (id) {
        //获取测试照片
        $.post('../ajax/Srv_LineResource.ashx/GetSPLAttachmentById', { id: id }, function (fileRes) {
            if (fileRes.total > 0) {
                $.each(fileRes.rows, function (i, item) {
                    $('#photoList').append('<span style="margin-right:10px;float:left;"><a class="ext-icon-attach" style="padding-left:20px;" href="' + item.filepath + '"   title="' + item.filename + '">' + item.filename + '</a></span>');
                });
            }
        }, 'json');

        //测试照片展示插件
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
                    return item.el.attr('title') + '<small> 测试照片 </small>';
                }
            }
        });

    };
    $(function () {
        if ($('#id').val().length > 0) {
            parent.$.messager.progress({
                text: '数据加载中....'
            });

            $.post('../ajax/Srv_LineResource.ashx/GetSpecialLineByID', {
                ID: $('#id').val()
            }, function (result) {
                parent.$.messager.progress('close');
                if (result.rows[0].id != undefined) {
                    $('#inputtime').html(result.rows[0].inputtime);
                    $('#bussinesstype').html(result.rows[0].bussinesstype);
                    $('#chargingcode').html(result.rows[0].chargingcode);
                    $('#customername').html(result.rows[0].customername);
                    $('#address').html(result.rows[0].address);
                    $('#customercontact').html(result.rows[0].customercontact);
                    $('#customerphone').html(result.rows[0].customerphone);
                    $('#customermanager').html(result.rows[0].customermanager);
                    $('#direction').html(result.rows[0].direction);
                    $('#route').html(result.rows[0].route);
                    $('#username').html(result.rows[0].username);
                    $('#memo').html(result.rows[0].memo);
                    $('#constructionunit').html(result.rows[0].constructionunit);
                    $('#receiptroute').html(result.rows[0].receiptroute);
                    $('#receiptuser').html(result.rows[0].receiptuser);
                    $('#receipttime').html(result.rows[0].receipttime);
                    $('#linestatus').html(result.rows[0].linestatus);
                    $('#receiptmemo').html(result.rows[0].receiptmemo);
                    $('#removaltime').html(result.rows[0].removaltime);
                    showPhotoList(result.rows[0].id);
                }
            }, 'json');
        }
    });

</script>
<form>
    <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="border-collapse: collapse;" id="detailTable">
        <tr>
            <td colspan="4" style="text-align: center; line-height: 30px; font-size: 16px; font-weight: 700;">专线客户光缆</td>

        </tr>
        <tr>
            <td class="left_td">派单日期：
            </td>
            <td class="tdinput" style="width: 180px;">
                <input type="hidden" value="<%=id %>" name="id" id="id" />
                <span id="inputtime"></span>
            </td>
            <td class="left_td">业务类型：
            </td>
            <td class="tdinput" style="width: 180px;">
                <span id="bussinesstype"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">计费编码：
            </td>
            <td class="tdinput">
                <span id="chargingcode"></span>
            </td>
            <td class="left_td">客户名称：
            </td>
            <td class="tdinput">
                <span id="customername"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">安装地址：
            </td>
            <td class="tdinput" colspan="3">
                <span id="address"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">客户联系人：
            </td>
            <td class="tdinput">
                <span id="customercontact"></span>
            </td>
            <td class="left_td">客户电话：
            </td>
            <td class="tdinput">
                <span id="customerphone"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">联通客户经理：
            </td>
            <td class="tdinput">
                <span id="customermanager"></span>
            </td>
            <td class="left_td">局向：
            </td>
            <td class="tdinput">
                <span id="direction"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">指定路由：
            </td>
            <td class="tdinput" colspan="3">
                <span id="route"></span>
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
            <td colspan="4" style="text-align: center; line-height: 20px; font-size: 14px; font-weight: 700;">回单信息</td>
        </tr>
        <tr>

            <td class="left_td">施工单位：
            </td>
            <td class="tdinput" colspan="3">
                <span id="constructionunit"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">回单路由：</td>
            <td class="tdinput" colspan="3">
                <div id="receiptroute"></div>
            </td>
        </tr>
        <tr>
            <td class="left_td">测试照片：</td>
            <td class="tdinput" colspan="3">
                <div id="photoList"></div>
            </td>
        </tr>
        <tr>
            <td class="left_td">回单人：</td>
            <td class="tdinput">
                <span id="receiptuser"></span>
            </td>
            <td class="left_td">完工时间：</td>
            <td class="tdinput">
                <span id="receipttime"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">线路状态：
            </td>
            <td class="tdinput" colspan="3">
                <span id="linestatus"></span>
            </td>
        </tr>
         <tr>
            <td class="left_td">回单备注：
            </td>
            <td class="tdinput" colspan="3">
                <span id="receiptmemo"></span>
            </td>
        </tr>
         <tr>
            <td class="left_td">拆机时间：
            </td>
            <td class="tdinput" colspan="3">
                <span id="removaltime"></span>
            </td>
        </tr>
    </table>
</form>
