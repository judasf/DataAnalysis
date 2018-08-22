<%@ Page Language="C#" AutoEventWireup="true" CodeFile="xlqgtlxxxq.aspx.cs" Inherits="xlqgtlxxxq" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>迁改事项管理</title>
        <link type="text/css" href="../css/style.css" rel="Stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
    <div id="content">
        <p class="sitepath">
            <b>当前位置：</b>迁改事项处理 >  <%=Session["pre"] != null&&Session["pre"].ToString().Trim()==""?"<a href=\"xlqgxxgl.aspx\">市区迁改信息管理</a>":"<a href=\"xlqgxxgl_town.aspx\">县公司迁改信息管理</a>" %>>市区迁改退料信息详情
        </p>
        <br />
        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1"   class="tablewidth">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                    迁改退料信息详情
                </td>
            </tr>
            <tr>
                <td class="tdtitle" width="90" height="30">
                    编号：
                </td>
                <td class="tdinput"  id="id" runat="server" width="200">
                </td>
                <td class="tdtitle" width="90">
                    发生时间：
                </td>
                <td width="200" class="tdinput"  id="fssj" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="30">
                    发生单位：
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
