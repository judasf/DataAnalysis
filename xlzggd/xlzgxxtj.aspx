<%@ Page Language="C#" AutoEventWireup="true" CodeFile="xlzgxxtj.aspx.cs" Inherits="xlbdxxtj" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>整改事项管理</title>
       <link type="text/css" href="../css/style.css"   rel="Stylesheet"/>

</head>
<body>
    <form id="form1" runat="server">
    <div id="content">
        <p class="sitepath">
            <b>当前位置：</b>整改事项管理 > <a href="xlzgxxtj.aspx">整改信息统计</a>
        </p>
           <p style="text-align: left;">
            <b>数据查询：</b>选择年份： 
            <asp:DropDownList ID="ddlYear" runat="server">
            </asp:DropDownList>
               选择派发单位： 
            <asp:DropDownList ID="ddlpfdw" runat="server">
            </asp:DropDownList>
                  选择工单状态： 
            <asp:DropDownList ID="ddlqrwj" runat="server">
                <asp:ListItem Value="0">--全部--</asp:ListItem>
                <asp:ListItem Value="1">已完结</asp:ListItem>
                <asp:ListItem Value="2">未完结</asp:ListItem>
            </asp:DropDownList>
            <span class="btnp" style="text-align: left; padding-left: 35px;">
                <asp:Button ID="btnSearch" runat="server" Text="查询数据" OnClick="btnSearch_Click" />
                <asp:Button ID="btnExportExcel" runat="server" Text="导出Excel" OnClick="btnExportExcel_Click" /></span>
        </p>
        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" >
            <tr style="background-color: #eeeeee; ">
                <td width="120" >
                    派单单位
                </td>
                <td width="50">
                    1月
                </td>
                <td width="50">
                    2月
                </td>
                <td width="50">
                    3月
                </td>
                <td width="50">
                    4月
                </td>
                <td width="50">
                    5月
                </td>
                <td width="50">
                    6月
                </td>
                <td width="50">
                    7月
                </td>
                <td width="50">
                    8月
                </td>
                <td width="50">
                    9月
                </td>
                <td width="50">
                    10月
                </td>
                <td width="50">
                    11月
                </td>
                <td width="50">
                    12月
                </td>
            </tr>
            
            <asp:Repeater ID="repData" runat="server">
                <ItemTemplate>
                    <tr>
                    <td >
                     <%#Eval("pfdw") %>
                </td>
                    <td >
                    <a  href="<%#JudgeLinkBypfdw(Eval("pfdw").ToString()) %>?qj=<%=year%>-01&jz=<%=year%>-01&dw=<%#Eval("pfdw") %>" title="查看详细信息"> <%#Eval("num1") %></a>
                </td>
                
                 <td >
                    <a  href="<%#JudgeLinkBypfdw(Eval("pfdw").ToString()) %>?qj=<%=year%>-02&jz=<%=year%>-02&dw=<%#Eval("pfdw") %>" title="查看详细信息"><%#Eval("num2") %></a>
                </td>
              
                 <td >
                   <a  href="<%#JudgeLinkBypfdw(Eval("pfdw").ToString()) %>?qj=<%=year%>-03&jz=<%=year%>-03&dw=<%#Eval("pfdw") %>" title="查看详细信息"> <%#Eval("num3") %></a>
                </td>
                
                 <td >
                    <a  href="<%#JudgeLinkBypfdw(Eval("pfdw").ToString()) %>?qj=<%=year%>-04&jz=<%=year%>-04&dw=<%#Eval("pfdw") %>" title="查看详细信息"><%#Eval("num4") %></a>
                </td>
                
                 <td >
                 <a  href="<%#JudgeLinkBypfdw(Eval("pfdw").ToString()) %>?qj=<%=year%>-05&jz=<%=year%>-05&dw=<%#Eval("pfdw") %>" title="查看详细信息">   <%#Eval("num5") %></a>
                </td>
                
                 <td >
                   <a  href="<%#JudgeLinkBypfdw(Eval("pfdw").ToString()) %>?qj=<%=year%>-06&jz=<%=year%>-06&dw=<%#Eval("pfdw") %>" title="查看详细信息"> <%#Eval("num6") %></a>
                </td>
               <td >
                   <a  href="<%#JudgeLinkBypfdw(Eval("pfdw").ToString()) %>?qj=<%=year%>-07&jz=<%=year%>-07&dw=<%#Eval("pfdw") %>" title="查看详细信息"> <%#Eval("num7") %></a>
                </td>
                
                 <td >
                  <a  href="<%#JudgeLinkBypfdw(Eval("pfdw").ToString()) %>?qj=<%=year%>-08&jz=<%=year%>-08&dw=<%#Eval("pfdw") %>" title="查看详细信息">  <%#Eval("num8") %></a>
                </td>
                
                 <td >
                   <a  href="<%#JudgeLinkBypfdw(Eval("pfdw").ToString()) %>?qj=<%=year%>-09&jz=<%=year%>-09&dw=<%#Eval("pfdw") %>" title="查看详细信息"> <%#Eval("num9") %></a>
                </td>
                
                 <td >
                           <a  href="<%#JudgeLinkBypfdw(Eval("pfdw").ToString()) %>?qj=<%=year%>-10&jz=<%=year%>-10&dw=<%#Eval("pfdw") %>" title="查看详细信息">  <%#Eval("num10") %></a>
                </td>
                
                 <td >
                           <a  href="<%#JudgeLinkBypfdw(Eval("pfdw").ToString()) %>?qj=<%=year%>-11&jz=<%=year%>-11&dw=<%#Eval("pfdw") %>" title="查看详细信息">  <%#Eval("num11") %></a>
                </td>
                
                 <td >
                           <a  href="<%#JudgeLinkBypfdw(Eval("pfdw").ToString()) %>?qj=<%=year%>-12&jz=<%=year%>-12&dw=<%#Eval("pfdw") %>" title="查看详细信息">  <%#Eval("num12") %></a>
                </td>
                
                    </tr>
                </ItemTemplate>
            </asp:Repeater>
        </table>
      
    </div>
    </form>
</body>
</html>
