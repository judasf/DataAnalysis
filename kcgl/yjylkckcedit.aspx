<%@ Page Language="C#" AutoEventWireup="true" CodeFile="yjylkckcedit.aspx.cs" Inherits="yjylkckcedit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>库存管理</title>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />
    <script type="text/javascript">
    var True = true;
            var False = false;
        function chkInput() {
            var ddlClass = document.getElementById("txtClassName");

            var amount = document.getElementById("amount");
            //判断盘号begin
            if(<%
            if(Session["uname"] == null)
           Response.Redirect("yjylkckctjb.aspx");
           else
           Response.Write(PanHaoShow(txtClassName.InnerText,txtTypeName.InnerText));
           %>) {
            var txtPanHao = document.getElementById("txtPanHao");
            if (txtPanHao.value.length <= 0) {
            alert("请录入盘号！");
            txtPanHao.focus();
            return false;
            }
            }
            //end

            if (amount.value.length <= 0) {
                alert("请录入库存数量！");
                amount.focus();
                return false;
            }
            if (amount.value.search("^-?\\d+$") != 0) {
                alert("录入的库存数量不正确！");
                amount.focus();
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
            <b>当前位置：</b>库存管理 > <a href="yjylkckctjb.aspx">库存统计表</a> > 库存编辑
        </p>
        <br />
        <table border="1" bordercolor="#CCCCCC" cellpadding="0" cellspacing="0" class="tablewidth">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="2" align="center">
                    库存编辑
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    编号：
                </td>
                <td class="tdinput" id="id" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    类别：
                </td>
                <td class="tdinput" id="txtClassName" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    型号：
                </td>
                <td class="tdinput" id="txtTypeName" runat="server">
                </td>
            </tr>
            <tr id="trPanhao" runat="server" style="display: none;">
                <td class="tdtitle">
                    盘号：
                </td>
                <td class="tdinput">
                    <asp:TextBox ID="txtPanHao" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    库存数量：
                </td>
                <td class="tdinput">
                    <asp:TextBox ID="amount" runat="server"></asp:TextBox>(单位：<span runat="server" id="units1"></span>)
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center" class="btnp">
                    <asp:Button ID="Button1" runat="server" Text="修改" OnClientClick="return chkInput();"
                        OnClick="Button1_Click" />
                    &nbsp; &nbsp; &nbsp; &nbsp;
                    <asp:Button ID="Button2" runat="server" Text="返回" OnClick="Button2_Click" />
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
