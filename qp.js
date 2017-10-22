
function showHide(payOption) {
	if (payOption == 'PBP') {
		show('checkSav');
		hide('creditCard');
		hide('lastPayDetails');
		hide('newExpDetail');
		document.getElementById('lastPayHidden').value = false;
		document.getElementById('creditCardRadio').checked = false;
		document.getElementById('lastPaymentRadio').checked = false;
		document.getElementById('checkingSavingsRadio').checked = true;
		document.getElementById('paymentOptionHidden').value = payOption;
		clearCCFields();
		clearExpDate();
	} else if (payOption == 'CRC') {
		show('creditCard');
		hide('checkSav');
		hide('lastPayDetails');
		hide('newExpDetail');
		document.getElementById('lastPayHidden').value = false;
		document.getElementById('checkingSavingsRadio').checked = false;
		document.getElementById('lastPaymentRadio').checked = false;
		document.getElementById('creditCardRadio').checked = true;
		document.getElementById('paymentOptionHidden').value = payOption;
		clearPBPFields();
		clearExpDate();
	} else if (payOption == 'LastPayment') {
		clearCCFields();
		clearPBPFields();
		show('lastPayDetails');
		showLastPayWarning();
		hide('creditCard');
		hide('checkSav');
		show('newExpDetail');
		document.getElementById('checkingSavingsRadio').checked = false;
		document.getElementById('creditCardRadio').checked = false;
		document.getElementById('lastPaymentRadio').checked = true;
		document.getElementById('paymentOptionHidden').value = payOption;
		document.getElementById('lastPayHidden').value = true;
	}
}

function showLastPayWarning() {
	var s = document.getElementById('lastPayDets').innerText;
	if (typeof (s) != 'undefined' && s != 'null' && s.indexOf("Account") != -1) {
		show('lastPayWarning');
	} else {
		hide('lastPayDetails');
	}
}

function checkbillingNumChange(formId, rowId, caller) {
	if (document.getElementById('lastPayHidden').value && rowId == 0) {
		if (caller == 'checkbillingNumChange'
				&& (!document.getElementById('lastPaymentRadio').disabled || (document
						.getElementById('lastPayDets').innerText == noLastPay))) {
			alert("The Billing Number has changed. Please select details to retrieve the last payment information");
			resetLastFinancials(formId, 'clearLastFinancialDetails',
					'/PaymentManager/QP/processPayment.do?method=');
		} else if (caller == 'qpdeleteRow') {
			alert("The Billing Number has been deleted. Please select details to retrieve the last payment information");
			document.getElementById("rowData[0].billingNumber").defaultValue == "";
			resetLastFinancials(formId, 'clearLastFinancialDetails',
					'/PaymentManager/QP/processPayment.do?method=');
		}
		document.getElementById('lastPayDets').innerText = lablefiller;
		document.getElementById('lastPayDetailsHidden').value = '';
		if (document.getElementById('paymentOptionHidden') != null
				&& document.getElementById('paymentOptionHidden').value == 'LastPayment') {
			document.getElementById('paymentOptionHidden').value = '';
		}
		document.getElementById('lastPaymentRadio').checked = false;
		document.getElementById('lastPaymentRadio').disabled = true;
		document.getElementById('lastPayHidden').value = false;
		document.getElementById('lifePolicyInd').value = false;
		document.getElementById('checkingSavingsRadio').disabled = false;
		hide('newExpDetail');
		hide('lastPayWarning');
	}
}

function resetLastFinancials(formId, method, targetUrl) {
	if (!window.console)
		console = {
			log : function() {
			}
		};
	$
			.ajax( {
				url : targetUrl + method,
				type : 'GET',
				error : function() {
					console
							.log("clear Last financial failed and initialized the request");
					doAction(formId, 'setUpPage', targetUrl + 'setUpPage');
				},
				success : function(data) {
					//console.log("Last financial cleared successfully");
			}
			});
}

function qpdeleteRow(formId, rowId) {
	deleteRow(rowId);
	checkbillingNumChange(formId, rowId, 'qpdeleteRow');
}

function clearPBPFields() {
	document.getElementById("bankAccountType").value = "";
	document.getElementById("bankAccountNumberToEncrypt").value = "";
	document.getElementById("bankRoutingNumberDisplay").value = "";
}


function updateInpectionStatus(inspectionStatus) {
	
	
	doAction(QuickPayPaymentEntryActionForm,
			'updateInspectionStatus',
			'/PaymentManager/QP/processPayment.do?method=updateInspectionStatus&status=' + inspectionStatus);
	
}



function forToolTip() {
	$(document).tooltip();
}


function popUp() {
	$('#dialog-confirm')
			.dialog(
					{
						modal : true,
						resizable : false,
						draggable : false,
						height : 'auto',
						width : 'auto',
						closeOnEscape: false,
			            open: function(event) {
			               $('.ui-dialog-buttonpane').find('button:contains("Inspected")').addClass('buttonPopUp');
			               $('.ui-dialog-buttonpane').find('button:contains("Disabled")').addClass('buttonPopUp');
			 								},	
						buttons : [
								{
									text : "Inspected",
									title : "If selected, the date, time and user ID will be logged.",
									id : 'inspect',
									onmouseover : 'javascript:forToolTip()',
									click : function() {
										$(this).dialog('close');
										updateInpectionStatus('Inspected');
									}
								},
								{
									text : "Disabled",
									title : "If selected, the credit card swipe portion of the device will be disabled.  The debit/credit card manual entry and check debit portion will still be enabled. To reactivate, swipe a credit card to receive a new inspection request.",
									id : 'suspend',
									onmouseover : 'javascript:forToolTip()',
									click : function() {
										$(this).dialog('close');
										updateInpectionStatus('Disabled');
										$('#scannedCardNumber').val("");
										$('input[name=scanEntryCheckbox]').attr('checked', false);
									}
								}

						]

					});
}
