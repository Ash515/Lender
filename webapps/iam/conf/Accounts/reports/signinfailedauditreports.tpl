<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<table style='font-family: DejaVu Sans, Roboto, Helvetica, sans-serif;margin:auto !important; font-size: 11px;padding:1px;margin:0px;width:1000px;padding:4px;'><tr><td bgcolor='whiteSmoke' style='text-align:left; line-height:25px;border:1px solid #CCC;box-shadow:0px 1px #FFF7F7 , 1px 2px 0px #ccc'>
<center><h3 style='font-family:open sans,DejaVu Sans'>User Sign In Failed Statics for' ${Yesterday_Date}  </h3></center></table><br><br>

<p><b style='font-family:open sans,DejaVu Sans'> ${Overall_Statistics}:</b></p>	
<table border="1" style="width:300px;border:1px solid #A39E9E;font-size:12px;line-height:19px;text-align:center;white-space:nowrap;border-collapse:collapse;">

   <tr style="background-color:whiteSmoke;border:1px solid #A39E9E;border-collapse:collapse;">
        <td></td>
		<th style="width:12.5%">Total Users</th>
		<th style="width:12.5%">Unique Users</th>
	</tr>
   <tr>
		<td style="text-align:left;padding-left:6px;border:1px solid #A39E9E;">Failed Sign In</td>
		<td>${TOTALFAILEDSIGINCOUNT}</td>
		<td>${TOTAL_NUMBEROF_UNIQUE_USERS}</td>
   </tr>

   <tr>
        <td style="text-align:left;padding-left:6px;border:1px solid #A39E9E;">Users Converted From Failed Sign In</td>
        <td>${TOTALNOSUCHUSER_REGISTEREDUSERS}</td>
        <td></td>
  </tr>
  
  <tr>
        <td style="text-align:left;padding-left:6px;border:1px solid #A39E9E;">Verify Password call for Inactive Users</td>
        <td>${TOTAL_NUMBEROF_VERIFYPASSWORD_INACTIVE_USERS}</td>
        <td>${TOTAL_NUMBEROF_UNIQUE_VERIFYPASSWORD_INACTIVE_USERS}</td>
  </tr>      

</table>

<#if ((user_signin_weblogin_content)=="true")>
<br/><p><b style='font-family:open sans,DejaVu Sans'>${USER_FAILURE_DETAILS_WEBLOGIN}:</b></p>		
<table width='100%' cellpadding='5' style='font-family: DejaVu Sans, Roboto, Helvetica, sans-serif; font-size: 11px;padding:1px;border:1px solid #A39E9E;border-collapse:collapse;white-space: nowrap;'>
<tr>
<th style='padding-right:10px;text-align:right;background-color:whiteSmoke;border:1px solid #A39E9E;'>LOGIN ID</th>
<th style='padding-right:10px;text-align:right;background-color:whiteSmoke;border:1px solid #A39E9E;border-collapse:collapse;'>ZUID</th>
<th style='padding-right:10px;text-align:right;background-color:whiteSmoke;border:1px solid #A39E9E;'>IP ADDRESS</th>
<th style='padding-right:10px;text-align:right;background-color:whiteSmoke;border:1px solid #A39E9E;'>APP NAME</th>
<th style='padding-right:10px;text-align:right;background-color:whiteSmoke;border:1px solid #A39E9E;'>COUNTRY</th>
<th style='padding-right:10px;text-align:right;background-color:whiteSmoke;border:1px solid #A39E9E;'>ERROR CODE</th>
<th style='padding-right:10px;text-align:center;background-color:whiteSmoke;border:1px solid #A39E9E;'>COUNT</th>
<th style='padding-right:10px;text-align:center;background-color:whiteSmoke;border:1px solid #A39E9E;'>USER AGENT</th>
</tr>
<tr>
<#list table_loginid_weblogin as rows> 
<tr>
<td style='border:1px solid #A39E9E;'>
<#if ((rows.LOGIN_ID)?has_content)>
${rows.LOGIN_ID}
</#if>
</td>
<td style='border:1px solid #A39E9E;'>
<#if ((rows.ZUID)?has_content)>
${rows.ZUID}
</#if>
</td>
<td style='border:1px solid #A39E9E;'>
<#if ((rows.IP_ADDRESS)?has_content)>
${rows.IP_ADDRESS}
</#if>
</td>
<td style='border:1px solid #A39E9E;'>
<#if ((rows.APP_NAME)?has_content)>
${rows.APP_NAME}
</#if>  
</td>
<td style='border:1px solid #A39E9E;'>
<#if ((rows.COUNTRY)?has_content)>
${rows.COUNTRY}
</#if>
</td>
<td style='border:1px solid #A39E9E;'>
<#if ((rows.ERROR_CODE)==1)>NO SUCH USER
<#elseif ((rows.ERROR_CODE)==2)>INVALID PASSWORD
<#elseif ((rows.ERROR_CODE)==3)>USER NOT ACTIVE
<#elseif ((rows.ERROR_CODE)==4)>IP RESTRICTION
<#elseif ((rows.ERROR_CODE)==5)>REGISTRATION NOT ALLOWED
<#elseif ((rows.ERROR_CODE)==6)>REMOTE SERVER ERROR
<#elseif ((rows.ERROR_CODE)==7)>ACCOUNT INACTIVE
<#elseif ((rows.ERROR_CODE)==8)>DISABLED THIRD PARTY SIGNIN
<#elseif ((rows.ERROR_CODE)==9)>Email Doesnot Exist
<#elseif ((rows.ERROR_CODE)==10)>User redirected tosign Up page
</#if>
</td>
<td style='border:1px solid #A39E9E;'>
<#if ((rows.COUNT)?has_content)>
${rows.COUNT}
</#if>
</td>
<td style='border:1px solid #A39E9E;'>
<#if ((rows.USER_AGENT)?has_content)>
${rows.USER_AGENT}
</#if>
</td>
</tr>
</#list>
</tr>
</table>	
</#if>

