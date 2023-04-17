<%-- $Id: $ --%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN" "http://www.w3.org/TR/REC-html40/frameset.dtd">
<%@page import="com.zoho.accounts.internal.util.I18NUtil"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst.OAuthConstants.OAuthAccessGrantType"%>
<%@page import="com.zoho.accounts.internal.util.AppConfiguration"%>
<%@page import="com.zoho.accounts.internal.oauth2.OAuth2Util"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.util.Map"%>
<%@page import="com.zoho.accounts.internal.oauth2.OAuthTokenOrgInfo"%>
<%@page import="com.zoho.accounts.internal.oauth2.OAuthScopeDetails"%>
<%@ include file="../../../static/includes.jspf" %>
<%
boolean is_ajax = request.getAttribute("is_ajax") != null ? (Boolean) request.getAttribute("is_ajax") : false;
boolean devicedirectRequest = request.getAttribute("devicedirectRequest") != null ? (Boolean) request.getAttribute("devicedirectRequest") : false;
boolean isDirectAccess = !is_ajax;
boolean isMobile = Util.isMobileUserAgent(request);
User user = IAMUtil.getCurrentUser();

boolean closeBrowser = request.getAttribute("closebrswr") != null ? (Boolean) request.getAttribute("closebrswr") : false ;//Boolean.parseBoolean(request.getParameter("closebrswr"));
String clientName = request.getAttribute("clientName") != null ? (String) request.getAttribute("clientName") : null;
String vCode = request.getAttribute("Vcode") != null ? (String) request.getAttribute("Vcode") : null;
String scopeDetailsParam = request.getAttribute("scopeDetailsParam") != null ? (String) request.getAttribute("scopeDetailsParam") : null;
String queryParams = request.getAttribute("queryParams") != null ? (String) request.getAttribute("queryParams") : "";
JSONObject customoauth = request.getAttribute("customoauth") != null ? (JSONObject)request.getAttribute("customoauth") : null;
String reqOriginUrl = request.getAttribute("reqOriginUrl") != null ? (String) request.getAttribute("reqOriginUrl") : "";
boolean grantType = request.getAttribute("grantType") != null ? (Boolean) request.getAttribute("grantType") : false;
boolean isorgoauth = request.getAttribute("OrgOAuth") != null ? (Boolean) request.getAttribute("OrgOAuth") : false;
Boolean isClientPortal = request.getAttribute("isClientPortal") != null ? (Boolean) request.getAttribute("isClientPortal") : false ;
String accZaid = request.getAttribute("accountID")!=null ? (String) request.getAttribute("accountID") : null;
List<String> servicesSkipped = new ArrayList<String>();
boolean isInternal = request.getAttribute("isInternal") != null ? (Boolean) request.getAttribute("isInternal") : false;
boolean userPartOfOrgs = true;
boolean throwError = AccountsConfiguration.getConfigurationTyped("oauth.user.no.org", true);//No I18N
JSONObject ScopeandOrgInfo = request.getAttribute("ScopeandOrgInfo") != null ? (JSONObject)request.getAttribute("ScopeandOrgInfo") : null;
boolean isOrgInfo = request.getAttribute("isOrgInfo")!=null ? (Boolean)request.getAttribute("isOrgInfo") : false;
int subpromptcount=0;
int overallcount=0;
%>
<html>
<head>
<title><%=I18NUtil.getMessage("IAM.ZOHO.ACCOUNTS")%></title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no" />
<script src="<%=jsurl%>/jquery-1.12.2.min.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
<link href="<%=cssurl%>/oauth.css" type="text/css" rel="stylesheet"  /><%-- NO OUTPUTENCODING --%>
</head>
<script>
var fullList = {};
var countmap = [];
</script>
<body>
<%if(isDirectAccess) {%>
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
        <%if(!isMobile) {%>
		    <div class="profile">
                <span class="profile_pic"></span>
                <span class="profile_name"><%=IAMEncoder.encodeHTML(user.getDisplayName())%></span>
                <span class="hide logout" id="log_out"><%=I18NUtil.getMessage("IAM.LOGOUT")%></span>
            </div>
		
		<%}
        else
        {
        %>	
        	<div class="mob_profile">
            	<span class="profile_pic" style="margin-top: 13px;"></span>
            </div>
            <div class="mob_logout">
            	<div class="exit_profile"><span class="close_X"></span></div>
            	
            	<div class="profile_info">
            		<span class="profile_pic_enlarge"></span>
            		<div class="white mob_name"><%=IAMEncoder.encodeHTML(user.getDisplayName())%></div>
            		<div class="white mob_emailid"><%=IAMEncoder.encodeHTML(user.getPrimaryEmail())%></div>
        		</div>
        		<button class="btn log_out" id="log_out"><%=I18NUtil.getMessage("IAM.LOGOUT")%></button>
        	</div>
       
        <%	
        }
        }%>
		<div class="screen"></div>
			<div class="container">
            
            <div class="wrap">
		           <div class="deviceapprovalimage"></div>
		           <img class="logo" src="<%=IAMEncoder.encodeHTML(imgurl)%>/zlogo.png">
        	       
      <% 
      				if(isDirectAccess) 
      				{
      %>
					 <div class="head_text"><%=IAMEncoder.encodeHTML(clientName)%></div>
	  <%			} 
      				else 
      				{
      %>
					 <div class="head_text">
<%-- 					 <%=Util.getI18NMsg(request, "IAM.DEVICEOAUTH.DEVICE.APPROVAL")%>	&nbsp;&nbsp; --%>
					 <%=IAMEncoder.encodeHTML(clientName) %></div>
      <%
					}
	  %>			
	  <div id="scope_resp"></div>
	  			 <div id="Approve_Reject">
	  			 <%if(customoauth!=null && customoauth.has("extraData")){ %>
	  			 <div class="normal_text"><%=customoauth.get("extraData") %></div>
	  			 <% } else { %>
		           <div class="normal_text">
						<%=!isInternal ? I18NUtil.getMessage("IAM.DEVICEOAUTH.ACCEPT.DESCRIPTION.NOTES", IAMEncoder.encodeHTML(clientName)) : I18NUtil.getMessage("IAM.INTERNAL.OAUTH.ACCEPT.DESCRIPTION.NOTES", IAMEncoder.encodeHTML(clientName))%>
		           </div>
		           <% } %>
      <%
	
			if(isOrgInfo)
			{
	  %>
                    <div id="selectedbox_div" class="selectedbox_div">
                    </div>
      <%
			}
			else
			{
	  %>
	  				<div>
      <%      
      			for(String serviceName : ScopeandOrgInfo.keySet())
      			{
      				JSONObject serviceobj = (JSONObject)ScopeandOrgInfo.get(serviceName);
      %>
							<div class="showselected" >
								<span class='servicelogo x2_<%=IAMEncoder.encodeHTML(serviceName.toLowerCase())%>_icon' id="servicelogo"></span>
								<div class="servicedetails">
									<span class="servicehead empty_org"><%=IAMEncoder.encodeHTML(serviceobj.getString("DisplayName"))%></span>
								</div>
								<%if(!isInternal){%>
								<div class="scopes">
									<ul>
	 <% 
	                    JSONArray descarr = (JSONArray)serviceobj.get("Description");
      					for(int i =0 ; i < descarr.length() ; i++)
      					{
     %>						
      							<%=descarr.get(i)%>
     <% 
      					}
     %>
      					</ul>
						</div>
						<% } %>
					</div>
      <%				}
      			}
      %>
                    </div>
	  
		    
	<%
	List<String> servicesWithNoOrgs = new ArrayList<String>();
	List<String> servicesWithAllOrgs = new ArrayList<String>();
			if(isOrgInfo)
			{
	%>
		    <div id="myModal" class="modal">
				<div class="headinh">
                    <%=I18NUtil.getMessage("IAM.SERVICE.CHOOSE", IAMEncoder.encodeHTML(clientName))%>
                    <span class="close_btn" id="close_btn"></span>
                </div>
  			
    			<div class="left_info">
    <%   							
		                        for(String serviceName:ScopeandOrgInfo.keySet())
		                        {
									JSONObject info = (JSONObject)ScopeandOrgInfo.getJSONObject(serviceName).optJSONObject("OrgInfo"); //NO I18N
									if(info == null)
									{
										continue;
									} else if (info.length() == 1 && (info.optJSONArray(info.keys().next())==null || (info.getJSONArray(info.keys().next()).length()==1 && !ScopeandOrgInfo.getJSONObject(serviceName).optBoolean("applicationBased")))){ //NO I18N
											if(info.optBoolean("NOT_CONFIGURED")){
												servicesWithNoOrgs.add(serviceName);
												userPartOfOrgs = false;
											} else if(info.optBoolean("ALL_CONFIGURED")){ //NO I18N
												servicesWithAllOrgs.add(serviceName);
											} else {
												servicesSkipped.add(serviceName);
											}
									} else {	
										subpromptcount++;
	%>                                
					    			    <div class="nav_product" >
					            			<span id="<%=subpromptcount%>_prod_name" class="product" onclick="goto_prod(<%=subpromptcount%>)">
					                            <span class="product_icon <%=IAMEncoder.encodeHTML(serviceName.toLowerCase())%>_icon"></span> 
					    						<span class="product_name"><%=IAMEncoder.encodeHTML(serviceName)%></span>
					                            <span class="edit_circle" id="<%=subpromptcount%>_prod_check" >
					                                <span class="icon-tick"></span>                            
					                            </span>
					    					</span>
					    				</div>
	<%                              
									}
								}								
    %>
				</div>
							<div class="right_info">
	<%	
								subpromptcount=0;
			                    for(String serviceName:ScopeandOrgInfo.keySet())
			                        {
									JSONObject info = (JSONObject)ScopeandOrgInfo.getJSONObject(serviceName).optJSONObject("OrgInfo"); //NO I18N
									boolean isapplicationBased = ScopeandOrgInfo.getJSONObject(serviceName).optBoolean("applicationBased"); //NO I18N
									if(info == null  || servicesWithNoOrgs.contains(serviceName) || servicesWithAllOrgs.contains(serviceName)){
										overallcount++;
									} else if((info.length() == 1  && info.getJSONArray(info.keys().next()).length()==1)&& !isapplicationBased) {
										overallcount++;
										JSONObject singleorginfo = info.getJSONArray(info.keys().next()).getJSONObject(0);
										String value = singleorginfo.getString("zid")+"."+singleorginfo.getString("display_name");
									%>
									<script> 
									fullList["<%=IAMEncoder.encodeHTML(serviceName)%>"]= "<%=IAMEncoder.encodeHTML(value)%>";
									countmap[<%=overallcount%>] = 0;
									</script>
									<%
								     } else{
											subpromptcount++;
											overallcount++;
	%>
					                    	<div id="display_prodct_<%=subpromptcount%>" class="hide product_select">
					                        	<span class="product_<%=subpromptcount%>_name ">
					                            	<%=IAMEncoder.encodeHTML(serviceName)%>
					                        	</span>
					                             <span class="description" id="first_desc"><%=I18NUtil.getMessage("IAM.SERVICE.CHOOSE.DESCRIPTION")%></span>
					                        	<span class="description hide" id="second_desc" ><%=I18NUtil.getMessage("IAM.OAUTH.SERVICE.APPLICATION.DESCRIPTION") %></span>
					                        	<div class="application_space hide"></div>
					                        	<div class="services_space">
					                        	
	<%                                 
	                                    Iterator<String> envkeys = info.keys();
	                                    while(envkeys.hasNext()){
	                                    	Integer envkey = Integer.valueOf(envkeys.next());
%>                                           <span class="description"><%=I18NUtil.getMessage("IAM.OAUTH.MULTIORG.ENV."+envkey)%></span>
<%                                              
	                                    	JSONArray envspecificarr = info.getJSONArray(envkey.toString());
	                                    	for(int i=0;i<envspecificarr.length();i++){
	                                    		JSONObject envspecificobj = envspecificarr.getJSONObject(i);
%>	                                    		
	                                    		<div class="primary-btn" id="product_<%=subpromptcount%>_service_<%=envkey%>_<%=i%>" onclick="switchradio(this,'<%=IAMEncoder.encodeHTML(serviceName)%>',<%=subpromptcount%>,<%=overallcount%>)">
					                            <span class="select_tick"></span> 
					                            <span class="select_text"><%=IAMEncoder.encodeHTML(envspecificobj.getString("display_name"))%></span>						          
					                            </div>
					                        <input type="radio" class="hide" name="<%=IAMEncoder.encodeHTML(serviceName)%>" value="<%=IAMEncoder.encodeHTML(envspecificobj.getString("zid")+"."+envspecificobj.getString("display_name"))%>" > 
<%
	                                    	}
	                                    }
%>
								                    <div class="error" id="<%=subpromptcount%>_error">
							                        </div>
								                        <div class="but_action">
								                         <button class="btn" id="next_<%=subpromptcount%>" onclick='change_div(<%=subpromptcount%>,"<%=IAMEncoder.encodeHTML(serviceName)%>", <%=isapplicationBased%>);'><%=I18NUtil.getMessage("IAM.TFA.NEXT")%></button>								                        
							                             <button class="cancel" id="back_<%=subpromptcount%>"  onclick='back_div(<%=subpromptcount%>);' ><%=I18NUtil.getMessage("IAM.BACK")%></button>
							                        </div>
							                        <div class="submit_action">
							                            <%if(isapplicationBased){%>
							                            <button class="btn"  onclick='check_applicationINFO(<%=subpromptcount%>,"<%=IAMEncoder.encodeHTML(serviceName)%>",true);'><%=I18NUtil.getMessage("IAM.SUBMIT")%></button>
							                            <%} else{%>
							                            <button class="btn"  onclick='close_modal();'><%=I18NUtil.getMessage("IAM.SUBMIT")%></button>
							                            <%}%>
							                        </div>
							                   </div>
							                </div>
	<%
									}
								}
	%>
								</div>
    		</div>
    <%
    		}
	 %>
