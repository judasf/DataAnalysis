<%@ Page Language="C#" AutoEventWireup="true" CodeFile="xlzgtlxxxq.aspx.cs" Inherits="xlzgtlxxxq" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>整改事项管理</title>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
    <div id="content">
          <p class="sitepath">
            <b>当前位置：</b>整改事项管理 > <a href="xlzgxxgl.aspx">整改信息管理</a>> 整改退料信息详情
        </p>
        <table border="1" bordercolor="#CCCCCC" cellpadding="0" cellspacing="0" class="tablewidth">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                    整改退料信息详情
                </td>
            </tr>
            <tr>
                <td class="tdtitle" width="90" height="30">
                    编号：
                </td>
                <td class="tdinput"  id="zgid" runat="server" width="200">
                </td>
                <td class="tdtitle" width="90">
                    派单单位：
                </td>
                <td width="200" class="tdinput"  id="pfdw" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="30">
                    派单人：
                </td>
                <td class="tdinput"  id="pdr" runat="server">
                </td>
                <td class="tdtitle">
                    派单时间：
                </td>
                <td class="tdinput"  id="pdsj" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="30">
                    维护单位：
                </td>
                <td class="tdinput"  id="whdw" runat="server">
                </td>
                <td class="tdtitle">
                    负责人：
                </td>
                <td class="tdinput" id="fzr" runat="server">
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
