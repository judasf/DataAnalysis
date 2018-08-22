<%@ Page Language="C#" AutoEventWireup="true" CodeFile="xlzgxxtllr.aspx.cs" Inherits="xlzgxxtllr" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>整改事项管理</title>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />

    <script type="text/javascript">
        function chkInput() {
            var tlxx = document.getElementById("tlxx");
            if (tlxx.value.length <= 0) {
                alert("请录入退料信息！");
                tlxx.focus();
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
            <b>当前位置：</b>整改事项管理 > <a href="xlzgxxgl.aspx">整改信息管理</a>> 整改退料信息录入
        </p>
        <table border="1" bordercolor="#CCCCCC" cellpadding="0" cellspacing="0" class="tablewidth">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                    整改退料信息录入
                </td>
            </tr>
            <tr>
                <td colspan="4">
                    线路整改信息
                </td>
            </tr>
               <tr>
                <td class="tdtitle">
                    编号：
                </td>
                <td class="tdinput"  id="zgid" runat="server">
                </td>
                <td class="tdtitle">
                    派单单位：
                </td>
                <td class="tdinput"  id="pfdw" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    派单人：
                </td>
                <td class="tdinput"  id="pdr" runat="server">
                </td>
                <td class="tdtitle">
                    派单时间：
                </td>
                <td class="tdinput"  id="pdsj" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    联系人：
                </td>
                <td class="tdinput"  id="lxr" runat="server">
                </td>
                <td class="tdtitle">
                    联系电话：
                </td>
                <td class="tdinput"  id="lxrdh" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    维护单位：
                </td>
                <td class="tdinput"  id="whdw" runat="server">
                </td>
                <td class="tdtitle">
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
               
            </tr>
            <tr>
                <td class="tdtitle" >
                    退料信息：
                </td>
                <td class="tdinput" colspan="3">
                    <asp:TextBox ID="tlxx" runat="server" Rows="4" MaxLength="500" TextMode="MultiLine"
                        Width="441px"></asp:TextBox>
                    <span style="color: #F00;">*</span>
                </td>
            </tr>
            <tr>
                <td colspan="4" align="center" class="btnp">
                    <asp:Button ID="Button1" runat="server" Text="提交退料信息" OnClientClick="return chkInput();"
                        OnClick="Button1_Click" />
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
