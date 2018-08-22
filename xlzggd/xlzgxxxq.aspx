<%@ Page Language="C#" AutoEventWireup="true" CodeFile="xlzgxxxq.aspx.cs" Inherits="xlbdxxxq" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>整改事项管理</title>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
    <div id="content">
     <p class="sitepath">
            <b>当前位置：</b>整改事项管理 > <a href="xlzgxxgl.aspx">整改信息管理</a>> 整改通知书详情
        </p>
        <table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" class="tablewidth" >
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                    整改通知书详情
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    编号：
                </td>
                <td class="tdinput" id="zgid" runat="server">
                </td>
                <td class="tdtitle">
                    派单单位：
                </td>
                <td class="tdinput" id="pddw" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle" >
                    派单人：
                </td>
                <td class="tdinput"  id="pdr" runat="server">
                </td>
                <td class="tdtitle" >
                    派单时间：
                </td>
                <td class="tdinput"  id="pdsj" runat="server">
                </td>
            </tr>
             <tr>
                <td class="tdtitle">
                    线路类型：
                </td>
                <td class="tdinput"  id="xllx" runat="server">
                </td>
                   <td class="tdtitle">
                   工单历时：
                </td>
                <td class="tdinput" id="jobDuration" runat="server" >
                </td>
            </tr>
            <tr>
                <td class="tdtitle" >
                    联系人：
                </td>
                <td class="tdinput"  id="lxr" runat="server">
                </td>
                <td class="tdtitle" >
                    联系电话：
                </td>
                <td class="tdinput"  id="lxdh" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle" >
                    维护单位：
                </td>
                <td class="tdinput"  id="whdw" runat="server">
                </td>
                <td class="tdtitle" >
                    负责人：
                </td>
                <td class="tdinput"  id="fzr" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    整改区域：
                </td>
                <td class="tdinput" colspan="3" id="zgqy" runat="server" height="30" valign="top">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    存在问题：
                </td>
                <td class="tdinput" colspan="3" id="czwt" runat="server" height="40" valign="top">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    整改要求：
                </td>
                <td class="tdinput" colspan="3" id="zgyq" runat="server" height="30" valign="top">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    整改时限：
                </td>
                <td class="tdinput" colspan="3" id="zgsx" runat="server" height="30" valign="top">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                  区域维护：
                </td>
                <td class="tdinput" colspan="3" id="qywh" runat="server">
                </td>
            </tr>
            <tr <%=isZg?"":"style='display:none'" %>>
                <td class="tdtitle">
                    整改措施：
                </td>
                <td class="tdinput" colspan="3" height="30" id="zgcs" runat="server" valign="top">
                </td>
            </tr>
            <tr <%=isZg?"":"style='display:none'" %>>
                <td class="tdtitle">
                    整改人：
                </td>
                <td class="tdinput" id="zgr" runat="server" colspan="3">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    领料信息：
                </td>
                <td class="tdinput" id="zgll" runat="server">
                </td>
                <td class="tdtitle">
                    退料信息：
                </td>
                <td class="tdinput" id="zgtl" runat="server">
                </td>
            </tr>
                <tr  <%=isTOWN?"style='display:none'":"" %>>
                <td class="tdtitle">
                   外包单位确认区域维护领料单：
                </td>
                <td class="tdinput" id="wbqr" runat="server" >
                </td>
                  <td class="tdtitle">
                   线管确认区域维护领料单：
                </td>
                <td class="tdinput" id="xgqr" runat="server">
                </td>
            </tr>
            <tr  <%=isTD?"":"style='display:none'" %> >
                <td class="tdtitle">
                    退单原因：
                </td>
                <td class="tdinput" id="tdyy" runat="server" colspan="3">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    库管确认领料出库：
                </td>
                <td class="tdinput" id="kgck" runat="server" colspan="3">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    外包整改完结时间：
                </td>
                <td class="tdinput" id="wjsj" runat="server" >
                </td>
                <td class="tdtitle">
                    确认整改完结时间：
                </td>
                <td class="tdinput" id="qrwjsj" runat="server" >
                </td>
            </tr>
              <tr>
                <td class="tdtitle">
                   整改备注：
                </td>
                <td class="tdinput" id="zgbz" runat="server"  colspan="3">
                </td>
                
            </tr>
            <tr <%=isFC?"":"style='display:none'" %>>
                <td class="tdtitle">
                    复查意见：
                </td>
                <td class="tdinput" colspan="3" height="30" id="fcyj" runat="server"  valign="top">
                </td>
            </tr>
            <tr <%=isFC?"":"style='display:none'" %>>
                <td class="tdtitle">
                    复查人：
                </td>
                <td class="tdinput" id="fcr" runat="server">
                </td>
                <td class="tdtitle">
                    复查时间：
                </td>
                <td class="tdinput" id="fcsj" runat="server">
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