<#if ((user_signin_verifypassword_content)=="true")>
<br/><p><b style='font-family:open sans,DejaVu Sans'>${USER_FAILURE_DETAILS_VERIFYPASSWORD}:</b></p>		
<table width='100%' cellpadding='5' style='font-family: DejaVu Sans, Roboto, Helvetica, sans-serif; font-size: 11px;padding:1px;border:1px solid #A39E9E;border-collapse:collapse;white-space: nowrap;'>
<tr>
<th style='padding-right:10px;text-align:right;background-color:whiteSmoke;border:1px solid #A39E9E;'>LOGIN ID</th>
<th style='padding-right:10px;text-align:right;background-color:whiteSmoke;border:1px solid #A39E9E;border-collapse:collapse;'>ZUID</th>
<th style='padding-right:10px;text-align:right;background-color:whiteSmoke;border:1px solid #A39E9E;'>IP ADDRESS</th>
<th style='padding-right:10px;text-align:right;background-color:whiteSmoke;border:1px solid #A39E9E;'>APP NAME</th>
<th style='padding-right:10px;text-align:right;background-color:whiteSmoke;border:1px solid #A39E9E;'>COUNTRY</th>
<th style='padding-right:10px;text-align:right;background-color:whiteSmoke;border:1px solid #A39E9E;'>ERROR CODE</th>
<th style='padding-right:10px;text-align:center;background-color:whiteSmoke;border:1px solid #A39E9E;'>COUNT</th>
<th style='padding-right:10px;text-align:center;background-color:whiteSmoke;border:1px solid #A39E9E;'>USER AGENT</th>
</tr>
<tr>
<#list table_loginid_verifypassword as rows> 
<tr>
<td style='border:1px solid #A39E9E;'>
<#if ((rows.LOGIN_ID)?has_content)>
${rows.LOGIN_ID}
</#if>
</td>
<td style='border:1px solid #A39E9E;'>
<#if ((rows.ZUID)?has_content)>
${rows.ZUID}
</#if>
</td>
<td style='border:1px solid #A39E9E;'>
<#if ((rows.IP_ADDRESS)?has_content)>
${rows.IP_ADDRESS}
</#if>
</td>
<td style='border:1px solid #A39E9E;'>
<#if ((rows.APP_NAME)?has_content)>
${rows.APP_NAME}
</#if>  
</td>
<td style='border:1px solid #A39E9E;'>
<#if ((rows.COUNTRY)?has_content)>
${rows.COUNTRY}
</#if>
</td>
<td style='border:1px solid #A39E9E;'>
<#if ((rows.ERROR_CODE)==1)>NO SUCH USER
<#elseif ((rows.ERROR_CODE)==2)>INVALID PASSWORD
<#elseif ((rows.ERROR_CODE)==3)>USER NOT ACTIVE
<#elseif ((rows.ERROR_CODE)==4)>IP RESTRICTION
<#elseif ((rows.ERROR_CODE)==5)>REGISTRATION NOT ALLOWED
<#elseif ((rows.ERROR_CODE)==6)>REMOTE SERVER ERROR
<#elseif ((rows.ERROR_CODE)==7)>ACCOUNT INACTIVE
<#elseif ((rows.ERROR_CODE)==8)>DISABLED THIRD PARTY SIGNIN
<#elseif ((rows.ERROR_CODE)==9)>Email Doesnot Exist
<#elseif ((rows.ERROR_CODE)==10)>User redirected tosign Up page
</#if>
</td>
<td style='border:1px solid #A39E9E;'>
<#if ((rows.COUNT)?has_content)>
${rows.COUNT}
</#if>
</td>
<td style='border:1px solid #A39E9E;'>
<#if ((rows.USER_AGENT)?has_content)>
${rows.USER_AGENT}
</#if>
</td>
</tr>
</#list>
</tr>
</table>	
</#if>

