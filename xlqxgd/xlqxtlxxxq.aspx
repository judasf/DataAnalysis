<%@ Page Language="C#" AutoEventWireup="true" CodeFile="xlqxtlxxxq.aspx.cs" Inherits="xlqxtlxxxq" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>抢修事项管理</title>
        <link type="text/css" href="../css/style.css" rel="Stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
    <div id="content">
        <p class="sitepath">
            <b>当前位置：</b>抢修事项管理 > <a href="xlqxxxgl.aspx">抢修信息管理</a>>抢修退料信息详情
        </p>
        <br />
        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1"   class="tablewidth">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                    抢修退料信息详情
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="30">
                    编号：
                </td>
                <td class="tdinput"  id="id" runat="server" >
                </td>
                <td class="tdtitle" width="90">
                    抢修日期：
                </td>
                <td width="200" class="tdinput"  id="qxrq" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="30">
                    抢修地点：
                </td>
                <td class="tdinput"  id="qxdd" colspan="3" runat="server" valign="top">
                </td>
            </tr>
            <tr>
                <td class="tdtitle" width="90">
                    退料信息：
                </td>
                <td class="tdinput" colspan="3" id="tlxx" runat="server" height="80" valign="top">
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
