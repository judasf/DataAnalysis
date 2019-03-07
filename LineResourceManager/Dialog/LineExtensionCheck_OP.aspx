<%@ Page Language="C#" %>

<% 
    /** 
     *线路资源核查
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
        var url = './ajax/Srv_LineResource.ashx/CheckLineResourceByID';
        if ($('form').form('validate')) {
            parent.$.messager.confirm('询问', '确认提交核查信息？', function (r) {
                if (r) {
                    $.post(url, $.serializeObject($('form')), function (result) {
                        if (result.success) {
                            parent.$.messager.alert('提示', result.msg, 'info');
                            $grid.datagrid('reload');
                            $dialog.dialog('close');
                            ////刷新需求单列表
                            //var tab = window.parent.index_tabs.tabs('getTab', '需求单管理');
                            //if (tab) {
                            //    var panel = tab.panel('panel')
                            //    var frame = panel.find('iframe');
                            //    frame[0].contentWindow.$('#leGrid').datagrid('reload');
                            //}
                        } else
                            parent.$.messager.alert('提示', result.msg, 'error');
                    }, 'json');
                }
            });
        }
    };
    $(function () {
        //指派施工单位
        var el = $('tr:eq(11)', '#LCTable');
        //退回发起单位
        var backEl = $('tr:eq(10)', '#LCTable');
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
                }
            }, 'json');
        }
        //默认隐藏退回信息
        backEl.detach();
        el.detach();
        $('#isNext').combobox({
            editable: false,
            onSelect: function (rec) {
                if (rec.value == '1') {
                    el.insertAfter($('tr:eq(9)', '#LCTable'));
                    backEl.insertAfter($('tr:eq(9)', '#LCTable'));
                    $.parser.parse(backEl);
                    $.parser.parse(el);
                }
                else {
                    backEl.insertAfter($('tr:eq(9)', '#LCTable'));
                    $.parser.parse(backEl);
                    el.detach();
                }

            }
        });
    });
</script>
<style>
    #LCTable td {
        padding: 7px 2px;
    }

    #LCTable .tdinput {
        text-align: left;
    }

    #LCTable .left_td {
        text-align: right;
        background: #fafafa;
        width: 100px;
    }
</style>
<form method="post">
    <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="border-collapse: collapse;" class="table table-bordered table-condensed" style="margin-bottom: 0;" id="LCTable">
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
            <td colspan="4" style="text-align: center; line-height: 20px; font-size: 14px; font-weight: 700;">资源核查</td>
        </tr>
        <tr>
            <td class="left_td">下一环节：
            </td>
            <td colspan="3">
                <select name="isNext" id="isNext" class="easyui-combobox" data-options="required:true,panelHeight:'auto',editable:false">
                    <option></option>
                    <option value="0">退回发起单位</option>
                    <option value="1">送施工单位</option>
                </select>
            </td>
        </tr>
        <tr>
            <td class="left_td">核查信息：</td>
            <td class="tdinput" colspan="3">
                <textarea name="checkinfo" id="checkinfo" cols="" style="width: 400px;" class="easyui-validatebox" required rows="4"></textarea>
            </td>
        </tr>
        <tr>
            <td class="left_td">指派施工单位：
            </td>
            <td colspan="3">
                <select name="constructionunit" id="constructionunit" class="easyui-combobox" style="width: 120px;" data-options="required:true,panelHeight:'auto',editable:false">
                    <option></option>
                    <option>文峰浩翔</option>
                    <option>中通服</option>
                    <option>北关浩翔</option>
                </select>
            </td>
        </tr>
    </table>
</form>

