<%@ Page Language="C#" AutoEventWireup="true" CodeFile="gwsz.aspx.cs" Inherits="gwsz" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>系统设置</title>
    <link type="text/css" href="../css/style.css"   rel="Stylesheet"/>
</head>
<body>
    <form id="form1" runat="server">
    <div id="content">
        <p class="sitepath"><b>当前位置：</b>系统设置 > <a href="gwsz.aspx">岗位设置</a> </p>
        <br />
                  <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="width: 600px;text-align:center;" >
            <tr style="background-color: #eeeeee; line-height: 30px;">
            <td  width="60" >
            编号
            </td>
                <td   width="200">
                  岗位名称
                </td>
                 <td>
                  岗位说明
                </td>
              
            </tr>
            <asp:Repeater ID="repData" runat="server">
                <ItemTemplate>
                    <tr>
                    <td>
                    <%#Eval("roleid")%>
                    </td>
                        <td>
                            <%#Eval("rolename")%>
                        </td>
                         <td>
                            <%#Eval("memo")%>
                        </td>
                    </tr>
                </ItemTemplate>
            </asp:Repeater>
        </table>

        
    </div>
    </form>
</body>
</html>
