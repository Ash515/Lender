<!DOCTYPE html>
<html>
<head>
<title><@i18n key="IAM.ORGINVITATION.TITLE" /></title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<#include "za_accept_account_merge_invitation_static">
</head>
<body>
 	<div id="height"></div>
	<div class="blur_screen"></div>
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
		<header>	
			<#if partner.isPartnerLogoExist>
				<div>
					<img class="partnerlogo" src="/static/file?t=org&ID=${partner.partnerId}" />
				</div>
			<#else>
				<div class="logo"></div>
			</#if>
		</header>
		<br />
		
		<div class="announcement_popup">
			<div class="success_tick"></div>
			<div class="success_message"></div>
			<div class="btn_center verify_btn" id="continue"></div>
		</div>
		<div class="wrap">
			<form name="accountinvitationform" class="form" action="${za.contextpath}/accmergeinvite.ac" method="post">	
				<#if isvalidrequest>
					<#if acceptinvitation>
						<#if isNotOrgAdmin>
							<span class="head_text"><@i18n key="IAM.ORG.INVITATION.FAILURE.TITLE" /></span>
							<span class="announcement_text">
								<@i18n key="IAM.ORG.INVITATION.ROLE.NOT.SUPPORT" arg0="${userexistingorg}" />        
							</span>
					    <#elseif conflict>
							<span class="head_text"><@i18n key="IAM.ORG.INVITATION.FAILURE.TITLE" /></span>
							<#if dataconflict>
								<span class="announcement_text">
									<@i18n key="IAM.ORG.INVITATION.DATA.LOSS" arg0="${userexistingorg}" arg1="${conflictservices}" arg2="${za.config.accountsServer}"/>
								</span>
							</#if>
							<#if directoryconflict>
								<span class="announcement_text">
									<@i18n key="IAM.ORG.DIRECTORY.DISASSOCIATE" arg0="${directoryconflictservices}" />
								</span>
							</#if>
						<#elseif isError>
							<span class="head_text"><@i18n key="IAM.ORG.INVITATION.FAILURE.TITLE" /></span>
							<span class="announcement_text">
								<@i18n key="IAM.ORG.INVITATION.UNKNOWN.ERROR" />        
							</span>
						<#elseif acceptinvitation>
							<span class="head_text"><@i18n key="IAM.ORG.MERGE" /></span>
							<span class="name"><@i18n key="IAM.TEMPLATE.SIGNUP.ORG.MERGE.SUBTITLE.EXISTING" arg0="${emailid}" /></span>
							<span class="announcement_text">
								<@i18n key="IAM.ORG.MERGE.CONFIRM" arg0="${userexistingorg}" arg1="${currentorg}" />       
							</span>
							<div class="merge_info_box">
				                <#if migratingUserCount??>
										<div class="merge_header">
				                    		<div class="merge_icon users_icon"></div>
				                    		<div class="merge_desc">
				                        		<div class="innerbox_head"><@i18n key="IAM.ORGINVITATION.ACCEPT.USERS.HEADDING" /> </div>
				                        		<div class="innerbox_discription "><@i18n key="IAM.ORGINVITATION.ACCEPT.USERS.COUNT" arg0="${migratingUserCount}" /></div>
				                      		</div>
				                      	</div>
				                </#if>

				                <#if totalGroupsMigratingCount??>
				                		<div class="merge_header">
				                    		<div class="merge_icon grp_icon"></div>
				                    		<div class="merge_desc">
				                        		<div class="innerbox_head"><@i18n key="IAM.ORGINVITATION.ACCEPT.GROUPS.HEADDING" /> </div>
				                        		<div class="innerbox_discription "><@i18n key="IAM.ORGINVITATION.ACCEPT.GROUPS.COUNT" arg0="${totalGroupsMigratingCount}" /></div>
				                    		</div>
				                    	</div>
				                </#if>

				                <#if totalAppsMigratingCount??>
										<div class="merge_header" id="app_space">
				                    		<div class="merge_icon app_icon"></div>
				                    		<div class="merge_desc">
				                        		<div class="innerbox_head"><@i18n key="IAM.ORGINVITATION.ACCEPT.APPLICATION.HEADDING" /> </div>
				                        		<div class="innerbox_discription "><span class="extra_apps"><@i18n key="IAM.ORGINVITATION.ACCEPT.APPLICATION.COUNT" arg0="${totalAppsMigratingCount}" /><span></div>
				                        		<div class="services_box">
				                            		 <#list totalAppsMigrating as app>
				                            			<div class="service_space">
				                            	    		<div class="service_icon ${app?ensure_starts_with("zoho")?lower_case}_icon"></div>
				                                			<div class="service_head">${app}</div>
				                            			</div>
				                            		</#list>
				                        		</div>
				                    		</div>
				                    	</div>
				                </#if>
				            </div>

				            <div class="btns">
				            	<button class="verify_btn" type=submit name="submit">
				            		<span class=""><@i18n key="IAM.TPL.ORGINVITATION.TOACCEPT" /></span>
									<span class="btn_loading"></span>
								</button>
				               	<a href="${za.config.accountsServer}" class="skip_btn"><@i18n key="IAM.CANCEL" /></a>
				           </div>
						</#if>
					<#else>
						<span class="head_text"><@i18n key="IAM.ORG.MERGE" /></span>
							<span class="announcement_text" ><@i18n key="IAM.ORGMERGEINVITATION.REJECT.SUBTITLE" arg0="${emailid}" arg1="${userexistingorg}" arg2="${currentorg}"/></span>
						<div class="btns">
			                <input class="verify_btn" type="submit" value="<@i18n key="IAM.TPL.ORGINVITATION.TOREJECT" />">
			            </div>
					</#if>
				<#elseif isAlreadyJoined>
					<span class="head_text"><@i18n key="IAM.ORG.INVITATION.FAILURE.TITLE" /></span>
				    <span class="announcement_text">
				    	<@i18n key="IAM.ORGINVITATION.ALREADY.ACCEPTED" arg0="${za.config.accountsServer}"/>
			        </span>
				<#elseif islogoutNeeded>
					<span class="head_text"><@i18n key="IAM.ORG.INVITATION.FAILURE.TITLE" /></span>
					<span class="announcement_text">
					    	<@i18n key="IAM.SIGNING.IN.ALREADY" arg0="${currentloggedInuser}" arg1="${logouturl}"/>
			        </span>
				<#elseif inActiveInvitation>
					<span class="head_text"><@i18n key="IAM.ORG.INVITATION.FAILURE.TITLE" /></span>
					<span class="announcement_text">
						<@i18n key="IAM.ORGINVITATION.INACTIVE.ADMIN" />        
					</span>
				<#else>
					<span class="head_text"><@i18n key="IAM.ORG.INVITATION.FAILURE.TITLE" /></span>
					<span class="announcement_text">
						<@i18n key="IAM.INVALID.REQUEST" />        
					</span>
				</#if>
			</form>
	    </div>
	    <footer id="footer">
	      <div>
			<#if !partner.isPartnerHideHeader>
			<#if partner.isfujixerox>
				<a href='${tos_link}' target="_blank"><@i18n key="IAM.SIGNUP.TERMS.OFSERVICE" /></a>
				<a href='${privacy_link}' target="_blank"><@i18n key="IAM.PRIVACY" /></a>
				<a href='<@i18n key="IAM.CONTACT.LINK" />' target="_blank"><@i18n key="IAM.CONTACT.US" /></a>
			<#else>
				<span><@i18n key="IAM.FOOTER.COPYRIGHT" arg0="2012"/></span>
			</#if>
			</#if>
		   </div>
		</footer>
	</div> 
</body>

<script>
        $(document).ready(function() {
   		     var offset= $("#height").outerHeight()-155;// 20 for footer and 120for top
    		 $(".wrap").css("min-height", offset);
    		 $( window ).resize(function() {
    		 offset= $("#height").outerHeight()-155;// 20 for footer and 120for top
        	 $(".wrap").css("min-height", offset);
    		});
        
			$(document.body).css("visibility", "visible");
			$(document.accountinvitationform).zaAccountInvitation();
			$(".extra_apps").click(function(){
                    $(".services_box").show();
                    $("#app_space .innerbox_discription").hide();
                });
		});
</script> 

</html>          
            
                            
            
            
            

