<%@ Page Language="C#" AutoEventWireup="true" CodeFile="xlrcwh_marking_view.aspx.cs"
    Inherits="xlkh_xlrcwh_marking_view" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>线路考核管理</title>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
    <div id="content">
        <p class="sitepath">
            <b>当前位置：</b>线路考核管理 > <a href="xlkhtjb.aspx">线路外包维护质量考核表</a> > 日常维护内容考核得分详情
        </p>
        <p style="text-align: left;">
            <b>考核月份：</b><span id="scoredate" runat="server"></span>&nbsp;&nbsp;&nbsp;&nbsp;
            <b>被考核分公司：</b> <span id="deptname" runat="server"></span>&nbsp;&nbsp;&nbsp;&nbsp;<b>考核单位：</b><span
                id="markingdept" runat="server"></span> &nbsp;&nbsp;&nbsp;&nbsp;<span id="markingtime"
                    runat="server"></span>
        </p>
        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="width: 900px;">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td width="80" colspan="2">
                    类别
                </td>
                <td width="60">
                    维护项目
                </td>
                <td width="30">序号
                    </td>
                 <td width="210">
                  维护标准
                </td>
                 <td width="30">
                  分值
                </td>
                <td width="210">
                   考评标准
                </td>
                <td width="40">
                    扣分
                </td>
                <td width="120">
                    备注 (扣分原因)
                </td>
            </tr>
            <asp:Repeater ID="repData" runat="server">
                <ItemTemplate>
                    <tr>
                        <td runat="server" id="pclass">
                            <%#Eval("pclass") %>
                        </td>
                        <td id="classname" runat="server">
                            <%#Eval("classname")%>
                        </td>
                         <td id="itemname" runat="server">
                            <%#Eval("itemname")%>
                        </td>
                         <td>
                                <%#Eval("rowid")%>
                            </td>
                        <td align="left">
                            <%#Eval("std")%>
                        </td>
                        <td id="marks" runat="server">
                            <%#Eval("marks")%>
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
                    <tr style='display: <%#bool.Parse((repData.Items.Count==0).ToString())?"":"none"%>'>
                        <td colspan="9" class="b_red">
                            没有该月考核数据！
                        </td>
                    </tr>
                </FooterTemplate>
            </asp:Repeater>
            <tr style='display: <%=bool.Parse((repData.Items.Count==0).ToString())?"none":""%>'>
                <td colspan="7">
                    合计：
                </td>
                <td runat="server" id="trtotal">
                </td>
                <td>
                </td>
            </tr>
           
        </table>
        <p style="width: 900px;">
            <a href="javascript:history.back();">返回上一页</a></p>
    </div>
    </form>
</body>
</html>
