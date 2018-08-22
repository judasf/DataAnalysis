<%@ Page Language="C#" AutoEventWireup="true" CodeFile="xlzgqdqywh.aspx.cs" Inherits="xlzgqdqywh" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>整改事项管理</title>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />
<script type="text/javascript">
        function chkInput() {
            var qywh = document.getElementById("qywh");
            if (qywh.value == "0") {
                alert("请选择区域维护！");
                qywh.focus();
                return false;
            }
            if (confirm("提交前请确认信息无误！"))
                return true;
            else
                return false;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div id="content">
        <p class="sitepath">
            <b>当前位置：</b>整改事项管理 > <a href="xlzgxxgl.aspx">整改信息管理</a>>确定整改区域维护
        </p>
        <br />
        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" class="tablewidth">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                    确定整改区域维护
                </td>
            </tr>
            <tr>
                <td class="tdtitle" >
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
                <td class="tdtitle">
                    派单人：
                </td>
                <td class="tdinput" id="pdr" runat="server">
                </td>
                <td class="tdtitle" >
                    派单时间：
                </td>
                <td class="tdinput" id="pdsj" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle" >
                    联系人：
                </td>
                <td class="tdinput" ID="lxr" runat="server">
                   
                </td>
                <td class="tdtitle" >
                    联系电话：
                </td>
                <td class="tdinput"  ID="lxdh" runat="server">
                    
                </td>
            </tr>
            <tr>
                <td class="tdtitle" width="90">
                    维护单位：
                </td>
                <td class="tdinput" width="180" id="whdw" runat="server">
                </td>
                <td class="tdtitle" width="90">
                    负责人：
                </td>
                <td class="tdinput" width="180" id="fzr" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    整改区域：
                </td>
                <td class="tdinput" colspan="3" id="zgqy" runat="server" height="30">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    存在问题：
                </td>
                <td class="tdinput" colspan="3" id="czwt" runat="server" height="100" valign="top">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    整改要求：
                </td>
                <td class="tdinput" colspan="3" id="zgyq" runat="server" height="30">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    整改时限：
                </td>
                <td class="tdinput" colspan="3" id="zgsx" runat="server" height="30">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                   区域维护：
                </td>
                <td class="tdinput" colspan="3" height="30">
                    <asp:DropDownList ID="qywh" runat="server">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr><td colspan="4" class="btnp"><asp:Button ID="Button1" runat="server" OnClientClick="return chkInput()" Text="确定整改区域维护" OnClick="Button1_Click" /></td></tr>
        </table>
       
            
       
    </div>
    </form>
</body>
</html>
