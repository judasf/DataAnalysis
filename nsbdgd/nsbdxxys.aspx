<%@ Page Language="C#" AutoEventWireup="true" CodeFile="nsbdxxys.aspx.cs" Inherits="nsbdxxys" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>南水北调事项管理</title>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />

   <script type="text/javascript" src="../Script/My97DatePicker/WdatePicker.js"></script>

    <script type="text/javascript">
        function chkInput() {
            var ysyj = document.getElementById("ysyj");
            if (ysyj.value.length <= 0) {
                alert("请录入验收意见！");
                ysyj.focus();
                return false;
            }
            var ysr = document.getElementById("ysr");
            if (ysr.value.length <= 0) {
                alert("请录入验收人！");
                ysr.focus();
                return false;
            }
            var yssj = document.getElementById("yssj");
            if (yssj.value.length <= 0) {
                alert("请录入验收时间！");
                yssj.focus();
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
            <b>当前位置：</b>南水北调事项处理 > <%=Session["pre"] != null&&Session["pre"].ToString().Trim()==""?"<a href=\"nsbdxxgl.aspx\">市区南水北调信息管理</a>":"<a href=\"nsbdxxgl_town.aspx\">县公司南水北调信息管理</a>" %>> 南水北调工单验收
        </p>
        <br />
       <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1"  class="tablewidth">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                    南水北调工单验收
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
                <td class="tdinput" colspan="3" ID="sy" runat="server">
                   
                </td>
            </tr>
            
            <tr>
                <td class="tdtitle" >
                  施工单位：
                </td>
                <td class="tdinput" colspan="3"  ID="sgdw" runat="server">
                  
                </td>
            </tr>
             <tr>
                <td class="tdtitle" >
                  负责人：
                </td>
                <td class="tdinput" ID="sgdwfzr" runat="server" >
                    
                </td>
                <td class="tdtitle" >
                  联系电话：
                </td>
                <td class="tdinput"  ID="sgdwlxdh" runat="server">
                    
                </td>
            </tr>
            <tr>  <td class="tdtitle" >
                   验收意见：
                </td>
                <td class="tdinput"  colspan="3" height="60">
                      <asp:TextBox ID="ysyj" runat="server" Rows="4" MaxLength="2000" TextMode="MultiLine"  Width="441px"></asp:TextBox>
                <span style="color: #F00;">*</span>
                </td></tr>
                <tr>
                <td class="tdtitle" height="30">
                    验收人：
                </td>
                <td class="tdinput" >
                    <asp:TextBox ID="ysr" runat="server"></asp:TextBox>
                <span style="color: #F00;">*</span>
                </td>
                <td class="tdtitle">
                   验收时间：
                </td>
                <td class="tdinput"  >
                    <asp:TextBox   ID="yssj" runat="server" class="Wdate" onFocus="WdatePicker({isShowClear:false,readOnly:true,dateFmt:'yyyy-MM-dd HH:mm:ss'})" ></asp:TextBox>
                <span style="color: #F00;">*</span>
                </td>
            </tr>
                     <tr>
                <td colspan="4" align="center" class="btnp">
                    <asp:Button ID="Button1" runat="server" Text="提交南水北调验收意见" OnClientClick="return chkInput();"
                        OnClick="Button1_Click" />
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
