﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="View_c.aspx.cs" Inherits="View_c" %>

<%--<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
--%><html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>打分表</title>
    <link href="css/style.css" rel="stylesheet" type="text/css" />
</head>
<body style="margin: 5px 0;">
    <form id="form1" runat="server">
    <table border="2" width="100%" height="100%" cellpadding="6" cellspacing="0" bgcolor="#F5F5FF"
        style="border-collapse: collapse" bordercolor="#F5F5FF">
        <tr>
            <td class="head" align="center" height="25">
                <b style="font-size: 18px;">网络部员工考核</b>
            </td>
        </tr>
        <tr>
            <td bgcolor="#F5F5FF" align="center" valign="top">
                <p align="left">
                    <b >评分月份：<%=Request.QueryString["ym"] %></b></p><b id="noScore"  style="display:none;">本月分数尚未填写！</b>
                <table border="1" width="50%" cellspacing="1" cellpadding="3" style="border-collapse: collapse;" bordercolor='#6A71A3'id="scoreList" >
                     <tr>
                                                <td colspan="3">
                                                    <b>基础报表</b>：未按时出规定报表一次扣2分，被省公司通报一次扣5分。

                                                </td>
                                            </tr>
                    <tr bgcolor='#CED4E8' align="center" class="bold">
                    <td>编号</td>
                        <td> 
                            姓名
                        </td>
                        <td>
                          得分
                        </td>
                       
                    </tr>
                    <asp:Repeater ID="repList" runat="server">
                    <ItemTemplate>
                    <tr align="center">
                    <td><%#Container.ItemIndex+1 %></td>
                    <td><%#Eval("uname")%></td>
                    <td><%#Eval("score")%></td>
                    </tr>
                    </ItemTemplate>
                    </asp:Repeater>
                </table>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

