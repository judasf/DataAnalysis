<%@ Page Language="C#" AutoEventWireup="true" CodeFile="xlqgxxtllr.aspx.cs" Inherits="xlqgxxtllr" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>迁改事项管理</title>

   <script type="text/javascript" src="../Script/My97DatePicker/WdatePicker.js"></script>

    <link type="text/css" href="../css/style.css" rel="Stylesheet" />

    <script type="text/javascript">
        function chkInput() {

            var tlxx = document.getElementById("tlxx");
            if (tlxx.value.length <= 0) {
                alert("请录入退料信息！");
                tlxx.focus();
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
            <b>当前位置：</b>迁改事项处理 >  <%=Session["pre"] != null&&Session["pre"].ToString().Trim()==""?"<a href=\"xlqgxxgl.aspx\">市区迁改信息管理</a>":"<a href=\"xlqgxxgl_town.aspx\">县公司迁改信息管理</a>" %>> 迁改退料信息录入
        </p>
        <br />
        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1"  class="tablewidth">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                    迁改退料信息录入
                </td>
            </tr>
            <tr>
                <td colspan="4">
                    迁改信息
                </td>
            </tr>
            <tr>
                <td class="tdtitle" width="90">
                    编号：
                </td>
                <td class="tdinput" style="background-color: #eeeeee;" id="id" runat="server" width="200">
                </td>
                <td class="tdtitle" width="90">
                    发生时间：
                </td>
                <td width="200" class="tdinput" style="background-color: #eeeeee;" id="fssj" runat="server">
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
                <td class="tdinput" style="background-color: #eeeeee;" id="fzr" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle" width="90">
                    退料信息：
                </td>
                <td class="tdinput" colspan="3">
                    <asp:TextBox ID="tlxx" runat="server" Rows="4" MaxLength="1000" TextMode="MultiLine"
                        Width="441px"></asp:TextBox>
                    <span style="color: #F00;">*</span>
                </td>
            </tr>
            <tr>
                <td colspan="4" align="center"  class="btnp">
                    <asp:Button ID="Button1" runat="server" Text="提交退料信息" OnClientClick="return chkInput();"
                        OnClick="Button1_Click" />
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
