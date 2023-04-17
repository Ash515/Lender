<%--$Id$--%>
<%@page import="com.adventnet.iam.OrgInvitation"%>
<%@page import="com.adventnet.iam.OrgPolicy"%>
<%@page import="com.adventnet.iam.IAMErrorCode"%>
<%@page import="com.adventnet.iam.UserEmail"%>
<%@page import="com.adventnet.iam.Org"%>
<%@page import="com.zoho.accounts.AccountsUtil"%>
<%@page import="com.zoho.accounts.Accounts"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.zoho.resource.Criteria"%>
<%@page import="com.zoho.accounts.AccountsConstants"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.Digest"%>
<%@ include file="../static/includes.jspf" %>
<!DOCTYPE html> <%--No I18N--%>


<%
	String cause = null;
	String digest = request.getParameter("DIGEST");
	String pageSubTitle = "";  String successMsg = ""; 
	String primaryEmail = "";
	String requestURI = (String)request.getAttribute("requestURI");
	String redirectUrl = Util.getIAMURL();
	Long zoid = -1l;
	String btnValue = Util.getI18NMsg(request, "IAM.CONTACTS.ACCEPT"); //No I18N
	OrgInvitation invitation=null;
	Long zuid = -1l;
	Org currentOrg=null;
	String pageSubTile;
	String[] plain = null;
	String org_name = "";
	String contactPerson="";
	User user = null;
	String fromurl="";
	Org org = null;
	boolean isAcceptInvitation =requestURI.equals(request.getContextPath() + "/oia");
		Digest accDigest = Accounts.getDigestURI(AccountsConstants.SYSTEM_SPACE, digest).GET();

		if (accDigest == null || !Util.isValid(accDigest.getArgsData())) 
		{
			cause = "INVALID_DIGEST"; //No I18N
		} 
		else if(System.currentTimeMillis() > accDigest.getExpiryTime()) 
		{
			cause = "EXPIRED_DIGEST"; //No I18N
		}
		else 
		{

			JSONObject jobj = new JSONObject(accDigest.getArgsData());
			if(jobj.has(AccountsConstants.DigestParams.ZOID.dbValue())) 
			{
				zoid = AccountsUtil.getLong(jobj.get(AccountsConstants.DigestParams.ZOID.dbValue())); 
			}
			else if(jobj.has(AccountsConstants.DigestParams.ZAID.dbValue()))
			{
				zoid = AccountsUtil.getLong(jobj.get(AccountsConstants.DigestParams.ZAID.dbValue())); 
			}
			if(jobj.has(AccountsConstants.DigestParams.ZUID.dbValue())) 
			{
				zuid = AccountsUtil.getLong(jobj.get(AccountsConstants.DigestParams.ZUID.dbValue()));
				UserEmail ue = Util.USERAPI.getPrimaryEmail(zuid);
				primaryEmail = ue != null ? ue.getEmailId() : "";
				user = zuid != -1 ? Util.USERAPI.getUser(zuid) : null;
			} 
			else if(jobj.has(AccountsConstants.DigestParams.EMAIL_ID.dbValue()))
			{
				primaryEmail = jobj.getString(AccountsConstants.DigestParams.EMAIL_ID.dbValue());
				user = primaryEmail != null ? Util.USERAPI.getUser(primaryEmail) : null;
				zuid = user != null ? user.getZUID() : -1;
			}
			if(accDigest.getIsValidated()) 
			{
	        	if(user.getZOID() == zoid) 
	        	{
	        		if("/oia".equals(request.getRequestURI()))
	        		{
	        			cause= "ORG_INVITATION_ACCEPTED"; //No I18N 
	        		}
	        		else
	        			cause= "ALREADY_ACCEPTED_REJECTED"; //No I18N
	        	} 
	        	else 
	        	{
	        		cause="ORG_INVITATION_REJECTED";	//No I18N
	        	}
			}

    		org = Util.ORGAPI.getOrg(zoid);
    		org_name = org != null ? org.getDisplayName() : "";
			invitation = user != null && org != null ? Util.ORGAPI.getUserInvitation(zoid, zuid) : null;
    		if (isAcceptInvitation && zoid !=-1) 
    		{
				OrgPolicy policy = Util.ORGAPI.getOrgPolicy(zoid);
				long count = Util.ORGAPI.getOrgUsersCount(zoid);
				if (policy.getMaxAllowedUsers() <= count) 
				{
					cause=IAMException.IAMErrorCode.O116;
					org_name= org.getDisplayName();
					contactPerson =Util.USERAPI.getPrimaryEmail(org.getOrgContact()).getEmailId();
				}
			}
		
			if(isAcceptInvitation && user.getZOID() != -1 && user.getZOID() != zoid) //already in a org
			{
				cause = IAMException.IAMErrorCode.O113;
				currentOrg = Util.ORGAPI.getOrg(user.getZOID());
				boolean isSingleOrgUser = false;
				if (currentOrg.getOrgContact() == user.getZUID()) 
				{
					boolean isorgcontact = true;
					if (Util.ORGAPI.getOrgUsersCount(currentOrg.getZOID()) == 1) 
					{
						isSingleOrgUser = true;
					}
				} 
				else 
				{
					boolean isorgcontact = false;
				}

			}

			fromurl = Util.isFujixerox() ? Util.getRedirectURL(request) : accDigest != null ? accDigest.getServiceUrl() : null;
			fromurl = fromurl == null ? "" : fromurl;
		}
		if (user == null || invitation == null || invitation.getStatus() != OrgInvitation.PENDING) 
		{
			cause = "INVALID_DIGEST"; //No I18N
		}

	if (cause != null) {
		String errorMsgKey = "IAM.ORGINVITATION." + cause; //No I18N
%>



				<%@ include file="orguserinvite_error.jsp" %>


<%
	} else {
		String orgname = Util.isValid(org_name)?IAMEncoder.encodeHTML(org_name):"";
		if(isAcceptInvitation) {
			pageSubTile=Util.getI18NMsg(request, "IAM.ORG.INVITATION.ACCEPT.SUBTITLE.WITH.ORG_NAME",orgname); //No I18N
%>


				<%@ include file="orguserinvite_accept.jsp" %>
<%
		} else {
			btnValue = Util.getI18NMsg(request, "IAM.INVITE.REJECT"); //No I18N
			pageSubTile=Util.getI18NMsg(request, "IAM.ORG.INVITATION.REJECT.QUESTION"); //No I18N
			%>
			<%@ include file="orguserinvite_reject.jsp" %>
			<%
		}
	}
