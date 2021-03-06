﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Marks_f.aspx.cs" Inherits="Marks_f" %>

<%@ Register Src="menu.ascx" TagName="menu" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>网络部员工考核</title>
    <link href="css/style.css" type="text/css" rel="Stylesheet" />
    <script type="text/javascript">
        function chkblank() {
            var IsNum = /^[\d|\.]*$/;
            for (i = 0; i < 7; i++) {
                var num;
                num = "0" + i;
                var score1 = document.getElementById("rep_ctl" + num + "_txt_score1")
                var score2 = document.getElementById("rep_ctl" + num + "_txt_score2")
                if (score1.value == "") {
                    alert("请输入考核得分！");
                    score1.focus();
                    return false;
                }
                else {
                    if (!IsNum.test(score1.value)) {
                        alert("输入得分不正确，请检测！");
                        score1.focus();
                        return false;
                    }
                }
                if (score2.value == "") {
                    alert("请输入考核得分！");
                    score2.focus();
                    return false;
                }
                else {
                    if (!IsNum.test(score2.value)) {
                        alert("输入得分不正确，请检测！");
                        score2.focus();
                        return false;
                    }
                }
            }
            if (confirm("您确定要提交分数吗？提交后将不能更改！"))
                return true;
            else
                return false;

        }

    </script>
</head>
<body style="margin: 0;">
    <form id="form1" runat="server">
    <table style="border-collapse: collapse" bordercolor="#f5f5ff" cellspacing="0" cellpadding="6"
        width="100%" bgcolor="#f5f5ff" border="2">
        <tbody>
            <tr>
                <td class="head" align="center" height="25">
                    <b style="font-size: 18px;">网络部员工考核</b>
                </td>
            </tr>
            <tr>
                <td valign="center" bgcolor="#ced4e8" height="18">
                    <uc1:menu ID="menu1" runat="server" />
                    <asp:Label ID="lblDeptName" Style="margin-left: 35%; display: inline; text-align: center;
                        color: Black; font-weight: 700;" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
            <tr>
                <td valign="top" align="center" bgcolor="#f5f5ff">
                    <table style="border-collapse: collapse" bordercolor="#6a71a3" cellspacing="1" cellpadding="3"
                        width="96%" border="1">
                        <tbody>
                            <tr>
                                <td class="head" align="left">
                                    <b>考核评分</b>
                                </td>
                            </tr>
                            <tr align="center">
                                <td>
                                    <p align="left">
                                        <b>评分月份：<b id="markmonth" runat="server"></b></b></p>
                                    <table style="border-collapse: collapse" bordercolor="#6a71a3" cellspacing="1" cellpadding="3"
                                        width="40%" border="1">
                                        <tbody>
                                            <tr>
                                                <td colspan="4">
                                                    <b>其它加扣分 </b>：全省有通报的各项工作中，排名前三加5分，排名前6加3分，低于全省平均水平扣2分，排名12名之后扣3分，排名后三扣5分 。
                                                </td>
                                            </tr>
                                            <tr class="bold" align="center" bgcolor="#ced4e8">
                                                <td width="10%">
                                                    编号
                                                </td>
                                                <td width="30%">
                                                    姓名
                                                </td>
                                                <td>
                                                    扣分项                                                </td>
                                                    <td>
                                                    加分项                                                </td>
                                            </tr>
                                            <asp:Repeater ID="rep" runat="server">
                                                <ItemTemplate>
                                                    <tr align="left">
                                                        <td align="center">
                                                            <%#Container.ItemIndex+1 %>
                                                        </td>
                                                        <td align="center">
                                                            <%#Eval("username") %>
                                                            <asp:HiddenField ID="uname" runat="server" Value='<%#Eval("username") %>' />
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txt_score1" runat="server"></asp:TextBox>
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txt_score2" runat="server"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </tbody>
                                    </table>
                                    <div align="center">
                                        <asp:Button ID="Button1" class="btn" runat="server" Text="提交" OnClick="Button1_Click"
                                            OnClientClick="return chkblank();" />
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <script type="text/javascript">

                        function view() {
                            var y = document.getElementById("ddlYm").value;
                            var url = "view_f.aspx?ym=" + y;
                            window.open(url, "view", "resizable=yes,scrollbars=yes,location=no,toolbar=no,menubar=no,status=no");
                        }
                    </script>
                    <table style="border-collapse: collapse; margin-top: 5px;" bordercolor="#6a71a3"
                        cellspacing="1" cellpadding="3" width="96%" border="1">
                        <tbody align="left">
                            <tr bgcolor="#9fb5ec">
                                <td class="head">
                                    以往考核得分查询
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    &nbsp;&nbsp;
                                    <asp:DropDownList ID="ddlYm" runat="server">
                                    </asp:DropDownList>
                                    &nbsp;&nbsp;
                                    <input onclick="view()" class="btn" type="button" value="查看" />
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </td>
            </tr>
        </tbody>
    </table>
    </form>
</body>
</html>
