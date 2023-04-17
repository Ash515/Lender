<%-- $Id$ --%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@page import="com.zoho.resource.URI"%>
<%@page import="com.zoho.accounts.AppResource.RESOURCE.USERSYSTEMROLES"%>
<%@page import="com.zoho.accounts.AppResourceProto.App.AppSystemRole"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.AppAccount.Template.TemplateImage"%>
<%@page import="com.zoho.accounts.Accounts"%>
<%@page import="com.zoho.accounts.Accounts.RESOURCE"%>
<%@page import="com.zoho.accounts.AppResource"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.AppAccount.Template"%>
<%@page import="com.zoho.resource.Criteria"%>
<%@page import="com.zoho.accounts.AccountsProto.Account.AppAccount"%>
<%@page import="com.zoho.accounts.AccountsConstants.Screen"%>
<%@page import="com.zoho.accounts.AccountsConstants"%>
<%@page import="com.zoho.accounts.AppResourceProto.App"%>

<%@ include file="../../static/includes.jspf"%>
<%@ include file="includes.jsp"%>
<%
      String type = request.getParameter("t");
      boolean isFirst = true;
      String app_name = request.getParameter("appname");
      isFirst = app_name != null ? false : true;
      
      if (isFirst) {
            app_name = "AaaServer";//NO I18N
      }
      boolean isIAMAdmin = request.isUserInRole("IAMAdmininistrator");
      boolean isIAMServiceAdmin = !isIAMAdmin && request.isUserInRole(Role.IAM_SERVICE_ADMIN);
  	  List<String> isUserAllowedServices = new ArrayList<String>(); 
  	  if(Util.isDevelopmentSetup() && isIAMServiceAdmin) {
		AppSystemRole[] appRoles = (AppSystemRole[]) RestProtoUtil.GETS(AppResource.getAppSystemRoleURI(URI.JOIN, Role.IAM_SERVICE_ADMIN).getQueryString().setCriteria(new Criteria(USERSYSTEMROLES.ZUID, user.getZUID())).build());
  		if(appRoles != null) {
    		for (AppSystemRole appRole : appRoles) {//Populate permission enabled services
    			if(appRole.getParent().getAppName().equalsIgnoreCase(Util.getIAMServiceName())) {
    				continue;
    			}
    			app_name = appRole.getParent().getAppName();
 				isUserAllowedServices.add(appRole.getParent().getAppName().toLowerCase());
    		}
  		}
  	}

