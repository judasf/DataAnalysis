<%@ Page Language="C#" AutoEventWireup="true" CodeFile="jzwykh_marking.aspx.cs" Inherits="jzkh_jzwykh_marking" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>基站考核管理</title>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />
        <script type="text/javascript">
            function chkInput() {
                var deptname = document.getElementById("deptname");
                if (deptname.value=="0") {
                    alert("选择被考核分公司！");
                    deptname.focus();
                    return false;
                }
                var txtScore;
                var total = 0;
                for (var i = 0; i < 5; i++) {
                     txtScore = document.getElementById("repData_ctl0" + i + "_txtscore")
                    if (txtScore.value.length <= 0) {
                        alert("请输入扣分！");
                        txtScore.focus();
                        return false;
                    } else if (!/^-?\d+(.\d+)?$/.test(txtScore.value))  {
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
                    if (confirm("被考核分公司：【"+deptname.value+"】，扣分为："+total+"，得分为："+(100-total)+"。确认提交考核分数？"))
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
            <b>当前位置：</b>基站考核管理 > <a href="jzwykh_marking.aspx">网优指标考核</a>
        </p>
        <p style="text-align: left;"> <b>考核月份：</b><span id="scoredate" runat="server"></span>&nbsp;&nbsp;&nbsp;&nbsp;
            <b>被考核分公司：</b>
            <asp:DropDownList ID="deptname" runat="server">
                <asp:ListItem Value="0">选择被考核分公司</asp:ListItem>
                <asp:ListItem>市区</asp:ListItem>
                <asp:ListItem>安阳县</asp:ListItem>
                <asp:ListItem>林州市</asp:ListItem>
                <asp:ListItem>汤阴县</asp:ListItem>
                <asp:ListItem>内黄县</asp:ListItem>
                <asp:ListItem>滑县</asp:ListItem>
            </asp:DropDownList>
        </p>
        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="width: 750px;">
            <tr style="background-color: #eeeeee; ">
                <td width="40">
                    类别
                </td>
                 
                <td width="100">
                   维护项目
                </td> 
                 <td width="20">
                    序号
                </td>
                <td width="180">
                    评分标准
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
                            <%#Eval("markstd")%>
                        </td>
                        <td>
                            <asp:TextBox ID="txtscore" runat="server" Style="width: 50px;">0</asp:TextBox><asp:HiddenField
                                ID="hfid" runat="server" Value='<%#Eval("id") %>' />
                        </td>
                        <td>
                            <asp:TextBox ID="txtmemo" TextMode="MultiLine" runat="server" Style="width: 150px;"></asp:TextBox>
                        </td>
                    </tr>
                </ItemTemplate>
            </asp:Repeater>
            <tr><td colspan="6" class="btnp">
                <asp:Button ID="Button1" runat="server" Text="提交分数" 
                    OnClientClick="return chkInput();" onclick="Button1_Click" /></td></tr>
        </table>
    </div>
    </form>
</body>
</html>
