<%@ Page Language="C#" AutoEventWireup="true" CodeFile="xlkhtjb.aspx.cs" Inherits="xlkh_xlkhtjb" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>线路考核管理</title>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />

    <style type="text/css">
        .style1 { width: 100%; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div id="content">
            <p class="sitepath">
                <b>当前位置：</b>线路考核管理 > <a href="xlkhtjb.aspx">线路外包维护质量考核表</a>
            </p>
            <p style="text-align: left;">
                <b>选择考核月份：</b><asp:DropDownList ID="scoredate" runat="server">
                </asp:DropDownList>
                <span class="btnp" style="text-align: left; padding-left: 35px;">
                    <asp:Button ID="btnSearch" runat="server" Text="查询数据" OnClick="btnSearch_Click" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnExportExcel" runat="server" Text="导出Excel" OnClick="btnExportExcel_Click" /></span>
            </p>
            <h4 style="width: 750px; text-align: center;">
                <span runat="server" id="sd"></span>线路外包维护质量考核表</h4>
            <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="table-layout: fixed;">
                <tr style="background-color: #eeeeee; line-height: 20px;">
                    <td width="80" rowspan="2">分公司
                    </td>
                    <td width="80" rowspan="2">外包单位
                    </td>
                    <td width="100" rowspan="2">障碍与服务指标（权重30%）
                    </td>
                    <td width="200" colspan="2">日常维护与考核（权重70%）
                    </td>
                    <td width="100" rowspan="2">额外奖惩
                    </td>
                    <td width="100" rowspan="2">汇总得分
                    </td>
                </tr>
                <tr style="background-color: #eeeeee; line-height: 20px;">
                    <td width="100">公响与县公司考核（权重60%）
                    </td>
                    <td width="100">市公司考核（权重10%）
                    </td>
                </tr>
                <asp:Repeater ID="repData" runat="server">
                    <ItemTemplate>
                        <tr>
                            <td id="deptTD" runat="server">
                                <%#Eval("deptname").ToString()=="市区-长线局"?"市区":Eval("deptname") %>
                            </td>
                            <td id="wbdw" runat="server">
                                <%#Eval("wbdw")%>
                            </td>
                            <td>
                                 <%#Eval("wbdw").ToString() == "长线局" ? "无" : "<a href=xlzayfw_marking_view.aspx?dept=" +Server.UrlEncode(Eval("deptname").ToString()) + "&scoredate=" + sd.InnerText + ">" + Eval("s1") + "</a>"%>



<%--                                <a href='xlzayfw_marking_view.aspx?dept=<%#Server.UrlEncode(Eval("deptname").ToString()) %>&scoredate=<%=sd.InnerText %>'>
                                    <%#Eval("s1")%></a>--%>
                            </td>
                            <td>
                                 <%#Eval("deptname").ToString() == "市区" &&Eval("wbdw").ToString() == "设计院" ? "无" : "<a href=xlrcwh_marking_view.aspx?dept=" + Server.UrlEncode(Eval("deptname").ToString()) + "&scoredate=" + sd.InnerText + "&markingdept=" + Server.UrlEncode(Eval("wbdw").ToString() == "长线局" ? "公众响应中心" : Eval("deptname").ToString()) + ">" + Eval("s2") + "</a>"%>





                              <%--  <a href='xlrcwh_marking_view.aspx?dept=<%#Server.UrlEncode(Eval("deptname").ToString()) %>&scoredate=<%=sd.InnerText %>&markingdept=<%#Server.UrlEncode(Eval("deptname").ToString().Substring(0,2) == "市区" ? "公众响应中心" : Eval("deptname").ToString())%>'>
                                    <%#Eval("s2")%></a>--%>
                            </td>
                            <td>
                                <a href='xlrcwh_marking_view.aspx?dept=<%#Server.UrlEncode(Eval("deptname").ToString()) %>&scoredate=<%=sd.InnerText %>&markingdept=<%#Server.UrlEncode("运行维护部")%>'>
                                    <%#Eval("s3")%></a>
                            </td>
                            <td>
                                <a href='xlewjc_marking_view.aspx?dept=<%#Server.UrlEncode(Eval("deptname").ToString()) %>&scoredate=<%=sd.InnerText %>'>
                                    <%#Eval("s4")%></a>
                            </td>
                            <td>
                                <%#Eval("s5")%>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
                <tr>
                    <td colspan="8" align="left">备注：<br />
                        线路维护得分=障碍与服务指标得分*30%+公响与县公司考核*60%+市公司考核*10%<br />
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
