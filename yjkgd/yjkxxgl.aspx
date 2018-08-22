<%@ Page Language="C#" AutoEventWireup="true" CodeFile="yjkxxgl.aspx.cs" Inherits="yjkxxgl" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>应急库事项管理</title>
    <script type="text/javascript" src="../Script/My97DatePicker/WdatePicker.js"></script>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />
    <style type="text/css">
        td { padding: 2px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div id="content">
            <p class="sitepath">
                <b>当前位置：</b>应急库事项管理 > <a href="yjkxxgl.aspx">应急库信息管理</a>
            </p>
            <p style="text-align: left;">
                <b>数据查询：</b>选择派单时间： 从 
                   <asp:TextBox runat="server" Style="width: 65px;" ID="ddlMonth" class="Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM',readOnly:'true'})"></asp:TextBox>
                至
               <asp:TextBox runat="server" Style="width: 65px;" ID="ddlMonth1" class="Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM',readOnly:'true'})"></asp:TextBox>
                接收单位：<asp:DropDownList ID="ddljsdw" runat="server">
                </asp:DropDownList>
                编号：<asp:TextBox ID="id" runat="server"></asp:TextBox>
                <span class="btnp" style="text-align: left; padding-left: 35px;">
                    <asp:Button ID="btnSearch" runat="server" Text="查询数据" OnClick="btnSearch_Click" />
                    <asp:Button ID="btnExportExcel" runat="server" Text="导出Excel" OnClick="btnExportExcel_Click" /></span>
            </p>
            <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="table-layout:fixed;">
                <tr style="background-color: #eeeeee; line-height: 30px;">
                    <td width="120">编号
                    </td>
                    <td width="160">派单时间
                    </td>
                    <td width="100">派单人
                    </td>
                    <td width="100">接收单位
                    </td>
                    <td width="100">接收人
                    </td>
                    <td width="120">是否接收
                    </td>
                    <td width="180">备注
                    </td>
                </tr>
                <asp:Repeater ID="repData" runat="server">
                    <ItemTemplate>
                        <tr>
                            <td>
                                <a href="yjkxxxq.aspx?id=<%#Eval("id")%>" title="点击查看详情"><%#Eval("id")%></a>
                            </td>
                            <td>
                                <%#Eval("pdsj")%>
                            </td>
                            <td>
                                <%#Eval("pdr")%>
                            </td>
                            <td>
                                <%#Eval("jsdw")%>
                            </td>
                            <td>
                                <%#Eval("jsr")%>
                            </td>
                            <td>
                                <%#handleJS(Eval("id").ToString(), Eval("jsr").ToString(), Eval("jsdw").ToString())%>
                            </td>
                            <td>
                                <%#Eval("bz")%>
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
                跳转到<asp:Literal ID="Literal1" runat="server"></asp:Literal>页
            </p>
        </div>
    </form>
</body>
</html>
