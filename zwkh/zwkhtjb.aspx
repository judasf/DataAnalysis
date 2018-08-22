<%@ Page Language="C#" AutoEventWireup="true" CodeFile="zwkhtjb.aspx.cs" Inherits="zwkh_zwkhtjb" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>装维考核管理</title>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />

    <style type="text/css">
        .style1 { width: 100%; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div id="content">
            <p class="sitepath">
                <b>当前位置：</b>装维考核管理 > <a href="zwkhtjb.aspx">装维外包维护质量考核表</a>
            </p>
            <p style="text-align: left;">
                <b>选择考核月份：</b><asp:DropDownList ID="scoredate" runat="server">
                </asp:DropDownList>
                <span class="btnp" style="text-align: left; padding-left: 35px;">
                    <asp:Button ID="btnSearch" runat="server" Text="查询数据" OnClick="btnSearch_Click" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnExportExcel" runat="server" Text="导出Excel" OnClick="btnExportExcel_Click" /></span>
            </p>
            <h4 style="width: 750px; text-align: center;">
                <span runat="server" id="sd"></span>装维外包维护质量考核表</h4>
            <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="table-layout: fixed;">
                <tr style="background-color: #eeeeee; line-height: 20px;">
                    <td width="80">分公司
                    </td>
                    <td width="80">外包单位
                    </td>
                    <td width="100">障碍与服务指标（85分）
                    </td>
                    <td width="100">基础管理考核（15分）
                    </td>
                    <td width="100">额外奖惩
                    </td>
                    <td width="100">汇总得分
                    </td>
                </tr>
                <asp:Repeater ID="repData" runat="server">
                    <ItemTemplate>
                        <tr>
                            <td>
                                <%#Eval("deptname") %>
                            </td>
                            <td id="wbdw" runat="server">
                                <%#Eval("wbdw")%>
                            </td>
                            <td>
                                <a href='zwzayfw_marking_view.aspx?dept=<%#Server.UrlEncode(Eval("deptname").ToString()) %>&scoredate=<%=sd.InnerText %>'>
                                    <%#Eval("s1")%></a>
                            </td>
                            <td>
                                <a href='zwjcgl_marking_view.aspx?dept=<%#Server.UrlEncode(Eval("deptname").ToString()) %>&scoredate=<%=sd.InnerText %>&markingdept=<%#Server.UrlEncode(Eval("deptname").ToString().Substring(0,2) == "市区" ? "公众响应中心" : Eval("deptname").ToString())%>'>
                                    <%#Eval("s2")%></a>
                            </td>
                            <td>
                                <a href='zwewjc_marking_view.aspx?dept=<%#Server.UrlEncode(Eval("deptname").ToString()) %>&scoredate=<%=sd.InnerText %>'>
                                    <%#Eval("s3")%></a>
                            </td>
                            <td>
                                <%#Eval("s4")%>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
                <tr>
                    <td colspan="8" align="left">备注：<br />
                       装维考核得分=障碍与服务指标得分（85分）+基础管理考核得分（15分）+额外奖罚（控制指标）
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
