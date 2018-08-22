<%@ Page Language="C#" %>

<style type="text/css">
    #detailTable td { padding: 7px 2px; }
    #detailTable .tdinput { text-align: left; }
    #detailTable .left_td { text-align: right; background: #fafafa; width: 100px; }
</style>
<% 
    /** 
     *查看机房租赁合同台账详情
     * 
     */
    string id = string.IsNullOrEmpty(Request.QueryString["id"]) ? "" : Request.QueryString["id"].ToString();
%>
<script type="text/javascript">
    $(function () {
        if ($('#id').val().length > 0) {
            parent.$.messager.progress({
                text: '数据加载中....'
            });
            $.post('../ajax/Srv_AccessNetwork.ashx/GetLeaseContractfoByID', {
                ID: $('#id').val()
            }, function (result) {
                parent.$.messager.progress('close');
                if (result.rows[0].id != undefined) {
                    $('#anid').html(result.rows[0].anid);
                    $('#roomname').html(result.rows[0].roomname);
                    $('#cityname').html(result.rows[0].cityname);
                    $('#address').html(result.rows[0].address);
                    $('#contractno').html(result.rows[0].contractno);
                    $('#contractstart').html(result.rows[0].contractstart);
                    $('#contractend').html(result.rows[0].contractend);
                    $('#contractor').html(result.rows[0].contractor);
                    $('#rent').html(result.rows[0].rent);
                    $('#allrent').html(result.rows[0].allrent);
                    $('#payclosingdate').html(result.rows[0].payclosingdate);
                    $('#lastpaydate').html(result.rows[0].lastpaydate);
                    $('#payamount').html(result.rows[0].payamount);
                    $('#paymonth').html(result.rows[0].paymonth);
                    $('#thispaydate').html(result.rows[0].thispaydate);
                    $('#thispayamount').html(result.rows[0].thispayamount);
                    $('#otheraccount').html(result.rows[0].otheraccount);
                    $('#accountnumber').html(result.rows[0].accountnumber);
                    $('#openingbank').html(result.rows[0].openingbank);
                    $('#contact').html(result.rows[0].contact);
                    $('#memo1').html(result.rows[0].memo1);
                    $('#memo2').html(result.rows[0].memo2);
                    $('#memo3').html(result.rows[0].memo3);
                    $('#memo4').html(result.rows[0].memo4);
                }
            }, 'json');
        }
    });

</script>
<table cellspacing="0" cellpadding="0" bordercolor="#CCCCCC" border="1" style="border-collapse: collapse;" id="detailTable">
   <tr>
            <td class="left_td">局站编码：
            </td>
            <td class="tdinput" colspan="3">
                <input type="hidden" id="id" name="id" value="<%=id %>" />
                <span id="anid"></span>
            </td>
       </tr>
        <tr>
            <td class="left_td">机房名称：
            </td>
            <td class="tdinput" colspan="3">
                <span id="roomname"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">所属县市：
            </td>
            <td class="tdinput" style="width:180px;">
                <span id="cityname"></span>
            </td>
          <td class="left_td" >租赁合同编号：
            </td>
            <td class="tdinput"style="width:180px;">
                <span id="contractno"></span>
            </td>
        </tr>

        <tr>
            <td class="left_td">详细地址：
            </td>
            <td class="tdinput" colspan="3">
                <div id="address"></div>
            </td>
        </tr>
        <tr>
           <td class="left_td">合同开始日期：
            </td>
            <td class="tdinput">
                <span id="contractstart"></span>
            </td>
            <td class="left_td">合同截止日期：
            </td>
            <td class="tdinput">
                <span id="contractend"></span>
            </td>
        </tr>
        <tr>
            <td class="left_td">租赁合同方：
            </td>
            <td class="tdinput" colspan="3">
                <span id="contractor"></span>
            </td>
               </tr>
        <tr>
            <td class="left_td">合同年租金：
            </td>
            <td class="tdinput">
                <span id="rent"></span>
            </td>
     
            <td class="left_td">合同总金额：
            </td>
            <td class="tdinput">
                <span id="allrent"></span>
            </td>
             </tr>
        <tr>
            <td class="left_td">付款截止日期：
            </td>
            <td class="tdinput">
                <span id="payclosingdate"></span>
            </td>
       
            <td class="left_td">上一年付款日期：
            </td>
            <td class="tdinput">
                <span id="lastpaydate"></span>
            </td>
              </tr>
        <tr>
            <td class="left_td">付款总额：
            </td>
            <td class="tdinput">
                <span id="payamount"></span>
            </td>
      
            <td class="left_td">应付款月份：
            </td>
            <td class="tdinput">
                <span id="paymonth"></span>
            </td>
             </tr>
        <tr>
            <td class="left_td">本年付款日期：
                  
            </td>
            <td class="tdinput">
                <span id="thispaydate"></span>
            </td>
       
            <td class="left_td">付款总额：
            </td>
            <td class="tdinput">
                <span id="thispayamount"></span>
            </td>
             </tr>
        <tr>
            <td class="left_td" >对方账户：
            </td>
            <td class="tdinput">
                <span id="otheraccount"></span>
            </td>
       
            <td class="left_td">对方账号：
            </td>
            <td class="tdinput">
                <span id="accountnumber"></span>
            </td>
        </tr>
     <tr>
            <td class="left_td" >对方开户行：
            </td>
            <td class="tdinput">
                <span id="openingbank"></span>
            </td>
       
            <td class="left_td">联系方式：
            </td>
            <td class="tdinput">
                <span id="contact"></span>
            </td>
        </tr>
<tr>
            <td class="left_td" valign="top">票据类型：
            </td>
            <td class="tdinput" colspan="3">
                <div id="memo4"></div>
            </td>
        </tr>
        <tr>
            <td class="left_td">备注1：
            </td>
            <td class="tdinput" colspan="3">
                <div id="memo1"></div>
            </td>
        </tr>
        <tr>
            <td class="left_td" valign="top">备注2：
                
            </td>
            <td class="tdinput" colspan="3">
                <div id="memo2"></div>
            </td>
        </tr>
        <tr>
            <td class="left_td" valign="top">备注3：
            </td>
            <td class="tdinput" colspan="3">
                <div id="memo3"></div>
            </td>
        </tr>
    
</table>
