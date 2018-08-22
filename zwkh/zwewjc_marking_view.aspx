<%@ Page Language="C#" AutoEventWireup="true" CodeFile="zwewjc_marking_view.aspx.cs"
    Inherits="zwkh_zwewjc_marking_view" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>装维考核管理</title>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
    <div id="content">
        <p class="sitepath">
            <b>当前位置：</b>装维考核管理 > <a href="zwkhtjb.aspx">装维外包维护质量考核表</a> > 额外奖惩考核得分详情
        </p>
        <p style="text-align: left;">
            <b>考核月份：</b><span id="scoredate" runat="server"></span>&nbsp;&nbsp;&nbsp;&nbsp;
            <b>被考核分公司：</b> <span id="deptname" runat="server"></span>&nbsp;&nbsp;&nbsp;&nbsp;<span
                id="markingdept" runat="server"></span> &nbsp;&nbsp;&nbsp;&nbsp;<span id="markingtime"
                    runat="server"></span>
        </p>
        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="width: 900px;">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td width="30">
                    类别
                </td>
                <td width="30" >
                    序号
                </td>
                <td width="70">
                   维护项目
                </td>
                <td width="180">
                    维护标准
                </td>
                <td width="180">
                    考评标准
                </td>
                <td width="40">
                    得分
                </td>
                <td width="120">
                    备注 (加/扣分原因)
                </td>
            </tr>
            <asp:Repeater ID="repData" runat="server">
                <ItemTemplate>
                    <tr>
                        <td id="classname" runat="server">
                            <%#Eval("classname")%>
                        </td>
                        <td>
                            <%#Eval("rowid")%>
                        </td>
                        <td>
                            <%#Eval("itemname")%>
                        </td>
                         <td align="left">
                            <%#Eval("std")%>
                        </td>
                        <td align="left">
                            <%#Eval("markstd")%>
                        </td>
                        <td>
                            <%#Eval("score") %>
                        </td>
                        <td align="left">
                            <%#Eval("memo") %>
                        </td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                    <tr style='display:<%#bool.Parse((repData.Items.Count==0).ToString())?"":"none"%>'>
                        <td colspan="7" class="b_red">
                            没有该月考核数据！
                        </td>
                    </tr>
                </FooterTemplate>
            </asp:Repeater>
            <tr  style='display:<%=bool.Parse((repData.Items.Count==0).ToString())?"none":""%>' >
                <td colspan="5">
                    合计：
                </td>
                <td runat="server" id="trtotal">
                </td>
                <td>
                </td>
            </tr>
        </table>
        <p style="width:900px;">
            <a href="javascript:history.back();">返回上一页</a></p>
    </div>
    </form>
</body>
</html>