<br>
							<%
							
							if(isDirectAccess && !devicedirectRequest) {
								if(!userPartOfOrgs && ( throwError || (ScopeandOrgInfo.length()==servicesWithNoOrgs.size()))){
								%>
								<div class="normal_text">
										<%=I18NUtil.getMessage("IAM.USER.UNAVAILABLE.QUERY", IAMEncoder.encodeHTML(clientName))%>
	   							</div>
								<button class="cancel" onclick="submitRejectForm('true')" style="background: #e3e3e3;"><%=I18NUtil.getMessage("IAM.BACK.TO.APP")%></button>
							<%}else{
							%>
							<div class="normal_text">
									<%=I18NUtil.getMessage("IAM.ACCEPT.APPROVAL.QUERY", IAMEncoder.encodeHTML(clientName))%>
	   						</div>
	   							<%if(grantType){ %>
	   								<input type="checkbox" id='implicitgrnat' onclick="addImplicitGrant(this)"><%=I18NUtil.getMessage("IAM.OAUTH.IMPLICIT.GRANT") %><br>
	   							<% }%>
								<button class="btn" onclick="submitApproveForm()"><%=I18NUtil.getMessage("IAM.CONTACTS.ACCEPT")%></button>
								<button class="cancel" onclick="submitRejectForm('')"><%=I18NUtil.getMessage("IAM.INVITE.REJECT")%></button>
								<%}
							} else {
								if(!userPartOfOrgs && ( throwError  || (ScopeandOrgInfo.length()==servicesWithNoOrgs.size()))){
									%>
									<div class="normal_text">
											<%=I18NUtil.getMessage("IAM.USER.UNAVAILABLE.QUERY", IAMEncoder.encodeHTML(clientName))%>
		   							</div>
									<button class="cancel" onclick="submitDeviceRejectForm()" style="background: #e3e3e3;"><%=I18NUtil.getMessage("IAM.BACK.TO.APP")%></button>
								<%}else{
							%>
								<button class="btn" onclick="submitDeviceApproveForm()"><%=I18NUtil.getMessage("IAM.CONTACTS.ACCEPT")%></button>
                				<button class="cancel" onclick="submitDeviceRejectForm()"><%=I18NUtil.getMessage("IAM.INVITE.REJECT")%></button>
							<%}
							}%>
		    </div>
		    <br/>
		    </div>

		  
		  
            <footer id="footer">
			    <div>
                    <span class="footer_spacing _copy">
                       <%=IAMEncoder.encodeHTML(Util.getCopyRightYear())%>,
                    </span>
                    <span class="footer_spacing">
                       <a href="<%=I18NUtil.getMessage("IAM.ZOHOCORP.LINK")%>" title="<%=I18NUtil.getMessage("IAM.ZOHOCORP")%>" target="_blank" style="font-size:11px;color:#085ddc;"><%=I18NUtil.getMessage("IAM.ZOHOCORP")%></a>
                    </span>
                    <span class="footer_spacing">
                        <%=I18NUtil.getMessage("IAM.ADVENTNET.ALL.RIGHTS.RESERVED")%>
                    </span>
                </div>
		    </footer>
		</div>
