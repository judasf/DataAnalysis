<%@ Page Language="C#" AutoEventWireup="true" CodeFile="xlbdxxtllr.aspx.cs" Inherits="xlbdxxtllr" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>被盗事项管理</title>
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
           <p class="sitepath"><b>当前位置：</b>被盗事项管理 > <a href="xlbdxxgl.aspx">被盗信息管理</a>> 被盗退料信息录入</p>
     <br />

        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1"  class="tablewidth">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                    被盗退料信息录入
                </td>
            </tr>
            <tr>
                <td colspan="4">
                   线路被盗信息
                </td>
            </tr>
          <tr>
                <td class="tdtitle">
                    编号：
                </td>
                <td class="tdinput" style="background-color: #eeeeee;"  ID="bdid" runat="server">
                  
                </td>
                <td class="tdtitle">
                    被盗日期：
                </td>
                <td class="tdinput" style="background-color: #eeeeee;" ID="bdrq" runat="server">
                 
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    被盗地点：
                </td>
                <td class="tdinput" colspan="3" style="background-color: #eeeeee;" ID="bddd" runat="server" >
                    
                </td>
            </tr>
            <tr>
            <tr>
                <td class="tdtitle" width="90">
                    退料信息：
                </td>
                <td class="tdinput" colspan="3">
                    <asp:TextBox ID="tlxx" runat="server" Rows="4" MaxLength="1000" TextMode="MultiLine"
                        Width="441px"></asp:TextBox>
                    <span style="color: #F00;">*</span>
                </td>
            </tr>
            <tr>
                <td colspan="4" align="center"  class="btnp">
                    <asp:Button ID="Button1" runat="server" Text="提交退料信息" OnClientClick="return chkInput();"
                        OnClick="Button1_Click" />
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
