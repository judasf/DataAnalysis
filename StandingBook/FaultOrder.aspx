﻿<%@ Page Language="C#" %>

<!DOCTYPE html>
<html>
<head>
    <title>故障工单台账</title>
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
        //新增
        var addOrder = function () {
            var dialog = parent.$.modalDialog({
                title: '新增',
                width: 600,
                height: 600,
                iconCls: 'icon-add',
                href: 'StandingBook/Dialog/FaultOrder_OP.aspx',
                buttons: [{
                    text: '提交',
                    handler: function () {
                        parent.onFormSubmit(dialog, orderGrid);
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
        var editOrder = function (id) {
            var dialog = parent.$.modalDialog({
                title: '编辑',
                width: 600,
                height: 600,
                iconCls: 'icon-edit',
                href: 'StandingBook/Dialog/FaultOrder_OP.aspx?id=' + id,
                buttons: [{
                    text: '保存',
                    handler: function () {
                        parent.onFormSubmit(dialog, orderGrid);
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
        //删除
        var removeFun = function (orderno) {
            parent.$.messager.confirm('询问', '您确定要删除该故障信息？', function (r) {
                if (r) {
                    $.post('../ajax/Srv_StandingBook.ashx/RemoveFaultOrderByOrderNo', {
                        orderno: orderno
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
                            orderGrid.datagrid('reload');
                        } else {
                            parent.$.messager.alert('提示', result.msg, 'error');
                        }
                    }, 'json');
                }
            });
        };
        //查看工单
        var viewOrderDetail = function (id) {
            var btns = [{
                text: '关闭',
                handler: function () {
                    dialog.dialog('close');
                }
            }];
            //if (roleid == 4 || roleid == 15)
            //    btns.unshift({
            //        text: '编辑',
            //        handler: function () {
            //            dialog.dialog('close');
            //            editOrder(id);
            //        }
            //    });
            var dialog = parent.$.modalDialog({
                title: '故障工单详情',
                width: 600,
                height: 600,
                iconCls: 'ext-icon-page',
                href: 'StandingBook/Dialog/ViewFaultOrderDetail_OP.aspx?id=' + id,
                buttons: btns
            });
        };
        //查询功能
        var searchGrid = function () {
            orderGrid.datagrid('load', $.serializeObject($('#searchForm')));
        };
        //重置查询
        var resetGrid = function () {
            $('#searchForm').form('reset');
            orderGrid.datagrid('load', {});
        };
        //导出故障工单明细excel
        var exportFaultOrder = function () {
            jsPostForm('../ajax/Srv_StandingBook.ashx/ExportFaultOrder', $.serializeObject($('#searchForm')));
        };
        //生成领料单word
        var exportToWord = function () {
            var row = orderGrid.datagrid('getSelected');
            if (!row) {
                parent.$.messager.alert('提示', '请选择一条维修台账！', 'error');
            }
            else
                jsPostForm('../ajax/Srv_StandingBook.ashx/ExportWordByID', { id: row.id });
        };
        //故障工单台账
        var orderGrid;
        $(function () {
            orderGrid = $('#orderGrid').datagrid({
                title: '故障工单台账',
                url: '../ajax/Srv_StandingBook.ashx/GetFaultOrder',
                striped: true,
                rownumbers: true,
                pagination: true,
                noheader: true,
                pageSize: 20,
                singleSelect: true,
                idField: 'id',
                sortName: 'id',
                sortOrder: 'desc',
                columns: [
                  [
                       {
                           title: '操作',
                           field: 'action',
                           width: '75',
                           halign: 'center',
                           formatter: function (value, row) {
                               var str = '';
                               //str += $.formatString('<a href="javascript:editOrder(\'{0}\');" title="编辑" style="cursor:pointer;" >编辑</a>&nbsp;&nbsp;&nbsp;&nbsp;', row.id);
                               str += $.formatString('<a href="javascript:removeFun(\'{0}\');" title="删除" style="cursor:pointer;" >删除</a>', row.faultorderno);
                               return str;
                           }
                       }, {
                           width: '120',
                           title: '故障单号',
                           field: 'faultorderno',
                           halign: 'center',
                           align: 'center'
                       }, {
                           width: '80',
                           title: '故障日期',
                           field: 'faultdate',
                           halign: 'center',
                           align: 'center'
                       }, {
                           width: '160',
                           title: '局站编码',
                           field: 'stationid',
                           halign: 'center',
                           align: 'center'
                       },
                      {
                          width: '200',
                          title: '机房名称',
                          field: 'roomname',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '180',
                          title: '故障地点',
                          field: 'faultplace',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '单位    ',
                          field: 'cityname',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '100',
                          title: '维修单号',
                          field: 'repairorderno',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '60',
                          title: '网点类别',
                          field: 'pointtype',
                          halign: 'center',
                          align: 'center'
                      }
                      , {
                          width: '120',
                          title: '设备类型',
                          field: 'eqtype',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '120',
                          title: '设备型号',
                          field: 'eqmodel',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '180',
                          title: '故障现象',
                          field: 'faultmsg',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '是否外包范围',
                          field: 'inscope',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '报障人',
                          field: 'faultuser',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '确认人',
                          field: 'confirmuser',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '140',
                          title: '确认单扫描件',
                          field: 'confirmordername',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '备注',
                          field: 'memo',
                          halign: 'center',
                          align: 'center'
                      }
                      , {
                          width: '80',
                          title: '录单日期',
                          field: 'inputdate',
                          halign: 'center',
                          align: 'center'
                      }
                      , {
                          width: '80',
                          title: '录单人',
                          field: 'inputuser',
                          halign: 'center',
                          align: 'center'
                      }
                  ]
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
                    $(this).datagrid('tooltip', ['roomname', 'address', 'contractno']);
                },
                onDblClickRow: function (index, row) {
                    viewOrderDetail(row.id);
                }
            });
            //设置分页属性
            var pager = $('#orderGrid').datagrid('getPager');
            pager.pagination({
                layout: ['list', 'sep', 'first', 'prev', 'sep', 'links', 'sep', 'next', 'last', 'sep', 'refresh', 'sep', 'manual']
            });
            if (roleid != 0)
                $('#orderGrid').datagrid('hideColumn', 'action');
        });
    </script>
</head>
<body class="easyui-layout">
    <div id="agTip">
        <form id="searchForm" style="margin: 0;">
            <table>
                <tr>
                    <td style="width: 80px; font-weight: 700;">数据查询：</td>
                    <td style="width: 45px; text-align: right;">日期：
                    </td>
                    <td>
                        <input style="width: 80px;" name="sdate" id="sdate" class="Wdate" onfocus="WdatePicker({maxDate:'#F{$dp.$D(\'edate\')}',maxDate:'%y-%M-%d'})" readonly="readonly" />-<input style="width: 80px;" name="edate" id="edate" class="Wdate"
                            onfocus="WdatePicker({minDate:'#F{$dp.$D(\'sdate\')}',maxDate:'%y-%M-%d'})" readonly="readonly" />
                    </td>
                    <%if ((roleid ==0 || roleid==4))
                        { %>
                    <td style="width: 80px; text-align: right;">单位：
                    </td>
                    <td>
                        <select style="width: 120px;" id="cityname" class="combo easyui-combobox" name="cityname" data-options="panelHeight:'auto',editable:false">
                            <option value="">全部</option>
                            <option>网络部</option>
                            <option>客户支撑中心</option>
                            <option>网络管理中心</option>
                            <option>网络优化/客户响应中心</option>
                            <option>安阳县</option>
                            <option>汤阴县</option>
                            <option>内黄县</option>
                            <option>滑县</option>
                            <option>林州市</option><option>集客支撑网格</option>
                        </select>
                    </td>
                    <%} %>
                    <td style="width: 80px; text-align: right;">机房名称：</td>
                    <td>
                        <input style="width: 160px; height: 20px" type="text" class="combo" name="roomname" />
                    </td>
                    <td style="width: 80px; text-align: right;">局站编码：</td>
                    <td>
                        <input style="width: 160px; height: 20px" type="text" class="combo" name="stationid" />
                    </td>
                    
                </tr>
                <tr>
                    <td></td>
                    <td style="width: 80px; text-align: right;">故障单号：</td>
                    <td style="text-align:left;">
                        <input style="width: 160px; height: 20px" type="text" class="combo" name="faultorderno" />
                    </td>
                     <td style="width: 80px; text-align: right;">设备类型：
                    </td>
                    <td style="text-align: left;">
                        <select id="eqtype" class="easyui-combobox" name="eqtype" style="width: 120px;" data-options="panelHeight:'auto',editable:false">
                            <option value="">全部</option>
                            <option>光缆线路</option>
                            <option>空调</option>
                            <option>发电机</option>
                            <option>其他</option>
                        </select>
                    </td>
                       <td style="width: 80px; text-align: right;">是否维修：
                    </td>
                    <td style="text-align: left;">
                        <select id="isrepaire" class="easyui-combobox" name="isrepaire" style="width: 120px;" data-options="panelHeight:'auto',editable:false">
                            <option value="">全部</option>
                            <option>是</option>
                            <option>否</option>
                        </select>
                    </td>
                </tr>
                 <tr>
                    <td></td>
                     <td colspan="6" style="text-align: left;">
                         <%if (roleid == 18 || roleid == 21 || roleid == 20 || roleid == 4)
                            { %>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:false"
                            onclick="addOrder();">新增障碍工单</a>
                        <%} %>
                          <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier',plain:true"
                            onclick="searchGrid();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier_zoom_out',plain:true"
                            onclick="resetGrid();">重置</a>
                         <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-table_go',plain:true"
                            onclick="exportFaultOrder();">导出</a>
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
            <b>当前位置：</b>故障维修台账管理 > <a href="javascript:void(0);">故障工单管理</a>
        </p>
        <table id="orderGrid" data-options="fit:false,border:false">
        </table>
    </div>
</body>
</html>
