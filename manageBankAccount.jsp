<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="/WEB-INF/pymtMgr.tld" prefix="pymtMgr" %>

	<%// bind the java script doAction function to the form %> 
<bean:define id="action" name="action" type="java.lang.String" />
<bean:struts id="mapping" mapping="<%= action %>" />
<bean:define id="formName" name="mapping" property="name" type="java.lang.String"/>
<bean:define id="originalBankAccountBO" name="<%= formName %>" property="originalAgentBankAccount" 
	type="com.amfam.billing.pymtmgr.entities.dto.AgentBankAccountDTO"
	toScope="request" />
	
	<!-- show 'IMPORTANT' message if method = change -->
<table>
		<tr><td class="error">
			<logic:equal name="<%= formName %>" property="showModifyButton" value="true">
 				<bean:message key="text.importantMessage" /><br><br>
			</logic:equal>
		</td></tr>
	</table>

	<table>
		<colgroup>
		 	<col width="58%" class="textlabel"/>
		 	<col width="42%"/>
		</colgroup>
		<tr>
			<td><bean:message key="label.effectiveDate" /></td>
			<td><pymtMgr:date name="originalBankAccountBO" property="bankingEffTs" content="date"/></td>
		</tr>
		<tr>
			<td><bean:message key="label.agentBankName" /></td>
			<td>
	 		<logic:notEmpty name="originalBankAccountBO" property="bank.name">
	 		<bean:write name="originalBankAccountBO" property="bank.name"/>
	 		</logic:notEmpty>
	 		<logic:empty name="originalBankAccountBO" property="bank.name">
	 		<bean:message key="label.notAvailable" />
	 		</logic:empty>
	  		</td>
			
		</tr>
		<tr>
			<td><bean:message key="label.agentBankRoutingNumber" /></td>
			<td><html:text name="<%= formName %>" property="routingNumber"  onblur="onBankAcctChange();" size="12" maxlength="9" styleId="bankRoutingNumber"/></td>
		</tr>
		<tr>
			<td><bean:message key="label.agentBankAccountNumber" /></td>
			<td><html:text name="<%= formName %>" property="bankAccountNumber" onblur="onBankAcctChange();" size="20" maxlength="17" styleId="bankAccountNumber"/>
			<input type="hidden" id="bankAccountNumberToEncrypt" name="bankAccountNumberToEncrypt" /></td>
		</tr>
		<tr>
			<td><bean:message key="label.agentBankAccountType" /></td>
			<td><input type="radio"  class="checkingRadio" onclick="setAccountType('CHEC');"   id="checkingRadio" >
			<bean:message key="label.checking" />
			<input type="radio"  class="savingRadio" onclick="setAccountType('SAVE');"  id="savingRadio" >
			<bean:message key="label.savings" /></td>
			<html:hidden name="<%= formName %>" property="accountType" styleId="accountTypeHidden"></html:hidden>
		</tr>
		<tr>
			<td><bean:message key="label.returnedBankItemFeeAmount" /></td>
			<td><html:text name="<%= formName %>" property="rbiFeeAmount" onblur="onBankAcctChange();" size="8" maxlength="5" styleId="rbiFeeAmount"/></td>
		</tr>
	</table>
	<br><br>
	<table> 
	
		<logic:equal name="<%= formName %>" property="showModifyButton" value="true" >
		<tr valign="bottom">
				<td><input type="checkbox"  name="modifyFinancialCkBox" id="modifyFinancialCkBox" style="margin-top: 2px;" onclick="modifyFinDetails();"/>
				<bean:message key="label.button.modifyFinancialInfo"/></td>
				<html:hidden name="<%= formName %>" property="modifyFinancialInfoInd" styleId="modifyFinancialInfoIndHidden"></html:hidden>
				<td>&nbsp;</td>
				<td><input type="checkbox" name="modifyBankFeeCkBox" id="modifyBankFeeCkBox" style="margin-top: 2px;" onclick="modifyBankFeeDetails();"/>
				<bean:message key="label.button.modifyReturnedFee"/></td>
				<html:hidden name="<%= formName %>" property="modifyReturnedBankFeeInd" styleId="modifyReturnedBankFeeIndHidden"  ></html:hidden>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
			</logic:equal>
	</table>
	<br><br><br>
<script type="text/javascript">

window.onload=function(){

	var showModifyButton = <bean:write name="<%=formName%>" property="showModifyButton" />;
	
	// select the respective radio button on load of manage agent bank account page
	if(document.getElementById('accountTypeHidden').value == 'CHEC'){
		document.getElementById('checkingRadio').checked = true;
	} else if(document.getElementById('accountTypeHidden').value == 'SAVE'){
		document.getElementById('savingRadio').checked = true;
	}
	
	//Call the showHide() only for the modify flow.
	if(showModifyButton){
		showHide();
	}
	
}

/*
This method is called to set and disable the routingNumber, bankAccountNumber, accountType and hide
the 'Next' button.  
*/
	
