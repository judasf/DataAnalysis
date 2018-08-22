<%@ Page Language="C#" AutoEventWireup="true" CodeFile="yjylkckclr.aspx.cs" Inherits="yjylkckclr" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>库存管理</title>
    <link type="text/css" href="../css/style.css"   rel="Stylesheet"/>
    <script type="text/javascript">
        function chkInput() {
            var ddlClass = document.getElementById("ddlClass");
            if (ddlClass.value == "0") {
                alert("请选择类别！");
                return false;
            }
            var ddlType1 = document.getElementById("ddlType1");
            if (ddlType1.value == "0") {
                alert("请选择型号！");
                return false;
            }
            var txtAmount1 = document.getElementById("txtAmount1");
            if (txtAmount1.value.length <= 0) {
                alert("请录入数量！");
                txtAmount1.focus();
                return false;
            }
            if (txtAmount1.value.search("^-?\\d+$") != 0) {
                alert("录入的数量不正确！");
                txtAmount1.focus();
                return false;
            }
            //判断盘号（电缆 、光缆）
            var txtPanhao1 = document.getElementById("txtPanhao1");
            if (ddlClass.value == "1" || ddlClass.value == "2") {
                if (txtPanhao1.value.length <= 0) {
                    alert("请录入盘号！");
                    txtPanhao1.focus();
                    return false;
                }
            }
            //验证第二行至第五行的数据
            //begin
            var ddlType2 = document.getElementById("ddlType2");
            var txtAmount2 = document.getElementById("txtAmount2");
            if (ddlType2.value != "0") {
                if (txtAmount2.value.length <= 0) {
                    alert("请录入第2行的数量！");
                    txtAmount2.focus();
                    return false;
                }
                if (txtAmount2.value.search("^-?\\d+$") != 0) {
                    alert("第2行录入的数量不正确！");
                    txtAmount2.focus();
                    return false;
                }
                var txtPanhao2 = document.getElementById("txtPanhao2");
                if (ddlClass.value == "1" || ddlClass.value == "2") {
                    if (txtPanhao2.value.length <= 0) {
                        alert("请录入盘号！");
                        txtPanhao2.focus();
                        return false;
                    }
                }
            }
            var ddlType3 = document.getElementById("ddlType3");
            var txtAmount3 = document.getElementById("txtAmount3");
            if (ddlType3.value != "0") {
                if (txtAmount3.value.length <= 0) {
                    alert("请录入第3行的数量！");
                    txtAmount3.focus();
                    return false;
                }
                if (txtAmount3.value.search("^-?\\d+$") != 0) {
                    alert("第3行录入的数量不正确！");
                    txtAmount3.focus();
                    return false;
                }
                var txtPanhao3 = document.getElementById("txtPanhao3");
                if (ddlClass.value == "1" || ddlClass.value == "2") {
                    if (txtPanhao3.value.length <= 0) {
                        alert("请录入盘号！");
                        txtPanhao3.focus();
                        return false;
                    }
                }
            }
            var ddlType4 = document.getElementById("ddlType4");
            var txtAmount4 = document.getElementById("txtAmount4");
            if (ddlType4.value != "0") {
                if (txtAmount4.value.length <= 0) {
                    alert("请录入第4行的数量！");
                    txtAmount4.focus();
                    return false;
                }
                if (txtAmount4.value.search("^-?\\d+$") != 0) {
                    alert("第4行录入的数量不正确！");
                    txtAmount4.focus();
                    return false;
                }
                var txtPanhao4 = document.getElementById("txtPanhao4");
                if (ddlClass.value == "1" || ddlClass.value == "2") {
                    if (txtPanhao4.value.length <= 0) {
                        alert("请录入盘号！");
                        txtPanhao4.focus();
                        return false;
                    }
                }
            }
            var ddlType5 = document.getElementById("ddlType5");
            var txtAmount5 = document.getElementById("txtAmount5");
            if (ddlType5.value != "0") {
                if (txtAmount5.value.length <= 0) {
                    alert("请录入第5行的数量！");
                    txtAmount5.focus();
                    return false;
                }
                if (txtAmount5.value.search("^-?\\d+$") != 0) {
                    alert("第5行录入的数量不正确！");
                    txtAmount5.focus();
                    return false;
                }
                var txtPanhao5 = document.getElementById("txtPanhao5");
                if (ddlClass.value == "1" || ddlClass.value == "2") {
                    if (txtPanhao5.value.length <= 0) {
                        alert("请录入盘号！");
                        txtPanhao5.focus();
                        return false;
                    }
                }
            }
            //end
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
        <p class="sitepath"><b>当前位置：</b>库存管理 > <a href="yjylkckctjb.aspx">库存统计表</a> > <a href="yjylkckclr.aspx">库存录入</a> </p>
          <br />
        <table border="1" bordercolor="#CCCCCC" cellpadding="0" cellspacing="0">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="5" align="center">
                    库存录入
                </td>
            </tr>
            <tr>
                <td>
                    选择类别：
                </td>
                <td colspan="4" align="left" >
                    <asp:DropDownList ID="ddlClass" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlClass_SelectedIndexChanged">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td  width="100">
                    型号
                </td>
                 <td id="phtitle" width="80">
                    盘号
                </td>
                <td  width="80">
                    数量
                </td>
                <td  width="40">
                    单位
                </td>
                <td >
                 备注
                </td>
            </tr>
            <tr>
                <td >
                    <asp:DropDownList ID="ddlType1" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlType1_SelectedIndexChanged">
                        <asp:ListItem Value="0">请选择型号</asp:ListItem>
                    </asp:DropDownList>
                </td>
                  <td >
                    <asp:TextBox ID="txtPanhao1" runat="server" ></asp:TextBox>
                </td>
                <td >
                    <asp:TextBox ID="txtAmount1" runat="server"></asp:TextBox>
                </td>
                <td >
                    <span runat="server" id="units1"></span>
                </td>
                <td>
                    <asp:TextBox ID="memo1" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:DropDownList ID="ddlType2" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlType2_SelectedIndexChanged">
                        <asp:ListItem Value="0">请选择型号</asp:ListItem>
                    </asp:DropDownList>
                </td>
                 <td >
                    <asp:TextBox ID="txtPanhao2" runat="server"></asp:TextBox>
                </td>
                <td>
                    <asp:TextBox ID="txtAmount2" runat="server"></asp:TextBox>
                </td>
                <td>
                    <span runat="server" id="units2"></span>
                </td>
                  <td>
                    <asp:TextBox ID="memo2" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td >
                    <asp:DropDownList ID="ddlType3" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlType3_SelectedIndexChanged">
                        <asp:ListItem Value="0">请选择型号</asp:ListItem>
                    </asp:DropDownList>
                </td>
                 <td>
                    <asp:TextBox ID="txtPanhao3" runat="server"></asp:TextBox>
                </td>
                <td>
                    <asp:TextBox ID="txtAmount3" runat="server"></asp:TextBox>
                </td>
                <td>
                    <span runat="server" id="units3"></span>
                </td>
                <td>
                    <asp:TextBox ID="memo3" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td >
                    <asp:DropDownList ID="ddlType4" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlType4_SelectedIndexChanged">
                        <asp:ListItem Value="0">请选择型号</asp:ListItem>
                    </asp:DropDownList>
                </td>
                 <td>
                    <asp:TextBox ID="txtPanhao4" runat="server"></asp:TextBox>
                </td>
                <td>
                    <asp:TextBox ID="txtAmount4" runat="server"></asp:TextBox>
                </td>
                <td>
                    <span runat="server" id="units4"></span>
                </td>
                <td>
                    <asp:TextBox ID="memo4" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td >
                    <asp:DropDownList ID="ddlType5" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlType5_SelectedIndexChanged">
                        <asp:ListItem Value="0">请选择型号</asp:ListItem>
                    </asp:DropDownList>
                </td>
                 <td>
                    <asp:TextBox ID="txtPanhao5" runat="server"></asp:TextBox>
                </td>
                <td>
                    <asp:TextBox ID="txtAmount5" runat="server"></asp:TextBox>
                </td>
                <td>
                    <span runat="server" id="units5"></span>
                </td>
                <td>
                    <asp:TextBox ID="memo5" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td colspan="5" align="center" class="btnp">
                    <asp:Button ID="Button1" runat="server" Text="提交" OnClientClick="return chkInput();"
                        OnClick="Button1_Click" />
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
