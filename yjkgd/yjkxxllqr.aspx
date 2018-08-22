<%@ Page Language="C#" AutoEventWireup="true" CodeFile="yjkxxllqr.aspx.cs" Inherits="yjkxxllqr" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>应急库事项管理</title>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
    <div id="content">
     <p class="sitepath">
            <b>当前位置：</b>应急库事项管理 > <a href="yjkxxgl.aspx">应急库信息管理</a>> 库管接收派单领料信息
        </p>
        <br />
        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1"  class="tablewidth">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                   库管接收派单领料信息
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    编号：
                </td>
                <td class="tdinput" id="id" runat="server" colspan="3">
                </td>
                
            </tr>
            <tr>
             <td class="tdtitle" >
                    派单时间：
                </td>
                <td class="tdinput"  id="pdsj" runat="server">
                </td>
                <td class="tdtitle" >
                    派单人：
                </td>
                <td class="tdinput"  id="pdr" runat="server">
                </td>
               
            </tr>
            <tr>
                <td class="tdtitle" >
                   接收单位：
                </td>
                <td class="tdinput"  id="jsdw" runat="server">
                </td>
                <td class="tdtitle" >
                    接收人：
                </td>
                <td class="tdinput"  id="jsr" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle" >
                   备注：
                </td>
                <td class="tdinput"  id="bz" runat="server" colspan="3">
                </td>
               
            </tr>
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td >
                  序号
                </td>
                <td >
                物资类别
                </td>
                 <td>
                   物资型号
                </td>
                <td>
                领取数量
                </td>
            </tr>
         <asp:Repeater ID="repData" runat="server">
                <ItemTemplate>
                    <tr>
                        <td >
                           <%#Eval("rowid") %>
                        </td>
                        <td>
                          <%#Eval("classname") %>
                        </td>
                        <td >
                          <%#Eval("typename") %>
                        </td>
                        <td>
                            <%#Eval("amount") %> <%#Eval("units") %>
                        </td>
                    </tr>
                </ItemTemplate>
            </asp:Repeater>
          <tr >
                <td  colspan="4" class="btnp">
                    <asp:Button ID="Button1" runat="server" Text="库管接收派单领料信息" 
                        onclick="Button1_Click" />
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