function resetFinInfo() {

	var routingNumber = '<bean:write name="originalBankAccountBO" property="routingTransNumber.masked" />';
	var bankAccountNumber = '<bean:write name="originalBankAccountBO" property="bankAcctNumber.displayable" />';
	var accountType = '<bean:write name="originalBankAccountBO" property="bankAcctType" />';
	
		document.getElementById('bankRoutingNumber').value = routingNumber;
		document.getElementById('bankAccountNumber').value = bankAccountNumber;
	
		if(accountType == 'CHEC'){
			document.getElementById('checkingRadio').checked=true;
			document.getElementById('savingRadio').checked=false;
		}else if(accountType == 'SAVE'){
			document.getElementById('savingRadio').checked=true;
			document.getElementById('checkingRadio').checked=false;
		}
		document.getElementById('accountTypeHidden').value = accountType;
		document.getElementById('bankRoutingNumber').disabled = true;
		document.getElementById('bankAccountNumber').disabled = true;
		document.getElementById('checkingRadio').disabled = true;
		document.getElementById('savingRadio').disabled = true;
		document.getElementById('action.label.button.next').style.visibility = 'hidden';		
}	

//This method is called to set the rbiFeeAmount, disable the rbiFeeAmount and hide the 'Next' button.

function resetBankFeeInfo() {

	var rbiFeeAmount = '<bean:write name="originalBankAccountBO" property="rbiFeeAmountDisplay"/>';
	
		document.getElementById('rbiFeeAmount').value = rbiFeeAmount;
		document.getElementById('rbiFeeAmount').disabled = true;
		document.getElementById('action.label.button.next').style.visibility = 'hidden';		
}

//This method is called to set the clearText bankAccountNumber to bankAccountNumberToEncrypt field.
		
function onBankAcctChange(){
		
		if(document.getElementById("bankAccountNumber")!=null){
			baNumber = document.getElementById("bankAccountNumber").value;
		}
		// remove spaces and dashes
		baNumber = baNumber.replace(/\s|/g, '');
		document.getElementById("bankAccountNumberToEncrypt").value = baNumber;
}

//This method is called on select or unselect of the 'modify financial information' checkbox in manageBankAccount page.

function modifyFinDetails(){

if(document.getElementById("modifyFinancialCkBox").checked == true)
		{
			document.getElementById('bankRoutingNumber').disabled = false;
			document.getElementById('bankAccountNumber').disabled = false;
			document.getElementById('bankRoutingNumber').value="";
			document.getElementById('bankAccountNumber').value="";
			
			document.getElementById('checkingRadio').checked = false;
			document.getElementById('checkingRadio').disabled = false;
			document.getElementById('savingRadio').checked = false;
			document.getElementById('savingRadio').disabled = false;
			document.getElementById('accountTypeHidden').value="";
			document.getElementById('modifyFinancialInfoIndHidden').value = true;
		}else{
			document.getElementById('modifyFinancialInfoIndHidden').value = false;
		}
		showHide();
}


//This method is called on select or unselect of the 'modify bank item fee' checkbox in manageBankAccount page. 

function modifyBankFeeDetails(){

	if(document.getElementById("modifyBankFeeCkBox").checked == true)
		{
			document.getElementById('rbiFeeAmount').disabled = false;
			document.getElementById('rbiFeeAmount').value = "";
			document.getElementById('modifyReturnedBankFeeIndHidden').value = true;
		}else{
			document.getElementById('modifyReturnedBankFeeIndHidden').value = false;
		}
		showHide();
}


//This method is called on click of checking or savings radio button in manageBankAccount page. 

function setAccountType(type){

	if (type == 'CHEC') {
	document.getElementById('accountTypeHidden').value='CHEC';
	document.getElementById('checkingRadio').checked = true;
	document.getElementById('savingRadio').checked = false;
	
	}else if(type == 'SAVE'){
	document.getElementById('accountTypeHidden').value='SAVE';
	document.getElementById('savingRadio').checked = true;
	document.getElementById('checkingRadio').checked = false;
	}
}

/*
 This method is called on load of manageBankAccount page only for the modify flow and on select or unselect of 
 modifyFinancialInfo and modifyBankFeeInfo checkbox, else logic will set the modifyFinancialCkBox and modifyBankFeeCkBox 
 to true on reload of page to maintian the status of the checkBox. 
*/

function showHide(){
	
	if(document.getElementById('modifyFinancialInfoIndHidden').value == "false"){
		resetFinInfo();		
	}else{
		document.getElementById("modifyFinancialCkBox").checked = true;
	}
	
	if(document.getElementById('modifyReturnedBankFeeIndHidden').value == "false"){
		resetBankFeeInfo();
	}else{
		document.getElementById("modifyBankFeeCkBox").checked = true;
	}
	
	if(document.getElementById('modifyFinancialInfoIndHidden').value == "true" || document.getElementById('modifyReturnedBankFeeIndHidden').value == "true"){
	   document.getElementById('action.label.button.next').style.visibility = 'visible';
	}
}
 </script>