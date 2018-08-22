<%@ Page Language="C#" AutoEventWireup="true" CodeFile="wbzbgl.aspx.cs" Inherits="gzbb_wbzbgl" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>工作报表管理</title>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
    <div id="content">
        <p class="sitepath">
            <b>当前位置：</b>工作报表管理 > <a href="wbzbgl.aspx">工作周报管理</a>
        </p>
        <p style="text-align: left;">
            <b>数据查询：</b>选择上传日期： 从
            <asp:DropDownList ID="ddlMonth" runat="server">
            </asp:DropDownList>
            至
            <asp:DropDownList ID="ddlMonth1" runat="server">
            </asp:DropDownList>
            选择上传单位：
            <asp:DropDownList ID="ddlscdw" runat="server">
            </asp:DropDownList>
            <span class="btnp" style="text-align: left; padding-left: 35px;">
                <asp:Button ID="btnSearch" runat="server" Text="查询数据" OnClick="btnSearch_Click" />
                </span>
        </p>
        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td width="60">
                    编号
                </td>
                <td width="150">
                    上传时间
                </td>
                <td width="300">
                   文件名
                </td>
                <td width="80">
                    上传单位
                </td>
                <td width="80">
                    上传人
                </td>
              
            </tr>
            <asp:Repeater ID="repData" runat="server">
                <ItemTemplate>
                    <tr>
                        <td>
                            <%#Eval("id")%>
                        </td>
                        <td>
                            <%#Eval("uptime")%>
                        </td>
                        <td>
                            <%# "<a href='uploadfiles/" + Eval("filename") + "' title='点击下载' target='_blank' >" + Eval("filename") + "</a>"%>
                        </td>
                        <td>
                            <%#Eval("userdept")%>
                        </td>
                        <td>
                            <%#Eval("username")%>
                        </td>
                     
                    </tr>
                </ItemTemplate>
            </asp:Repeater>
        </table>
        <p class="tablewidth">
            有<asp:Literal ID="RecordCount" runat="server"></asp:Literal>条记录 共有<asp:Literal ID="PageCount"
                runat="server"></asp:Literal>页 当前第<asp:Literal ID="Pageindex" runat="server"></asp:Literal>页
            <asp:HyperLink ID="FirstPage" runat="server" Text="首页"></asp:HyperLink>
            <asp:HyperLink ID="PrevPage" runat="server" Text="上一页"></asp:HyperLink>
            <asp:HyperLink ID="NextPage" runat="server" Text="下一页"></asp:HyperLink>
            <asp:HyperLink ID="LastPaeg" runat="server" Text="尾页"></asp:HyperLink>
            跳转到<asp:Literal ID="Literal1" runat="server"></asp:Literal>页</p>
    </div>
    </form>
</body>
</html>
