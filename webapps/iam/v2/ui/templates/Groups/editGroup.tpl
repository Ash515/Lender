<!DOCTYPE HTML >
	<div class='group_pp_cover'>		
			<div class="popup_head center_text"><@i18n key="IAM.GROUP.EDIT.HEAD" /></div>
			
			<div class="close_btn centre_cross" onclick="close_edit_grp_popup();"></div>
			
			<div class="group_dp icon-camera" id="edit_grp_dp" >
				<div class="bg_blur_grp"></div>
				<img onerror="setDefault_dp(this)" class="profile_picture"></img>
			</div>
			
            <div class="grp_dp_edit_screen"></div>   
                 
            <div class="alert__box" id="grp_edit_dp">
				<div class="triangle">
				    	<div class="empty"></div>
				</div>
				<div class="alert__box_options">
					<div class="profile_options"><@i18n key="IAM.GROUP.CHANGE.LOGO" /> </div>
				</div>
			</div>
			
		<form name="grpdetails" id="grpdetails" onsubmit="return edit_group_info(this)">
    		<input name="gid" data-validate="zform_field" type="hidden" /> 
			<div class="field full">
					<div class="textbox_label "><@i18n key="IAM.GROUP.NAME" /> </div>
					<input class="textbox big_textbox" tabindex="1" data-limit="100" onkeypress="remove_error()" data-validate="zform_field" name="grpname" type="text" >
			</div>	
			<div class="field full">
					<div class="textbox_label"><@i18n key="IAM.GROUP.DESCRIPTION" /></div>
					<textarea class="deleteacc_cmnd big_textare" tabindex="1" onkeypress="remove_error()" data-limit="200" data-validate="zform_field" name="grpdesc"></textarea>
			</div>
			<div class="pop_up_overflow_btn">
				<button class="primary_btn_check inline" tabindex="1" ><span><@i18n key="IAM.UPDATE" /> </span></button>
			</div>
    	</form>	
    </div>