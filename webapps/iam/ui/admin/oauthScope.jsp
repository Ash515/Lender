<%@page import="com.zoho.accounts.AppResource.RESOURCE.USERSYSTEMROLES"%>
<%@page import="com.zoho.accounts.AppResourceProto.App.AppSystemRole"%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst.ScopeExposedType"%>
<%@page import="com.zoho.accounts.OAuthResource"%>
<%@page import="com.zoho.accounts.AppResourceProto.App.AppSystemRole.UserSystemRoles"%>
<%@page import="com.zoho.resource.URI"%>
<%@page import="com.zoho.accounts.internal.oauth2.OAuthScopeDetails"%>
<%@page import="com.adventnet.iam.OAuthTokenManager.OAuthScopeOperation"%>
<%@page import="com.zoho.accounts.AccountsUtil"%>
<%@page import="com.zoho.accounts.AppResourceProto.App.Scope.SubScopes"%>
<%@page import="com.zoho.accounts.AppResource.RESOURCE.SCOPE"%>
<%@page import="com.zoho.resource.Criteria"%>
<%@page import="com.zoho.accounts.AppResource"%>
<%@page import="com.zoho.accounts.AppResourceProto.App.Scope"%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst"%>
<%@page import="com.zoho.accounts.internal.oauth2.OAuthScope"%>
<%@ include file="../../static/includes.jspf" %>
<%@ include file="includes.jsp"%>
<div class="maincontent">
    <div class="menucontent">
        <div class="topcontent"><div class="contitle">OAuth Scope</div></div> <%--No I18N--%>
	<div class="subtitle">Admin Services</div> <%--No I18N--%>
    </div>
    <div class="field-bg">
        <%
        long userid = IAMUtil.getCurrentUser().getZUID();
        boolean isIAMAdmin = request.isUserInRole("IAMAdmininistrator");
        boolean isOAuthAdmin = request.isUserInRole("OAuthAdmin");
        boolean isIAMServiceAdmin = !isIAMAdmin && request.isUserInRole(Role.IAM_SERVICE_ADMIN);
    	List<String> isUserAllowedServices = new ArrayList<String>(); 
    	if(isIAMServiceAdmin) {
    		AppSystemRole[] appRoles = (AppSystemRole[]) RestProtoUtil.GETS(AppResource.getAppSystemRoleURI(URI.JOIN, Role.IAM_SERVICE_ADMIN).getQueryString().setCriteria(new Criteria(USERSYSTEMROLES.ZUID, userid)).build());
    		if(appRoles != null) {
	    		for (AppSystemRole appRole : appRoles) {//Populate permission enabled services
	    			if(appRole.getParent().getAppName().equalsIgnoreCase(Util.getIAMServiceName())) {
	    				continue;
	    			}
    				isUserAllowedServices.add(appRole.getParent().getAppName().toLowerCase());
	    		}
    		}
    	}
        UserSystemRoles[] usr = null;
    	if(!Util.isDevelopmentSetup()) {
    		usr = AppResource.getUserSystemRolesURI(URI.JOIN,"IAMOAuthScopeViewer",userid).GETS(); //NO I18N
    	}
        String type = request.getParameter("t");
        if("add".equals(type)) {
        	 if(isIAMAdmin || isOAuthAdmin || (Util.isDevelopmentSetup() && isIAMServiceAdmin)){
           	 
        %>
        <form name="addOAuth" class="zform" method="post" onsubmit="return addOAuthScope(this, '');">
	    <div class="labelmain">
	    <div class="initailOauthDiv">
                <div class="labelkey">Service Name :</div>  <%--No I18N--%>
                <div class="labelvalue">
		    <select name="serviceid" class="select select2Div">
		    <option value =''>Select</option>  <%--No I18N--%>
			<%for(Service s: ss){%>
			<%if(Util.isDevelopmentSetup() && isIAMServiceAdmin && !isUserAllowedServices.contains(s.getServiceName().toLowerCase())) { 
					continue;
			 }%>
			<option value='<%=s.getServiceId()%>'><%=IAMEncoder.encodeHTML(s.getServiceName())%></option><%}%> <%--NO OUTPUTENCODING--%>
		    </select>
		</div>
		<div class="labelkey">Scope Name :</div> <%--No I18N--%>
		<div class="labelvalue"><input type="text" class="input" name="scopename"/></div>
		<div class="labelkey">Scope Type :</div>  <%--No I18N--%>
                <div class="labelvalue">
                    <select name="internal" class="select" >
                        <option value="<%=AccountsInternalConst.ScopeType.OAUTH.getScopeAsInt()%>">OAuth</option>  <%-- NO OUTPUTENCODING --%> <%--No I18N--%>
                        <option value="<%=AccountsInternalConst.ScopeType.APIKEY.getScopeAsInt()%>">ApiKey</option> <%-- NO OUTPUTENCODING --%> <%--No I18N--%>
                        <option value="<%=AccountsInternalConst.ScopeType.GROUPSCOPE.getScopeAsInt()%>">GroupScope</option> <%-- NO OUTPUTENCODING --%> <%--No I18N--%>
                        <option value="<%=AccountsInternalConst.ScopeType.OEMBED.getScopeAsInt()%>">OEmbed</option> <%-- NO OUTPUTENCODING --%> <%--No I18N--%>
                    </select>
                </div>
		<div class="labelkey">Description :</div>  <%--No I18N--%>
		<div class="labelvalue"><input type="text" class="input" name="desc"/></div>
		<div class="labelkey">Scope Exposed Type :</div>  <%--No I18N--%>
		<div class="labelvalue">
             <select name="isExposed" class="select" >
                        <option value="<%=ScopeExposedType.EXTERNAL.ordinal()%>">External</option>  <%-- NO OUTPUTENCODING --%> <%--No I18N--%>
                        <option value="<%=ScopeExposedType.INTERNAL.ordinal()%>">Internal</option> <%-- NO OUTPUTENCODING --%> <%--No I18N--%>
                        <option value="<%=ScopeExposedType.RESTRICTED.ordinal()%>">Restricted</option> <%-- NO OUTPUTENCODING --%> <%--No I18N--%>
                    </select>
        </div>
		<div class="labelkey">Operation Type :</div>  <%--No I18N--%>
		<select name="device" class="select" onchange="return changeOperationType(this)" style="height:30px">
			<option value="GENERAL" >GENERAL</option><%--No I18N--%>
        	<option value="CUSTOM">CUSTOM</option><%--No I18N--%>
		</select>
		<div id="custom_select" style="display:none;">
			<div class="labelkey">CUSTOM:</div>  <%--No I18N--%>
			<div class="labelvalue" style="padding:6px 0px;"><input name="custom1" class="check" type="checkbox" ></div>
		</div>
		<div id="general_select" style="">
			<div class="labelkey">READ:</div>  <%--No I18N--%>
			<div class="labelvalue" style="padding:6px 0px;"><input name="read1" class="check" type="checkbox" ></div>
			<div class="labelkey">CREATE:</div>  <%--No I18N--%>
			<div class="labelvalue" style="padding:6px 0px;"><input name="create1" class="check" type="checkbox" ></div>
			<div class="labelkey">UPDATE:</div>  <%--No I18N--%>
			<div class="labelvalue" style="padding:6px 0px;"><input name="update1" class="check" type="checkbox" ></div>
			<div class="labelkey">DELETE:</div>  <%--No I18N--%>
			<div class="labelvalue" style="padding:6px 0px;"><input name="delete1" class="check" type="checkbox" ></div>
		</div>
		<input type="button" class="oauthnext" value="Next" onclick="showOAuthDesc(document.addOAuth)"/>
		</div>
		
		<div class="dessOauth" style="display: none;">

		
		<div class="oauthdescrb"  style="margin-top: 1px;color: #030203;font-size: 15px;padding: 6px 5px 5px 0;text-align: right;width: 30%; font-weight: bold;">
		Description to show to user.  <%--No I18N--%>
		</div>
		<div class="labelkey">IS I18N Keys :</div> <%--No I18N--%>
		<div class="labelvalue"><input type="checkbox" class="input" name="isI18N"/></div>
			<div class="showALL" style="display:none;">
				<div class="labelkey">ALL :</div> <%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="ALL"/></div>
			</div>
			<div class="showWRITE" style="display:none;">
				<div class="labelkey">WRITE :</div> <%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="WRITE"/></div>
			</div>
			<div class="showREAD" style="display:none;">
				<div class="labelkey">READ :</div> <%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="READ"/></div>
			</div>
			<div class="showCREATEUPDATE" style="display:none;">
				<div class="labelkey">CREATE-UPDATE :</div> <%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="CREATEUPDATE"/></div>
			</div>
			<div class="showCREATE" style="display:none;">
				<div class="labelkey">CREATE :</div> <%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="CREATE"/></div>
			</div>
			<div class="showUPDATE" style="display:none;">
				<div class="labelkey">UPDATE :</div> <%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="UPDATE"/></div>
			</div>
			<div class="showDELETE" style="display:none;">
				<div class="labelkey">DELETE :</div> <%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="DELETE"/></div>
			</div>
			<div class="showCustom" style="display:none;">
				<div class="labelkey">CUSTOM :</div> <%--No I18N--%>
				<div class="labelvalue"><input type="text" class="input" name="CUSTOM"/></div>
			</div>
		
		<div class="accbtn Hbtn">
		    <div class="savebtn" onclick="addOAuthScope(document.addOAuth, ''); initSelect2();">
			<span class="btnlt"></span>
			<span class="btnco">Add</span>  <%--No I18N--%>
			<span class="btnrt"></span>
		    </div>
		    <div onclick="loadui('/ui/admin/oauthScope.jsp?t=view'); initSelect2();">
			<span class="btnlt"></span>
			<span class="btnco">Cancel</span>  <%--No I18N--%>
			<span class="btnrt"></span>
		    </div>
		</div>

		<input type="submit" class="hidesubmit" />
		</div>
	    </div>
	</form>
        <%}} else if("view".equals(type)){%>
          <%if(isIAMAdmin || isOAuthAdmin || (isIAMServiceAdmin && Util.isDevelopmentSetup())){
        	  String appname = request.getParameter("sname");
        	  if(appname!= null && isIAMServiceAdmin && !isUserAllowedServices.contains(appname.toLowerCase())) {
        	%>
        	<div class="emptyobjmain">
	    		<dl class="emptyobjdl"><dd><p align="center" class="emptyobjdet"> Not Authorised to view <%=appname %> scopes</p></dd></dl><%-- No I18N --%>
			</div>	  
        	<% return;
        	}
        	%>
        <div class="Hcbtn topbtn">
       	<% if(isIAMAdmin || isOAuthAdmin || (Util.isDevelopmentSetup() && isIAMServiceAdmin)) { %>
	    <div class="addnew" onclick="loadui('/ui/admin/oauthScope.jsp?t=add'); initSelect2();">
		<span class="cbtnlt"></span>
		<span class="cbtnco">Add New</span>  <%--No I18N--%>
		<span class="cbtnrt"></span>
	    </div>
	    <%} %>
	    <form id="scopesearchform" name="scopesearchform" method="post">
	            <div class="labelkey">Service Name :</div>   <%--No I18N--%>
	             <div class="labelvalue">
			<select name="serviceName" class="select select2Div" >
 			<option value="">Select</option>   <%--No I18N--%> 
			<%for(Service s: ss) { %>
			<%if(Util.isDevelopmentSetup() && isIAMServiceAdmin) { 
				if(!isUserAllowedServices.contains(s.getServiceName().toLowerCase())) {
					continue;
				} %>
			<% }%>
			<option value='<%=IAMEncoder.encodeHTMLAttribute(s.getServiceName())%>' <%if (appname!=null && appname.equals(s.getServiceName())) {%> <%="selected"%> <%}%>><%=IAMEncoder.encodeHTML(s.getServiceName())%></option>
			<%} %>
			</select>
	</div>
	     <div class="accbtn Hbtn">
            <div class="savebtn" onclick="getOAuthScopesbasedonService()"><%-- NO OUTPUTENCODING --%>
            <span class="btnlt"></span>
            <span class="btnco">Get Scopes</span> <%--No I18N--%>
            <span class="btnrt"></span>
            </div>
           </div>
           
	</form>
	</div>
	<% } %>
	<%  	  	
	         String servicename = "";
	         String sername = request.getParameter("sname");
	    	 Map<String, OAuthScope> OAuthScopeCache = OAuthScope.getAllOAuthScopeIDvsScope();
            if(OAuthScopeCache != null && !OAuthScopeCache.isEmpty()){
            	 if(usr!=null || sername!=null){
        %>
       
	<div class="apikeyheader" id="headerdiv">
	    <div class="apikeytitle" style="width:18%;">Scope</div>  <%--No I18N--%>
	    <div class="apikeytitle" style="width:16%;">Provider</div>  <%--No I18N--%>
	    <div class="apikeytitle" style="width:10%;">Scope Type</div>  <%--No I18N--%>
	    <div class="apikeytitle">Actions</div> <%--No I18N--%>
	</div>
        <div class="content1" id="overflowdiv">
        <%      }
                Set<String> OAuthKeys = OAuthScopeCache.keySet();
                for(String key : OAuthKeys) {
                	OAuthScope scope = OAuthScopeCache.get(key);
                    if(scope == null) {
                        continue;
                    }

                  if(usr!=null)
                  {
                	  for(UserSystemRoles userRole:usr){
                		    servicename = userRole.getParent().getAppName(); 
                		    if(servicename.equalsIgnoreCase(scope.getAppName()))
                		    {
                  %>
                	  <div class="apikeycontent">
   
                <div class="apikey" style="width:18%;"><%=IAMEncoder.encodeHTML(scope.getScopeName())%></div>
                <div class="apikey" style="width:16%;"><%=IAMEncoder.encodeHTML(scope.getAppName())%></div>
                <div class="apikey" style="width:10%;"><%=scope.getScopeType() == OAuthScope.API_SCOPE ? "ApiScope" : (scope.getScopeType() == OAuthScope.OEMBED_SCOPE ? "OEmbed" : "OAuth") %></div>
     
                <div class="apikey apikeyactionOauth">
                 <div class="savebtn" onclick="loadui('/ui/admin/oauthScope.jsp?t=editdesc&scopeid=<%=IAMEncoder.encodeJavaScript(scope.getGroupID())%>')"> <%-- NO OUTPUTENCODING --%>
                            <span class="cbtnlt"></span>
                            <span class="cbtnco">View Description</span> <%--No I18N--%>
                            <span class="cbtnrt"></span>
                     </div>
                      <% if(scope.isGroupScope()) { %>
                        <div class="savebtn" onclick="loadupdateOAuthSubScope('/ui/admin/oauthScope.jsp?t=editSubscope&scopeid=<%=IAMEncoder.encodeJavaScript(scope.getGroupID())%>'); initSelect2();"> <%-- NO OUTPUTENCODING --%>
                            <span class="cbtnlt"></span>
                            <span class="cbtnco">View SubScope</span> <%--No I18N--%>
                            <span class="cbtnrt"></span>
                        </div>
                        <%  } %>
                     </div>
                     <div class="clrboth">
                     </div>
                     </div>
                 <% } } } else if(sername!=null){
                 if(sername.equalsIgnoreCase(scope.getAppName()))
                		    {%>
                 <div class="apikeycontent">
   
                <div class="apikey" style="width:18%;"><%=IAMEncoder.encodeHTML(scope.getScopeName())%></div>
                <div class="apikey" style="width:16%;"><%=IAMEncoder.encodeHTML(scope.getAppName())%></div>
                <div class="apikey" style="width:10%;"><%=scope.getScopeType() == OAuthScope.API_SCOPE ? "ApiScope" : (scope.getScopeType() == OAuthScope.OEMBED_SCOPE ? "OEmbed" : "OAuth") %></div>
     
                <div class="apikey apikeyactionOauth">
                    <div class="Hbtn">
                        <div class="savebtn" onclick="loadui('/ui/admin/oauthScope.jsp?t=edit&scopeid=<%=scope.getGroupID()%>')"> <%-- NO OUTPUTENCODING --%>
                            <span class="cbtnlt"></span>
                            <span class="cbtnco">Edit</span> <%--No I18N--%>
                            <span class="cbtnrt"></span>
                        </div>
                        <div onclick="deleteOAuthScope('<%=IAMEncoder.encodeJavaScript(scope.getGroupID())%>', '<%=IAMEncoder.encodeJavaScript(scope.getAppName())%>')"> <%-- NO OUTPUTENCODING --%>
                            <span class="cbtnlt"></span>
                            <span class="cbtnco">Delete</span> <%--No I18N--%>
                            <span class="cbtnrt"></span>
                        </div>
                        <div class="savebtn" onclick="loadui('/ui/admin/oauthScope.jsp?t=editdesc&scopeid=<%=IAMEncoder.encodeJavaScript(scope.getGroupID())%>')"> <%-- NO OUTPUTENCODING --%>
                            <span class="cbtnlt"></span>
                            <span class="cbtnco">Edit Description</span> <%--No I18N--%>
                            <span class="cbtnrt"></span>
                        </div>
                        <% if(scope.isGroupScope()) { %>
                        <div class="savebtn" onclick="loadupdateOAuthSubScope('/ui/admin/oauthScope.jsp?t=editSubscope&scopeid=<%=IAMEncoder.encodeJavaScript(scope.getGroupID())%>'); initSelect2();"> <%-- NO OUTPUTENCODING --%>
                            <span class="cbtnlt"></span>
                            <span class="cbtnco">Update SubScope</span> <%--No I18N--%>
                            <span class="cbtnrt"></span>
                        </div>
                        <%  } %>
                    </div>
                </div>
                <div class="clrboth"></div>
            </div>
                <% } }}
        %>
        </div>
        <%
            } else {
        %>
        <div class="emptyobjmain">
	    <dl class="emptyobjdl"><dd><p align="center" class="emptyobjdet">No scope added</p></dd></dl>  <%--No I18N--%>
	</div>
        <%
            }
         } else if("edit".equals(type)) { //No I18N
            String scopeId = request.getParameter("scopeid");
            OAuthScope scope = null;
            if(scopeId == null || (scope = OAuthScope.getOAuthScope(scopeId)) == null) {
        %>
        <div class="emptyobjmain">
            <dl class="emptyobjdl"><dd><p align="center" class="emptyobjdet">No such scope created for requestd scope id <%=IAMEncoder.encodeHTML(scopeId)%></p></dd></dl>  <%--No I18N--%>
        </div>
        <%
            } else {
            	OAuthScope scp  = OAuthScope.getOAuthScope(scopeId);
                String serviceId = scope.getGroupID();
                int internal = scope.getScopeType();
                int allowedOpType = scope.getAllowedOperationType();
        %>
		
        <form name="updateOAuth" class="zform" method="post" onsubmit="return addOAuthScope(this, '<%=IAMEncoder.encodeJavaScript(scope.getGroupID())%>');">
	    <div class="labelmain">
                <div class="labelkey">Service Name :</div>  <%--No I18N--%>
                <div class="labelvalue">
		    <select name="serviceid" class="select select2Div" disabled>
                        <option value="<%=Util.SERVICEAPI.getService(scope.getAppName()).getServiceId()%>"><%=IAMEncoder.encodeHTML(scope.getAppName()) %></option><%-- NO OUTPUTENCODING --%> 
		    </select>
		</div>
		<div class="labelkey">Scope Name :</div>  <%--No I18N--%>
		<div class="labelvalue"><input type="text" class="input" name="scopename" value="<%=IAMEncoder.encodeHTMLAttribute(scope.getScopeName())%>"/></div>
		<div class="labelkey">Scope Type :</div>  <%--No I18N--%>
                <div class="labelvalue">
                    <select name="internal" class="select" disabled="disabled" onchange="changeScopeType(this)">
                        <option value="<%=AccountsInternalConst.ScopeType.OAUTH.getScopeAsInt() %>" <%if(scope.getScopeType() == OAuthScope.SCOPE  ) {%>selected<%}%>>OAuth</option> <%-- NO OUTPUTENCODING --%> <%--No I18N--%>
                        <option value="<%=AccountsInternalConst.ScopeType.APIKEY.getScopeAsInt() %>" <%if(scope.getScopeType() == OAuthScope.API_SCOPE  ) {%>selected<%}%>>ApiKey</option> <%-- NO OUTPUTENCODING --%> <%--No I18N--%>
                        <option value="<%=AccountsInternalConst.ScopeType.GROUPSCOPE.getScopeAsInt() %>" <%if(scope.getScopeType() == OAuthScope.GROUP_SCOPE  ) {%>selected<%}%>>Group Scope</option>  <%-- NO OUTPUTENCODING --%> <%--No I18N--%>
                        <option value="<%=AccountsInternalConst.ScopeType.OEMBED.getScopeAsInt() %>" <%if(scope.getScopeType() == OAuthScope.OEMBED_SCOPE  ) {%>selected<%}%>>OEmbed</option>  <%-- NO OUTPUTENCODING --%> <%--No I18N--%>
                    </select>
                </div>
		<div class="labelkey">Description :</div>  <%--No I18N--%>
		<div class="labelvalue"><input type="text" class="input" name="desc" value="<%=IAMEncoder.encodeHTMLAttribute(scope.getDescription())%>"/></div>
		<div class="labelkey">Scope Exposed Type :</div>  <%--No I18N--%>
		<div class="labelvalue">
             <select name="isExposed" class="select"  value="<%=scope.getScopeExposedType().ordinal()%>">
                        <option value="<%=ScopeExposedType.EXTERNAL.ordinal()%>" <%if(scope.getScopeExposedType().ordinal() ==   ScopeExposedType.EXTERNAL.ordinal()) {%>selected<%}%>>External</option>  <%-- NO OUTPUTENCODING --%> <%--No I18N--%>
                        <option value="<%=ScopeExposedType.INTERNAL.ordinal()%>" <%if(scope.getScopeExposedType().ordinal() ==   ScopeExposedType.INTERNAL.ordinal()) {%>selected<%}%> >Internal</option> <%-- NO OUTPUTENCODING --%> <%--No I18N--%>
                        <option value="<%=ScopeExposedType.RESTRICTED.ordinal()%>" <%if(scope.getScopeExposedType().ordinal() ==   ScopeExposedType.RESTRICTED.ordinal()) {%>selected<%}%>>Restricted</option> <%-- NO OUTPUTENCODING --%> <%--No I18N--%>
                    </select>
        </div>
		<% boolean isCustom= OAuthScopeDetails.isOperationAllowed(allowedOpType, OAuthScopeOperation.CUSTOM);
			for(OAuthScopeOperation op : OAuthScopeOperation.getAllValuesAsList()){
				if(!isCustom && op.getIsOpeartion() && op != OAuthScopeOperation.CUSTOM){
		%>
		<div class="labelkey"><%=IAMEncoder.encodeHTML(op.name())%>:</div>  <%--No I18N--%>
		<div class="labelvalue" style="padding:6px 0px;"><input name="<%=IAMEncoder.encodeHTML(op.name().toLowerCase())%>1" class="check" type="checkbox" <%= OAuthScopeDetails.isOperationAllowed(allowedOpType, op) ? "checked='checked'" : "" %>></div>
		<%		}
			} 
			if(isCustom){
				%>
				<div class="labelkey"><%=IAMEncoder.encodeHTML(OAuthScopeOperation.CUSTOM.name())%>:</div>  <%--No I18N--%>
				<div class="labelvalue" style="padding:6px 0px;"><input name="<%=IAMEncoder.encodeHTML(OAuthScopeOperation.CUSTOM.name().toLowerCase())%>1" class="check" type="checkbox" checked='checked'></div>
				<%
			}
			%>
		</div>
		<div class="accbtn Hbtn">
		    <div class="savebtn" onclick="addOAuthScope(document.updateOAuth, '<%=IAMEncoder.encodeJavaScript(scope.getGroupID())%>'); initSelect2();">
			<span class="btnlt"></span>
			<span class="btnco">Update</span>  <%--No I18N--%>
			<span class="btnrt"></span>
		    </div>
		    <div onclick="loadui('/ui/admin/oauthScope.jsp?t=view'); initSelect2();">
			<span class="btnlt"></span>
			<span class="btnco">Cancel</span>  <%--No I18N--%>
			<span class="btnrt"></span>
		    </div>
		</div>
		<input type="submit" class="hidesubmit" />
	</form>
        <%
            }
        } else if("editdesc".equals(type)) { //No I18N
            String scopeId = request.getParameter("scopeid");
            OAuthScope scope = null;
            if(scopeId == null || (scope = OAuthScope.getOAuthScope(scopeId)) == null) {
        %>
        <div class="emptyobjmain">
            <dl class="emptyobjdl"><dd><p align="center" class="emptyobjdet">No such scope created for requestd scope id <%=IAMEncoder.encodeHTML(scopeId)%></p></dd></dl>  <%--No I18N--%>
        </div>
        <%
            } else {
                int serviceId = Util.SERVICEAPI.getService(scope.getAppName()).getServiceId();
                int internal = scope.getScopeType();
                int allowedOpType = scope.getAllowedOperationType();
        %>
        <form name="updateOAuth" class="zform" method="post" onsubmit="return updateOAuthDesc(this, '<%=serviceId%>', '<%=IAMEncoder.encodeJavaScript(scope.getGroupID())%>');">
        <div>
        <%if(OAuthScopeDetails.isOperationAllowed(allowedOpType, OAuthScopeOperation.ALL)){ %>
	    <div class="labelkey">ALL :</div>  <%--No I18N--%>
		<div class="labelvalue"><input type="text" class="input" name="ALL" value="<%= scope.getDescription("ALL") != null ? IAMEncoder.encodeHTML(scope.getDescription("ALL").getDescription()) : "" %>"/></div>
		<%}if(OAuthScopeDetails.isOperationAllowed(allowedOpType, OAuthScopeOperation.WRITE)){ %>
		<div class="labelkey">WRITE :</div> <%--No I18N--%>
		<div class="labelvalue"><input type="text" class="input" name="WRITE" value="<%=  scope.getDescription("WRITE") != null ? IAMEncoder.encodeHTML(scope.getDescription("WRITE").getDescription()) : "" %>"/></div>
		<%}if(OAuthScopeDetails.isOperationAllowed(allowedOpType, OAuthScopeOperation.READ)){ %>
		<div class="labelkey">READ :</div> <%--No I18N--%>
		<div class="labelvalue"><input type="text" class="input" name="READ" value="<%=  scope.getDescription("READ") != null ?IAMEncoder.encodeHTML(scope.getDescription("READ").getDescription()) : "" %>"/></div>
		<%}if(OAuthScopeDetails.isOperationAllowed(allowedOpType, OAuthScopeOperation.CREATE) && OAuthScopeDetails.isOperationAllowed(allowedOpType, OAuthScopeOperation.UPDATE)){ %>
		<div class="labelkey">CREATE-UPDATE :</div> <%--No I18N--%>
		<div class="labelvalue"><input type="text" class="input" name="CREATEUPDATE" value="<%=  scope.getDescription("CREATE-UPDATE") != null ? IAMEncoder.encodeHTML(scope.getDescription("CREATE-UPDATE").getDescription()) : "" %>"/></div>
		<%}if(OAuthScopeDetails.isOperationAllowed(allowedOpType, OAuthScopeOperation.CREATE)){ %>
		<div class="labelkey">CREATE :</div> <%--No I18N--%>
		<div class="labelvalue"><input type="text" class="input" name="CREATE" value="<%=  scope.getDescription("CREATE") != null ? IAMEncoder.encodeHTML(scope.getDescription("CREATE").getDescription())  : "" %>"/></div>
		<%}if(OAuthScopeDetails.isOperationAllowed(allowedOpType, OAuthScopeOperation.UPDATE)){ %>
		<div class="labelkey">UPDATE :</div> <%--No I18N--%>
		<div class="labelvalue"><input type="text" class="input" name="UPDATE" value="<%= scope.getDescription("UPDATE") != null ? IAMEncoder.encodeHTML(scope.getDescription("UPDATE").getDescription())  : "" %>"/></div>
		<%}if(OAuthScopeDetails.isOperationAllowed(allowedOpType, OAuthScopeOperation.DELETE)){ %>
		<div class="labelkey">DELETE :</div> <%--No I18N--%>
		<div class="labelvalue"><input type="text" class="input" name="DELETE" value="<%=  scope.getDescription("DELETE") != null ? IAMEncoder.encodeHTML(scope.getDescription("DELETE").getDescription()) : "" %>"/></div>
		<%}if(OAuthScopeDetails.isOperationAllowed(allowedOpType, OAuthScopeOperation.CUSTOM)){ %>
		<div class="labelkey">CUSTOM :</div> <%--No I18N--%>
		<div class="labelvalue"><input type="text" class="input" name="CUSTOM" value="<%=  scope.getDescription("CUSTOM") != null ? IAMEncoder.encodeHTML(scope.getDescription("CUSTOM").getDescription()) : "" %>"/></div>
		<%} %>
		<div class="accbtn Hbtn">
		       <%if(isIAMAdmin || isOAuthAdmin || (isIAMServiceAdmin && Util.isDevelopmentSetup())){ %>
		    <div class="savebtn" onclick="updateOAuthDesc(document.updateOAuth, '<%=serviceId%>', '<%=IAMEncoder.encodeJavaScript(scope.getGroupID())%>'); initSelect2();">
			<span class="btnlt"></span>
			<span class="btnco">Update</span>  <%--No I18N--%>
			<span class="btnrt"></span>
		    </div>
		    <%}%>
		    <div onclick="loadui('/ui/admin/oauthScope.jsp?t=view'); initSelect2();">
			<span class="btnlt"></span>
			<span class="btnco">Cancel</span>  <%--No I18N--%>
			<span class="btnrt"></span>
		    </div>
		</div>
		<input type="submit" class="hidesubmit" />
	    </div>
	</form>
        <%
            }
        } else if("editSubscope".equals(type)) { //No I18N
            String scopeId = request.getParameter("scopeid");
            OAuthScope scope = null;
            if(scopeId == null || (scope = OAuthScope.getOAuthScope(scopeId)) == null) {
        %>
        <div class="emptyobjmain">
            <dl class="emptyobjdl"><dd><p align="center" class="emptyobjdet">No such scope created for requestd scope id <%=IAMEncoder.encodeHTML(scopeId)%></p></dd></dl>  <%--No I18N--%>
        </div>
        <%
            } else {
                String serviceName = scope.getAppName();
                Scope[] oAuthScopes =  AppResource.getScopeURI(serviceName).getQueryString().setCriteria(new Criteria(SCOPE.INTERNAL, AccountsInternalConst.ScopeType.OAUTH.getScopeAsInt())).build().GETS();
                SubScopes[] curScopes =  AppResource.getSubScopesURI(serviceName, scope.getGroupID()).GETS();
                List<String> cuelLis = new ArrayList<String>();
                if(curScopes != null) {
                	for(SubScopes s : curScopes) {
                		cuelLis.add(s.getScopeId());
                	}
                }
                if(oAuthScopes == null || scope.getScopeType() !=  OAuthScope.GROUP_SCOPE) {
        %>
        	No OAuth scope defined.   <%--No I18N--%>
        <%
                } else {
        
        %>
        <div class="labelkey">Scope Name :</div>  <%--No I18N--%>
		<div class="labelvalue"><input type="text" class="input" name="ALL" value="<%=IAMEncoder.encodeHTMLAttribute( scope.getScopeName())%>" disabled="disabled"/></div>
		<div class="labelkey">Sub Scopes :</div>  <%--No I18N--%>
		<div class="labelvalue">
        <form name="updateOAuthSubScopefrm" class="zform" method="post" onsubmit="return updateOAuthSubScope(this, '<%=IAMEncoder.encodeJavaScript(serviceName)%>', '<%=IAMEncoder.encodeJavaScript(scope.getGroupID())%>');">
        <div style="width:500px; ">
        <div style="width:500px;">
         <select name="subIds" data-placeholder="Select Sub scopes" style="width:100%;" class="select2Div labelvalue" multiple tabindex="6">
          
        <% for(Scope s : oAuthScopes) {if(s.getExposed() <= ScopeExposedType.INTERNAL.getPriority() ){%>
        <option value="<%=IAMEncoder.encodeHTMLAttribute(s.getScopeId())%>" <%= cuelLis.contains(s.getScopeId()) ? "selected" : ""%> ><%=IAMEncoder.encodeHTMLAttribute(s.getScope()) %></option>
		<% } }%>
		</select>
		</div>
		<div class="accbtn Hbtn">
		     <%if(isIAMAdmin || isOAuthAdmin || (isIAMServiceAdmin && Util.isDevelopmentSetup())){ %>
		    <div class="savebtn" onclick="updateOAuthSubScope(document.updateOAuthSubScopefrm, '<%=IAMEncoder.encodeJavaScript(serviceName)%>', '<%=IAMEncoder.encodeJavaScript(scope.getGroupID())%>'); initSelect2();">
			<span class="btnlt"></span>
			<span class="btnco">Update</span>  <%--No I18N--%>
			<span class="btnrt"></span>
		    </div>
		    <%}%>
		    <div onclick="loadui('/ui/admin/oauthScope.jsp?t=view'); initSelect2();">
			<span class="btnlt"></span>
			<span class="btnco">Cancel</span>  <%--No I18N--%>
			<span class="btnrt"></span>
		    </div>
		</div>
		<input type="submit" class="hidesubmit" />
	    </div>
	</form>	
	</div>
	<div id="invalidsubscope" style="display: none; width: 500px; margin-left:25%; margin-top:5%;">
	    <div>
			<b class="mrptop outbg"><b class="mrp1"></b><b class="mrp2"></b><b class="mrp3"></b><b class="mrp4"></b></b>
		</div>	
		<div class="mrpheader">
			<span class="close" onclick="invalidsubscopeform('hide')"></span> <span><font size="2">Invalid subscopes</font></span> <%--No I18N--%>
		</div>
		<div class="mprcontent">
		    <div>
				<b class="mrptop inbg"><b class="mrp2"></b><b class="mrp3"></b><b class="mrp4"></b></b>
			</div>
			<div class="mrpcontentdiv" style="height:50px;">
			<span id="invalidsubscopelist">
			</span>
             <div class="mrpBtn">
			 <input type="button" value="OK" onclick="invalidsubscopeform('hide')" />
			</div>
			</div>		
			<div>
			<b class="mrpbot inbg"><b class="mrp4"></b><b class="mrp3"></b><b class="mrp2"></b><b class="mrp1"></b></b>
		    </div> 
		</div>
		<div>
			<b class="mrpbot outbg"><b class="mrp4"></b><b class="mrp3"></b><b class="mrp2"></b><b class="mrp1"></b></b>
		</div>	
	</div>
        <%
                }
                }
        }
        %>
    </div>
</div>