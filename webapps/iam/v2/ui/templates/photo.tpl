<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN" "http://www.w3.org/TR/REC-html40/frameset.dtd">


<html>
   <body>
	<div class="popup_bg"></div>
	   	<form name="photo" method="post" id="photo_cropform" enctype="multipart/form-data" target="dummy" onSubmit="return false;">
	   		
			<div class="hide">
				<input type="file" accept="image/x-png,image/gif,image/jpeg" name="picture" id="picsrc">
				<input type="text" name ="zform_field_transform" id="transform_value"/>
			</div>
	   		
	   		<div class="dp_change" tabindex="1" id="dp_change">
				<div class="dp_title">
					<span class="box_head"><@i18n key="IAM.USER.PROFILE.PHOTO"/></span>
				</div>
					<div class="dp_container" id="wrp">
	        			<img id="img" draggable="false">
	        			<div class="crop" id="crop">
	           				<div class="inContainer">
	               				<img id="clear_img" draggable="false">
	           				</div>
	           				<div class="photo_loading">
   								<div class="loader" ></div>
   							</div>
	        			</div>
	    			</div>
	    			<img id="orientation_check" hidden>
					<div class="tophead">
						<div class="rotate_opt icon-RotateLeft" onclick="setRotateVal(this,0)"></div>
						<span class="dp_size_small icon-Minus" ></span>
						<input type="range" id="ppvalue" name="points" onchange="lastsizeCon=size;backScale();" range="min" max="600" min="0" value="1" >
						<span class="dp_size_large icon-Plus" ></span>
						<div class="rotate_opt icon-RotateRight" onclick="setRotateVal(this,0)"></div>
					</div>
					<div class="dp_per_options">
						<span class="profile_privacy_text"><@i18n key="IAM.PHOTO.VIEW.DESCRIPTION"/></span>
						<span class="photo_perm_wrapper">
						<select id="photo_permission">
							<option value="3"><@i18n key="IAM.PHOTO.PERMISSION.ZOHO_USERS" /></option>
							<option value="2"><@i18n key="IAM.PHOTO.PERMISSION.CHAT_CONTACTS" /></option>
							<#if (is_org_user)>
								<option value="1"><@i18n key="IAM.PHOTO.PERMISSION.ORG_USERS" /></option>
							</#if>
							<option value="4"><@i18n key="IAM.PHOTO.PERMISSION.EVERYONE" /></option>
							<option value="0"><@i18n key="IAM.PHOTO.PERMISSION.ONLY_MYSELF" /></option>
						</select>
						</span>
					</div>
							   <input id="x1" data-validate="zform_field" type="hidden" name="x_point">
					           <input id="y1" data-validate="zform_field" type="hidden" name="y_point">
					           <input id="h" data-validate="zform_field" type="hidden" name="height">
					           <input id="w" data-validate="zform_field" type="hidden" name="width">
					           <input id="t" data-validate="zform_field" type="hidden" name="t_value">
					           <input id="ot" data-validate="zform_field" type="hidden" name="ot_value">   
				<div class="dp_popup_btns">
					<button class="btn inline_btn savepic"  onclick="Usercrop(this.form);"><@i18n key="IAM.PHOTO.DONE"/> </button>
					<button class="btn inline_btn grey_btn dp_close" onclick="close_dp_popup();"><@i18n key="IAM.CANCEL"/> </button>
				</div>
					
			</div>
		</form>
	</body>
    <script src="${za.js_url}/photo.js" type="text/javascript"></script> 
</html>