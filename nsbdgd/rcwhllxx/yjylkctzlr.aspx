<%@ Page Language="C#" AutoEventWireup="true" CodeFile="yjylkctzlr.aspx.cs" Inherits="yjylkctzlr" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>日常维护事项管理</title>
        <link type="text/css" href="../css/style.css" rel="Stylesheet" />
    <script type="text/javascript">
        function chkInput() {
       
            var lldw = document.getElementById("lldw");
            if (lldw.value.length <= 0) {
                alert("请录入领料单位！");
                lldw.focus();
                return false;
            }
            var llr = document.getElementById("llr");
            if (llr.value.length <= 0) {
                alert("请录入领料人！");
                llr.focus();
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
            if (ddlClass.value == "1" || ddlClass.value == "2") {
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
            if (ddlClass.value == "4") {//只判断辅件
                //附件新增判断1
                var ddlType1 = document.getElementById("ddlType1");
                var amount1 = document.getElementById("amount1");
                var kcamount1 = document.getElementById("kcamount1");
                if (ddlType1.value != "0") {
                    if (amount1.value.length <= 0) {
                        alert("请录入数量1！");
                        amount1.focus();
                        return false;
                    }
                    if (amount1.value.search("^-?\\d+$") != 0) {
                        alert("录入的数量1不正确！");
                        amount1.focus();
                        return false;
                    }
                    if (kcamount1.value == "0" || (parseInt(amount1.value, 10) > parseInt(kcamount1.value))) {
                        alert("型号1库存不足，无法领取！");
                        return false;
                    }
                }
                //附件新增判断2
                var ddlType2 = document.getElementById("ddlType2");
                var amount2 = document.getElementById("amount2");
                var kcamount2 = document.getElementById("kcamount2");
                if (ddlType2.value != "0") {
                    if (amount2.value.length <= 0) {
                        alert("请录入数量2！");
                        amount2.focus();
                        return false;
                    }
                    if (amount2.value.search("^-?\\d+$") != 0) {
                        alert("录入的数量2不正确！");
                        amount2.focus();
                        return false;
                    }
                    if (kcamount2.value == "0" || (parseInt(amount2.value, 10) > parseInt(kcamount2.value))) {
                        alert("型号2库存不足，无法领取！");
                        return false;
                    }
                }
                //附件新增判断3
                var ddlType3 = document.getElementById("ddlType3");
                var amount3 = document.getElementById("amount3");
                var kcamount3 = document.getElementById("kcamount3");
                if (ddlType3.value != "0") {
                    if (amount3.value.length <= 0) {
                        alert("请录入数量3！");
                        amount3.focus();
                        return false;
                    }
                    if (amount3.value.search("^-?\\d+$") != 0) {
                        alert("录入的数量3不正确！");
                        amount3.focus();
                        return false;
                    }
                    if (kcamount3.value == "0" || (parseInt(amount3.value, 10) > parseInt(kcamount3.value))) {
                        alert("型号3库存不足，无法领取！");
                        return false;
                    }
                }
            }
            
            var yldz = document.getElementById("yldz");
            if (yldz.value.length <= 0) {
                alert("请录入用料地址！");
                yldz.focus();
                return false;
            }
            var llyt = document.getElementById("llyt");
            if (llyt.value.length <= 0) {
                alert("请录入领料用途！");
                llyt.focus();
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
            <b>当前位置：</b>日常维护事项管理 > <a href="yjylkctzlr.aspx">日常领料信息录入</a>
        </p>
        <br />
        <table border="1" bordercolor="#CCCCCC" cellpadding="0" cellspacing="0" class="tablewidth">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                    日常领料信息录入
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
                    出库时间：
                </td>
                <td class="tdinput" ID="cksj" runat="server" >
                   
                </td>
                 <td class="tdtitle">
                    出库单位：
                </td>
                <td class="tdinput" ID="ckdw" runat="server" >
                   
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    领料单位：
                </td>
                <td class="tdinput">
                    <asp:TextBox ID="lldw" runat="server"></asp:TextBox>
                    <span style="color: #F00;">*</span>
                </td>
                <td class="tdtitle">
                    领料人：
                </td>
                <td class="tdinput">
                    <asp:TextBox ID="llr" runat="server"></asp:TextBox>
                    <span style="color: #F00;">*</span>
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
                    <asp:DropDownList ID="ddlClass" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlClass_SelectedIndexChanged">
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
                <!--辅件新增-->
           
              <tr   id="addtr1"  runat="server" style="display:none;">
                <td class="tdtitle" >
                    型号1：
                </td>
                <td class="tdinput" colspan="3" >
                    <asp:DropDownList ID="ddlType1" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlType1_SelectedIndexChanged">
                        <asp:ListItem Value="0">请选择型号</asp:ListItem>
                    </asp:DropDownList>
                  
                </td>
            </tr>
             <tr  id="addtr2"  runat="server" style="display:none;">
                <td class="tdtitle">
                    数量1：
                </td>
                <td align="left">
                    <asp:TextBox ID="amount1" runat="server"></asp:TextBox>
                </td>
                <td class="tdtitle">
                    <span style="color: Red;">型号1总库存：</span>
                </td>
                <td align="left">
                    <asp:TextBox ID="kcamount1" runat="server" ReadOnly="true" Style="color: Red;"></asp:TextBox>
               (单位：<span runat="server" id="unitAdd1"></span>)
                </td>
            </tr>
            <tr   id="addtr3"  runat="server" style="display:none;">
                <td class="tdtitle">
                    型号2：
                </td>
                <td class="tdinput" colspan="3">
                    <asp:DropDownList ID="ddlType2" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlType2_SelectedIndexChanged">
                        <asp:ListItem Value="0">请选择型号</asp:ListItem>
                    </asp:DropDownList>
                  
                </td>
            </tr>
             <tr  id="addtr4"  runat="server" style="display:none;">
                <td class="tdtitle">
                    数量2：
                </td>
                <td align="left">
                    <asp:TextBox ID="amount2" runat="server"></asp:TextBox>
                </td>
                <td class="tdtitle">
                    <span style="color: Red;">型号2总库存：</span>
                </td>
                <td align="left">
                    <asp:TextBox ID="kcamount2" runat="server" ReadOnly="true" Style="color: Red;"></asp:TextBox>
                      (单位：<span runat="server" id="unitAdd2"></span>)
                </td>
            </tr>
             <tr  id="addtr5"  runat="server" style="display:none;" >
                <td class="tdtitle">
                    型号3：
                </td>
                <td class="tdinput" colspan="3">
                    <asp:DropDownList ID="ddlType3" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlType3_SelectedIndexChanged">
                        <asp:ListItem Value="0">请选择型号</asp:ListItem>
                    </asp:DropDownList>
                  
                </td>
            </tr>
             <tr  id="addtr6"  runat="server" style="display:none;">
                <td class="tdtitle">
                    数量3：
                </td>
                <td align="left">
                    <asp:TextBox ID="amount3" runat="server"></asp:TextBox>
                </td>
                <td class="tdtitle">
                    <span style="color: Red;">型号3总库存：</span>
                </td>
                <td align="left">
                    <asp:TextBox ID="kcamount3" runat="server" ReadOnly="true" Style="color: Red;"></asp:TextBox>
                      (单位：<span runat="server" id="unitAdd3"></span>)
                </td>
            </tr>
       
            <!--辅件新增 end-->
            <tr>
                <td class="tdtitle">
                    <span>用料地址：</span>
                </td>
                <td align="left" colspan="3">
                    <asp:TextBox ID="yldz" runat="server" MaxLength="500" Rows="2" TextMode="MultiLine"
                        Width="360px"></asp:TextBox><span style="color: #F00;">*</span>
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    领料用途：
                </td>
                <td colspan="3" align="left">
                    <asp:TextBox ID="llyt" runat="server" MaxLength="500" Rows="4" TextMode="MultiLine"
                        Width="360px"></asp:TextBox><span style="color: #F00;">*</span>
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    备注：
                </td>
                <td colspan="3" align="left">
                    <asp:TextBox ID="bz" runat="server" MaxLength="500" Rows="2" TextMode="MultiLine"
                        Width="360px"></asp:TextBox>
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
