<%@ Page Language="C#" AutoEventWireup="true" CodeFile="yjkxxlr.aspx.cs" Inherits="yjkxxlr" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>应急库事项管理</title>
        <link type="text/css" href="../css/style.css" rel="Stylesheet" />
    <script type="text/javascript">
        function chkInput() {
            var True = true;
            var False = false;
            var ddljsdw = document.getElementById("ddljsdw");
            if (ddljsdw.value== 0) {
                alert("请选择接收单位！");
                ddljsdw.focus();
                return false;
            }
           
            var ddlClass = document.getElementById("ddlClass");
            if (ddlClass.value == "0") {
                alert("请选择类别！");
                return false;
            }
            var ddlType = document.getElementById("ddlType");
            if (ddlType.value == "0") {
                alert("请选择型号！");
                return false;
            }
            var amount = document.getElementById("amount");
            //判断盘号begin
            if(<%
            if(Session["uname"] == null)
           Response.Redirect("yjkxxgl.aspx");
           else
           Response.Write(PanHaoShow(ddlClass.SelectedItem.Text,ddlType.SelectedItem.Text));
           %>){
                var ddlPanhao = document.getElementById("ddlPanhao");
                var phkc = document.getElementById("phkc");
                if (ddlPanhao.value == "0") {
                    alert("请选择盘号！");
                    return false;
                }
                if (phkc.value == "0" || (parseInt(amount.value, 10) > parseInt(phkc.value))) {
                    alert("当前盘号库存不足，无法领取！");
                    return false;
                }
            }
            //end
            if (amount.value.length <= 0) {
                alert("请录入领料数量！");
                amount.focus();
                return false;
            }
            if (amount.value.search("^-?\\d+$") != 0) {
                alert("录入的领料数量不正确！");
                amount.focus();
                return false;
            }
            var kcamount = document.getElementById("kcamount");
            if (kcamount.value == "0" || (parseInt(amount.value, 10) > parseInt(kcamount.value))) {
                alert("库存不足，无法领取！");
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
            <b>当前位置：</b>应急库事项管理 > <a href="yjkxxlr.aspx">应急库信息录入</a>
        </p>
        <br />
        <table border="1" bordercolor="#CCCCCC" cellpadding="0" cellspacing="0" class="tablewidth">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                    应急库信息录入
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    编号：
                </td>
                <td class="tdinput"  ID="id" runat="server" colspan="3">
                    
                </td>
                </tr>
                <tr>
                <td class="tdtitle">
                    派单时间：
                </td>
                <td class="tdinput" ID="pdsj" runat="server" >
                   
                </td>
                 <td class="tdtitle">
                    派单人：
                </td>
                <td class="tdinput" ID="pdr" runat="server" >
                   
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                   接收单位：
                </td>
                <td class="tdinput">
                    <asp:DropDownList ID="ddljsdw" runat="server">
                    </asp:DropDownList>
                    <span style="color: #F00;">*</span>
                </td>
                <td class="tdtitle">
                    备注：
                </td>
                <td class="tdinput">
                    <asp:TextBox ID="bz" runat="server" Rows="3" TextMode="MultiLine"></asp:TextBox>
                 
                </td>
            </tr>
            <tr>
                <td colspan="4">
                    领料内容
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    类别：
                </td>
                <td class="tdinput">
                    <asp:DropDownList ID="ddlClass" runat="server">
                    </asp:DropDownList>
                    <span style="color: #F00;">*</span>
                </td>
                <td class="tdtitle">
                    型号：
                </td>
                <td class="tdinput">
                    <asp:DropDownList ID="ddlType" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlType_SelectedIndexChanged">
                        <asp:ListItem Value="0">请选择型号</asp:ListItem>
                    </asp:DropDownList>
                    <span style="color: #F00;">*</span>
                </td>
            </tr>
            <tr id="trPanhao" runat="server" style="display:none;">
                <td class="tdtitle">
                    盘号：
                </td>
                <td class="tdinput">
                    <asp:DropDownList ID="ddlPanhao" runat="server" AutoPostBack="True" 
                        onselectedindexchanged="ddlPanhao_SelectedIndexChanged">
                        <asp:ListItem Value="0">请选择盘号</asp:ListItem>
                    </asp:DropDownList>
                    （<span style="color: #F00;">针对电缆、光缆</span>）
                </td>
                <td class="tdtitle">
                    <span style="color: Red;">当前盘号库存：</span>
                </td>
                <td align="left">
                    <asp:TextBox ID="phkc" runat="server" ReadOnly="true" Style="color: Red;"></asp:TextBox>(单位：<span
                        runat="server" id="units3"></span>)
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    数量：
                </td>
                <td align="left">
                    <asp:TextBox ID="amount" runat="server"></asp:TextBox>(单位：<span runat="server" id="units1"></span>)<span
                        style="color: #F00;">*</span>
                </td>
                <td class="tdtitle">
                    <span style="color: Red;">型号总库存：</span>
                </td>
                <td align="left">
                    <asp:TextBox ID="kcamount" runat="server" ReadOnly="true" Style="color: Red;"></asp:TextBox>(单位：<span
                        runat="server" id="units2"></span>)
                </td>
            </tr>
            <tr>
                <td colspan="4" align="center" class="btnp">
                    <asp:Button ID="Button1" runat="server" Text="确定" OnClientClick="return chkInput();"
                        OnClick="Button1_Click" />
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
