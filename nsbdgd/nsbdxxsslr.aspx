<%@ Page Language="C#" AutoEventWireup="true" CodeFile="nsbdxxsslr.aspx.cs" Inherits="nsbdxxsslr" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>南水北调事项管理</title>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />

   <script type="text/javascript" src="../Script/My97DatePicker/WdatePicker.js"></script>

    <script type="text/javascript">
        function chkInput() {
            var sssj = document.getElementById("sssj");
            if (sssj.value.length <= 0) {
                alert("请选择送审时间！");
                sssj.focus();
                return false;
            }

            var ssje = document.getElementById("ssje");
            if (ssje.value.length <= 0) {
                alert("请录入送审金额！");
                ssje.focus();
                return false;
            } else if (/[^0-9\.]/.test(ssje.value)) {
            alert("录入的送审金额有误，请重新输入！");
                ssje.focus();
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
            <b>当前位置：</b>南水北调事项处理 >  <%=Session["pre"] != null&&Session["pre"].ToString().Trim()==""?"<a href=\"nsbdxxgl.aspx\">市区南水北调信息管理</a>":"<a href=\"nsbdxxgl_town.aspx\">县公司南水北调信息管理</a>" %>> 南水北调工单送审
        </p>
        <br />
        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" class="tablewidth">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                    南水北调工单送审
                </td>
            </tr>
    <tr>
                <td class="tdtitle">
                    编号：
                </td>
                <td class="tdinput" id="id" runat="server">
                </td>
                <td class="tdtitle">
                    申请时间：
                </td>
                <td class="tdinput" id="fssj" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle" width="90">
                    申请单位：
                </td>
                <td class="tdinput" width="180" id="fsdw" runat="server">
                </td>
                <td class="tdtitle" width="90">
                    联系人：
                </td>
                <td class="tdinput" width="180" id="lxr" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle" width="90">
                    联系电话：
                </td>
                <td class="tdinput" width="180" id="lxdh" runat="server">
                </td>
                <td class="tdtitle" width="90">
                    预算金额：
                </td>
                <td class="tdinput" width="180" id="ysje" runat="server">
                </td>
            </tr>
             <tr>
                <td class="tdtitle" width="90">
                    迁建线路地点：
                </td>
                <td class="tdinput" width="180" id="dd" runat="server">
                </td>
                <td class="tdtitle" width="90">
                    施工地段：
                </td>
                <td class="tdinput" width="180" id="sgdd" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="40">
                    迁建线路内容及方案：
                </td>
                <td class="tdinput" colspan="3" id="sy" runat="server">
                </td>
            </tr>
        
            <tr>
                <td class="tdtitle">
                    施工单位：
                </td>
                <td class="tdinput" colspan="3" id="sgdw" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    负责人：
                </td>
                <td class="tdinput" id="sgdwfzr" runat="server">
                </td>
                <td class="tdtitle">
                    联系电话：
                </td>
                <td class="tdinput" id="sgdwlxdh" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    验收意见：
                </td>
                <td class="tdinput" colspan="3" height="60" id="ysyj" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="30">
                    验收人：
                </td>
                <td class="tdinput" id="ysr" runat="server">
                </td>
                <td class="tdtitle">
                    验收时间：
                </td>
                <td class="tdinput" id="yssj" runat="server">
                </td>
            </tr>
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                    审计报账
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="30">
                    送审时间：
                </td>
                <td class="tdinput" >
                <asp:TextBox   ID="sssj" runat="server" class="Wdate" onFocus="WdatePicker({isShowClear:false,readOnly:true,dateFmt:'yyyy-MM-dd HH:mm:ss'})" ></asp:TextBox>
                <span style="color: #F00;">*</span>
                </td>
                <td class="tdtitle">
                    送审金额：
                </td>
                <td class="tdinput" >
                    <asp:TextBox ID="ssje" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td colspan="4" align="center" class="btnp">
                    <asp:Button ID="Button1" runat="server" Text="提交南水北调送审信息" OnClientClick="return chkInput();"
                        OnClick="Button1_Click" />
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
