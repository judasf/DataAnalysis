<%@ Page Language="C#" AutoEventWireup="true" CodeFile="xlzgxxzgcs.aspx.cs" Inherits="xlzgxxzgcs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title> 整改事项管理</title>
        <link type="text/css" href="../css/style.css" rel="Stylesheet" />

<script type="text/javascript">
    function chkInput() {
        var zgcs = document.getElementById("zgcs");
        if (zgcs.value.length <= 0) {
            alert("请录入整改措施！");
            zgcs.focus();
            return false;
        }
        var zgr = document.getElementById("zgr");
        if (zgr.value.length <= 0) {
            alert("请录入整改人！");
            zgr.focus();
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
            <b>当前位置：</b>整改事项管理 > <a href="xlzgxxgl.aspx">整改信息管理</a>> 区域维护整改措施录入
        </p>
        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1"  class="tablewidth">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                 区域维护整改措施录入
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
                <td class="tdinput"  id="lxdh" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle" >
                    维护单位：
                </td>
                <td class="tdinput"   id="whdw" runat="server">
                   
                </td>
                <td class="tdtitle" >
                    负责人：
                </td>
                <td class="tdinput"   id="fzr" runat="server">
                    
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
                <td class="tdinput" colspan="3" id="czwt" runat="server"  height="100" valign="top">
                  
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
                <td class="tdinput" colspan="3" id="qywh" runat="server" >
                   
                </td>
            </tr>
                        <tr>
                <td class="tdtitle">
                    整改措施：
                </td>
                <td class="tdinput" colspan="3">
                    <asp:TextBox ID="zgcs" runat="server" Rows="4" MaxLength="1000" TextMode="MultiLine"  Width="441px"></asp:TextBox>
                <span style="color: #F00;">*</span>
                </td>
            </tr>
           <tr>
                <td class="tdtitle">
                    整改人：
                </td>
                <td class="tdinput" colspan="3">
                    <asp:TextBox ID="zgr" runat="server" ></asp:TextBox>
                <span style="color: #F00;">*</span>
                
                </td>
            </tr>
        <tr><td colspan="4" class="btnp"><asp:Button ID="Button1" runat="server" Text="提交整改措施"  OnClientClick="return chkInput()"
                        OnClick="Button1_Click" /></td></tr>
        </table>  
                    
               
    </div>
    </form>
</body>
</html>
