﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="nsbdxxllgl.aspx.cs" Inherits="nsbdxxllgl" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>南水北调事项处理</title>
    <link type="text/css" href="../css/style.css"   rel="Stylesheet"/>
    <style type="text/css">td { padding: 2px;}</style>
</head>
<body>
    <form id="form1" runat="server">
    <div id="content">
       <p class="sitepath">
            <b>当前位置：</b>南水北调事项管理 > <a href="nsbdxxllgl.aspx">南水北调领料信息管理</a>
        </p>
        <p style="text-align: left;line-height:30px;">
            <b>数据查询：</b>选择出库日期： 从
            <asp:DropDownList ID="ddlMonth" runat="server">
            </asp:DropDownList>
            至
            <asp:DropDownList ID="ddlMonth1" runat="server">
            </asp:DropDownList> 
                    <b>领料型号：</b>
                    <asp:DropDownList ID="ddlType" runat="server">
                    </asp:DropDownList>&nbsp;&nbsp;&nbsp;
         <b>领料单位：</b><asp:DropDownList ID="lldw" runat="server">
                    </asp:DropDownList>
                      <b>南水北调编号：</b><asp:TextBox ID="nsbdid" runat="server"></asp:TextBox>
                    </p>
            <p style="line-height:40px;">
            <span class="btnp" style="text-align: left; padding-left: 5px;">
                <asp:Button ID="btnSearch" runat="server" Text="查询数据" OnClick="btnSearch_Click" />    
                <asp:Button ID="btnExportExcel" runat="server" Text="导出Excel" OnClick="btnExportExcel_Click" /></span>
        </p>
        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1"  style="table-layout:fixed;">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td width="40">
                   序号
                </td>
                <td width="100">
                    南水北调编号
                </td>
                <td width="130">
                    出库时间
                </td>
                <td width="120">
                    领料单位
                </td>
                <td width="100">
                    领料人
                </td>
                <td width="90">
                   联系电话
                </td>
                <td width="80">
                    物资类别
                </td>
                <td width="180">
                    物资型号
                </td>
                <td width="40">
                    盘号
                </td>
                <td width="60">
                    数量
                </td>
                <td width="40">
                  单位            
                </td>
                
            </tr>
            <asp:Repeater ID="repData" runat="server">
                <ItemTemplate>
                    <tr>
                        <td>
                           <%#Eval("id")%>
                        </td>
                        <td>
                            <%#Eval("nsbdid")%>
                        </td>
                        <td>
                            <%#Eval("cksj")%>
                        </td>
                        <td>
                            <%#Eval("lldw")%>
                        </td>
                        <td>
                            <%#Eval("llr")%>
                        </td>
                        <td>
                            <%#Eval("lxdh")%>
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
                         <%#Eval("amount")%>
                        </td>
                        <td>
                         <%#Eval("units")%>
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
