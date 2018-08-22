<%@ Page Language="C#" AutoEventWireup="true" CodeFile="right.aspx.cs" Inherits="right" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>运维信息管理系统</title>
    <link type="text/css" href="css/style.css" rel="Stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <h4 class="ta_c  pt_20">
            欢迎使用运维信息管理系统</h4>
        <table align="center" width="96%" cellspacing="1" cellpadding="3" border="0" class="tableborder">
            <tbody>
                <tr class="header">
                    <td height="25">
                        我的状态
                    </td>
                </tr>
                <tr>
                    <td height="25" bgcolor="#FFFFFF">
                        <table  width="96%" cellspacing="0" cellpadding="0" border="0" style="text-align:left;" >
                            <tbody>
                                <tr>
                                    <td height="22">
                                        当前用户:&nbsp;<b>
                                            <%=Session["uname"] %>
                                        </b>&nbsp;&nbsp;,所在单位:&nbsp;<b><%=Session["deptname"] %>
                                        </b>&nbsp;&nbsp;,所在岗位:&nbsp;<b><%=SZGW %>
                                        </b>
                                    </td>
                                </tr>
                                <tr>
                                    <td height="22" >
                                        <b>工作提醒</b>：<span id="gztx" runat="server">没有工作提醒</span>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
            </tbody>
        </table>
        <br />
        <br />
        <table align="center"  <%=isUnitKG||isUnitPQ||isUnitPQLL|| isAN || isNetCard?"style='display:none'":"" %> width="96%" cellspacing="1" cellpadding="3" border="0" class="tableborder">
            <tbody>
                <tr class="header">
                    <td width="100%" height="25">
                        <table width="100%" cellspacing="0" cellpadding="0" border="0">
                            <tbody>
                                <tr>
                                    <td width="50%">
                                        <strong>快捷菜单</strong>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
              <%-- 
               <tr <%=isEC||isAdmin||isYW?"":"style='display:none'" %>>
                    <td height="25" bgcolor="#FFFFFF" >
                        <strong>能耗台账管理</strong>：&nbsp;&nbsp;
                            <a href="EnergyConsumption/AccessStationElec.aspx?token=<%=token %>" >接入网机房月度电费</a>&nbsp;&nbsp;
                            <a href="EnergyConsumption/AccessStationLastElec.aspx?token=<%=token %>" >接入网机房上年电费</a>&nbsp;&nbsp;
                            <a href="EnergyConsumption/AccessStationInfo.aspx?token=<%=token %>" >接入网机房动力信息</a>
                    </td>
                </tr>
               <tr <%=isEC||isAdmin||isYW?"":"style='display:none'" %>>
                    <td height="25" bgcolor="#FFFFFF" >
                        <strong>客户接入物料管理</strong>：&nbsp;&nbsp;
                            <a href="CustomAccess/UnitStockMana.aspx?token=<%=token %>" >客户接入库存管理</a>&nbsp;&nbsp;
                            <a href="CustomAccess/UnitInStockDetail.aspx?token=<%=token %>" >物料入库明细</a>&nbsp;&nbsp;
                            <a href="CustomAccess/UnitOutStockDetail.aspx?token=<%=token %>" >领料明细</a>&nbsp;&nbsp;
                            <a href="CustomAccess/wlxh.aspx?token=<%=token %>" >物料型号管理</a>&nbsp;&nbsp;
                            <a href="CustomAccess/UnitArea.aspx?token=<%=token %>" >营业部信息管理</a>
                    </td>
                </tr>
                 <tr <%=isEC||isAdmin||isYW?"":"style='display:none'" %>>
                    <td height="25" bgcolor="#FFFFFF" >
                        <strong>接入网资源管理</strong>：&nbsp;&nbsp;
                            <a href="AccessNetwork/RoomResources.aspx?token=<%=token %>" >机房资源管理</a>&nbsp;&nbsp;
                            <a href="AccessNetwork/EquipmentInfo.aspx?token=<%=token %>" >设备信息管理</a>&nbsp;&nbsp;
                            <a href="AccessNetwork/LeaseContract.aspx?token=<%=token %>" >租赁合同台账</a>&nbsp;&nbsp;
                    </td>
                </tr>--%>
              
            </tbody>
        </table>
    </div>
    </form>
</body>
</html>
