<%@page import="com.amfam.billing.reuse.util.Dates" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<%@ taglib uri="com.amfam.billing.paynow.taglib.paynow-taglib" prefix="pn"%>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="/WEB-INF/tld/sbi-taglib.tld" prefix="sbi" %>


<%
 String basedomain = (String)getServletContext().getAttribute("MARKETING_TIER_BASELINK");
%>

<tiles:importAttribute/>

<% // Adobe DTM changes %>
<script language="JavaScript" type="text/javascript">
/* Start: Adobe DTM changes,source script is included in base.jsp/dailogLayout.jsp common file*/
 if(!window.digitalData){
			var digitalData = {};
			digitalData={
				
				event:[{
							eventInfo:
							{
								eventName:{}
							}
						}],
				page:{
					pageInfo:{
					pageName:"PayNow:EnterPayment",
					experience: "",
					},
					category:{primaryCategory:"Payments",
							  subCategory1:"Pay Now",
 							  subCategory2:"n/a",
 							  subCategory3:"n/a"},
		
					attributes:{language:"english"}				
				}
				
			};
		}
	/*End: Adobe DTM changes*/
</script>

<script type="text/javascript">

var otherAmountSelected = false;

$(document).ready(function() {

   //remove enter keypress while on text boxes 
   var $inputs = $('#payNowForm :input[type=text],:input[type=radio]');    
   $inputs.each(function() {                          
                $(this).keypress(function(e){
                var code = (e.keyCode ? e.keyCode : e.which);  
                                if(code == 13) { 
                                                return false;                       
                                }
                });
            });        
                
                //ccformatting on input box   			    
  	$("#creditCardNumber").inputmask({"ccimagedisplayid" : "payment-methods"});
   	$("#creditCardNumber").val("");
   	$("#cardNumber").val("");
	   			
	$("#creditCardNumber").bind("keyup",function(){
	   		var val = $(this).val();
	   		val = val.replace(/\-/g, "");
	   	$("#cardNumber").val(val);
	  });       
});


function removeBillNumfn(billnum,amtType){
   document.getElementById('removeBillNumId').value = billnum; 
   document.getElementById('removeAmtType').value = amtType;
}

function doSubmit(id, newValue, form)
{
	if(id == 'target'){
		document.getElementById(form).target.value=newValue;
	} else if (id == 'method'){
		document.getElementById(form).method.value=newValue;
	} else {
		document.getElementById(id).value=newValue;
	}
	document.getElementById(form).submit();
}


function clickPrevious()
{
	document.forms[0].doAction('toEditPayment', 'processPayment.do');
	document.forms[0].submit();
}


function show_hide(id, show)
{
	if (navigator.appName.indexOf("Microsoft") > -1) {
		var canSee = 'block';
	} else {
		var canSee = 'table-row-group';
	}
	if (show) {
		document.getElementById(id).style.display = canSee;
	} else {
		document.getElementById(id).style.display = "none";
	}
}


/*Set focus and empty the respective textBox on select of OtherAmount Radio button and call timeoutFunction*/


function enableOtherAmt(ind){
	otherAmountSelected = true;
	if($('#accountInfoMobile').css('display') == 'block' ){
		document.getElementById('mobile_other_'+ ind).checked=true;
		var otamt= document.getElementById('mobile_otherAmount_'+ ind );
	}
	else{
		document.getElementById('other_'+ ind).checked=true;
		var otamt= document.getElementById('otherAmount_'+ ind );
	}
	
	otamt.value='';
	
	window.setTimeout(function(){
		$(otamt).closest('label').removeClass('ui-radio-off').addClass('ui-radio-on checked');
		otamt.focus();
	}, 100);
	
}

function showMobile(id){
	document.getElementById(id).style.visibility="visible";
   	document.getElementById(id).style.display='block';
   	
}
function hideMobile(id){
	document.getElementById(id).style.visibility="hidden";
    document.getElementById(id).style.display='none';
}

function clearOtherAmt(ind){
	otherAmountSelected = false;
	if($('#accountInfoMobile').css('display') == 'block' ){
		var otAmt = document.getElementById('mobile_otherAmount_'+ ind ) ;
		var otAmtId = 'mobile_otherAmount_'+ ind;
	}
	else{
		var otAmt = document.getElementById('otherAmount_'+ ind ) ;
		var otAmtId = 'otherAmount_'+ ind;
	}
		
	if(typeof(otAmt) !== 'undefined' && !(otAmt.value == otAmt.title) ) {	
		document.getElementById(otAmtId).value='';
	}
}


function showInnerShell()
{	
	document.getElementById("innerShell").style['display']='';
	
	var BilNumTextField = document.forms[0].addBillNumId;
	
	if (typeof(BilNumTextField) !== 'undefined'){
	
		BilNumTextField.value='';
		BilNumTextField.focus();
	}
	
	//	resetTabOrder();
	

}

function hideInnerShell(){	
	document.getElementById("innerShell").style['display']='none';
}

var globalPMdetailCount= 0;




function refreshTotal(){

     var sumtot = 0.00;
     var typeStr ="";
    document.getElementById('grandtotal').value="00.00";
    
    for (ind = 0; ind <= globalPMdetailCount; ind++) { 
  
	var amount=0.00; 
	var type="";
	
	var DetailamtRadioObjArray 	= document.getElementsByName('amount_'+ ind);	
		
	var radioLength 		= DetailamtRadioObjArray.length;	


		for (var i = 0; i < radioLength; i++) {
			
			if (DetailamtRadioObjArray[i].checked) {				
				
				
				if ((DetailamtRadioObjArray[i].id == 'tot_'+ ind) || (DetailamtRadioObjArray[i].id == 'mobile_tot_'+ ind)){
				
				 	amount=stripDollar(document.getElementById('input_tot_'+ind).value);
				 	if( (amount.indexOf("-") != -1 ) || (amount == "0.00" )) {
				 		DetailamtRadioObjArray[i].checked = false; 
				 		DetailamtRadioObjArray[i].disabled =true; 
				 		amount ="0.00" ; 
				 	} 
				 	type=document.getElementById('billnum_'+ind).value+','+ind+','+amount+','+'T'+':';				 	
				 	
				}
				
				if ((DetailamtRadioObjArray[i].id == 'full_'+ ind) || (DetailamtRadioObjArray[i].id == 'mobile_full_'+ ind)){
				
				 	amount=stripDollar(document.getElementById('input_full_'+ind).value);
				 	if( (amount.indexOf("-") != -1 ) || (amount == "0.00" )) {
				 		DetailamtRadioObjArray[i].checked = false; 
				 		DetailamtRadioObjArray[i].disabled =true; 
				 		amount ="0.00" ; 
				 	} 
				 	type=document.getElementById('billnum_'+ind).value+','+ind+','+amount+','+'F'+':';				 	
				 	
				}
				
				if ((DetailamtRadioObjArray[i].id == 'min_'+ ind) || (DetailamtRadioObjArray[i].id == 'mobile_min_'+ ind)){
				
					amount=stripDollar(document.getElementById('input_min_'+ind).value);
					if( (amount.indexOf("-") != -1 ) || (amount == "0.00" )) {
						DetailamtRadioObjArray[i].checked = false; 
						DetailamtRadioObjArray[i].disabled =true; 
						amount ="0.00";
					}
					
										 
					if(document.getElementById('loanIndicator_'+ind).value == 'true'){
						type=document.getElementById('billnum_'+ind).value+','+ind+','+amount+','+'LI'+':';
					}else {
						type=document.getElementById('billnum_'+ind).value+','+ind+','+amount+','+'M'+':';
					}
				 	
				}
				
				if ((DetailamtRadioObjArray[i].id == 'other_'+ ind) || (DetailamtRadioObjArray[i].id == 'mobile_other_'+ ind)){
					otherAmountResult = getOtherAmount();
					amount = otherAmountResult[0];
					type = otherAmountResult[1];
				}	
				
				
				sumtot = sumtot	+ parseFloat(amount);
				typeStr= typeStr + type;
				
				break;
			}
			else if(otherAmountSelected){
				otherAmountResult = getOtherAmount();
				amount = otherAmountResult[0];
				type = otherAmountResult[1];
				
				sumtot = sumtot	+ parseFloat(amount);
				/* Not to break the iteration logic when the radiobutton is not selected for specific account
				 and add the ":" mulitple time during returned from the getOtherAmount fn. */
				if( type != ":" ){
				typeStr= typeStr + type;
				break;
				}
				
			}
			/* Add ":" to separate the different account details incase 
			the radio button is not selected for the added account. */
			if( i == (radioLength-1) ){
				typeStr= typeStr + ':'; 
			}
	        }
	}
	

	
	document.getElementById('formgrandtotal').value=sumtot.toFixed(2);
	document.getElementById('formamounttypestr').value=typeStr;	
    document.getElementById('grandtotal').childNodes[0].nodeValue = '$'+formatCurrency(sumtot.toFixed(2));
    
}