</body>

		<script>
        var num_of_prod=<%=subpromptcount%>;
        var servnotConfigured;
        var isImplicitGranted = false;
        var isImplicit = <%=grantType%>;
        var isInternal = <%=isInternal%>;
        var applicationSelected = {};
        var customoauthAppData = {};
        var customoauth = <%=customoauth%>;
        var scopeOrgInfo = <%=ScopeandOrgInfo%>;
		$(function() 
		{	
			$('body').css("overflow-y","hidden"); //No I18N
			servnotConfigured = <%=new JSONArray(servicesWithNoOrgs)%>;<%-- NO OUTPUTENCODING --%>
			$(".profile_pic").css({"background":'url("<%=cPath%>/file?fs=thumb&ID=<%=IAMEncoder.encodeHTML(user.getZuid())%>")no-repeat transparent 0px 0px', "background-size":"100%"});   <%-- NO OUTPUTENCODING --%> <%-- No I18N --%>
			<%if(isMobile) 
			{%>
				$(".profile_pic_enlarge").css({"background":'url("<%=cPath%>/file?fs=thumb&ID=<%=IAMEncoder.encodeHTML(user.getZuid())%>")no-repeat transparent 0px 0px', "background-size":"100%"});   <%-- NO OUTPUTENCODING --%> <%-- No I18N --%>
			<%}
			if(subpromptcount>0){
				%>
				$('.screen').css("display","block"); //No I18N
				$(".modal").css("display","block"); //No I18N
	    		$("#display_prodct_1").css("display","block"); //No I18N
	            $("#1_prod_name").addClass("highlight");
	            $("#back_1").hide();
	            $("#next_"+num_of_prod).html("Submit"); //No I18N
	            <%
            }
			else{
			%>
			$('.screen').hide();
			$(".modal").hide();
            $('.selectedbox_div').css("display","block"); //NO I18N
            $('body').css("overflow-y","scroll"); //No I18N
			$('body').css("height","100%");  //No I18N
			$('html').css("overflow","auto");  //No I18N
			<%if(isOrgInfo){%>
			display_selected();
			<%
			}
			}
			%>
            
			
            var offset= $("#height").outerHeight()-165;// 20 for footer and 120for top
            $(".wrap").css("min-height", offset); //No I18N
            $( window ).resize(function() {
                offset= $("#height").outerHeight()-165;// 20 for footer and 120for top
                $(".wrap").css("min-height", offset); //No I18N
        
            });
            $('.submit_action').hide();


            $("#close_btn").click(function()
            {
                close_modal();
            });
            $("#log_out").click(function(){
            	<% if(isClientPortal) {
            	%>
              		window.parent.location.href='/accounts/logout?client_portal=true&zaid='+'<%=accZaid%>'+'&serviceurl='+'<%=IAMEncoder.encodeURL(reqOriginUrl+"?"+queryParams)%>';
				<% } else { %>
            			window.parent.location.href='/logout?serviceurl='+'<%=IAMEncoder.encodeURL(reqOriginUrl+"?"+queryParams)%>';
            	<% } %>

            });
            $('.profile_pic').click(function(){
            	
            	$('.mob_logout').show();
            });
            
            $('.exit_profile').click(function(){
            	$('.mob_logout').hide();
            });	
		
		});
		function switchradio(element,prod,count,overallcount)
		{
			$(".error").hide();
            $(element).parent().find(".primary-btn").removeClass('highlight_select');
            $(element).parent().find(".select_tick").removeClass('selected_tick');
			$(element).addClass('highlight_select');
			$(element).children('.select_tick').addClass('selected_tick'); //No I18N
			$(element).next().prop("checked", true)//No I18N
            $("#"+count+"_prod_check").show();
            var value= $('input[name='+prod+']:checked', '#display_prodct_'+count).val();
            fullList[prod]=value;
            countmap[overallcount]=count;
		}


