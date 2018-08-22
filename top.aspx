<%@ Page Language="C#" AutoEventWireup="true" CodeFile="top.aspx.cs" Inherits="top" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>页头</title>
    <script type="text/javascript" src="Script/showdate.js"></script>

    <style type="text/css">
        body { margin-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; }
        .STYLE1 { font-size: 12px; color: #FFFFFF; }
        .STYLE2 { font-size: 9px; }
        .STYLE3 { color: #033d61; font-size: 12px;padding-left:20px; }
        img{border:none;}
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td height="70" background="images/main_05.gif"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="24"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="270" height="24" background="images/main_03.gif">&nbsp;</td>
            <td width="505" background="images/main_04.gif">&nbsp;</td>
            <td>&nbsp;</td>
            <td width="21"><img src="images/main_07.gif" width="21" height="24"></td>
          </tr>
        </table></td>
      </tr>
      <tr>
        <td height="38"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="270" height="38" background="images/main_09.gif">&nbsp;</td>
            <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="77%" height="25" valign="bottom"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="50" height="19"></td>
                    <td width="50"></td>
                    <%--<td width="150"><div align="center"><a onfocus="this.blur()" target="_blank" href="http://61.54.1.57:801/"><img width="148" height="19" src="images/link.gif"></a></div></td>--%>
                    <td width="50"><div align="center"><a href="right.aspx" target="I2" onfocus="this.blur()" ><img src="images/main_12.gif" width="48" height="19"/></a></div></td>
                    <td width="100"><div align="center"><a href="changepwd.aspx" target="I2" onfocus="this.blur()" ><img src="images/main_22.gif" width="98" height="19"/></a></div></td>
                    <td width="26"><div align="center"><img src="images/main_21.gif" width="26" height="19"/></div></td>
                    <td width="50"><div align="center"><a href="logout.aspx"  onfocus="this.blur()" ><img src="images/main_20.gif" width="48" height="19"/></a></div></td>
                    <td>&nbsp;</td>
                  </tr>
                </table></td>
                <td width="220" valign="bottom"  nowrap="nowrap"><div align="right"><span class="STYLE1"><span class="STYLE2">■</span> 今天是：<script language="JavaScript">
                                                                                                                                               document.write(showDate());
</script></span></div></td>
              </tr>
            </table></td>
            <td width="21"><img src="images/main_11.gif" width="21" height="38"></td>
          </tr>
        </table></td>
      </tr>
      <tr>
        <td height="8" style=" line-height:8px;"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="270" background="images/main_29.gif" style=" line-height:8px;">&nbsp;</td>
            <td width="505" background="images/main_30.gif" style=" line-height:8px;">&nbsp;</td>
            <td style=" line-height:8px;">&nbsp;</td>
            <td width="21" style=" line-height:8px;"><img src="images/main_31.gif" width="21" height="8"></td>
          </tr>
        </table></td>
      </tr>
    </table></td>
  </tr>
  <tr>
    <td height="28" background="images/main_36.gif"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="177" height="28" background="images/main_32.gif"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="20%"  height="22">&nbsp;</td>
            <td width="59%" valign="bottom"><div align="center" class="STYLE1"></div></td>
            <td width="21%">&nbsp;</td>
          </tr>
        </table></td>
        <td class="STYLE3">当前用户：<%=Session["uname"] %>,所在单位：<%=Session["deptname"] %></td>
        <td width="21"><img src="images/main_37.gif" width="21" height="28"></td>
      </tr>
    </table></td>
  </tr>
</table>

    </form>
</body>
</html>
