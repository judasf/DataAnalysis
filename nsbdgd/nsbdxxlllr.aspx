<%@ Page Language="C#" AutoEventWireup="true" CodeFile="nsbdxxlllr.aspx.cs" Inherits="nsbdxxlllr" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>南水北调事项管理</title>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />
    <script type="text/javascript">
        function chkInput() {
        var True=true;
           var False=false;
            var cksj = document.getElementById("cksj");
            if (cksj.value.length <= 0) {
                alert("请选择出库时间！");
                cksj.focus();
                return false;
            }
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
            var lxdh = document.getElementById("lxdh");
            if (lxdh.value.length <= 0) {
                alert("请录入联系电话！");
                lxdh.focus();
                return false;
            }
            //判断领料内容1 begin
            var ddlClass1 = document.getElementById("ddlClass1");
            if (ddlClass1.value == "0") {
            ddlClass1.focus();
                alert("请选择类别1！");
                return false;
            }
            var ddlType1 = document.getElementById("ddlType1");
            if (ddlType1.value == "0") {
            ddlType1.focus();
                alert("请选择型号1！");
                return false;
            }
            var amount1 = document.getElementById("amount1");
            //判断盘号begin
            if(<%
            if(Session["uname"] == null)
           Response.Redirect("nsbdxxgl.aspx");
           else
           Response.Write(PanHaoShow(ddlClass1.SelectedItem.Text,ddlType1.SelectedItem.Text));
           %>){
            var ddlPanhao1 = document.getElementById("ddlPanhao1");
                var phkc1 = document.getElementById("phkc1");
                if (ddlPanhao1.value == "0") {
                    alert("请选择盘号1！");
                    return false;
                }
                if (phkc1.value == "0" || (parseInt(amount1.value, 10) > parseInt(phkc1.value))) {
                    alert("当前盘号库存不足，无法领取，请确认输入的数量1是否正确！");
                    amount1.focus();
                    return false;
                }
            }
            //end
            if (amount1.value.length <= 0) {
                alert("请录入领料数量1！");
                amount1.focus();
                return false;
            }
            if (amount1.value.search("^-?\\d+$") != 0) {
                alert("录入的领料数量1不正确！");
                amount1.focus();
                return false;
            }
            var kcamount1 = document.getElementById("kcamount1");
            if (kcamount1.value == "0" || (parseInt(amount1.value, 10) > parseInt(kcamount1.value))) {
                alert("库存不足，无法领取,请确认输入的数量1是否正确！");
                amount1.focus();
                return false;
            }
            //判断领料内容1 end
            //判断领料内容2 begin
            var ddlClass2 = document.getElementById("ddlClass2");
            if (ddlClass2.value != "0") {


                var ddlType2 = document.getElementById("ddlType2");
                if (ddlType2.value == "0") {
                    alert("请选择型号2！");
                    return false;
                }
                var amount2 = document.getElementById("amount2");
                  //判断盘号begin
            if(<%=PanHaoShow(ddlClass2.SelectedItem.Text,ddlType2.SelectedItem.Text) %>){
            var ddlPanhao2 = document.getElementById("ddlPanhao2");
                var phkc2 = document.getElementById("phkc2");
                if (ddlPanhao2.value == "0") {
                    alert("请选择盘号2！");
                    return false;
                }
                if (phkc2.value == "0" || (parseInt(amount2.value, 10) > parseInt(phkc2.value))) {
                    alert("当前盘号库存不足，无法领取，请确认输入的数量1是否正确！");
                    amount1.focus();
                    return false;
                }
            }
            //end
              
                if (amount2.value.length <= 0) {
                    alert("请录入领料数量2！");
                    amount2.focus();
                    return false;
                }
                if (amount2.value.search("^-?\\d+$") != 0) {
                    alert("录入的领料数量2不正确！");
                    amount2.focus();
                    return false;
                }
                var kcamount2 = document.getElementById("kcamount2");
                if (kcamount2.value == "0" || (parseInt(amount2.value, 10) > parseInt(kcamount2.value))) {
                    alert("库存不足，无法领取,请确认输入的数量2是否正确！");
                    amount2.focus();
                    return false;
                }
            }
            //判断领料内容2 end
            //判断领料内容3 begin
            var ddlClass3 = document.getElementById("ddlClass3");
            if (ddlClass3.value != "0") {


                var ddlType3 = document.getElementById("ddlType3");
                if (ddlType3.value == "0") {
                    alert("请选择型号3！");
                    return false;
                }
                var amount3 = document.getElementById("amount3");
                //判断盘号begin
                if(<%=PanHaoShow(ddlClass3.SelectedItem.Text,ddlType3.SelectedItem.Text) %>){
                    var ddlPanhao3 = document.getElementById("ddlPanhao3");
                    var phkc3 = document.getElementById("phkc3");
                    if (ddlPanhao3.value == "0") {
                        alert("请选择盘号3！");
                        return false;
                    }
                    if (phkc3.value == "0" || (parseInt(amount3.value, 10) > parseInt(phkc3.value))) {
                        alert("当前盘号库存不足，无法领取，请确认输入的数量3是否正确！");
                        amount3.focus();
                        return false;
                    }
                }
                //end
                if (amount3.value.length <= 0) {
                    alert("请录入领料数量3！");
                    amount3.focus();
                    return false;
                }
                if (amount3.value.search("^-?\\d+$") != 0) {
                    alert("录入的领料数量3不正确！");
                    amount3.focus();
                    return false;
                }
                var kcamount3 = document.getElementById("kcamount3");
                if (kcamount3.value == "0" || (parseInt(amount3.value, 10) > parseInt(kcamount3.value))) {
                    alert("库存不足，无法领取,请确认输入的数量3是否正确！");
                    amount3.focus();
                    return false;
                }
            }
            //判断领料内容3 end
            //判断领料内容4 begin
            var ddlClass4 = document.getElementById("ddlClass4");
            if (ddlClass4.value != "0") {


                var ddlType4 = document.getElementById("ddlType4");
                if (ddlType4.value == "0") {
                    alert("请选择型号4！");
                    return false;
                }
                var amount4 = document.getElementById("amount4");
                //判断盘号begin
                  if(<%=PanHaoShow(ddlClass4.SelectedItem.Text,ddlType4.SelectedItem.Text) %>){
                    var ddlPanhao4 = document.getElementById("ddlPanhao4");
                    var phkc4 = document.getElementById("phkc4");
                    if (ddlPanhao4.value == "0") {
                        alert("请选择盘号4！");
                        return false;
                    }
                    if (phkc4.value == "0" || (parseInt(amount4.value, 10) > parseInt(phkc4.value))) {
                        alert("当前盘号库存不足，无法领取，请确认输入的数量4是否正确！");
                        amount4.focus();
                        return false;
                    }
                }
                //end
                if (amount4.value.length <= 0) {
                    alert("请录入领料数量4！");
                    amount4.focus();
                    return false;
                }
                if (amount4.value.search("^-?\\d+$") != 0) {
                    alert("录入的领料数量4不正确！");
                    amount4.focus();
                    return false;
                }
                var kcamount4 = document.getElementById("kcamount4");
                if (kcamount4.value == "0" || (parseInt(amount4.value, 10) > parseInt(kcamount4.value))) {
                    alert("库存不足，无法领取,请确认输入的数量4是否正确！");
                    amount4.focus();
                    return false;
                }
            }
            //判断领料内容4 end
            //判断领料内容5 begin
            var ddlClass5 = document.getElementById("ddlClass5");
            if (ddlClass5.value != "0") {


                var ddlType5 = document.getElementById("ddlType5");
                if (ddlType5.value == "0") {
                    alert("请选择型号5！");
                    return false;
                }
                var amount5 = document.getElementById("amount5");
                //判断盘号begin
                  if(<%=PanHaoShow(ddlClass5.SelectedItem.Text,ddlType5.SelectedItem.Text) %>){
                    var ddlPanhao5 = document.getElementById("ddlPanhao5");
                    var phkc5 = document.getElementById("phkc5");
                    if (ddlPanhao5.value == "0") {
                        alert("请选择盘号5！");
                        return false;
                    }
                    if (phkc5.value == "0" || (parseInt(amount5.value, 10) > parseInt(phkc5.value))) {
                        alert("当前盘号库存不足，无法领取，请确认输入的数量5是否正确！");
                        amount5.focus();
                        return false;
                    }
                }
                //end
                if (amount5.value.length <= 0) {
                    alert("请录入领料数量5！");
                    amount5.focus();
                    return false;
                }
                if (amount5.value.search("^-?\\d+$") != 0) {
                    alert("录入的领料数量5不正确！");
                    amount5.focus();
                    return false;
                }
                var kcamount5 = document.getElementById("kcamount5");
                if (kcamount5.value == "0" || (parseInt(amount5.value, 10) > parseInt(kcamount5.value))) {
                    alert("库存不足，无法领取,请确认输入的数量5是否正确！");
                    amount5.focus();
                    return false;
                }
            }
            //判断领料内容5 end
            //判断领料内容6 begin
            var ddlClass6 = document.getElementById("ddlClass6");
            if (ddlClass6.value != "0") {


                var ddlType6 = document.getElementById("ddlType6");
                if (ddlType6.value == "0") {
                    alert("请选择型号6！");
                    return false;
                }
                var amount6 = document.getElementById("amount6");
                //判断盘号begin
                  if(<%=PanHaoShow(ddlClass6.SelectedItem.Text,ddlType6.SelectedItem.Text) %>){
                    var ddlPanhao6 = document.getElementById("ddlPanhao6");
                    var phkc6 = document.getElementById("phkc6");
                    if (ddlPanhao6.value == "0") {
                        alert("请选择盘号6！");
                        return false;
                    }
                    if (phkc6.value == "0" || (parseInt(amount6.value, 10) > parseInt(phkc6.value))) {
                        alert("当前盘号库存不足，无法领取，请确认输入的数量6是否正确！");
                        amount6.focus();
                        return false;
                    }
                }
                //end
                if (amount6.value.length <= 0) {
                    alert("请录入领料数量6！");
                    amount6.focus();
                    return false;
                }
                if (amount6.value.search("^-?\\d+$") != 0) {
                    alert("录入的领料数量6不正确！");
                    amount6.focus();
                    return false;
                }
                var kcamount6 = document.getElementById("kcamount6");
                if (kcamount6.value == "0" || (parseInt(amount6.value, 10) > parseInt(kcamount6.value))) {
                    alert("库存不足，无法领取,请确认输入的数量6是否正确！");
                    amount6.focus();
                    return false;
                }
            }
            //判断领料内容6 end
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
            <b>当前位置：</b>南水北调事项处理 >
            <%=Session["pre"] != null&&Session["pre"].ToString().Trim()==""?"<a href=\"nsbdxxgl.aspx\">市区南水北调信息管理</a>":"<a href=\"nsbdxxgl_town.aspx\">县公司南水北调信息管理</a>" %>>
            南水北调领料信息录入
        </p>
        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="width: 750px;">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                    南水北调领料信息录入
                </td>
            </tr>
            <tr>
                <td colspan="4">
                    南水北调信息
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    编号：
                </td>
                <td class="tdinput" style="background-color: #eeeeee;" id="id" runat="server">
                </td>
                <td class="tdtitle">
                    发生时间：
                </td>
                <td class="tdinput" style="background-color: #eeeeee;" id="fssj" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    发生单位：
                </td>
                <td class="tdinput" style="background-color: #eeeeee;" id="fsdw" runat="server">
                </td>
                <td class="tdtitle">
                    联系人：
                </td>
                <td class="tdinput" style="background-color: #eeeeee;" id="lxr" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    施工单位：
                </td>
                <td class="tdinput" style="background-color: #eeeeee;" id="sgdw" runat="server">
                </td>
                <td class="tdtitle">
                    负责人：
                </td>
                <td class="tdinput" style="background-color: #eeeeee;" id="sgdwfzr" runat="server">
                </td>
            </tr>
            <tr>
                <td colspan="4">
                    领料信息
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    出库时间：
                </td>
                <td class="tdinput">
                    <asp:TextBox ID="cksj" runat="server" ReadOnly="true"></asp:TextBox>
                    <span style="color: #F00;">*</span>
                </td>
                <td class="tdtitle">
                    领料单位：
                </td>
                <td class="tdinput">
                    <asp:TextBox ID="lldw" runat="server"></asp:TextBox>
                    <span style="color: #F00;">*</span>
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    领料人：
                </td>
                <td class="tdinput">
                    <asp:TextBox ID="llr" runat="server"></asp:TextBox>
                    <span style="color: #F00;">*</span>
                </td>
                <td class="tdtitle">
                    联系电话：
                </td>
                <td class="tdinput">
                    <asp:TextBox ID="lxdh" runat="server"></asp:TextBox>
                    <span style="color: #F00;">*</span>
                </td>
            </tr>
            <tr>
                <td colspan="4">
                    <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="border-collapse: collapse;">
                        <tr>
                            <td rowspan="3" style="background-color: #ddd;">
                                领料内容1
                            </td>
                            <td class="tdtitle">
                                类别1：
                            </td>
                            <td class="tdinput">
                                <asp:DropDownList ID="ddlClass1" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlClass1_SelectedIndexChanged">
                                </asp:DropDownList>
                                <span style="color: #F00;">*</span>
                            </td>
                            <td class="tdtitle">
                                型号1：
                            </td>
                            <td class="tdinput">
                                <asp:DropDownList ID="ddlType1" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlType1_SelectedIndexChanged">
                                    <asp:ListItem Value="0">请选择型号</asp:ListItem>
                                </asp:DropDownList>
                                <span style="color: #F00;">*</span>
                            </td>
                        </tr>
                        <tr id="trPanhao1" runat="server" style="display: none;">
                            <td class="tdtitle">
                                盘号1：
                            </td>
                            <td class="tdinput">
                                <asp:DropDownList ID="ddlPanhao1" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlPanhao1_SelectedIndexChanged">
                                    <asp:ListItem Value="0">请选择盘号</asp:ListItem>
                                </asp:DropDownList>
                                （<span style="color: #F00;">针对电缆、光缆</span>）
                            </td>
                            <td class="tdtitle">
                                <span style="color: Red;">当前盘号库存：</span>
                            </td>
                            <td align="left">
                                <asp:TextBox ID="phkc1" runat="server" ReadOnly="true" Style="color: Red;"></asp:TextBox>(单位：<span
                                    runat="server" id="units1_3"></span>)
                            </td>
                        </tr>
                        <tr>
                            <td class="tdtitle">
                                数量1：
                            </td>
                            <td align="left">
                                <asp:TextBox ID="amount1" runat="server"></asp:TextBox>(单位：<span runat="server" id="units1_1"></span>)<span
                                    style="color: #F00;">*</span>
                            </td>
                            <td class="tdtitle">
                                <span style="color: Red;">型号总库存1：</span>
                            </td>
                            <td align="left">
                                <asp:TextBox ID="kcamount1" runat="server" ReadOnly="true" Style="color: Red;"></asp:TextBox>(单位：<span
                                    runat="server" id="units1_2"></span>)
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="4">
                    <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="border-collapse: collapse;">
                        <tr>
                            <td rowspan="3" style="background-color: #ddd;">
                                领料内容2
                            </td>
                            <td class="tdtitle">
                                类别2：
                            </td>
                            <td class="tdinput">
                                <asp:DropDownList ID="ddlClass2" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlClass2_SelectedIndexChanged">
                                </asp:DropDownList>
                                <span style="color: #F00;">*</span>
                            </td>
                            <td class="tdtitle">
                                型号2：
                            </td>
                            <td class="tdinput">
                                <asp:DropDownList ID="ddlType2" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlType2_SelectedIndexChanged">
                                    <asp:ListItem Value="0">请选择型号</asp:ListItem>
                                </asp:DropDownList>
                                <span style="color: #F00;">*</span>
                            </td>
                        </tr>
                        <tr id="trPanhao2" runat="server" style="display: none;">
                            <td class="tdtitle">
                                盘号2：
                            </td>
                            <td class="tdinput">
                                <asp:DropDownList ID="ddlPanhao2" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlPanhao2_SelectedIndexChanged">
                                    <asp:ListItem Value="0">请选择盘号</asp:ListItem>
                                </asp:DropDownList>
                                （<span style="color: #F00;">针对电缆、光缆</span>）
                            </td>
                            <td class="tdtitle">
                                <span style="color: Red;">当前盘号库存：</span>
                            </td>
                            <td align="left">
                                <asp:TextBox ID="phkc2" runat="server" ReadOnly="true" Style="color: Red;"></asp:TextBox>(单位：<span
                                    runat="server" id="units2_3"></span>)
                            </td>
                        </tr>
                        <tr>
                            <td class="tdtitle">
                                数量2：
                            </td>
                            <td align="left">
                                <asp:TextBox ID="amount2" runat="server"></asp:TextBox>(单位：<span runat="server" id="units2_1"></span>)<span
                                    style="color: #F00;">*</span>
                            </td>
                            <td class="tdtitle">
                                <span style="color: Red;">型号总库存2：</span>
                            </td>
                            <td align="left">
                                <asp:TextBox ID="kcamount2" runat="server" ReadOnly="true" Style="color: Red;"></asp:TextBox>(单位：<span
                                    runat="server" id="units2_2"></span>)
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="4">
                    <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="border-collapse: collapse;">
                        <tr>
                            <td rowspan="3" style="background-color: #ddd;">
                                领料内容3
                            </td>
                            <td class="tdtitle">
                                类别3：
                            </td>
                            <td class="tdinput">
                                <asp:DropDownList ID="ddlClass3" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlClass3_SelectedIndexChanged">
                                </asp:DropDownList>
                                <span style="color: #F00;">*</span>
                            </td>
                            <td class="tdtitle">
                                型号3：
                            </td>
                            <td class="tdinput">
                                <asp:DropDownList ID="ddlType3" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlType3_SelectedIndexChanged">
                                    <asp:ListItem Value="0">请选择型号</asp:ListItem>
                                </asp:DropDownList>
                                <span style="color: #F00;">*</span>
                            </td>
                        </tr>
                        <tr id="trPanhao3" runat="server" style="display: none;">
                            <td class="tdtitle">
                                盘号3：
                            </td>
                            <td class="tdinput">
                                <asp:DropDownList ID="ddlPanhao3" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlPanhao3_SelectedIndexChanged">
                                    <asp:ListItem Value="0">请选择盘号</asp:ListItem>
                                </asp:DropDownList>
                                （<span style="color: #F00;">针对电缆、光缆</span>）
                            </td>
                            <td class="tdtitle">
                                <span style="color: Red;">当前盘号库存3：</span>
                            </td>
                            <td align="left">
                                <asp:TextBox ID="phkc3" runat="server" ReadOnly="true" Style="color: Red;"></asp:TextBox>(单位：<span
                                    runat="server" id="units3_3"></span>)
                            </td>
                        </tr>
                        <tr>
                            <td class="tdtitle">
                                数量3：
                            </td>
                            <td align="left">
                                <asp:TextBox ID="amount3" runat="server"></asp:TextBox>(单位：<span runat="server" id="units3_1"></span>)<span
                                    style="color: #F00;">*</span>
                            </td>
                            <td class="tdtitle">
                                <span style="color: Red;">型号总库存3：</span>
                            </td>
                            <td align="left">
                                <asp:TextBox ID="kcamount3" runat="server" ReadOnly="true" Style="color: Red;"></asp:TextBox>(单位：<span
                                    runat="server" id="units3_2"></span>)
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="4">
                    <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="border-collapse: collapse;">
                        <tr>
                            <td rowspan="3" style="background-color: #ddd;">
                                领料内容4
                            </td>
                            <td class="tdtitle">
                                类别4：
                            </td>
                            <td class="tdinput">
                                <asp:DropDownList ID="ddlClass4" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlClass4_SelectedIndexChanged">
                                </asp:DropDownList>
                                <span style="color: #F00;">*</span>
                            </td>
                            <td class="tdtitle">
                                型号4：
                            </td>
                            <td class="tdinput">
                                <asp:DropDownList ID="ddlType4" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlType4_SelectedIndexChanged">
                                    <asp:ListItem Value="0">请选择型号</asp:ListItem>
                                </asp:DropDownList>
                                <span style="color: #F00;">*</span>
                            </td>
                        </tr>
                        <tr id="trPanhao4" runat="server" style="display: none;">
                            <td class="tdtitle">
                                盘号4：
                            </td>
                            <td class="tdinput">
                                <asp:DropDownList ID="ddlPanhao4" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlPanhao4_SelectedIndexChanged">
                                    <asp:ListItem Value="0">请选择盘号</asp:ListItem>
                                </asp:DropDownList>
                                （<span style="color: #F00;">针对电缆、光缆</span>）
                            </td>
                            <td class="tdtitle">
                                <span style="color: Red;">当前盘号库存4：</span>
                            </td>
                            <td align="left">
                                <asp:TextBox ID="phkc4" runat="server" ReadOnly="true" Style="color: Red;"></asp:TextBox>(单位：<span
                                    runat="server" id="units4_3"></span>)
                            </td>
                        </tr>
                        <tr>
                            <td class="tdtitle">
                                数量4：
                            </td>
                            <td align="left">
                                <asp:TextBox ID="amount4" runat="server"></asp:TextBox>(单位：<span runat="server" id="units4_1"></span>)<span
                                    style="color: #F00;">*</span>
                            </td>
                            <td class="tdtitle">
                                <span style="color: Red;">型号总库存4：</span>
                            </td>
                            <td align="left">
                                <asp:TextBox ID="kcamount4" runat="server" ReadOnly="true" Style="color: Red;"></asp:TextBox>(单位：<span
                                    runat="server" id="units4_2"></span>)
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="4">
                    <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="border-collapse: collapse;">
                        <tr>
                            <td rowspan="3" style="background-color: #ddd;">
                                领料内容5
                            </td>
                            <td class="tdtitle">
                                类别5：
                            </td>
                            <td class="tdinput">
                                <asp:DropDownList ID="ddlClass5" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlClass5_SelectedIndexChanged">
                                </asp:DropDownList>
                                <span style="color: #F00;">*</span>
                            </td>
                            <td class="tdtitle">
                                型号5：
                            </td>
                            <td class="tdinput">
                                <asp:DropDownList ID="ddlType5" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlType5_SelectedIndexChanged">
                                    <asp:ListItem Value="0">请选择型号</asp:ListItem>
                                </asp:DropDownList>
                                <span style="color: #F00;">*</span>
                            </td>
                        </tr>
                        <tr id="trPanhao5" runat="server" style="display: none;">
                            <td class="tdtitle">
                                盘号5：
                            </td>
                            <td class="tdinput">
                                <asp:DropDownList ID="ddlPanhao5" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlPanhao5_SelectedIndexChanged">
                                    <asp:ListItem Value="0">请选择盘号</asp:ListItem>
                                </asp:DropDownList>
                                （<span style="color: #F00;">针对电缆、光缆</span>）
                            </td>
                            <td class="tdtitle">
                                <span style="color: Red;">当前盘号库存5：</span>
                            </td>
                            <td align="left">
                                <asp:TextBox ID="phkc5" runat="server" ReadOnly="true" Style="color: Red;"></asp:TextBox>(单位：<span
                                    runat="server" id="units5_3"></span>)
                            </td>
                        </tr>
                        <tr>
                            <td class="tdtitle">
                                数量5：
                            </td>
                            <td align="left">
                                <asp:TextBox ID="amount5" runat="server"></asp:TextBox>(单位：<span runat="server" id="units5_1"></span>)<span
                                    style="color: #F00;">*</span>
                            </td>
                            <td class="tdtitle">
                                <span style="color: Red;">型号总库存5：</span>
                            </td>
                            <td align="left">
                                <asp:TextBox ID="kcamount5" runat="server" ReadOnly="true" Style="color: Red;"></asp:TextBox>(单位：<span
                                    runat="server" id="units5_2"></span>)
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="4">
                    <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="border-collapse: collapse;">
                        <tr>
                            <td rowspan="3" style="background-color: #ddd;">
                                领料内容6
                            </td>
                            <td class="tdtitle">
                                类别6：
                            </td>
                            <td class="tdinput">
                                <asp:DropDownList ID="ddlClass6" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlClass6_SelectedIndexChanged">
                                </asp:DropDownList>
                                <span style="color: #F00;">*</span>
                            </td>
                            <td class="tdtitle">
                                型号6：
                            </td>
                            <td class="tdinput">
                                <asp:DropDownList ID="ddlType6" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlType6_SelectedIndexChanged">
                                    <asp:ListItem Value="0">请选择型号</asp:ListItem>
                                </asp:DropDownList>
                                <span style="color: #F00;">*</span>
                            </td>
                        </tr>
                        <tr id="trPanhao6" runat="server" style="display: none;">
                            <td class="tdtitle">
                                盘号6：
                            </td>
                            <td class="tdinput">
                                <asp:DropDownList ID="ddlPanhao6" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlPanhao6_SelectedIndexChanged">
                                    <asp:ListItem Value="0">请选择盘号</asp:ListItem>
                                </asp:DropDownList>
                                （<span style="color: #F00;">针对电缆、光缆</span>）
                            </td>
                            <td class="tdtitle">
                                <span style="color: Red;">当前盘号库存6：</span>
                            </td>
                            <td align="left">
                                <asp:TextBox ID="phkc6" runat="server" ReadOnly="true" Style="color: Red;"></asp:TextBox>(单位：<span
                                    runat="server" id="units6_3"></span>)
                            </td>
                        </tr>
                        <tr>
                            <td class="tdtitle">
                                数量6：
                            </td>
                            <td align="left">
                                <asp:TextBox ID="amount6" runat="server"></asp:TextBox>(单位：<span runat="server" id="units6_1"></span>)<span
                                    style="color: #F00;">*</span>
                            </td>
                            <td class="tdtitle">
                                <span style="color: Red;">型号总库存6：</span>
                            </td>
                            <td align="left">
                                <asp:TextBox ID="kcamount6" runat="server" ReadOnly="true" Style="color: Red;"></asp:TextBox>(单位：<span
                                    runat="server" id="units6_2"></span>)
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="4" align="center" class="btnp">
                    <asp:Button ID="Button1" runat="server" Text="录入南水北调领料信息" OnClientClick="return chkInput();"
                        OnClick="Button1_Click" />
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
