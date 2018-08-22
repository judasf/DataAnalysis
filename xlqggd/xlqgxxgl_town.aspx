<%@ Page Language="C#" AutoEventWireup="true" CodeFile="xlqgxxgl_town.aspx.cs" Inherits="xlqgxxgl_town" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>迁改事项处理</title>
    <script type="text/javascript" src="../Script/My97DatePicker/WdatePicker.js"></script>
    <link type="text/css" href="../css/style.css"   rel="Stylesheet"/>
</head>
<body>
    <form id="form1" runat="server">
    <div id="content">
    <p class="sitepath"><b>当前位置：</b>迁改事项处理 > <a href="xlqgxxgl_town.aspx">县公司迁改信息管理</a> </p>
        <p style="text-align: left;" >
            <b>数据查询：</b>选择发生日期： 从 
                   <asp:TextBox runat="server" Style="width: 65px;" ID="ddlMonth" class="Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM',readOnly:'true'})"></asp:TextBox>
                至
               <asp:TextBox runat="server" Style="width: 65px;" ID="ddlMonth1" class="Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM',readOnly:'true'})"></asp:TextBox>
            选择发生单位：
            <asp:DropDownList ID="ddlfsdw" runat="server">
            </asp:DropDownList>
            迁改编号：<asp:TextBox ID="qgid" runat="server"></asp:TextBox>
            <span class="btnp" style="text-align: left; padding-left: 25px;">
                <asp:Button ID="btnSearch" runat="server" Text="查询数据" OnClick="btnSearch_Click" />
                <asp:Button ID="btnExportExcel" runat="server" Text="导出Excel" OnClick="btnExportExcel_Click" /></span>
        </p>
        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="table-layout:fixed;" >
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td width="120">
                    编号
                </td>
                <td width="100">
                    发生时间
                </td>
                <td width="100">
                    发生单位
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
                    是否派单
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
                            <%# "<a href=xlqgxxxq.aspx?id="+ Eval("id")+" title='点击查看详情'>"+ Eval("id")+"</a>"%>
                        </td>
                        <td>
                            <%#Eval("fssj")%>
                        </td>
                        <td>
                            <%#Eval("fsdw")%>
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
                            <%#handlePD(Eval("id").ToString(),Eval("sgdw").ToString()) %>
                        </td>
                        <td>
                            <%#handleLL(Eval("id").ToString(), Eval("qgll").ToString(), Eval("sgdw").ToString())%>
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
