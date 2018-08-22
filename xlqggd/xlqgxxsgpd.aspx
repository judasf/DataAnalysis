<%@ Page Language="C#" AutoEventWireup="true" CodeFile="xlqgxxsgpd.aspx.cs" Inherits="xlqgxxsgpd" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>迁改事项管理</title>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />

   <script type="text/javascript" src="../Script/My97DatePicker/WdatePicker.js"></script>

    <script type="text/javascript">
        function chkInput() {
            var sgdw = document.getElementById("sgdw");
            if (sgdw.value.length <= 0) {
                alert("请录入施工单位！");
                sgdw.focus();
                return false;
            }
            var sgdwfzr = document.getElementById("sgdwfzr");
            if (sgdwfzr.value.length <= 0) {
                alert("请录入负责人！");
                sgdwfzr.focus();
                return false;
            }
            var sgdwlxdh = document.getElementById("sgdwlxdh");
            if (sgdwlxdh.value.length <= 0) {
                alert("请录入联系电话！");
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
         <p class="sitepath">
            <b>当前位置：</b>迁改事项处理 > <span id="pathname" runat="server"></span>> 迁改派单
        </p>
        <br />
       
        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1"   class="tablewidth">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                    迁改派单
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    编号：
                </td>
                <td class="tdinput" id="id" runat="server">
                </td>
                <td class="tdtitle" >
                    发生时间：
                </td>
                <td class="tdinput" id="fssj" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle"  >
                    发生单位：
                </td>
                <td class="tdinput" colspan="3" id="fsdw" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle"   >
                  联系人：
                </td>
                <td class="tdinput" ID="lxr" runat="server">
                    
                
                </td>
                <td class="tdtitle" >
                    联系电话：
                </td>
                <td class="tdinput" id="lxdh" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="40">
                    事由：
                </td>
                <td class="tdinput" colspan="3" ID="sy" runat="server">
                   
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                  预算金额：
                </td>
                <td class="tdinput" colspan="3" ID="ysje" runat="server">
                </td>
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
                  负责人：
                </td>
                <td class="tdinput" >
                    <asp:TextBox ID="sgdwfzr" runat="server"></asp:TextBox><span style="color: #F00;">*</span>
                </td>
                <td class="tdtitle" >
                  联系电话：
                </td>
                <td class="tdinput" >
                    <asp:TextBox ID="sgdwlxdh" runat="server"></asp:TextBox><span style="color: #F00;">*</span>
                </td>
            </tr>
                     <tr>
                <td colspan="4" align="center" class="btnp">
                    <asp:Button ID="Button1" runat="server" Text="提交迁改派单信息" OnClientClick="return chkInput();"
                        OnClick="Button1_Click" />
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
