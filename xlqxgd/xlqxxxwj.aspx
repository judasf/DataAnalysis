﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="xlqxxxwj.aspx.cs" Inherits="xlqxxxwj" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>抢修事项管理</title>

   <script type="text/javascript" src="../Script/My97DatePicker/WdatePicker.js"></script>

    <link type="text/css" href="../css/style.css" rel="Stylesheet" />

    <script type="text/javascript">
        function chkInput() {
            var hfsj = document.getElementById("hfsj");
            if (hfsj.value.length <= 0) {
                alert("请选择抢修恢复时间！");
                hfsj.focus();
                return false;
            }
            if (confirm("确认该抢修已完结！"))
                return true;
            else
                return false;
        }
           
    </script>

</head>
<body>
    <form id="form1" runat="server">
    <div id="content">
      <p class="sitepath"><b>当前位置：</b>抢修事项管理 > <a href="xlqxxxgl.aspx">抢修信息管理</a>>>设置抢修恢复时间  </p>
        
        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" class="tablewidth">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                    >设置抢修恢复时间 
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="30" width="120">
                   编号：
                </td>
                <td class="tdinput" width="200">
                    <asp:Label ID="qxid" runat="server" Text="Label"></asp:Label>
                </td>
                <td class="tdtitle" width="120">
                    抢修日期：
                </td>
                <td class="tdinput" width="200">
                    <asp:Label ID="qxrq" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="30">
                    抢修地点：
                </td>
                <td class="tdinput" colspan="3">
                    <asp:Label ID="qxdd" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="30">
                    报公安日期：
                </td>
                <td class="tdinput">
                    <asp:Label ID="bgarq" runat="server" Text="Label"></asp:Label>
                </td>
                <td class="tdtitle">
                    报保险公司日期：
                </td>
                <td class="tdinput">
                    <asp:Label ID="bbxgsrq" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="30">
                    保险公司是否出现场：
                </td>
                <td class="tdinput">
                    <asp:Label ID="bxgscxc" runat="server" Text="Label"></asp:Label>
                </td>
                <td class="tdtitle">
                    直接损失金额：
                </td>
                <td class="tdinput">
                    <asp:Label ID="ssje" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="60">
                    抢修损失：
                </td>
                <td class="tdinput" colspan="3">
                    <asp:Label ID="qxss" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
            <tr>
                <td height="30" class="tdtitle">
                    抢修恢复时间：
                </td>
                <td colspan="3" class="tdinput">
                    <asp:TextBox ID="hfsj" runat="server" Width="150" class="Wdate" onFocus="WdatePicker({isShowClear:false,readOnly:true,dateFmt:'yyyy-MM-dd HH:mm:ss'})"></asp:TextBox>
                    <span style="color: #F00;">*</span>
                </td>
            </tr>
            <tr>
                <td colspan="4" align="center" height="30" class="btnp">
                    <asp:Button ID="Button1" runat="server" Text="抢修工单已完结" OnClientClick="return chkInput();"
                        OnClick="Button1_Click" />
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
