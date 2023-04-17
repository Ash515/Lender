<!--$Id$-->  

<%@ include file='/components/jsp/CommonIncludes.jspf'%>
<%@page import="java.util.*"%>
<%@page import="com.adventnet.client.util.*"%>
<%@ page import="com.adventnet.i18n.I18N" %>
<br>
    <form name="createNewUserForm" setfailedfocus="true">   
  <%boolean isCreateNewUser = true;

			String loginId = request.getParameter("LOGIN_ID");
			String loginName = null;
			String roleName = "";
			String emailId = "";
			String buttonDisplayStr = I18N.getMsg("mc.components.Create");
			String headerText = " Add a New User";
			if (loginId != null) {
%>
  <input type="hidden" name="LOGIN_ID" value='<%=IAMEncoder.encodeHTMLAttribute(loginId)%>'>      
  <%buttonDisplayStr = I18N.getMsg("mc.components.Update");
				isCreateNewUser = false;
				headerText = "Edit User Details";
				loginName = (String) request.getAttribute("LoginName");

				roleName = (String) request.getAttribute("RoleName");
				if (roleName == null) {
					roleName = ""; // this is for add new user
				}

				emailId = (String) request.getAttribute("EmailId");
				if (emailId == null) {
					emailId = ""; // this is for add new user
				}
			}
%>

            <!--<td class="titleHeaderMain" colspan="4" nowrap><%out.print(headerText);//NO OUTPUTENCODING%>&nbsp;<a href= "javascript:void(null)" onClick="contextHelp('Adding_new_users');"><img src="<%out.print(request.getContextPath());//NO OUTPUTENCODING%>/images/contexthlp.gif" border="0"></a></td><%--NO OUTPUTENCODING --%>
          </tr>-->
		      <%if (isCreateNewUser) {
%>
<table width="90%" >
    <tr>
      <td nowrap width="25%" align="right"  > <%=IAMEncoder.encodeHTML(I18N.getMsg("mc.components.usermgmt.Login_Name"))%> </td>
		<td width="25%" align="left"><input type="text" tabindex="1" size="20"
			name="loginName" validatemethod="validUserName"
			errormsg="<%=IAMEncoder.encodeHTMLAttribute(I18N.getMsg("mc.components.usermgmt.Enter_a_valid_login_name"))%>" id="NEWUSLOGIN">
		<div id="NEWUSLOGIN_DIV" class="errorMsg hide"></div>
		</td>

		<td nowrap width="25%" align="right" > <%=IAMEncoder.encodeHTML(I18N.getMsg("mc.components.usermgmt.Access_Level"))%> </td>
<td width="25%" align="left" ><%@ include file="Role.jspf"%>	</td>
          </tr>
            <%} else {

				%>
       <%=IAMEncoder.encodeHTML(I18N.getMsg("mc.components.usermgmt.Access_Level"))%> 
       <%@ include file="Role.jspf"%> 
          
      <%--      <%=loginName%>    --%>
      	 <input type="hidden" name="loginName" value="<%=IAMEncoder.encodeHTMLAttribute(loginName)%>">   
            <%}

			%>
          <%if (isCreateNewUser) {
%>
<tr>
<td nowrap  width="25%" align="right"><%=IAMEncoder.encodeHTML(I18N.getMsg("mc.components.usermgmt.Password"))%> 
<td  width="25%" align="left">
<input type="password" tabindex="2" name="password" size="20"
			class="inputStylePwd" isnullable='false'
			validatemethod="validatePassword"
			errormsg="<%=IAMEncoder.encodeHTMLAttribute(I18N.getMsg("mc.components.usermgmt.Password_should_be_between_5_20_characters"))%>" id="PASSWORD">
		<div id="PASSWORD_DIV" class="errorMsg hide"></div></td>
           <!-- Error message placeholder -->
<td nowrap width="25%" align="right"><%=IAMEncoder.encodeHTML(I18N.getMsg("mc.components.usermgmt.Email_Address"))%>  
<td  width="25%" align="left">
<input type="text" tabindex="5" name="emailaddress" value="<%=IAMEncoder.encodeHTMLAttribute(emailId)%>" isnullable='false' validatemethod="isEmailId" class="inputStyle" size="20" errormsg="<%=IAMEncoder.encodeHTMLAttribute(I18N.getMsg("mc.components.usermgmt.Enter_a_valid_email_address"))%>" id="NEWUSLOGINEMAIL">
		<div id="NEWUSLOGINEMAIL_DIV" class="errorMsg hide"></div></td>
            <!-- Error message placeholder -->
          </tr>
         <tr>
<td nowrap  width="25%" align="right"><%=IAMEncoder.encodeHTML(I18N.getMsg("mc.components.usermgmt.Confirm_Password"))%> </td>
<td  width="25%" align="left">            
 <input name="confirmpass" tabindex="3" type="password"
			isnullable='false' validatemethod="validateConfirmPassword2"
			class="inputStylePwd" id="NEWUSLOGINCP" size="20"
			errormsg="<%=IAMEncoder.encodeHTMLAttribute(I18N.getMsg("mc.components.usermgmt.Enter_confirm_password"))%>">
           </td>
            <td ><div id="NEWUSLOGINCP_DIV" class="errorMsg hide"></div></td>
            <!-- Error message placeholder -->
          </tr>
<%} else {

				%> 
 <%=IAMEncoder.encodeHTML(I18N.getMsg("mc.components.usermgmt.Email_Address")) %>
	<input type="text" name="emailaddress" value="<%=IAMEncoder.encodeHTMLAttribute(emailId)%>" isnullable='false' validatemethod="isEmailId" class="inputStyle" size="20" errormsg="<%=IAMEncoder.encodeHTMLAttribute(I18N.getMsg("mc.components.usermgmt.Enter_a_valid_email_address"))%>" id="NEWUSLOGINEMAIL">
	<div id="NEWUSLOGINEMAIL_DIV" class="errorMsg hide"></div>
            <!-- Error message placeholder -->
     
<%}
%>

  <table width="90%"  border="0" cellspacing="0" cellpadding="3">
    <tr class="tableheaderConfig">
            <td width="25%" nowrap>&nbsp; </td>
      <td align="centre" width="75%"> <input name="close" type="submit"
				tabindex="6" class="btnStyleBig" value="<%out.print(buttonDisplayStr);//NO OUTPUTENCODING%>"><%--NO OUTPUTENCODING --%> 
        <input align="centre" name="cancel" type="button"
				class="btnStyleBig" tabindex="7" value="<%=IAMEncoder.encodeHTMLAttribute(I18N.getMsg("mc.components.Cancel"))%>" onClick="TableDOMModel.closeDetailsEl(this);">
      </td>
    </tr>
  </table>
