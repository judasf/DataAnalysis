﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="xqjgzzb_marking_view.aspx.cs"
    Inherits="jzkh_jzgzzb_marking_view" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>基站考核管理</title>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
    <div id="content">
        <p class="sitepath">
            <b>当前位置：</b>基站考核管理 > <a href="jzkhtjb.aspx">基站外包维护质量考核表</a> >小区级故障指标考核得分详情
        </p>
        <p style="text-align: left;">
            <b>考核月份：</b><span id="scoredate" runat="server"></span>&nbsp;&nbsp;&nbsp;&nbsp;
            <b>被考核分公司：</b> <span id="deptname" runat="server"></span>&nbsp;&nbsp;&nbsp;&nbsp;<span
                id="markingdept" runat="server"></span> &nbsp;&nbsp;&nbsp;&nbsp;<span id="markingtime"
                    runat="server"></span>
        </p>
        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="width: 850px;">
            <tr style="background-color: #eeeeee; line-height: 30px;">
               <td width="40">
                    类别
                </td>
                
                <td width="75">
                    维护项目
                </td>
                 <td width="20">
                    序号
                </td>
                <td width="260">
                    评分标准
                </td>
                <td width="40">
                    扣分
                </td>
                <td width="100">
                    备注 (扣分原因)
                </td>
            </tr>
            <asp:Repeater ID="repData" runat="server">
                <ItemTemplate>
                    <tr>
                         <td runat="server" id="classname">
                            <%#Eval("classname")%>
                        </td>
                       
                        <td id="itemname" runat="server">
                            <%#Eval("itemname")%>
                        </td>
                         <td>
                            <%#Eval("rowid")%>
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
                        <td colspan="6" class="b_red">
                            没有该月考核数据！
                        </td>
                    </tr>
                </FooterTemplate>
            </asp:Repeater>
            <tr  style='display:<%=bool.Parse((repData.Items.Count==0).ToString())?"none":""%>' >
                <td colspan="4">
                    合计：
                </td>
                <td runat="server" id="trtotal">
                </td>
                <td>
                </td>
            </tr>
        </table>
        <p style="width: 750px;">
            <a href="javascript:history.back();">返回上一页</a></p>
    </div>
    </form>
</body>
</html>
