 <!--$Id$-->  


<%@ include file='/components/jsp/CommonIncludes.jspf'%>
<%@page import="com.adventnet.client.util.*"%>
<%@ page import="com.adventnet.i18n.I18N" %>

<!--    <script>parent.includeJS("<%=IAMEncoder.encodeHTMLAttribute(request.getContextPath())%>/javascript/usermanagement.js",window)</script>   -->
<!--    <script>parent.includeJS("<%=IAMEncoder.encodeHTMLAttribute(request.getContextPath())%>/components/javascript/FormHandling.js",window)</script> -->
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<br>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><form name="passwordChangeForm">
  <%
 String emailId = (String)request.getAttribute("EmailId");
%>
        <table border="0" cellpadding="3" cellspacing="0" width="100%" align="center" class="whitetable">
          <tr valign="top">
          </tr>
          <tr valign="top">
            <td colspan="4" align="right" nowrap>&nbsp;</td>
          </tr>
          <tr valign="top">
            <td width="25%" align="right" nowrap><%=IAMEncoder.encodeHTML(I18N.getMsg("mc.components.usermgmt.Old_Password"))%></td>
            <td width="4">:</td>
            <td width="329"> <input name="oldPassword" type="password" class="inputStyle" id="OLDPASSWORD" size="30" isnullable="false" validatemethod="validatePassword" errormsg="<%=IAMEncoder.encodeHTMLAttribute(I18N.getMsg("mc.components.usermgmt.Old_password_should_be_between_5_20_characters"))%>" >
            </td>
            <td width="397"> <div id="OLDPASSWORD_DIV" class="errorMsg hide"></div></td>
          </tr>
          <tr valign="top">
            <td align="right"><%=IAMEncoder.encodeHTML(I18N.getMsg("mc.components.usermgmt.New_Password"))%></td>
            <td>:</td>
            <td> <input name="newPassword" type="password" class="inputStyle" id="NEWPASSWORD" size="30" isnullable="false" validatemethod="validateNewPassword" errormsg="<%=IAMEncoder.encodeHTMLAttribute(I18N.getMsg("mc.components.usermgmt.New_password_should_be_limited_to_5_20_characters"))%>" >
            </td>
            <td > <div id="NEWPASSWORD_DIV" class="errorMsg hide"></div></td>
          </tr>
          <tr valign="top">
            <td align="right"><%=IAMEncoder.encodeHTML(I18N.getMsg("mc.components.usermgmt.Confirm_Password"))%></td>
            <td>:</td>
            <td> <input name="confirmPassword" type="password"  class="inputStyle" id="NEWUSLOGINCP" size="30" isnullable="false" validatemethod="validateConfirmPassword3" errormsg="<%=IAMEncoder.encodeHTMLAttribute(I18N.getMsg("mc.components.usermgmt.Enter_confirm_password"))%>" >
            </td>
            <td > <div id="NEWUSLOGINCP_DIV" class="errorMsg hide"></div></td>
          </tr>
          <tr valign="top">
            <td align="right"><%=IAMEncoder.encodeHTML(I18N.getMsg("mc.components.usermgmt.Email_Address"))%></td>
            <td>:</td>
            <td> <input type="text" name="emailaddress" value="<%=IAMEncoder.encodeHTMLAttribute(emailId)%>" class="inputStylenormal" size="40" isnullable="false" validatemethod="isEmailId" errormsg="<%=IAMEncoder.encodeHTMLAttribute(I18N.getMsg("mc.components.usermgmt.Enter_a_valid_email_address"))%>" id="NEWUSLOGINEMAIL" >
            </td>
            <td> <div id="NEWUSLOGINEMAIL_DIV" class="errorMsg hide"></div></td>
          </tr>
          <tr>
            <td colspan="3">&nbsp;</td>
          </tr>
        </table>
  <table width="100%" align="center" border="0" cellspacing="0" cellpadding="3">
    <tr class="tableheaderConfig">
            <td width="25%">&nbsp; </td>
      <td width="5%"> <input name="close" type="submit" class="btnStyleBig"  value="<%=IAMEncoder.encodeHTMLAttribute(I18N.getMsg("mc.components.Save"))%>"></td>
        <td> <input name="close" type="button" class="button" value="<%=IAMEncoder.encodeHTMLAttribute(I18N.getMsg("mc.components.Cancel"))%>"   onClick="history.back();" &nbsp; ></td>
    </tr>
  </table>
</form> </td>
  </tr>
</table>
<br>



  <script>
//  alert("hi");
   function validatePassword(value, formElement){
//    alert("hi");
        if(!isNotEmpty(value, formElement)){
                return false;
        }
        if(value.length < 5){
                return "Password should contain atleast 5 characters";
        }
        if(value.length >20){
                return "Password should be between 5-20 characters";
        }
        return true;
}

function validateNewPassword(value,formElement)
{
// alert("hello");
if(!isNotEmpty(value, formElement)){
                return false;
        }
        if(value.length < 5){
                return "Password should contain atleast 5 characters";
        }
        if(value.length >20){
                return "Password should be between 5-20 characters";
        }
        return true;

}


   function validateConfirmPassword3(value, formElement){
        if(!isNotEmpty(value, formElement)){
                return false;
        }
        if(value != formElement.form.newPassword.value){
                return "Password mismatch";
        }
        return true;
}

function validateConfirmPassword2(value, formElement){
        if(!isNotEmpty(value, formElement)){
                return false;
        }
        if(value != formElement.form.password.value){
                return "Password mismatch";
        }
        return true;
}

</script>