function showErrMsg(msg) 
{
    $(".top_div").css({"border-right": "3px solid #ef4444", "color": "#ef4444"}); //No I18N     
    $(".cross_mark").css("background-color","#ef4444");          //No I18N        
    $(".crossline1").css({"top": "18px", "left": "0px", "width":"20px"});   //No I18N        
    $(".crossline2").css("left","0px");     //No I18N
    $('.top_msg').html(msg); //No I18N

    $( ".top_div" ).fadeIn("slow");//No I18N
    
    setTimeout(function() {
        $( ".top_div" ).fadeOut("slow"); //No I18N
    }, 5000);;

}



function showmsg(msg) 
{
    $(".top_div").css({"border-right": "3px solid #50BF54", "color": "#50BF54"});     //No I18N   
    $(".cross_mark").css("background-color","#50BF54");    //No I18N             
    $(".crossline1").css({"top": "22px", "left": "-6px", "width":"12px"});     //No I18N     
    $(".crossline2").css("left","4px");     //No I18N
    $('.top_msg').html(msg); //No I18N

    $( ".top_div" ).fadeIn("slow");//No I18N
    
    setTimeout(function() {
        $( ".top_div" ).fadeOut("slow");//No I18N
    }, 5000);

}
        function close_modal()
        {
                    display_selected();
                    showmsg("<%=I18NUtil.getMessage("IAM.SUBMIT.DESCRIPTION")%>") //No I18N
                    $('.screen').hide();
                     $(".modal").hide();
                    $('.selectedbox_div').slideDown("fast"); //No I18N
                    $('body').css("overflow-y","scroll"); //No I18N
		      		$('body').css("height","100%");  //No I18N
		   			$('html').css("overflow","auto");  //No I18N
        }
        
        function de(id) 
        {
            return document.getElementById(id);
        }
        function check_applicationINFO(count,prod,close)
        {
        	 var value= $('input[name='+prod+']:checked', '#display_prodct_'+count).val();
        		//make application based call and display in UI
				var info = JSON.parse(getApplicationBasedDetails(prod,value.split(".")[0]));
				if(info.error==undefined)
				{
					 $("#display_prodct_"+count+" #first_desc").hide();
					 $("#display_prodct_"+count+" #second_desc").css("display","block");//No I18N
					  
					 $("#display_prodct_"+count+" .services_space").hide();
					 
					 var application_basedselect="";
					 for(i=0;i<info.length;i++)
					 {
						if(info[i].applicationList !== undefined)
						{
							//application_basedselect+='					  <div class="checkbox_div application_field" id="application_field_'+i+'"  onclick="showNewDiv('+i+')" style="display: block;">	<input id="application_toggle_'+i+'"  class="checkbox_check" type="checkbox">	<span class="checkbox">	<span class="checkbox_tick"></span>	</span>	<span for="application_toggle_'+i+'"  class="checkbox_label"><b>'+info[i].applicationName+'</b></span>	</div>					 ';
							application_basedselect+='	 <div class="primary-btn application_field" id="application_field_'+i+'" onclick="showNewDiv('+i+')" >	 <span class="select_tick" onclick="select_application_radio(this,'+i+')"></span>   <span class="select_text"  ><b>'+info[i].applicationName+'</b></span>	</div>	 <input type="radio" class="hide application_radio" id="application_toggle_'+i+'" value="'+info[i].applicationId+'" name="'+prod+'_application_radio" > ';

							application_basedselect+='<div class="applicationdiv" id="groupapplicationdiv'+i+'" style="display: none;">'
							for(j=0;j<info[i].applicationList.length;j++)
							{
								application_basedselect+='<div class="application_options">	 <label for="subapplication_'+i+'_toggle_'+j+'" >'+info[i].applicationList[j].applicationName+'</label>	<input onchange="spcific_appli_check(this)" value="'+info[i].applicationList[j].applicationId+'" id="subapplication_'+i+'_toggle_'+j+'" class="checkbox_check" type="checkbox">	        <span class="checkbox"> <span class="checkbox_tick"></span>     </span> </div>'
							}
							application_basedselect+='</div>'
						} 
						else 
						{
							//application_basedselect+='		<div class="checkbox_div hide" id="application_field_'+i+'" style="display: block;"><input id="application_toggle_'+i+'" class="checkbox_check" type="checkbox">	<span class="checkbox">	<span class="checkbox_tick"></span>	</span>	<label for="application_toggle_'+i+'" class="checkbox_label">'+info[i].applicationName+'</label>	</div>';
							application_basedselect+='			 <div class="primary-btn" id="application_field_'+i+'" >	 <span class="select_tick" onclick="select_application_radio(this,'+i+')" ></span>    <span class="select_text"><b>'+info[i].applicationName+'</b></span>	</div>	<input type="radio" class="hide" id="application_toggle_'+i+'" value="'+info[i].applicationId+'" name="'+prod+'_application_radio" > ';
						}
					 } 
					 
					 var application_basedFormat='<div class="product_application_space" id="'+prod+'application_based'+count+'">'+application_basedselect+'</div> <div class="error" id="'+prod+'application_errorspace"> </div><button class="btn" onclick="submt_ServiceApplication_info('+count+',\''+prod+'\','+close+')">Submit</button>';
					 
					 
					 $("#display_prodct_"+count+" .application_space").append(application_basedFormat);
					 
					 $("#display_prodct_"+count+" .application_space").show();
				}
				else
				{
					if(info.error!=undefined)
					{
						$("#"+count+"_error").html(info.error);
	                    $("#"+count+"_error").fadeIn("slow");
	    
					}
				}
        }
        
        
        function spcific_appli_check(element)
        {
        	$(".error").hide();
        	var selected = [];
        	var head_id=$(element).parent().parent().attr("id");//No I18N
        	var head_num=head_id.substr(-1);
        	
        	
        	$(".application_space .select_tick").removeClass("selected_tick");
        	$(".application_space .primary-btn").removeClass("highlight_select");
        	$(".application_space .application_radio").next().prop("checked", false)//No I18N
        	
        	$('#'+head_id+' input:checked').each(function() {
        	    selected.push($(this).attr('value'));//No I18N
        	});
        	
        	if(selected.length>=1)
        	{
        		$( '.applicationdiv input[type="checkbox"]' ).prop('checked', false);//No I18N
        		$(element).prop('checked', true);//No I18N
        		
        		$("#application_field_"+head_num).addClass('highlight_select');
        		$("#application_field_"+head_num).children('.select_tick').addClass('selected_tick'); //No I18N
    			$("#application_toggle_"+head_num).prop("checked", true)//No I18N
    			
        	}
        }
        
        
        function select_application_radio(element,app_num)
        {
        	$(".error").hide();
        	$(".application_space .select_tick").removeClass("selected_tick");
        	$(".application_space .primary-btn").removeClass("highlight_select");
        	$(".application_space .application_radio").next().prop("checked", false)//No I18N
        	element=$(element).parent();
        	
        	$( '.applicationdiv input[type="checkbox"]' ).prop('checked', false);//No I18N
        	
        	if($("#groupapplicationdiv"+app_num).length != 0)
        	{	
            	if(!$("#application_field_"+app_num).hasClass("selected_applicationDIV"))
            	{
            		$(".applicationdiv").slideUp();//hide all
	            	$(".application_field").removeClass("selected_applicationDIV");
            		
            		
            		$("#application_field_"+app_num).addClass("selected_applicationDIV");
	        		$("#groupapplicationdiv"+app_num).slideDown();
            	}
            	
	        	$( '#groupapplicationdiv'+app_num+' input[type="checkbox"]' ).prop('checked', true);//No I18N
	        	
	        	event.stopPropagation();
        	}
        	else
        	{
        		$(".applicationdiv").slideUp();//hide all
            	$(".application_field").removeClass("selected_applicationDIV");
        	}
        	$(element).addClass('highlight_select');
        	$(element).children('.select_tick').addClass('selected_tick'); //No I18N
			$(element).next().prop("checked", true)//No I18N
        }
        
        function showNewDiv(i)
        {
			if(!$("#groupapplicationdiv"+i).is(":visible"))
			{
	        	$(".applicationdiv").slideUp();//hide all
	        	$(".application_field").removeClass("selected_applicationDIV");
	        	
	        	$("#application_field_"+i).addClass("selected_applicationDIV");
	        	$("#groupapplicationdiv"+i).slideDown();
			}
			else
			{
				$("#groupapplicationdiv"+i).slideUp();
				$("#application_field_"+i).removeClass("selected_applicationDIV");
			}
        }
        
		function change_div(count,prod,isapp)
		{
                $(".error").hide();
                var value= $('input[name='+prod+']:checked', '#display_prodct_'+count).val();
                if(value)
                {
                    $("#"+count+"_prod_check").show();	
    				$("#"+count+"_prod_name").removeClass("highlight");
    				
    				if(isapp){
    				check_applicationINFO(count,prod,false);
    				} else {
    					change_product(count,prod);
    				}
			
		        }
                else
                {
                    $("#"+count+"_error").html("<%=I18NUtil.getMessage("IAM.SERVICE.CHOOSE.ERROR")%>");
                    $("#"+count+"_error").fadeIn("slow");

                }
        }

		
		function submt_ServiceApplication_info(count,product,close)
		{
			$(".error").hide();
			var radio_id=$('input[name="'+product+'_application_radio"]:checked').attr("id");//NO I18N
			if(radio_id==undefined)
			{
				 $('#'+product+'application_errorspace').html("<%=I18NUtil.getMessage("IAM.SERVICE.CHOOSE.ERROR")%>");
				 $('#'+product+'application_errorspace').fadeIn("slow");//No I18N
				return;
			}
			
			var radio_id_num=radio_id.substr(-1);
			
			
			applicationSelected[product] = $('input[name='+product+'_application_radio]:checked').val()//No I18N
			
			
			if($("#groupapplicationdiv"+radio_id_num).length>0)
			{
				
				var selected = [];
				$("#groupapplicationdiv"+radio_id_num+" input:checked").each(function() {
	        	    selected.push($(this).attr('value'));//No I18N
	        	});
				
				if(selected.length==1)
				{
					applicationSelected[product] = selected[0];
				}
				
				
			}
			
			$("#display_prodct_"+count+" .application_space").html("");
			$("#display_prodct_"+count+" #first_desc").show();
			$("#display_prodct_"+count+" #second_desc").hide();
			$("#display_prodct_"+count+" .services_space").show();
			
			if(close){
				close_modal();
			}
			else {
				change_product(count,product);
			}
			
		}
		
		function change_product(count,product)
		{
			$("#display_prodct_"+count).hide();
		 	if(de("display_prodct_"+(count+1)))
			{
			    $("#display_prodct_"+(count+1)).show();
       			$("#"+(count+1)+"_prod_name").addClass("highlight");
			}
	     	if(count<num_of_prod)
	        {	
		        return;
		    }
			$(".modal").hide();
			display_selected();
            $('.but_action').hide();
            $('.submit_action').show();
            showmsg("<%=I18NUtil.getMessage("IAM.SUBMIT.DESCRIPTION")%>"); //No I18N

			$('.screen').hide();
            $('.close_btn').show();
            $('.selectedbox_div').slideDown("fast");//No I18N
		}
		
        function display_selected()
        {
            var service;
            var prod;
            var prod_icon;
            var isorg;
            $( "#selectedbox_div" ).empty();
            i=1;
            <%
  			for (String service : ScopeandOrgInfo.keySet())
  			{ %>
  			 isorg = false;
  			 var prod = '<%=IAMEncoder.encodeHTML(service)%>';
        	 prod_icon="x2_"+prod.toLowerCase()+"_icon"; //No I18N
             $( "#selectedbox_div" ).append( '<div class="showselected" ><span class="servicelogo" id="servicelogo_'+i+'"></span><div class="servicedetails"><span class="servicehead" id="servicehead_'+i+'"></span><span class="service_selectedoption"></span><br><span class="customoauth" id="customoauth_'+i+'"></span></div><div id="scopes_'+i+'"><ul></ul></div></div>' );  //No I18N
             $( "#servicelogo_"+i ).addClass(prod_icon);
             $( "#servicehead_"+i).html(scopeOrgInfo[prod].DisplayName);
             <%if(!isInternal){%>
         	 for(var j=0;j<scopeOrgInfo[prod].Description.length;j++){
				$( "#scopes_"+i+" ul" ).append(scopeOrgInfo[prod].Description[j]);
			  }
         	 <%}%>
         	 if(fullList.hasOwnProperty(prod)){
         		isorg = true;
         		$( "#servicehead_"+i).next().html(fullList[prod].split(".")[1]);
         		<%if(!servicesSkipped.contains(service)){%>
         		$( "#servicehead_"+i).parent().attr("onclick", "edit_spec("+i+")"); //NO I18N				
				$( "#servicehead_"+i).next().append('<svg version="1.1" id="Layer_1" x="0px" y="0px"viewBox="0 0 512 512" xml:space="preserve"><g id="pencil_iconid"><path class="path1" d="M432,0c44.2,0,80,35.8,80,80c0,18-6,34.6-16,48l-32,32L352,48l32-32C397.4,6,414,0,432,0z M32,368L0,512l144-32l296-296L328,72L32,368z M357.8,181.8l-224,224l-27.6-27.6l224-224L357.8,181.8z"></path></g></svg>'); //NO I18N
				<%}%>
         	 } 
         	 <%if(isMobile) {%>
				$('svg').css("opacity",".5");  //No I18N
			<%}%>
			 <%if(servicesWithNoOrgs.contains(service)){%>
         	isorg = true;
         	 $( "#servicelogo_"+i ).addClass('dullimage');
     	     $( "#servicehead_"+i).next().html('<%=I18NUtil.getMessage("IAM.SCOPE.RESTRICTION",ScopeandOrgInfo.getJSONObject(service).getString("DisplayName"))%>');
    	     $( "#scopes_"+i ).addClass('scopes_cross_empty');
     	     $( "#scopes_"+i+" ul li" ).append("<span class='scopes_cross'></span>");
     	     <%} else { %>
     	     $( "#scopes_"+i ).addClass('scopes');
     	     <%}
         	 if (servicesWithAllOrgs.contains(service)) {%>
         	isorg = true;
         	 $( "#servicehead_"+i).next().html('<%=I18NUtil.getMessage("IAM.OAUTH.ALL.ORG.ACCESS",ScopeandOrgInfo.getJSONObject(service).getString("DisplayName"))%>');
     	     <%}%>
     	    if(customoauth!=null && customoauth.hasOwnProperty('applicationName') && customoauth.hasOwnProperty('applicationId') && customoauth.servicename.toLowerCase() == prod.toLowerCase() ){
				 if(customoauth.hasOwnProperty('description')){
						$("#customoauth_"+i).html('<div class="tooltip">'+customoauth.applicationName+'<span class="infoicon"></span><span class="tooltiptext">'+customoauth.description+'</span></div>');
					}
				 else {
						$("#customoauth_"+i).html('<div class="tooltip">'+customoauth.applicationName+'</div>'); // NO I18N
					}
				  customoauthAppData[prod] = customoauth.applicationId;
			}  
     	    if(!isorg) {
				 $( "#servicehead_"+i).addClass('empty_org');
			}
             i++;
             <%}%>
            $('.modal').css("position","fixed");
            $('body').css("overflow-y","scroll");
			$('body').css("height","100%");  //No I18N
			$('html').css("overflow","auto");  //No I18N
        }
        function edit_spec(count)
        {
            $('.screen').show();
            $('body').css("overflow-y","hidden"); //No I18N
            $(".modal").show();
            goto_prod(countmap[count]);
        }
        function back_div(count)
        {
                    $(".error").hide();
                    $("#display_prodct_"+count).hide();
                    $("#display_prodct_"+(count-1)).show();
                    $("#"+count+"_prod_name").removeClass("highlight");
                    $("#"+(count-1)+"_prod_name").addClass("highlight");

        }

       function goto_prod(count)
        {
    	    $(".error").hide();
            var check;
            if(Object.keys(fullList).length==0)
            {
                check=1;
            }
            else
                check=Object.keys(fullList).length;
            if(count<=(check))
            {
                $(".product_select").hide();
                $("#display_prodct_"+count).show();
                $(".product").removeClass("highlight");
                $("#"+count+"_prod_name").addClass("highlight");
            }
            else
                {
                    $("#"+check+"_error").html("<%=I18NUtil.getMessage("IAM.SERVICE.CHOOSE.ERROR.NEXT")%>");
                    $("#"+check+"_error").fadeIn("slow");
    

                }
        }      
