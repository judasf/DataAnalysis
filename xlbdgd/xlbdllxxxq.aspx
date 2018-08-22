<%@ Page Language="C#" AutoEventWireup="true" CodeFile="xlbdllxxxq.aspx.cs" Inherits="xlbdllxxxq" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>被盗事项管理</title>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
    <div id="content">
        <h3>
            中国联合网络通信有限公司安阳市分公司外包单位紧急领用物资申请单</h3>
        <table border="0" cellspacing="0" cellpadding="0" bordercolor="#000000" style="color: #000;
            margin: 0 auto; font-size: 14px;">
            <tr>
                <td width="330" align="left">
                    领料单位：<asp:Label ID="lldw" runat="server" Text="Label"></asp:Label>
                </td>
                <td width="280">
                    编号：<asp:Label ID="bdid" runat="server" Text="Label"></asp:Label>
                </td>
                <td width="280" align="right">
                    领料时间：<asp:Label ID="cksj" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
        </table>
        <table border="1" cellspacing="0" cellpadding="0" bordercolor="#000000"style="color: #000;
            margin: 0 auto; font-size: 14px;">
            <tr>
                <td width="80" height="40">
                    被盗日期：
                </td>
                <td width="250" align="left">
                    <asp:Label ID="bdrq" runat="server" Text=""></asp:Label>
                </td>
                <td width="80">
                    损失金额：
                </td>
                <td width="200" align="left">
                    <asp:Label ID="ssje" runat="server" Text=""></asp:Label>
                </td>
                <td width="80">
                    恢复时间：
                </td>
                <td width="200" align="left">
                    <asp:Label ID="hfsj" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <td height="40">
                    被盗地点：
                </td>
                <td align="left">
                    <asp:Label ID="bddd" runat="server" Text=""></asp:Label>
                </td>
                <td>
                    被盗损失：
                </td>
                <td colspan="3" align="left">
                    <asp:Label ID="bdss" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <td width="80" height="40">
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
