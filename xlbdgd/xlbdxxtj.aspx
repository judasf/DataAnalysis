<%@ Page Language="C#" AutoEventWireup="true" CodeFile="xlbdxxtj.aspx.cs" Inherits="xlbdxxtj" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>被盗事项管理</title>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />
        <style type="text/css">td { padding: 1px;}</style>
</head>
<body>
    <form id="form1" runat="server">
    <div id="content">
        <p class="sitepath">
            <b>当前位置：</b>被盗事项管理 > <a href="xlbdxxtj.aspx">被盗信息统计</a>
        </p>
        <p style="text-align: left;">
            <b>数据查询：</b>选择年份：
            <asp:DropDownList ID="ddlYear" runat="server">
            </asp:DropDownList>
            选择单位：
            <asp:DropDownList ID="ddlBddw" runat="server">
            </asp:DropDownList>
            <span class="btnp" style="text-align: left; padding-left: 35px;">
                <asp:Button ID="btnSearch" runat="server" Text="查询数据" OnClick="btnSearch_Click" />
                <asp:Button ID="btnExportExcel" runat="server" Text="导出Excel" OnClick="btnExportExcel_Click" /></span>
        </p>
        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1">
            <tr style="background-color: #eeeeee;">
                <td width="120" rowspan="2">
                    被盗单位
                </td>
                <td colspan="2">
                    1月
                </td>
                <td colspan="2">
                    2月
                </td>
                <td  colspan="2">
                    3月
                </td>
                <td colspan="2">
                    4月
                </td>
                <td colspan="2">
                    5月
                </td>
                <td colspan="2">
                    6月
                </td>
                <td colspan="2">
                    7月
                </td>
                <td colspan="2">
                    8月
                </td>
                <td colspan="2">
                    9月
                </td>
                <td colspan="2">
                    10月
                </td>
                <td colspan="2">
                    11月
                </td>
                <td colspan="2">
                    12月
                </td>
            </tr>
            <tr style="background-color: #eeeeee;">
                <td width="40">
                    次数
                </td>
                <td width="120">
                    金额
                </td>
                <td width="30">
                    次数
                </td>
                <td width="100">
                    金额
                </td>
                <td width="30">
                    次数
                </td>
                <td width="100">
                    金额
                </td>
                <td width="30">
                    次数
                </td>
                <td width="100">
                    金额
                </td>
                <td width="30">
                    次数
                </td>
                <td width="100">
                    金额
                </td>
                <td width="30">
                    次数
                </td>
                <td width="100">
                    金额
                </td>
                <td width="30">
                    次数
                </td>
                <td width="100">
                    金额
                </td>
                <td width="30">
                    次数
                </td>
                <td width="100">
                    金额
                </td>
                <td width="30">
                    次数
                </td>
                <td width="100">
                    金额
                </td>
                <td width="30">
                    次数
                </td>
                <td width="100">
                    金额
                </td>
                <td width="30">
                    次数
                </td>
                <td width="100">
                    金额
                </td>
                <td width="30">
                    次数
                </td>
                <td width="100">
                    金额
                </td>
            </tr>
            <asp:Repeater ID="repData" runat="server">
                <ItemTemplate>
                    <tr>
                        <td>
                            <%#Eval("bddw") %>
                        </td>
                        <td>
                            <a href="xlbdxxgl.aspx?qj=<%=year%>-01&jz=<%=year%>-01&dw=<%#Eval("bddw") %>" title="查看详细信息">
                                <%#Eval("num1") %></a>
                        </td>
                        <td>
                            <%#Eval("amount1") %>
                        </td>
                        <td>
                            <a href="xlbdxxgl.aspx?qj=<%=year%>-02&jz=<%=year%>-02&dw=<%#Eval("bddw") %>" title="查看详细信息">
                                <%#Eval("num2") %></a>
                        </td>
                        <td>
                            <%#Eval("amount2") %>
                        </td>
                        <td>
                            <a href="xlbdxxgl.aspx?qj=<%=year%>-03&jz=<%=year%>-03&dw=<%#Eval("bddw") %>" title="查看详细信息">
                                <%#Eval("num3") %></a>
                        </td>
                        <td>
                            <%#Eval("amount3") %>
                        </td>
                        <td>
                            <a href="xlbdxxgl.aspx?qj=<%=year%>-04&jz=<%=year%>-04&dw=<%#Eval("bddw") %>" title="查看详细信息">
                                <%#Eval("num4") %></a>
                        </td>
                        <td>
                            <%#Eval("amount4") %>
                        </td>
                        <td>
                            <a href="xlbdxxgl.aspx?qj=<%=year%>-05&jz=<%=year%>-05&dw=<%#Eval("bddw") %>" title="查看详细信息">
                                <%#Eval("num5") %></a>
                        </td>
                        <td>
                            <%#Eval("amount5") %>
                        </td>
                        <td>
                            <a href="xlbdxxgl.aspx?qj=<%=year%>-06&jz=<%=year%>-06&dw=<%#Eval("bddw") %>" title="查看详细信息">
                                <%#Eval("num6") %></a>
                        </td>
                        <td>
                            <%#Eval("amount6") %>
                        </td>
                        <td>
                            <a href="xlbdxxgl.aspx?qj=<%=year%>-07&jz=<%=year%>-07&dw=<%#Eval("bddw") %>" title="查看详细信息">
                                <%#Eval("num7") %></a>
                        </td>
                        <td>
                            <%#Eval("amount7") %>
                        </td>
                        <td>
                            <a href="xlbdxxgl.aspx?qj=<%=year%>-08&jz=<%=year%>-08&dw=<%#Eval("bddw") %>" title="查看详细信息">
                                <%#Eval("num8") %></a>
                        </td>
                        <td>
                            <%#Eval("amount8") %>
                        </td>
                        <td>
                            <a href="xlbdxxgl.aspx?qj=<%=year%>-09&jz=<%=year%>-09&dw=<%#Eval("bddw") %>" title="查看详细信息">
                                <%#Eval("num9") %></a>
                        </td>
                        <td>
                            <%#Eval("amount9") %>
                        </td>
                        <td>
                            <a href="xlbdxxgl.aspx?qj=<%=year%>-10&jz=<%=year%>-10&dw=<%#Eval("bddw") %>" title="查看详细信息">
                                <%#Eval("num10") %></a>
                        </td>
                        <td>
                            <%#Eval("amount10") %>
                        </td>
                        <td>
                            <a href="xlbdxxgl.aspx?qj=<%=year%>-11&jz=<%=year%>-11&dw=<%#Eval("bddw") %>" title="查看详细信息">
                                <%#Eval("num11") %></a>
                        </td>
                        <td>
                            <%#Eval("amount11") %>
                        </td>
                        <td>
                            <a href="xlbdxxgl.aspx?qj=<%=year%>-12&jz=<%=year%>-12&dw=<%#Eval("bddw") %>" title="查看详细信息">
                                <%#Eval("num12") %></a>
                        </td>
                        <td>
                            <%#Eval("amount12") %>
                        </td>
                    </tr>
                </ItemTemplate>
            </asp:Repeater>
        </table>
    </div>
    </form>
</body>
</html>
