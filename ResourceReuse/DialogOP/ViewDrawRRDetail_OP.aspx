<%@ Page Language="C#" %>

<style type="text/css">
    #detailTable td, #detailTable th { padding: 7px 2px; }

    #detailTable .tdinput { text-align: left; }

    #detailTable .left_td { text-align: right; background: #fafafa; width: 190px; }
</style>
<% 
    /** 
     *查看资源领用明细
     * 
     */
    string id = "";
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
        id = string.IsNullOrEmpty(Request.QueryString["id"]) ? "" : Request.QueryString["id"].ToString();
    }
%>
<script type="text/javascript">

    //查询功能
    var searchGrid = function () {
        drawResourcelGrid.datagrid('load', $.serializeObject($('#searchForm')));
    };
    //重置查询
    var resetGrid = function () {
        $('#searchForm').form('reset');
        drawResourcelGrid.datagrid('load', {});
    };
    //资源管理页面显示资源领用明细
    var drawResourcelGrid;
    $(function () {
        drawResourcelGrid = $('#drawResourcelGrid').datagrid({
            title: '领用明细',
            url: '../ajax/Srv_ResourceReuse.ashx/GetDrawResourceInfo?id=' + $('#id').val(),
            striped: true,
            rownumbers: true,
            pagination: true,
            noheader: true,
            showFooter: true,
            pageSize: 10,
            singleSelect: true,
            idField: 'id',
            sortName: 'id',
            sortOrder: 'desc',
            columns: [
              [
                   {
                      width: '80',
                      title: '领用日期',
                      field: 'outdate',
                      halign: 'center',
                      align: 'center'
                  }, {
                      width: '140',
                      title: '领用单位',
                      field: 'receiveunitname',
                      halign: 'center',
                      align: 'center'
                  }, {
                      width: '60',
                      title: '领用数量',
                      field: 'receivenum',
                      halign: 'center',
                      align: 'center'
                  }
                 , {
                     width: '160',
                     title: '用途',
                     field: 'usefor',
                     halign: 'center',
                     align: 'center'
                 }, {
                     width: '80',
                     title: '领用人',
                     field: 'receiveman',
                     halign: 'center',
                     align: 'center'
                 }, {
                     width: '80',
                     title: '联系电话',
                     field: 'receivephone',
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
                $(this).datagrid('clearSelections');
                ////提示框
                $(this).datagrid('tooltip', ['usefor']);
            }
        });
        //设置分页属性
        var pager = $('#drawResourcelGrid').datagrid('getPager');
        pager.pagination({
            layout: ['list', 'sep', 'first', 'prev', 'sep', 'links', 'sep', 'next', 'last', 'sep', 'refresh', 'sep', 'manual']
        });
    });
</script>

<div id="agTip">
    <form id="searchForm" style="margin: 0;">
        <input type="hidden" value="<%=id %>" id="id" />
        <table>
            <tr>
                <td style="width: 60px; text-align: right;">领用日期：
                </td>
                <td>

                    <input style="width: 80px;" name="sdate" id="sdate" class="Wdate" onfocus="WdatePicker({maxDate:'#F{$dp.$D(\'edate\')}',maxDate:'%y-%M-%d'})" readonly="readonly" />-<input style="width: 80px;" name="edate" id="edate" class="Wdate"
                        onfocus="WdatePicker({minDate:'#F{$dp.$D(\'sdate\')}',maxDate:'%y-%M-%d'})" readonly="readonly" />
                </td>
                <td style="width: 80px; text-align: right;">领用单位：</td>
                <td>
                    <input style="width: 160px; height: 20px" type="text" class="combo" name="receivename" />
                </td>
            </tr>
            <tr>

               
                <td colspan="4" style="text-align: left;">
                    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier',plain:true"
                        onclick="searchGrid();">查询</a>
                    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier_zoom_out',plain:true"
                        onclick="resetGrid();">重置</a>
                </td>
            </tr>
        </table>
    </form>
</div>
<table id="drawResourcelGrid" data-options="fit:true,border:false">
</table>
