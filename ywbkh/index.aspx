<%@ Page Language="C#" AutoEventWireup="true" CodeFile="index.aspx.cs" Inherits="ywbkh_index" %>

<%@ Register Src="menu.ascx" TagName="menu" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>运行维护部员工考核</title>
    <link type="text/css" href="css/style.css" rel="Stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
    <table style="border-collapse: collapse" bordercolor="#f5f5ff" cellspacing="0" cellpadding="6"
        width="100%" bgcolor="#f5f5ff" border="2">
        <tbody>
            <tr>
                <td class="head" align="center" height="25">
                    <b style="font-size: 18px;">运行维护部员工考核</b>
                </td>
            </tr>
            <tr>
                <td valign="center" bgcolor="#ced4e8" height="18">
                    <uc1:menu ID="menu1" runat="server" />
                    <asp:Label ID="lblDeptName" Style="margin-left: 35%; display: inline; text-align: center;
                        color: Black; font-weight: 700;" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
            <tr>
                <td valign="top" align="center" bgcolor="#f5f5ff">
                    <table style="border-collapse: collapse" bordercolor="#6a71a3" cellspacing="1" cellpadding="3"
                        width="96%" border="1">
                        <tbody>
                            <tr>
                                <td class="head" align="left">
                                    <b>考核评分</b>
                                </td>
                            </tr>
                            <tr align="center">
                                <td>
                                    <p style="text-align: left;">
                                        <b>选择考核月份：</b><asp:DropDownList ID="scoredate" runat="server">
                                        </asp:DropDownList>
                                        <span class="btnp" style="text-align: left; padding-left: 35px;">
                                            <asp:Button ID="btnSearch" class="btn" runat="server" Text="查询数据" OnClick="btnSearch_Click" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            <asp:Button ID="btnExportExcel" class="btn" runat="server" Text="导出Excel" OnClick="btnExportExcel_Click" /></span>
                                    </p>
                                    <h4 style="width: 900px; text-align: center;">
                                        <span runat="server" id="sd"></span>运行维护部部门员工考核办法</h4>
                                    <table bordercolor="#6a71a3" cellspacing="1" cellpadding="3" border="1" style="border-collapse: collapse">
                                        <tr style="line-height: 20px;" class="bold" align="center" bgcolor="#ced4e8">
                                            <td width="80" rowspan="4">
                                                姓名
                                            </td>
                                            <td width="240" colspan="3">
                                                日常工作（权重30分）
                                            </td>
                                            <td width="360" colspan="4">
                                                KPI考核（权重60分）
                                            </td>
                                            <td width="90">
                                                胜任度(权重10分)
                                            </td>
                                            <td width="80" rowspan="4">
                                                得分
                                            </td>
                                        </tr>
                                        <tr tyle="line-height: 20px;" class="bold" align="center" bgcolor="#ced4e8">
                                            <td width="150">
                                                A
                                            </td>
                                            <td width="150">
                                                B
                                            </td>
                                            <td width="150">
                                                C
                                            </td>
                                            <td width="90">
                                                D
                                            </td>
                                            <td width="150">
                                                E
                                            </td>
                                            <td width="180" colspan="2">
                                                F
                                            </td>
                                            <td width="150">
                                                G
                                            </td>
                                        </tr>
                                        <tr tyle="line-height: 20px;" class="bold" align="center" bgcolor="#ced4e8">
                                            <td width="90">
                                                劳动纪律
                                            </td>
                                            <td width="90">
                                                信息报道
                                            </td>
                                            <td width="90">
                                                基础报表
                                            </td>
                                            <td width="90">
                                                网运指标
                                            </td>
                                            <td width="90">
                                                工作效率
                                            </td>
                                            <td width="180" colspan="2">
                                                其它加扣分
                                            </td>
                                            <td width="90">
                                                贡献度胜任度职业道德
                                            </td>
                                        </tr>
                                        <tr style="line-height: 20px;" class="bold" bgcolor="#ced4e8">
                                            <td width="90">
                                                迟到或早退一次扣1分、事假每天扣2分，病假每天扣1分执行。无故旷工半天，扣5分。无故旷工一天，扣10分，扣分随天数增加而增加.
                                            </td>
                                            <td width="90">
                                                每人每月至少上报信息1篇，每差一篇扣5分。凡信息被市公司采用的加2分，被省公司采用的加5分。
                                            </td>
                                            <td width="90">
                                                未按时出规定报表一次扣2分，被省公司通报一次扣5分。
                                            </td>
                                            <td width="90">
                                                本岗位挂靠指标完成情况
                                            </td>
                                            <td width="90">
                                                不能按时按要求完成本岗位工作任务（周工作计划内容、日常工作内容），效率低的每次每项扣2分
                                            </td>
                                            <td width="180" colspan="2">
                                                全省有通报的各项工作中，排名前三加5分，排名前6加3分，低于全省平均水平扣2分，排名12名之后扣3分，排名后三扣5分
                                            </td>
                                            <td width="90">
                                                部门员工得分=部门正职得分*50+部门副职得分*30%+员工互评得分*20%; 部门副职得分=员工打分均值
                                            </td>
                                        </tr>
                                        <asp:Repeater ID="repData" runat="server">
                                            <ItemTemplate>
                                                <tr align="center">
                                                    <td>
                                                        <%#Eval("uname") %>
                                                    </td>
                                                    <td>
                                                        <%#Eval("score_a") %>
                                                    </td>
                                                    <td>
                                                        <%#Eval("score_b") %>
                                                    </td>
                                                    <td>
                                                        <%#Eval("score_c") %>
                                                    </td>
                                                    <td>
                                                        <%#Eval("score_d") %>
                                                    </td>
                                                    <td>
                                                        <%#Eval("score_e") %>
                                                    </td>
                                                    <td>
                                                        <%#Eval("score_f1") %>
                                                    </td>
                                                    <td>
                                                        <%#Eval("score_f2") %>
                                                    </td>
                                                    <td>
                                                        <%#handleSRD(Eval("uname").ToString())%>
                                                    </td>
                                                    <td>
                                                        <%#handleZF(Eval("uname").ToString())%>
                                                    </td>
                                                </tr>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                        <tr tyle="line-height: 20px;" class="bold" align="center" bgcolor="#ced4e8">
                                            <td>
                                                考核员
                                            </td>
                                            <td>
                                                白凌峰
                                            </td>
                                            <td>
                                                李靖
                                            </td>
                                            <td>
                                                董雪娥
                                            </td>
                                            <td>
                                                董雪娥（白凌峰、李常欣）
                                            </td>
                                            <td>
                                                李常欣
                                            </td>
                                            <td colspan="2">
                                                白凌峰
                                            </td>
                                            <td>
                                                全体人员
                                            </td>
                                            <td>
                                                &nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="11" align="left">
                                                说明：
                                                <br />
                                                1、每月10日前出分项考核数据并汇总公示，15日前报人力资源部。<br />
                                                2、分项考核员负责月分项数据的记录与汇总，月分项扣分原因须注明。
                                                <br />
                                                3、网运指标项由分管副职负责督促、审核和落实。
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </tbody>
                    </table>
    </form>
</body>
</html>
