<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="ywbkh_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>网络部员工考核</title>
    <link href="css/login-box.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <div style="padding: 10% 0 0 35%;">
        <div id="login-box" style="text-align: center;">
            <h2 style="font-size: 24px; text-align: center;">
                网络部员工考核</h2>
            <br />
            <br />
            <br />
            <div class="login-box-name" style="margin-top: 20px;">
                账 号：</div>
            <div class="login-box-field" style="margin-top: 20px;">
                <input name="username" id="username" class="form-login" title="username" value="" size="30" maxlength="2048"
                    runat="server" /></div>
            <div class="login-box-name">
                密 码：</div>
            <div class="login-box-field">
                <input name="password" id="password" type="password" class="form-login" title="Password" value="" size="30"
                    maxlength="2048" runat="server" /></div>
            <br />
            <br />
            <br />

            <asp:ImageButton ID="ImageButton1" runat="server"  style="margin-top:20px;"
                ImageUrl="~/ywbkh/images/login-btn.png" onclick="ImageButton1_Click" />

        </div>
    </div>
    </form>
</body>
</html>
