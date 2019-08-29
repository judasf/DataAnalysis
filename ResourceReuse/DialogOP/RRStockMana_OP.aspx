<%@ Page Language="C#" %>

<style type="text/css">
    #resForm td { padding: 7px 2px; }

    #resForm .tdinput { text-align: left; }

    #resForm .left_td { text-align: right; background: #fafafa; width: 100px; }
</style>
<% 
    /** 
     *故障工单操作对话框
     * 
     */
    if (Session["uname"] == null || Session["uname"].ToString() == "")
    {%>
<script type="text/javascript">
    $(function () {
        parent.$.messager.alert('提示', '登陆超时，请重新登陆再进行操作！', 'error', function () {
            parent.location.replace('logout.aspx');
        });
    });
</script>
<%}%>
<script type="text/javascript">
    var onFormSubmit = function ($dialog, $grid) {
        if ($('#resForm').form('validate')) {
            var url = '../ajax/Srv_ResourceReuse.ashx/SaveRRStockInfo';
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
        } else {
            console.log($('#typeid1').val());
        }
    };
    $(function () {
        //初始化型号下拉框
        $('#typeid').combobox({
            valueField: 'id',
            textField: 'text',
            editable: true,
            panelHeight: '200',
            url: '../ajax/Srv_ResourceReuse.ashx/GetTypeInfoCombobox',
            filter: function (q, row) {
                var opts = $(this).combobox('options');
                return row[opts.textField].indexOf(q) > -1;
            },
            onHidePanel: function () {
                var valueField = $(this).combobox('options').valueField;
                var val = $(this).combobox('getValue');  //当前combobox的值
                var allData = $(this).combobox('getData');   //获取combobox所有数据
                var result = true;      //为true说明输入的值在下拉框数据中不存在
                for (var i = 0; i < allData.length; i++) {
                    if (val == allData[i][valueField]) {
                        result = false;
                    }
                }
                if (result) {
                    $(this).combobox('clear');
                }
            }

        });
        //初始化所属网格下拉框
        $('#gridid').combobox({
            valueField: 'id',
            textField: 'text',
            editable:false,
            panelHeight: '200',
            url: '../ajax/Srv_ResourceReuse.ashx/GetGridInfoCombobox'
        });

    });
</script>
<form method="post" id="resForm">
    <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="border-collapse: collapse;">
        <tr>
            <td class="left_td">入库日期：
            </td>
            <td class="tdinput" style="width: 200px;">
                <input name="indate" id="indate" class="easyui-validatebox Wdate" style="width: 200px;"onfocus="WdatePicker({isShowClear:false,readOnly:true})" required />
            </td>
        </tr>
        <tr>
            <td class="left_td">所属网格：
            </td>
            <td class="tdinput" >
                <input name="gridid" id="gridid" class="inputBorder" required style="width: 200px;"/>
            </td>
        </tr>
        <tr>
            <td class="left_td">资源类别：
            </td>
            <td class="tdinput" style="width: 180px;">
                <input name="typeid" id="typeid" class="inputBorder" required style="width: 200px;"/>
            </td>
        </tr>
        <tr>
            <td class="left_td">入库数量：
            </td>
            <td class="tdinput">
                <input type="text" name="amount" class="inputBorder easyui-numberbox" data-options="min:0,required:true"  style="width: 200px;"/>
            </td>
        </tr>
        <tr>
            <td class="left_td">固定资产编码：
            </td>
            <td class="tdinput">
                <input name="assetsno" id="assetsno" class="inputBorder " style="width: 200px;"/>
            </td>
        </tr>
        <tr>
            <td class="left_td">存放地点：
            </td>
            <td class="tdinput">
                <textarea name="location" style="width: 300px" rows="3" id="location" class="easyui-validatebox" required></textarea>
            </td>
        </tr>
        <tr>
            <td class="left_td">联系人：
            </td>
            <td class="tdinput">
                <input name="linkman" id="linkman" class="inputBorder easyui-validatebox" style="width: 200px;" data-options="required:true" />
            </td>
        </tr>
        <tr>
            <td class="left_td">联系电话：
            </td>
            <td class="tdinput">
                <input name="linkphone" id="linkphone" style="width: 200px;" class="inputBorder easyui-validatebox" data-options="required:true" />
            </td>
        </tr>
        <tr>
            <td class="left_td">备注：
            </td>
            <td class="tdinput">
                <textarea  name="memo" id="memo" rows="3" class="" style="width: 300px"></textarea>
            </td>
        </tr>
    </table>
</form>
