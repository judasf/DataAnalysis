<%@ Page Language="C#" AutoEventWireup="true" CodeFile="yhgl.aspx.cs" Inherits="yhgl" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>系统设置</title>
    <link type="text/css" href="../css/style.css"   rel="Stylesheet"/>
        
    <script type="text/javascript">
        function chkInput() {
            var ddlDept = document.getElementById("ddlDept");
            if (ddlDept.value == "0") {
                alert("请选择单位！");
                ddlDept.focus();
                return false;
            }
            var ddlRole = document.getElementById("ddlRole");
            if (ddlRole.value == "100") {
                alert("请选择岗位！");
                ddlRole.focus();
                return false;
            }
            var uname = document.getElementById("uname");
            if (uname.value.length <= 0) {
                alert("请输入用户名！");
                uname.focus();
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
        <p class="sitepath"><b>当前位置：</b>系统设置 > <a href="yhgl.aspx">用户管理</a> </p>
                  <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="width: 700px" >
                       <p style="text-align: left;">
                <b>数据查询：</b>
                用户名：<asp:TextBox ID="username" runat="server"></asp:TextBox>
                <span class="btnp" style="text-align: left; padding-left: 35px;">
                    <asp:Button ID="btnSearch" runat="server" Text="查询数据" OnClick="btnSearch_Click" />
                 
            </p>
            <tr style="background-color: #eeeeee; line-height: 30px;">
              <td  width="80">
            用户编号
            </td>
                <td  width="100">
                   用户名
                </td>
               <td width="100">
                   所在单位
                </td>
                <td width="100">
                   所在岗位
                </td>
                 <td width="100">
                   恢复密码
                </td>
                 <td width="100">
                   删除
                </td>
                 <td width="100">
                   账号状态
                </td>
            </tr>
            <asp:Repeater ID="repData" runat="server" onitemcommand="repData_ItemCommand">
                <ItemTemplate>
                    <tr>
                   <td>
                    <%#Eval("rowid")%>
                    </td>
                        <td>
                            <%#Eval("uname")%>
                        </td>
                         <td>
                            <%#Eval("deptname")%>
                        </td>
                         <td>
                            <%#Eval("rolename")%>
                        </td>
                      <td >
                          <asp:Button ID="btnRecover" CommandName="btnRecover" CommandArgument='<%#Eval("uid") %>'  runat="server" Text="恢复密码" style="padding: 3px 6px;" />
                          
                        </td>
                        <td>
                             <asp:Button ID="btnDel" CommandName="btnDel" CommandArgument='<%#Eval("uid") %>'    OnClientClick=<%#"return confirm('您确定要删除用户【"+Eval("uname")+"】吗？')"  %>   runat="server" Text="删除用户"  style="padding: 3px 6px;" />
                        </td>
                         <td>
                             <asp:Button ID="btnStatus" CommandName="btnStatus" CommandArgument='<%#Eval("uid")+","+Eval("status") %>'  OnClientClick=<%#"return confirm('您确定要"+(Eval("status").ToString()=="1"?"停用":"启用")+"用户【"+Eval("uname")+"】吗？')"  %>   runat="server" Text='<%#Eval("status").ToString()=="1"?"已启用":"已停用" %>'  style="padding: 3px 6px;" />
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

        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="width: 600px;">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                   用户添加
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                 所在单位：
                </td>
                <td colspan="3" align="left">
                    <asp:DropDownList ID="ddlDept" runat="server" 
                        onselectedindexchanged="ddlDept_SelectedIndexChanged">
                    </asp:DropDownList>
                      <asp:TextBox ID="pre" runat="server"   Visible="false"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                   所在岗位：
                </td>
                <td colspan="3" align="left">
                    <asp:DropDownList ID="ddlRole" runat="server">
                    </asp:DropDownList>
                  
                </td>
            </tr>
                        <tr>
                <td class="tdtitle">
                  用户名：
                </td>
                <td colspan="3" align="left">
                    <asp:TextBox ID="uname" runat="server"></asp:TextBox>
                </td>
            </tr>

            <tr>
                <td colspan="4" align="center" class="btnp">
                    <asp:Button ID="Button1" runat="server" Text="添加用户" 
                        OnClientClick="return chkInput();" onclick="Button1_Click" />
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
