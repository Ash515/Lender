<%-- $Id: $ --%>
<%@page import="com.zoho.accounts.internal.oauth2.OAuth2Util"%>
<%@page import="com.zoho.accounts.dcl.DCLUtil"%>
<%@ include file="includes.jsp"%> 
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@page import="com.zoho.accounts.SystemResourceProto.DCLocation"%>
<HTML>     
<body>
<div class="maincontent">
    <div class="menucontent">
		<div class="topcontent" style="border-bottom:1px solid #dfdfdf"><div class="contitle">Operations on Client ID</div></div>	<%--No I18N--%>
    </div> 
	<div class="field-bg">	
	<div class="restorelink">  <%--No I18N--%>
            <a href="javascript:;" id="dolink" onclick="showclientform(this, true)" class="disablerslink">Client ID Creation</a>  / <%--No I18N--%>  
            <a href="javascript:;" id="dufolink" onclick="showclientform(this, false)" class="activerslink">Client ID Deletion</a><%--No I18N--%>
        </div>
		<form id="clientidcreationform" name="clientidcreationform" method="post">
			<div class="labelmain">
				<div class="labelkey">Client Type :</div>	<%--No I18N--%>
				<div class="labelvalue">
					<select name="clienttype" onchange="showId(this)">					
						<option value=<%=IAMEncoder.encodeHTML(OAuth2Util.OAuthAppGroup.OAUTH_INTERNAL.getOAuthAppGroupID())%>>USER-BASED</option>	<%--No I18N--%>		
						<option value=<%=IAMEncoder.encodeHTML(OAuth2Util.OAuthAppGroup.OAUTH_ORG.getOAuthAppGroupID())%>>ORG-BASED</option>	<%--No I18N--%>
						<option value=<%=IAMEncoder.encodeHTML(OAuth2Util.OAuthAppGroup.OAUTH_DEVICE.getOAuthAppGroupID())%>>DEVICE-BASED</option> <%--No I18N--%>
					</select>
				</div>			
				<div id="hiddenDiv1">
				<div class="labelkey">Sub Type :</div>	<%--No I18N--%>
				<div class="labelvalue">
					<select name="clientsubtype" >					
						<option value="1">OAuth</option>	<%--No I18N--%>		
						<option value="2">ApiKey</option>	<%--No I18N--%>
					</select>
				</div>
				</div>
				<div>
				<div class="labelkey">Enter Client Name : </div>	<%--No I18N--%>
				<div class="labelvalue">
					<input type="text" size="20" name="clientname" id="clientname" maxlength="200"/>
				</div>
			</div>
			<div>
				<div class="labelkey">Enter Client Scopes : </div>	<%--No I18N--%>
				<div class="labelvalue">
					<textarea style="font-size:10px;" name="clientscopes" rows="5" cols="50" placeholder="eg: servicename.scopename.operation_type <comma-separated><no-white-spaces-allowed>"></textarea> <%--No I18N--%>
				</div>
			</div>
			<div>
				<div class="labelkey">Enter Admin Password : </div>	<%--No I18N--%>
				<div class="labelvalue">
					<input type="password" name="password1" id="password1"/>
				</div>
			</div>
			<div id="hiddenDiv3" style="display:none;"> 
				<div class="labelkey">Is MultiDC  :</div>   <%--No I18N--%>
			    <div class="labelvalue">	
			     <div id="cb">
			     <% String currentloc = IAMEncoder.encodeHTML(DCLUtil.getLocation());
			    int setup = 0 ;
			    String md= "MultiDCSupport"; //NO I18N
			    Collection<DCLocation> locations = DCLUtil.getLocationList();
			    DCLocation presentLocation = DCLUtil.getPresentLocation();
			    if(locations != null && presentLocation != null ){
			    for(DCLocation location : locations){
			    	if(!presentLocation.getLocation().equals(location.getLocation())){		   	    	
			   	        %>
			     <% 
			    	setup = setup + 1;	
				    String dcvalue = md + setup;	
			    %>	 
			         <input type="checkbox" class="check" id=<%=IAMEncoder.encodeHTML(dcvalue)%> value=<%=IAMEncoder.encodeHTML(location.getLocation())%> /> <%=IAMEncoder.encodeHTML(location.getLocation())%>  <!-- No I18N -->    
			     <%
			    	}
			    }
			    }
			      %>
			        </div>     
			    </div>
			    </div>
			    <div>
			    <div class="labelkey"></div>
				<div class="labelvalue"> 
					<input type="button" id="submitbutton1" value="Send" style="height:30px;width:70px;background-color:green" onclick="validateinputstogenerateclientid('<%=setup%>','<%=currentloc%>')"/>
				</div>
				</div>
			 
		<div id="jsonresponse">
		<div class="labelkey">Response: </div>	<%--No I18N--%>
		<div class="labelvalue">
			<textarea id="addclientId" readonly style="font-size:10px;background-color:#BDBDBD" name="response" rows="10" cols="50">		
			</textarea>
		</div>
	    </div>
			</div>
		</form>
		<form id="deleteclient" method="post" style="display: none;">
		<div class="labelkey">Enter Client ID</div>  <%--No I18N--%>
		        <div class="labelvalue">
					<input type="text" size="20" name="clientid" id="clientid" maxlength="200" />
				</div>
				<div class="labelkey">Is System Space:</div>	<%--No I18N--%>
				<div class="labelvalue">
					<input type="checkbox" class="check" name="isSystemSpace"/>
				</div>
		<div class="labelkey">Enter Admin Password : </div>	 <%--No I18N--%>
				<div class="labelvalue">
					<input type="password" name="password2" id="password2"/>
				</div>
				<div>
				<div class="labelkey"></div>
				<div class="labelvalue"> 
					<input type="button" id="submitbutton2" value="Send" style="height:30px;width:70px;background-color:green" onclick="deleteclientid()"/>
				</div>
			</div>
		<div id="clientresponse">
		<div class="labelkey">Response: </div>  <%--No I18N--%>
		<div class="labelvalue">
			<textarea id="deleteclientId" readonly style="font-size:10px;background-color:#BDBDBD" name="response" rows="10" cols="50"></textarea>
		</div>
	   </div>
		</form>
		
	
		
	</div>
</div>
</body>
</HTML>