function getOtherAmount(){
var amount=0, type=':';
					var otheramtId = ($('#accountInfoMobile').css('display') == 'block' ) ? 'mobile_otherAmount_'+ ind : 'otherAmount_'+ ind
				    var otheramt = stripDollar(document.getElementById(otheramtId).value);
				    
					if(otheramt.length > 0 && (otheramt.indexOf('Amount') < 0)) {
					 document.getElementById(otheramtId).value = (parseFloat(otheramt).toFixed(2)); 
					 if(isNaN(document.getElementById(otheramtId).value)) document.getElementById(otheramtId).value = "0.00";
					 amount=stripDollar(document.getElementById(otheramtId).value);
					 
					 if(document.getElementById(otheramtId).value != "0.00"){
					 document.getElementById(otheramtId).value = formatCurrency(document.getElementById(otheramtId).value); 
					 }
					 
					 if(document.getElementById('loanIndicator_'+ind).value == 'true'){
					 	type=document.getElementById('billnum_'+ind).value+','+ind+','+amount+','+'LO'+':';
					 } else{
					 	type=document.getElementById('billnum_'+ind).value+','+ind+','+amount+','+'O'+':';
					 }	
					} else {
						if($('#accountInfoMobile').css('display') == 'block' ){
							if(document.getElementById('mobile_other_'+ ind ).checked){
							  return setTypeAsZero();	
							}
						}else if(document.getElementById('other_'+ ind ).checked){
							  return setTypeAsZero();
						}
					}
					return [amount, type];
}

/* Radio button of otherAmount is selected and haven't entered the amount value then we are setting the amount value as "0"  */
function setTypeAsZero(){
	var setAmountZero = "0";
	
		if(document.getElementById('loanIndicator_'+ind).value == 'true'){
			type=document.getElementById('billnum_'+ind).value+','+ind+','+setAmountZero+','+'LO'+':';
		} else{
			type=document.getElementById('billnum_'+ind).value+','+ind+','+setAmountZero+','+'O'+':';
		}
		return [setAmountZero, type];
}

function stripDollar(amt){
	
	amt=amt.replace("Account Balance:","");
	amt=amt.replace("Full Pay Balance:","");
	amt=amt.replace("Minimum Due:","");
	amt=amt.replace("$", "");
	amt=amt.replace(" ","") ;
	amt=amt.replace("(","");
	amt=amt.replace(")","");
	amt=amt.replace(",","");
   return amt;
}


function initAmtTypRadioOnLoad(){
	
	var typestring = document.getElementById('formamounttypestr').value;
	
	
	var radioRowArr = typestring.split(':');
	
	var len = radioRowArr.length;
	
	 var ind = 0;
	
	for (i=0;i < len ; i++){
				
		var x = radioRowArr[i]
		
		if(typeof(x) !== 'undefined' && x != '') {

		  var subArr = x.split(',');
		  
		  if (typeof(subArr) !== 'undefined' ){
		  
		    var ind = getIndex(subArr[0],subArr[3]);
			
		    if ( ind != -1 ) {
		    
		    	id_prepend = '';
	    	
		    	if($('#accountInfoMobile').css('display') == 'block' )
		    		id_prepend = 'mobile_';
				
			   if (subArr[3] == 'T' && typeof(document.getElementById(id_prepend+'tot_'+ ind)) !== 'undefined' ) {  
			   		document.getElementById(id_prepend+'tot_'+ ind).checked=true; 
			   }
			   
			   if (subArr[3] == 'F' && typeof(document.getElementById(id_prepend+'full_'+ ind)) !== 'undefined' ) {  
			   		document.getElementById(id_prepend+'full_'+ ind).checked=true; 
			   }
			   
			   if (subArr[3] == 'M' && typeof(document.getElementById(id_prepend+'min_'+ ind)) !== 'undefined' ) { 
			   		document.getElementById(id_prepend+'min_'+ ind).checked=true;   
			   }
			   
			    if (subArr[3] == 'O' && typeof(document.getElementById(id_prepend+'other_'+ ind)) !== 'undefined' ) { 
					document.getElementById(id_prepend+'other_'+ ind).checked=true; 
					if(subArr[2]!="0")
				 	document.getElementById(id_prepend+'otherAmount_'+ ind).value=subArr[2];
			   }
		  			
		  		if (subArr[3] == 'LO' && typeof(document.getElementById(id_prepend+'other_'+ ind)) !== 'undefined' ) { 
					document.getElementById(id_prepend+'other_'+ ind).checked=true; 
					if(subArr[2]!="0")
				 	document.getElementById(id_prepend+'otherAmount_'+ ind).value=subArr[2];
			   }
			   
			     if (subArr[3] == 'LI' && typeof(document.getElementById(id_prepend+'min_'+ ind)) !== 'undefined' ) { 
			   		document.getElementById(id_prepend+'min_'+ ind).checked=true;   
			   }
				ind++;				   
		    }
		 }		
		} 
	}

}


function getIndex(billnum,amtType){

   for (ind = 0; ind <= globalPMdetailCount; ind++) {    
	if ( document.getElementById('billnum_'+ind).value == billnum ){
	/* Increment the ind if the amountType is loan and detail has loanInd as false,
	 to avoid selecting premium when the loan radio button was selected  */ 
		if( (document.getElementById('loanIndicator_'+ind).value =='false') && (amtType == 'LO' || amtType == 'LI') ){
		 return ++ind;
		} 
	   return ind;
	}
		
   }
   
   return -1 ;

}

history.navigationMode = 'compatible';
$(document).ready(function(){
	var paymentAmttype = document.getElementById('paymentAmountType').value;
	
	 if(paymentAmttype == 'CHECKSAVE'){
      	$('#creditCard').hide();
      	$('#checkingSavings').show();
      	$('.checkingSavings').show();
      	setTimeout( function() { resetTabOrder(); }, 300 );
		$('#paynowtoolbarId').find('a').attr('tabindex', '-1');
		setTimeout( function() {$( '#bankAccountType' ).focus() }, 350 );
     } else if (paymentAmttype =='DEBITCREDIT'){
     	$('#checkingSavings').hide();
        $('#creditCard').show();
        $('.creditCard').show();
        $('.disclaimer').hide();
        setTimeout( function() { resetTabOrder(); }, 300 ); 
	    $('#paynowtoolbarId').find('a').attr('tabindex', '-1');
	    setTimeout( function() { $( '#creditCardNumber' ).focus(); }, 350 );
     	} else if(paymentAmttype == ''){
     	$('.disclaimer').hide();
     	};	 
});

</script>



