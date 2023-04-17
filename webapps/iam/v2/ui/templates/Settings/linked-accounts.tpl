<script>
var csrfParam= "${za.csrf_paramName}";
var csrfCookieName = "${za.csrf_cookieName}";
</script>


				<div class="hide popup" tabindex="1"id="popup_linked-accounts_contents">
					<div class="authweb_popup_head" id="linked_acc_popup_head"></div>
					<div class="close_btn" onclick="close_linked_accounts_screen()"></div>
					<div id="link_account_info" class="list_show">
								<div class="info_div">
									<div class="info_lable"><@i18n key="IAM.LINKEDACCOUNTS.ADDED.TIME" /></div>
									<div class="info_value" id="pop_up_time"></div>
								</div>
								<div class="info_div">
									<div class="info_lable"><@i18n key="IAM.OS.NAME.HEADING" /></div>
									<div class="info_value" id="pop_up_os"><div class="asession_os_popup"></div></div>
								</div>
								<div class="info_div">
									<div class="info_lable"><@i18n key="IAM.LOGINHISTORY.BROWSERAGENT.BROWSER" /></div>
									<div class="info_value" id="pop_up_browser"><div class="asession_browser_popup"></div></div>
								</div>
								<div class="info_div">
									<div class="info_lable"><@i18n key="IAM.AUTHORIZED.WEBSITES.TRUSTED.LOCATION" /></div>
									<div class="info_value" id="pop_up_location"><@i18n key="IAM.SESSIONS.LOCATION.UNAVAILABLE" /></div>
									<div class="info_ip"></div>
								</div>
					</div>
					<span id="linked_acc_popup_info"></span>
				</div>
				
				
				<div class="box big_box " id="linked_acc_box">
				
					<div class="box_blur"></div>
					<div class="loader"></div>
				
					<div class="box_info" >
						<div class="box_head"><@i18n key="IAM.LINKED.ACCOUNTS" /><span class="icon-info"></span></div>
						<div class="box_discrption"><@i18n key="IAM.LINKEDACCOUNTS.DESCRIPTION" /></div>
					</div>
					
					<!-- listing all possible idps for this dc -->
					<div id="all_idps" style="padding-bottom: 30px; display: block;">
					
					<#if google>
					<div class="idp_option" onclick="thirdparty_authentication('GOOGLE');">
					<div class="idp_icon google_icon"></div>
					<div class="idp_name"><@i18n key="IAM.IDENTITY.PROVIDER.NAME.GOOGLE" /></div>					
					</div>
					</#if>
					
					<#if azure>
					<div class="idp_option" onclick="thirdparty_authentication('AZURE');">
					<div class="idp_icon azure_icon"></div>
					<div class="idp_name"><@i18n key="IAM.IDENTITY.PROVIDER.NAME.MICROSOFT" /></div>					
					</div>
					</#if>
					
					<#if linkedin>
					<div class="idp_option" onclick="thirdparty_authentication('LINKEDIN');">
					<div class="idp_icon linkedin_icon"></div>
					<div class="idp_name"><@i18n key="IAM.IDENTITY.PROVIDER.NAME.LINKEDIN" /></div>					
					</div>
					</#if>
					
					<#if facebook>
					<div class="idp_option" onclick="thirdparty_authentication('FACEBOOK');">
					<div class="idp_icon facebook_icon"></div>
					<div class="idp_name"><@i18n key="IAM.IDENTITY.PROVIDER.NAME.FACEBOOK" /></div>					
					</div>
					</#if>
							
					<#if twitter>
					<div class="idp_option" onclick="thirdparty_authentication('TWITTER');">
					<div class="idp_icon twitter_icon"></div>
					<div class="idp_name"><@i18n key="IAM.IDENTITY.PROVIDER.NAME.TWITTER" /></div>					
					</div>
					</#if>
					
					<#if yahoo>
					<div class="idp_option" onclick="thirdparty_authentication('YAHOO');">
					<div class="idp_icon yahoo_icon"></div>
					<div class="idp_name"><@i18n key="IAM.IDENTITY.PROVIDER.NAME.YAHOO" /></div>					
					</div>
					</#if>
					
					
					<#if slack>
					<div class="idp_option" onclick="thirdparty_authentication('SLACK');">
					<div class="idp_icon slack_icon"></div>
					<div class="idp_name"><@i18n key="IAM.IDENTITY.PROVIDER.NAME.SLACK" /></div>					
					</div>
					</#if>
					
					<#if douban>
					<div class="idp_option" onclick="thirdparty_authentication('DOUBAN');">
					<div class="idp_icon douban_icon"></div>
					<div class="idp_name"><@i18n key="IAM.IDENTITY.PROVIDER.NAME.DOUBAN" /></div>					
					</div>
					</#if>
					
					<#if baidu>
					<div class="idp_option" onclick="thirdparty_authentication('BAIDU');">
					<div class="idp_icon baidu_icon"></div>
					<div class="idp_name"><@i18n key="IAM.IDENTITY.PROVIDER.NAME.BAIDU" /></div>					
					</div>
					</#if>
					
					<#if weibo>
					<div class="idp_option" onclick="thirdparty_authentication('WEIBO');">
					<div class="idp_icon weibo_icon"></div>
					<div class="idp_name"><@i18n key="IAM.IDENTITY.PROVIDER.NAME.WEIBO" /></div>					
					</div>
					</#if>
					
					<#if wechat>
					<div class="idp_option" onclick="thirdparty_authentication('WECHAT');">
					<div class="idp_icon wechat_icon"></div>
					<div class="idp_name"><@i18n key="IAM.IDENTITY.PROVIDER.NAME.WECHAT" /></div>					
					</div>
					</#if>
					
					<#if qq>
					<div class="idp_option" onclick="thirdparty_authentication('QQ');">
					<div class="idp_icon qq_icon"></div>
					<div class="idp_name"><@i18n key="IAM.IDENTITY.PROVIDER.NAME.QQ" /></div>					
					</div>
					</#if>
					
					<#if apple>
					<div class="idp_option" onclick="thirdparty_authentication('APPLE');">
					<div class="idp_icon apple_icon"></div>
					<div class="idp_name"><@i18n key="IAM.IDENTITY.PROVIDER.NAME.APPLE" /></div>					
					</div>
					</#if>
								
					</div>
					
					
					<div id="no_linkedaccount" class="box_content_div">
						<div class="no_data no_data_SQ"></div>
						<div class="no_data_text"><@i18n key="IAM.LINKEDACCOUNT.NOT_PRESENT" /> </div>
		 			</div>
		 		
					<div id="all_linked_accounts" class="list_show hide">
					</div>
					
					
					<!-- slide add idps div -->
					<div class="add_new_account_container">
					<div id="idps_slide_container">
					<div class="closeicon" id="IDP_container_slideup"></div>
					
										
					<div class="addnew half addnew_account_heading" onclick="IDP_container_slidedown();"><@i18n key="IAM.LINKEDACCOUNTS.ADD.NEW.ACCOUNT" /></div>
					<div class="idps_list" id="idps_list" style="display: none;">
					
					<#if google>
					<div class="idp_option idp_opt_slide" onclick="thirdparty_authentication('GOOGLE');">
					<div class="idp_icon google_icon"></div>
					<div class="idp_name"><@i18n key="IAM.IDENTITY.PROVIDER.NAME.GOOGLE" /></div>					
					</div>
					</#if>
					
					<#if azure>
					<div class="idp_option idp_opt_slide" onclick="thirdparty_authentication('AZURE');">
					<div class="idp_icon azure_icon"></div>
					<div class="idp_name"><@i18n key="IAM.IDENTITY.PROVIDER.NAME.MICROSOFT" /></div>					
					</div>
					</#if>
					
					<#if linkedin>
					<div class="idp_option idp_opt_slide" onclick="thirdparty_authentication('LINKEDIN');">
					<div class="idp_icon linkedin_icon"></div>
					<div class="idp_name"><@i18n key="IAM.IDENTITY.PROVIDER.NAME.LINKEDIN" /></div>					
					</div>
					</#if>
					
					<#if facebook>
					<div class="idp_option idp_opt_slide" onclick="thirdparty_authentication('FACEBOOK');">
					<div class="idp_icon facebook_icon"></div>
					<div class="idp_name"><@i18n key="IAM.IDENTITY.PROVIDER.NAME.FACEBOOK" /></div>					
					</div>
					</#if>
							
					<#if twitter>
					<div class="idp_option idp_opt_slide" onclick="thirdparty_authentication('TWITTER');">
					<div class="idp_icon twitter_icon"></div>
					<div class="idp_name"><@i18n key="IAM.IDENTITY.PROVIDER.NAME.TWITTER" /></div>					
					</div>
					</#if>
					
					<#if yahoo>
					<div class="idp_option idp_opt_slide" onclick="thirdparty_authentication('YAHOO');">
					<div class="idp_icon yahoo_icon"></div>
					<div class="idp_name"><@i18n key="IAM.IDENTITY.PROVIDER.NAME.YAHOO" /></div>					
					</div>
					</#if>
					
					<#if slack>
					<div class="idp_option idp_opt_slide" onclick="thirdparty_authentication('SLACK');">
					<div class="idp_icon slack_icon"></div>
					<div class="idp_name"><@i18n key="IAM.IDENTITY.PROVIDER.NAME.SLACK" /></div>					
					</div>
					</#if>
					
					<#if douban>
					<div class="idp_option idp_opt_slide" onclick="thirdparty_authentication('DOUBAN');">
					<div class="idp_icon douban_icon"></div>
					<div class="idp_name"><@i18n key="IAM.IDENTITY.PROVIDER.NAME.DOUBAN" /></div>					
					</div>
					</#if>
					
					<#if qq>
					<div class="idp_option idp_opt_slide" onclick="thirdparty_authentication('QQ');">
					<div class="idp_icon qq_icon"></div>
					<div class="idp_name"><@i18n key="IAM.IDENTITY.PROVIDER.NAME.QQ" /></div>					
					</div>
					</#if>
					
					<#if wechat>
					<div class="idp_option idp_opt_slide" onclick="thirdparty_authentication('WECHAT');">
					<div class="idp_icon wechat_icon"></div>
					<div class="idp_name"><@i18n key="IAM.IDENTITY.PROVIDER.NAME.WECHAT" /></div>					
					</div>
					</#if>
					
					<#if weibo>
					<div class="idp_option idp_opt_slide" onclick="thirdparty_authentication('WEIBO');">
					<div class="idp_icon weibo_icon"></div>
					<div class="idp_name"><@i18n key="IAM.IDENTITY.PROVIDER.NAME.WEIBO" /></div>					
					</div>
					</#if>
					
					<#if baidu>
					<div class="idp_option idp_opt_slide" onclick="thirdparty_authentication('BAIDU');">
					<div class="idp_icon baidu_icon"></div>
					<div class="idp_name"><@i18n key="IAM.IDENTITY.PROVIDER.NAME.BAIDU" /></div>					
					</div>
					</#if>
					
					<#if apple>
					<div class="idp_option idp_opt_slide" onclick="thirdparty_authentication('APPLE');">
					<div class="idp_icon apple_icon"></div>
					<div class="idp_name"><@i18n key="IAM.IDENTITY.PROVIDER.NAME.APPLE" /></div>					
					</div>
					</#if>
					
					<#if intuit>
					<div class="idp_option idp_opt_slide" onclick="thirdparty_authentication('INTUIT');">
					<div class="idp_icon intuit_icon"></div>
					<div class="idp_name"><@i18n key="IAM.IDENTITY.PROVIDER.NAME.INTUIT" /></div>					
					</div>
					</#if>
					
					<#if adp>
					<div class="idp_option idp_opt_slide" onclick="thirdparty_authentication('ADP');">
					<div class="idp_icon adp_icon"></div>
					<div class="idp_name"><@i18n key="IAM.IDENTITY.PROVIDER.NAME.ADP" /></div>					
					</div>
					</#if>
					
					</div>
					</div>				
					</div>
					<div class="icon-showall hide" id="linked_accounts_viewall" onclick="show_all_linked_account()"><span><@i18n key="IAM.VIEWMORE.INFO" /> </span></div>
					
				</div>
				
				
				
				<div class="viewall_popup hide popupshowanimate_2" tabindex="1" id="authorized_linked_more">
					<div class="box_info">
						<div class="expand_closebtn" onclick="closeview_all_linked_acc()"></div>
						<div class="box_head"><@i18n key="IAM.LINKED.ACCOUNTS" /><span class="icon-info"></span></div>
						<div class="box_discrption"><@i18n key="IAM.LINKEDACCOUNTS.DESCRIPTION" /></div>
					</div>
					<div id="view_accounts_remove" class="viewall_popup_content">
					</div>
				</div>
				
				
				<div id="empty_LinkedSites_format" class="hide">
									
					<div class="Field_session" id="linked_accountnum"> 				
						<div class="authweb_entry_headder">
							<div class="linked_acc_info">
								<div class="aw_dp linked_account_icon"></div>
								<div class="aw_disc linked_account_id">
									<div class="aw_name"></div>
									<div class="aw_time"></div>
								</div>
							</div>
							<div class="linked_acc_details browser_icon"></div>
							<div class="linked_acc_details os_icon"></div>
							<div class="linked_acc_details created_location"><@i18n key="IAM.SESSIONS.LOCATION.UNAVAILABLE" /></div>
							<span class="deleteicon hide action_icon icon-delete" style="float: right; margin-right: 30px;" title="<@i18n key="IAM.REMOVE" />" ></span>
						</div>
						
						<div class="aw_info " id="linked_account_info">				
							
							<button class="primary_btn_check negative_btn_red inline" id="linked_acc_action" tabindex="1" ><span><@i18n key="IAM.REMOVE" /> </span></button>
							
						</div>
					</div>
					
				</div>
