<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN" "http://www.w3.org/TR/REC-html40/frameset.dtd">


		<div class='group_pp_cover'>
			<div class="popup_head center_text"><@i18n key="IAM.GROUP.CREATE" /> </div>
			<div class="close_btn centre_cross" onclick="close_edit_grp_popup();"></div>
				
				
			<div id="create_grp_dp">
				<div class="group_dp icon-camera" onclick="openUploadPhoto('group','new');" id="edit_grp_dp">
					<div class="bg_blur_grp"></div>
					<img onerror="setDefault_dp(this)" src='${za.img_url}/group_2.png'class="profile_picture"></img>
				</div>
				
				<form name="Grp_photo" method="post" id="new_grp_photo_form" enctype="multipart/form-data" target="dummy" onSubmit="return false;">
					<input type="file" class="hide" accept="image/x-png,image/gif,image/jpeg" name="picture" onchange="upload_grp_pic(this)" id="new_picsrc_grp">
				</form>
			
	            <div class="grp_dp_edit_screen"></div>   
	                 
	             <!-- Profile pic options -->
	             <div class="alert__box" id="grp_edit_dp">
					<div class="triangle">
					    	<div class="empty"></div>
					</div>
					<div class="alert__box_options">
						<div class="profile_options" onclick="openUploadPhoto('group','')"><@i18n key="IAM.GROUP.CHANGE.LOGO" /> </div>
					</div>
				</div>
				<!-- Profile pic options end -->
				
			</div>
			
		<form name="creategrp" id="create_grp" onsubmit="return createGrp(this)">
	
			<div id="create_grp_info">
				<div class="field full">
						<div class="textbox_label "><@i18n key="IAM.GROUP.NAME" /> </div>
						<input id="create_grp_name" tabindex="0" data-limit="100" class="textbox big_textbox" onkeypress="remove_error()" data-validate="zform_field" name="grpname" type="text" value="">
				</div>
				<div class="field full">
							<div class="textbox_label"><@i18n key="IAM.GROUP.DESC" /></div>
							<textarea id="create_grp_desc" tabindex="0" data-limit="200" class="deleteacc_cmnd big_textare" onkeypress="remove_error()" data-optional="true" data-validate="zform_field"  name="grpdesc"></textarea>
				</div>
			</div>
			
			<div id="create_grp_members">
					
					<input type="hidden" name="gmlimit" />					
					
					<div class="field full">
							<div class="textbox_label"><@i18n key="IAM.INITIAL.GROUP.MEMBER.EMAILADDRESS" /> </div>
						
						
				<!--		<select data-validate="zform_field" name="grpmembers" id="select_member_email" class="inputSelect">
				    		</select> -->
				    		
							<div class="contacts_place"></div>
				    					    		
							<#if ! no_orgusers>
								<textarea tabindex="0" class="deleteacc_cmnd big_textare" data-validate="zform_field" onkeypress="remove_error()" autocomplete="email" name="" placeholder='<@i18n key="IAM.GROUP.MEMBER.EMAIL_ADDRESS" /> <@i18n key="IAM.GROUP.EMAIL_USECOMMA" />'></textarea>
								<div class="memidex"><@i18n key="IAM.ORGPOLICY.PERSONALGROUP.INVITATION" /></div>
							</#if>
					</div>		
					
			</div>
			
			<div id="creatgrp_butt1" class="pop_up_overflow_btn">
  				<button tabindex="0" class="primary_btn_check inline" id="add_name_old_ip"><span><@i18n key="IAM.CREATE" />  </span></button>
				<button tabindex="0" class="primary_btn_check high_cancel" onclick="return close_edit_grp_popup();"><span><@i18n key="IAM.BACK" /> </span></button>
    		</div>
    	</form>	
    </div>