<bean:define id="action" name="action" type="java.lang.String" />
<bean:struts id="mapping" mapping="<%= action %>" />
<bean:define id="formName" name="mapping" property="name" type="java.lang.String"/>
<bean:define id="form" name="<%= formName %>" type="com.amfam.billing.actions.PaymentEntryForm" />

<bean:define id="payment" name="<%= formName %>" property="payment" 	type="com.amfam.billing.pymtmgr.entities.Payment"	toScope="request" />
	

<% // END HEADER %>

<% // BEGIN CONTENT %>

	<% // /Task Indicator %>
	
	 <ul id="progressBar" class="four">
	 	<li class="progressBar_present1">
	 	<span id="endCap_left_present"></span><span class="oneLine"><bean:message key="indicator.authenticate" /></span></li>
		<li class="progressBar_present"><span class="oneLine"><bean:message key="indicator.edit" /></span></li>
		<li class="progressBar_future"><span class="oneLine"><bean:message key="indicator.verify" /></span></li>
		<li class="progressBar_future"><span class="oneLine"><bean:message key="indicator.confirm" /></span></li>
	</ul>
	 
	<jsp:include page="/WEB-INF/view/shared/errors.jsp" />
	
	
<!-- ########################################################################################################################### -->
	
	 <ul id="accountInfo">
			
			<li class="row">
			    <ul class="fourColumns header">
				<li class="one"><h3><bean:message key="label.columnDueDate"/></h3></li>
				<li class="two"><h3><bean:message key="label.columnPolicyHolder"/></h3></li>
				<li class="three"><h3><bean:message key="label.columnBillingNumber"/></h3></li>
				<li class="four"><h3><bean:message key="label.columnPaymentAmount"/></h3>
				<div id = "enterpagepayemnt"><a class="help"><bean:message key="text.helpPaymentAmount"/></a></div></li>
				<div class='help_content5'>
					<h4>Which amount should I pay?</h4>
					<p>The payment amounts offered to you depend on the type of bill you are paying. You will likely not be offered all of the amounts in the following list.</p>
					<p>Account Balance - Select this amount to pay the account balance in full.</p>
					<p>Full Pay Balance - Select this amount to pay the full balance.</p>
					<p>Loan Interest Due - Select this amount to pay the loan interest due.</p>
					<p>Minimum Due - Select this amount to pay the minimum amount due to keep this account current.</p>
					<p>Other Amount - Select to pay another amount.</p>
					<p>Other Loan Amount - Select to pay a loan amount other than the loan interest due.</p>
					<p>Other Premium Amount - Select to pay a premium amount other than the premium amount due. </p>
					<p>Payment Amount - Select this amount to pay the payment amount on your contribution statement.</p>
					<p> Premium Amount Due - Select this amount to pay the premium amount due to keep this policy current.</p>
				</div>
				<script>
				$(document).ready(function(){
				  	$('#enterpagepayemnt').click(function(e){
				  	 $(".help_content5").slideToggle();
					});
				});
				$(document).ready(function(){
						$('#enterpage').click(function(e){
						 $(".help_content4").slideToggle();
						});
					});
				</script>
					</ul>							
				</li>
	                 <html:hidden  name="form"  property="removeBillNum" styleId="removeBillNumId"/>            
	                  <html:hidden  name="form"  property="removeAmtType" styleId="removeAmtType"/>
	                 <script type="text/javascript">globalPMdetailCount = 0;</script>
	                 <%! int index;  %>
	              <logic:iterate id="detail" name="payment" property="paymentDetailIterator" type="com.amfam.billing.pymtmgr.entities.PaymentDetail" indexId="indexNo">
				<c:if test='<%= (indexNo == 0) %>'> <%index=0;%></c:if>
				<c:if test="<%=!(detail.isDeleted())%>">
		        <script type="text/javascript">globalPMdetailCount = <%=index%>;</script>
				<input type="hidden" value="<bean:write name="detail" property="billingNumber.formatted"/>"	id="billnum_<%=index%>"/>
				<input type="hidden" id="loanIndicator_<%=index%>"  value="<%= detail.isLoanIndicator() %>" />
					<li class="row" id="accountInfoDesktop">
					    <ul class="fourColumns" id="fourColumns_<%=index%>">
						
						<li class="one"><pn:DateDisplay date="<%= detail.getBillingSummary().getDueDate()%>"/> </li>

						<li class="two"><%= detail.getBillAccount().getAccountHolder().getFormattedBillingNameAndAddress().getName() %></li>
						
						<li class="three"><bean:write name="detail" property="billingNumber.formatted"/>
						<logic:equal name="detail" property="billingNumber.billingSystemCode.code" value="L">
						<logic:equal name="detail" property="loanIndicator" value="true">
						<br><bean:message key="label.LoanInterest"/>
						</logic:equal>
						<logic:equal name="detail" property="loanIndicator" value="false">
						<br><bean:message key="label.Premium"/>
						</logic:equal>
						</logic:equal></li>
			 <logic:messagesNotPresent property='<%="amount_"+index %>'>
	                  <li class="four">
	         </logic:messagesNotPresent>
	         <logic:messagesPresent property='<%="amount_"+index %>'>
	                  <li class="four error">
	         </logic:messagesPresent>
	         <logic:notEqual name="detail" property="billingNumber.billingSystemCode.code" value="L">
	         <ul id= "radiobuttons" style="margin-left: -13px;">
						    <li class="formRadio">
							    <span class="radioSkin">
								<input type="radio" id="min_<%=index%>" name="amount_<%=index%>" class="radioButton"   onclick="clearOtherAmt(<%=index%>);refreshTotal();"/>
							    <label class="radioLabel" for="min_<%=index%>"> Minimum Due: <fmt:formatNumber value="<%= detail.getBillingSummary().getMinimumDue().toString()%>" type="currency" pattern="$#,##0.00;-$#,##0.00"/></label> 
							    </span>
				     			    <input type="hidden" id="input_min_<%=index%>" value="<fmt:formatNumber value="<%= detail.getBillingSummary().getMinimumDue().toString()%>" type="currency" pattern="$#,##0.00;-$#,##0.00"/>" />
							</li>
   						<c:if test="<%=(detail.getBillingSummary().isEligibleForFullPayDiscount())%>">
						    <li class="formRadio">
							    <span class="radioSkin">						                                                    	
								<input type="radio" id="full_<%=index%>" name="amount_<%=index%>" class="radioButton"  onclick="clearOtherAmt(<%=index%>);refreshTotal();"/>
							    <label class="radioLabel" for="full_<%=index%>"> Full Pay Balance: <fmt:formatNumber value="<%= detail.getBillingSummary().getFullPayDiscountAmount().toString()%>" type="currency" pattern="$#,##0.00;-$#,##0.00"/></label>
							   	</span>
							   <input type="hidden" id="input_full_<%=index%>" value="<fmt:formatNumber value="<%= detail.getBillingSummary().getFullPayDiscountAmount().toString()%>" type="currency" pattern="$#,##0.00;-$#,##0.00"/>" />

							</li>	
						</c:if>
						
						<c:if test="<%=!(detail.getBillingSummary().isEligibleForFullPayDiscount())%>">
											    						    
							<li class="formRadio">
							    <span class="radioSkin">						                                                    	
								<input type="radio" id="tot_<%=index%>" name="amount_<%=index%>" class="radioButton"  onclick="clearOtherAmt(<%=index%>);refreshTotal();"/>
							   <label class="radioLabel" for="tot_<%=index%>"> Account Balance: <fmt:formatNumber value="<%= detail.getBillingSummary().getTotalDue().toString()%>" type="currency" pattern="$#,##0.00;-$#,##0.00"/></label>
							    </span>
							   <input type="hidden" id="input_tot_<%=index%>" value="<fmt:formatNumber value="<%= detail.getBillingSummary().getTotalDue().toString()%>" type="currency" pattern="$#,##0.00;-$#,##0.00"/>" />

							</li>
						</c:if>
						<li class="formRadio">
							    <span class="radioSkin">
								<input type="radio" name="amount_<%=index%>" class="radioButton" id="other_<%=index%>" onclick="enableOtherAmt(<%=index%>);refreshTotal();"/>
								<label for="other_<%=index%>" class="radioLabel">
									<span class="floatLeft">Other Amount:</span>
								 <div class = "otheramountclass">
							    	<span class="floatLeft">$</span>
									<input type="text" class="textField example" name="otherAmount_<%=index%>" id="otherAmount_<%=index%>" onkeypress="document.getElementById('other_<%=index%>').checked=true;" 
									onclick="enableOtherAmt(<%=index%>);refreshTotal();" onblur="refreshTotal();" value=""  />
							    </div></label>
							    </span>
							</li>
							</ul>
			<c:if test="<%= (form.getModifiablePaymentDetailCount() > 1)%>">	
					<li>						
				  <a id="action.label.button.remove" class="button cancelBtn" href="#" onclick="removeBillNumfn('<bean:write name="detail" property="billingNumber.formatted"/>','nonLife'); doSubmit('method', 'removePaymentDetail', 'payNowForm'); return false;">
           			<span>Remove</span>
            	  </a>							  
				</li>
				</c:if>
	</logic:notEqual>
		<logic:equal name="detail" property="billingNumber.billingSystemCode.code" value="L">
		<logic:equal name="detail" property="loanIndicator" value="false">
		 	 <ul id= "radiobuttons" style="margin-left: -13px;">
		 	 <!--
		 	 		Life annuity policy start with 9, if the policy starts with 9 then not display below tag content
		 	 		-->
		 	 		<c:if test='<%= !(detail.getBillingNumber().toString().subSequence(0,1).equals("9"))%>'>
		 	 		<li class="formRadio">
							    <span class="radioSkin">
								<input type="radio"  id="min_<%=index%>" name="amount_<%=index%>" class="radioButton"   onclick="clearOtherAmt(<%=index%>);refreshTotal();"/>
							    <label class="radioLabel" for="min_<%=index%>"> Premium Amount Due: <fmt:formatNumber value="<%= detail.getBillingSummary().getMinimumDue().toString()%>" type="currency" pattern="$#,##0.00;-$#,##0.00"/></label> 
							    </span>
				     			    <input type="hidden" id="input_min_<%=index%>" value="<fmt:formatNumber value="<%= detail.getBillingSummary().getMinimumDue().toString()%>" type="currency" pattern="$#,##0.00;-$#,##0.00"/>" />
					</li>
					<logic:messagesNotPresent property='<%="otherAmount_"+index %>'>
                                 		<ul class="labelSet">
                                 	</logic:messagesNotPresent>
                                 	
                                 	<logic:messagesPresent property='<%="otherAmount_"+index %>'>
                                 		<ul class="labelSet error">
                                 	</logic:messagesPresent>
					<li class="formRadio">
							    <span class="radioSkin">
								<input type="radio" name="amount_<%=index%>" class="radioButton" id="other_<%=index%>" onclick="enableOtherAmt(<%=index%>);refreshTotal();"/>
								<label for="other_<%=index%>" class="radioLabel">
									<span class="floatLeft">Other Premium Amount: </span>
								 <div class = "otheramountclass">
							    	<span class="floatLeft">$</span>
									<input type="text"  class="textField example" name="otherAmount_<%=index%>" id="otherAmount_<%=index%>"  onkeypress="document.getElementById('other_<%=index%>').checked=true;"
									onclick="enableOtherAmt(<%=index%>);refreshTotal();" onblur="refreshTotal();" value=""  />
							    </div></label>
							    </span>
						</li>
					</c:if>
					<c:if test='<%= (detail.getBillingNumber().toString().subSequence(0,1).equals("9"))%>'>	
					<li class="formRadio">
							    <span class="radioSkin">
								<input type="radio"  id="min_<%=index%>" name="amount_<%=index%>" class="radioButton"   onclick="clearOtherAmt(<%=index%>);refreshTotal();"/>
							    <label class="radioLabel" for="min_<%=index%>">Payment Amount: <fmt:formatNumber value="<%= detail.getBillingSummary().getMinimumDue().toString()%>" type="currency" pattern="$#,##0.00;-$#,##0.00"/></label> 
							    </span>
				     			    <input type="hidden" id="input_min_<%=index%>" value="<fmt:formatNumber value="<%= detail.getBillingSummary().getMinimumDue().toString()%>" type="currency" pattern="$#,##0.00;-$#,##0.00"/>" />
					</li>
									<logic:messagesNotPresent property='<%="otherAmount_"+index %>'>
                                 		<ul class="labelSet">
                                 	</logic:messagesNotPresent>
                                 	
                                 	<logic:messagesPresent property='<%="otherAmount_"+index %>'>
                                 		<ul class="labelSet error">
                                 	</logic:messagesPresent>
					<li class="formRadio">
							    <span class="radioSkin">
								<input type="radio" name="amount_<%=index%>" class="radioButton" id="other_<%=index%>" onclick="enableOtherAmt(<%=index%>);refreshTotal();"/>
								<label for="other_<%=index%>" class="radioLabel">
									<span class="floatLeft">Other Amount:</span>
								 <div class = "otheramountclass">
							    	<span class="floatLeft">$</span>
									<input type="text"  class="textField example" name="otherAmount_<%=index%>" id="otherAmount_<%=index%>"  onkeypress="document.getElementById('other_<%=index%>').checked=true;"
									onclick="enableOtherAmt(<%=index%>);refreshTotal();" onblur="refreshTotal();" value=""  />
							    </div></label>
							    </span>
						</li>
					</c:if>
						</ul>
					</ul>
				<c:if test="<%= (form.getModifiablePaymentDetailCount() > 1)%>" >	
					<li>						
				  	<a id="action.label.button.remove" class="button cancelBtn" href="#" onclick="removeBillNumfn('<bean:write name="detail" property="billingNumber.formatted"/>','premium'); doSubmit('method', 'removePaymentDetail', 'payNowForm'); return false;">
           				<span>Remove</span>
            	  	</a>							  
					</li>
				</c:if>
	</logic:equal>
	<logic:equal name="detail" property="loanIndicator" value="true">
		<ul id= "radiobuttons" style="margin-left: -13px;">
			 			<li class="formRadio">
							<span class="radioSkin">
							<input type="radio" id="min_<%=index%>" name="amount_<%=index%>" class="radioButton"   onclick="clearOtherAmt(<%=index%>);refreshTotal();"/>
							<label class="radioLabel" for="min_<%=index%>">Loan Interest Due: <fmt:formatNumber value="<%= detail.getBillingSummary().getLoanInterestDue().toString()%>" type="currency" pattern="$#,##0.00;-$#,##0.00"/></label> 
							</span>
				     			<input type="hidden" id="input_min_<%=index%>" value="<fmt:formatNumber value="<%= detail.getBillingSummary().getLoanInterestDue().toString()%>" type="currency" pattern="$#,##0.00;-$#,##0.00"/>" />
						</li>
						<logic:messagesNotPresent property='<%="otherAmount_"+index %>'>
                                 		<ul class="labelSet">
                                 	</logic:messagesNotPresent>
                                 	
                                 	<logic:messagesPresent property='<%="otherAmount_"+index %>'>
                                 		<ul class="labelSet error">
                                 	</logic:messagesPresent>
						<li class="formRadio">
							    <span class="radioSkin">
								<input type="radio" name="amount_<%=index%>" class="radioButton" id="other_<%=index%>" onclick="enableOtherAmt(<%=index%>);refreshTotal();"/>
								<label for="other_<%=index%>" class="radioLabel">
									<span class="floatLeft">Other Loan Amount:</span>
								 <div class = "otheramountclass">
							    	<span class="floatLeft">$</span>
									<input type="text" class="textField example" name="otherAmount_<%=index%>" id="otherAmount_<%=index%>" onkeypress="document.getElementById('other_<%=index%>').checked=true;"
									onclick="enableOtherAmt(<%=index%>);refreshTotal();" onblur="refreshTotal();" value=""  />
							    </div></label>
							    </span>
						</li>
						</ul>
					</ul>
					<c:if test="<%= (form.getModifiablePaymentDetailCount() > 1) %>">	
						<li>
							<a id="action.label.button.removeLoan_<%=index%>" class="button cancelBtn" href="#" onclick= "removeBillNumfn('<bean:write name="detail" property="billingNumber.formatted"/>','loan');doSubmit('method', 'removePaymentDetail', 'payNowForm')">
		           			<span>Remove</span>
		            		</a>
		            	</li>
		            </c:if>
	</logic:equal>
		</logic:equal>
	</li>
