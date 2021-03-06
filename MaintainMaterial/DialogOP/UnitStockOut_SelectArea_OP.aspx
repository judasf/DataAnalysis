﻿<%@ Page Language="C#" %>

<% 
    /** 
     *各营销中心库管或者领料工号录入领料信息时选择领料单位
     */
    //id
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
%>
<script type="text/javascript">
    var onFormSubmit = function ($dialog, $grid) {
        if ($('#isForm').form('validate')) {
            var areaid = $('input[name="areaId"]').val();
            var areaname = $('#areaId').combobox('getText');
            $dialog.dialog('close');
            var dialog = parent.$.modalDialog({
                title: '领料信息录入',
                width: 800,
                height: 500,
                iconCls: 'icon-remove',
                href: 'CustomAccess/dialogop/UnitStockOut_OP.aspx?areaid='+areaid+'&areaname='+encodeURIComponent(areaname),
                buttons: [{
                    text: '提交',
                    handler: function () {
                        parent.onFormSubmit(dialog, $grid);
                    }
                },
                {
                    text: '取消',
                    handler: function () {
                        dialog.dialog('close');
                    }
                }]
            });
        }
    };
</script>
<style>
    #FCTable .text-right { text-align: right; vertical-align: middle;width:130px; }
    #FCTable input[readonly]{background-color:#fff;}
</style>
<form method="post" id="isForm">
        <table class="doc-table">
        <caption style="font-size: 14px; line-height: 35px; font-weight: 700;">
            选择领料单位
        </caption>
        <tr>
            <td style="text-align:right;">领料单位：
            </td>
            <td colspan="3"style="text-align:left;" >
                <input id="areaId" type="text" name="areaId" style="width: 140px;" class="combo easyui-combobox" data-options="
                    valueField: 'id',
                    textField: 'text',
                    editable: false,
                    required:true,
                    panelHeight: 'auto',
                    url: 'ajax/Srv_CustomAccess.ashx/GetCustomAccess_UnitAreaCombobox'
                      " />
            </td>
        </tr>
    </table>
</form>

