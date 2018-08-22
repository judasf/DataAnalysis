<%@ Page Language="C#" AutoEventWireup="true" CodeFile="xlqxxxgl.aspx.cs" Inherits="xlqxxxgl" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>抢修事项管理</title>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
    <div id="content">
        <p class="sitepath"><b>当前位置：</b>抢修事项管理 > <a href="xlqxxxgl.aspx">抢修信息管理</a></p>
         <p style="text-align: left;">
                <b>数据查询：</b>选择抢修日期： 从
                <asp:DropDownList ID="ddlMonth" runat="server">
                </asp:DropDownList>
                至
                <asp:DropDownList ID="ddlMonth1" runat="server">
                </asp:DropDownList>
                选择单位：
                <asp:DropDownList ID="ddlqxdw" runat="server">
                </asp:DropDownList>
                抢修编号：<asp:TextBox ID="qxid" runat="server"></asp:TextBox>
                <span class="btnp" style="text-align: left; padding-left: 35px;">
                    <asp:Button ID="btnSearch" runat="server" Text="查询数据" OnClick="btnSearch_Click" />
                    <asp:Button ID="btnExportExcel" runat="server" Text="导出Excel" OnClick="btnExportExcel_Click" /></span>
            </p>
            <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="table-layout:fixed;">
                <tr style="background-color: #eeeeee; line-height: 30px;">
                    <td width="120">
                        编号
                    </td>
                    <td width="80">
                        抢修日期
                    </td>
                    <td width="150">
                        抢修地点
                    </td>
                    <td width="80">
                        抢修单位
                    </td>
                    <td width="80">
                        损失金额(元)
                    </td>
                    <td width="120">
                        恢复时间
                    </td>
                    <td width="80">
                        是否领料
                    </td>
                      <td width="80">
                        是否退料
                    </td>
                    <td width="100">
                        是否完结
                    </td>
                    
                          <td width="60"  <%=isAdminYW?"":"style='display:none'" %>>
                  操作
                </td>
                </tr>
                <asp:Repeater ID="repData" runat="server">
                    <ItemTemplate>
                        <tr>
                            <td>
                                <%# "<a href=xlqxxxxq.aspx?qxid="+ Eval("id")+" title='点击查看详情'>"+ Eval("id")+"</a>"%>
                            </td>
                            <td>
                                <%#Eval("qxrq")%>
                            </td>
                            <td>
                                <%#Eval("qxdd")%>
                            </td>
                            <td>
                                <%#Eval("qxdw")%>
                            </td>
                            <td>
                                <%#Eval("ssje")%>
                            </td>
                            <td>
                                <%#Eval("hfsj")%>
                            </td>
                            <td>
                                <%# handleLL(Eval("id").ToString(),Eval("qxll").ToString()) %>
                            </td>
                            <td>
                                <%# handleTL(Eval("id").ToString(), Eval("qxtl").ToString(), Eval("qxll").ToString())%>
                            </td>
                            <td>
                                <%#handleWj(Eval("id").ToString(),Eval("hfsj").ToString(),Eval("qxtl").ToString())%>
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