</ul>
			    <!-- #################################### *LifePolicy - LoanAmount* #################################### -->
<li class="row" id="accountInfoMobile">
					    <ul class="fourColumns">
					    <li class="one"><bean:message key="label.dueDate"/></li>
						<li class="two"><pn:DateDisplay date="<%= detail.getBillingSummary().getDueDate()%>"/> </li>
						<li class="one"><bean:message key="label.policyHolder"/></li>
						<li class="two"><%= detail.getBillAccount().getAccountHolder().getFormattedBillingNameAndAddress().getName() %></li>
						<li class="one"><bean:message key="label.columnBillingNumber"/>:</li>
						<li class="two"><bean:write name="detail" property="billingNumber.formatted"/></li>
						<li class="one"><bean:message key="label.paymentAmount"/></li>
	<logic:notEqual name="detail" property="billingNumber.billingSystemCode.code" value="L">
				<logic:messagesNotPresent property='<%="amount_"+index %>'>
	                                  		<li class="two">
	                                  	</logic:messagesNotPresent>
	                                  	<logic:messagesPresent property='<%="amount_"+index %>'>
	                                  		<li class="two error">
	                                  	</logic:messagesPresent> 				              
	                       <ul>
						    <li class="formRadio">
							    <span class="radioSkin">
								<input type="radio" id="mobile_min_<%=index%>" name="amount_<%=index%>" class="radioButton"   onclick="clearOtherAmt(<%=index%>);refreshTotal();hideMobile('mobileOtherAmtClass_<%=index%>');"/>
							    <label class="radioLabel" for="mobile_min_<%=index%>"><bean:message key="text.minimumDue" /><fmt:formatNumber value="<%= detail.getBillingSummary().getMinimumDue().toString()%>" type="currency" pattern="$#,##0.00;-$#,##0.00"/></label> 
							    </span>
							    <input type="hidden" id="input_min_<%=index%>" value="<fmt:formatNumber value="<%= detail.getBillingSummary().getMinimumDue().toString()%>" type="currency" pattern="$#,##0.00;-$#,##0.00"/>" />
							</li>
   						<c:if test="<%=(detail.getBillingSummary().isEligibleForFullPayDiscount())%>">
						    <li class="formRadio">
							    <span class="radioSkin">						                                                    	
								<input type="radio" id="mobile_full_<%=index%>" name="amount_<%=index%>" class="radioButton"  onclick="clearOtherAmt(<%=index%>);refreshTotal();hideMobile('mobileOtherAmtClass_<%=index%>');"/>
							    <label for="mobile_full_<%=index%>" class="radioLabel"><bean:message key="text.fullPayBalance" /><fmt:formatNumber value="<%= detail.getBillingSummary().getFullPayDiscountAmount().toString()%>" type="currency" pattern="$#,##0.00;-$#,##0.00"/></label>
							   	</span>
							   <input type="hidden" id="input_full_<%=index%>" value="<fmt:formatNumber value="<%= detail.getBillingSummary().getFullPayDiscountAmount().toString()%>" type="currency" pattern="$#,##0.00;-$#,##0.00"/>" />
							</li>	
						</c:if>
						
						<c:if test="<%=!(detail.getBillingSummary().isEligibleForFullPayDiscount())%>">
											    						    
							<li class="formRadio">
							    <span class="radioSkin">						                                                    	
								<input type="radio" id="mobile_tot_<%=index%>" name="amount_<%=index%>" class="radioButton"  onclick="clearOtherAmt(<%=index%>);refreshTotal();hideMobile('mobileOtherAmtClass_<%=index%>');"/>
							   <label class="radioLabel" for="mobile_tot_<%=index%>"><bean:message key="text.accountBalance" /><fmt:formatNumber value="<%= detail.getBillingSummary().getTotalDue().toString()%>" type="currency" pattern="$#,##0.00;-$#,##0.00"/></label>
							    </span>
								<input type="hidden" id="input_tot_<%=index%>" value="<fmt:formatNumber value="<%= detail.getBillingSummary().getTotalDue().toString()%>" type="currency" pattern="$#,##0.00;-$#,##0.00"/>" />
							</li>
						</c:if>
							<li class="formRadio">
							    <span class="radioSkin">
								<input type="radio" name="amount_<%=index%>" class="radioButton" id="mobile_other_<%=index%>" onclick="enableOtherAmt(<%=index%>);refreshTotal();showMobile('mobileOtherAmtClass_<%=index%>');"/>
							    <label for="mobile_other_<%=index%>" class="radioLabel">
							    	<span class="floatLeft">Other Amount:</span></label>
							    <div class = "otheramountclass" id="mobileOtherAmtClass_<%=index%>">
									<span class="floatLeft">$</span>
									<input type="text" class="textField example" name="otherAmount_<%=index%>" id="mobile_otherAmount_<%=index%>" onkeypress="document.getElementById('mobile_other_<%=index%>').checked=true;" 
									 onclick="enableOtherAmt(<%=index%>);refreshTotal();" onblur="refreshTotal();" value="" placeholder="Other Amount" />
							    	</div>
							    </span>
							</li>
						    </ul>
						   </li> 
					</logic:notEqual>
			<logic:equal name="detail" property="billingNumber.billingSystemCode.code" value="L">
			 <logic:messagesNotPresent property='<%="amount_"+index %>'>
	                                  		<li class="two">
	                                  	</logic:messagesNotPresent>
	                                  	<logic:messagesPresent property='<%="amount_"+index %>'>
	                                  		<li class="two error">
	                                  	</logic:messagesPresent> 
			  <logic:equal name="detail" property="loanIndicator" value="false">
			 <ul>
			 <c:if test='<%= !(detail.getBillingNumber().toString().subSequence(0,1).equals("9"))%>'>
			 <li class="formRadio">
							    <span class="radioSkin">
								<input type="radio" id="mobile_min_<%=index%>" name="amount_<%=index%>" class="radioButton"   onclick="clearOtherAmt(<%=index%>);refreshTotal();hideMobile('mobileOtherAmtClass_<%=index%>');"/>
							    <label class="radioLabel" for="mobile_min_<%=index%>"> Premium Amount Due: <fmt:formatNumber value="<%= detail.getBillingSummary().getMinimumDue().toString()%>" type="currency" pattern="$#,##0.00;-$#,##0.00"/></label> 
							    </span>
							    <input type="hidden" id="input_min_<%=index%>" value="<fmt:formatNumber value="<%= detail.getBillingSummary().getMinimumDue().toString()%>" type="currency" pattern="$#,##0.00;-$#,##0.00"/>" />
							</li>
						<logic:messagesNotPresent property='<%="otherAmount_"+index %>'>
                               		<ul class="labelSet">
                               	</logic:messagesNotPresent>
                               	<logic:messagesPresent property='<%="otherAmount_"+index %>'>
                               		<ul class="labelSet error">
            </logic:messagesPresent>
			<li class="formRadio">
							    <span class="radioSkin">
								<input type="radio" name="amount_<%=index%>" class="radioButton" id="mobile_other_<%=index%>" onclick="enableOtherAmt(<%=index%>);refreshTotal();showMobile('mobileOtherAmtClass_<%=index%>');"/>
								<label for="mobile_other_<%=index%>" class="radioLabel">
							    	<span class="floatLeft">Other Premium Amount:</span></label>
										    <div class = "otheramountclass" id="mobileOtherAmtClass_<%=index%>">
												<span class="floatLeft">$</span>
												<input type="text" class="textField example" name="otherAmount_<%=index%>" id="mobile_otherAmount_<%=index%>"  onkeypress="document.getElementById('mobile_other_<%=index%>').checked=true;"
												onclick="enableOtherAmt(<%=index%>);refreshTotal();" onblur="refreshTotal();" value="" placeholder="Other Amount" />
										    	</div>
							    	</span>
							</li>
							</ul>
					</c:if>
					<c:if test='<%= (detail.getBillingNumber().toString().subSequence(0,1).equals("9"))%>'>
					 <li class="formRadio">
							    <span class="radioSkin">
								<input type="radio" id="mobile_min_<%=index%>" name="amount_<%=index%>" class="radioButton"   onclick="clearOtherAmt(<%=index%>);refreshTotal();hideMobile('mobileOtherAmtClass_<%=index%>');"/>
							    <label class="radioLabel" for="mobile_min_<%=index%>"> Payment Amount: <fmt:formatNumber value="<%= detail.getBillingSummary().getMinimumDue().toString()%>" type="currency" pattern="$#,##0.00;-$#,##0.00"/></label> 
							    </span>
							    <input type="hidden" id="input_min_<%=index%>" value="<fmt:formatNumber value="<%= detail.getBillingSummary().getMinimumDue().toString()%>" type="currency" pattern="$#,##0.00;-$#,##0.00"/>" />
						</li>
						<logic:messagesNotPresent property='<%="otherAmount_"+index %>'>
                               		<ul class="labelSet">
                               	</logic:messagesNotPresent>
                               	<logic:messagesPresent property='<%="otherAmount_"+index %>'>
                               		<ul class="labelSet error">
            </logic:messagesPresent>
			<li class="formRadio">
							    <span class="radioSkin">
								<input type="radio" name="amount_<%=index%>" class="radioButton" id="mobile_other_<%=index%>" onclick="enableOtherAmt(<%=index%>);refreshTotal();showMobile('mobileOtherAmtClass_<%=index%>');"/>
							    <label for="mobile_other_<%=index%>" class="radioLabel">
							    	<span class="floatLeft">Other Amount: </span></label>
							    <div class = "otheramountclass" id="mobileOtherAmtClass_<%=index%>">
									<span class="floatLeft">$</span>
									<input type="text" class="textField example" name="otherAmount_<%=index%>" id="mobile_otherAmount_<%=index%>"  onkeypress="document.getElementById('mobile_other_<%=index%>').checked=true;"
									onclick="enableOtherAmt(<%=index%>);refreshTotal();" onblur="refreshTotal();" value="" placeholder="Other Amount" />
							    	</div>
							    </span>
							</li>
							</ul>
					</c:if>
			</ul></logic:equal> 
			 <logic:equal name="detail" property="loanIndicator" value="true">
			 <ul>
				<li class="formRadio">
							    <span class="radioSkin">
								<input type="radio" id="mobile_min_<%=index%>" name="amount_<%=index%>" class="radioButton"   onclick="clearOtherAmt(<%=index%>);refreshTotal();hideMobile('mobileOtherAmtClass_<%=index%>');"/>
							    <label class="radioLabel" for="mobile_min_<%=index%>"> Loan Amount Due: <fmt:formatNumber value="<%= detail.getBillingSummary().getLoanInterestDue().toString()%>" type="currency" pattern="$#,##0.00;-$#,##0.00"/></label> 
							    </span>
							    <input type="hidden" id="input_min_<%=index%>" value="<fmt:formatNumber value="<%= detail.getBillingSummary().getLoanInterestDue().toString()%>" type="currency" pattern="$#,##0.00;-$#,##0.00"/>" />
							</li>
			<logic:messagesNotPresent property='<%="otherAmount_"+index %>'>
                             		<ul class="labelSet">
                             	</logic:messagesNotPresent>
                             	<logic:messagesPresent property='<%="otherAmount_"+index %>'>
                             		<ul class="labelSet error">
            </logic:messagesPresent>
						<li class="formRadio">
							    <span class="radioSkin">
								<input type="radio" name="amount_<%=index%>" class="radioButton" id="mobile_other_<%=index%>" onclick="enableOtherAmt(<%=index%>);refreshTotal();showMobile('mobileOtherAmtClass_<%=index%>');"/>
							    <label for="mobile_other_<%=index%>" class="radioLabel">
							    	<span class="floatLeft">Other Loan Amount:</span></label>
							    	<div class = "otheramountclass" id="mobileOtherAmtClass_<%=index%>">
									<span class="floatLeft">$</span>
									<input type="text" class="textField example" name="otherAmount_<%=index%>" id="mobile_otherAmount_<%=index%>" onkeypress="document.getElementById('mobile_other_<%=index%>').checked=true;"
									onclick="enableOtherAmt(<%=index%>);refreshTotal();" onblur="refreshTotal();" value="" placeholder="Other Amount" />
							    	</div>
							    </span>
							</li>
						</ul>
			</ul></logic:equal>
			</li>
			</logic:equal>
	</ul>
   </li>            
		<%index++;%>
	</c:if>	
