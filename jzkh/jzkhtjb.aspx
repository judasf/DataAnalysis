<%@ Page Language="C#" AutoEventWireup="true" CodeFile="jzkhtjb.aspx.cs" Inherits="jzkh_jzkhtjb_marking" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>基站考核管理</title>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />
    <style type="text/css">
        .style1 { width: 100%; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div id="content">
        <p class="sitepath">
            <b>当前位置：</b>基站考核管理 > <a href="jzkhtjb.aspx">基站外包维护质量考核表</a>
        </p>
        <p style="text-align: left;">
            <b>选择考核月份：</b><asp:DropDownList ID="scoredate" runat="server">
            </asp:DropDownList>
            <span class="btnp" style="text-align: left; padding-left: 35px;">
                <asp:Button ID="btnSearch" runat="server" Text="查询数据" OnClick="btnSearch_Click" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnExportExcel" runat="server" Text="导出Excel" OnClick="btnExportExcel_Click" /></span>
        </p>
        <h4 style="width: 900px; text-align: center;">
            <span runat="server" id="sd"></span>基站外包维护质量考核表</h4>
        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="table-layout:fixed;">
            <tr style="background-color: #eeeeee; line-height: 20px;">
                <td width="80" rowspan="2">
                    分公司
                </td>
                <td width="80" rowspan="2">
                    外包单位
                </td>
                <td width="180" colspan="2">
                    基站故障指标(权重60%)
                </td>
                <td width="360" colspan="3">
                    日常维护管理与考核（40%）
                </td>
                <td width="80" rowspan="2">
                    额外奖罚
                </td>
                <td width="80" rowspan="2">
                    汇总得分
                </td>
            </tr>
            <tr style="background-color: #eeeeee; line-height: 20px;">
                <td width="90">
                    断站指标（权重48%）
                </td>
                <td width="90">
                    小区级故障指标（权重12%）
                </td>
                <td width="90">
                   网维或县公司考核（权重25%）
                </td>
                <td width="90">
                  网优考核（权重5%）
                </td>
                <td width="90">
                  市公司考核（权重10%）
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
                            <a href='jzdzzb_marking_view.aspx?dept=<%#Server.UrlEncode(Eval("deptname").ToString()) %>&scoredate=<%=sd.InnerText %>'>
                                <%#Eval("s1")%></a>
                        </td>
                        <td>
                            <a href='xqjgzzb_marking_view.aspx?dept=<%#Server.UrlEncode(Eval("deptname").ToString()) %>&scoredate=<%=sd.InnerText %>'>
                                <%#Eval("s2")%></a>
                        </td>
                        <td>
                            <a href='jzrcwh_marking_view.aspx?dept=<%#Server.UrlEncode(Eval("deptname").ToString()) %>&scoredate=<%=sd.InnerText %>&markingdept=<%#Server.UrlEncode(Eval("deptname").ToString() == "市区" ? "网络管理中心" : Eval("deptname").ToString())%>'>
                                <%#Eval("s3")%></a>
                        </td>
                        <td>
                             <a href='jzwykh_marking_view.aspx?dept=<%#Server.UrlEncode(Eval("deptname").ToString()) %>&scoredate=<%=sd.InnerText %>'>
                                <%#Eval("s4")%></a>
                        </td>
                        <td>
                              <a href='jzrcwh_marking_view.aspx?dept=<%#Server.UrlEncode(Eval("deptname").ToString()) %>&scoredate=<%=sd.InnerText %>&markingdept=<%=Server.UrlEncode("网络部") %>'>
                                <%#Eval("s5")%></a>
                        </td>
                        <td>
                        <a href='jzewjc_marking_view.aspx?dept=<%#Eval("deptname") %>&scoredate=<%=sd.InnerText %>'>
                            <%#Eval("s6")%></a> </td>
                        <td>
                            <%#Eval("s7")%>
                        </td>
                    </tr>
                </ItemTemplate>
            </asp:Repeater>
            <tr>
                <td colspan="13" align="left">
                    备注：<br />
                    各单位基站维护得分=基站断站指标得分 * 48% + 小区级故障指标得分 * 12% + 网维或县公司考核得分 * 25% + 网优考核 *5% + 市公司考核得分 * 10%+额外奖罚
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
