<%@ Page Language="C#" %>

<!DOCTYPE html>
<html>
<head>
    <title>线路延伸管理</title>
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
                width: 530,
                height: 440,
                iconCls: 'icon-add',
                href: 'LineResourceManager/Dialog/LineExtension_OP.aspx',
                buttons: [{
                    text: '提交',
                    handler: function () {
                        parent.onFormSubmit(dialog, leGrid);
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
        /*
        //编辑
        var editOrder = function (id) {
            var dialog = parent.$.modalDialog({
                title: '编辑',
                width: 600,
                height: 600,
                iconCls: 'icon-edit',
                href: 'LineResourceManager/Dialog/FaultOrder_OP.aspx?id=' + id,
                buttons: [{
                    text: '保存',
                    handler: function () {
                        parent.onFormSubmit(dialog, leGrid);
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
        */
        //删除
        var removeFun = function (id) {
            parent.$.messager.confirm('询问', '您确定要需求单信息？', function (r) {
                if (r) {
                    $.post('../ajax/Srv_LineResource.ashx/RemoveLineResourceById', {
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
                            leGrid.datagrid('reload');
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
                title: '线路延伸详情',
                width: 600,
                height: 600,
                iconCls: 'ext-icon-page',
                href: 'LineResourceManager/Dialog/ViewLineExtensionDetail_OP.aspx?id=' + id,
                buttons: btns
            });
        };
        //核验上传的施工资料
        var checkFile = function (id) {
            var btns = [{
                text: '完成录入',
                handler: function () {
                    parent.onFormSubmit(dialog, leGrid);
                }
            }, {
                text: '退回施工',
                handler: function () {
                    parent.backToUnit(dialog, leGrid);
                }
            }, {
                text: '关闭',
                handler: function () {
                    dialog.dialog('close');
                }
            }];
            var dialog = parent.$.modalDialog({
                title: '线路延伸详情',
                width: 600,
                height: 600,
                iconCls: 'ext-icon-page',
                href: 'LineResourceManager/Dialog/ViewLineExtensionDetail_OP.aspx?id=' + id,
                buttons: btns
            });
        };
        ///资源核查回单
        var checkResource = function (id) {
            var dialog = parent.$.modalDialog({
                title: '资源核查',
                width: 600,
                height: 600,
                iconCls: 'ext-icon-page',
                href: 'LineResourceManager/Dialog/LineExtensionCheck_OP.aspx?id=' + id,
                buttons: [{
                    text: '提交',
                    handler: function () {
                        parent.onFormSubmit(dialog, leGrid);
                    }
                },
                {
                    text: '关闭',
                    handler: function () {
                        dialog.dialog('close');
                    }
                }
                ]
            });
        };
        ///建设施工回单
        var finishOrder = function (id) {
            var dialog = parent.$.modalDialog({
                title: '建设施工',
                width: 600,
                height: 600,
                iconCls: 'ext-icon-page',
                href: 'LineResourceManager/Dialog/LineExtensionFinish_OP.aspx?id=' + id,
                buttons: [{
                    text: '提交',
                    handler: function () {
                        parent.onFormSubmit(dialog, leGrid);
                    }
                },
                {
                    text: '关闭',
                    handler: function () {
                        dialog.dialog('close');
                    }
                }
                ]
            });
        };
        ///重新上传资料
        var uploadFile = function (id) {
            var dialog = parent.$.modalDialog({
                title: '资料上传',
                width: 600,
                height: 600,
                iconCls: 'ext-icon-page',
                href: 'LineResourceManager/Dialog/LineExtensionUploadFile_OP.aspx?id=' + id,
                buttons: [{
                    text: '提交',
                    handler: function () {
                        parent.onFormSubmit(dialog, leGrid);
                    }
                },
                {
                    text: '关闭',
                    handler: function () {
                        dialog.dialog('close');
                    }
                }
                ]
            });
        };
        //查询功能
        var searchGrid = function () {
            leGrid.datagrid('load', $.serializeObject($('#searchForm')));
        };
        //重置查询
        var resetGrid = function () {
            $('#searchForm').form('reset');
            leGrid.datagrid('load', {});
        };
        //导出线路延伸明细excel
        var exportLineExtension = function () {
            jsPostForm('../ajax/Srv_LineResource.ashx/ExportLineExtension', $.serializeObject($('#searchForm')));
        };
        //线路延伸台账
        var leGrid;
        $(function () {
            leGrid = $('#leGrid').datagrid({
                title: '线路延伸台账',
                url: '../ajax/Srv_LineResource.ashx/GetLineExtension',
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
                           width: '120',
                           halign: 'center',
                           formatter: function (value, row) {
                               var str = '';
                               if (roleid == 1 || roleid == 0) {//工单管理查看详情
                                   str += $.formatString('<a href="javascript:void(0)" onclick="viewOrderDetail(\'{0}\');">详情</a>&nbsp;', row.id);
                               }
                               if (roleid == 8) {//线路主管，核查资源和能否建设
                                   if (row.status == 1)//核查中
                                       str += $.formatString('<a href="javascript:void(0)" onclick="checkResource(\'{0}\');">资源核查</a>&nbsp;', row.id);
                                   else if (row.status == 3)
                                       str += $.formatString('<a href="javascript:void(0)" onclick="checkFile(\'{0}\');">资料核验</a>&nbsp;', row.id);
                                   else
                                       str += $.formatString('<a href="javascript:void(0)" onclick="viewOrderDetail(\'{0}\');">详情</a>&nbsp;', row.id);
                                   str += $.formatString('<a href="javascript:void(0)" onclick="removeFun(\'{0}\');">删除</a>&nbsp;', row.id);
                               }
                               if (roleid == 3) { //施工单位（浩翔，中通服），施工操作
                                   if (row.status == 2)//施工中
                                       str += $.formatString('<a href="javascript:void(0)" onclick="finishOrder(\'{0}\');">建设施工</a>&nbsp;', row.id);
                                   else if (row.status == -3)//资料有误，重新上传
                                       str += $.formatString('<a href="javascript:void(0)" onclick="uploadFile(\'{0}\');">上传资料</a>&nbsp;', row.id);
                                   else
                                       str += $.formatString('<a href="javascript:void(0)" onclick="viewOrderDetail(\'{0}\');">详情</a>&nbsp;', row.id);
                               }
                               return str;
                           }
                       }, {
                           width: '80',
                           title: '当前进度',
                           field: 'status',
                           halign: 'center',
                           align: 'center',
                           formatter: function (value, row, index) {
                               switch (value) {
                                   case '-3':
                                       return '资料有误';
                                       break;
                                   case '-2':
                                       return '施工退回';
                                       break;
                                   case '-1':
                                       return '核查退回';
                                       break;
                                   case '0':
                                       return '待提交'
                                       break;
                                   case '1':
                                       return '核查中'
                                       break;
                                   case '2':
                                       return '施工中'
                                       break;
                                   case '3':
                                       return '已完工'
                                       break;
                                   case '4':
                                       return '已录入'
                                       break;
                               }
                           }
                       }, {
                           width: '80',
                           title: '日期',
                           field: 'inputdate',
                           halign: 'center',
                           align: 'center'
                       }, {
                           width: '80',
                           title: '发起单位',
                           field: 'deptname',
                           halign: 'center',
                           align: 'center'
                       }, {
                           width: '160',
                           title: '宽带账号',
                           field: 'account',
                           halign: 'center',
                           align: 'center'
                       },
                      {
                          width: '200',
                          title: '标准地址',
                          field: 'address',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '100',
                          title: '分纤盒号',
                          field: 'boxno',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '终端数量',
                          field: 'terminalnumber',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '装维经理',
                          field: 'linkman',
                          halign: 'center',
                          align: 'center'
                      }
                      , {
                          width: '100',
                          title: '联系电话',
                          field: 'linkphone',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '100',
                          title: '录入人',
                          field: 'username',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '180',
                          title: '核查信息',
                          field: 'checkinfo',
                          hidden: true,
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '85',
                          title: '核查人',
                          field: 'checkuser',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '90',
                          title: '核查时间',
                          field: 'checktime',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '施工单位',
                          field: 'constructionunit',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '施工信息',
                          field: 'constructioninfo',
                          hidden: true,
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '是否新增PON口',
                          field: 'isaddpon',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '全程路由',
                          field: 'fullroute',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '上报资料',
                          hidden: true,
                          field: 'reportname',
                          halign: 'center',
                          align: 'center'
                      }
                      , {
                          width: '85',
                          title: '回单人',
                          hidden: true,
                          field: 'finishuser',
                          halign: 'center',
                          align: 'center'
                      }
                       , {
                           width: '90',
                           title: '完工时间',
                           field: 'finishtime',
                           halign: 'center',
                           align: 'center'
                       }
                       , {
                           width: '100',
                           title: '资料录入时间',
                           field: 'inputfiletime',
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
                    $(this).datagrid('tooltip', ['roomname', 'address', 'contractno', 'fullroute']);
                },
                onDblClickRow: function (index, row) {
                    viewOrderDetail(row.id);
                }
            });
            //设置分页属性
            var pager = $('#leGrid').datagrid('getPager');
            pager.pagination({
                layout: ['list', 'sep', 'first', 'prev', 'sep', 'links', 'sep', 'next', 'last', 'sep', 'refresh', 'sep', 'manual']
            });
            if (roleid == 5)
                $('#leGrid').datagrid('hideColumn', 'action');
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
                    <%if (roleid == 8 ||roleid == 0)
                        {%>
                    <td style="width: 80px; text-align: right;">发起单位：
                    </td>
                    <td>
                        <select id="deptname" style="width: 100px;" class="combo easyui-combobox" name="deptname" data-options="panelHeight:'auto',editable:false">
                            <option value="">全部</option>
                            <option>北关营销中心</option>
                            <option>红旗营销中心</option>
                            <option>铁西营销中心</option>
                            <option>文峰营销中心</option>
                            <option>客户支撑中心</option>
                        </select>
                    </td>
                    <%} %>
                    <td style="width: 80px; text-align: right;">装维经理：</td>
                    <td>
                        <input style="width: 160px; height: 20px" type="text" class="combo" name="linkman" />
                    </td>

                </tr>
                <tr>
                    <td></td>
                    <td style="width: 80px; text-align: right;">需求进度：</td>
                    <td style="text-align: left;">
                        <input style="width: 160px" name="status" id="status" class="easyui-combobox" data-options="panelHeight:'auto',editable:false,valueField:'value',textField:'text',data:[{'value':'-3','text':'资料有误'},{'value':'-2','text':'施工退回'},{'value':'-1','text':'核查退回'},{'value':'1','text':'核查中'},{'value':'2','text':'施工中'},{'value':'3','text':'已完工'},{'value':'4','text':'已录入'}]" />
                    </td>
                    <%if (roleid == 8 ||roleid == 0)
                        {%>
                    <td style="width: 80px; text-align: right;">施工单位：
                    </td>
                    <td>
                        <select id="constructionunit" style="width: 100px;" class="combo easyui-combobox" name="constructionunit" data-options="panelHeight:'auto',editable:false">
                            <option value="">全部</option>
                            <option>文峰浩翔</option>
                            <option>中通服</option>
                            <option>北关浩翔</option>
                        </select>
                    </td>
                    <%} %>
                    <td colspan="2" style="text-align: left;">
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier',plain:true"
                            onclick="searchGrid();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier_zoom_out',plain:true"
                            onclick="resetGrid();">重置</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-table_go',plain:true"
                            onclick="exportLineExtension();">导出</a>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td colspan="6" style="text-align: left;">
                        <%if (roleid == 1 || roleid == 8)
                            { %>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:false"
                            onclick="addOrder();">需求发起</a>
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
            <b>当前位置：</b>线路资源管理 > <a href="javascript:void(0);">光缆延伸需求管理</a>
        </p>
        <table id="leGrid" data-options="fit:false,border:false">
        </table>
    </div>
</body>
</html>
