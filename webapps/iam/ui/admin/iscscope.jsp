<%-- $Id$ --%>
<%@ include file="../../static/includes.jspf" %>
<%@ include file="includes.jsp"%>
<div class="maincontent">
    <div class="menucontent">
        <div class="topcontent"><div class="contitle">ISCScope</div></div>
	<div class="subtitle">Admin Services</div>
    </div>
    <div class="field-bg">
        <%
        String type = request.getParameter("t"); //NO I18N
        if("add".equals(type)) { //No I18N        	
        	if("false".equals(AccountsConfiguration.getConfiguration("enable.iscscope.registration","false"))){%>       	
        	
        	<div style="margin-left: 10px;" onclick="loadui('/ui/admin/iscscope.jsp?t=view')">
				<span class="btnlt"></span>
				<span class="btnco">Back</span>
				<span class="btnrt"></span>
		    </div>
        	<div class="labelmain">
                <div style="font-size: 15px;text-align: center;margin-top: 20px;">Authtoken and ISC scopes are no more supported. User <a style="font-size: 16px;font-weight: bold; cursor: pointer; color: blue;" onclick="loadPage('oauth_scope','/ui/admin/oauthScope.jsp?t=view')">OAuth scopes</a></div> <%-- NO I18N --%>		    
			</div>			
        <%       
            }else{
        %>
        <form name="addISC" class="zform" method="post" onsubmit="return addISCScope(this, '');">
	    <div class="labelmain">
                <div class="labelkey">Service Name :</div>
                <div class="labelvalue">
		    <select name="serviceid" class="select">
			<%for(Service s: ss){%><option value='<%=s.getServiceId()%>'><%=IAMEncoder.encodeHTML(s.getServiceName())%></option><%}%> <%-- NO OUTPUTENCODING --%>
		    </select>
		</div>
		<div class="labelkey">Scope Name :</div>
		<div class="labelvalue"><input type="text" class="input" name="scopename"/></div>
		<div class="labelkey">Scope Type :</div>
                <div class="labelvalue">
                    <select name="internal" class="select" onchange="changeScopeType(this)">
                        <option value="1">ISCScope</option>
                        <option value="0">AuthToken</option>
                        <option value="2">OAuth</option>
                    </select>
                </div>
		<div class="labelkey" id ="parentscope">Parent Scope Name :</div>
                <div class="labelvalue">
			<%
                        String iscscopesstr = "<option value=\"-1\">Unassigned</option>";
                        String authtokensstr = "<option value=\"-1\">Unassigned</option>";
                        Map<Integer, ISCScope> iscScopeCache = CSPersistenceAPIImpl.getIDToISCScopeCache();
                        if(iscScopeCache != null && !iscScopeCache.isEmpty()) {
                            Set<Integer> iscKeys = iscScopeCache.keySet();
                            ServiceAPI sapi = Util.SERVICEAPI;
                            for(int key : iscKeys) {
                                ISCScope tmpScope = iscScopeCache.get(key);
                                if(tmpScope == null) {
                                    continue;
                                }
                                String tmpSname = tmpScope.serviceID != -1 ? sapi.getService(tmpScope.serviceID).getServiceName() + " service" : "All services";
                                String scopeVal = tmpScope.scope + " for " + tmpSname;
                                if(tmpScope.internal) {
                                    iscscopesstr += "<option value=\""+tmpScope.scopeID+"\">" + IAMEncoder.encodeHTML(scopeVal) + "</option>";
                                } else {
                                    authtokensstr += "<option value=\""+tmpScope.scopeID+"\">" + IAMEncoder.encodeHTML(scopeVal) + "</option>";
                                }
                            }
                        }
                        %>
		    <select name="parentiscscope" id="parentiscscope" class="select"><%=iscscopesstr%></select> <%-- NO OUTPUTENCODING --%>
		    <select name="parentauthtoken" id="parentauthtoken" style="display:none;" class="select"><%=authtokensstr%></select> <%-- NO OUTPUTENCODING --%>
		</div>
		<div class="labelkey">Description :</div>
		<div class="labelvalue"><input type="text" class="input" name="desc"/></div>
		<div class="accbtn Hbtn">
		    <div class="savebtn" onclick="addISCScope(document.addISC, '')">
			<span class="btnlt"></span>
			<span class="btnco">Add</span>
			<span class="btnrt"></span>
		    </div>
		    <div onclick="loadui('/ui/admin/iscscope.jsp?t=view')">
			<span class="btnlt"></span>
			<span class="btnco">Cancel</span>
			<span class="btnrt"></span>
		    </div>
		</div>
		<input type="submit" class="hidesubmit" />
	    </div>
	</form>
        <%}} else if("view".equals(type)){%>        	   		
        <div class="Hcbtn topbtn">
	    <div class="addnew" onclick="loadui('/ui/admin/iscscope.jsp?t=add')">
		<span class="cbtnlt"></span>
		<span class="cbtnco">Add New</span>
		<span class="cbtnrt"></span>
	    </div>
	</div>
	<%
        Map<Integer, ISCScope> iscScopeCache = CSPersistenceAPIImpl.getIDToISCScopeCache();
            if(iscScopeCache != null && !iscScopeCache.isEmpty()) {
        %>
	<div class="apikeyheader" id="headerdiv">
	    <div class="apikeytitle" style="width:18%;">Scope</div>
	    <div class="apikeytitle" style="width:16%;">Provider</div>
	    <div class="apikeytitle" style="width:18%;">Parent Scope</div>
	    <div class="apikeytitle" style="width:16%;">Parent Scope Provider</div>
	    <div class="apikeytitle" style="width:10%;">Scope Type</div>
	    <div class="apikeytitle">Actions</div>
	</div>
        <div class="content1" id="overflowdiv">
        <%
                ServiceAPI api = Util.SERVICEAPI;
                Set<Integer> iscKeys = iscScopeCache.keySet();
                for(int key : iscKeys) {
                    ISCScope iscScope = iscScopeCache.get(key);
                    if(iscScope == null) {
                        continue;
                    }
                    
                    String scopeProvider = "All";
                    if(iscScope.serviceID != -1) {
                        Service scopeService = api.getService(iscScope.serviceID);
                        scopeProvider = scopeService == null ? "Unknown" : scopeService.getServiceName();
                    }

                    ISCScope parentScope = CSPersistenceAPIImpl.getISCScope(iscScope.parentScopeID);
                    String parentScopeName = parentScope != null ? parentScope.scope : "-----";
                    
                    String parentScopeProvider = "-----";
                    if(parentScope != null) {
                        if(parentScope.serviceID != -1) {
                            Service parentScopeService = parentScope.serviceID != -1 ? api.getService(parentScope.serviceID) : null;
                            parentScopeProvider = parentScopeService == null ? "Unknown" : parentScopeService.getServiceName();
                        } else {
                            parentScopeProvider = "All";
                        }
                    }
        %>
            <div class="apikeycontent">
                <div class="apikey" style="width:18%;"><%=IAMEncoder.encodeHTML(iscScope.scope)%></div>
                <div class="apikey" style="width:16%;"><%=IAMEncoder.encodeHTML(scopeProvider)%></div>
                <div class="apikey" style="width:18%;"><%=IAMEncoder.encodeHTML(parentScopeName)%></div>
                <div class="apikey" style="width:16%;"><%=IAMEncoder.encodeHTML(parentScopeProvider)%></div>
                <div class="apikey" style="width:10%;"><%=iscScope.typeID == 1 ? "ISCScope" : iscScope.typeID == 2 ? "OAuth" : "AuthToken"%></div>
                <div class="apikey apikeyaction">
                    <div class="Hbtn">
                        <div class="savebtn" onclick="loadui('/ui/admin/iscscope.jsp?t=edit&scopeid=<%=iscScope.scopeID%>')"> <%-- NO OUTPUTENCODING --%>
                            <span class="cbtnlt"></span>
                            <span class="cbtnco">Edit</span> <%--No I18N--%>
                            <span class="cbtnrt"></span>
                        </div>
                        <div onclick="deleteISCScope('<%=IAMEncoder.encodeJavaScript(iscScope.scope)%>', '<%=iscScope.serviceID%>')"> <%-- NO OUTPUTENCODING --%>
                            <span class="cbtnlt"></span>
                            <span class="cbtnco">Delete</span> <%--No I18N--%>
                            <span class="cbtnrt"></span>
                        </div>
                    </div>
                </div>
                <div class="clrboth"></div>
            </div>
        <%
                }
        %>
        </div>
        <%
            } else {
        %>
        <div class="emptyobjmain">
	    <dl class="emptyobjdl"><dd><p align="center" class="emptyobjdet">No scope added</p></dd></dl>
	</div>
        <%
            }
        } else if("edit".equals(type)){
        	if("false".equals(AccountsConfiguration.getConfiguration("enable.iscscope.registration","false"))){ %>
        	<div style="margin-left: 10px;" onclick="loadui('/ui/admin/iscscope.jsp?t=view')">
				<span class="btnlt"></span>
				<span class="btnco">Back</span>
				<span class="btnrt"></span>
		    </div>
        	<div class="labelmain">
                <div style="font-size: 15px;text-align: center;margin-top: 20px;">Authtoken and ISC scopes are no more supported. User <a style="font-size: 16px;font-weight: bold; cursor: pointer; color: blue;" onclick="loadPage('oauth_scope','/ui/admin/oauthScope.jsp?t=view')">OAuth scopes</a></div> <%-- NO I18N --%>		    
			</div>			
        <%       
            }else{        
            	int scopeId = IAMUtil.getInt(request.getParameter("scopeid"));
            	ISCScope scope = null;
            	if(scopeId == -1 || (scope = CSPersistenceAPIImpl.getISCScope(scopeId)) == null) {
        %>
        <div class="emptyobjmain">
            <dl class="emptyobjdl"><dd><p align="center" class="emptyobjdet">No such scope created for requestd scope id <%=scopeId%></p></dd></dl>
        </div>
        <%
            } else {
                int serviceId = scope.serviceID;
                boolean internal = scope.internal;
                int parentScopeId = scope.parentScopeID;
        %>
        <form name="updateISC" class="zform" method="post" onsubmit="return addISCScope(this, '<%=IAMEncoder.encodeJavaScript(scope.scope)%>');">
	    <div class="labelmain">
                <div class="labelkey">Service Name :</div>
                <div class="labelvalue">
		    <select name="serviceid" class="select" disabled>
                        <option value="<%=serviceId%>"><%=serviceId == -1 ? "All" : IAMEncoder.encodeHTMLAttribute(Util.SERVICEAPI.getService(serviceId).getServiceName())%></option>
		    </select>
		</div>
		<div class="labelkey">Scope Name :</div>
		<div class="labelvalue"><input type="text" class="input" name="scopename" value="<%=IAMEncoder.encodeHTMLAttribute(scope.scope)%>"/></div>
		<div class="labelkey">Scope Type :</div>
                <div class="labelvalue">
                    <select name="internal" class="select" onchange="changeScopeType(this)">
                        <option value="1" <%if(scope.typeID == 1) {%>selected<%}%>>ISCScope</option>
                        <option value="0" <%if(scope.typeID == 0) {%>selected<%}%>>AuthToken</option>
                        <option value="2" <%if(scope.typeID == 2) {%>selected<%}%>>OAuth</option>
                    </select>
                </div>
                <div id ="parentscope" <%if(scope.typeID == 2) {%>style="display: none;"<%}%>>
		<div class="labelkey" >Parent Scope Name :</div>
                <div class="labelvalue">
			<%
                        ISCScope parentScope = CSPersistenceAPIImpl.getISCScope(parentScopeId);
                        String iscscopesstr = "<option value=\"-1\">Unassigned</option>";
                        String authtokensstr = "<option value=\"-1\">Unassigned</option>";
                        Map<Integer, ISCScope> iscScopeCache = CSPersistenceAPIImpl.getIDToISCScopeCache();
                        if(iscScopeCache != null && !iscScopeCache.isEmpty()) {
                            Set<Integer> iscKeys = iscScopeCache.keySet();
                            ServiceAPI sapi = Util.SERVICEAPI;
                            for(int key : iscKeys) {
                                ISCScope tmpScope = iscScopeCache.get(key);
                                if(tmpScope == null || tmpScope.scopeID == scope.scopeID) {
                                    continue;
                                }
                                String tmpSname = tmpScope.serviceID != -1 ? sapi.getService(tmpScope.serviceID).getServiceName() + " service" : "All services";
                                String scopeVal = tmpScope.scope + " for " + tmpSname;
                                String tmpSelected = "";
                                if(parentScope != null && tmpScope.scopeID == parentScope.scopeID) {
                                    tmpSelected = "selected";
                                }
                                if(tmpScope.typeID == 1) {
                                    iscscopesstr += "<option value=\""+tmpScope.scopeID+"\" "+tmpSelected+">" + IAMEncoder.encodeHTML(scopeVal) + "</option>";
                                } else if(tmpScope.typeID == 0) {
                                    authtokensstr += "<option value=\""+tmpScope.scopeID+"\" "+tmpSelected+">" + IAMEncoder.encodeHTML(scopeVal) + "</option>";
                                }
                            }
                        }
                        %>
		    <select name="parentiscscope" id="parentiscscope" class="select" <%if(!internal) {%>style="display:none;"<%}%>><%=iscscopesstr%></select> <%-- NO OUTPUTENCODING --%>
		    <select name="parentauthtoken" id="parentauthtoken" class="select" <%if(internal) {%>style="display:none;"<%}%>><%=authtokensstr%></select> <%-- NO OUTPUTENCODING --%>
		</div>
		</div>
		<div class="labelkey">Description :</div>
		<div class="labelvalue"><input type="text" class="input" name="desc" value="<%=IAMEncoder.encodeHTMLAttribute(scope.description)%>"/></div>
		<div class="accbtn Hbtn">
		    <div class="savebtn" onclick="addISCScope(document.updateISC, '<%=IAMEncoder.encodeJavaScript(scope.scope)%>')">
			<span class="btnlt"></span>
			<span class="btnco">Update</span>
			<span class="btnrt"></span>
		    </div>
		    <div onclick="loadui('/ui/admin/iscscope.jsp?t=view')">
			<span class="btnlt"></span>
			<span class="btnco">Cancel</span>
			<span class="btnrt"></span>
		    </div>
		</div>
		<input type="submit" class="hidesubmit" />
	    </div>
	</form>
        <%
            }
            	}}
        %>
    </div>
</div>
