<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Marks_b.aspx.cs" Inherits="Marks_b" %>

<%@ Register src="menu.ascx" tagname="menu" tagprefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>运行维护部员工考核</title>
    <link href="css/style.css" type="text/css" rel="Stylesheet" />
    <script type="text/javascript">
        function chkblank() {
            var IsNum = /^[-|\d|\.]*$/;
            for (i = 0; i < 7; i++) {
                var num;
                num = "0" + i;  
                var score = document.getElementById("rep_ctl" + num + "_txt_score")
                if (score.value == "") {
                    alert("请输入考核得分！");
                    score.focus();
                    return false;
                }
                else {
                    if (!IsNum.test(score.value)) {
                        alert("输入得分不正确，请检测！");
                        score.focus();
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
                    <b style="font-size: 18px;">运行维护部员工考核</b>
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
                                                <td colspan="3">
                                                    <b>信息报道</b>：每人每月至少上报信息1篇，每差一篇扣5分。凡信息被市公司采用的加2分，被省公司采用的加5分。<span style="color:red">注：扣分输入正值，加分输入负值。</span>
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
                                                    评分
                                                </td>
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
                                                            <asp:TextBox ID="txt_score" runat="server"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </tbody>
                                    </table>
                                    <div align="center">
                                        <asp:Button ID="Button1"  class="btn" runat="server" Text="提交" OnClick="Button1_Click" OnClientClick="return chkblank();" />
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <script type="text/javascript">

                        function view() {
                            var y = document.getElementById("ddlYm").value;
                            var url = "view_b.aspx?ym=" + y;
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
                                    <input onclick="view()"  class="btn" type="button" value="查看" />
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
