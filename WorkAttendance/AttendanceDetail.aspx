<%@ Page Language="C#" %>

<!DOCTYPE html>
<html>
<head>
    <title>员工考勤管理——签到明细</title>
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
        //查询功能
        var searchGrid = function () {
            detailGrid.datagrid('load', $.serializeObject($('#searchForm')));
        };
        //重置查询
        var resetGrid = function () {
            $('#searchForm').form('reset');
            detailGrid.datagrid('load', {});
        };
        //签到明细
        var detailGrid;
        $(function () {
            detailGrid = $('#detailGrid').datagrid({
                title: '员工签到明细',
                url: '../ajax/Srv_Attendance.ashx/GetAttendanceDetail',
                striped: true,
                rownumbers: true,
                pagination: true,
                noheader: true,
                pageSize: 20,
                singleSelect: true,
                idField: 'id',
                sortName: 'teamname',
                sortOrder: 'asc',
                columns: [
                  [
                        {
                            width: '100',
                            title: '班组',
                            field: 'teamname',
                            sortable: true,
                            halign: 'center',
                            align: 'center'
                        },
                      {
                          width: '80',
                          title: '姓名',
                          field: 'empname',
                          halign: 'center',
                          align: 'center'
                      },
                      {
                          width: '120',
                          title: '手机号',
                          field: 'emptel',
                          halign: 'center',
                          align: 'center'
                      }
                      , {
                          width: '160',
                          title: '签到点名称',
                          field: 'signpoint',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '60',
                          title: '类型',
                          field: 'signtype',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '200',
                          title: 'GPS地址',
                          field: 'gps',
                          halign: 'center',
                          align: 'center'
                      },
                      {
                          width: '140',
                          title: '签到时间',
                          field: 'signtime',
                          halign: 'center',
                          align: 'center'
                      }, {
                          width: '230',
                          title: '备注',
                          field: 'memo',
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
                }
            });
            //设置分页属性
            var pager = $('#detailGrid').datagrid('getPager');
            pager.pagination({
                layout: ['list', 'sep', 'first', 'prev', 'sep', 'links', 'sep', 'next', 'last', 'sep', 'refresh', 'sep', 'manual']
            });
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
                        <input style="width: 80px;" name="sdate" id="sdate" class="Wdate" onfocus="WdatePicker({maxDate:'#F{$dp.$D(\'edate\')}',maxDate:'%y-%M-%d'})"
                            readonly="readonly" />-<input style="width: 80px;" name="edate" id="edate" class="Wdate"
                                onfocus="WdatePicker({minDate:'#F{$dp.$D(\'sdate\')}',maxDate:'%y-%M-%d'})" readonly="readonly" />
                    </td>
                    <td style="width: 40px; text-align: right;">班组：
                    </td>
                    <td>
                        <select id="teamname" class="combo easyui-combobox" name="teamname"  data-options="panelHeight:'auto',editable:false">
                            <option value="">全部</option>
                            <option>96480班组</option>
                            <option>工单处理班</option>
                            <option>技术与资料组</option>
                            <option>装维服务组</option>
                            <option>资源管理班</option>
                            <option>北关基层单元</option>
                            <option>东区基层单元</option>
                            <option>红旗基层单元</option>
                            <option>开发区基层单元</option>
                            <option>铁西基层单元</option>
                            <option>文峰基层单元</option>
                        </select>
                    </td>
                    <td style="width: 40px; text-align: right;">姓名：</td>
                    <td>
                        <input style="width: 80px; height: 20px" type="text" class="combo" name="empname" />
                    </td>
                    <td>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier',plain:true"
                            onclick="searchGrid();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier_zoom_out',plain:true"
                            onclick="resetGrid();">重置</a>
                    </td>
                </tr>
            </table>
        </form>
    </div>
    <div data-options="region:'center',fit:true,border:false">
        <p class="sitepath">
            <b>当前位置：</b>员工考勤管理 > <a href="javascript:void(0);">签到明细</a>
        </p>
        <table id="detailGrid" data-options="fit:false,border:false">
        </table>
    </div>
</body>
</html>