<#if ((user_signin_verify_apppassword_content)=="true")>
<br/><p><b style='font-family:open sans,DejaVu Sans'>${USER_FAILURE_DETAILS_VERIFY_APPPASSWORD}:</b></p>		
<table width='100%' cellpadding='5' style='font-family: DejaVu Sans, Roboto, Helvetica, sans-serif; font-size: 11px;padding:1px;border:1px solid #A39E9E;border-collapse:collapse;white-space: nowrap;'>
<tr>
<th style='padding-right:10px;text-align:right;background-color:whiteSmoke;border:1px solid #A39E9E;'>LOGIN ID</th>
<th style='padding-right:10px;text-align:right;background-color:whiteSmoke;border:1px solid #A39E9E;border-collapse:collapse;'>ZUID</th>
<th style='padding-right:10px;text-align:right;background-color:whiteSmoke;border:1px solid #A39E9E;'>IP ADDRESS</th>
<th style='padding-right:10px;text-align:right;background-color:whiteSmoke;border:1px solid #A39E9E;'>APP NAME</th>
<th style='padding-right:10px;text-align:right;background-color:whiteSmoke;border:1px solid #A39E9E;'>COUNTRY</th>
<th style='padding-right:10px;text-align:right;background-color:whiteSmoke;border:1px solid #A39E9E;'>ERROR CODE</th>
<th style='padding-right:10px;text-align:center;background-color:whiteSmoke;border:1px solid #A39E9E;'>COUNT</th>
<th style='padding-right:10px;text-align:center;background-color:whiteSmoke;border:1px solid #A39E9E;'>USER AGENT</th>
</tr>
<tr>
<#list table_loginid_verifyapppassword as rows> 
<tr>
<td style='border:1px solid #A39E9E;'>
<#if ((rows.LOGIN_ID)?has_content)>
${rows.LOGIN_ID}
</#if>
</td>
<td style='border:1px solid #A39E9E;'>
<#if ((rows.ZUID)?has_content)>
${rows.ZUID}
</#if>
</td>
<td style='border:1px solid #A39E9E;'>
<#if ((rows.IP_ADDRESS)?has_content)>
${rows.IP_ADDRESS}
</#if>
</td>
<td style='border:1px solid #A39E9E;'>
<#if ((rows.APP_NAME)?has_content)>
${rows.APP_NAME}
</#if>  
</td>
<td style='border:1px solid #A39E9E;'>
<#if ((rows.COUNTRY)?has_content)>
${rows.COUNTRY}
</#if>
</td>
<td style='border:1px solid #A39E9E;'>
<#if ((rows.ERROR_CODE)==1)>NO SUCH USER
<#elseif ((rows.ERROR_CODE)==2)>INVALID PASSWORD
<#elseif ((rows.ERROR_CODE)==3)>USER NOT ACTIVE
<#elseif ((rows.ERROR_CODE)==4)>IP RESTRICTION
<#elseif ((rows.ERROR_CODE)==5)>REGISTRATION NOT ALLOWED
<#elseif ((rows.ERROR_CODE)==6)>REMOTE SERVER ERROR
<#elseif ((rows.ERROR_CODE)==7)>ACCOUNT INACTIVE
<#elseif ((rows.ERROR_CODE)==8)>DISABLED THIRD PARTY SIGNIN
<#elseif ((rows.ERROR_CODE)==9)>Email Doesnot Exist
<#elseif ((rows.ERROR_CODE)==10)>User redirected tosign Up page
</#if>
</td>
<td style='border:1px solid #A39E9E;'>
<#if ((rows.COUNT)?has_content)>
${rows.COUNT}
</#if>
</td>
<td style='border:1px solid #A39E9E;'>
<#if ((rows.USER_AGENT)?has_content)>
${rows.USER_AGENT}
</#if>
</td>
</tr>
</#list>
</tr>
</table>	
</#if>