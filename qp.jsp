<!-- ========================================================== -->
<!-- quickPay.jsp - Written by: bxr043- March 2014 				-->
<!-- ========================================================== -->
<%
/*
 * [Change Log]
 * Date:      UserName: Project:   Description of change(s)
 * ========== ========= ========== ==================================================
 * 12/16/2014 bxr043	PBP project    Created for PBP UI- project
 *
*/ %>


<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/sbi-taglib.tld" prefix="sbi" %>
  
 <link rel="StyleSheet"
	href="<html:rewrite page="/view/body/styles/jquery-ui-1.11.4.css" module="" />" 
	type="text/css"/>
	
 <link rel="StyleSheet"
	href="<html:rewrite page="/view/body/styles/quickpay.css" module="" />" 
	type="text/css"/>
<link rel="StyleSheet"
	href="<html:rewrite page="/view/body/styles/creditcard.css" module="" />" 
	type="text/css"/>
<html:xhtml/>

<bean:define id="action" name="action" type="java.lang.String" />
<bean:struts id="mapping" mapping="<%= action %>" />
<bean:define id="formName" name="mapping" property="name" type="java.lang.String"/>
<bean:define id="form" name="<%= formName %>" 
      type="com.amfam.billing.pymtmgr.actions.quickpay.QuickPayPaymentEntryActionForm" />
<bean:define id="paymentBO" name="<%= formName %>" property="payment" 
      type="com.amfam.billing.pymtmgr.entities.Payment"
      toScope="request" />
<bean:define id="paymentPersisted" name="paymentBO" property="persisted"
      type="java.lang.Boolean" />

    <script language="javascript">

    var lablefiller = "                                     ";
    var noLastPay="No payment information is available";
    
window.onload=function(){
	var lastPaymentSelected = <bean:write name="<%=formName%>" property="lastPaymentSelected"/>;
    var paymentOption = '<bean:write name="<%=formName%>" property="paymentOption" />';
    var displayScannerInspection = '<bean:write name="<%=formName%>" property="displayScannerInspectionPopUp" />';
    
    
  	hide('newExpDetail');
 	if(document.getElementById("rowData[0].billingNumber")!=null){
	  document.getElementById("rowData[0].billingNumber").focus();
	}

	if(document.getElementById('lastPayDets').innerText=="" || (document.getElementById('lastPayDets').innerText==noLastPay)){
	   document.getElementById('lastPaymentRadio').checked=false;
	   document.getElementById('lastPaymentRadio').disabled=true;
	   document.getElementById('lastPayHidden').value=false;
	   lastPaymentSelected=false;
	    if(document.getElementById('lastPayDets').innerText==""){
	    document.getElementById('lastPayDets').innerText=lablefiller;
		}
	}
	if((paymentOption =='PBP') && !lastPaymentSelected) {
	  document.getElementById('checkingSavingsRadio').checked=true;
	  showHide(paymentOption);
	} else if(paymentOption=='CRC' && !lastPaymentSelected){	
	   
		
	  if(displayScannerInspection=='true'){
   	  	popUp();
   	  }else{
   		document.getElementById('scannedCardNumber').value ='';
   		document.getElementById('scanEntryCheckbox').checked=false;
   		manualEntryDisplay();
   		updateTotal();
   	  }
	  document.getElementById('creditCardRadio').checked=true;
	  showHide(paymentOption);
	}else if(lastPaymentSelected){
	  document.getElementById('lastPaymentRadio').checked=true;
	  showHide(paymentOption);
	}
	
	if(document.getElementById('lifePolicyInd').value =='true'){
	clearPBPFields();
	hide('checkSav');
	document.getElementById('checkingSavingsRadio').checked =false;
	document.getElementById('checkingSavingsRadio').disabled =true;
	}
	<logic:present role="CBSAM,CBSAM_Specialists,Recovery,RPC_PaymentEntry,Remittance_Srv_Tech,PSandS">
     // Load a URL asynchronously using Ajax.  Ignore response.
     <%
         // Rewrite does not work properly for modules
         // hot fix.  Have to get the application instance
	     String url = request.getRequestURI();
	     String[] temp;
	     temp = url.split("/");
     %>
	loadUrlAsync("/<%=org.apache.commons.lang.StringEscapeUtils.escapeHtml(temp[1])%>/QP/stopI3Recording.do?userid=<%=org.apache.commons.lang.StringEscapeUtils.escapeHtml(request.getRemoteUser())%>&restart=false");
</logic:present>
}
</script>
<!--  ====================== 
         D E T A I L S 
      ======================  -->
        <h4  class="valueGreen">***Select &#39;Details&#39;
 to populate Last Payment information***</h4>
 		
 		<div id='alphanumonlyoverlay' style="visibility:hidden; color:red; font-weight:bold; font-family:Verdana; font-size:medium;" >
					Special characters not allowed.
		</div>
 		
      <hr/> 
      <table id="detailTable" width="100%" class="mastertable">
            <colgroup>
                  <col width="10%" />
                  <col width="10%" />
                  <col width="9%" />
                  <col width="13%" />
                  <col width="10%" />
                  <col width="10%" />
                  <col width="10%" />
                  <col width="10%" />
                  <col width="10%" />
                  <col width="8%" />
            </colgroup>
            <tr class="heading">
                  <th><bean:message key="table.heading.billingNumber" /></th>
                  <th><bean:message key="table.heading.policyNumber" /></th>
                  <th><bean:message key="table.heading.amount" /></th>
                  <th><bean:message key="table.heading.designation" /></th>
                  <th><bean:message key="table.heading.billingSystem" /></th>
                  <th><bean:message key="table.heading.fullPay" /></th>
                  <th><bean:message key="table.heading.payInFullAmount" /></th>
                  <th><bean:message key="table.heading.minPay" /></th>
                  <th><bean:message key="table.heading.dueDate" /></th>
                  <th><bean:message key="table.heading.pastDue" /></th>
            </tr>

