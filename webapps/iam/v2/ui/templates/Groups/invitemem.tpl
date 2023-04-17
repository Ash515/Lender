<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN" "http://www.w3.org/TR/REC-html40/frameset.dtd">





			<div class='group_pp_cover'>
				<div class="popup_head"><@i18n key="IAM.GROUP.INVITE" /></div>
				<div class="close_btn" onclick="close_edit_grp_popup();"></div>
				
				
				<form name="invitegrp" id="invitegrp" onsubmit="return Invitefriends(this)">
					
					<div class="field full">
							<div class="textbox_label "><@i18n key="IAM.GROUP.NAME" /></div>
							<input class="textbox big_textbox" tabindex="0" id="invite_popup_groupName" type="text" readonly="readonly">
					</div>
					<input data-validate="zform_field" name="gid" type="hidden" />
					
					<input type="hidden" id="invite_popup_grouplimit" name="gmlimit"/>
					
					<div class="field full">
							<div class="textbox_label"><@i18n key="IAM.NEW.GROUP.MEMBER.EMAILADDRESS" /></div>	
							<div class="contacts_place"></div>
					</div>
					<div class='pop_up_overflow_btn'>
						<button class="primary_btn_check inline" tabindex="0" ><span><@i18n key="IAM.INVITE" /></span></button>
					</div>					
				</form>
			</div>