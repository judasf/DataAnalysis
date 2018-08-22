<%@ Page Language="C#" AutoEventWireup="true" CodeFile="nsbdllxxxq.aspx.cs" Inherits="nsbdllxxxq" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>南水北调事项管理</title>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
    <div id="content">
        <h3>
            中国联合网络通信有限公司安阳市分公司南水北调领用物资申请单</h3>
        <table border="0" cellspacing="0" cellpadding="0" bordercolor="#000000" style="color: #000;
            margin: 0 auto; font-size: 14px;">
            <tr>
                <td width="330" align="left">
                    领料单位：<asp:Label ID="lldw" runat="server" Text="Label"></asp:Label>
                </td>
                <td width="280">
                    编号：<asp:Label ID="zgid" runat="server" Text="Label"></asp:Label>
                </td>
                <td width="280" align="right">
                    领料时间：<asp:Label ID="cksj" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
        </table>
        <table border="1" cellspacing="0" cellpadding="0" bordercolor="#000000" style="color: #000;
            margin: 0 auto; font-size: 14px;">
            <tr>
                <td width="80" height="50">
                    申请时间：
                </td>
                <td width="250" align="left" id="fssj" runat="server">
                </td>
                <td width="80">
                    申请单位：
                </td>
                <td width="200" align="left" id="fsdw" runat="server">
                </td>
                <td width="80">
                    联系人：
                </td>
                <td width="200" align="left" id="lxr" runat="server">
                </td>
            </tr>
            <tr>
                <td height="50">
                    施工单位：
                </td>
                <td align="left" id="sgdw" runat="server">
                </td>
                <td>
                    负责人：
                </td>
                <td align="left" id="fzr" runat="server" colspan="3">
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
        <table border="0" cellspacing="0" cellpadding="0" bordercolor="#000000" style="color: #000;
            margin: 0 auto; font-size: 14px;">
            <tr>
                <td width="330" align="left">
                    领料人：<asp:Label ID="llr" runat="server" Text="Label"></asp:Label>
                </td>
                <td width="280">
                    联系电话：<asp:Label ID="lxdh" runat="server" Text="Label"></asp:Label>
                </td>
                <td width="280">
                </td>
            </tr>
        </table>
        <p class="btnp">
            <input type="button" value="打印该页" onclick="javascript:window.print();" /></p>
    </div>
    </form>
</body>
</html>
