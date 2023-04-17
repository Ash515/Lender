//$Id$
	function togglePopUp(func) {
   		if(func == "show") {
   			de("confirmpopup").style.display=""; //No I18N
   			de('opacity').style.display=''; //No I18N
   		} else {
   			de('confirmpopup').style.display="none"; //No I18N
   			de('opacity').style.display='none'; //No I18N
   		}
   	}
	function de(id) {
	    return document.getElementById(id);
	}
	function validateUserCode(isMobile,serviceName,serviceUrl) {
		var value = document.getElementById("code").value;
		if (!value || value.trim() == "") {
			showError("code", I18N.get("IAM.TFA.ENTER.VERIFICATION.CODE"));//No i18N
			de('code').focus(); //No I18N
			return;
		}

		var remember = de('tfaremember').checked;//No I18N
		var servicename =serviceName;
		var serviceurl =serviceUrl;
		value = value.replace(/\s/g, "");
		var params = "remembertfa=" + remember + "&code=" + value + "&servicename=" + servicename + "&serviceurl=" + serviceurl;//No i18N
		var cdigest = de('cdigest').value;//No i18N
		if (cdigest && cdigest.trim() != "") {
			var captcha = de('captcha').value;//No i18N
			params += "&cdigest="+cdigest+"&captcha="+captcha;//No i18N
		}
		switchVerifyButton("pcs_std",isMobile); //No i18N
		sendRequestWithCallback("verify", params + "&" + csrfParam,true, //No I18N
		function(res){
		removeAndSetTimeOut();
		verifyCount++;
		
		if(!(res.indexOf("switchto") != -1 || res.indexOf("showsuccess")!= -1)) {
			if(isSmartPhone && verifyCount>=3 && res!="invalid_captcha") {
				de('gauthhint').style.display="inline-block";				
			}
		}
		
		if(res.indexOf("switchto") != -1 || res.indexOf("showsuccess")!= -1) {
			new Function( 'return ' + res)(); // jshint ignore:line
			return;
		} else if(res==="invalid_captcha" || res === "show_captcha"){//No i18N
			if(res === "invalid_captcha") {
				showError('captcha',I18N.get("IAM.ERROR.INVALID_IMAGE_TEXT"));//No i18N
				de('captcha').focus();//No i18N
			} else {
				if(cdigest != null && cdigest != "") {
					showError('captcha',I18N.get("IAM.ERROR.INVALID_IMAGE_TEXT")); //No i18N	
				}else {
					showError('code',I18N.get("IAM.PHONE.INVALID.VERIFY.CODE"));			//No i18N		
				}
				de("code").value="";//No i18N
				de('code').focus();//No i18N
			}
			de("captcha").value="";//No i18N
			de('captcharow').style.display="";
			showCaptcha();
			if(isMobile == true) {
				de("verify_mobile").className += " " + "old_button"; //No I18N
				de("verify_button").className = "bluebutt_ver";
			}
			switchVerifyButton("pcs_end",isMobile); //No i18N
			return;
		} else if(res==="invalid_code"){ //No i18N
			showError('code',I18N.get("IAM.PHONE.INVALID.VERIFY.CODE")); //No i18N
			document.getElementById("code").value="";
			de('code').focus();//No i18N
			switchVerifyButton("pcs_end",isMobile); //No i18N
			return;
		}else if(res==="invalid_code_and_captcha") { //No i18N
			showError('code',I18N.get("IAM.PHONE.INVALID.VERIFY.CODE")); //No I18N
			document.getElementById("code").value="";
			de("captcha").value=""; //No i18N
			de('captcharow').style.display="";
			showCaptcha();
			de('code').focus(); //No i18N
			if(isMobile == true) {
				de("verify_mobile").className += " " + "old_button"; //No I18N
				de("verify_button").className = "bluebutt_ver";
			}
			switchVerifyButton("pcs_end",isMobile); //No i18N
			return;
		}else if(res==="exceeded"){ //No i18N
			showError('code',I18N.get("IAM.TFA.VERIFY.THRESHOLD.EXCEED")); //No I18N
			switchVerifyButton("pcs_end",isMobile); //No i18N
			return;
		}
		showError('code',I18N.get("IAM.ERROR.GENERAL")); //No I18N
		document.getElementById("code").value="";
		de('code').focus();//No i18N
		switchVerifyButton("pcs_end",isMobile); //No i18N
	});
	}
	function showError(EleName, msg) {
		if (de(EleName).previousSibling !=null && de(EleName).previousSibling.className == 'error') {
				var element = de(EleName).previousSibling;
				element.innerHTML = msg;
				element.style.display="";
		} else {
			var newElement = document.createElement('div');
			newElement.className = "error";
			newElement.setAttribute("id", EleName + "err");
			newElement.innerHTML = msg;
			de(EleName).parentNode.insertBefore(newElement, de(EleName));
		}
	}
	function hideErrordiv(element) {
		if(element.previousSibling !=null && element.previousSibling.className == 'error') {
			element.previousSibling.style.display = "none";
		}
	}
	function switchVerifyButton(process,isMobile){
		if(process == "pcs_std") {
			if(isMobile == true) {
				var vermob = de("verify_mobile"); //No i18N
				vermob.innerHTML= err_verifying;
				vermob.setAttribute ("onclick", null);
			}
			var verbutt = de('verify_button'); //No i18N
			verbutt.innerHTML= I18N.get("IAM.VERIFYING");
			verbutt.setAttribute ("onclick", null);
		}else {
			if(isMobile == true) {
				var vermob = de("verify_mobile"); //No i18N
				vermob.innerHTML= I18N.get("IAM.VERIFY");
				vermob.setAttribute ("onclick", "validateUserCode()");
			}
			var verbutt = de('verify_button'); //No i18N
			verbutt.innerHTML= err_verify;
			verbutt.setAttribute ("onclick", "validateUserCode()");
		}
	}
	function sendRequestWithCallback(action, params, async, callback) {
	    var objHTTP = xhr();
	    objHTTP.open('POST', action, async);
	    objHTTP.setRequestHeader('Content-Type','application/x-www-form-urlencoded;charset=UTF-8');
	    if(async){
		objHTTP.onreadystatechange=function() {
		    if(objHTTP.readyState==4) {
			if(callback) {
			    callback(objHTTP.responseText);
			}
		    }
		};
	    }
	    objHTTP.send(params);
	    if(!async) {
		if(callback) {
	            callback(objHTTP.responseText);
	        }
	    }
	} 