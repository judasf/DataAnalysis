<%@ Page Language="C#" AutoEventWireup="true" CodeFile="xlqxxxxq.aspx.cs" Inherits="xlqxxxxq" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>抢修事项管理</title>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
    <div id="content">
        <p class="sitepath"><b>当前位置：</b>抢修事项管理 > <a href="xlqxxxgl.aspx">抢修信息管理</a>> 抢修工单详情</p>
     <br />
        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" class="tablewidth">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                    抢修工单详情
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="30">
                    编号：
                </td>
                <td class="tdinput" width="200">
                    <asp:Label ID="qxid" runat="server" Text="Label"></asp:Label>
                </td>
                <td class="tdtitle">
                    抢修日期：
                </td>
                <td class="tdinput" width="200">
                    <asp:Label ID="qxrq" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="30">
                    抢修地点：
                </td>
                <td class="tdinput" colspan="3">
                    <asp:Label ID="qxdd" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="30">
                    报公安日期：
                </td>
                <td class="tdinput">
                    <asp:Label ID="bgarq" runat="server" Text="Label"></asp:Label>
                </td>
                <td class="tdtitle">
                    报保险公司日期：
                </td>
                <td class="tdinput">
                    <asp:Label ID="bbxgsrq" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="30">
                    保险公司是否出现场：
                </td>
                <td class="tdinput">
                    <asp:Label ID="bxgscxc" runat="server" Text="Label"></asp:Label>
                </td>
                <td class="tdtitle">
                    直接损失金额(元)：
                </td>
                <td class="tdinput">
                    <asp:Label ID="ssje" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="60">
                    抢修损失：
                </td>
                <td class="tdinput" colspan="3">
                    <asp:Label ID="qxss" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="30">
                    抢修领料信息：
                </td>
                <td class="tdinput" >
                    <asp:Label ID="qxll" runat="server" Text="Label"></asp:Label>
                </td>
                <td class="tdtitle" height="30">
                    抢修退料信息：
                </td>
                <td class="tdinput" >
                    <asp:Label ID="qxtl" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="30">
                    该抢修状态：
                </td>
                <td class="tdinput">
                    <asp:Label ID="bdwj" runat="server" Text="Label"></asp:Label>
                </td>
                <td class="tdtitle">
                    抢修恢复时间：
                </td>
                <td class="tdinput">
                    <asp:Label ID="hfsj" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
        </table>
          </div>
    </form>
</body>
</html>