%>
<%-- 
<html>
	<head>
	<%
			String fromurl = Util.isFujixerox() ? Util.getRedirectURL(request) : (String)request.getAttribute("FROM_URL");
    		fromurl = fromurl == null ? "" : fromurl;
    		String callbackURL = (String) request.getAttribute("CALLBACK_URL");
    
    		String requestURI = (String)request.getAttribute("requestURI");
    		String digest = request.getParameter("DIGEST");
    		String org_name = "";
    		String primaryEmail = "";
    		String btnValue = Util.getI18NMsg(request, "IAM.CONTACTS.ACCEPT"); //No I18N
    		Long zoid = -1l;
    		Long zuid = -1l;
    		String[] plain = null;
    			Digest accDigest = Accounts.getDigestURI(AccountsConstants.SYSTEM_SPACE, digest).GET();
				if (accDigest != null) 
				{
		
					if (Util.isValid(accDigest.getArgsData())) 
					{
						JSONObject jobj = new JSONObject(accDigest.getArgsData());
						if(jobj.has(AccountsConstants.DigestParams.ZOID.dbValue())) 
						{
							zoid = AccountsUtil.getLong(jobj.get(AccountsConstants.DigestParams.ZOID.dbValue())); 
						}
						else if(jobj.has(AccountsConstants.DigestParams.ZAID.dbValue())) //No I18N
						{
							zoid = AccountsUtil.getLong(jobj.get(AccountsConstants.DigestParams.ZAID.dbValue())); 
						}
						if(jobj.has(AccountsConstants.DigestParams.ZUID.dbValue())) 
						{
							zuid = AccountsUtil.getLong(jobj.get(AccountsConstants.DigestParams.ZUID.dbValue()));

							UserEmail ue = Util.USERAPI.getPrimaryEmail(zuid);
							
							
							
							primaryEmail = ue != null ? ue.getEmailId() : "";
						} 
						else if(jobj.has(AccountsConstants.DigestParams.EMAIL_ID.dbValue()))
						{
							primaryEmail = jobj.getString(AccountsConstants.DigestParams.EMAIL_ID.dbValue());
						} 
					} 		
				}	
    		if (Util.isValid(primaryEmail)  && zoid != -1) 
    		{
        		Org org = Util.ORGAPI.getOrg(zoid);
        		org_name = org != null ? org.getDisplayName() : "";
   			}
    		if("/oir".equals(requestURI)) 
    		{
				btnValue = Util.getI18NMsg(request, "IAM.INVITE.REJECT"); //No I18N
    		}
    		String orgname = Util.isValid(org_name)?IAMEncoder.encodeHTML(org_name):"";
			String pageSubTile = "/oia".equals(requestURI) ? Util.getI18NMsg(request, "IAM.ORG.INVITATION.ACCEPT.SUBTITLE",orgname) : Util.getI18NMsg(request, "IAM.ORG.INVITATION.REJECT.SUBTITLE"); //No I18N
			if("/noia".equals(requestURI) || "/noir".equals(requestURI)) 
			{
    			pageSubTile = null;
			}
			String cause = request.getAttribute("cause") == null ? null : (String)request.getAttribute("cause");
	%>
 		<title><%=Util.getI18NMsg(request,"IAM.ORGINVITATION.TITLE")%></title> 
    	<link href='https://fonts.googleapis.com/css?family=Open+Sans' rel='stylesheet' type='text/css'>	
    	
 
		<script src="<%=tpkgurl%>/jquery-1.12.2.min.js"></script>
		<script src="<%=jsurl%>/common.js"></script>
		
        <link rel="stylesheet" type="text/css" href="<%=tpkgurl%>/semantic.min.css">
        <script src="<%=tpkgurl%>/semantic.min.js"></script>
		<link href="<%=cssurl%>/SemanticStyle.css" rel="stylesheet"type="text/css"> 
		<meta name="viewport"content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no" />
		
		<script>
		
	    var callbackURL = "<%=IAMEncoder.encodeJavaScript(callbackURL)%>";
	    var autoRedirectToNextURL = <%=IAMUtil.isValid(callbackURL) && (callbackURL.startsWith("http://") || callbackURL.startsWith("https://")) %>;
		$(function() 
		{
				$("input").keyup(function()
				{
					$( ".error_notif" ).remove();
			
				});
		});
	  
		function confirmemail(f) 
	    {
			$( ".error_notif" ).remove();
			try
			{
				if("/oir"==("<%=requestURI%>"))
				{
					var params="DIGEST=<%=IAMEncoder.encodeJavaScript(Util.encode(request.getParameter("DIGEST")))%>&ACTION="+euc('Reject_Request');
					var resp=getPlainResponse("<%=IAMEncoder.encodeJavaScript((String)request.getAttribute("requestURI"))%>",params);
					resp = resp.trim();
				}
				else
				{
					if(f.password.value=="") 
		    		{
		    			$('#password_field').append( '<div class="error_notif"><%=Util.getI18NMsg(request,"IAM.ERROR.PASS.EMPTY")%></div>' );
						f.password.focus();
		    		}
		    		else if(f.password.value!=null) 
		    		{
						var params="DIGEST=<%=IAMEncoder.encodeJavaScript(Util.encode(request.getParameter("DIGEST")))%>&PASSWORD="+euc(f.password.value);
						var resp=getPlainResponse("<%=IAMEncoder.encodeJavaScript((String)request.getAttribute("requestURI"))%>",params);
						resp = resp.trim();
		    		}
				}
					
				if(resp=="WRONG_ACTION")
		    	{
		   			showErrMsg('<%=Util.getI18NMsg(request,"IAM.ERROR.CODE.Z101")%>');
		   		}
				else if(resp=="SUCCESS_ACCEPT_ORG_INVITATION" || resp == "SUCCESS_REJECT_ORG_INVITATION") 
				{
					if (autoRedirectToNextURL) 
					{
						window.location.href = callbackURL;
					} 
					else 
					{	 
						if (resp == "SUCCESS_ACCEPT_ORG_INVITATION") // No I18N
						{
							$('#successconfirm').html('<%=Util.getI18NMsg(request,"IAM.ORG.INVITATION.ACCEPT.SUCCESS")%>');
							$('#msgboard').show();
							$('#confirmdiv').hide();
						}
						else
						{
							$('#successconfirm').html('<%=Util.getI18NMsg(request,"IAM.ORG.INVITATION.REJECT.SUCCESS")%>');
							$('#msgboard').show();
							$('#confirmdiv').hide();
						}
					}
				}					
				else if(resp=="INVALID_PASSWORD") 
				{
						$('#password_field').append( '<div class="error_notif"><%=Util.getI18NMsg(request,"IAM.ERROR.INVALID.CURRENTPASS")%></div>' );
			    		f.password.focus();
				}
				else if(resp)
				{
					showErrMsg(resp.trim());
				}
		    	return false; 
			}
			catch(e) 
			{
				alert(e.message);
			}
			return false;
	    }
	    
		</script>
	
	</head>
	
	<body>
		<div id="height"></div>
	    <div id="error_space">
	    <div class="top_div">
    		<span class="cross_mark">
        		<span class="crossline1"></span>
        		<span class="crossline2"></span> 
    		</span>
    		<span class="top_msg"></span>
    	</div>
    	</div>
		<div class="container">
        	<div id="header">
        		<img class="zoho_logo" src="<%=imgurl%>/zoho.png">   
        	</div>
        	<div class="wrap">  
	<%
	  			if(cause != null && cause.equals(IAMErrorCode.O113)) 
	  			{
		  
		 			Org currentOrg = (Org) request.getAttribute("currentOrg");
		  			String inviteEmail = (String) request.getAttribute("inviteEmail");
	  				String newOrgName = (String) request.getAttribute("ORG");
	%> 
					<div class="info">
        				<div class="head_text"><%=Util.getI18NMsg(request, "IAM.ORG.INVITATION.FAILURE.TITLE")%></div>
        			</div>
	<%
					if(request.getAttribute("isorgcontact") != null && (Boolean) request.getAttribute("isorgcontact")) 
					{
						if(request.getAttribute("isSingleOrgUser") != null && (Boolean) request.getAttribute("isSingleOrgUser")) 
						{
	%>
              				<span>
              					<%=Util.getI18NMsg(request, "IAM.ORG.INVITATION.CONTACT.PERSON.FAILURE.SINGLEUSER", IAMEncoder.encodeHTML(currentOrg.getDisplayName()), IAMEncoder.encodeHTML(newOrgName), IAMEncoder.encodeHTML(inviteEmail))%>
              				</span>
    <%
    					} 
						else 
						{ 
	%>
              				<span>
              					<%=Util.getI18NMsg(request, "IAM.ORG.INVITATION.CONTACT.PERSON.FAILURE", IAMEncoder.encodeHTML(currentOrg.getDisplayName()), IAMEncoder.encodeHTML(newOrgName), IAMEncoder.encodeHTML(inviteEmail))%>
              				</span>
    <%
    					}
					
    				} 
					else 
					{ 
	%>
              				<span>
              					<%=Util.getI18NMsg(request, "IAM.ORG.INVITATION.ALREADY.ORGUSER", IAMEncoder.encodeHTML(currentOrg.getDisplayName()), IAMEncoder.encodeHTML(Util.USERAPI.getPrimaryEmail(currentOrg.getOrgContact()).getEmailId()), IAMEncoder.encodeHTML(newOrgName), IAMEncoder.encodeHTML(inviteEmail))%>
              				</span>
    <%					
    				} 
   				} 
	  			else 
	  			{ 
    %>
        		<div class="info">
        			<div class="head_text"><%=Util.getI18NMsg(request, "IAM.ORGINVITATION.TITLE")%></div>
        		</div>
					
	<%
    			if(cause == null) 
    			{
    %>
    				<div id="confirmdiv">
   <%  						if(pageSubTile != null) 
							{
	%>
								<div class="normal_text" id="page_subtitle"><%=pageSubTile%></div> 
	<% 						}
	%>
					    	<div class="maindiv">
							<form name="confirmpassword" onsubmit="return confirmemail(this);" novalidate method="post">			
	<%
							if("/oia".equals(requestURI)) 
							{
	%>				    
								<div class="ui input">
                    				<input name="username"  value="<%=IAMEncoder.encodeHTML(primaryEmail)%>" required="" readonly>
                    				<span class="bar"></span>
                    				<label class="input_label primary_address_label"><%=Util.getI18NMsg(request, "IAM.EMAIL.PRIMARY.EMAIL")%></label>
                				</div>
								<div class="ui input" id="password_field" style="margin-top: 0px;">
                    				<input name="password"  required="" type="password">
                    				<span class="bar"></span>
                    				<label class="input_label"><%=Util.getI18NMsg(request, "IAM.EMAILCONFIRM.ENTER.PASSWORD")%></label>
                				</div>
                				<a href="<%=cPath%>/password"class="link_forgoticon">
                					<img src="<%=imgurl%>/lock.png" class="forgoticon" >
                				</a>
                				
    <% 
							}
							else
							{
	%>
								<div class="group_list">
		    						<span class="group_list_label"><%=Util.getI18NMsg(request, "IAM.ORGANIZATION.NAME")%> -</span>
               						<span><%=IAMEncoder.encodeHTML(org_name)%></span>
								</div>
								<br />
	<%
							}
	%>
								<button type="submit" class="positive ui button" style="margin-top:0px"><%=btnValue%></button>
						</form>
					    </div>
					</div>

					<div id="msgboard" style="display:none">
    						<span class="normal_text" id="successconfirm"></span> 
   							<a href="<%=IAMEncoder.encodeHTMLAttribute(fromurl)%>"><%=Util.getI18NMsg(request,"IAM.CONFIRMATION.CONTINUE")%></a><%-- NO OUTPUTENCODING --%><%-- 
					</div>
	<% 
    			}
    				else if(cause.equals(IAMErrorCode.O116))
    				{	
    					String org = (String)request.getAttribute("ORG");
    					String contactPerson = (String)request.getAttribute("ORG_CONTACT");
    %>
   								<span><%=Util.getI18NMsg(request,"IAM.ERROR.ORG.MAXUSERS", IAMEncoder.encodeHTML(org), IAMEncoder.encodeHTMLAttribute(contactPerson), IAMEncoder.encodeHTML(contactPerson))%></span>
    <% 
    					
    				}
    				else if(cause.equals("SUCCESS_REJECT_ORG_INVITATION")) 
    				{
    					String orgName = request.getAttribute("orgname") == null ? "" : (String)request.getAttribute("orgname");
    					String signUpURL = null;
    				    if("true".equals(AccountsConfiguration.getConfiguration("redirect.signup.url", "false"))) 
    				    {
    				            signUpURL = request.getContextPath() + "/register"; //No I18N
    				    } 
    				    else 
    				    {
    				            signUpURL = AccountsConfiguration.ACCOUNTS_SERVER.getValue() + "/register"; //No I18N
    				    }
    				  	signUpURL += "?servicename="+ Util.getIAMServiceName() +"&email="+IAMEncoder.encodeHTMLAttribute(Util.encode(request.getAttribute("INVITE_EMAIL") == null ? "" : (String)request.getAttribute("INVITE_EMAIL"))); //No I18N
    %>
    									<div id="msgboard">
            								<span><%=Util.getI18NMsg(request,"IAM.ORGINVITATION.REJECT.SUCCESS", IAMEncoder.encodeHTML(orgName))%></span>
		    								<div class="grpinvlink"><%=Util.getI18NMsg(request,"IAM.GROUP.INVITATION.TXT", signUpURL)%></div>
										</div>
    
    <% 
    				}
    				else 
    				{
    %>
      					<div>
    						<div><%=Util.getI18NMsg(request, "IAM.INVALID.ORG.INVITATION")%></div>    						
    						<span class="signindiv"><a href="<%=IAMEncoder.encodeHTMLAttribute(fromurl)%>"><%=Util.getI18NMsg(request,"IAM.CONFIRMATION.CONTINUE")%></a></span>
						</div>
						<br />
   <%
   					}
				}
	%>
        	</div>
        	<footer id="footer">
				<%@ include file="../unauth/footer.jspf" %>
			</footer>  
    	</div>
	</body>
</html>
--%>