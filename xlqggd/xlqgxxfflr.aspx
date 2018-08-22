<%@ Page Language="C#" AutoEventWireup="true" CodeFile="xlqgxxfflr.aspx.cs" Inherits="xlqgxxfflr" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>迁改事项管理</title>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />

   <script type="text/javascript" src="../Script/My97DatePicker/WdatePicker.js"></script>

    <script type="text/javascript">
        function chkInput() {
            var ffsj = document.getElementById("ffsj");
            if (ffsj.value.length <= 0) {
                alert("请选择付费时间！");
                ffsj.focus();
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
            <b>当前位置：</b>迁改事项处理 >  <%=Session["pre"] != null&&Session["pre"].ToString().Trim()==""?"<a href=\"xlqgxxgl.aspx\">市区迁改信息管理</a>":"<a href=\"xlqgxxgl_town.aspx\">县公司迁改信息管理</a>" %>> 迁改工单付费
        </p>
        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1"  class="tablewidth">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                    迁改工单付费
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    编号：
                </td>
                <td class="tdinput" id="id" runat="server">
                </td>
                <td class="tdtitle" width="90">
                    发生时间：
                </td>
                <td class="tdinput" width="180" id="fssj" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle" width="90">
                    发生单位：
                </td>
                <td class="tdinput" colspan="3" id="fsdw" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle" width="90">
                    联系人：
                </td>
                <td class="tdinput" width="180" id="lxr" runat="server">
                </td>
                <td class="tdtitle" width="90">
                    联系电话：
                </td>
                <td class="tdinput" width="180" id="lxdh" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="40">
                    事由：
                </td>
                <td class="tdinput" colspan="3" id="sy" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    预算金额：
                </td>
                <td class="tdinput" colspan="3" id="ysje" runat="server">
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
                <td class="tdinput" id="sssj" runat="server">
                </td>
                <td class="tdtitle">
                    送审金额：
                </td>
                <td class="tdinput" id="ssje" runat="server">
                </td>
            </tr>
            <tr>
             <tr>
                <td class="tdtitle" height="30">
                    审计时间：
                </td>
                <td class="tdinput" id="sjsj" runat="server">
                </td>
                <td class="tdtitle">
                    审计金额：
                </td>
                <td class="tdinput" id="sjje" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle" height="30">
                    付费时间：
                </td>
                <td class="tdinput" colspan="3" >
                <asp:TextBox   ID="ffsj" runat="server" class="Wdate" onFocus="WdatePicker({isShowClear:false,readOnly:true,dateFmt:'yyyy-MM-dd HH:mm:ss'})" ></asp:TextBox>
                <span style="color: #F00;">*</span>
                </td>
              
            </tr>
            <tr>
                <td colspan="4" align="center" class="btnp">
                    <asp:Button ID="Button1" runat="server" Text="提交迁改付费信息" OnClientClick="return chkInput();"
                        OnClick="Button1_Click" />
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
