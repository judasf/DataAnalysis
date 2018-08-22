<%@ Page Language="C#" %>

<style type="text/css">
    #detailTable td, #detailTable th { padding: 7px 2px; }

    #detailTable .tdinput { text-align: left; }

    #detailTable .left_td { text-align: right; background: #fafafa; width: 190px; }
</style>
<% 
    /** 
     *查看领取物料的维修用料明细
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
        drawMaterialGrid.datagrid('load', $.serializeObject($('#searchForm')));
    };
    //重置查询
    var resetGrid = function () {
        $('#searchForm').form('reset');
        drawMaterialGrid.datagrid('load', {});
    };
    //导出当前物料使用明细excel
    var exportMaterialInfo = function () {
        jsPostForm('../ajax/Srv_StandingBook.ashx/ExportStockDrawMaterialInfo?id=' + $('#id').val(), $.serializeObject($('#searchForm')));
    };

    //领用物料在日常维修台账中的使用明细
    var drawMaterialGrid;
    $(function () {
        drawMaterialGrid = $('#drawMaterialGrid').datagrid({
            title: '用料明细',
            url: '../ajax/Srv_StandingBook.ashx/GetStockDrawMaterialInfo?id=' + $('#id').val(),
            striped: true,
            rownumbers: true,
            pagination: true,
            noheader: true,
            showFooter: true,
            pageSize: 10,
            singleSelect: true,
            idField: 'c.id',
            sortName: 'c.id',
            sortOrder: 'desc',
            columns: [
              [
                  {
                      width: '100',
                      title: '维修单号',
                      field: 'repairorderno',
                      halign: 'center',
                      align: 'center'
                  }, {
                      width: '80',
                      title: '维修日期',
                      field: 'repairdate',
                      halign: 'center',
                      align: 'center'
                  }, {
                      width: '140',
                      title: '机房名称',
                      field: 'roomname',
                      halign: 'center',
                      align: 'center'
                  }, {
                      width: '190',
                      title: '维修地点',
                      field: 'repairplace',
                      halign: 'center',
                      align: 'center'
                  }
                 , {
                     width: '160',
                     title: '维修事项',
                     field: 'repairitem',
                     halign: 'center',
                     align: 'center'
                 }, {
                     width: '120',
                     title: '物料型号',
                     field: 'typename',
                     halign: 'center',
                     align: 'center'
                 }, {
                     width: '60',
                     title: '用料数量',
                     field: 'amount',
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
                $(this).datagrid('tooltip', ['roomname', 'repairplace', 'repairitem','typename']);
            }
        });
        //设置分页属性
        var pager = $('#drawMaterialGrid').datagrid('getPager');
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
                <td style="width: 45px; text-align: right;">日期：
                </td>
                <td>

                    <input style="width: 80px;" name="sdate" id="sdate" class="Wdate" onfocus="WdatePicker({maxDate:'#F{$dp.$D(\'edate\')}',maxDate:'%y-%M-%d'})" readonly="readonly" />-<input style="width: 80px;" name="edate" id="edate" class="Wdate"
                        onfocus="WdatePicker({minDate:'#F{$dp.$D(\'sdate\')}',maxDate:'%y-%M-%d'})" readonly="readonly" />
                </td>
                <td style="width: 80px; text-align: right;">机房名称：</td>
                <td>
                    <input style="width: 160px; height: 20px" type="text" class="combo" name="roomname" />
                </td>
            </tr>
            <tr>

                <td style="width: 80px; text-align: right;">维修单号：</td>
                <td style="text-align: left;">
                    <input style="width: 160px; height: 20px" type="text" class="combo" name="repairorderno" />
                </td>
                <td colspan="6" style="text-align: left;">
                    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier',plain:true"
                        onclick="searchGrid();">查询</a>
                    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-magifier_zoom_out',plain:true"
                        onclick="resetGrid();">重置</a>
                    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-table_go',plain:true"
                        onclick="exportMaterialInfo();">导出</a>
                </td>
            </tr>
        </table>
    </form>
</div>
<table id="drawMaterialGrid" data-options="fit:true,border:false">
</table>
