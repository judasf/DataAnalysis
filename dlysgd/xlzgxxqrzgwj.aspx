<%@ Page Language="C#" AutoEventWireup="true" CodeFile="xlzgxxqrzgwj.aspx.cs" Inherits="xlzgxxqrzgwj" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>电缆延伸事项管理</title>

   <script type="text/javascript" src="../Script/My97DatePicker/WdatePicker.js"></script>

    <link type="text/css" href="../css/style.css" rel="Stylesheet" />
    <script type="text/javascript">
        function chkInput() {
            var wjsj = document.getElementById("wjsj");
            if (wjsj.value.length <= 0) {
                alert("请选择电缆延伸完结时间！");
                wjsj.focus();
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
            <b>当前位置：</b>电缆延伸事项管理 > <a href="xlzgxxgl.aspx">电缆延伸信息管理</a>>确认外包电缆延伸完结
        </p>
        <table border="1" bordercolor="#CCCCCC" cellpadding="0" cellspacing="0" class="tablewidth">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                    确认外包电缆延伸完结
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
                <td class="tdtitle">
                    派单人：
                </td>
                <td class="tdinput" id="pdr" runat="server">
                </td>
                <td class="tdtitle">
                    派单时间：
                </td>
                <td class="tdinput" id="pdsj" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    联系人：
                </td>
                <td class="tdinput" id="lxr" runat="server">
                </td>
                <td class="tdtitle">
                    联系电话：
                </td>
                <td class="tdinput" id="lxdh" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    维护单位：
                </td>
                <td class="tdinput" id="whdw" runat="server">
                </td>
                <td class="tdtitle">
                    负责人：
                </td>
                <td class="tdinput" id="fzr" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    电缆延伸区域：
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
                    电缆延伸要求：
                </td>
                <td class="tdinput" colspan="3" id="zgyq" runat="server" height="30">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    电缆延伸时限：
                </td>
                <td class="tdinput" colspan="3" id="zgsx" runat="server" height="30">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    区域维护：
                </td>
                <td class="tdinput" id="qywh" runat="server">
                </td>
                <td class="tdtitle">
                    电缆延伸人：
                </td>
                <td class="tdinput" id="zgr" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    电缆延伸措施：
                </td>
                <td class="tdinput" colspan="3" height="50" id="zgcs" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    电缆延伸完结时间：
                </td>
                <td class="tdinput" colspan="3" id="wjsj" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    确认完结时间：
                </td>
                <td class="tdinput" >
                    <asp:TextBox ID="qrwjsj" runat="server" class="Wdate" onFocus="WdatePicker({isShowClear:false,readOnly:true,dateFmt:'yyyy-MM-dd HH:mm:ss'})"></asp:TextBox>
                   </td>
                    <td class="tdtitle">
                    电缆延伸备注：
                </td>
                <td class="tdinput">
                    <asp:TextBox ID="zgbz" runat="server" TextMode="MultiLine" Rows="3" MaxLength="500" Width="200px"></asp:TextBox>
                </td>
            </tr>
            <tr><td colspan="4" class="btnp">  <asp:Button ID="Button1" runat="server" Text="设置电缆延伸完结时间" OnClientClick="return chkInput()"
                OnClick="Button1_Click" /></td></tr>
        </table>
       
    </div>
    </form>
</body>
</html>
