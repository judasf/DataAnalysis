<%@ Page Language="C#" AutoEventWireup="true" CodeFile="changepwd.aspx.cs" Inherits="changepwd" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>个人资料修改</title>
    <link type="text/css" href="css/style.css" rel="Stylesheet" />
    <script type="text/javascript">
       
        function chkInput() {
            var oldpwd = document.getElementById("txtOld")
            if (oldpwd.value.length <= 0) {
                alert("请输入旧密码！");
                oldpwd.focus();
                return false;
            }
            var newpwd = document.getElementById("txtNew")
            if (newpwd.value.length <= 0) {
                alert("请输入新密码！");
                newpwd.focus();
                return false;
            }
            var repwd = document.getElementById("txtRenew")
            if (repwd.value.length <= 0) {
                alert("请输入确认新密码！");
                repwd.focus();
                return false;
            }
            if (newpwd.value != repwd.value) {
                alert("两次输入的新密码不同！请重新输入");
                repwd.focus();
                return false;
            }
            else {
                if (!safePassword(newpwd.value)) {
                    alert('新密码必须包含字母、数字和符号！');
                    return false;
                }
                else
                    return true;
            }
        }
        /* 密码由字母和数字组成，至少8位 */
        var safePassword = function (value) {
            return !(/^(([A-Z]*|[a-z]*|\d*|[-_\~!@#\$%\^&\*\.\(\)\[\]\{\}<>\?\\\/\'\"]*)|.{0,7})$|\s/.test(value));
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
    <div id="content">
        <p class="sitepath">
            <b>当前位置：</b>个人资料修改 > <a href="changepwd.aspx">密码修改</a>
        </p>
        <br />
        <table border="1" bordercolor="#CCCCCC" cellpadding="0" cellspacing="0" style="width:450px;">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="2" align="center">
                    密码修改
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    用户名：
                </td>
                <td class="tdinput" id="uname" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    旧密码：
                </td>
                <td class="tdinput">
                <asp:TextBox ID="txtOld" runat="server" TextMode="Password"></asp:TextBox><span class="b_red">*</span>
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    新密码：
                </td>
                <td class="tdinput" >
                 <asp:TextBox ID="txtNew" runat="server" TextMode="Password"></asp:TextBox><span class="b_red">*</span>
                    <br />新密码必须包含字母、数字和符号，长度在8位以上
                </td>
            </tr>
            <tr >
                <td class="tdtitle">
                    确认新密码：
                </td>
                <td class="tdinput">
                      <asp:TextBox ID="txtRenew" runat="server" TextMode="Password"></asp:TextBox><span class="b_red">*</span>
                     <br />新密码必须包含字母、数字和符号，长度在8位以上
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center" class="btnp">
                    <asp:Button ID="Button1" runat="server" Text="修改" OnClientClick="return chkInput();"
                        OnClick="Button1_Click" />
                    &nbsp; &nbsp; &nbsp; &nbsp;
                    <asp:Button ID="Button2" runat="server" Text="返回" OnClick="Button2_Click" />
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
