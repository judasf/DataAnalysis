<%@ Page Language="C#" AutoEventWireup="true" CodeFile="xlzgxxlr.aspx.cs" Inherits="xlzgxxlr" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>整改事项管理</title>
    <link type="text/css" href="../css/style.css"   rel="Stylesheet"/>
   <script type="text/javascript" src="../Script/My97DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
        function chkInput() {
            var xllx = document.getElementById("xllx");
            if (xllx.value == "0") {
                alert("请选择线路类型！");
                xllx.focus();
                return false;
            }
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
            var whdw = document.getElementById("whdw");
            if (whdw.value=="0") {
                alert("请选择维护单位！");
                whdw.focus();
                return false;
            }
            var fzr = document.getElementById("fzr");
            if (fzr.value.length <= 0) {
                alert("请录入负责人！");
                fzr.focus();
                return false;
            }
            var zgqy = document.getElementById("zgqy");
            if (zgqy.value.length <= 0) {
                alert("请录入整改区域！");
                zgqy.focus();
                return false;
            }

            var czwt = document.getElementById("czwt");
            if (czwt.value.length <= 0) {
                alert("请录入存在问题！");
                czwt.focus();
                return false;
            }
            var zgyq = document.getElementById("zgyq");
            if (zgyq.value.length <= 0) {
                alert("请录入整改要求！");
                zgyq.focus();
                return false;
            }
            var zgsx = document.getElementById("zgsx");
            if (zgsx.value.length <= 0) {
                alert("请录入整改时限！");
                zgsx.focus();
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
            <b>当前位置：</b>整改事项管理 > <a href="xlzgxxgl.aspx">整改信息管理</a> > <a href="xlzgxxlr.aspx">整改信息录入</a>
        </p>
       <br />
          <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1"  class="tablewidth">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                    整改通知书
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    编号：
                </td>
                <td class="tdinput"  id="id" runat="server">
                  
                </td>
                 <td class="tdtitle"  >
                    派单单位：
                </td>
                <td class="tdinput"  id="pfdw" runat="server">
                   
                </td>
            </tr>
            <tr>
                <td class="tdtitle"  >
                    派单人：
                </td>
                <td class="tdinput"  id="pdr" runat="server">
                   
                </td>
                <td class="tdtitle"  >
                   派单时间：
                </td>
                <td class="tdinput"  id="pdsj" runat="server">
                    
                </td>
            </tr>
               <tr>
                <td class="tdtitle">
                    线路类型：
                </td>
                <td class="tdinput" colspan="3">
                   <asp:DropDownList ID="xllx" runat="server">
                       <asp:ListItem Text="请选择线路类型" Value="0"></asp:ListItem>
                       <asp:ListItem Text="电缆" Value="电缆"></asp:ListItem>
                       <asp:ListItem Text="光缆" Value="光缆"></asp:ListItem>
                    </asp:DropDownList>
                    <span style="color: #F00;">*</span>
                </td>
            </tr>
            <tr>
                <td class="tdtitle"  >
                    联系人：
                </td>
                <td class="tdinput" >
                   <asp:TextBox ID="lxr" runat="server"></asp:TextBox>
                    <span style="color: #F00;">*</span>
                </td>
                <td class="tdtitle"  >
                    联系电话：
                </td>
                <td class="tdinput" >
                    <asp:TextBox ID="lxdh" runat="server"></asp:TextBox>
                    <span style="color: #F00;">*</span>
                </td>
            </tr>
            <tr>
                <td class="tdtitle"  >
                    维护单位：
                </td>
                <td class="tdinput" >
                    <asp:DropDownList ID="whdw" runat="server">
                       
                    </asp:DropDownList>
                    <span style="color: #F00;">*</span>
                </td>
                <td class="tdtitle"  >
                    负责人：
                </td>
                <td class="tdinput" >
                    <asp:TextBox ID="fzr" runat="server" ReadOnly="true" Text="李志勇"></asp:TextBox>
                    <span style="color: #F00;">*</span>
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    整改区域：
                </td>
                <td class="tdinput" colspan="3">
                    <asp:TextBox ID="zgqy" runat="server" Rows="2" MaxLength="1000" TextMode="MultiLine"
                        Width="441px"></asp:TextBox>
                    <span style="color: #F00;">*</span>
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    存在问题：
                </td>
                <td class="tdinput" colspan="3">
                    <asp:TextBox ID="czwt" runat="server" Rows="4" MaxLength="2000" TextMode="MultiLine"  Width="441px"></asp:TextBox>
                <span style="color: #F00;">*</span>
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    整改要求：
                </td>
                <td class="tdinput" colspan="3">
                    <asp:TextBox ID="zgyq" runat="server"  Width="441px"></asp:TextBox><span style="color: #F00;">*</span>
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    整改时限：
                </td>
                <td class="tdinput" colspan="3">
                    <asp:TextBox ID="zgsx" runat="server"  Width="441px"></asp:TextBox>
                    <span style="color: #F00;">*</span>
                </td>
            </tr>
            
            
            
            
            <tr>
                <td colspan="4" align="center"  class="btnp">
                    <asp:Button ID="Button1" runat="server" Text="派发整改通知书" OnClientClick="return chkInput();"
                        OnClick="Button1_Click" />
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
