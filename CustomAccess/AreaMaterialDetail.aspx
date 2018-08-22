<%@ Page Language="C#" %>

<!DOCTYPE html>
<html>
<head>
    <title>客户接入——装维片区用料明细</title>
    <%--引入My97日期文件--%>
    <script src="../Script/My97DatePicker/WdatePicker.js" type="text/javascript"></script>
    <%--引入Jquery文件--%>
    <script src="../Script/easyui/jquery-1.10.2.min.js" type="text/javascript"></script>
    <script src="../Script/easyui/jquery.easyui.min.js" type="text/javascript"></script>
    <%--引入uploadify文件--%>
    <link rel="stylesheet" type="text/css" href="../Script/uploadify/uploadify.css" />
    <script type="text/javascript" src="../Script/uploadify/jquery.uploadify.js"></script>
    <%--引入easyui文件--%>
    <link href="../Script/easyui/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../Script/easyui/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../Script/easyui/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../Script/extJquery.js" type="text/javascript"></script>
    <script src="../Script/extEasyUI.js" type="text/javascript"></script>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />
    <%  int roleid = -1;
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
            roleid = int.Parse(Session["roleid"].ToString()); 
    %>
    <script type="text/javascript">
        var roleid = '<%=roleid%>';
    </script>
    <%}
    %>
    <script type="text/javascript">
        var grid;
        var addFun = function () {
            var dialog = parent.parent.$.modalDialog({
                title: '装维片区用料明细录入',
                width: 550,
                height: 400,
                iconCls: 'icon-add',
                href: 'BaseUnit/dialogop/InputAreaMaterial_op.aspx',
                buttons: [{
                    text: '提交',
                    handler: function () {
                        parent.onFormSubmit(dialog, grid);
                    }
                },
                {
                    text: '取消',
                    handler: function () {
                        dialog.dialog('close');
                    }
                }]
            });
        };
        //查询功能
        var searchGrid = function () {
            grid.datagrid('load', $.serializeObject($('#searchForm')));
        };
        //重置查询
        var resetGrid = function () {
            if (roleid != 12 && roleid != 13 && roleid != 14)
                $('#unitname').combobox('setValue', '');
            $('#typeid').combobox('setValue', '');
            grid.datagrid('load', {});
        };
        //导出装维片区用料明细excel
        var exportAreaMaterialDetail = function () {
            jsPostForm('../ajax/Srv_khjr_Stock.ashx/ExportAreaMaterialDetail', $.serializeObject($('#searchForm')));
        };
        //导入装维片区用料明细
        var importAreaMaterialDetail = function () {
            var dialog = parent.$.modalDialog({
                title: '导入数据',
                width: 600,
                height: 230,
                iconCls: 'icon-table_row_insert',
                href: 'BaseUnit/DialogOP/ImporAreaMaterial_op.aspx',
                buttons: [{
                    text: '导入',
                    handler: function () {
                        parent.onFormSubmit(dialog, grid);
                    }
                },
                    {
                        text: '取消',
                        handler: function () {
                            dialog.dialog('close');
                        }
                    }
                ]
            });
        };
        $(function () {
            grid = $('#grid').datagrid({
                title: '装维片区用料明细',
                url: '../ajax/Srv_khjr_Stock.ashx/GetAreaMaterialDetail',
                striped: true,
                rownumbers: true,
                pagination: true,
                singleSelect: true,
                noheader: true,
                showFooter:true,
                pageSize: 20,
                idField: 'a.id',
                sortName: 'a.id',
                sortOrder: 'desc',
                columns: [[{
                    width: '80',
                    title: '录入日期',
                    field: 'inputdate',
                    sortable: false,
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '100',
                    title: '装维单元',
                    field: 'unitname',
                    sortable: false,
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '80',
                    title: '装维片区',
                    field: 'areaname',
                    sortable: false,
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '60',
                    title: '用料类别',
                    field: 'yllb',
                    sortable: false,
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '100',
                    title: '用户号码',
                    field: 'usernum',
                    sortable: false,
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '80',
                    title: '用户姓名',
                    field: 'username',
                    sortable: false,
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '120',
                    title: '用户地址',
                    field: 'useraddress',
                    sortable: false,
                    halign: 'center',
                    align: 'center'
                }
                , {
                    width: '100',
                    title: '光猫',
                    field: 'onu',
                    sortable: false,
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '60',
                    title: '皮线光缆',
                    field: 'pxgl',
                    sortable: false,
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '65',
                    title: '冷接(3M)',
                    field: 'ljct_3m',
                    sortable: false,
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '65',
                    title: '冷接(国产)',
                    field: 'ljct_gc',
                    sortable: false,
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '35',
                    title: '皮线',
                    field: 'px',
                    sortable: false,
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '35',
                    title: '户线',
                    field: 'hx',
                    sortable: false,
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '35',
                    title: '网线',
                    field: 'wx',
                    sortable: false,
                    halign: 'center',
                    align: 'center'
                },  {
                    width: '120',
                    title: '备注',
                    field: 'memo',
                    sortable: false,
                    halign: 'center',
                    align: 'center'
                }]],
                toolbar: '#toolbar',
                onLoadSuccess: function (data) {
                    parent.$.messager.progress('close');
                    if (!data.success && data.total == -1) {
                        parent.$.messager.alert('提示', '登陆超时，请重新登陆再进行操作！', 'error', function () {
                            parent.location.replace('logout.aspx');
                        });
                    }
                    if (data.rows.length == 0) {
                        var body = $(this).data().datagrid.dc.body2;
                        body.find('table tbody').append('<tr><td width="' + body.width() + '" style="height: 25px; text-align: center;">没有数据</td></tr>');
                    }
                    //提示框
                    $(this).datagrid('tooltip', ['useraddress', 'memo']);
                }
            });
            var pager = $('#grid').datagrid('getPager');
            pager.pagination({
                layout: ['list', 'sep', 'first', 'prev', 'sep', 'links', 'sep', 'next', 'last', 'sep', 'refresh', 'sep', 'manual']
            });
        });
    </script>