<%if(isDirectAccess) {%>


function getPlainResponse(action, params) {
    if(params.indexOf("&") === 0) {
	params = params.substring(1);
    }
    var objHTTP,result;objHTTP = xhr();
    objHTTP.open('POST', action, false);
    objHTTP.setRequestHeader('Content-Type','application/x-www-form-urlencoded;charset=UTF-8');
    if(!params || params === '') {
        params = "__d=e"; //No I18N
    }
    objHTTP.setRequestHeader('Content-length', params.length);
    objHTTP.send(params);
    return objHTTP.responseText;
}

function xhr() {
    var xmlhttp;
    if (window.XMLHttpRequest) {
	xmlhttp=new XMLHttpRequest();
    }
    else if(window.ActiveXObject) {
	try {
	    xmlhttp=new ActiveXObject("Msxml2.XMLHTTP");
	}
	catch(e) {
	    xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	}
    }
    return xmlhttp;
}
<%}%>

function getcsrfParams() {
	var csrfParam = "<%=SecurityUtil.getCSRFParamName(request)%>"; //NO OUTPUTENCODING
	var csrfCookieName = "<%=SecurityUtil.getCSRFCookieName(request)%>"; //NO OUTPUTENCODING
	var params = csrfParam + "=" + getCookie(csrfCookieName);
	return params;
	 
}

