<%--$Id$--%>
<!DOCTYPE html> <%--No I18N--%>
<%@page import="com.adventnet.iam.internal.Util"%>
<%@page import="com.adventnet.iam.IAMErrorCode"%>
<html>
	<head>
		<title><%=Util.getI18NMsg(request, "IAM.ORGINVITATION.TITLE")%></title>

 
		<script src="<%=tpkgurl%>/jquery-3_5_1.min.js"></script>
		<script src="<%=jsurl%>/common_unauth.js"></script>
		<link href="<%=cssurl%>/accountUnauthStyle.css" rel="stylesheet"type="text/css">  		

		<meta name="viewport"content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no" />
	</head>
	<body>
		<div class="grp_invite_bg"></div>
		<div style="overflow:auto">
			<div class="container">
	        	<div id="header">
	        		<img class="zoho_logo" src="<%=imgurl%>/zoho.png">   
	        	</div>
	        	<div class="wrap"> 
	
	        	
	        	
	
						<div class="info">
	        				<div class="head_text"><%=Util.getI18NMsg(request, "IAM.ORG.INVITATION.FAILURE.CANNOT.ACCEPT.TITLE")%></div>
	        			</div>
		<%
		  			if(cause.equals(IAMException.IAMErrorCode.O113)) 
		  			{
						if(request.getAttribute("isorgcontact") != null && (Boolean) request.getAttribute("isorgcontact")) 
						{
							if(request.getAttribute("isSingleOrgUser") != null && (Boolean) request.getAttribute("isSingleOrgUser")) 
							{
		%>
	              				<span>
	              					<%=Util.getI18NMsg(request, "IAM.ORG.INVITATION.CONTACT.PERSON.FAILURE.SINGLEUSER.ALREADY.REGISTERED", IAMEncoder.encodeHTML(currentOrg.getDisplayName()), IAMEncoder.encodeHTML(org_name), IAMEncoder.encodeHTML(primaryEmail))%>
	              				</span>
	    <%
	    					} 
							else 
							{ 
		%>
	              				<span>
	              					<%=Util.getI18NMsg(request, "IAM.ORG.INVITATION.CONTACT.PERSON.FAILURE.ALREADY.REGISTERED", IAMEncoder.encodeHTML(currentOrg.getDisplayName()), IAMEncoder.encodeHTML(org_name), IAMEncoder.encodeHTML(primaryEmail))%>
	              				</span>
	    <%
	    					}
						
	    				} 
						else 
						{ 
		%>
	              				<span>
	              					<%=Util.getI18NMsg(request, "IAM.ORG.INVITATION.ALREADY.ORGUSER.CONTACT.ADMIN", IAMEncoder.encodeHTML(currentOrg.getDisplayName()), IAMEncoder.encodeHTML(Util.USERAPI.getPrimaryEmail(currentOrg.getOrgContact()).getEmailId()), IAMEncoder.encodeHTML(org_name), IAMEncoder.encodeHTML(primaryEmail))%>
	              				</span>
	    <%					
	    				} 
	   				}
		  			else if(cause.equals(IAMException.IAMErrorCode.O116))
					{	
		%>
									<span><%=Util.getI18NMsg(request,"IAM.ORG.ERROR.MAXUSERS", IAMEncoder.encodeHTML(org_name), IAMEncoder.encodeHTMLAttribute(contactPerson), IAMEncoder.encodeHTML(contactPerson))%></span>
		<% 
						
					}  
		  			else 
					{	
		%>
	
			      		<div id="msgboard">
	        				<div class="normal_text"><%=Util.getI18NMsg(request, errorMsgKey) %></div>
	    <% 
	    				if(Util.isValid(fromurl))
	    				{
	    
	    %>
							<div class="signindiv"><a style="text-decoration:none;color:#159AFF;" href="<%=IAMEncoder.encodeHTMLAttribute(fromurl)%>"><%=Util.getI18NMsg(request,"IAM.CONFIRMATION.CONTINUE")%></a></div>
		<%
						}
	    %>
	            	   		</div>
						<br />
	    <%
					}
		%>
	
	     		</div>			
	    	</div>
				<footer id="footer"><%@ include file="../unauth/footer.jspf" %></footer>  <%--No I18N--%>
	</body>
</html>