<%@ Page Language="C#" AutoEventWireup="true" CodeFile="nsbdxxlr.aspx.cs" Inherits="nsbdxxlr" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>南水北调事项管理</title>

    <link type="text/css" href="../css/style.css" rel="Stylesheet" />

   <script type="text/javascript" src="../Script/My97DatePicker/WdatePicker.js"></script>

    <script type="text/javascript">
        function chkInput() {
            var lxr = document.getElementById("lxr");
            if (lxr.value.length <= 0) {
                alert("请录入联系人！");
                lxr.focus();
                return false;
            }
            var lxdh = document.getElementById("lxdh");
            if (lxdh.value.length <= 0) {
                alert("请录入联系电话！");
                lxdh.focus();
                return false;
            }
            var ysje = document.getElementById("ysje");
            if (ysje.value.length <= 0) {
                alert("请录入预算金额！");
                ysje.focus();
                return false;
            } else if (/[^0-9\.]/.test(ysje.value)) {
                alert("录入的预算金额有误，请重新输入！");
                ysje.focus();
                return false;
            }
            var ddl_dd = document.getElementById("ddl_dd");
            if (ddl_dd.value=="0") {
                alert("请选择地点！");
                ddl_dd.focus();
                return false;
            }
            var sgdd = document.getElementById("sgdd");
            if (sgdd.value.length <= 0) {
                alert("请录入施工地段！");
                sgdd.focus();
                return false;
            }
            var sy = document.getElementById("sy");
            if (sy.value.length <= 0) {
                alert("请录入迁建线路内容及方案！");
                sy.focus();
                return false;
            }
           
            var sgdw = document.getElementById("sgdw");
            if (sgdw.value.length <= 0) {
                alert("请录入施工单位！");
                sgdw.focus();
                return false;
            }
            var sgdwfzr = document.getElementById("sgdwfzr");
            if (sgdwfzr.value.length <= 0) {
                alert("请录入施工单位负责人！");
                sgdwfzr.focus();
                return false;
            }
            var sgdwlxdh = document.getElementById("sgdwlxdh");
            if (sgdwlxdh.value.length <= 0) {
                alert("请录入施工单位联系电话！");
                sgdwlxdh.focus();
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
       <p class="sitepath"><b>当前位置：</b>南水北调事项处理 > <a href="nsbdxxlr.aspx">南水北调信息录入</a> </p>
       <br />
        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1"   class="tablewidth">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                    南水北调信息录入
                </td>
            </tr>
            <tr>
                <td class="tdtitle" >
                    编号：
                </td>
                <td class="tdinput" id="id" runat="server">
                </td>
                <td class="tdtitle" height="30">
                    申请时间：
                </td>
                <td class="tdinput"  id="fssj" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="30">
                    申请单位：
                </td>
                <td class="tdinput"  id="fsdw" runat="server">
                </td>
                 <td class="tdtitle" height="30">
                  联系人：
                </td>
                <td class="tdinput" >
                    <asp:TextBox ID="lxr" runat="server"></asp:TextBox>
                    <span style="color: #F00;">*</span>
                </td>
            </tr>
            <tr>
               
                <td class="tdtitle">
                    联系电话：
                </td>
                <td class="tdinput" >
                    <asp:TextBox ID="lxdh" runat="server"></asp:TextBox>
                    <span style="color: #F00;">*</span>
                </td>
                 <td class="tdtitle" height="30">
                  预算金额：
                </td>
                <td class="tdinput" >
                    <asp:TextBox ID="ysje" runat="server"></asp:TextBox>
                    <span style="color: #F00;">*</span>
                </td>
            </tr>
             <tr>
                <td class="tdtitle" height="30">
                 迁建线路地点：
                </td>
                <td class="tdinput" >
                    <asp:DropDownList ID="ddl_dd" runat="server">
                    <asp:ListItem Value="0">请选择地点</asp:ListItem>
                    <asp:ListItem Value="市区">市区</asp:ListItem>
                    <asp:ListItem Value="汤阴">汤阴</asp:ListItem>
                    <asp:ListItem Value="内黄">内黄</asp:ListItem>
                    <asp:ListItem Value="滑县">滑县</asp:ListItem>
                    </asp:DropDownList>
                    <span style="color: #F00;">*</span>
                </td>
                <td class="tdtitle">
                    施工地段：
                </td>
                <td class="tdinput" >
                    <asp:TextBox ID="sgdd" runat="server" Rows="2" MaxLength="300" TextMode="MultiLine" Width="150px"></asp:TextBox>
                    <span style="color: #F00;">*</span>
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="60">
                   迁建线路内容及方案：
                </td>
                <td class="tdinput" colspan="3">
                    <asp:TextBox ID="sy" runat="server" Rows="4" MaxLength="2000" TextMode="MultiLine"
                        Width="441px"></asp:TextBox>
                    <span style="color: #F00;">*</span>
                </td>
            </tr>
            <tr>
               
            </tr>
            <tr>
                <td class="tdtitle" >
                  施工单位：
                </td>
                <td class="tdinput" colspan="3" >
                    <asp:TextBox ID="sgdw" runat="server"></asp:TextBox><span style="color: #F00;">*</span>
                </td>
            </tr>
             <tr>
                <td class="tdtitle" >
                  施工单位负责人：
                </td>
                <td class="tdinput" >
                    <asp:TextBox ID="sgdwfzr" runat="server"></asp:TextBox><span style="color: #F00;">*</span>
                </td>
                <td class="tdtitle" >
                  施工单位联系电话：
                </td>
                <td class="tdinput" >
                    <asp:TextBox ID="sgdwlxdh" runat="server"></asp:TextBox><span style="color: #F00;">*</span>
                </td>
            </tr>
                     <tr>
                <td colspan="4" align="center" class="btnp">
                    <asp:Button ID="Button1" runat="server" Text="提交南水北调信息" OnClientClick="return chkInput();"
                        OnClick="Button1_Click" />
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