<%
      boolean isEvenRow = true;
      int i = 0;
%>
      <logic:iterate id="detail" name="<%= formName %>" property="rowData"
            type="com.amfam.billing.pymtmgr.actions.PaymentDetailEntryActionForm" >
<%
      if (!detail.isDetailMarkedForDeletion()) {
            isEvenRow = !isEvenRow;
            String rowId = "rowData[" + i + "].";
%>
		<tr id='<%= "detailRow" + i %>'
			class='<%= isEvenRow ? "even" : "odd" %>'>
		<td>
		 <html:hidden name="<%= formName %>" property='<%= rowId + "sequenceNumber" %>' />
		 <html:hidden styleId='<%= rowId + "detailMarkedForDeletion" %>' name="<%= formName %>" property='<%= rowId + "detailMarkedForDeletion" %>' />
 		<html:text styleId='<%= rowId + "billingNumber" %>' name="<%= formName %>" property='<%= rowId + "billingNumber" %>' onkeypress="return blockSpecialCharAllowDash(this,event);"  onchange='<%= "checkbillingNumChange("+formName+"," + i + ",checkbillingNumChange)" %>' size="14" maxlength="20" />
		</td>
		<td>
			<html:text name="<%= formName %>" styleId='<%= rowId + "policyNumber" %>' property='<%= rowId + "policyNumber" %>' onkeypress="return blockSpecialCharAllowDash(this,event);" size="14" maxlength="20" />
		</td>
		<td><html:text name="<%= formName %>" styleId='<%= rowId + "amount" %>' property='<%= rowId + "amount" %>'
			size="12" maxlength="13" styleClass="money"
			onblur="updateTotal();"
			 /></td>
		<td><html:select name="<%= formName %>" styleId='<%= rowId + "designation" %>' property='<%= rowId + "designation" %>' >
			<logic:iterate id="op"
				name="<%= formName %>"
				property="payment.method.allowedDesignations"
				type="com.amfam.billing.pymtmgr.domain.PaymentDesignation" >
					<html:option value="<%= op.name() %>" 
						key='<%= "listText.designation." + op.name() %>' />				
			</logic:iterate>			
			</html:select>
		</td>
		
		<td class="value"><bean:write name="<%= formName %>" property='<%= rowId + "billingSystem" %>' /></td>
		<td class="money"><bean:write name="<%= formName %>" property='<%= rowId + "totalDue" %>' formatKey="moneyFormat"/></td>
		<td class="money"><bean:write name="<%= formName %>" property='<%= rowId + "payInFullAmount" %>' formatKey="moneyFormat"/></td>
		<td class="money"><bean:write name="<%= formName %>" property='<%= rowId + "minDue" %>' formatKey="moneyFormat"/></td>
		<td class="value"><bean:write name="<%= formName %>" property='<%= rowId + "dueDate" %>'/></td>
		<td class="value"><bean:write name="<%= formName %>" property='<%= rowId + "pastDue" %>' /></td>
		<td><button type="button" class="small" onclick="<%= "qpdeleteRow("+formName+"," + i + ")" %>"  id='<%= rowId + "deleteButton" %>' >Delete</button></td>
		</tr>
		<tr id='<%= "detailRow" + i + "-" + i%>'
			class='<%= isEvenRow ? "even" : "odd" %>'>
			<td class="value" colspan="10">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b><bean:message key="table.heading.accountholderName" /></b><bean:write name="<%= formName %>" property='<%= rowId + "acctHolderName" %>'/></td>
		</tr>
 
      <%
      }
      i++;
 %>
      </logic:iterate>
      <tr><td colspan="10"><hr/></td></tr>
            <tr>
                  <td>
                        <input type="hidden" name="deleteRowId" id="deletedRowId" value="-1"/>
                        <input type="hidden" name="userPushedReset" id="userPushedReset" value="-1"/>


                        <button type="button" id="addrow" name="addrow" class="small">Add Row</button>
                  </td>
                  <td class="textlabelRight"><bean:message key="label.totalAmount" /></td>
                  <td id="totalAmount"  class="totalMoney">$0.00</td>
                  <td colspan="7">&nbsp;</td>
            </tr>
   </table>
   
   <div style="display:none;" id="dialog-confirm" title="Card Reader Inspection Request"><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 15px 0;"></span>
    <b> <bean:message key="label.heading" /> <br><br></b>
     <ui>
       <li><bean:message key="label.inspectSwipe" /></li>
       <li><bean:message key="label.inspectCables" /></li>
       <li><bean:message key="label.inspectUSB" /></li>
       <li><bean:message key="label.inspectTape" /></li>
      <li><bean:message key="label.inspectCode" /></li>
    <br>
     <b><bean:message key="label.inspectHelpdesk" /></b>
     </ui>