</logic:iterate>

<!-- ########################################################################################################################### -->
	

    <%// inner shell on demand Dyna Section %>


                            <div class="innerShell payNowShell" id="innerShell" style='display: none;'>
                             	
                                <div class="innerShellBottom">
                                    <div class="innerShellTop" style="background-color: #E7E8E9;">
                                    	<h4> Make a Payment On Another Account </h4>
                                        Please enter the billing number that you would like to add to your payment.<br>
                                        <ul>                                           
                                        <logic:messagesNotPresent property="addBillNum">
	                                  		 <li class="row">
	                                  	</logic:messagesNotPresent>
	                                  	
	                                  	<logic:messagesPresent property="addBillNum">
	                                  		<script type="text/javascript">showInnerShell()</script>	
	                                  		 <li class="row error">
	                                  	</logic:messagesPresent>                                            
                                                <label><bean:message key="label.billingNumber"/></label>
                                                <input type="text" class="textField" name="addBillNum" id="addBillNumId" maxlength="14" title=""/>
                                                <div id ="enterpage"><p class="helpText rightText">
                                                <a class="help_question"><bean:message key="text.helpQuestion1"/></a>
                                                </p></div>
                    <div class='help_content4'>
											<h4>Where do you find this number?</h4>
											<p>You can find this number on your billing, contribution or annual statement.</p>
								<div id ="help_text_images" style="margin-bottom: 1.5em;"><img src="amfamCache/images/Bill.jpeg" style="width: 40%;"><img src="amfamCache/images/annual_statement.jpeg" style="width: 40%;padding-left: 0.5em;"></div>
					</div>
                                            </li>
                                            
                                            <li class="row buttonRow">
                                                <a class="cancelBtn button" href="javascript: hideInnerShell();"><bean:message key="label.button.cancel"/></a>&nbsp;
                                              <input type="submit" class="button paynowaction" data-role="none"
												value="Add" id="action.label.button.add"
												onClick="this.form.doAction( &#39;addPaymentDetail&#39;, &#39;processPayment.do?tid=ap92&#39; );return submitForm();"
														alt="Add Billing Account"></input>
                                            </li>
                                        </ul>
                                    </div> <!-- /#innerShellShellTop -->
                                </div> <!-- /#innerShellShellBottom -->
                            </div> <!-- /#innerShellShell -->
		<li class="row"> 
		    <ul class="threeColumns footer">
		    <li	class="three"><a href="javascript: showInnerShell();" class="button" style="width: 100%;">+ Pay Another</a></li>
		       <li class="one">Total Payment Amount:
		       		<!-- <a  href="#" id="TotalAmountHelp" class="help"><bean:message key="enterpayment.TotalAmountHelp"/></a>
					<a href="#" id="TotalAmountHelp" class="help" tabIndex="-1"><bean:message key="enterpayment.TotalAmountHelp"/></a> -->
		       </li>
		       <li class="one" ><div id="grandtotal">$0.00</div></li>
		       <html:hidden  name="form"  property="amount" styleId="formgrandtotal"/>
		       <html:hidden  name="form"  property="amounttypestr" styleId="formamounttypestr"/>	                                       
		    </ul>
		 </li>
		