function getCookie(cookieName) {
    var nameEQ = cookieName + "=";
    var ca = document.cookie.split(';');
    for(var i=0;i < ca.length;i++) {
        var c = ca[i].trim();
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
    }
    return null;
}

function submitDeviceApproveForm() {
	var approvedOrgs = "";
 	if(Object.keys(fullList).length > 0){
 		Object.keys(fullList).forEach(function(key) {
 			approvedOrgs += key+"."+fullList[key].split(".")[0];
 			approvedOrgs +=",";
 			})
	}
 	
 	  for(var i=0; i<servnotConfigured.length; i++){ 
 		approvedOrgs += servnotConfigured[i];
		approvedOrgs +=",";
 	}

	var params = "approvedScope=<%=scopeDetailsParam%>&" + getcsrfParams()+"&is_ajax=true&Vcode=<%=vCode%>";
	if(approvedOrgs){
	params = params + "&approvedOrgs="+approvedOrgs; //No I18N
	}
	if(Object.keys(applicationSelected).length !== 0 ){
		params = params + "&applicationSelected="+ encodeURI(JSON.stringify(applicationSelected));//no I18N
	}
	var resp = getPlainResponse("<%=request.getContextPath()%>/oauth/v3/device/approve", params); //NO OUTPUTENCODING //No I18N
	resp = resp ? resp.trim() : "";//No I18N
	var jsonStr = JSON.parse(resp);
	if(jsonStr != null && jsonStr.redirect_uri) {
		<% if(closeBrowser) { %>
		showDeviceManageSuccess('<%=I18NUtil.getMessage("IAM.DEVICEOAUTH.REQ.APPROVED")%>');
		window.close();
		<% }  else { %>
			showDeviceManageSuccess('<%=I18NUtil.getMessage("IAM.DEVICEOAUTH.REQ.APPROVED")%>');
	 <% 	} %>
	} else {
		showErrMsg('<%=I18NUtil.getMessage("IAM.ERROR.GENERAL")%>');
	}
}

