<%@ Page Language="C#" AutoEventWireup="true" CodeFile="xlzgxxwbllqr.aspx.cs" Inherits="xlbdxxxq" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>整改事项管理</title>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
    <div id="content">
     <p class="sitepath">
            <b>当前位置：</b>整改事项管理 > <a href="xlzgxxgl.aspx">整改信息管理</a>> 外包对区域维护领料单确认
        </p>
        <br />
        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1"  class="tablewidth">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                    外包对区域维护领料单确认
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    编号：
                </td>
                <td class="tdinput" id="zgid" runat="server">
                </td>
                <td class="tdtitle">
                    派单单位：
                </td>
                <td class="tdinput" id="pddw" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle" >
                    派单人：
                </td>
                <td class="tdinput"  id="pdr" runat="server">
                </td>
                <td class="tdtitle" >
                    派单时间：
                </td>
                <td class="tdinput"  id="pdsj" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle" >
                    联系人：
                </td>
                <td class="tdinput"  id="lxr" runat="server">
                </td>
                <td class="tdtitle" >
                    联系电话：
                </td>
                <td class="tdinput"  id="lxdh" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle" >
                    维护单位：
                </td>
                <td class="tdinput"  id="whdw" runat="server">
                </td>
                <td class="tdtitle" >
                    负责人：
                </td>
                <td class="tdinput"  id="fzr" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                  区域维护：
                </td>
                <td class="tdinput"  id="qywh" runat="server">
                </td>
                <td class="tdtitle">
                    整改人：
                </td>
                <td class="tdinput" id="zgr" runat="server">
                </td>
            </tr>
            <tr >
                <td class="tdtitle">
                    整改措施：
                </td>
                <td class="tdinput" colspan="3" height="50" id="zgcs" runat="server">
                </td>
            </tr>
             <tr >
                <td class="tdtitle">
                   领料人：
                </td>
                <td class="tdinput"  id="llr" runat="server">
                </td>
                 <td class="tdtitle">
                   联系电话：
                </td>
                <td class="tdinput"  id="llrlxdh" runat="server">
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
                    <asp:Button ID="Button1" runat="server" Text="外包对区域维护领料单确认" 
                        onclick="Button1_Click" />
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