<!-- ########################################################################################################################### -->

	    	    	          
	                             	<li class="row">
	                                  	<ul class="labelSet">
	                                          <li class="one"><b><bean:message key="label.paymentDate"/></b></li>
	                                          <li class="two"><%=new SimpleDateFormat("MM/dd/yyyy").format((java.util.Date)new Date())%></li>
	                                      </ul>
	                                  </li>
	                              	<li class="row">
	                              	  <input type="hidden" id="accountTypehiddenId" value=""/>						
	                                  	<logic:messagesNotPresent property="accountType">
	                                  		<ul class="labelSet">
	                                  	</logic:messagesNotPresent>
	                                  	
	                                  	<logic:messagesPresent property="accountType">
	                                  		<ul class="labelSet error">
	                                  	</logic:messagesPresent>
	                                  	
	                                    <li class="one payment-type"><b><bean:message key="text.paymentType"/></b></li>
	                                    <logic:equal name="form" property="hideCCForAnnuity" value="false">
											<li class="two"><html:select property="accountType" styleId="paymentAmountType">
											<html:option key="label.paymentType" value="" />
											<html:option key="text.checkingSavings" value="CHECKSAVE" />
											<html:option  key="text.debitCreditCard" value="DEBITCREDIT" />
											</html:select></li> 
										</logic:equal>
										
										<logic:equal name="form" property="hideCCForAnnuity" value="true">
											<li class="two">
											<bean:message key="text.checkingSavings"/>
											<html:hidden  name="form"  property="accountType" styleId="paymentAmountType" value="CHECKSAVE"/>
											</li> 
										</logic:equal>
											</ul></li>
										<script>
										$('#paymentAmountType').on('change',function(){
                                          if(this.value=='CHECKSAVE'){
                                          	$('#creditCard').hide();
                                          	$('#checkingSavings').show();
                                          	$('.checkingSavings').show();
                                          	$('.disclaimer').show();
                                          	setTimeout( function() { resetTabOrder(); }, 300 );
											$('#paynowtoolbarId').find('a').attr('tabindex', '-1');
											setTimeout( function() {$( '#bankAccountType' ).focus() }, 350 );
                                         } else if (this.value =='DEBITCREDIT'){
                                         	$('#checkingSavings').hide();
                                            $('#creditCard').show();
                                            $('.creditCard').show();
                                            $('.disclaimer').hide();
                                            setTimeout( function() { resetTabOrder(); }, 300 ); 
										    $('#paynowtoolbarId').find('a').attr('tabindex', '-1');
										    setTimeout( function() { $( '#creditCardNumber' ).focus(); }, 350 );
                                         	}
                                          else if(this.value == ''){
                                          	$('#creditCard').hide();
                                          	$('#checkingSavings').hide();
                                          	$('.disclaimer').hide();
                                          }
										});
										</script>
   
  

