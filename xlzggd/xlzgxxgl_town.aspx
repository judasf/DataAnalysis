<%@ Page Language="C#" AutoEventWireup="true" CodeFile="xlzgxxgl_town.aspx.cs" Inherits="xlzgxxgl_town" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>整改事项处理</title>
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
            <b>当前位置：</b>整改事项管理 > <a href="xlzgxxgl.aspx">县公司整改信息管理</a>
        </p>
        <p style="text-align: left; line-height: 30px;">
            <b>数据查询：</b>选择整改日期：  从 
                   <asp:TextBox runat="server" Style="width: 65px;" ID="ddlMonth" class="Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM',readOnly:'true'})"></asp:TextBox>
                至
               <asp:TextBox runat="server" Style="width: 65px;" ID="ddlMonth1" class="Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM',readOnly:'true'})" ></asp:TextBox>
            选择派单单位：
            <asp:DropDownList ID="ddlpfdw" runat="server">
            </asp:DropDownList>
            选择区域维护：
            <asp:DropDownList ID="ddlqywh" runat="server">
            </asp:DropDownList>
            工单状态：<asp:DropDownList ID="gdzt" runat="server">
                <asp:ListItem Value='0'>-------全部-------</asp:ListItem>
                <asp:ListItem Value='qyll'>区域领料未领料</asp:ListItem>
                <asp:ListItem Value='kgcl'>库管出料未出库</asp:ListItem>
                <asp:ListItem Value='wbzg'>外包整改未整改</asp:ListItem>
                <asp:ListItem Value='zgwj'>整改完结未完结</asp:ListItem>
                <asp:ListItem Value='sftl'>整改完结未退料</asp:ListItem>
            </asp:DropDownList>
            整改编号：<asp:TextBox ID="zgid" runat="server"></asp:TextBox>
        </p>
        <p style="line-height: 40px;">
            <span class="btnp" style="text-align: left; padding-left: 15px;">
                <asp:Button ID="btnSearch" runat="server" Text="查询数据" OnClick="btnSearch_Click" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnExportExcel" runat="server" Text="导出Excel" OnClick="btnExportExcel_Click" /></span>
        </p>
        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="table-layout:fixed;">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td width="100">
                    编号
                </td>
                <td width="100">
                    派单时间
                </td>
                <td width="80">
                    派单单位
                </td>
                <td width="80">
                    派单人
                </td>
                <td width="80">
                    维护单位
                </td>
                <td width="80">
                    区域维护
                </td>
                <td width="80">
                    整改领料
                </td>
                <td width="80">
                    库管出料
                </td>
                <td width="80">
                    外包整改
                </td>
                <td width="100">
                    整改完结并复查
                </td>
                <td width="80">
                    是否退料
                </td>
                <td width="40" <%=isAdminYW?"":"style='display:none'" %>>
                    操作
                </td>
            </tr>
            <asp:Repeater ID="repData" runat="server">
                <ItemTemplate>
                    <tr>
                        <td>
                            <%# "<a href=xlzgxxxq.aspx?zgid="+ Eval("id")+" title='点击查看详情'>"+ Eval("id")+"</a>"%>
                        </td>
                        <td>
                            <%#Eval("pdsj")%>
                        </td>
                        <td>
                            <%#Eval("pfdw")%>
                        </td>
                        <td>
                            <%#Eval("pdr")%>
                        </td>
                        <td>
                            <%#Eval("whdw")%>
                        </td>
                        <td>
                            <%#Eval("qywh")%>
                        </td>
                        <td>
                            <%#handleQYLL(Eval("id").ToString(), Eval("zgll").ToString())%>
                        </td>
                        <td>
                            <%#handleKGQR(Eval("id").ToString(), Eval("kgck").ToString(), Eval("zgll").ToString())%>
                        </td>
                        <td>
                            <%#handleWBZGWJ(Eval("id").ToString(), Eval("wjsj").ToString(), Eval("kgck").ToString())%>
                        </td>
                        <td>
                            <%#handleXGQRWJ(Eval("id").ToString(), Eval("qrwjsj").ToString(), Eval("zgbz").ToString(), Eval("wjsj").ToString())%>
                        </td>
                        <td>
                            <%#handleTL(Eval("id").ToString(), Eval("zgtl").ToString(),Eval("zgtd").ToString())%>
                        </td>
                        <td <%=isAdminYW?"":"style='display:none'" %>>
                            <a href="javascript:if(confirm('确认删除该条数据？')) location.href='?id=<%#Eval("id")%>&action=del';"
                                title="删除">删除</a>
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