function submitDeviceRejectForm() {
	var params = "<%=queryParams%>&" + getcsrfParams()+"&is_ajax=true&Vcode=<%=vCode%>"; //No I18N
	var resp = getPlainResponse("<%=request.getContextPath()%>/oauth/v3/device/reject", params); //NO OUTPUTENCODING //No I18N
	resp = resp ? resp.trim() : "";//No I18N
	var jsonStr = JSON.parse(resp);
	if(jsonStr != null && jsonStr.redirect_uri) {
		<% if(closeBrowser) { %>
		showDeviceManageSuccess('<%=I18NUtil.getMessage("IAM.DEVICEOAUTH.REQ.REJECTED")%>');
		window.close();
	<% }  else { %>
		showDeviceManageSuccess('<%=I18NUtil.getMessage("IAM.DEVICEOAUTH.REQ.REJECTED")%>');
		<% 	} %>
	} else {
		showErrMsg('<%=I18NUtil.getMessage("IAM.ERROR.GENERAL")%>');;
	}
}

function submitApproveForm() {
	//has to be improved
 	var approvedOrgs = "";
 	if(Object.keys(fullList).length > 0){
 		Object.keys(fullList).forEach(function(key) {
 			approvedOrgs += key+"."+fullList[key].split(".")[0];
 			approvedOrgs +=",";
 			})
	}
 	
 	for(var i=0; i<servnotConfigured.length; i++){ 
 		approvedOrgs += servnotConfigured[i];
		approvedOrgs +=",";
 	}

 	var params = "<%=queryParams%>&approvedScope=<%=scopeDetailsParam%>&" + getcsrfParams()+"&is_ajax=true&implicitGranted="+isImplicitGranted; //No I18N
	if(approvedOrgs){
		params += "&approvedOrgs="+approvedOrgs; //NO I18N
	}
 	if(Object.keys(applicationSelected).length !== 0 ){
		params = params + "&applicationSelected="+ encodeURI(JSON.stringify(applicationSelected));//no I18N
	}
 	if(Object.keys(customoauthAppData).length != 0){
 		params = params + "&customoauthAppData="+ encodeURI(JSON.stringify(customoauthAppData));//no I18N
 	}
 	var reqUri = "";
 	if(<%= isClientPortal %>){
 		reqUri = "<%=request.getContextPath()%>/clientoauth/v2/<%=accZaid%>/approve";
 	} else if(<%= isorgoauth %>){
 		reqUri = "<%=request.getContextPath()%>/oauth/v2/org/approve";
 		
    }else {
 		reqUri = "<%=request.getContextPath()%>/oauth/v2/approve";
 	}
	var resp = getPlainResponse(reqUri, params); //NO OUTPUTENCODING 
	resp = resp ? resp.trim() : "";//No I18N
	var jsonStr = JSON.parse(resp);
	if(jsonStr != null && jsonStr.redirect_uri) {
		<%-- var msg_to_user = '<%=Util.getI18NMsg(request, "IAM.DEVICEOAUTH.REQ.APPROVED.WITH.LINK")%>';
		msg_to_user = msg_to_user.replace("$REDIRECT_URI", jsonStr.redirect_uri);
		showDeviceManageSuccess(msg_to_user); --%>
		window.location =  jsonStr.redirect_uri;
	} else {
		showErrMsg('<%=I18NUtil.getMessage("IAM.ERROR.GENERAL")%>');
	}
}

