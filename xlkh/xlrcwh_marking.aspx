<%@ Page Language="C#" AutoEventWireup="true" CodeFile="xlrcwh_marking.aspx.cs" Inherits="xlkh_xlrcwh_marking" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>线路考核管理</title>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />
    <script type="text/javascript">
        function chkInput() {
            var deptname = document.getElementById("deptname");
            if (deptname.value == "0") {
                alert("选择被考核分公司！");
                deptname.focus();
                return false;
            }
            //获取文本框数量
            var num = 0;
            var txtInput = document.getElementsByTagName("input");
            for (var j = 0; j < txtInput.length; j++) {
                if (txtInput[j].type == "text")
                    num++;
            }
            var txtScore;
            var lblMarks;
            var total = 0;
            for (var i = 0; i < num; i++) {
                iStr = i < 10 ? "0" + i.toString() : i.toString();
                txtScore = document.getElementById("repData_ctl" + iStr + "_txtscore")
                //lblMarks = document.getElementById("repData_ctl" + iStr + "_lblMarks")
                if (txtScore.value.length <= 0) {
                    alert("请输入扣分！");
                    txtScore.focus();
                    return false;
                }
                //else if (Number(txtScore.value) > Number(lblMarks.innerHTML)) {
                //    alert("输入扣分大于该项分值，请检查输入！");
                //    txtScore.focus();
                //    return false;
                //}
                else if (!/^-?\d+(.\d+)?$/.test(txtScore.value)) {
                    alert("输入的扣分不正确，请重新输入！");
                    txtScore.focus();
                    return false;
                }
                total += Number(txtScore.value);
            }
            if (total >= 100) {
                alert("扣分已超过100分，请检查您的输入！");
                return false;
            }
            if (confirm("被考核分公司：【" + deptname.value + "】，扣分为：" + total + "，得分为：" + (100 - total) + "。确认提交考核分数？"))
                return true;
            else
                return false;
        }

    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div id="content">
            <p class="sitepath">
                <b>当前位置：</b>线路考核管理 > <a href="xlrcwh_marking.aspx">日常维护管理考核</a>
            </p>
            <p style="text-align: left;">
                <b>考核月份：</b><span id="scoredate" runat="server"></span>&nbsp;&nbsp;&nbsp;&nbsp;
            <b>被考核分公司：</b>
                <asp:DropDownList ID="deptname" runat="server">
                </asp:DropDownList>
            </p>
            <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="width: 900px;">
                <tr style="background-color: #eeeeee;">
                    <td width="80" colspan="2">类别
                    </td>

                    <td width="60">维护项目
                    </td>
                    <td width="30">序号
                    </td>
                    <td width="210">维护标准
                    </td>
                    <td width="30">分值
                    </td>
                    <td width="210">考评标准
                    </td>
                    <td width="40">扣分
                    </td>
                    <td width="120">备注 (扣分原因)<br />
                        注明地点、时间和详细扣分原因等
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
                            <td id="lblMarks" runat="server"> 
                                <%#Eval("marks")%>
                                <%--<asp:Label ID="lblMarks" runat="server"><%#Eval("marks")%></asp:Label>--%>
                            </td>
                            <td align="left">
                                <%#Eval("markstd")%>
                            </td>
                            <td>
                                <asp:TextBox ID="txtscore" runat="server" Style="width: 30px;">0</asp:TextBox><asp:HiddenField
                                    ID="hfid" runat="server" Value='<%#Eval("id") %>' />
                            </td>
                            <td>
                                <asp:TextBox ID="txtmemo" TextMode="MultiLine" runat="server" Style="width: 130px;"></asp:TextBox>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>

                <tr>
                    <td colspan="9" class="btnp">
                        <asp:Button ID="Button1" runat="server" Text="提交分数"
                            OnClientClick="return chkInput();" OnClick="Button1_Click" /></td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
