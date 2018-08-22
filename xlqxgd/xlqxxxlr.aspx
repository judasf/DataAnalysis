<%@ Page Language="C#" AutoEventWireup="true" CodeFile="xlqxxxlr.aspx.cs" Inherits="xlqxxxlr" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>抢修事项管理</title>
   <script type="text/javascript" src="../Script/My97DatePicker/WdatePicker.js"></script>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />
    <script type="text/javascript">
        function chkInput() {
            var qxrq = document.getElementById("qxrq");
            if (qxrq.value.length <= 0) {
                alert("请选择抢修日期！");
                qxrq.focus();
                return false;
            }
            var qxdd = document.getElementById("qxdd");
            if (qxdd.value.length <= 0) {
                alert("请录入抢修地点！");
                qxdd.focus();
                return false;
            }
            var ssje = document.getElementById("ssje");
            if (ssje.value.length <= 0) {
                alert("请录入直接损失金额！");
                ssje.focus();
                return false;
            } else if (/[^0-9\.]/.test(ssje.value)) {
            alert("录入的直接损失金额有误，请重新输入！");
            ssje.focus();
                return false;
            }
            
            var qxss = document.getElementById("qxss");
            if (qxss.value.length <= 0) {
                alert("请录入抢修损失！");
                qxss.focus();
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
               <p class="sitepath"><b>当前位置：</b>抢修事项管理 >  <a href="xlqxxxgl.aspx">抢修信息管理</a>><a href="xlqxxxlr.aspx">抢修信息录入</a> </p>
        <br />
        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1"  class="tablewidth">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                    抢修信息录入
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="30">
                    序号：
                </td>
                <td class="tdinput">
                    <asp:TextBox ID="id" runat="server" ReadOnly="true"></asp:TextBox>
                    <span style="color: #F00;">*</span>
                </td>
              
                <td class="tdtitle">
                    抢修日期：
                </td>
                <td class="tdinput">
                    <asp:TextBox ID="qxrq" runat="server" class="Wdate" onFocus="WdatePicker({isShowClear:false,readOnly:true})"></asp:TextBox>
                    <span style="color: #F00;">*</span>
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="30">
                    抢修地点：
                </td>
                <td class="tdinput" colspan="3" >
                    <asp:TextBox ID="qxdd" runat="server" MaxLength="1000"  
                        Width="398px"></asp:TextBox>
                    <span style="color: #F00;">*</span>
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="30">
                    报公安日期：
                </td>
                <td class="tdinput">
                    <asp:TextBox ID="bgarq" runat="server" class="Wdate" onFocus="WdatePicker({isShowClear:false,readOnly:true})"></asp:TextBox>
                    
                </td>
              
                <td class="tdtitle">
                    报保险公司日期：
                </td>
                <td class="tdinput">
                    <asp:TextBox ID="bbxgsrq" runat="server" class="Wdate" onFocus="WdatePicker({isShowClear:false,readOnly:true})"></asp:TextBox>
                    
                </td>
            </tr>
            <tr><td class="tdtitle" height="30">保险公司是否出现场：</td>
            <td class="tdinput">
                <asp:DropDownList ID="bxgscxc" runat="server">
                 <asp:ListItem >否</asp:ListItem>
                <asp:ListItem >是</asp:ListItem>
                </asp:DropDownList>
                </td>
                <td class="tdtitle">直接损失金额：</td>
                 <td class="tdinput">
                     <asp:TextBox ID="ssje" runat="server"></asp:TextBox><span style="color: #F00;">*</span></td>
            </tr>
             <tr>
                <td class="tdtitle" height="60">
                    抢修损失：
                </td>
                <td class="tdinput" colspan="3" >
                    <asp:TextBox ID="qxss" runat="server" MaxLength="1000"  Rows="4" TextMode="MultiLine"
                        Width="398px"></asp:TextBox>
                    <span style="color: #F00;">*</span>
                </td>
            </tr>
            <tr>
                <td colspan="4" align="center" class="btnp">
                    <asp:Button ID="Button1" runat="server" Text="提交抢修信息" OnClientClick="return chkInput();"
                        OnClick="Button1_Click" />
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