</div>
   
     <html:hidden styleId="formtotalamount" property="amount" />
   <div id="dateParem">
      <html:hidden styleId="expDateFull" property="expDateFull" />
    </div>
<div><table class="textlabel" id="receivedFrom">
	<tr class="textlabel" valign="top">
			<td align="left"  bordercolor="black" colspan="3" >
				<div id='alphaonlyoverlay' style="visibility:hidden; color:red; font-weight:bold; font-family:Verdana; font-size:medium;" >
					Alpha characters only.
				</div>	
				<div id='alphaonlyoverlayForPaste' style="visibility:hidden; color:red; font-weight:bold; font-family:Verdana; font-size:medium;" >
					Copy/Paste not allowed when numeric or special characters exist.
				</div>
			</td>
	</tr>
    <tr valign="bottom" class="textlabel">
			<td><bean:message key="label.receivedFrom" />:</td>
			<td><html:text property="receivedFrom" styleClass="alphaOnly" size="22" maxlength="22"/></td>
            </tr>
            <tr valign="top" class="textlabelredsmall">
			<td>(Payor Name)</td>
		</tr>
			</table></div>	
 <table><tr valign="bottom">
<td valign="top"><input type="radio"  class="radioButton" onclick="showHide('LastPayment')"  id="lastPaymentRadio" ></td>
<td valign="top"><label class="textlabel"><bean:message key="label.LastPayment" /></label><label for="lastPaymentDetails" id="lastPayDets" class="radioLabel odd"><bean:write  name="form" property="lastPaymentDetails" /></label>
</tr>
</table>
 <div id="lastPayDetails" style="visibility:hidden;display:none">
<html:hidden  name="form" property="cardExpiredInd" styleId="cardExpiredIndicator"  ></html:hidden>
<html:hidden  name="form" property="lastPaymentSelected" styleId="lastPayHidden"  ></html:hidden>
<html:hidden  name="form" property="lastPaymentDetails" styleId="lastPayDetailsHidden"  ></html:hidden>
<html:hidden  name="form" property="paymentOption" styleId="paymentOptionHidden"  ></html:hidden>
<html:hidden  name="form" property="lifePolicyInd" styleId="lifePolicyInd"  ></html:hidden>
 
