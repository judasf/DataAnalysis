<%@ Page Language="C#" %>

<!DOCTYPE html>
<html>
<head>
    <title>盘活资源事项——资源明细</title>
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
    <%--引入图片展示插件--%>
    <link href="../Script/ImgPopup/ImgPopup.css" rel="stylesheet" />
    <script src="../Script/ImgPopup/ImgPopup.min.js"></script>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />
    <%  int roleid = -1;
        string deptname = "";
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
            deptname = Session["deptname"].ToString();
    %>
    <script type="text/javascript">
        var roleid = '<%=roleid%>';
        var deptname = '<%=deptname%>';
    </script>
    <%}
    %>
    <script type="text/javascript">
        var grid;
        var addFun = function () {
            var dialog = parent.parent.$.modalDialog({
                title: '资源录入',
                width: 500,
                height: 490,
                iconCls: 'icon-add',
                href: 'ResourceReuse/dialogop/RRStockMana_OP.aspx',
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

        //物资领用
        var drawFun = function () {
            var row = grid.datagrid('getSelected');
            if (!row) {
                parent.$.messager.alert('提示', '请选择要领用的资源！', 'error');
            }
            else if(deptname!=row.unitname){
                parent.$.messager.alert('提示', '只能领取本单位入库资源！', 'error');
            }else if (row.amount == 0) {
                parent.$.messager.alert('提示', '库存不足！', 'error');
            } else
                var dialog = parent.parent.$.modalDialog({
                    title: '物资领取',
                    width: 580,
                    height: 620,
                    iconCls: 'icon-add',
                    href: 'ResourceReuse/dialogop/RRStockDraw_OP.aspx?id=' + row.id,
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
        //导出入库明细excel
        var exportOutStockDetail = function () {
            jsPostForm('../ajax/Srv_ResourceReuse.ashx/ExportReuseDrawStockDetail', $.serializeObject($('#searchForm')));
        };
        //显示当前资源的领用明细
        var viewReceiveRRDetail = function (id) {
            var dialog = parent.$.modalDialog({
                title: '资源领用明细',
                width: 650,
                height: 400,
                iconCls: 'ext-icon-page',
                href: 'ResourceReuse/DialogOP/ViewDrawRRDetail_OP.aspx?id=' + id,
                buttons: [{
                    text: '关闭',
                    handler: function () {
                        dialog.dialog('close');
                    }
                }]
            });
        };
        $(function () {
            //初始化型号下拉框
            $('#typeid').combobox({
                valueField: 'id',
                textField: 'text',
                editable: true,
                panelHeight: '200',
                url: '../ajax/Srv_ResourceReuse.ashx/GetTypeInfoComboboxAll',
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
            grid = $('#grid').datagrid({
                title: '资源明细',
                url: '../ajax/Srv_ResourceReuse.ashx/GetRRStockInfo',
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
                    title: '入库日期',
                    field: 'indate',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '100',
                    title: '资源编号',
                    field: 'rrid',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '160',
                    title: '资源名称',
                    field: 'typename',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '100',
                    title: '入库单位',
                    field: 'unitname',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '160',
                    title: '网格名称',
                    field: 'gridname',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '100',
                    title: '入库数量',
                    field: 'amount',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '100',
                    title: '当前库存',
                    field: 'currentstock',
                    halign: 'center',
                    align: 'center',
                    styler: function (value, row, index) {
                        return 'color:red;'
                    }
                }, {
                    width: '40',
                    title: '单位',
                    field: 'units',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '80',
                    title: '领取明细',
                    field: 'materialdetail',
                    halign: 'center',
                    align: 'center',
                    formatter: function (index, row) {
                        var str = '';
                        if (row.currentstock == row.amount)
                            str += '无领取明细';
                        else {
                            str += $.formatString('<a href="javascript:void(0);" onclick="viewReceiveRRDetail(\'{0}\');"  title="点击查看领取明细" style="cursor:pointer;text-decoration:none;color:#ff8800" >领取明细</a>', row.rrid);
                        }
                        return str;
                    }
                }, {
                    width: '200',
                    title: '存放地点',
                    field: 'location',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '100',
                    title: '联系人',
                    field: 'linkman',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '100',
                    title: '联系电话',
                    field: 'linkphone',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '200',
                    title: '备注',
                    field: 'memo',
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
                    $(this).datagrid('tooltip', ['memo']);
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
                    <td style="width: 65px; text-align: right;">入库日期：
                    </td>
                    <td>
                        <input style="width: 80px;" name="sdate" id="sdate" class="Wdate" onfocus="WdatePicker({maxDate:'#F{$dp.$D(\'edate\')}',maxDate:'%y-%M-%d'})"
                            readonly="readonly" />-<input style="width: 80px;" name="edate" id="edate" class="Wdate"
                                onfocus="WdatePicker({minDate:'#F{$dp.$D(\'sdate\')}',maxDate:'%y-%M-%d'})" readonly="readonly" />
                    </td>
                    <td style="width: 65px; text-align: right;">资源名称：
                    </td>
                    <td align="left">
                        <input name="typeid" id="typeid" class="combo" style="width: 140px;" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 65px; font-weight: 700;"></td>
                    <td style="width: 65px; text-align: right;">入库单位：
                    </td>
                    <td>
                        <select id="unitname" class="combo easyui-combobox" name="unitname" style="width: 170px;" data-options="panelHeight:'auto',editable: false">
                            <option value="">全部</option>
                            <option>网络管理中心</option>
                            <option>网络优化/客户响应中心</option>
                            <option>安阳县</option>
                            <option>滑县</option>
                            <option>内黄县</option>
                            <option>林州市</option>
                            <option>汤阴县</option>
                        </select>
                    </td>
                    <td style="width: 85px; text-align: right;">资源编号：
                    </td>
                    <td align="left">
                        <input type="text" name="rrid" id="rrid" style="width: 140px; height: 20px;" class="combo" />
                    </td>
                    <td style="text-align: left; padding-left: 0;">
                        <a href="javascript:void(0);" style="margin: 0 10px;" class="easyui-linkbutton" data-options="iconCls:'icon-magifier',plain:true"
                            onclick="searchGrid();">&nbsp;&nbsp;查询&nbsp;&nbsp;</a>
                        <a href="javascript:void(0);" style="margin-right: 10px;" class="easyui-linkbutton" data-options="iconCls:'icon-magifier_zoom_out',plain:true"
                            onclick="resetGrid();">&nbsp;&nbsp;重置&nbsp;&nbsp;</a>

                        <%--<a href="javascript:void(0);" style="margin-right: 10px;" class="easyui-linkbutton" data-options="iconCls:'icon-table_go',plain:true"
                            onclick="exportOutStockDetail();">&nbsp;&nbsp;导出&nbsp;&nbsp;</a>--%>
                    </td>
                </tr>
                <%if (roleid == 40)
                    { %>
                <tr>
                    <td style="width: 65px; font-weight: 700;"></td>
                    <td colspan="5" align="left">
                        <a href="javascript:void(0);" style="margin-right: 10px;" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:false"
                            onclick="addFun();">资源录入</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" style="margin-right: 10px;" data-options="iconCls:'icon-remove',plain:false"
                            onclick="drawFun();">资源领取</a>
                    </td>
                </tr>
                <%} %>
            </table>
        </form>
    </div>
    <div data-options="region:'center',fit:true,border:false">
        <p class="sitepath">
            <b>当前位置：</b>盘活资源事项 > <a href="javascript:void(0);">资源明细</a>
        </p>
        <table id="grid" data-options="fit:false,border:false">
        </table>
    </div>
</body>
</html>