function submitRejectForm(valid) {
	var params = "<%=queryParams%>&" + getcsrfParams()+"&is_ajax=true"; //No I18N
	if(valid!=''){
		params += "&hasNoOrgs=true";//No I18N
	}
	var reqUri = "";
 	if(<%= isClientPortal %>){
 		reqUri = "<%=request.getContextPath()%>/clientoauth/v2/<%=accZaid%>/reject";
 	} else {
 		reqUri = "<%=request.getContextPath()%>/oauth/v2/reject";
 	}
	var resp = getPlainResponse(reqUri, params); //NO OUTPUTENCODING 
	resp = resp ? resp.trim() : "";//No I18N
	var jsonStr = JSON.parse(resp);
	if(jsonStr != null && jsonStr.redirect_uri) {
		<%-- var msg_to_user = '<%=Util.getI18NMsg(request, "IAM.DEVICEOAUTH.REQ.REJECTED.WITH.LINK")%>';
		msg_to_user = msg_to_user.replace("$REDIRECT_URI", jsonStr.redirect_uri); --%>
		//showDeviceManageSuccess(msg_to_user);
		window.location =  jsonStr.redirect_uri;
	} else {
		showErrMsg('<%=I18NUtil.getMessage("IAM.ERROR.GENERAL")%>');
	}
}

function getApplicationBasedDetails(serviceName,zid){
	var params = "servicename="+serviceName+"&zid="+zid+"&"+getcsrfParams();//No I18N
	var out = getPlainResponse("<%=request.getContextPath()%>/oauth/fetch/application", params);
	return out;
}


function showDeviceManageSuccess(msg) {
	$('#Approve_Reject').hide();
	$('#scope_resp').html(msg);
	$('#scope_resp').show();
}

function addImplicitGrant(ischecked){
	if(isImplicit && ischecked.checked){
		isImplicitGranted = true;
	}else{
		isImplicitGranted = false;
	}
}
</script>
</html>