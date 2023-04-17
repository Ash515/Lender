<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN" "http://www.w3.org/TR/REC-html40/frameset.dtd">
<html>
    <head>
    	<script>
			var states_details =${States};
		</script>
    </head>

    <body>


			<div class="box profile_box">
                <button class="primary_btn_check right_btn circlebtn_mobile_edit onlyweb " id="editprofile" onclick="return editProfile();" ><span><@i18n key="IAM.EDIT" /></span></button>
				
				<div class="profile_head">
					
					<div class="profile_dp icon-camera" id="profile_img" onclick="openUploadPhoto('user','0');">
						<div class="dp_pic_blur_bg"></div>
						<label id="file_lab">
							<img onload="setPhotoSize(this)" id="dp_pic" draggable=false>
						</label>
					</div>
					
					<div class="profile_info">
						<div class="profile_name"id="profile_name"></div>
						<div class="profile_email"id="profile_email"></div>
					</div>
				</div>
				<form id="locale" name="locale" onsubmit="return saveProfile(this);">
					<div class="profileinfo_form" tabindex="0">
						
						<div class="textbox_div textbox_inline editmode" id="Full_Name">
							<label class="textbox_label"><@i18n key="IAM.FULL.NAME" /></label>
							<input type="text" class="textbox profile_mode" autocomplete="name" id="profile_name_edit" data-limit="100" disabled>
						</div>
						
						<div class="textbox_div textbox_inline editmode hide" id="First_Name" >
							<label class="textbox_label"><@i18n key="IAM.FIRST.NAME" /></label>
							<input type="text" class="textbox profile_mode" tabinex="0" autocomplete="Fname" data-validate="zform_field" id="profile_Fname_edit" onkeypress="remove_error()" name="firstname" data-limit="100" disabled>
						</div>
						
						<div class="textbox_div textbox_inline editmode hide" id="Last_Name">
							<label class="textbox_label"><@i18n key="IAM.LAST.NAME" /></label>
							<input type="text" class="textbox profile_mode" tabindex="0" data-optional="true" autocomplete="Lname" data-validate="zform_field" id="profile_Lname_edit" name="lastname" data-limit="100" disabled>
						</div>
						
						<div class="textbox_div textbox_inline editmode">
							<label class="textbox_label"><@i18n key="IAM.NICK.NAME" /></label>
							<input type="text" class="textbox profile_mode" tabindex="0" data-optional="true" onkeypress="remove_error()" id="profile_nickname" autocomplete="name" data-validate="zform_field" name="displayname" data-limit="50" disabled>
						</div>
						
						<div class="field textbox_div textbox_inline editmode">
							<label class="textbox_label"><@i18n key="IAM.GENDER" /></label>
							<select class="profile_mode" id="gender_select" data-validate="zform_field" name="gender" disabled> 
								<option value="1" id="male_gender"><@i18n key="IAM.GENDER.MALE" /></option>
								<option value="0" id="female_gender"><@i18n key="IAM.GENDER.FEMALE" /></option>
								<option value="2" id="other_gender"><@i18n key="IAM.GENDER.OTHER" /></option>
								<option value="3" id="non_binary_gender"><@i18n key="IAM.GENDER.NON_BINARY" /></option>
	                        </select>
						</div>
						
						<div class="field textbox_div textbox_inline editmode "> 
                            <div class="textbox_label"><@i18n key="IAM.COUNTRY" /></div>
                          	<select class="profile_mode" data-validate="zform_field" autocomplete='country-name' name="country" id="localeCn" disabled onchange="check_state()">
                          		<#list Countries as countrydata>
                          			<option value="${countrydata.getISO2CountryCode()}" id="${countrydata.getISO2CountryCode()}" >${countrydata.getDisplayName()}</option>
                           		</#list>
                            </select>
                        </div>
                        
                        <div id="gdpr_us_state" class="hide field textbox_div textbox_inline editmode "> 
                            <div class="textbox_label"><@i18n key="IAM.GDPR.DPA.ADDRESS.STATE" /></div>
                          	<select class="profile_mode" data-validate="zform_field" autocomplete='state-name' name="state" id="localeState" disabled>
                          		  	<option value="" disabled selected><@i18n key="IAM.US.STATE.SELECT" /></option>
                            </select>
                        </div>
						
						
						<div class="field textbox_div textbox_inline editmode ">
							<label class="textbox_label"><@i18n key="IAM.LANGUAGE" /></label>	
							<select class="profile_mode" data-validate="zform_field" name="language" id="localeLn" disabled>
								<#list Languages as Languagedata>
                          			<option value="${Languagedata.getLanguageCode()}" class="hide" id="${Languagedata.getLanguageCode()}" >${Languagedata.getDisplayName()}</option>
                           		</#list>
                            </select>
      					</div>
						
                        
						<div class="field textbox_div textbox_inline editmode">
							<label class="textbox_label"><@i18n key="IAM.TIMEZONE" /></label>
							<select class="profile_mode timezone_select" data-validate="zform_field" name="timezone" id="localeTz"  disabled>
								<#list TimeZones as TimeZonedata>
                          			<option value="${TimeZonedata.getId()}" id="${TimeZonedata.getId()}" >(${TimeZonedata.getGMTString()}) ${TimeZonedata.getDisplayName()} ( ${TimeZonedata.getId()} )	</option>
                           		</#list>
                            </select>
                             <input id="timezone_show_type" style="display:none" class="checkbox_check" type="checkbox"/>
                             <div class="checkbox_div hide" style="display:none" id="displayall_timezone" >
								<input id="timezone_toggle" onchange="showZoneAfterCheck()" class="checkbox_check" type="checkbox"/>
								<span class="checkbox">
									<span class="checkbox_tick"></span>
								</span>
								<label for="timezone_toggle" class="checkbox_label"><@i18n key="IAM.PROFILE.LANGUAGE.DISPLAY.ALL" /></label>
							</div>
                        </div>
                        



						<div class="primary_btn_check circlebtn_mobile_edit onlymobile" id="editonmobile" onclick="return editProfile();" ><span><@i18n key="IAM.EDIT" /></span></div>

													
	                    <div id="savebtnid" class="hide">	            			
	            			<button class="primary_btn_check " tabindex="0" id="saveprofile" ><span><@i18n key="IAM.SAVE" /></span></button>
							<button class="primary_btn_check high_cancel" tabindex="0" id="undo_changes" onclick="return undochanges();"><span><@i18n key="IAM.CANCEL" /></span></button>
	            		</div>
					
					</div>
					
				</form>
				
				<select class="hide" name="country_Tz" id="country_Tz"  type="hidden" disabled>
					<#list CurrentTimeZonesList as CurrentTimeZonedata>
              			<option value="${CurrentTimeZonedata.zone_code}" id="${CurrentTimeZonedata.zone_code}" >${CurrentTimeZonedata.zone_name}</option>
               		</#list>
            	</select>	
            	
			</div>
                
                
    </body>
</html>
