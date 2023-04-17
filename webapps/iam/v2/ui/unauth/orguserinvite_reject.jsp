<%--$Id$--%>
<!DOCTYPE html> <%--No I18N--%>
<html>
				<head>
					<title><%=Util.getI18NMsg(request, "IAM.ORGINVITATION.TITLE")%></title>	
					<script src="<%=cPath%>/accounts-msgs?<%=Util.getErrorQS()%>" type="text/javascript"></script><%-- NO OUTPUTENCODING --%>
			 
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
	        					<div class="head_text"><%=Util.getI18NMsg(request, "IAM.ORGINVITATION.TITLE")%></div>
	        				</div>
	        				<div id="rejectORGInvite">
	<%-- 	    					<form name="confirmpassword" onsubmit="return rejectInvite(this,'<%=IAMEncoder.encodeJavaScript(Util.encode(request.getParameter("DIGEST")))%>','<%=request.getContextPath()%>/g/invitation/reject');"  novalidate method="POST"> --%>
	<%-- 								<div class="normal_text" id="page_subtitle"><%=Util.getI18NMsg(request, "IAM.GRPINVITATION.REJECT.SUBTITLE")%></div>  --%>
	<!-- 										<div class="group_list"> -->
	<%-- 		    								<span class="group_list_label"><%=Util.getI18NMsg(request, "IAM.GROUP.NAME")%> - </span> --%>
	<%-- 		    								<span><%=IAMEncoder.encodeHTML(grp_name)%></span> --%>
	<!-- 										</div> -->
	<!-- 										<br /> -->
	<%-- 		    					<button type="submit" class="positive ui button" style="margin-top:0px"><%=Util.getI18NMsg(request, "IAM.INVITE.REJECT")%></button> --%>
	<!-- 		    				</form> -->
								
	   <%  						if(pageSubTile != null) 
								{
		%>
									<div class="normal_text" id="page_subtitle"><%=pageSubTile%></div> 
		<% 						}
		%>
						    	<div class="maindiv">
								<form name="confirmpassword" onsubmit="return rejectOrgInvite(this,'<%=IAMEncoder.encodeJavaScript(Util.encode(request.getParameter("DIGEST")))%>','<%=request.getContextPath()%>/org/invitation/reject');" novalidate method="post">	
									<div class="group_list">
			    						<span class="group_list_label"><%=Util.getI18NMsg(request, "IAM.ORGANIZATION.NAME")%> -</span>
	               						<span><%=IAMEncoder.encodeHTML(org_name)%></span>
									</div>
									<br />	    
									<button type="submit" class="btn green_btn" style="margin-top:0px"><%=btnValue%></button>
								</form>				
								</div>
							</div>
							<div id="msgboard" style="display:none">
	    						<span class="normal_text" id="success_msg"></span> 
		<% 
	    				if(Util.isValid(fromurl))
	    				{
	    
	    %>
							<div class="signindiv"><a href="<%=IAMEncoder.encodeHTMLAttribute(fromurl)%>"><%=Util.getI18NMsg(request,"IAM.CONFIRMATION.CONTINUE")%></a></div>
		<%
						}
	    %>
						</div>
	     				</div>			
	    			</div>
    			</div>
				<footer id="footer"><%@ include file="../unauth/footer.jspf" %></footer>  
			</body>
			</html>