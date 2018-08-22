<%@ Page Language="C#" %>

<!DOCTYPE html>
<html>
<head>
    <title>运维物料管理——物料调拨明细</title>
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
        //查询功能
        var searchGrid = function () {
            grid.datagrid('load', $.serializeObject($('#searchForm')));
        };
        //重置查询
        var resetGrid = function () {
            if (roleid != 2)
                $('#unitname').combobox('setValue', '');
            $('#oldunitname').combobox('setValue', '');
            $('#sdate').val('');
            $('#edate').val('');
            $('#classname').combobox('setValue', '');
            $('#typeid').combobox('setValue', '');
            grid.datagrid('load', {});
        };
        //导出入库明细excel
        var exportInStockDetail = function () {
            jsPostForm('../ajax/Srv_MaintainMaterial.ashx/ExportUnitAllotStockDetail', $.serializeObject($('#searchForm')));
        };
        $(function () {
            //初始化型号下拉框
            $('#typeid').combobox({
                valueField: 'id',
                textField: 'text',
                editable: true,
                panelHeight: '200',
                url: '../ajax/Srv_MaintainMaterial.ashx/GetTypeInfoComboboxAll',
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
                title: '物料调拨明细',
                url: '../ajax/Srv_MaintainMaterial.ashx/GetUnitAllotStockDetail',
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
                    title: '调拨日期',
                    field: 'allotrq',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '80',
                    title: '单位名称',
                    field: 'allotunitname',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '200',
                    title: '调拨单号',
                    field: 'allotorderno',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '220',
                    title: '原商城订单号',
                    field: 'storeorderno',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '80',
                    title: '调拨单位',
                    field: 'oldunitname',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '60',
                    title: '调拨单',
                    field: 'reportpath',
                    halign: 'center',
                    align: 'center',
                    formatter: function (index, row) {
                        var str = '';
                        if (row.reportpath)
                            str += $.formatString('<a href="javascript:void(0);" data-mfp-src="../{0}"  title="点击查看调拨单" class="showpic" style="cursor:pointer;text-decoration:none;color:#ff8800" >详情</a>', row.reportpath);
                        return str;
                    }
                }, {
                    width: '80',
                    title: '物料类型',
                    field: 'classname',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '320',
                    title: '物料型号',
                    field: 'typename',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '100',
                    title: '调拨数量',
                    field: 'allotnum',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '40',
                    title: '单位',
                    field: 'units',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '40',
                    title: '单价',
                    field: 'price',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '80',
                    title: '金额',
                    field: 'money',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '200',
                    title: '备注',
                    field: 'memo',
                    halign: 'center',
                    align: 'center'
                }, {
                    width: '80',
                    title: '调拨人',
                    field: 'allotuser',
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
                    $(this).datagrid('tooltip', ['typename', 'memo']);
                    //物料调拨单展示插件
                    $('.showpic').magnificPopup({
                        type: 'image'
                    });
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
                    <td style="width: 65px; text-align: right;">调拨日期：
                    </td>
                    <td>
                        <input style="width: 80px;" name="sdate" id="sdate" class="Wdate" onfocus="WdatePicker({maxDate:'#F{$dp.$D(\'edate\')}',maxDate:'%y-%M-%d'})" readonly="readonly" />-<input style="width: 80px;" name="edate" id="edate" class="Wdate"
                            onfocus="WdatePicker({minDate:'#F{$dp.$D(\'sdate\')}',maxDate:'%y-%M-%d'})" readonly="readonly" />
                    </td>
                 
                    <td style="width: 65px; text-align: right;">物料类型：
                    </td>
                    <td>
                        <select id="classname" class="combo easyui-combobox" name="classname" style="width: 100px;" data-options="panelHeight:'auto',editable: false,onSelect:function(rec){ var url = '../ajax/Srv_MaintainMaterial.ashx/GetMaintainMaterial_TypeInfoComboboxAll?classname='+encodeURIComponent(rec.value);$('#typeid').combobox('reload', url); }">
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
                      <td style="width:65px; text-align: right;">
                    </td>
                       <td style="width: 65px; text-align: right;">单位名称：
                    </td>
                    <td>
                        <select id="unitname" class="combo easyui-combobox" name="unitname" style="width: 170px;" data-options="panelHeight:'auto',editable: false">
                            <%if (roleid == 2)
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
                    <td style="width: 75px; text-align: right;">调拨单位：
                    </td>
                    <td>
                        <select id="oldunitname" class="combo easyui-combobox" name="oldunitname" style="width: 100px;" data-options="panelHeight:'auto',editable: false">
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
                        </select>
                    </td>
                    <td style="width: 85px; text-align: right;">商城出库单号：
                    </td>
                    <td align="left">
                        <input type="text" name="storeorderno" id="storeorderno" style="width: 300px; height: 20px;" class="combo" />
                    </td>
                    </tr><tr>
                         <td style="width:80px; text-align: right;">
                    </td>
                    <td colspan="6" style="text-align: left">
                        <a href="javascript:void(0);" style="margin-right: 10px;" class="easyui-linkbutton" data-options="iconCls:'icon-magifier',plain:false"
                            onclick="searchGrid();">&nbsp;&nbsp;查询&nbsp;&nbsp;</a>
                        <a href="javascript:void(0);" style="margin-right: 10px;" class="easyui-linkbutton" data-options="iconCls:'icon-magifier_zoom_out',plain:false"
                            onclick="resetGrid();">&nbsp;&nbsp;重置&nbsp;&nbsp;</a>
                         <a href="javascript:void(0);" style="margin-right: 10px;" class="easyui-linkbutton" data-options="iconCls:'icon-table_go',plain:false"
                            onclick="exportInStockDetail();">&nbsp;&nbsp;导出&nbsp;&nbsp;</a>
                    </td>
                </tr>
            </table>
        </form>
    </div>
    <div data-options="region:'center',fit:true,border:false">
        <p class="sitepath">
            <b>当前位置：</b>运维物料管理 > <a href="javascript:void(0);">物料调拨明细</a>
        </p>
        <table id="grid" data-options="fit:false,border:false">
        </table>
    </div>
</body>
</html>
