<%@ Page Language="C#" AutoEventWireup="true" CodeFile="zwewjc_marking.aspx.cs" Inherits="zwkh_zwewjc_marking" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>装维考核管理</title>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />
        <script type="text/javascript">
            function chkInput() {
                var txtScore;
                var lblMarks;
                var deptname = document.getElementById("deptname");
                if (deptname.value == "0") {
                    alert("选择被考核分公司！");
                    deptname.focus();
                    return false;
                }
                var total = 0;
                for (var i = 0; i < 3; i++) {
                    txtScore = document.getElementById("repData_ctl0" + i + "_txtscore")
                    if (txtScore.value.length<1) {
                        alert("请输入得分！");
                        txtScore.focus();
                        return false;
                    } else if (!/^-?\d+(.\d+)?$/.test(txtScore.value)) {
                        alert("输入的得分不正确，请重新输入！");
                        txtScore.focus();
                        return false;
                    }
                    total += Number(txtScore.value);
                }
              
                    if (confirm("额外奖惩得分为："+total+"。确认提交考核分数？"))
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
            <b>当前位置：</b>装维考核管理 > <a href="zwewjc_marking.aspx">额外奖惩指标考核</a>
        </p>
        <p style="text-align: left;"> <b>考核月份：</b><span id="scoredate" runat="server"></span>&nbsp;&nbsp;&nbsp;&nbsp;
          <b>被考核单位：</b><asp:DropDownList ID="deptname" runat="server">
                </asp:DropDownList>
        </p>
        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1"  style="width:900px;">
            <tr style="background-color: #eeeeee; ">
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
                    备注 (加/扣分原因)<br />注明地点、时间和详细扣分原因等
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
                            <asp:TextBox ID="txtscore" runat="server" Style="width: 40px;">0</asp:TextBox><asp:HiddenField
                                ID="hfid" runat="server" Value='<%#Eval("id") %>' />
                        </td>
                        <td>
                            <asp:TextBox ID="txtmemo" TextMode="MultiLine" runat="server" Style="width: 140px;"></asp:TextBox>
                        </td>
                    </tr>
                </ItemTemplate>
            </asp:Repeater>
            <tr>
            <td colspan="7" align="left">
            备注：<br />
            扣分请录入负值
            </td>
            </tr>
            <tr><td colspan="7" class="btnp">
                <asp:Button ID="Button1" runat="server" Text="提交分数" 
                    OnClientClick="return chkInput();" onclick="Button1_Click" /></td></tr>
        </table>
    </div>
    </form>
</body>
</html>