<table  class="textlabel" id='lastPayWarning'>
					<tr>
						<td  class="textlabelred" >WARNING:</td>								
						<td  class="textlabel"><p><small><bean:message key="label.pbplegal.warningmessage"/></small></p>	</td>			
				    </tr>  
		</table>
</div>
<table  class="textlabel" id="newExpDetail">
	<logic:equal name="<%= formName %>" property="cardExpiredInd" value="true" >
	<% if (com.amfam.billing.pymtmgr.util.MiscUtil.roleRequiresMasking(request)) { %>
				<% // These Credit Card Number fields should be masked.   %>
	<tr>
		<td><bean:message key="label.newExpDate" />:</td>
				<td>
					<html:password styleId="expDateMM1" property="expDateMM1" onkeyup="return autoTab(this, 2, event);" maxlength="2" size="2" onblur="formatMonth(this);onExpLastPayDateChange();" /> /
					<html:password styleId="expDateYYYY1" property="expDateYYYY1" maxlength="4" size="4" onblur="onExpLastPayDateChange();" />
					
		</td>
			<td id="newExpLabel" class="textlabelred">Card has expired</td>
		
		</tr>
		<% } else { %>
		<tr>
		<td><bean:message key="label.newExpDate" />:</td>
				<td>
					<html:text styleId="expDateMM1" property="expDateMM1" onkeyup="return autoTab(this, 2, event);" maxlength="2" size="2" onblur="formatMonth(this);onExpLastPayDateChange();" /> /
					<html:text styleId="expDateYYYY1" property="expDateYYYY1" maxlength="4" size="4" onblur="onExpLastPayDateChange();" />
					
		</td>
			<td id="newExpLabel" class="textlabelred">Card has expired</td>
		<% } %>
		</tr>
	 </logic:equal>
  </table>
<table><tr class="textlabel" valign="bottom">
<td valign="top"><input type="radio"  class="radioButton" onclick="showHide('PBP')"   id="checkingSavingsRadio" ></td>
<td valign="top"><label for="checkingSavings" class="radioLabel"><bean:message key="label.PBP" /></label></td>
</tr></table>
<div id="checkSav" style="visibility:hidden;display:none">
				<table  class="textlabel" id='PaybyPhoneWarning'>
				<tr>
						<td  class="textlabelred" >WARNING:</td>								
						<td  class="textlabel"><p><small><bean:message key="label.pbplegal.warningmessage"/></small></p>	</td>			
				</tr>
				</table>
<table class="textlabel" id="checSavField">
    <tr class="textlabel" valign="bottom"> 
          <td><bean:message key="label.bankAccountType"/>:</td>
			<td>
				<html:select name="form" property="bankAccountType" styleId="bankAccountType" >
				<html:option value="" ></html:option>
				<html:option value="PERSCHEC"><bean:message key='label.PersonalChecking'/></html:option>
				<html:option value="PERSSAVE"><bean:message key='label.PersonalSavings'/></html:option>
				<html:option value="BUSNCHEC"><bean:message key='label.BusinessChecking'/></html:option>
				<html:option value="BUSNSAVE"><bean:message key='label.BusinessSavings'/></html:option>
				</html:select>
			</td>
		</tr>
		<tr class="textlabel" valign="bottom">
				<td><bean:message key="label.bankRoutingNumber9Digit"/>:</td>
				<td><html:text property="bankRoutingNumberDisplay" styleId="bankRoutingNumberDisplay" size="9" maxlength="9" ></html:text></td></tr>
	<% if (com.amfam.billing.pymtmgr.util.MiscUtil.roleRequiresMasking(request)) { %>
	<tr class="textlabel" valign="bottom">
				<td><bean:message key="label.bankAccountNumber" />:</td>
				<td><html:password property="bankAccountNumberToEncrypt" styleId="bankAccountNumberToEncrypt" size="19" maxlength="17"  /></td>
	</tr>
	<% } else { %>
	<tr class="textlabel" valign="bottom">
				<td><bean:message key="label.bankAccountNumber" />:</td>
				<td><html:text property="bankAccountNumberToEncrypt" styleId="bankAccountNumberToEncrypt" size="19" maxlength="17"  /></td>
	</tr>
	<% } %>
