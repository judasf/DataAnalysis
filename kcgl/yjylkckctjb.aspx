<%@ Page Language="C#" AutoEventWireup="true" CodeFile="yjylkckctjb.aspx.cs" Inherits="yjylkckctjb" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>库存管理</title>
    <link type="text/css" href="../css/style.css"   rel="Stylesheet"/>

</head>
<body>
    <form id="form1" runat="server">
    <div id="content">
        <p class="sitepath"><b>当前位置：</b>库存管理 > <a href="yjylkckctjb.aspx">库存统计表</a> </p>
        <p style="text-align: left;">
            <b>数据查询：</b>选择类别：<asp:DropDownList ID="ddlClass" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlClass_SelectedIndexChanged">
            </asp:DropDownList> &nbsp; &nbsp;选择型号：<asp:DropDownList ID="ddlType" runat="server">
             <asp:ListItem Value="0">---------------全部---------------</asp:ListItem>
            </asp:DropDownList> &nbsp; &nbsp;选择市县：<asp:DropDownList ID="ddlpre" runat="server">
            </asp:DropDownList>
            <span class="btnp" style="text-align: left; padding-left: 35px;">
                <asp:Button ID="btnSearch" runat="server" Text="查询数据" OnClick="btnSearch_Click" />
                <asp:Button ID="btnExportExcel" runat="server" Text="导出Excel" OnClick="btnExportExcel_Click" /></span>
        </p>
        <table border="1" bordercolor="#CCCCCC" cellpadding="0" cellspacing="0" class="tablewidth" style="table-layout:fixed;">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td width="80">
                     编号
                </td>
                <td width="100">
                   类别
                </td>
                <td >
                   型号
                </td>
                <td   width="80">
                   盘号
                </td>
          <td width="40">
                    单位
                </td>
                <td width="80">
                   库存数量
                </td>
           
            </tr>
            <asp:Repeater ID="repData" runat="server">
                <ItemTemplate>
                    <tr>
                        <td>
                        <%#handleEdit(Eval("id").ToString(),Eval("rowid").ToString()) %>
                        </td>
                        <td>
                            <%#Eval("classname")%>
                        </td>
                        <td>
                            <%#Eval("typename")%>
                        </td>
                         <td>
                            <%#Eval("panhao")%>
                        </td>
                          <td>
                            <%#Eval("units")%>
                        </td>
                        <td>
                            <%#Eval("amount")%>
                        </td>
                   
                    </tr>
                </ItemTemplate>
            </asp:Repeater>
        </table>
        <p>
            有<asp:Literal ID="RecordCount" runat="server"></asp:Literal>条记录 共有<asp:Literal ID="PageCount"
                runat="server"></asp:Literal>页 当前第<asp:Literal ID="Pageindex" runat="server"></asp:Literal>页
            <asp:HyperLink ID="FirstPage" runat="server" Text="首页"></asp:HyperLink>
            <asp:HyperLink ID="PrevPage" runat="server" Text="上一页"></asp:HyperLink>
            <asp:HyperLink ID="NextPage" runat="server" Text="下一页"></asp:HyperLink>
            <asp:HyperLink ID="LastPaeg" runat="server" Text="尾页"></asp:HyperLink>
            跳转到<asp:Literal ID="Literal1" runat="server"></asp:Literal>页</p>
    </div>
    </form>
</body>
</html>
