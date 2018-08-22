<%@ Page Language="C#" AutoEventWireup="true" CodeFile="xlzgxxkgllck.aspx.cs" Inherits="xlbdxxxq" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>整改事项管理</title>
    <link type="text/css" href="../css/style.css" rel="Stylesheet" />
    <script type="text/javascript" src="../Script/easyui/jquery-1.10.2.min.js"></script>
    <script type="text/javascript">
        function Edit(obj) {
            $(obj).parent().find(":text").css("display", "");
            $(obj).parent().find("span").css("display", "none");
            $(obj).css("display", "none");
            $(obj).parent().find("#save").css("display", "");
        }
        function Save(obj) {
            var id = $(obj).parent().find(":hidden").val();
            var amount = $(obj).parent().find(":text").val();
            $.post("../ajax/EditKgck.ashx", { id: id, amount: amount, action: "EditKgck" },
            function (data) {
                switch (data) {
                    case "NoPrivilege":
                        alert("登陆超时，请重新登录后在进行操作！");
                        top.location.href = '../';
                        break;
                    case "ErrorNum":
                        alert("输入有误，请检查修改的数量！");
                        $(obj).parent().find(":text").focus();
                        break;
                    case "NoEnoughStock":
                        alert("库存不足，请检查修改的数量！");
                        $(obj).parent().find(":text").focus();
                        break;
                    case "ResponseError":
                        alert("系统错误，请联系管理员！");
                        break;
                    case "Succ":
                        alert("修改成功！");
                        $(obj).parent().find("span").css("display", "").text($(obj).parent().find(":text").val());
                        $(obj).parent().find(":text").css("display", "none");
                        $(obj).css("display", "none");
                        $(obj).parent().find("#edit").css("display", "");
                        break;
                }
            }
            );
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div id="content">
        <p class="sitepath">
            <b>当前位置：</b>整改事项管理 > <a href="xlzgxxgl.aspx">整改信息管理</a>>库管对区域维护领料单确认出库
        </p>
        <br />
        <table border="1" bordercolor="#CCCCCC" cellpadding="0" cellspacing="0" class="tablewidth">
            <tr style="background-color: #eeeeee; line-height: 30px;">
                <td colspan="4" align="center">
                    库管对区域维护领料单确认出库
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
                <td class="tdtitle">
                    派单人：
                </td>
                <td class="tdinput" id="pdr" runat="server">
                </td>
                <td class="tdtitle">
                    派单时间：
                </td>
                <td class="tdinput" id="pdsj" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    联系人：
                </td>
                <td class="tdinput" id="lxr" runat="server">
                </td>
                <td class="tdtitle">
                    联系电话：
                </td>
                <td class="tdinput" id="lxdh" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    维护单位：
                </td>
                <td class="tdinput" id="whdw" runat="server">
                </td>
                <td class="tdtitle">
                    负责人：
                </td>
                <td class="tdinput" id="fzr" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    区域维护：
                </td>
                <td class="tdinput" id="qywh" runat="server">
                </td>
                <td class="tdtitle">
                    整改人：
                </td>
                <td class="tdinput" id="zgr" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    整改措施：
                </td>
                <td class="tdinput" colspan="3" height="50" id="zgcs" runat="server">
                </td>
            </tr>
            <tr>
                <td class="tdtitle">
                    领料人：
                </td>
                <td class="tdinput" id="llr" runat="server">
                </td>
                <td class="tdtitle">
                    联系电话：
                </td>
                <td class="tdinput" id="llrlxdh" runat="server">
                </td>
            </tr>
            <tr>
                <td colspan="4" style="padding: 0px;">
                    <table style="width: 698px;" border="1" bordercolor="#CCCCCC" cellpadding="0" cellspacing="0">
                        <tr style="background-color: #eeeeee; line-height: 30px;">
                            <td width="40">
                                序号
                            </td>
                            <td>
                                物资类别
                            </td>
                            <td>
                                物资型号
                            </td>
                            <td width="40">
                                盘号
                            </td>
                            <td>
                                领取数量
                            </td>
                        </tr>
                        <asp:Repeater ID="repData" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td>
                                        <%#Eval("rowid") %>
                                    </td>
                                    <td>
                                        <%#Eval("classname") %>
                                    </td>
                                    <td>
                                        <%#Eval("typename") %>
                                    </td>
                                    <td>
                                        <%#Eval("panhao") %>
                                    </td>
                                    <td>
                                    <input type="hidden" value="<%#Eval("id") %>">
                                        <span style="width: 40px;">
                                            <%#Eval("amount") %></span>
                                        <input type="text" value="<%#Eval("amount") %>" style="width: 40px; display: none;">&nbsp;&nbsp;<%#Eval("units") %>&nbsp;&nbsp;<input
                                            type="button" value="编辑" class="smBtn" id="edit" onclick="Edit(this)" /><input  type="button" value="保存" class="smBtn" onclick="Save(this)" id="save" style="display:none;"/>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </table>
                </td>
            </tr>
            <tr >
                <td class="tdtitle">
                    是否需要退料：
                </td>
                <td colspan="3" class="tdinput">
                    <asp:DropDownList runat="server" ID="ddltlzt">
                        <asp:ListItem Text="有退料" Value="0" />
                        <asp:ListItem Text="无退料" Value="1" />
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td colspan="4" class="btnp">
                    <asp:Button ID="Button1" runat="server" Text="库管对区域维护领料单确认出库" OnClick="Button1_Click" />
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
