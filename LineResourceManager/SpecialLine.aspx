<%@ Page Language="C#" %>

<!DOCTYPE html>
<html>
<head>
    <title>专线客户光缆</title>
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
                height: 530,
                iconCls: 'icon-add',
                href: 'LineResourceManager/Dialog/SpecialLine_OP.aspx',
                buttons: [{
                    text: '提交',
                    handler: function () {
                        parent.onFormSubmit(dialog, slGrid);
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
                        parent.onFormSubmit(dialog, slGrid);
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
        //查看工单
        var viewOrderDetail = function (id) {
            var btns = [{
                text: '关闭',
                handler: function () {
                    dialog.dialog('close');
                }
            }];
            var dialog = parent.$.modalDialog({
                title: '专线客户光缆详情',
                width: 600,
                height: 600,
                iconCls: 'ext-icon-page',
                href: 'LineResourceManager/Dialog/ViewSpecialLineDetail_OP.aspx?id=' + id,
                buttons: btns
            });
        };
        ///施工回单
        var receiptOrder = function (id) {
            var dialog = parent.$.modalDialog({
                title: '施工回单',
                width: 600,
                height: 600,
                iconCls: 'ext-icon-page',
                href: 'LineResourceManager/Dialog/SpecialLineReceipt_OP.aspx?id=' + id,
                buttons: [{
                    text: '提交',
                    handler: function () {
                        parent.onFormSubmit(dialog, slGrid);
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
            slGrid.datagrid('load', $.serializeObject($('#slslsearchForm')));
        };
        //重置查询
        var resetGrid = function () {
            $('#slsearchForm').form('reset');
            slGrid.datagrid('load', {});
        };
        //导出专线客户光缆明细excel
        var exportSpecialLine = function () {
            jsPostForm('../ajax/Srv_LineResource.ashx/ExportSpecialLine', $.serializeObject($('#slsearchForm')));
        };
        //专线客户光缆台账
        var slGrid;
        $(function () {
            slGrid = $('#slGrid').datagrid({
                title: '专线客户光缆台账',
                url: '../ajax/Srv_LineResource.ashx/GetSpecialLine',
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
                               if (roleid == 19 || roleid == 0) {//工单管理查看详情
                                   str += $.formatString('<a href="javascript:void(0)" onclick="viewOrderDetail(\'{0}\');">详情</a>&nbsp;', row.id);
                               }

                               if (roleid == 3) { //施工单位（浩翔，中通服），施工操作
                                   if (row.receipttime.length == 0)//待回单
                                       str += $.formatString('<a href="javascript:void(0)" onclick="receiptOrder(\'{0}\');">回单</a>&nbsp;', row.id);
                                   else
                                       str += $.formatString('<a href="javascript:void(0)" onclick="viewOrderDetail(\'{0}\');">详情</a>&nbsp;', row.id);
                               }
                               return str;
                           }
                       }, {
                           width: '80',
                           title: '派单日期',
                           field: 'inputdate',
                           halign: 'center',
                           align: 'center'
                       }, {
                           width: '80',
                           title: '业务类型',
                           field: 'bussinesstype',
                           halign: 'center',
                           align: 'center'
                       }, {
                           width: '160',
                           title: '计费编码',
                           field: 'chargingcode',
                           halign: 'center',
                           align: 'center'
                       },
                      {
                          width: '120',
                          title: '客户名称',
                          field: 'customername',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '200',
                          title: '安装地址',
                          field: 'address',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '120',
                          title: '客户联系人',
                          field: 'customercontact',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '100',
                          title: '客户电话',
                          field: 'customerphone',
                          halign: 'center',
                          align: 'center'
                      }
                      , {
                          width: '120',
                          title: '联通客户经理',
                          field: 'customermanager',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '80',
                          title: '局向',
                          field: 'direction',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '220',
                          title: '指定路由',
                          field: 'route',
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
                          title: '录入人',
                          field: 'username',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '220',
                          title: '回单路由',
                          field: 'receiptroute',
                          halign: 'center',
                          align: 'center'
                      }
                      , {
                          width: '120',
                          title: '回单时间',
                          field: 'receipttime',
                          halign: 'center',
                          align: 'center'
                      }
                  ]
                ],
                toolbar: '#slTip',
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
                    $(this).datagrid('tooltip', ['customername', 'address', 'route']);
                },
                onDblClickRow: function (index, row) {
                    viewOrderDetail(row.id);
                }
            });
            //设置分页属性
            var pager = $('#slGrid').datagrid('getPager');
            pager.pagination({
                layout: ['list', 'sep', 'first', 'prev', 'sep', 'links', 'sep', 'next', 'last', 'sep', 'refresh', 'sep', 'manual']
            });
            //if (roleid != 0)
            //    $('#slGrid').datagrid('hideColumn', 'action');
        });
    </script>
</head>
<body class="easyui-layout">
    <div id="slTip">
        <form id="slsearchForm" style="margin: 0;">
            <table>
                <tr>
                    <td style="width: 80px; font-weight: 700;">数据查询：</td>
                    <td style="width: 45px; text-align: right;">日期：
                    </td>
                    <td>
                        <input style="width: 80px;" name="sdate" id="sdate" class="Wdate" onfocus="WdatePicker({maxDate:'#F{$dp.$D(\'edate\')}',maxDate:'%y-%M-%d'})" readonly="readonly" />-<input style="width: 80px;" name="edate" id="edate" class="Wdate"
                            onfocus="WdatePicker({minDate:'#F{$dp.$D(\'sdate\')}',maxDate:'%y-%M-%d'})" readonly="readonly" />
                    </td>

                    <td style="width: 80px; text-align: right;">业务类型：</td>
                    <td>
                        <input style="width: 160px; height: 20px" type="text" class="combo" name="bussinesstype" />
                    </td>

                    <td style="width: 80px; text-align: right;">计费编码：</td>
                    <td>
                        <input style="width: 160px; height: 20px" type="text" class="combo" name="chargingcode" />
                    </td>

                </tr>
                <tr>
                    <td></td>
                    <td style="width: 80px; text-align: right;">局向：</td>
                    <td>
                        <input style="width: 160px; height: 20px" type="text" class="combo" name="direction" />
                    </td>

                    <td style="width: 80px; text-align: right;">施工单位：
                    </td>
                    <td>
                        <select id="constructionunit" style="width: 100px;" class="combo easyui-combobox" name="constructionunit" data-options="panelHeight:'auto',editable:false">
                            <option value="">全部</option>
                            <option>浩翔</option>
                            <option>中通服</option>
                            <option>长线局</option>
                        </select>
                    </td>
                    <td colspan="2" style="text-align: left;">
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier',plain:true"
                            onclick="searchGrid();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier_zoom_out',plain:true"
                            onclick="resetGrid();">重置</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-table_go',plain:true"
                            onclick="exportSpecialLine();">导出</a>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td colspan="6" style="text-align: left;">
                        <%if (roleid == 19)
                            { %>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:false"
                            onclick="addOrder();">工单录入</a>
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
            <b>当前位置：</b>线路资源管理 > <a href="javascript:void(0);">专线客户光缆管理</a>
        </p>
        <table id="slGrid" data-options="fit:false,border:false">
        </table>
    </div>
</body>
</html>
