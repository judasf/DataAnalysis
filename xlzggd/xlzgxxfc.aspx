<%@ Page Language="C#" AutoEventWireup="true" CodeFile="xlzgxxfc.aspx.cs" Inherits="xlzgxxfc" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>整改事项管理</title>

   <script type="text/javascript" src="../Script/My97DatePicker/WdatePicker.js"></script>

    <link type="text/css" href="../css/style.css" rel="Stylesheet" />
  
    <script type="text/javascript">
        function chkInput() {
            var fcyj = document.getElementById("fcyj");
            if (fcyj.value.length <= 0) {
                alert("请录入复查意见！");
                fcyj.focus();
                return false;
            }
            var fcr = document.getElementById("fcr");
            if (fcr.value.length <= 0) {
                alert("请录入复查人！");
                fcr.focus();
                return false;
            }
            var fcsj = document.getElementById("fcsj");
            if (fcsj.value.length <= 0) {
                alert("请选择复查时间！");
                fcsj.focus();
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
            <b>当前位置：</b>整改事项管理 > <a href="xlzgxxgl.aspx">整改信息管理</a> > 整改复查
        </p>
        <br />
        <table border="1" bordercolor="#CCCCCC" cellpadding="0" cellspacing="0" class="tablewidth">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                    整改复查
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
                    整改区域：
                </td>
                <td class="tdinput" colspan="3" id="zgqy" runat="server" height="30">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    存在问题：
                </td>
                <td class="tdinput" colspan="3" id="czwt" runat="server" height="60" valign="top">
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
                <td class="tdinput" id="qywh" runat="server">
                </td>
                <td class="tdtitle">
                    整改人：
                </td>
                <td class="tdinput" id="zgr" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    整改措施：
                </td>
                <td class="tdinput" colspan="3" height="50" id="zgcs" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    整改完结时间：
                </td>
                <td class="tdinput" colspan="3" id="wjsj" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    确认完结时间：
                </td>
                <td class="tdinput" ID="qrwjsj" runat="server" >
                   </td>
                    <td class="tdtitle">
                    整改备注：
                </td>
                <td class="tdinput" ID="zgbz" runat="server" >
                </td>
            </tr>
           
            <tr>
                <td class="tdtitle">
                    复查意见：
                </td>
                <td class="tdinput" colspan="3" height="50">
                    <asp:TextBox ID="fcyj" runat="server" Rows="4" MaxLength="2000" TextMode="MultiLine"
                        Width="441px"></asp:TextBox>
                    <span style="color: #F00;">*</span>
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="30">
                    复查人：
                </td>
                <td class="tdinput">
                    <asp:TextBox ID="fcr" runat="server"></asp:TextBox>
                    <span style="color: #F00;">*</span>
                </td>
                <td class="tdtitle">
                    复查时间：
                </td>
                <td class="tdinput" id="Td3" runat="server">
                    <asp:TextBox ID="fcsj" runat="server" class="Wdate" onFocus="WdatePicker({isShowClear:false,readOnly:true,dateFmt:'yyyy-MM-dd HH:mm:ss'})"></asp:TextBox>
                    <span style="color: #F00;">*</span>
                </td>
            </tr>
            <tr><td colspan="4" class="btnp"><asp:Button ID="Button1" runat="server" Text="提交复查意见" OnClientClick="return chkInput()"
                OnClick="Button1_Click" /></td></tr>
        </table>
     
    </div>
    </form>
</body>
</html>
