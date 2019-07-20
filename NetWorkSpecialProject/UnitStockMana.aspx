<%@ Page Language="C#" %>

<!DOCTYPE html>
<html>
<head>
    <title>专项整治管理——物料库存管理</title>
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
        string uname = "";
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
            uname = Session["uname"].ToString();
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
                title: '物料库存录入',
                width: 860,
                height: 500,
                iconCls: 'icon-add',
                href: 'NetWorkSpecialProject/dialogop/UnitStockMana_OP.aspx',
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
        /*
        //领料信息录入
        var removeFun = function (id) {
                var dialog = parent.$.modalDialog({
                    title: '领料信息录入',
                    width: 860,
                    height: 500,
                    iconCls: 'icon-remove',
                    href: 'NetWorkSpecialProject/dialogop/UnitStockOut_OP.aspx',
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
        };*/
        //物料领取
        var drawFun = function (id) {
            var dialog = parent.$.modalDialog({
                title: '物料领取',
                width: 860,
                height: 500,
                iconCls: 'icon-remove',
                href: 'NetWorkSpecialProject/dialogop/UnitStockDraw_OP.aspx',
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
        //物料调拨
        var allotFun = function () {
            var row = grid.datagrid('getSelected');
            if (!row) {
                parent.$.messager.alert('提示', '请选择要调拨的物料！', 'error');
            }
            else if (row.amount == 0)
            {
                parent.$.messager.alert('提示', '该物料库存不足！', 'error');
            }else
                var dialog = parent.parent.$.modalDialog({
                    title: '物料调拨',
                    width: 580,
                    height: 480,
                    iconCls: 'icon-add',
                    href: 'NetWorkSpecialProject/dialogop/UnitStockAllot_OP.aspx?id='+row.id,
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
            if (roleid != 2)
                $('#unitname').combobox('setValue', '');
            $('#classname').combobox('setValue', '');
            $('#typeid').combobox('setValue', '');
            grid.datagrid('load', {});
        };
        //导出库存明细excel
        var exportStock = function () {
            jsPostForm('../ajax/Srv_NetWorkSpecialProject.ashx/ExportUnitStock', $.serializeObject($('#searchForm')));
        };
        $(function () {
            //初始化型号下拉框
            $('#typeid').combobox({
                valueField: 'id',
                textField: 'text',
                editable: true,
                panelHeight: '200',
                url: '../ajax/Srv_NetWorkSpecialProject.ashx/GetTypeInfoComboboxAll',
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
                },
                onLoadError: function () {
                    parent.$.messager.alert('提示', '该物料类型下未配置型号！', 'error');
                }
            });
            grid = $('#grid').datagrid({
                title: '专项整治物料库存表',
                url: '../ajax/Srv_NetWorkSpecialProject.ashx/GetMaintainMaterialUnitStock',
                striped: true,
                rownumbers: true,
                pagination: true,
                singleSelect: true,
                noheader: true,
                pageSize: 20,
                idField: 'a.id',
                sortName: 'a.id',
                sortOrder: 'desc',
                columns: [[{
                    width: '80',
                    title: '单位名称',
                    field: 'unitname',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '220',
                    title: '商城出库单号',
                    field: 'storeorderno',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '80',
                    title: '物料类型',
                    field: 'classname',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '450',
                    title: '物料型号',
                    field: 'typename',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '60',
                    title: '库存数量',
                    field: 'amount',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '40',
                    title: '单位',
                    field: 'units',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '60',
                    title: '单价',
                    field: 'price',
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
                    $(this).datagrid('clearSelections').datagrid('tooltip', ['typename']);
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
                    <td style="width: 65px; font-weight: 700;">数据查询：</td>
                    <td style="width: 65px; text-align: right;">单位名称：
                    </td>
                    <td>
                        <select id="unitname" class="combo easyui-combobox" name="unitname" style="width: 220px;" data-options="panelHeight:'auto',editable: false,onSelect:function(rec){ var url = '../ajax/Srv_NetWorkSpecialProject.ashx/GetNetWorkSpecialProject_UnitAreaComboboxAll?unitname='+encodeURIComponent(rec.value);$('#areaid').combobox('reload', url); }">
                            <%if (roleid == 2 )
                                { %>
                            <option><%=Session["deptname"] %></option>

                            <%}
                                else
                                { %>
                            <option value="">全部</option>
                            <option>运行维护部</option>
                               <option>网络发展部</option>
                            <option>网络优化中心</option>
                            <option>客户支撑中心</option>
                            <option>网络维护中心</option>
                            <option>安阳县</option>
                            <option>滑县</option>
                            <option>内黄县</option>
                            <option>林州市</option>
                            <option>汤阴县</option>
                            <%} %>
                        </select>
                    </td>
                       <td style="width: 65px; text-align: right;">物料类型：
                    </td>
                    <td>
                        <select id="classname" class="combo easyui-combobox" name="classname" style="width: 100px;" data-options="panelHeight:'auto',editable: false,onSelect:function(rec){ var url = '../ajax/Srv_NetWorkSpecialProject.ashx/GetNSP_MaintainMaterial_TypeInfoComboboxAll?classname='+encodeURIComponent(rec.value);$('#typeid').combobox('reload', url); }">
                            <option value="">全部</option>
                            <option>光缆</option>
                            <option>电力电缆</option>
                            <option>双绞线</option>
                            <option>光跳纤</option>
                            <option>光缆接头盒</option>
                            <option>分光器</option>
                            <option>电杆</option>
                            <option>井盖</option>
                            <option>铁件</option>
                            <option>工器具</option>
                            <option>其他</option>
                        </select>
                    </td>
                    <td style="width: 65px; text-align: right;">物料型号：
                    </td>
                    <td align="left">
                        <input name="typeid" id="typeid" class="combo" style="width: 300px;" />
                    </td>
                    </tr>
                <tr>
                    <td style="width: 65px; font-weight: 700;"></td>
                    <td style="width: 85px; text-align: right;">商城出库单号：
                    </td>
                    <td align="left">
                        <input type="text" name="storeorderno" id="storeorderno"  style="width: 220px;height:20px;" class="combo"/>
                    </td>
                     <td style="width: 85px; text-align: right;">是否有库存：
                    </td>
                    <td align="left">
                        <select id="" class="combo easyui-combobox" name="currentstock" style="width: 100px;" data-options="panelHeight:'auto',editable: false">
                            <option value="-1">全部</option>
                            <option value="1" selected>有库存</option>
                            <option value="0" >库存为0</option>
                        </select>
                    </td>
                    <td colspan="2" align="left">
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier',plain:true"
                            onclick="searchGrid();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier_zoom_out',plain:true"
                            onclick="resetGrid();">重置</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-table_go',plain:true"
                            onclick="exportStock();">导出</a>
                    </td>
                </tr>
                <%if (roleid ==2 || roleid == 4)
                    { %>
                <tr>
                     <td style="width: 65px; font-weight: 700;"></td>
                    <td colspan="5" align="left">
                         <% if((roleid==4)&& (uname=="ligang171"||uname=="wankun")||roleid ==2){%>
                        <a href="javascript:void(0);" style="margin-right: 10px;" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:false"
                            onclick="addFun();">物料库存录入</a>
                        <a href="javascript:void(0);" style="margin-right: 10px;" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:false"
                            onclick="allotFun();">物料调拨</a>
                      
                           <a href="javascript:void(0);" class="easyui-linkbutton" style="margin-right: 10px;" data-options="iconCls:'icon-remove',plain:false"
                            onclick="drawFun();">物料领取</a>
                          <%} %>
                      <%--  <a href="javascript:void(0);" class="easyui-linkbutton" style="margin-right: 10px;" data-options="iconCls:'icon-remove',plain:false"
                            onclick="removeFun();">领料信息录入</a>--%>
                           <a href="../template/物资调拨领用单.xlsx" class="easyui-linkbutton" style="margin-right: 10px;" data-options="iconCls:'icon-save',plain:false"
                            onclick="void('0');">物料调拨领用单下载</a>
                    </td>
                </tr>
                <%} %>
            </table>
        </form>
    </div>
    <div data-options="region:'center',fit:true,border:false">
        <p class="sitepath">
            <b>当前位置：</b>专项整治管理 > <a href="javascript:void(0);">物料库存管理</a>
        </p>
        <table id="grid" data-options="fit:false,border:false">
        </table>
    </div>
</body>
</html>
