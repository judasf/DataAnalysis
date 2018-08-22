<%@ Page Language="C#" AutoEventWireup="true" CodeFile="nsbdtlxxxq.aspx.cs" Inherits="nsbdtlxxxq" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>南水北调事项管理</title>
        <link type="text/css" href="../css/style.css" rel="Stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
    <div id="content">
        <p class="sitepath">
            <b>当前位置：</b>南水北调事项处理 >  <%=Session["pre"] != null&&Session["pre"].ToString().Trim()==""?"<a href=\"nsbdxxgl.aspx\">市区南水北调信息管理</a>":"<a href=\"nsbdxxgl_town.aspx\">县公司南水北调信息管理</a>" %>>市区南水北调退料信息详情
        </p>
        <br />
        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1"   class="tablewidth">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                    南水北调退料信息详情
                </td>
            </tr>
            <tr>
                <td class="tdtitle" width="90" height="30">
                    编号：
                </td>
                <td class="tdinput"  id="id" runat="server" width="200">
                </td>
                <td class="tdtitle" width="90">
                    申请时间：
                </td>
                <td width="200" class="tdinput"  id="fssj" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="30">
                    申请单位：
                </td>
                <td class="tdinput"  id="fsdw" runat="server">
                </td>
                <td class="tdtitle">
                    联系人：
                </td>
                <td class="tdinput"  id="lxr" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="30">
                    施工单位：
                </td>
                <td class="tdinput"  id="sgdw" runat="server">
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
                <td class="tdinput" colspan="3" id="tlxx" runat="server" height="80">
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
