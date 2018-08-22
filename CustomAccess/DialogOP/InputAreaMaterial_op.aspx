<%@ Page Language="C#" %>

<% 
    /** 
     * KHJR_Zwyl表操作对话框
     * 
     */
%>
<script type="text/javascript">

    var onFormSubmit = function ($dialog, $grid) {
        if ($('form').form('validate')) {
            var url = 'ajax/Srv_khjr_Stock.ashx/SaveAreaMaterial';
            $.post(url, $.serializeObject($('form')), function (result) {
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
                    $grid.datagrid('reload');
                    $grid.datagrid('unselectAll');
                    $dialog.dialog('close');
                } else {
                    parent.$.messager.alert('提示', result.msg, 'error');
                }
            }, 'json');
        }
    };
</script>
<style>
    table td input { width: 100px; }
</style>
<form method="post">
    <table class="doc-table">
        <tr>
            <td style="text-align: right">用户号码：
            </td>
            <td>
                <input id="usernum" type="text" name="usernum" class="inputBorder easyui-validatebox " required placeholder="用户号码" />
            </td>
            <td style="text-align: right">用户姓名：
            </td>
            <td>
                <input id="username" type="text" name="username" placeholder="用户姓名" />
            </td>
        </tr>
        <tr>
            <td style="text-align: right">用户地址：</td>
            <td colspan="3">
                <textarea id="useraddress" name="useraddress" style="width: 300px;" rows="2" />
        </tr>
        <tr style="background-color: #eeeeee; line-height: 20px;">
            <td colspan="4" style="text-align: center">用料明细 </td>
        </tr>
        <tr>
            <td style="text-align: right">用料类别：</td>
            <td colspan="3">
                <select name="yllb" id="yllb" class="easyui-combobox" data-options="editable:false,panelHeight:50">
                    <option>装机</option>
                    <option>修障</option>
                </select></td>
        </tr>
        <tr>
            <td style="text-align: right">光猫：</td>
            <td>
                <select name="onu" id="onu" class="easyui-combobox" data-options="editable:false">
                    <option value="">选择光猫型号</option>
                    <option>华为通用GPON</option>
                    <option>烽火通用GPON</option>
                    <option>烽火通用EPON</option>
                    <option>中兴通用GPON</option>
                    <option>中兴通用EPON</option>
                    <option>华为8110</option>
                    <option>华为8311</option>
                    <option>华为8240</option>
                    <option>华为通用8321</option>
                    <option>烽火5006-01-B</option>
                    <option>烽火5506-01-B</option>
                    <option>烽火5506-04</option>
                    <option>中兴F420</option>
                    <option>中兴F607</option>
                    <option>中兴F607(通用)</option>
                    <option>中兴F620</option>
                    <option>上海贝尔I-120E</option>
                    <option>烽火HG261G</option>
                    <option>中兴ZXA10F612</option>
                    <option>烽火HG221G</option>
                    <option>中兴ZXA10F412</option>
                </select></td>
            <td style="text-align: right">皮线光缆：</td>
            <td>
                <input type="number" id="pxgl" name="pxgl" onblur="this.value=this.value.replace(/\D/g,'')" />
                米 </td>
        </tr>
        <tr>
            <td style="text-align: right">冷接插头(3M)：</td>
            <td>
                <input type="number" id="ljct_3M" name="ljct_3M" onblur="this.value=this.value.replace(/\D/g,'')" />
                只 </td>
            <td style="text-align: right">冷接插头(国产)：</td>
            <td>
                <input type="number" id="ljct_gc" name="ljct_gc" onblur="this.value=this.value.replace(/\D/g,'')" />
                只 </td>
        </tr>
        <tr>
            <td style="text-align: right">皮线：</td>
            <td>
                <input type="number" id="px" name="px" onblur="this.value=this.value.replace(/\D/g,'')" />
                米</td>
            <td style="text-align: right">户线：</td>
            <td>
                <input type="number" id="hx" name="hx" onblur="this.value=this.value.replace(/\D/g,'')" />
                米 </td>
        </tr>
        <tr>
            <td style="text-align: right">网线：</td>
            <td colspan="3">
                <input type="number" id="wx" name="wx" onblur="this.value=this.value.replace(/\D/g,'')" />
                米 </td>
        </tr>
        <tr>
            <td style="text-align: right">备注：</td>
            <td colspan="3">
                <textarea id="memo" name="memo" style="width: 300px;" rows="2" />
        </tr>
    </table>
</form>