<!-- ########################################################################################################################### -->	    

  <% //Credit card payment %>	  
       
   <div  id="creditCard"  style='display:none;'>   
	    <li class="row">
	      	<logic:messagesNotPresent property="cardNumber">
	                                  		<ul class="labelSet">
	                                  	</logic:messagesNotPresent>
	                                  	
	                                  	<logic:messagesPresent property="cardNumber">
	                                  		<ul class="labelSet error">
	                                  		<!--<script type="text/javascript">clickCreditCrd(); </script>
	                                  	--></logic:messagesPresent>
	                       <li class="one"><label for="creditCardNumber"><b><bean:message key="label.cardNumber"/></b></label></li>
	                      <li class="two"><span class="textfield_creditCard">
	    				  <input type="text" class="textField" name="creditCardNumber" id="creditCardNumber" maxlength="23" property="cardNumberFormatted" styleId="cardNumberFormatted"/>
	    				  <label class="col-sm-4 col-md-5 hidden-xs control-label" for="payment-methods"></label>
	    				  <div id="payment-methods" 	class="col-sm-8 col-md-7">
							<span class="pn-credit-card-img mastercard"></span>
							<span class="pn-credit-card-img visa"></span>
							<span class="pn-credit-card-img discover"></span>
							<span class="pn-credit-card-img amex"></span>
							<span class="pn-credit-card-img unknown hidden">Unknown Credit	Card </span>
							</div>
							<html:hidden property="cardNumber" styleId="cardNumber"/>				
						</span></li>	
					</ul>
			</li>
			
		<li class="row">
                               	<logic:messagesNotPresent property="expDate">

	                                  		<ul class="labelSet">
	                                  	</logic:messagesNotPresent>
	                                  	<logic:messagesPresent property="cardNumber">
	                                  		<!--<script type="text/javascript">pickPaymentType('DEBITCREDIT')</script>
	                                  	--></logic:messagesPresent>
	                                  	<logic:messagesPresent property="expDate">
	                                  		<ul class="labelSet error">
	                                  		<!--<script type="text/javascript">clickCreditCrd(); </script>	                        
	                                  		<script type="text/javascript">pickPaymentType('DEBITCREDIT')</script>
	                                  	--></logic:messagesPresent>
	                                          <li class="one"><label for="expDateMM"><b><bean:message key="label.expDate"/></b></label></li>
	                                          <li class="two">
	                                                      <span class="textfield_bg IEFix">
	                                                          <span class="textfield_left">
	                                                              <span class="textfield_right">	                                                                  
	                                                                  <select name="expDateMM" 
	                                                              		class="month" id="expDateMM">
									                                        <option value=""></option>
																			<option value="01">01</option>
																			<option value="02">02</option>
																			<option value="03">03</option>
																			<option value="04">04</option>
																			<option value="05">05</option>
																			<option value="06">06</option>
																			<option value="07">07</option>
																			<option value="08">08</option>
																			<option value="09">09</option>
																			<option value="10">10</option>
																			<option value="11">11</option>
																			<option value="12">12</option>
									                                </select> 
	                                                              </span>
	                                                          </span>
	                                                      </span>
	                                                      <span class="textfield_bg IEFix">
	                                                          <span class="textfield_left">
	                                                              <span class="textfield_right">
	                                                                  <select name="expDateYYYY" class="year" id="expDateYYYY">
	                                                                  	<option checked></option>	                                              
	                                                                  </select> 
	                                                              </span>
	                                                          </span>
	                                                      </span>
	                                                      	<html:hidden property="expDateFull" styleId="expDateFull"/>
	                                          </li>
	                                      </ul>
	                                  </li>
								</div>    
		   
	<% //Credit card payment %>
	

