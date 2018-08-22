<%@ Page Language="C#" AutoEventWireup="true" CodeFile="nsbdxxxq.aspx.cs" Inherits="nsbdxxxq" %>

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
            <b>当前位置：</b>南水北调事项管理 > <%=Session["pre"] != null&&Session["pre"].ToString().Trim()==""?"<a href=\"nsbdxxgl.aspx\">市区南水北调信息管理</a>":"<a href=\"nsbdxxgl_town.aspx\">县公司南水北调信息管理</a>" %>> 南水北调信息详情
        </p>
        <br />
        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1"  class="tablewidth">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                    南水北调信息详情
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    编号：
                </td>
                <td class="tdinput" id="id" runat="server">
                </td>
                <td class="tdtitle">
                    申请时间：
                </td>
                <td class="tdinput" id="fssj" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle" width="90">
                    申请单位：
                </td>
                <td class="tdinput" width="180" id="fsdw" runat="server">
                </td>
                <td class="tdtitle" width="90">
                    联系人：
                </td>
                <td class="tdinput" width="180" id="lxr" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle" width="90">
                    联系电话：
                </td>
                <td class="tdinput" width="180" id="lxdh" runat="server">
                </td>
                <td class="tdtitle" width="90">
                    预算金额：
                </td>
                <td class="tdinput" width="180" id="ysje" runat="server">
                </td>
            </tr>
             <tr>
                <td class="tdtitle" width="90">
                    迁建线路地点：
                </td>
                <td class="tdinput" width="180" id="dd" runat="server">
                </td>
                <td class="tdtitle" width="90">
                    施工地段：
                </td>
                <td class="tdinput" width="180" id="sgdd" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    迁建线路内容及方案：
                </td>
                <td class="tdinput" colspan="3" id="sy" runat="server" height="60">
                </td>
            </tr>
            <tr>
                <td class="tdtitle" style="background-color: #eeeeee;">
                    施工单位信息：
                </td>
                <td class="tdinput" colspan="3" id="sgdwxx" runat="server" height="30">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    领料信息：
                </td>
                <td class="tdinput" id="qgll" runat="server" height="30">
                </td>
                <td class="tdtitle">
                    退料信息：
                </td>
                <td class="tdinput" id="qgtl" runat="server" height="30">
                </td>
            </tr>
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                    南水北调验收信息
                </td>
            </tr>
            <tr <%=isYs?"":"style='display:none'" %>>
                <td class="tdtitle">
                    验收意见：
                </td>
                <td class="tdinput" colspan="3" id="ysyj" runat="server" height="40">
                </td>
            </tr>
            <tr <%=isYs?"style='display:none'":"" %>>
                <td colspan="4" align="center" class="b_red">
                    该南水北调还未验收
                </td>
            </tr>
            <tr <%=isYs?"":"style='display:none'" %>>
                <td class="tdtitle">
                    验收人：
                </td>
                <td class="tdinput" id="ysr" runat="server" height="30">
                </td>
                <td class="tdtitle">
                    验收时间：
                </td>
                <td class="tdinput" id="yssj" runat="server">
                </td>
            </tr>
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                    审计报账信息
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    审计状态：
                </td>
                <td class="tdinput" id="sjbz" runat="server" colspan="3">
                </td>
            </tr>
            <tr <%=isSs?"":"style='display:none'" %>>
                <td class="tdtitle">
                    送审时间：
                </td>
                <td class="tdinput" id="sssj" runat="server">
                </td>
                <td class="tdtitle">
                    送审金额：
                </td>
                <td class="tdinput" id="ssje" runat="server">
                </td>
            </tr>
            <tr <%=isSj?"":"style='display:none'" %>>
                <td class="tdtitle">
                    审计时间：
                </td>
                <td class="tdinput" id="sjsj" runat="server">
                </td>
                <td class="tdtitle">
                    审计金额：
                </td>
                <td class="tdinput" id="sjje" runat="server">
                </td>
            </tr>
            <tr <%=isFf?"":"style='display:none'" %>>
                <td class="tdtitle">
                    付费时间：
                </td>
                <td class="tdinput" id="ffsj" runat="server" colspan="3">
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
