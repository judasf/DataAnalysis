﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="yjylllxxxq.aspx.cs" Inherits="yjylllxxxq" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>客户接入事项管理</title>
    <style type="text/css">
        #content { width: 1024px; margin: 0 auto; color: #333; text-align: center; font-size: 12px; }
        td { padding: 5px; }
        .title { text-align: center; line-height: 33px; }
        .nav { text-align: center; line-height: 24px; }
        .nav a { padding: 0 9px; font-size: 14px; }
        .btnp input { padding: 0 10px; margin: 0 10px; cursor: pointer; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div id="content">
        <h3 class="title">
            中国联合网络通信有限公司安阳市分公司客户接入领用物资申请单</h3>
        <table border="0" cellspacing="0" cellpadding="0" bordercolor="#000000" style="table-layout: fixed;
            color: #000; font-size: 14px; border-collapse: collapse;">
            <tr>
                <td width="330" align="left">
                    领料单位：<asp:Label ID="lldw" runat="server" Text="Label"></asp:Label>
                </td>
                <td width="280">
                    编号：<asp:Label ID="id" runat="server" Text="Label"></asp:Label>
                </td>
                <td width="280" align="right">
                    领料时间：<asp:Label ID="cksj" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
        </table>
        <table border="1" cellspacing="0" cellpadding="0" bordercolor="#000000" style="table-layout: fixed;
            border-collapse: collapse; color: #000; font-size: 14px;width:930px;">
            <tr>
                <td width="80" height="50">
                    出库单位：
                </td>
                <td width="250" align="left" id="ckdw" runat="server">
                </td>
                <td width="80">
                    领料用途：
                </td>
                <td width="200" align="left" id="llyt" runat="server" colspan="3">
                </td>
            </tr>
            <tr>
                <td height="50">
                    用料地址：
                </td>
                <td align="left" id="yldz" runat="server">
                </td>
                <td>
                    备注：
                </td>
                <td align="left" id="bz" runat="server" colspan="3">
                </td>
            </tr>
            
            <tr>
                <td width="80" height="50">
                    编号
                </td>
                <td>
                    物资类别
                </td>
                <td colspan="2">
                    物资型号
                </td>
                <td colspan="2">
                    领取数量
                </td>
            </tr>
            <asp:Repeater ID="repData" runat="server">
                <ItemTemplate>
                    <tr>
                        <td>
                            <%#Eval("rowid") %>
                        </td>
                        <td>
                            <%#Eval("classname") %>
                        </td>
                        <td colspan="2">
                            <%#Eval("typename") %>
                        </td>
                        <td colspan="2">
                            <%#Eval("amount") %>
                            <%#Eval("units") %>
                        </td>
                    </tr>
                </ItemTemplate>
            </asp:Repeater>
        </table>
        <table border="0" cellspacing="0" cellpadding="0" bordercolor="#000000" style="table-layout: fixed;
            color: #000; font-size: 14px; border-collapse: collapse;width:930px;">
            <tr>
                <td width="330" align="left">
                    领料人：<asp:Label ID="llr" runat="server" Text="Label"></asp:Label>
                </td>
                <td width="280">
                    
                </td>
                <td width="280">
                </td>
            </tr>
        </table>
        <p>
            <input type="button" value="打印该页" onclick="javascript:window.print();" /></p>
    </div>
    </form>
</body>
</html>
