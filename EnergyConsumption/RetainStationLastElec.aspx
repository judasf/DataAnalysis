<%@ Page Language="C#" %>

<!DOCTYPE html>
<html>
<head>
    <title>保留基站上年度电费</title>
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
      
        
        //导入数据
        var importResources = function () {
            var dialog = parent.$.modalDialog({
                title: '导入数据',
                width: 600,
                height: 230,
                iconCls: 'icon-table_row_insert',
                href: 'EnergyConsumption/Dialog/ImportRetainStationLastElec_op.aspx',
                buttons: [{
                    text: '导入',
                    handler: function () {
                        parent.onFormSubmit(dialog, RetainStationLastElecLEGrid);
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
        //编辑
        var editFun = function (id) {
            var dialog = parent.$.modalDialog({
                title: '编辑',
                width: 700,
                height: 400,
                iconCls: 'icon-edit',
                href: 'EnergyConsumption/Dialog/RetainStationLastElec_OP.aspx?id=' + id,
                buttons: [{
                    text: '保存',
                    handler: function () {
                        parent.onFormSubmit(dialog, RetainStationLastElecLEGrid);
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
        //删除保留基站站上年最后一次缴费
        var removeFun = function (id) {
            parent.$.messager.confirm('询问', '您确定要删除该上年缴费信息？', function (r) {
                if (r) {
                    $.post('../ajax/Srv_EnergyConsumption.ashx/RemoveRetainStationLastElecByID', {
                        id: id
                    }, function (result) {
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
                            RetainStationLastElecLEGrid.datagrid('reload');
                        } else {
                            parent.$.messager.alert('提示', result.msg, 'error');
                        }
                    }, 'json');
                }
            });
        };
        //查看保留基站站上年最后一次缴费
        var viewRetainStationLastElecDetail = function (id) {
            var btns = [{
                text: '关闭',
                handler: function () {
                    dialog.dialog('close');
                }
            }];
            if (roleid == 4 || roleid == 20)
                btns.unshift({
                    text: '编辑',
                    handler: function () {
                        dialog.dialog('close');
                        editFun(id);
                    }
                });
            var dialog = parent.$.modalDialog({
                title: '保留基站上年最后一次缴费',
                width: 700,
                height: 380,
                iconCls: 'ext-icon-page',
                href: 'EnergyConsumption/Dialog/ViewRetainStationLastElec_OP.aspx?id=' + id,
                buttons: btns
            });
        };
        //查询功能
        var searchGrid = function () {
            RetainStationLastElecLEGrid.datagrid('load', $.serializeObject($('#searchForm')));
        };
        //重置查询
        var resetGrid = function () {
            $('#searchForm').form('reset');
            RetainStationLastElecLEGrid.datagrid('load', {});
        };
        //导出保留基站上年电费信息明细excel
        var exportRetainStationLastElec = function () {
            jsPostForm('../ajax/Srv_EnergyConsumption.ashx/ExportRetainStationLastElec', $.serializeObject($('#searchForm')));
        };
        //保留基站上年电费信息
        var RetainStationLastElecLEGrid;
        $(function () {
            RetainStationLastElecLEGrid = $('#RetainStationLastElecLEGrid').datagrid({
                title: '保留基站上年电费信息',
                url: '../ajax/Srv_EnergyConsumption.ashx/GetRetainStationLastElec',
                striped: true,
                rownumbers: true,
                pagination: true,
                noheader: true,
                pageSize: 20,
                singleSelect: true,
                idField: 'id',
                sortName: 'id',
                sortOrder: 'asc',
                columns: [
                  [
                         {
                             title: '操作',
                             field: 'action',
                             width: '80',
                             align: 'center',
                             halign: 'center',
                             formatter: function (value, row) {
                                 var str = '';
                                 if (row.stationid) {
                                     str += $.formatString('<a href="javascript:void(0)" onclick="editFun(\'{0}\');" title="编辑" style="cursor:pointer;" >编辑</a>&nbsp;&nbsp;&nbsp;&nbsp;', row.id);
                                     str += $.formatString('<a href="javascript:removeFun(\'{0}\');" title="删除" style="cursor:pointer;" >删除</a>', row.id);
                                 }
                                 return str;
                             }
                         }, {
                            width: '180',
                            title: '基站名称',
                            field: 'stationname',
                            halign: 'center',
                            align: 'center'
                        },
                      {
                          width: '180',
                          title: '物理站址编号(联通）',
                          field: 'stationid',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '120',
                          title: '共享情况',
                          field: 'sharedrelation',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '120',
                          title: '站型',
                          field: 'stationtype',
                          halign: 'center',
                          align: 'center'
                      }
                      , {
                          width: '60',
                          title: '所属市县',
                          field: 'cityname',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '用电形式',
                          field: 'electype',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '电表户号',
                          field: 'ammeterno',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '60',
                          title: '缴费年月',
                          field: 'paymentyearmonth',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '起度',
                          field: 'startdegrees',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '止度',
                          field: 'enddegrees',
                          halign: 'center',
                          align: 'center'
                      }, {
                          title: '用电量（度）',
                          field: 'powerusage',
                          halign: 'center',
                          align: 'center'
                      }, {
                          title: '倍率',
                          field: 'rate',
                          halign: 'center',
                          align: 'center'
                      }, {
                          title: '损耗',
                          field: 'loss',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '70',
                          title: '单价（元）',
                          field: 'elecprice',
                          halign: 'center',
                          align: 'center'
                      }
                      , {
                          width: '70',
                          title: '金额（元）',
                          field: 'amount',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '120',
                          title: '抄表期间',
                          field: 'meterperiod',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '60',
                          title: '折月',
                          field: 'convertmonth',
                          halign: 'center',
                          align: 'center'
                      }]
                ],
                toolbar: '#agTip',
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
                    ////提示框
                    $(this).datagrid('tooltip', ['roomname']);
                },
                onDblClickRow: function (index, row) {
                    viewRetainStationLastElecDetail(row.id);
                }
            });
            //设置分页属性
            var pager = $('#RetainStationLastElecLEGrid').datagrid('getPager');
            pager.pagination({
                layout: ['list', 'sep', 'first', 'prev', 'sep', 'links', 'sep', 'next', 'last', 'sep', 'refresh', 'sep', 'manual']
            });
            if (roleid != 4 && roleid != 20 )
                $('#RetainStationLastElecLEGrid').datagrid('hideColumn', 'action');
        });
    </script>
</head>
<body class="easyui-layout">
    <div id="agTip">
        <form id="searchForm" style="margin: 0;">
            <table>
                <tr>
                    <td style="width: 80px; font-weight: 700;">数据查询：</td>
                    <%if (roleid != 15)
                      { %>
                    <td style="width: 70px; text-align: right;">所属县市：
                    </td>
                    <td>
                        <select id="cityname" class="combo easyui-combobox" name="cityname" style="width: 70px;" data-options="panelHeight:'auto',editable:false">
                             <%if (roleid == 20 || roleid == 21)
                                {
                                    if (Session["deptname"].ToString() == "网络维护中心")
                                        Response.Write("<option>市区</option>");
                                    else if (Session["deptname"].ToString() == "林州市")
                                        Response.Write("<option>林州</option>");
                                    else Response.Write("<option>" + Session["deptname"] + "</option>");
                                }
                                else
                                {
                                        %>
                           
                            <option value="">全部</option>
                            <option>市区</option>
                            <option>安阳县</option>
                            <option>汤阴县</option>
                            <option>内黄县</option>
                            <option>滑县</option>
                            <option>林州</option>
                            <%} %>
                        </select>
                    </td>
                    <%} %>
                    <td style="width: 80px; text-align: right;">站址编号：</td>
                    <td>
                        <input style="width: 160px; height: 20px" type="text" class="combo" name="stationid" />
                    </td>
                   <td style="width: 80px; text-align: right;">基站名称：</td>
                    <td>
                        <input style="width: 160px; height: 20px" type="text" class="combo" name="stationname" />
                    </td>
                </tr>
                <tr><td style="width: 80px; font-weight: 700;"> </td>
                    <td style="width: 70px; text-align: right;">缴费年月：
                    </td>
                    <td>
                        <input style="width: 80px;" name="paymentyear" id="paymentyear" class="Wdate" onfocus="WdatePicker({dateFmt:'yyyy'})" readonly="readonly" />
                    </td>
                      <td style="width: 80px; text-align: right;">供电方式：
                    </td>
                    <td style="text-align: left;">
                        <select id="electype" class="combo easyui-combobox" name="electype" style="width: 60px;" data-options="panelHeight:'auto',editable:false">
                            <option value="">全部</option>
                            <option>直供电</option>
                            <option>转供电</option>
                        </select>
                    </td>
                  
                    <td colspan="4">
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier',plain:true"
                            onclick="searchGrid();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier_zoom_out',plain:true"
                            onclick="resetGrid();">重置</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-table_go',plain:true"
                            onclick="exportRetainStationLastElec();">导出</a>
                        <%if (roleid == 20||roleid == 4)
                            { %>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-table_row_insert',plain:true"
                            onclick="importResources();">导入数据</a><%} %>
                       <%-- <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true"
                            onclick="addResources();">新增</a>--%>
                        <%--} --%>
                    </td>
                </tr>
            </table>
        </form>
         <div style="background: url(../Script/easyui/themes/icons/tip.png) no-repeat 10px 5px; line-height: 24px; padding-left: 30px;">
        双击每条记录查看详细信息
    </div>
    </div>
    <div data-options="region:'center',fit:true,border:false">
        <p class="sitepath">
            <b>当前位置：</b>能耗事项管理 > <a href="javascript:void(0);">保留基站上年度电费</a>
        </p>
        <table id="RetainStationLastElecLEGrid" data-options="fit:false,border:false">
        </table>
    </div>
</body>
</html>
