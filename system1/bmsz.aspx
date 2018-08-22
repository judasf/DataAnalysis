<%@ Page Language="C#" AutoEventWireup="true" CodeFile="bmsz.aspx.cs" Inherits="bmsz" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>系统设置</title>
    <link type="text/css" href="../css/style.css"   rel="Stylesheet"/>
        
    <script type="text/javascript">
        function chkInput() {
            var deptname = document.getElementById("deptname");
            if (deptname.value.length<=0) {
                alert("请输入名称！");
                deptname.focus();
                return false;
            }
            
            if (confirm("提交前请确认信息无误！"))
                return true;
            else
                return false;
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
    <div id="content">
        <p class="sitepath"><b>当前位置：</b>系统设置 > <a href="bmsz.aspx">部门设置</a> </p>
                  <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="width: 500px;text-align:center;" >
            <tr style="background-color: #eeeeee; line-height: 30px;">
            <td >
            序号
            </td>
             <td >
            所在县市
            </td>
                <td >
                   部门
                </td>
               <td >
                   删除
                </td>
            </tr>
            <asp:Repeater ID="repData" runat="server" onitemcommand="repData_ItemCommand">
                <ItemTemplate>
                    <tr>
                    <td>
                    <%#Eval("rowid")%>
                    </td>
                      <td>
                    <%#Eval("city")%>
                    </td>
                        <td>
                            <%#Eval("deptname")%>
                        </td>
                         <td>
                             <asp:Button ID="btnDel" CommandName="btnDel" CommandArgument='<%#Eval("id") %>'    OnClientClick=<%#"return confirm('您确定要删除部门【"+Eval("deptname")+"】吗？')"  %>   runat="server" Text="删除部门"  style="padding: 3px 6px;" />
                        </td>
                    </tr>
                </ItemTemplate>
            </asp:Repeater>
        </table>
          <p style="width:500px">
            有<asp:Literal ID="RecordCount" runat="server"></asp:Literal>条记录 共有<asp:Literal ID="PageCount"
                runat="server"></asp:Literal>页 当前第<asp:Literal ID="Pageindex" runat="server"></asp:Literal>页
            <asp:HyperLink ID="FirstPage" runat="server" Text="首页"></asp:HyperLink>
            <asp:HyperLink ID="PrevPage" runat="server" Text="上一页"></asp:HyperLink>
            <asp:HyperLink ID="NextPage" runat="server" Text="下一页"></asp:HyperLink>
            <asp:HyperLink ID="LastPaeg" runat="server" Text="尾页"></asp:HyperLink>
            跳转到<asp:Literal ID="Literal1" runat="server"></asp:Literal>页</p>
<br />
       <%-- <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="width: 500px;">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="2" align="center">
                   部门添加
                </td>
            </tr>
              <tr>
                <td class="tdtitle">
                 所在县市：
                </td>
                <td  align="left">
                    <asp:DropDownList ID="pre" runat="server">
                    <asp:ListItem Value="">市区</asp:ListItem>
                    <asp:ListItem Value="AYX_">安阳县</asp:ListItem>
                    <asp:ListItem Value="LZS_">林州市</asp:ListItem>
                    <asp:ListItem Value="TYX_">汤阴县</asp:ListItem>
                    <asp:ListItem Value="HX_">滑县</asp:ListItem>
                    <asp:ListItem Value="NHX_">内黄县</asp:ListItem>
                    </asp:DropDownList>
                </td>
                </tr>
            <tr>
                <td class="tdtitle">
                  名称：
                </td>
                <td  align="left">
                    <asp:TextBox ID="deptname" runat="server"></asp:TextBox>
                </td>
            </tr>
                 

            <tr>
                <td colspan="2" align="center" class="btnp">
                    <asp:Button ID="Button1" runat="server" Text="部门添加" 
                        OnClientClick="return chkInput();" onclick="Button1_Click" />
                </td>
            </tr>
        </table>--%>
    </div>
    </form>
</body>
</html>
