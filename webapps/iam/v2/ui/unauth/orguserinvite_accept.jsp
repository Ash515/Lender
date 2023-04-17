<%--$Id$--%>
<!DOCTYPE html> <%--No I18N--%>
		<html>
			<head>
				<title><%=Util.getI18NMsg(request, "IAM.ORGINVITATION.TITLE")%></title>

 			<script src="<%=cPath%>/accounts-msgs?<%=Util.getErrorQS()%>" type="text/javascript"></script><%-- NO OUTPUTENCODING --%>
 				
				<script src="<%=tpkgurl%>/jquery-3_5_1.min.js"></script>	
				<script src="<%=jsurl%>/common_unauth.js"></script>
				<link href="<%=cssurl%>/accountUnauthStyle.css" rel="stylesheet"type="text/css">  t>
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
        				
        				
        				
<!--         				<div id="acceptGroupInvite"> -->
<%-- 	    					<form name="confirmpassword" onsubmit="return acceptInvite(this,'<%=IAMEncoder.encodeJavaScript(Util.encode(request.getParameter("DIGEST")))%>','<%=request.getContextPath()%>/g/invitation/accept');"  novalidate method="POST"> --%>
<%-- 								<div class="normal_text" id="page_subtitle"><%=Util.getI18NMsg(request,"IAM.GRPINVITATION.ACCEPT.SUBTITLE",grpname)%></div>  --%>
<!-- 										<div class="group_list"> -->
<%-- 		    								<div class="group_list_label"><%=Util.getI18NMsg(request, "IAM.GROUP.DECRIPTION")%> - </div> --%>
<%-- 		    								<div><%=IAMEncoder.encodeHTML(groupDesc)%></div> --%>
<!-- 										</div> -->
<!-- 										<br /> -->
								
<!-- 										<div class="ui input"> -->
<%--                     						<input name="username"  value="<%=IAMEncoder.encodeHTML(primaryEmail)%>" required="" readonly> --%>
<!--                     						<span class="bar"></span> -->
<%--                     						<label class="input_label primary_address_label"><%=Util.getI18NMsg(request, "IAM.EMAIL.PRIMARY.EMAIL")%></label> --%>
<!--                 						</div> -->
								
<!-- 										<div class="ui input" id="password_field" style="margin-top: 0px;"> -->
<!--                     						<input name="password"  required="" type="password"> -->
<!--                     						<span class="bar"></span> -->
<%--                     						<label class="input_label"><%=Util.getI18NMsg(request, "IAM.EMAILCONFIRM.ENTER.PASSWORD")%></label> --%>
<!--                 						</div> -->
<%--                 				<a href="<%=cPath%>/password?serviceurl=<%=IAMEncoder.encodeHTMLAttribute(Util.encode(redirectUrl))%>"class="link_forgoticon"> --%>
<%--                 					<img src="<%=imgurl%>/lock.png" class="forgoticon" > --%>
<!--                 				</a> -->
<%-- 		    				<button type="submit" class="positive ui button" style="margin-top:0px"><%=IAMEncoder.encodeHTMLAttribute(Util.getI18NMsg(request, "IAM.CONTACTS.ACCEPT"))%></button> --%>
<!-- 		    			</form> -->
	    				
<!-- 						</div> -->
						
						
						<div id="acceptORGInvite">
    <%  					if(pageSubTile != null) 
							{
	%>
								<div class="normal_text" id="page_subtitle"><%=pageSubTile%></div> 
	<% 						}
	%>
					    	<div class="maindiv">
							<form name="confirmpassword" onsubmit="return acceptOrgInvite(this,'<%=IAMEncoder.encodeJavaScript(Util.encode(request.getParameter("DIGEST")))%>','<%=request.getContextPath()%>/org/invitation/accept');"novalidate method="post">			

								<div class="ui input">
                    				<input name="username"  value="<%=IAMEncoder.encodeHTML(primaryEmail)%>" required="" readonly>
                    				<span class="bar"></span>
                    				<label class="input_label primary_address_label"><%=Util.getI18NMsg(request, "IAM.EMAIL.PRIMARY.EMAIL")%></label>
                				</div>
								<div class="ui input" id="password_field" style="margin-top: 0px;">
                    				<input name="password"  required="" type="password">
                    				<span class="bar"></span>
                    				<label class="input_label"><%=Util.getI18NMsg(request, "IAM.EMAILCONFIRM.ENTER.PASSWORD.TEXT")%></label>
                				</div>
                				<a href="<%=cPath%>/password"class="link_forgoticon">
                					<img src="<%=imgurl%>/lock.png" class="forgoticon" >
                				</a>
                				

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
			<footer id="footer"><%@ include file="../unauth/footer.jspf" %></footer>  <%--No I18N--%>
			</body>
		</html>