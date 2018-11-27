<%@ Page Language="C#" %>

<style type="text/css">
    #leForm td { padding: 7px 2px; }

    #leForm .tdinput { text-align: left; }

    #leForm .left_td { text-align: right; background: #fafafa; width: 100px; }
</style>
<% 
    /** 
     *线路延伸操作对话框
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
        if ($('#leForm').form('validate')) {
            var url;
            if ($('#id').val().length == 0) {
                url = '../ajax/Srv_LineResource.ashx/SaveLineExtensionInfo';
            } else {
                url = '../ajax/Srv_LineResource.ashx/UpdateFaultOrderInfo';
            }
          
            parent.$.messager.progress({
                title: '提示',
                text: '数据处理中，请稍后....'
            });
            $.post(url, $.serializeObject($('#leForm')), function (result) {
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
 
   
    $(function () {
      
        //if ($('#id').val().length > 0) {
        //    parent.$.messager.progress({
        //        text: '数据加载中....'
        //    });
        //    $.post('../ajax/Srv_LineResource.ashx/GetFaultOrderInfoByID', {
        //        ID: $('#id').val()
        //    }, function (result) {
        //        if (result.rows[0].id != undefined) {
        //            $('#leForm').form('load', {
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


    });

</script>
<form method="post" id="leForm">
    <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="border-collapse: collapse;">
        <tr>
            <td class="left_td">宽带账号：
            </td>
            <td class="tdinput" style="width: 180px;">
                <input name="account" id="account" class="inputBorder" data-options="required:true"/><input type="hidden" id="id" name="id" value="<%=id %>" />
            </td>
        
        </tr>
        <tr>
            <td class="left_td">标准地址：
            </td>
            <td class="tdinput">
                <input name="address" style="width: 400px" id="address" class="inputBorder" data-options="required:true"/>
            </td>
        </tr>
        <tr>
            <td class="left_td">分纤箱号：
            <td class="tdinput" >
                <input name="boxno" style="width: 180px" id="boxno" class="inputBorder easyui-validatebox" data-options="required:true" />
            </td>
            <td class="left_td">终端数量：
            </td>
            <td class="tdinput" >
                <input name="terminalnumber" style="width: 180px" id="terminalnumber" class="inputBorder easyui-validatebox" data-options="required:true" />
            </td>
        </tr>
        <tr>
            <td class="left_td">装维经理：
            <td class="tdinput" >
                <input name="linkman" style="width: 180px" id="linkman" class="inputBorder easyui-validatebox" data-options="required:true" />
            </td>
            <td class="left_td">联系电话：
            </td>
            <td class="tdinput" >
                <input name="linkphone" style="width: 180px" id="linkphone" class="inputBorder easyui-validatebox" data-options="required:true" />
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
