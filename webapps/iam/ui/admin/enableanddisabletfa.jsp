<%-- $Id$ --%>
<%@ include file="includes.jsp" %>
<div class="maincontent">
    <div class="menucontent">
	<div class="topcontent"><div class="contitle">Manage Two Factor Authentication</div></div> <!-- No i18N -->
	<div class="subtitle">Manage TFA for users</div> <%-- No I18N --%>
    </div>
     <div class="field-bg" style="padding: 10px;">
     <div>
     <div id="enabletfaheader" class="tfafield-header tfasel" onclick="switchTFAClass(this)">Enable and Disable TFA</div> <%-- No I18N --%> 
     <div id="resettfaheader" class="tfafield-header" onclick="switchTFAClass(this)">Reset TFA</div> <%-- No I18N --%>
     <div id="smsstatusheader" class="tfafield-header" onclick="switchTFAClass(this)">SMS Status</div> <%-- No I18N --%> 
     <div id="generateRecoveryCodeheader" class="tfafield-header" onclick="switchTFAClass(this)">Generate Recovery Code</div> <%-- No I18N --%>
     <div style="clear:both;"></div>
     </div>
     
     <div id="enabletfa" class="tfafield-body" style="display:;">
     <div class="labelkey">Email ID or zuid :</div> <%-- No I18N --%> 
     <div class="labelvalue"><input type="text" id="useremail" class="input"/></div>
     <div class="labelkey">Option : </div> <%-- No I18N --%> 
     <div class="labelvalue">
     <input type="radio" name="changeprefradio" value="1" id="enable" checked/>
     <label for="enable">Enable</label> <!-- No i18N -->
     <input type="radio"  name="changeprefradio" value="2" id="disable"/>
     <label for="disable">Disable</label> <!-- No i18N -->
     </div>
     <br />
     <div class="labelkey">Enter Admin password :</div> <%-- No I18N --%>
     <div class="labelvalue"><input type="password" id="tfapassword" class="input" onkeyup="if(event.keyCode==13) saveTFAAdmin();"/></div>
     <div class="accbtn Hbtn">
		    <div class="savebtn" onclick="saveTFAAdmin();">
			<span class="btnlt"></span>
			<span class="btnco"><%=Util.getI18NMsg(request,"IAM.SAVE")%></span>
			<span class="btnrt"></span>
		    </div>
		</div>
	</div>

	<div id="resettfa" class="tfafield-body" style="display:none;">
	 <div class="labelkey">Email id or zuid :</div> <%-- No I18N --%> 
	 <div class="labelvalue"><input type="text" id="reset_email" class="input"/></div>
	  <div class="labelkey">Enter Admin password :</div> <%-- No I18N --%>
     <div class="labelvalue"><input type="password" id="tfareset_pass" class="input"/></div>
     <div class="labelkey">&nbsp;</div>
     <div class="labelvalue"><button style="background-color: red;color: #FFFFFF;border:1px solid red" onclick="resetTFA()" >Reset</button></div> <%-- No I18N --%>
	<div class="labelkey">Response From Server :</div> <%-- No I18N --%>
	<div class="labelvalue">
	<textarea rows="10" cols="96" id="tfaresetstatus" style="font-size:10px;background-color:#ddd;border: 1px solid #CCCCCC;" readonly></textarea>
	</div>
	</div>
	
	<div id="smsstatus" class="tfafield-body" style="display:none;">
	 <div class="labelkey">Reference ID :</div> <%-- No I18N --%> 
	 <div class="labelvalue"><input type="text" id="tfaref_id" style="width: 250px;" class="input"/></div>
	<div class="accbtn Hbtn">
		    <div class="savebtn" onclick="checktelesignref();">
			<span class="btnlt"></span>
			<span class="btnco"><%=Util.getI18NMsg(request,"IAM.REGISTER.CHECK")%></span>
			<span class="btnrt"></span>
		    </div>
	</div>
	<div class="labelkey">Response From TeleSign :</div> <%-- No I18N --%>
	<div class="labelvalue">
	<textarea rows="10" cols="96" id="telesignres" style="font-size:10px;background-color:#ddd;border: 1px solid #CCCCCC;" readonly></textarea>
	</div>
	</div>
	
	<div id="generateRecoveryCode" class="tfafield-body" style="display:none;">
	 <div class="labelkey">Email ID or zuid :</div> <%-- No I18N --%> 	
	 <div class="labelvalue"><input type="text" id="recEmail" class="input"/></div>
	 <div class="labelkey">Enter Admin password :</div> <%-- No I18N --%>
     <div class="labelvalue"><input type="password" id="tfa_rec_password" class="input" onkeyup="if(event.keyCode==13) generateAdminRecoveryCode();"/></div>
     <div class="accbtn Hbtn">
		    <div class="savebtn" onclick="generateAdminRecoveryCode();">
			<span class="btnlt"></span>
			<span class="btnco"><%=Util.getI18NMsg(request,"IAM.SAVE")%></span>
			<span class="btnrt"></span>
		    </div>
	</div>
	<div class="labelkey">Recovery Code for User :</div> <%-- No I18N --%>
	<div class="labelvalue">
		<textarea rows="10" cols="52" id="recCodeResponse" style="font-size:12px;background-color:#ddd;border: 1px solid #CCCCCC;" readonly></textarea>
	</div>
	</div>
	</div>
<iframe onload="de('useremail').focus();" frameborder="0" class="hide" width="0%" height="0%" src="<%=request.getContextPath()%>/static/blank.html" ></iframe> <%-- NO OUTPUTENCODING --%>
</div>