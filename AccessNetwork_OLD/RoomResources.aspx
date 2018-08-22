<%@ Page Language="C#" %>

<!DOCTYPE html>
<html>
<head>
    <title>接入网资源管理——机房资源管理</title>
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
        bool isMana = true;
        if (Session["uname"] == null || Session["uname"].ToString() == "")
        {%>
    <script type="text/javascript">
        $(function () {
            parent.$.messager.alert('提示', '登陆超时，请重新登陆再进行操作！', 'error', function () {
                parent.location.replace('default.aspx');
            });
        });

    </script>
    <%}
        else
        {
            roleid = int.Parse(Session["roleid"].ToString());
            if (Session["uname"].ToString() == "数据维护班" || Session["uname"].ToString() == "交换维护班" || Session["uname"].ToString() == "无线维护班" || Session["uname"].ToString() == "传输维护班" || Session["uname"].ToString() == "动环维护班" || Session["uname"].ToString() == "网管监控班")
                isMana = false;
    %>
    <script type="text/javascript">
        var roleid = '<%=roleid%>';
        var isMana = '<%=isMana%>';
    </script>
    <%}
    %>
    <script type="text/javascript">
        //新增
        var addResources = function () {
            var dialog = parent.$.modalDialog({
                title: '新增',
                width: 600,
                height: 600,
                iconCls: 'icon-add',
                href: 'AccessNetwork/Dialog/RoomResources_OP.aspx',
                buttons: [{
                    text: '提交',
                    handler: function () {
                        parent.onFormSubmit(dialog, resourcesGrid);
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
        var editResources = function (id) {
            var dialog = parent.$.modalDialog({
                title: '编辑',
                width: 600,
                height: 600,
                iconCls: 'icon-edit',
                href: 'AccessNetwork/Dialog/RoomResources_OP.aspx?id=' + id,
                buttons: [{
                    text: '保存',
                    handler: function () {
                        parent.onFormSubmit(dialog, resourcesGrid);
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
        var removeFun = function (anid) {
            parent.$.messager.confirm('询问', '您确定要删除该机房和设备信息？', function (r) {
                if (r) {
                    $.post('../ajax/Srv_AccessNetwork.ashx/RemoveRoomAndEqResourcesInfoByAnID', {
                        anid: anid
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
                            resourcesGrid.datagrid('reload');
                        } else {
                            parent.$.messager.alert('提示', result.msg, 'error');
                        }
                    }, 'json');
                }
            });
        };
        //导入数据
        var importResources = function () {
            var dialog = parent.$.modalDialog({
                title: '导入数据',
                width: 600,
                height: 230,
                iconCls: 'icon-table_row_insert',
                href: 'AccessNetwork/Dialog/ImportFile_op.aspx',
                buttons: [{
                    text: '导入',
                    handler: function () {
                        parent.onFormSubmit(dialog, resourcesGrid);
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
        //查看机房资源详情
        var viewResourcesDetail = function (id) {
            var btns = [{
                text: '关闭',
                handler: function () {
                    dialog.dialog('close');
                }
            }];
            if (roleid == 4 || roleid == 15)
                btns.unshift({
                    text: '编辑',
                    handler: function () {
                        dialog.dialog('close');
                        editResources(id);
                    }
                });
            var dialog = parent.$.modalDialog({
                title: '机房资源详情',
                width: 600,
                height: 600,
                iconCls: 'ext-icon-page',
                href: 'AccessNetwork/Dialog/ViewRoomResourcesDetail_OP.aspx?id=' + id,
                buttons: btns
            });
        };
        //查询功能
        var searchGrid = function () {
            resourcesGrid.datagrid('load', $.serializeObject($('#searchForm')));
        };
        //重置查询
        var resetGrid = function () {
            $('#searchForm').form('reset');
            resourcesGrid.datagrid('load', {});
        };
        //导出接入网机房资源明细excel
        var exportRoomResources = function () {
            jsPostForm('../ajax/Srv_AccessNetwork.ashx/ExportRoomResources', $.serializeObject($('#searchForm')));
        };
        //机房资源信息台账
        var resourcesGrid;
        $(function () {
            resourcesGrid = $('#resourcesGrid').datagrid({
                title: '机房资源信息台账',
                url: '../ajax/Srv_AccessNetwork.ashx/GetRoomResources',
                striped: true,
                rownumbers: true,
                pagination: true,
                noheader: true,
                pageSize: 20,
                singleSelect: true,
                idField: 'id',
                sortName: 'inputtime',
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
                               str += $.formatString('<a href="javascript:editResources(\'{0}\');" title="编辑" style="cursor:pointer;" >编辑</a>&nbsp;&nbsp;&nbsp;&nbsp;', row.id);
                               str += $.formatString('<a href="javascript:removeFun(\'{0}\');" title="删除" style="cursor:pointer;" >删除</a>', row.anid);
                               return str;
                           }
                       }, {
                           width: '65',
                           title: '接入网编号',
                           field: 'anid',
                           halign: 'center',
                           align: 'center'
                       },
                      {
                          width: '80',
                          title: '机房名称',
                          field: 'roomname',
                          sortable: true,
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '60',
                          title: '所属县市',
                          field: 'cityname',
                          halign: 'center',
                          align: 'center'
                      }
                      , {
                          width: '60',
                          title: '行政区域',
                          field: 'regionname',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '70',
                          title: '接入网级别',
                          field: 'anlevel',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '150',
                          title: '详细地址',
                          field: 'address',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '60',
                          title: '网点类型',
                          field: 'pointtype',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '90',
                          title: '经度',
                          field: 'longitude',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '90',
                          title: '纬度',
                          field: 'dimension',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '60',
                          title: '面积',
                          field: 'area',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '60',
                          title: '产权性质',
                          field: 'propertyright',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '租赁合同编号',
                          field: 'contractno',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '140',
                          title: '合同期限（起止时间）',
                          field: 'contractpriod',
                          halign: 'center',
                          align: 'center'
                      }
                      , {
                          width: '70',
                          title: '租赁合同方',
                          field: 'lessortype',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '75',
                          title: '租金付款方式',
                          field: 'rentpayment',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '60',
                          title: '年租金',
                          field: 'rent',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '100',
                          title: '最近一次交费日期',
                          field: 'lastpaydate',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '60',
                          title: '动环监控',
                          field: 'demstatus',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '动环设备厂家',
                          field: 'demem',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '70',
                          title: '机房平面图',
                          field: 'roomplan',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '机房接地电阻',
                          field: 'roomresistance',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '机房供电方式',
                          field: 'powersupplymode',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '55',
                          title: '电费单价',
                          field: 'electricityprice',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '机房负载电流',
                          field: 'roomloadcurrent',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '70',
                          title: '备注1',
                          field: 'memo1',
                          halign: 'center',
                          align: 'center'
                      }
                      , {
                          width: '70',
                          title: '备注2',
                          field: 'memo2',
                          halign: 'center',
                          align: 'center'
                      }
                      , {
                          width: '70',
                          title: '备注3',
                          field: 'memo3',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '更新日期',
                          field: 'inputdate',
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
                            parent.location.replace('default.aspx');
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
                    viewResourcesDetail(row.id);
                }
            });
            //设置分页属性
            var pager = $('#resourcesGrid').datagrid('getPager');
            pager.pagination({
                layout: ['list', 'sep', 'first', 'prev', 'sep', 'links', 'sep', 'next', 'last', 'sep', 'refresh', 'sep', 'manual']
            });
            if (roleid != 4 && roleid != 15 || (roleid == 15 && isMana.toLowerCase() == 'false'))
                $('#resourcesGrid').datagrid('hideColumn', 'action');
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
                            <option value="">全部</option>
                            <option>安阳市</option>
                            <option>安阳县</option>
                            <option>汤阴县</option>
                            <option>内黄县</option>
                            <option>滑县</option>
                            <option>林州市</option>
                        </select>
                    </td>
                    <%} %>
                    <td style="width: 80px; text-align: right;">接入网编号：</td>
                    <td>
                        <input style="width: 80px; height: 20px" type="text" class="combo" name="anid" />
                    </td>

                    <td style="width: 80px; text-align: right;">接入网级别：
                    </td>
                    <td>
                        <select id="anlevel" class="combo easyui-combobox" name="anlevel" style="width: 60px;" data-options="panelHeight:'auto',editable:false">
                            <option value="">全部</option>
                            <option>C1</option>
                            <option>C2</option>
                            <option>C3</option>
                        </select>
                    </td>
                    <%if (roleid != 15)
                      { %>
                    <td style="width: 40px; text-align: right;">状态：
                    </td>
                    <td>
                        <select id="status" class="combo easyui-combobox" name="status" style="width: 60px;" data-options="panelHeight:'auto',editable:false">
                            <option value="0" selected>使用中</option>
                            <option value="1">已删除</option>
                        </select>
                    </td>
                    <%} %>
                    <td>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier',plain:true"
                            onclick="searchGrid();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier_zoom_out',plain:true"
                            onclick="resetGrid();">重置</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-table_go',plain:true"
                            onclick="exportRoomResources();">导出</a>
                        <%if ((roleid == 15 && isMana) || roleid == 4)
                          { %>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-table_row_insert',plain:true"
                            onclick="importResources();">导入数据</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true"
                            onclick="addResources();">新增机房</a>
                        <%} %>
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
            <b>当前位置：</b>接入网资源管理 > <a href="javascript:void(0);">机房资源管理</a>
        </p>
        <table id="resourcesGrid" data-options="fit:false,border:false">
        </table>
    </div>
</body>
</html>