%>
<div class="maincontent">
      <div class="menucontent">
            <div class="topcontent">
                  <div class="contitle">Screen</div>
            </div>
            <div class="subtitle">Admin Services</div>
            <div class="subtitle" style="display:<%= type.equals("view") ? "block" :"none"%>">
                  App Name : <select class="select select2Div" name="appname" id="appname"  onchange="changeAppName(this,'/ui/admin/screen.jsp','view')">                    <%--No I18N--%>
                        <%
                        	String zaaid = null;
                        	for (Service s : ss) {
                        		if(Util.isDevelopmentSetup() && isIAMServiceAdmin) {
                        			if(!isUserAllowedServices.contains(s.getServiceName().toLowerCase())) {
                    					continue;
                    				}
                        		}
            		                %>
                                    <option value="<%=IAMEncoder.encodeHTMLAttribute(s.getServiceName())%>" <%if (app_name.equals(s.getServiceName())) {%> <%="selected"%> <%}%>><%=IAMEncoder.encodeHTML(s.getServiceName())%></option>
                                    <%
                        		
                        	}
                        %>
                  </select>
            </div>
      </div>
      <div class="field-bg">
      <img src="images/loading.gif" id="loading" style="display:none;margin-left:500px">
            <%
            	if ("add".equals(type)) {
            %>
            <div class="topbtn Hcbtn">
                  <div class="addnew" onclick="loadui('/ui/admin/screen.jsp?t=view');">
                        <span class="cbtnlt"></span> <span class="cbtnco">Back to Screen</span> <span class="cbtnrt"></span><%--No I18N--%>
                  </div>
            </div>
            <form name="upload" id="upload" action="admin/screen/fileinfo" method="post" target="uploadaction"
                  enctype="multipart/form-data" onsubmit=" return validate(this)"    >
                  <%--No I18N--%>
                  <input type="hidden" name="iamcsrcoo"
                        value=<%=IAMEncoder.encodeHTMLAttribute(IAMUtil.getCookie(request, "iamcsr"))%>
                  /> 
                  <input type="hidden" name="type" value="<%=IAMEncoder.encodeHTMLAttribute(type)%>" />
                  <div class="labelmain" style="overflow: hidden" id="addf">
                        <div class="labelkey">App Name :</div>
                        <div class="labelvalue">
                              <select name="appname" id="appname" class="select select2Div">
                                    <option value="select">----select----</option>
                                    <%
                                    		for (Service s : ss) {
                                    			if(Util.isDevelopmentSetup() && isIAMServiceAdmin) { 
                                    				if(!isUserAllowedServices.contains(s.getServiceName().toLowerCase())) {
                                    					continue;
                                    				}
                                    			}
                                    %>
                                    <option value="<%=IAMEncoder.encodeHTMLAttribute(s.getServiceName())%>"><%=IAMEncoder.encodeHTML(s.getServiceName())%></option>
                                    <%
                                    	}
                                    %>
                              </select>
                        </div>
                        <div class="labelkey">Screen Name :</div>

                        <div class="labelvalue">
                              <select name="screen" id="screen" class="select select2Div" onchange="selectScreen(this)">
                                    <option value="select">----select----</option>                                    <%--No I18N--%>
                                    <%
                                    	Screen[] values = AccountsConstants.Screen.values();
                                    		for (int i = 0; i < values.length; i++) {
                                    %>
                                    <option value="<%=IAMEncoder.encodeHTMLAttribute(values[i].getScreenName())%>"><%=IAMEncoder.encodeHTML(values[i].toString())%></option>
                                    <%-- NO OUTPUTENCODING --%>
                                    <%
                                    	}
                                    %>
                                    <option value="other" style="font-weight: bold;">***other***</option> <%--No I18N--%>
                              </select> <input name="alternatescreen" id="alternatescreen" type="text" class="input" style="display: none;" />
                        </div>
                        <div class="labelkey">Screen Type :</div>
                        <div class="labelvalue">
                              <label><input type="radio" id="screentype" name="tpltype" value="0" checked="checked" onclick="showMailType(this.id)"  />Screen</label><%--No I18N--%>
                              <label><input type="radio" id="mailtype" name="tpltype" value="1" onclick="showMailType(this.id)" />Mail</label><%--No I18N--%>
                              <label> <input type="radio" name="tpltype" value="2" id="sms" onclick="showMailType(this.id)" />SMS</label><%--No I18N--%>
                        </div>
                        <div id="mailtable" style="display: none">
                              <div class="labelkey">Subject Name :</div>
                              <div class="labelvalue">
                                    <input name="subject" type="text" class="input">
                              </div>
                              <div class="labelkey">From :</div>
                              <div class="labelvalue">
                                    <input name="from" type="text" class="input">
                              </div>
                              <div class="labelkey">Reply To :</div>
                              <div class="labelvalue">
                                    <input name="replyto" type="text" class="input">
                              </div>
                        </div>

                        <div class="labelkey" style="padding-top: 12px">Template HTML :</div>
                        <div class="labelvalue">
                              <input name="tplfile" type="file" id="file" class="input">
                        </div>
                        <div class="labelkey" style="padding-top:12px">Plain Text :</div>
                        <div class="labelvalue">
                        		<input name="txtfile" type="file" id="textfile" class="input">
                        </div>
                          <div class="accbtn Hbtn" id="next">
                              <div class="savebtn" onclick="validate(document.upload)" id="Next">
                                    <span class="btnlt"></span> <span class="btnco">Next</span> <span class="btnrt"></span>                                    <!-- No I18N --> 
                              </div>
                              <div class="savebtn" onclick="loadui('/ui/admin/screen.jsp?t=view')">
                                    <span class="btnlt"></span> <span class="btnco">Cancel</span> <span class="btnrt"></span>                                    <!-- No I18N -->
                              </div>
                        </div>  
						
                  </div>
                  <div class="asdf" id="asd" ></div>
                   <div class="accbtn Hbtn" id="submit" style = 'display :none'>
                              <div class="savebtn" onclick="validate(document.upload)" id="saveid">
                                    <span class="btnlt"></span> <span class="btnco">Add</span> <span class="btnrt"></span>                                    <%--No I18N--%>
                              </div>
                              <div class="savebtn" onclick="loadui('/ui/admin/screen.jsp?t=view')">
                                    <span class="btnlt"></span> <span class="btnco">Cancel</span> <span class="btnrt"></span>                                    <%--No I18N--%>
                              </div>
                    </div>
            </form>
           
            <%
            	} else if ("view".equals(type)) {//No I18n
            %>
            <div class="Hcbtn topbtn">
                  <div class="addnew" onclick="loadui('/ui/admin/screen.jsp?t=add'); initSelect2();">
                        <span class="cbtnlt"></span> <span class="cbtnco">Add New</span> <span class="cbtnrt"></span><%--No I18N--%>
                  </div>
            </div>

            <div class="apikeyheader" id="headerdiv">
                  <div class="apikeytitle" style="width: 33%;">Screen Name</div>                  <%--No I18N--%>
                  <div class="apikeytitle" style="width: 44%;">Screen Type</div>                  <%--No I18N--%>
                  <div class="apikeytitle" style="width: 20%;">Action</div>              <%--No I18N--%>
            </div>
            <div class="content1" id="overflowdiv">
            <%
            String appname= request.getParameter("appname");
            appname = Util.isValid(appname) ? appname : app_name;
      		AppAccount aa = Accounts.getAppAccountURI(AccountsConstants.REFERENCE_ACCOUNT).getQueryString().setCriteria(new Criteria(RESOURCE.APPACCOUNT.APP_NAME, appname)).build().GET();
      		if (aa != null) {
      			zaaid = aa.getZaaid();
      		}
      		Template[] templates = Accounts.getTemplateURI(AccountsConstants.REFERENCE_ACCOUNT, zaaid).GETS();
      		           	int templateType = 0;
      		    if(templates != null) {
          		for (Template template : templates) {
          			templateType = template.getTemplateType();
                        %>
                         <div class="apikeycontent">
                        <div class="apikey" style="width: 30%;"><%=IAMEncoder.encodeHTML(template.getTemplateName())%></div>
                        <div class="sysname" style="width: 38%;"><%=templateType == 1 ? "Mail" : templateType == 2 ? "SMS" : "Screen"%></div>
                        <div class="apikey apikeyaction" style="width:25%;">
                              <div class="Hbtn">
                                    <div class="savebtn" style="margin-right:10px" onclick="loadui('/ui/admin/screen.jsp?t=addtext&appname=<%=IAMEncoder.encodeJavaScript(appname)%>&screenname=<%=IAMEncoder.encodeJavaScript(template.getTemplateName())%>');">
                                          <span class="cbtnlt"></span> <span class="cbtnco" style="width: 57px;">Add Text</span> <span class="cbtnrt"></span><%--No I18N--%>
                                    </div>
                                          <div class="savebtn" style="margin-right:10px" onclick="popUp(<%= Accounts.getTemplateImageURI(AccountsConstants.REFERENCE_ACCOUNT, zaaid,template.getTemplateName()).GET()!=null%>,'<%=IAMEncoder.encodeJavaScript(appname)%>','<%=IAMEncoder.encodeJavaScript(template.getTemplateName())%>');">
                                          <span class="cbtnlt"></span> <span class="cbtnco" style="width: 35px;">Edit</span> <span class="cbtnrt"></span><%--No I18N--%>
                                    </div>
                                   
                                 <div onclick="deleteTemplate('<%= IAMEncoder.encodeJavaScript(appname) %>','<%=IAMEncoder.encodeJavaScript(template.getTemplateName())%>')">
                                                <span class="cbtnlt"></span> <span class="cbtnco">Delete</span>      <%--No I18N--%>
                                                <span class="cbtnrt"></span>
                                          </div>
                                 </div>
                        </div>
                        <div class="clrboth"></div>
                  </div>
                        
                        <%
          		}           
            	}	else {
            		%>
      		       	<div class="emptyobjmain">
	    				<dl class="emptyobjdl"><dd><p align="center" class="emptyobjdet"> No Templates found for <%=appname %> </p></dd></dl><%-- No I18N --%>
					</div>	  
            	<% }
          %>
           				 <div class="label" id="select" style="width:15%;top:45%;left:50%;position:absolute;margin:opx auto;display:none">

			<div class="mrpheader">
				 <span class="close" onclick="updatescreen('hide')"></span> <span>Upload Action</span>             				<%--No I18N--%> 
			</div>
			<div class="mprcontent">
				<div>
					<b class="mrptop inbg"><b class="mrp2"></b><b class="mrp3"></b><b
						class="mrp4"></b></b>
				</div>
				<div class="mrpcontentdiv">
				<input id="upacappname" type="hidden" value=""/>
				<input id="upacscreenname" type="hidden" value=""/>
					<div class="savebtn" onclick="popChange(this)" id="tmpid"
						style="margin-left: 50px; margin-top: 5%">
						<span class="btnlt"></span> <span class="btnco">Template File Upload</span><span class="btnrt"></span>							<%--No I18N--%>
					</div>
					
					<div class="savebtn" onclick="popChange(this)" id="imgid"
						style="margin-left: 50px; margin-top: 10px;display:none">
						<span class="btnlt"></span> <span class="btnco">Image File Upload</span> <span class="btnrt"></span>				<%--No I18N--%>
			
				</div>
				<div>
					<b class="mrpbot inbg"><b class="mrp4"></b><b class="mrp3"></b><b
						class="mrp2"></b></b>
				</div>
			</div>
			<div>
				<b class="mrpbot outbg"><b class="mrp4"></b><b class="mrp3"></b><b
					class="mrp2"></b><b class="mrp1"></b></b>
			</div>
		</div>
            </div>
            <%} else if ("addtext".equals(type)) { 
             	String appname = request.getParameter("appname");
          		String screenname = request.getParameter("screenname");
            %>           
                    <div class="topbtn Hcbtn">
                        <div class="addnew" onclick="loadui('/ui/admin/screen.jsp?t=view');">
                              <span class="cbtnlt"></span> <span class="cbtnco">Back to Screen</span> <span class="cbtnrt"></span><%--No I18N--%>
                        </div>
                    </div>
                    
                    <form name="textupload" id="txtupload" action="/admin/screen/textupdate" method="post" target="uploadaction" 
                     enctype="multipart/form-data" onsubmit="return validateText(this)" >
                        <input type="hidden" name="iamcsrcoo" value="<%=IAMEncoder.encodeHTMLAttribute(IAMUtil.getCookie(request, "iamcsr"))%>"/> 
                        
                         <div class="labelkey">App Name :</div><%--No I18N--%>
                              <div class="labelvalue">
                                    <input type="text" name="appname" id="app" value="<%=IAMEncoder.encodeHTMLAttribute(appname)%>"
                                          readonly/>
                         </div>
                         <div class="labelkey">Screen Name :</div><%--No I18N--%>
                              <div class="labelvalue">
                                    <input type="text" name="screen" value="<%= IAMEncoder.encodeHTMLAttribute(screenname) %>" readonly />
                        </div>
                        <div class="labelkey" style="padding-top: 12px">Plain Text :</div><%--No I18N--%>
                          <div class="labelvalue">
                        		<input name="txtfile" type="file" id="txtfile" class="input">
                         </div>    
                        <div class="accbtn Hbtn" id="next">
                            <div class="savebtn" onclick="validateText(document.textupload)" id="Next">
                                    <span class="btnlt"></span> <span class="btnco">Add</span> <span class="btnrt"></span>                                    <%--No I18N--%> 
                             </div>
                             <div class="savebtn" onclick="loadui('/ui/admin/screen.jsp?t=view')">
                                    <span class="btnlt"></span> <span class="btnco">Cancel</span> <span class="btnrt"></span>                                   <%--No I18N--%>
                             </div>
                        </div>  
                                     
                    </form>
            <%
            } if ("edit".equals(type)) { //No I18n
            	String appname = request.getParameter("appname");
          		String screenname = request.getParameter("screenname");
          		//String zaaid = null;
          		AppAccount aa = Accounts.getAppAccountURI(AccountsConstants.REFERENCE_ACCOUNT).getQueryString().setCriteria(new Criteria(RESOURCE.APPACCOUNT.APP_NAME, appname)).build().GET();
          		if (aa != null) {
          			zaaid = aa.getZaaid();
          		}
          		int templateType = 0;
          		int i=0;
          		TemplateImage[] templateImages = Accounts.getTemplateImageURI(AccountsConstants.REFERENCE_ACCOUNT, zaaid, screenname).GETS();
          		TemplateImage temp = Accounts.getTemplateImageURI(AccountsConstants.REFERENCE_ACCOUNT, zaaid, screenname).GET();
            	%>
                  
                  <div class="topbtn Hcbtn">
                        <div class="addnew" onclick="loadui('/ui/admin/screen.jsp?t=view');">
                              <span class="cbtnlt"></span> <span class="cbtnco">Back to Screen</span> <span class="cbtnrt"></span><%--No I18N--%>
                        </div>

                  </div>
			
			<div class="edit" id="edit" style ='display:block'>
				<form name="upload" id="upload" action="/admin/screen/fileinfo" method="post" target="uploadaction"
                        enctype="multipart/form-data" onsubmit="return validate(this)" >
                        <input type="hidden" name="iamcsrcoo"
                              value=<%=IAMEncoder.encodeHTMLAttribute(IAMUtil.getCookie(request, "iamcsr"))%>
                        /> <input type="hidden" name="type" value="<%=IAMEncoder.encodeHTMLAttribute(type)%>" />

                        <div class="labelmain" style="overflow: hidden" id="addf">
                              <div class="labelkey">App Name :</div><%--No I18N--%>
                              <div class="labelvalue">
                                    <input type="text" id="appname" value="<%=IAMEncoder.encodeHTMLAttribute(appname)%>"
                                          disabled="disabled"
                                    />
                              </div>
                              <div class="labelkey">Screen Name :</div><%--No I18N--%>
                              <div class="labelvalue">
                                    <input type="text" value="<%= IAMEncoder.encodeHTMLAttribute(screenname) %>" disabled="disabled" />
                              </div>
                              <%
                              
                              	if (screenname != null && !screenname.equals("select")) {
                              			Template template = Accounts.getTemplateURI(AccountsConstants.REFERENCE_ACCOUNT, zaaid, screenname).GET();
                              			templateType = template.getTemplateType();
                              %>

                              <div class="labelkey">Screen Type :</div><%--No I18N--%>
                              <div class="labelvalue">
                                    <input type="text" name="stype"
                                          value="<%=templateType == 1 ? "Mail" : templateType == 2 ? "SMS" : "Screen"%>"
                                          disabled="disabled"
                                    />
                              </div>
                              <%
                              	if (templateType == 1) {
                              %>
                              <div id="mailtable">
                                    <div class="labelkey">Subject Name :</div><%--No I18N--%>
                                    <div class="labelvalue">
                                          <input name="subject" type="text" class="input"
                                                value="<%=IAMEncoder.encodeHTMLAttribute(template.getSubject())%>"
                                          />
                                    </div>
                                    <div class="labelkey">From :</div><%--No I18N--%>
                                    <div class="labelvalue">
                                          <input name="from" type="text" class="input"
                                                value="<%=IAMEncoder.encodeHTMLAttribute(template.getFromAddress())%>"
                                          />
                                    </div>
                                    <div class="labelkey">Reply To :</div><%--No I18N--%>
                                    <div class="labelvalue">
                                          <input name="replyto" type="text" class="input"
                                                value="<%=IAMEncoder.encodeHTMLAttribute(template.getReplyToAddress())%>"
                                          />
                                    </div>
                              </div>
                              <%
                              	}
                              %>
                              <%
                              	}
                              %>
                              <input type="hidden" name="tpltype" value=<%=templateType%> /> 
                              <input type="hidden" name="appname"   id="appname" value="<%=IAMEncoder.encodeHTMLAttribute(appname)%>" />
                              <input type="hidden" name="screen" id="screen" value=<%= IAMEncoder.encodeHTMLAttribute(screenname) %> />
                              <div class="labelkey" style="padding-top: 12px">Template HTML :</div><%--No I18N--%>
                              <div class="labelvalue">
                                    <input name="tplfile" type="file" id="file" class="input">
                              </div>
                              <div class="labelkey" style="padding-top: 12px">Plain Text :</div><%--No I18N--%>
                              <div class="labelvalue">
                        		<input name="txtfile" type="file" id="textfile" class="input">
                              </div>                             
                              <div class="accbtn Hbtn" id="next">
                              	<div class="savebtn" onclick="validate(document.upload)" id="Next">
                                    <span class="btnlt"></span> <span class="btnco">Next</span> <span class="btnrt"></span>                                    <%--No I18N--%> 
                              	</div>
                              	<div class="savebtn" onclick="loadui('/ui/admin/screen.jsp?t=view')">
                                    <span class="btnlt"></span> <span class="btnco">Cancel</span> <span class="btnrt"></span>                                   <%--No I18N--%>
                              	</div>
                        	 </div> 
                        </div>

				 <div class="asdf" id="asd" ></div>
					<div class="accbtn Hbtn" id="submit" style='display: none'>
						<div class="savebtn" onclick="validate(document.upload)">
							<span class="btnlt"></span> <span class="btnco">Update</span> <span	class="btnrt"></span>		<%--No I18N--%> 
						</div>
						<div onclick="loadui('/ui/admin/screen.jsp?t=view');">
							<span class="btnlt"></span> <span class="btnco">Cancel</span> <span	class="btnrt"></span>		<%--No I18N--%> 
						</div>
					</div>
				</form>
         	
         	<form name="iupload" id="iupload" action="/admin/screen/update" method="post" target="uploadaction"
                        enctype="multipart/form-data" onsubmit="return imageUpload(this)" >
                        <input type="hidden" name="iamcsrcoo"
                              value=<%=IAMEncoder.encodeHTMLAttribute(IAMUtil.getCookie(request, "iamcsr"))%>
                        /> <input type="hidden" name="type" value="<%=IAMEncoder.encodeHTMLAttribute(type)%>" />
                              <input type="hidden" name="tpltype" value=<%=templateType%> /> 
                              <input type="hidden" name="appname"   id="appname" value="<%=IAMEncoder.encodeHTMLAttribute(appname)%>" />
                              <input type="hidden" name="screen" id="screen" value=<%= IAMEncoder.encodeHTMLAttribute(screenname) %> />
                              
                              
 				 <div class="image" id="imk" >
					<%
					
					if(temp != null) {
						for (TemplateImage templateImage : templateImages) {
					%>
					<div class="labelkey" style="padding-top: 12px"><%=templateImage.getImageNameApl()%> :</div>	<%-- NO OUTPUTENCODING --%>												
					<div class="labelvalue">
						<input name = "<%="imgfile"+(i+1)%>" type="file" id="file" class="input" >
						<input type="hidden" name="<%="imgid"+i%>" value=<%=templateImage.getImageNameApl() %> /> <%-- NO OUTPUTENCODING --%>
					</div>
					<%
						i++;
							}
					}
					%>
				</div>  
				<div class="accbtn Hbtn" id="submit">
					<div class="savebtn" onclick="imageUpdate(document.iupload)">
							<span class="btnlt"></span> <span class="btnco">Update</span> <span class="btnrt"></span>				<%--No I18N--%> 
																																						
					</div>
					<div onclick="loadui('/ui/admin/screen.jsp?t=view');">
							<span class="btnlt"></span> <span class="btnco">Cancel</span> <span class="btnrt"></span>         <%--No I18N--%>
																																						
					</div>
				</div>
         	</form>
         </div>
            <%
            	}
            %>
    </div>
</div>
<iframe name="uploadaction" id="uploadaction" class="hide" frameborder="0" height="0%" width="0%"></iframe>