</table>
</div>
<table><tr class="textlabel" valign="bottom">
<td valign="top"><input type="radio"  class="radioButton" onclick="showHide('CRC')"   id="creditCardRadio" /></td>
<td valign="top"><label for="creditCards"  class="radioLabel"><bean:message key="label.CC" /></label></td>
<!-- PBR 2331 changes -->
<td id="creditCardTypes" 	class="col-sm-8 col-md-7">&nbsp; &nbsp;
					<span class="qp-credit-card-img visa"></span>
					<span class="qp-credit-card-img masterCard"></span>
					<span class="qp-credit-card-img amex"></span>
					<span class="qp-credit-card-img discover"></span>
					<span class="qp-credit-card-img unknown hidden">Unknown Credit Card </span></td>

<!--<img src="images/visa1_103x65_a.gif" width="53px" height="34px" title="Visa" alt="Visa"/> &nbsp;<img src="images/Mastercard.gif" width="53px" height="34px" title="MasterCard" alt="MasterCard"/>&nbsp;<img src="images/American_20Express.jpg" width="53px" height="34px" title="AmericanExpress" alt="AmericanExpress"/>&nbsp;<img src="images/Discover.jpg" width="53px" height="34px" title="Discover" alt="Discover"/></td>
-->
</tr></table>
<div id="creditCard" style="visibility:hidden;display:none">
<table class="textlabel"  id="creditCardFields">
<tr class="textlabel" valign="bottom">
				<td><bean:message key="label.scanEntry"/>:</td>	
				<td><html:checkbox styleId="scanEntryCheckbox" property="scanEntryCheckbox" onclick="scanEntry(this);"></html:checkbox> </td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
			
			<tr class="textlabel" valign="bottom" id="scanCardTag">
					<td><bean:message key="label.scanCard" />:</td>					
					<td>		
						<html:password  styleId="scannedCardNumber" property="scannedCardNumber" size="40" onkeydown="disableCopyPaste('#scannedCardNumber');" />
					 </td>
					 <td>&nbsp;</td>			
					<td>&nbsp;</td>
			</tr>		
		<% if (com.amfam.billing.pymtmgr.util.MiscUtil.roleRequiresMasking(request)) { %>
				<% // These Credit Card Number fields should be masked.   %>
				<tr class="textlabel" valign="bottom">
					<td colspan="4">
						<jsp:include page="quickPayCardEntryMasked.jsp" flush="true" />
					</td>
				</tr>					
			
			<% } else { %>
				<tr class="textlabel" valign="bottom">
				<td colspan="4">
						<jsp:include page="quickPayCardEntryNotMasked.jsp" flush="true" />
					</td>	
				</tr>
			<% } %>
</table>						
</div>
<script type="text/javascript">
function showoverlay(){
	var el = document.getElementById("alphaonlyoverlay");
	el.style.visibility ="visible";
}
function hideoverlay(){
	var el = document.getElementById("alphaonlyoverlay");
	el.style.visibility ="hidden";
}
function showoverlayForPaste(){
	var el = document.getElementById("alphaonlyoverlayForPaste");
	el.style.visibility ="visible";
}
function hideoverlayForPaste(){
	var el = document.getElementById("alphaonlyoverlayForPaste");
	el.style.visibility ="hidden";
}
function blockNumbers(obj, e){
	var key;
	var isCtrl = false;
	var keychar;
	var reg;

	if(window.event) {
		key = e.keyCode;
		isCtrl = window.event.ctrlKey
	}
	else if(e.which) {
		key = e.which;
		isCtrl = e.ctrlKey;
	}

	if ((key > 47) && (key < 58)) {
	   showoverlay();
	   setTimeout(hideoverlay,2000);
	   return false;
	}
	
	return true;
}

function showoverlayBillPol(){
	var el = document.getElementById("alphanumonlyoverlay");
	el.style.visibility ="visible";
}
function hideoverlayBillPol(){
	var el = document.getElementById("alphanumonlyoverlay");
	el.style.visibility ="hidden";
}


