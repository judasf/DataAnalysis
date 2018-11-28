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
     *查看线路延伸详情
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
    var showReport = function (filename, filepath) {
        /// <summary>显示建设资料详情</summary>
        $('#reportinfo').empty();
        $('#reportinfo').append('<span style="margin-right:10px;"><a class="ext-icon-attach" target="_blank" style="padding-left:20px;" href="' + filepath + '"  title="' + filename + '">' + filename + '</a></span>');
    };
    $(function () {
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
                    $('#status').html(result.rows[0].status);
                    $('#checkuser').html(result.rows[0].checkuser);
                    $('#checkinfo').html(result.rows[0].checkinfo);
                    $('#checktime').html(result.rows[0].checktime);
                    $('#constructionunit').html(result.rows[0].constructionunit);
                    $('#constructioninfo').html(result.rows[0].constructioninfo);
                    $('#finishuser').html(result.rows[0].finishuser);
                    $('#finishtime').html(result.rows[0].finishtime);
                    if (result.rows[0].reportname.length>0)
                        showReport(result.rows[0].reportname, result.rows[0].reportpath);
                }
            }, 'json');
        }
    });

</script>
<table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="border-collapse: collapse;" id="detailTable">
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
        <td class="tdinput" colspan="3">
            <span id="boxno"></span>
        </td>
    </tr>
    <tr>
        <td class="left_td">终端数量：
        </td>
        <td class="tdinput" colspan="3">
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
        <td colspan="4" style="text-align: center; line-height: 20px; font-size: 14px; font-weight: 700;">资源核查信息</td>
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
        <td colspan="4" style="text-align: center; line-height: 20px; font-size: 14px; font-weight: 700;">建设施工信息</td>
    </tr>
    <tr>
        <td class="left_td">施工单位：</td>
        <td class="tdinput" colspan="3">
            <div id="constructionunit"></div>
        </td>
    </tr>
    <tr>
        <td class="left_td">施工信息：
        </td>
        <td class="tdinput" colspan="3">
            <span id="constructioninfo"></span>
        </td>
    </tr>
    <tr>
        <td class="left_td">上报资料：
        </td>
        <td class="tdinput" colspan="3">
            <span id="reportinfo"></span>
        </td>
    </tr>
     <tr>
        <td class="left_td">回单人：</td>
        <td class="tdinput">
            <div id="finishuser"></div>
        </td>
        <td class="left_td">完工时间：</td>
        <td class="tdinput">
            <div id="finishtime"></div>
        </td>
    </tr>
</table>
