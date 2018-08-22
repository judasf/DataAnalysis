<%@ Page Language="C#" AutoEventWireup="true" CodeFile="yjylkclbgl.aspx.cs" Inherits="yjylkclbgl" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>库存管理</title>
    <link type="text/css" href="../css/style.css"   rel="Stylesheet"/>
        
    <script type="text/javascript">
        function chkInput() {
            var classname = document.getElementById("ddlClass");
            if (classname.value =="0") {
                alert("请选择库存类别！");
                return false;
            }
            var txtType = document.getElementById("txtType");
            if (txtType.value.length <= 0) {
                alert("请录入型号！");
                txtType.focus();
                return false;
            }
            var txtUnits = document.getElementById("txtUnits");
            if (txtUnits.value.length <= 0) {
                alert("请录入型号的单位！");
                txtUnits.focus();
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
        <p class="sitepath"><b>当前位置：</b>库存管理 > <a href="yjylkckctjb.aspx">库存统计表</a> > <a href="yjylkclbgl.aspx">库存型号管理</a> </p>
                  <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="table-layout:fixed;">
            <tr style="background-color: #eeeeee; line-height: 30px;">
            <td width="40">
            序号
            </td>
                <td width="80">
                   库存类别
                </td>
                <td >
                    型号
                </td>
                <td width="50">
                    单位
                </td>
                   <td width="80">
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
                            <%#Eval("classname")%>
                        </td>
                        <td>
                            <%#Eval("typename")%>
                        </td>
                        <td>
                            <%#Eval("units")%>
                        </td>
                       <td>
                             <asp:Button ID="btnDel" CommandName="btnDel" CommandArgument='<%#Eval("classname")+"$"+Eval("typename")+"$"+Eval("typeid")%>'    OnClientClick="return confirm('您确定要删除该型号吗？')"  runat="server" Text="删除型号"  style="padding: 3px 6px;" />
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

        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="width: 500px;">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                   型号添加
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                  库存类别：
                </td>
                <td colspan="3" align="left">
                    <asp:DropDownList ID="ddlClass" runat="server">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                   型号：
                </td>
                <td colspan="3" align="left">
                    <asp:TextBox ID="txtType" runat="server"></asp:TextBox>
                </td>
            </tr>
                        <tr>
                <td class="tdtitle">
                   单位：
                </td>
                <td colspan="3" align="left">
                    <asp:TextBox ID="txtUnits" runat="server"></asp:TextBox>
                </td>
            </tr>

            <tr>
                <td colspan="4" align="center" class="btnp">
                    <asp:Button ID="Button1" runat="server" Text="添加型号" 
                        OnClientClick="return chkInput();" onclick="Button1_Click" />
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