</head>
<body class="easyui-layout" style="overflow: hidden;">

    <div id="toolbar" style="display: none; padding: 5px 10px 0;">
        <form id="searchForm" style="margin: 0;">
            <table>
                <tr>
                    <td style="width: 80px; font-weight: 700;">数据查询：</td>
                    <td style="width: 65px; text-align: right;">录入日期：
                    </td>
                    <td>
                        <input style="width: 80px;" name="sdate" id="sdate" class="Wdate" onfocus="WdatePicker({maxDate:'#F{$dp.$D(\'edate\')}',maxDate:'%y-%M-%d'})"
                            readonly="readonly" />-<input style="width: 80px;" name="edate" id="edate" class="Wdate"
                                onfocus="WdatePicker({minDate:'#F{$dp.$D(\'sdate\')}',maxDate:'%y-%M-%d'})" readonly="readonly" />
                    </td>
                    <td style="width: 65px; text-align: right;">基层单元：
                    </td>
                    <td>
                        <select id="unitname" class="combo easyui-combobox" name="unitname" style="width: 120px;" data-options="panelHeight:'auto',editable: false,onSelect:function(rec){ var url = '../ajax/Srv_khjr.ashx/GetKHJR_UnitAreaComboboxAll?unitname='+encodeURIComponent(rec.value);$('#areaid').combobox('reload', url); }">
                            <%if (roleid == 12 || roleid == 13 || roleid == 14 || roleid == 17)
                              { %>
                            <option><%=Session["deptname"] %></option>

                            <%}
                              else
                              { %>
                            <option value="">全部</option>
                            <option>东风路装维单元</option>
                            <option>红旗路装维单元</option>
                            <option>相一路装维单元</option>
                            <option>东区装维单元</option>
                            <option>开发区装维单元</option>
                            <option>铁西区装维单元</option>
                            <%} %>
                        </select>
                    </td>
                     <td style="width: 65px; text-align: right;">装维片区：
                    </td>
                    <td>
                        <%--<input type="hidden" value="" id="areaname" name="areaname" />--%>
                        <input id="areaid" class="combo easyui-combobox" name="areaid" style="width: 120px;" data-options="panelHeight:'200',valueField:'id',textField:'text',editable: false,url:'../ajax/Srv_khjr.ashx/GetKHJR_UnitAreaComboboxAll'"/>
                    </td>
                   
                </tr>
                <tr>
                    <td colspan="7" style="text-align: left;padding-left:100px;">
                        <a href="javascript:void(0);" style="margin:0 10px;" class="easyui-linkbutton" data-options="iconCls:'icon-magifier',plain:false"
                            onclick="searchGrid();">&nbsp;&nbsp;查询&nbsp;&nbsp;</a>
                        <a href="javascript:void(0);" style="margin-right: 10px;" class="easyui-linkbutton" data-options="iconCls:'icon-magifier_zoom_out',plain:false"
                            onclick="resetGrid();">&nbsp;&nbsp;重置&nbsp;&nbsp;</a>
                      <%if ( Session["uname"].ToString() == "董福顺")
                          { %>    <a href="javascript:void(0);" style="margin-right: 10px;" class="easyui-linkbutton" data-options="iconCls:'icon-table_go',plain:false"
                            onclick="exportAreaMaterialDetail();">&nbsp;&nbsp;导出&nbsp;&nbsp;</a>
                      
                        <a href="javascript:void(0);" style="margin-right: 10px;" class="easyui-linkbutton" data-options="iconCls:'icon-table_row_insert',plain:false"
                            onclick="importAreaMaterialDetail();">导入用料明细</a>
                        <%} %>
                    </td>
                      <%if (roleid == 14)
                  { %>
                <tr>
                    <td colspan="7" align="left">
                        <a href="javascript:void(0);" style="margin-right: 10px;" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:false"
                        onclick="addFun();">装维片区用料明细录入</a>
                    </td>
                </tr>
                <%} %>
                </tr>
            </table>
        </form>
    </div>
    <div data-options="region:'center',fit:true,border:false">
        <p class="sitepath">
            <b>当前位置：</b>客户接入事项管理 > <a href="javascript:void(0);">客户接入——用料明细</a>
        </p>
        <table id="grid" data-options="fit:false,border:false">
        </table>
    </div>
</body>
</html>
