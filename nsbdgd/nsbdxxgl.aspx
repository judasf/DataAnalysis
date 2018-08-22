<%@ Page Language="C#" AutoEventWireup="true" CodeFile="nsbdxxgl.aspx.cs" Inherits="nsbdxxgl" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>南水北调事项处理</title>
    <link type="text/css" href="../css/style.css"   rel="Stylesheet"/>
</head>
<body>
    <form id="form1" runat="server">
    <div id="content">
    <p class="sitepath"><b>当前位置：</b>南水北调事项处理 > <a href="nsbdxxgl.aspx">南水北调信息管理</a> </p>
        <p style="text-align: left;" >
            <b>数据查询：</b>选择发生日期： 从
            <asp:DropDownList ID="ddlMonth" runat="server">
            </asp:DropDownList>
            至
            <asp:DropDownList ID="ddlMonth1" runat="server">
            </asp:DropDownList>
            选择迁建线路地点：
            <asp:DropDownList ID="ddl_dd" runat="server">
                <asp:ListItem Value="0">请选择地点</asp:ListItem>
                    <asp:ListItem Value="市区">市区</asp:ListItem>
                    <asp:ListItem Value="汤阴">汤阴</asp:ListItem>
                    <asp:ListItem Value="内黄">内黄</asp:ListItem>
                    <asp:ListItem Value="滑县">滑县</asp:ListItem>
            </asp:DropDownList>
            南水北调编号：<asp:TextBox ID="nsbdid" runat="server"></asp:TextBox>
            <span class="btnp" style="text-align: left; padding-left: 25px;">
                <asp:Button ID="btnSearch" runat="server" Text="查询数据" OnClick="btnSearch_Click" />
                <asp:Button ID="btnExportExcel" runat="server" Text="导出Excel" OnClick="btnExportExcel_Click" /></span>
        </p>
        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="table-layout:fixed;"  >
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td width="100">
                    编号
                </td>
                <td width="120">
                    申请时间
                </td>
                <td width="100">
                    申请单位
                </td>
                <td width="80">
                    地点
                </td>
                <td width="100">
                    施工地段
                </td>
                <td width="80">
                    联系人
                </td>
                <td width="80">
                    施工单位
                </td>
                 <td width="80">
                  验收人
                </td>
                <td width="120">
                  审计金额
                </td>
                <td width="80">
                    是否领料
                </td>
                <td width="80">
                    是否退料
                </td>
                <td width="80">
                    是否验收
                </td>
               <td width="80">
                    审计状态
                </td>
                  <td width="40"  <%=isAdminYW?"":"style='display:none'" %>>
                  操作
                </td>
            </tr>
            <asp:Repeater ID="repData" runat="server">
                <ItemTemplate>
                    <tr>
                        <td>
                            <%# "<a href=nsbdxxxq.aspx?id="+ Eval("id")+" title='点击查看详情'>"+ Eval("id")+"</a>"%>
                        </td>
                        <td>
                            <%#Eval("fssj")%>
                        </td>
                        <td>
                            <%#Eval("fsdw")%>
                        </td>
                         <td>
                            <%#Eval("dd")%>
                        </td>
                        <td>
                            <%#Eval("sgdd")%>
                        </td>
                        <td>
                            <%#Eval("lxr")%>
                        </td>
                        <td>
                            <%#Eval("sgdw")%>
                        </td>
                         <td>
                            <%#Eval("ysr")%>
                        </td>
                        <td>
                            <%#Eval("sjje")%>
                        </td>
                        <td>
                            <%#handleLL(Eval("id").ToString(), Eval("qgll").ToString())%>
                        </td>
                        <td>
                            <%#handleTL(Eval("id").ToString(), Eval("qgtl").ToString(), Eval("qgll").ToString())%>
                        </td>
                         <td>
                            <%#handleYS(Eval("id").ToString(), Eval("ysr").ToString(), Eval("qgtl").ToString())%>
                        </td>
                        <td>
                            <%#handleSJ(Eval("id").ToString(), Eval("sssj").ToString(), Eval("sjsj").ToString(), Eval("ffsj").ToString(), Eval("ysr").ToString())%>
                        </td>
                        <td <%=isAdminYW?"":"style='display:none'" %>>
                        <%#handleDel(Eval("id").ToString(), Eval("qgll").ToString())%>
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
            跳转到<asp:Literal ID="Literal1" runat="server"></asp:Literal></p>
    </div>
    </form>
</body>
</html>