</script>

<script type="text/javascript">
 function createXMLHttpRequest() {
   try { return new XMLHttpRequest(); } catch(e) {}
   try { return new ActiveXObject("Msxml2.XMLHTTP"); } catch (e) {}
   try { return new ActiveXObject("Microsoft.XMLHTTP"); } catch (e) {}
   alert("XMLHttpRequest not supported");
   return null;
 }

function loadUrlAsync(url) {
	var xhReq = createXMLHttpRequest();
    xhReq.open("POST", url, true);
    xhReq.send(null);
    // Ajax Errors are currently ignored for I3 stop recording.
    // Set xhReq.onreadystatechange function to handle errors.
}
</script>
<script type="text/javascript" >
	var designations = new Array();
	var designationStrings = new Array();
	var paymentMethod = '<bean:write name="<%=formName%>" property="paymentMethod" />'; 
<%
      i = 0;
%>    
      <logic:iterate id="op"
            name="<%= formName %>"
            property="payment.method.allowedDesignations"
            type="com.amfam.billing.pymtmgr.domain.PaymentDesignation" >    
                designations[ <%= Integer.toString( i, 10 ) %> ] = '<%= op.name() %>';
                designationStrings[ <%= Integer.toString( i, 10 ) %> ] = '<bean:message key='<%= "listText.designation." + op.name() %>' />';
                <%
                      i++;
                %>                  
      </logic:iterate>

//----------//
YAHOO.util.Event.onDOMReady(function() { 

   var oElement = document.getElementById("addrow");
     function addRowClick(e) { addEmptyRow();resetTabOrder(); }
   YAHOO.util.Event.addListener(oElement, "click", addRowClick);
   //PBR 2331 changes
    var oElementCC = document.getElementById("creditCardRadio");
     var oElementLP = document.getElementById("lastPaymentRadio");
     var oElementCS = document.getElementById("checkingSavingsRadio");
   function resetDisplay(){
				$("#creditCardTypes > span").each(function(i,e){			
						if (!$(this).hasClass("unknown")){
						$(this).show();
					}else{
						$(this).hide();
					}
				});
			}
 YAHOO.util.Event.addListener(oElementCC, "click", resetDisplay);
 YAHOO.util.Event.addListener(oElementLP, "click", resetDisplay);
  YAHOO.util.Event.addListener(oElementCS, "click", resetDisplay);
		

	// Initialize card number at load time.
	// Only do this if there is a Card Number on the page.
	if (document.getElementById("cardNumber") != null) {
	      onCardNumberChange();
	//		onScannedCardNumberNumberChange();
	}
	
	// Only do this if there is a Expiration Date on the page.
	if (document.getElementById("expDateFull") != null) {
	      onExpDateChange();
	}

	updateTotal();
	
	// Only do this if there is an Origin selection on the page
	if (document.getElementById("originTypeSelect") != null) {
	      onOriginTypeChange(document.getElementById("originTypeSelect"));
	}	
}); 

var oldValue;
var paste = false;
$(".alphaOnly").bind("input", function() {
	var regexp = /[^-'a-zA-Z ]/g;
	if ($(this).val().match(regexp)) {
		if (paste) {
			$(this).val(oldValue);
			showoverlayForPaste();
			setTimeout(hideoverlayForPaste, 2000);
		} else {
			$(this).val($(this).val().replace(regexp, ''));
			showoverlay();
			setTimeout(hideoverlay, 2000);
		}
	}
	paste = false;
	oldValue = $(this).val();
});

$(document).on("paste", ".alphaOnly", function(e) {
	paste = true;
});

	
	
	
	//PBR 2331 changes 
		//ccformatting on input box   			    
   			$("#cardNumberFull").inputmask({"ccTypeId" : "creditCardTypes"});
   			$("#cardNumberFull").val("");
		//aria default
	   			//ccfield
	   			$("#cardNumberFull").attr("aria-label","Credit Card Number");
	   			$("#cardNumberFull").attr("aria-describedby","creditCardTypes");
	   			$("#cardNumberFull").bind("keyup",function(){
	   				var val = $(this).val();
	   				val = val.replace(/\-/g, "");
	   			$("#cardNumber").val(val);
	   			});
   			//aria end
   	
</script>