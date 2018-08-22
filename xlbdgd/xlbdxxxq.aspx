<%@ Page Language="C#" AutoEventWireup="true" CodeFile="xlbdxxxq.aspx.cs" Inherits="xlbdxxxq" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>被盗事项管理</title>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
    <div id="content">
        <p class="sitepath">
            <b>当前位置：</b>被盗事项管理 > <a href="xlbdxxgl.aspx">被盗信息管理</a>>被盗工单详情
        </p>
        <br />
        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1"  class="tablewidth">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                    被盗工单详情
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="30">
                    编号：
                </td>
                <td class="tdinput" width="200">
                    <asp:Label ID="bdid" runat="server" Text="Label"></asp:Label>
                </td>
                <td class="tdtitle">
                    被盗日期：
                </td>
                <td class="tdinput" width="200">
                    <asp:Label ID="bdrq" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="30">
                    被盗地点：
                </td>
                <td class="tdinput" colspan="3">
                    <asp:Label ID="bddd" runat="server" Text="Label"></asp:Label>
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
                    被盗损失：
                </td>
                <td class="tdinput" colspan="3">
                    <asp:Label ID="bdss" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
             <tr>
                <td class="tdtitle" height="30">
                    被盗现场照片：
                </td>
                <td class="tdinput" colspan="3">
                    <asp:Label ID="bdxczp" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="30">
                    被盗领料信息：
                </td>
                <td class="tdinput" colspan="3">
                    <asp:Label ID="bdll" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="30">
                    该被盗状态：
                </td>
                <td class="tdinput">
                    <asp:Label ID="bdwj" runat="server" Text="Label"></asp:Label>
                </td>
                <td class="tdtitle">
                    被盗恢复时间：
                </td>
                <td class="tdinput">
                    <asp:Label ID="hfsj" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="30">
                    被盗恢复现场照片：
                </td>
                <td class="tdinput" colspan="3">
                    <asp:Label ID="bdhfxc" runat="server" Text=""></asp:Label>
                </td>
            </tr>
        </table>
      
    </div>
    </form>
</body>
</html>