<!-- ########################################################################################################################### -->	    

	    <% //Checking or Saving %>
	    	          <div  id="checkingSavings" class="bank-details"	style='display:none;'> 
	    	           <li class="row">
	    	           			<logic:messagesNotPresent property="bankAccountType">
	                                  		<ul class="labelSet">
	                                  	</logic:messagesNotPresent>
	                   	<logic:messagesPresent property="bankAccountType">
	                                  		<ul class="labelSet error">
	                    	       	</logic:messagesPresent>
	                    	       	<li class="one"><b><bean:message key="label.checkingSavingsType"/></b></li>
	                                <li class="two"><html:select property="bankAccountType" styleId="bankAccountType"  >
									 	<html:option key="text.select" value="" />
									 	<html:option key="text.checking" value="PERSCHEC" />
									 	<html:option key="text.savings" value="PERSSAVE" />
									 	<html:option key="text.businessChecking" value="BUSNCHEC" />
									 	<html:option key="text.businessSavings" value="BUSNSAVE" />
				       					 </html:select></li>
	                                     <li>
									</li>
								</ul>  
	    	           </li>
	    	           <li class="row">
	    	                         	<logic:messagesNotPresent property="routingNumber">
	                                  		<ul class="labelSet">
	                                  	</logic:messagesNotPresent>
	                                  	<logic:messagesPresent property="routingNumber">
	                                  		<ul class="labelSet error">
	                                  	</logic:messagesPresent>
	                                            <li class="one narrow"><label for="routingNumber"><b><bean:message key="label.bankRoutingNumber"/></b></label></li>
	                                            <li class="two narrow">
	                                            	<input type="text" class="textField BankNumberBox1" name="routingNumber" id="routingNumber" maxlength="9" title=""/>
	                                            </li><p class="routingnumberhelpText">
													<a name = "routingNum" class = "email_help_text" tabIndex="-1" ></a>
														<a tabIndex="-1" href="#routingNum">Where do you find this?</a>
												</p>
												<div id='help_contentrountingnumber' style="float:left;">
													<div class='content_float'>
																<h4>Where do you find this number?</h4>
																<p>Your bank account and routing numbers can be found at the bottom of your check. The 9-digit routing transit number appears on the bottom left of your check between the colon symbols. This number is used by the Federal Reserve Bank to route checks and deposits to the correct financial institution.</p>
																<p>The exact location of your checking account number and the number of digits can vary from each financial institution, but can usually be located to the right of your routing transit number.</p>
																<p>The sample check below shows where the numbers can be found.</p>
														<div id="help_text_images" style="margin-bottom: 2em;">
																	<img src="amfamCache/images/check1.gif" style="width: 45%;">
																	<img src="amfamCache/images/check2.gif" style="width: 45%;margin-left: 15px;">
														</div>
												</div>
											</div>
	                                        </ul>
	                                    </li>
	                        <li class="row">
									<logic:messagesNotPresent property="accountNumber">
	                                  		<ul class="labelSet">
	                                	</logic:messagesNotPresent>
	                                  	<logic:messagesPresent property="accountNumber">
	                                  		<ul class="labelSet error">
	                                  	</logic:messagesPresent>
	                                  		    <li class="one narrow"><label for="accountNumber"><b><bean:message key="label.bankAccountNumber"/></b></label></li>
	                                            <li class="two narrow">
	                                            	<input type="text" class="textField BankNumberBox1" name="accountNumber" id="accountNumber" maxlength="17" title=""/>
	                                            </li>
	                                            <p class="accountnumberhelpText">
													<a name = "AccountNum" class = "email_help_text" tabIndex="-1" ></a><a tabIndex="-1" href="#AccountNum">Where do you find this?</a>
												</p>
												<div id='help_contentaccountnumber' style="float:left;">
															<div class='content_float'>
																<h4>Where do you find this number?</h4>
																<p>Your bank account and routing numbers can be found at the bottom of your check. The 9-digit routing transit number appears on the bottom left of your check between the colon symbols. This number is used by the Federal Reserve Bank to route checks and deposits to the correct financial institution.</p>
																<p>The exact location of your checking account number and the number of digits can vary from each financial institution, but can usually be located to the right of your routing transit number.</p>
																<p>The sample check below shows where the numbers can be found.</p>
																<div id="help_text_images" style="margin-bottom: 2em;">
																	<img src="amfamCache/images/check1.gif" style="width: 45%;">
																	<img src="amfamCache/images/check2.gif" style="width: 45%;margin-left: 15px;">
																</div>
																
													</div>
												</div>
	                                        </ul>
	                                    </li>
	                                 </div>  
	                                	<li class="row">
	                                		<logic:messagesNotPresent property="emailAddressString">
	                                  			<ul class="labelSet">
	                                  		</logic:messagesNotPresent>
	                   						<logic:messagesPresent property="emailAddressString">
	                                  			<ul class="labelSet error">
	                    	      		 	</logic:messagesPresent>
	                              			    <li class="one"><label id="email" for="email"><b>Email for Receipt:</b></label></li>
	                                            <li class="two">
	                                                <input type="text" class="textField" name="emailAddressString" id="emailAddressString" title=""/>
	                                            </li>
	                                             <p class="helpText">
		                                                <a name = "emailText" tabIndex="-1" class = "email_help_text"></a><a tabIndex="-1" href="#emailText">How do we use your email?</a>
	                                                </p>
	                                    <div class='help_content3'>
											<div class='content_float'>
											<h4>How do we use your email?</h4>
											<p>Your email address is only required if you would like to receive an electronic confirmation of your payment. American Family will not use or store your email address for any other purpose.</p>
											<p>It is important that you enter your email address accurately. If your email address is incorrect, inactive or your mailbox is full, you will not receive an email payment confirmation.</p>
													</div>
												</div>
									</ul>
									<script>
												    $(document).ready(function(){
												      $('.helpText').click(function(e){
												    	$(".help_content3").slideToggle();
												    });
												});
												     $(document).ready(function(){
												      $('.routingnumberhelpText').click(function(e){
												    	$("#help_contentrountingnumber").slideToggle();
												    });
												});
												     $(document).ready(function(){
												      $('.accountnumberhelpText').click(function(e){
												    	$("#help_contentaccountnumber").slideToggle();
												    });
												});

									</script>
								</li>
			<c:if test="<%= (form.getBankReturnedFeeInd())%>">
               <li class="row textOnly">
               <p class="disclaimer">A returned bank fee will be charged if your payment is returned unpaid. Refer to your billing statement for specific fee information.</p>
	           </li>
	        </c:if>
	                                    <li class="row buttonRow">
           									<a class="button paynowPreviousBtn" href="javascript: clickPrevious();" onClick="return submitForm();" />
            								<span>Previous</span>
            								</a>&nbsp;

            								<a class="button cancelBtn" href="javascript:self.close()" />
            								<span>Cancel</span>
            								</a>&nbsp;
	                                        <!--<a href="javascript: clickPrevious();" onClick="return submitForm();" id="btn_previous">Previous</a> -->
	                                        <!-- <a href="javascript:self.close()" id="btn_cancel">Cancel</a> -->
	                                        <jsp:include page="/WEB-INF/view/shared/buttons.jsp" />&nbsp;
	                                    </li>
  
	    
	    
	    <% //Checking or Saving %>
	    
	  	   </ul>
	   </div> 
<!-- ########################################################################################################################### -->	 


<script language="javascript">
 
  
   document.forms[0].addBillNumId.value ="<bean:write name='form' property='addBillNum'/>";
   document.forms[0].accountTypehiddenId.value="<bean:write name='form' property='accountType'/>";
   
   
    populateYYYYdropdown();   
    initAmtTypRadioOnLoad(); 
	refreshTotal();

  function populateYYYYdropdown() {
  	
  	var d = new Date();        
  	
  	var yyyy = d.getFullYear();
  	
  	for (var i=1; i <= 16; i++) {
  		document.forms[0].expDateYYYY.options[i] = new Option(yyyy,yyyy);
  		yyyy = yyyy + 1;
  	}
  }	
</script>