</form></td>
<br>

<script>
<%   if((roleName != null) && (roleName.length() > 0))
   { %>
      var aa = document.forms["createNewUserForm"].roles;
      DOMUtils.setValueOnEl(aa,"<%=IAMEncoder.encodeHTML(roleName)%>");
<%}%>
   function validatePassword(value, formElement){
	if(!isNotEmpty(value, formElement)){
		return false;
	}
	if(value.length < 5){
		return "<%=IAMEncoder.encodeHTML(I18N.getMsg("mc.components.usermgmt.Password_should_contain_atleast_5_characters"))%>";
	}
	if(value.length >20){
		return "<%=IAMEncoder.encodeHTML(I18N.getMsg("mc.components.usermgmt.Password_should_be_between_5_20_characters"))%>";
	}
	return true;
}

function validateNewPassword(value,formElement)
{
if(!isNotEmpty(value, formElement)){
		return false;
	}
	if(value.length < 5){
		return "<%=IAMEncoder.encodeHTML(I18N.getMsg("mc.components.usermgmt.Password_should_contain_atleast_5_characters"))%>";
	}
	if(value.length >20){
		return "<%=IAMEncoder.encodeHTML(I18N.getMsg("mc.components.usermgmt.Password_should_be_between_5_20_characters"))%>";
	}
	return true;

}

function validateConfirmPassword3(value, formElement){
	if(!isNotEmpty(value, formElement)){
		return false;
	}
	if(value != formElement.form.newPassword.value){
		return "<%=IAMEncoder.encodeHTMLAttribute(I18N.getMsg("mc.components.usermgmt.Password_mismatch"))%>";
	}
	return true;
}

function validateConfirmPassword2(value, formElement){
	if(!isNotEmpty(value, formElement)){
		return false;
	}
	if(value != formElement.form.password.value){
		return "<%=IAMEncoder.encodeHTML(I18N.getMsg("mc.components.usermgmt.Password_mismatch"))%>";
	}
	return true;
}

function validUserName(str,formelement)
{
     var str1 = trimAll(str);
      if(str1.length == 0)
     {
       return false;
     }
     
     if(isAlphaNumericDotDash(str,formelement))
     {
         var result=isUniqueColoumn('AaaLogin','NAME',str);
         if(result == "true")
         {
             return true;
         }
         else
         {
             return "<%=IAMEncoder.encodeHTML(I18N.getMsg("mc.components.usermgmt.Login_Name_already_exists"))%>";
         }
     }
     return false;
}

function isAlphaNumericDotDash(str, formElement){
    var objRegExp = /^[a-zA-Z0-9_\-\. ]+$/;
    if(objRegExp.test(str)){
        return true;
    }
    return false;
}

function isUniqueColoumn(tablename,colname,value)
{
   var xmlhttp = getXMLhttp();
   //For rest case, if the address bar url is relative, 
   //the the final url will be wrong
   var url = CONTEXT_PATH + "/components/jsp/usermgmt/persistence.jsp?reqType=isunique&table="+tablename+"&col="+colname+"&colVal="+value;
   xmlhttp.open("GET",url,false);
   xmlhttp.send(null);
   var result = xmlhttp.responseText;
   result = trimAll(result);
   return result;
}
</script>



