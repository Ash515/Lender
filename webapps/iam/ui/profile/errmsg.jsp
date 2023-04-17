<%-- $Id$ --%>
<%@page import="com.zoho.accounts.AccountsConfiguration"%>
<%@ page import="com.adventnet.iam.IAMUtil, com.adventnet.iam.internal.Util"%>
<%
response.setContentType("text/javascript;charset=UTF-8"); // No I18N
response.setHeader("Cache-Control", "private,max-age=86400");//No I18N
response.setHeader("Pragma", null);//No I18N
response.setHeader("Expires", null);//No I18N
String supportEmailId = AccountsConfiguration.SUPPORT_EMAILID.getValue(); //No I18N
%>

    var iam_supported_language = '<%=(String)AccountsConfiguration.SUPPORTED_LANGUAGES.getValue()%>'; <%--No I18N--%>
    var err_fname = '<%=Util.getI18NMsg(request,"IAM.ERROR.FNAME.EMPTY")%>'; <%--No I18N--%>
    var err_fname_maxlen = '<%=Util.getI18NMsg(request,"IAM.ERROR.FNAME.MAXLEN", 100)%>'; <%--No I18N--%>
    var err_dname_maxlen = '<%=Util.getI18NMsg(request,"IAM.ERROR.DNAME.MAXLEN", 50)%>'; <%--No I18N--%>
    var err_skypeid_maxlen = '<%=Util.getI18NMsg(request,"IAM.ERROR.SKYPEID.MAXLEN", 100)%>'; <%--No I18N--%>
    var err_psaved = '<%=Util.getI18NMsg(request,"IAM.ERROR.PERSONAL.SAVED")%>'; <%--No I18N--%>
    var err_groupname_empty = '<%=Util.getI18NMsg(request,"IAM.ERROR.GROUPNAME.EMPTY")%>'; <%--No I18N--%>
    var err_groupmessage_maxlen = '<%=Util.getI18NMsg(request, "IAM.GROUP.MESSAGE.MAXIMUMLENGTH", 1000)%>'; <%--No I18N--%>
    var err_groupunsubscribe_sure = '<%=Util.getI18NMsg(request, "IAM.GROUP.SURE.UNSUBSCRIBE", 100)%>'; <%--No I18N--%>
    var err_enter_mememail = '<%=Util.getI18NMsg(request,"IAM.ERROR.ENTER.MEMEMAIL")%>'; <%--No I18N--%>
    var err_invalid_email = '<%=Util.getI18NMsg(request,"IAM.ERROR.INVALID.EMAIL")%>'; <%--No I18N--%>
    var err_validemail = '<%=Util.getI18NMsg(request,"IAM.ERROR.VALID.EMAIL")%>'; <%--No I18N--%>
    var err_email_maxlen = '<%=Util.getI18NMsg(request,"IAM.ERROR.EMAIL.MAXLEN", 100)%>'; <%--No I18N--%>
    var err_enter_currpass = '<%=Util.getI18NMsg(request,"IAM.ERROR.ENTER.CURRENTPASS")%>'; <%--No I18N--%>
    var err_enter_newpass = '<%=Util.getI18NMsg(request,"IAM.ERROR.ENTER.NEW.PASS")%>'; <%--No I18N--%>
    var err_wrong_pass = '<%=Util.getI18NMsg(request,"IAM.ERROR.WRONG.CONFIRMPASS")%>'; <%--No I18N--%>
    var err_update_success = '<%=Util.getI18NMsg(request,"IAM.ERROR.UPDATE.SUCCESS")%>'; <%--No I18N--%>
    var err_enter_pass = '<%=Util.getI18NMsg(request,"IAM.ERROR.ENTER.PASS")%>'; <%--No I18N--%>
    var err_password_maxlen = '<%=Util.getI18NMsg(request,"IAM.ERROR.PASSWORD.MAXLEN")%>'; <%--No I18N--%>
    var err_enter_ques = '<%=Util.getI18NMsg(request,"IAM.ERROR.ENTER.QUES")%>'; <%--No I18N--%>
    var err_enter_ans = '<%=Util.getI18NMsg(request,"IAM.ERROR.ENTER.ANS")%>'; <%--No I18N--%>
    var err_invalid_pass = '<%=Util.getI18NMsg(request,"IAM.ERROR.INVALID.PASS")%>'; <%--No I18N--%>
    var err_email_primary_notdlt = '<%=Util.getI18NMsg(request,"IAM.ERROR.PRIMARY.NOTDELETE")%>'; <%--No I18N--%>
    var err_email_sure_delete = '<%=Util.getI18NMsg(request,"IAM.ERROR.SURE.DELETE")%>'; <%--No I18N--%>
    var err_email_sure_delete1 = '<%=Util.getI18NMsg(request,"IAM.EMAIL.ERROR.SURE.DELETE")%>'; <%--No I18N--%>
    var err_mobile_sure_delete1 = '<%=Util.getI18NMsg(request,"IAM.MOBILE.ERROR.SURE.DELETE")%>'; <%--No I18N--%>  
    var err_mobile_screenname_sure_delete = '<%=Util.getI18NMsg(request,"IAM.MOBILE.SCREENNAME.ERROR.SURE.DELETE")%>'; <%--No I18N--%>        
    var err_allowedips_sure_delete = '<%=Util.getI18NMsg(request,"IAM.ALLOWEDIPS.SURE.DELETE")%>'; <%--No I18N--%>
    var err_group_notauth_dltgrp = '<%=Util.getI18NMsg(request,"IAM.ERROR.NOTAUTH.DLTGROUP")%>'; <%--No I18N--%>
    var err_group_success_dlt = '<%=Util.getI18NMsg(request,"IAM.ERROR.GROUP.DELETED")%>'; <%--No I18N--%>
    var err_while_dltgrp = '<%=Util.getI18NMsg(request,"IAM.ERROR.DELETE.GROUP")%>'; <%--No I18N--%>
    var err_sure_dltgrp = '<%=Util.getI18NMsg(request,"IAM.ERROR.SURE.DLTGROUP")%>'; <%--No I18N--%>
    var err_group_create_success = '<%=Util.getI18NMsg(request,"IAM.ERROR.CREATE.SUCCESS")%>'; <%--No I18N--%>
    var err_owner_only_invitemember = '<%=Util.getI18NMsg(request,"IAM.ERROR.ONLY.MODERATORINVITE")%>'; <%--No I18N--%>
    var account_unconfirmed = '<%=Util.getI18NMsg(request,"IAM.ERROR.UNCONFIRMED.USER")%>'; <%--No I18N--%>
    var err_while_invite_memeber = '<%=Util.getI18NMsg(request,"IAM.ERROR.WHILEINVITE.MEMBER")%>'; <%--No I18N--%>
    var err_group_invalid_name = '<%=Util.getI18NMsg(request,"IAM.ERROR.INVALID.GRPNAME")%>'; <%--No I18N--%>
    var err_while_crearte_group = '<%=Util.getI18NMsg(request,"IAM.ERROR.WHILE.CREATEGRP")%>'; <%--No I18N--%>
    var err_group_delete_success = '<%=Util.getI18NMsg(request,"IAM.ERROR.GRPDLT.SUCCESS")%>'; <%--No I18N--%>
    var err_while_grupdlt_member = '<%=Util.getI18NMsg(request,"IAM.ERROR.DLTGRP.MEMBER")%>'; <%--No I18N--%>
    var err_cnt_error_occurred = '<%=Util.getI18NMsg(request,"IAM.ERROR.GENERAL")%>'; <%--No I18N--%>
    var err_pref_enter_format = '<%=Util.getI18NMsg(request,"IAM.USERPREFERENCE.ERROR.ENTER.FORMAT")%>'; <%--No I18N--%>
    var err_pref_invalid_dateformat = '<%=Util.getI18NMsg(request,"IAM.USERPREFERENCE.ERROR.INVALID.DATEFORMAT")%>'; <%--No I18N--%>
    var msg_link_to_reset_password = '<%=Util.getI18NMsg(request,"IAM.FORGOT.ZOHO.PASSWORD.USER.RESPONSE")%>'; <%--No I18N--%>
    var grp_name_exists = '<%=Util.getI18NMsg(request,"IAM.GROUP.NAME.EXISTS")%>'; <%--No I18N--%>
    var grp_update_error = '<%=Util.getI18NMsg(request,"IAM.GROUP.ERROR.UPDATE")%>'; <%--No I18N--%>
    var grp_err_invite='<%=Util.getI18NMsg(request,"IAM.GROUP.ERROR.INVITE")%>'; <%--No I18N--%>
    var grp_invite_success='<%=Util.getI18NMsg(request,"IAM.GROUP.INVITE.SUCCESS")%>'; <%--No I18N--%>
    var err_loginName_same = '<%=Util.getI18NMsg(request, "IAM.PASSWORD.POLICY.LOGINNAME")%>'; <%--No I18N--%>
    var err_pass_len = '<%=Util.getI18NMsg(request,"IAM.ERROR.PASS.LEN")%>'; <%--No I18N--%>
    var ip_delete_success = '<%=Util.getI18NMsg(request, "IAM.ALLOWEDIP.DELETE")%>'; <%--No I18N--%>
    var err_empty_fromip = '<%=Util.getI18NMsg(request, "IAM.ALLOWEDIP.FROMIP.EMPTY")%>'; <%--No I18N--%>
    var err_enter_fromip = '<%=Util.getI18NMsg(request, "IAM.ALLOWEDIP.FROMIP.NOTVALID")%>'; <%--No I18N--%>
    var err_enter_toip = '<%=Util.getI18NMsg(request, "IAM.ALLOWEDIP.TOIP.NOTVALID")%>'; <%--No I18N--%>
    var ip_address_exist = '<%=Util.getI18NMsg(request, "IAM.ALLOWEDIP.ERROR.IP_ALREADY_EXISTS")%>'; <%--No I18N--%>
    var revoke_access_success = '<%=Util.getI18NMsg(request, "IAM.AUTHORIZED.WEBSITES.SUCCESS")%>'; <%--No I18N--%>
    var err_revoke_access_failed = '<%=Util.getI18NMsg(request, "IAM.AUTHORIZED.WEBSITES.FAILED")%>'; <%--No I18N--%>
    var err_question_maxlen = '<%=Util.getI18NMsg(request, "IAM.ERROR.SECURITY.QUESTION.MAXLEN", 50)%>'; <%--No I18N--%>
    var err_answer_maxlen = '<%=Util.getI18NMsg(request, "IAM.ERROR.SECURITY.ANSWER.MAXLEN", 35)%>'; <%--No I18N--%>
    var err_groupname_maxlen = '<%=Util.getI18NMsg(request, "IAM.ERROR.GROUPNAME.MAXLEN", 100)%>'; <%--No I18N--%>
    var err_groupdesc_maxlen = '<%=Util.getI18NMsg(request, "IAM.ERROR.GROUPDESC.MAXLEN", 200)%>'; <%--No I18N--%>
    var err_pinfo_cn_cannot_empty = '<%=Util.getI18NMsg(request, "IAM.PINFO.COUNTRY.CANNOT.EMPTY")%>'; <%--No I18N--%>
    var err_pinfo_ln_cannot_empty = '<%=Util.getI18NMsg(request, "IAM.PINFO.LANG.CANNOT.EMPTY")%>'; <%--No I18N--%>
    var err_pinfo_tz_cannot_empty = '<%=Util.getI18NMsg(request, "IAM.PINFO.TZONE.CANNOT.EMPTY")%>'; <%--No I18N--%>
    var err_reject_group_success = '<%=Util.getI18NMsg(request, "IAM.ORG.INVITATION.REJECT.SUCCESS")%>'; <%--No I18N--%>
    var err_confirm_group_success = '<%=Util.getI18NMsg(request, "IAM.ORG.INVITATION.ACCEPT.SUCCESS")%>'; <%--No I18N--%>
    var err_owner_only_updategrp = '<%=Util.getI18NMsg(request, "IAM.ERROR.ONLY.MODERATOR.UPDATEGROUP")%>'; <%--No I18N--%>
    var err_owner_only_deletemember = '<%=Util.getI18NMsg(request, "IAM.ERROR.ONLY.MODERATOR.DELETEMEMBER")%>'; <%--No I18N--%>
    var err_session_closed = '<%=Util.getI18NMsg(request, "IAM.USERSESSIONS.SESSION.CLOSED")%>'; <%--No I18N--%>
    var err_allother_session_closed = '<%=Util.getI18NMsg(request, "IAM.USERSESSIONS.ALLSESSION.CLOSED")%>'; <%--No I18N--%>
    var make_mobile_login_sure = '<%=Util.getI18NMsg(request,"IAM.LOGIN.USING.PHONENUMBER.SURE")%>'; <%--No I18N--%>   
    var err_refresh_page = '<%=Util.getI18NMsg(request,"IAM.REFRESH.PAGE")%>'; <%--No I18N--%> 
    var err_app_revoke = '<%=Util.getI18NMsg(request,"IAM.APP.REVOKE.ERROR") %>'; <%--No I18N --%>       
    var err_many_attempts = '<%=Util.getI18NMsg(request,"IAM.MANY.ATTEMPTS") %>'; <%--No I18N --%>
    
	<!--Exo error messages -->
	var exo_err_unknow_user = '<%=Util.getI18NMsg(request, "IAM.EXO.UNKNOW.USER")%>';
	var exo_err_expired_user = '<%=Util.getI18NMsg(request, "IAM.EXO.EXPIRED.USER")%>';
	var exo_err_max_attempt = '<%=Util.getI18NMsg(request, "IAM.EXO.MAX.ATTEMPT")%>';
	
	<!-- Yubikey error messages -->
	var yu_err_valid_name = '<%=Util.getI18NMsg(request, "IAM.TFA.YUBIKEY.ERRMSG")%>';<%--No I18N --%>
	var yu_err_alredy_exist = '<%=Util.getI18NMsg(request, "IAM.TFA.YUBIKEY.EXIST.MSG")%>';<%--No I18N --%>
	var yu_err_occured = '<%=Util.getI18NMsg(request, "IAM.TFA.YUBIKEY.Error.MSG")%>';<%--No I18N --%>
	
    var err_enter_valid_mobile = '<%=Util.getI18NMsg(request, "IAM.PHONE.ENTER.VALID.MOBILE")%>'; <%--No I18N--%>
    var err_already_configured_mobile = '<%=Util.getI18NMsg(request, "IAM.PHONE.TFA.ALREADY.CONFIGURED")%>'; <%--No I18N--%>
    var err_mobile_already_configured_for_tfa_short = '<%=Util.getI18NMsg(request, "IAM.PHONE.TFA.ALREADY.CONFIGURED.SHORT")%>'; <%--No I18N--%>
    var err_verification_sent_success = '<%=Util.getI18NMsg(request, "IAM.PHONE.VERIFICATION.CODE.SENT.SUCCESS")%>'; <%--No I18N--%>
    var err_deletion_success = '<%=Util.getI18NMsg(request, "IAM.PHONE.DELETION.SUCCESS")%>'; <%--No I18N--%>
    var err_invalid_verify_code = '<%=Util.getI18NMsg(request, "IAM.PHONE.INVALID.VERIFY.CODE")%>'; <%--No I18N--%>
    var err_confirm_dlt_mobile = '<%=Util.getI18NMsg(request, "IAM.PHONE.CONFIRM.DLT.MOBILE")%>'; <%--No I18N--%>
    var err_tfadeletion_warning_msg = '<%=Util.getI18NMsg(request, "IAM.PHONE.DELETION.WARNING")%>'; <%--No I18N--%>
    var err_verify_code_sent = '<%=Util.getI18NMsg(request, "IAM.PHONE.VERIFY.CODE.SENT.TO")%>'; <%--No I18N--%>
    var err_mobile_already_exist = '<%=Util.getI18NMsg(request, "IAM.PHONE.NUMBER.ALREADY.EXIST")%>'; <%--No I18N--%>
    var err_mobile_success = '<%=Util.getI18NMsg(request, "IAM.PHONE.MOBILE.SUCCESS")%>'; <%--No I18N--%>
    var confirm_fb_delete = '<%=Util.getI18NMsg(request, "IAM.FACEBOOK.SURE_DELETE")%>'; <%-- No I18N --%>
    var mailpopup_password_title = '<%=Util.getI18NMsg(request,"IAM.MSG.POPUP.PASSWORD.TITLE")%>'; <%-- No I18N --%>
    var mailpopup_password_msg = '<%=Util.getI18NMsg(request,"IAM.MSG.POPUP.PASSWORD.MSG")%>'; <%-- No I18N --%>
    var mailpopup_email_title = '<%=Util.getI18NMsg(request,"IAM.MSG.POPUP.EMAIL.TITLE")%>'; <%-- No I18N --%>
    var mailpopup_email_msg = '<%=Util.getI18NMsg(request,"IAM.MSG.POPUP.EMAIL.MSG")%>'; <%-- No I18N --%>
    var mailpopup_email_tip = '<%=Util.getI18NMsg(request, "IAM.EMAIL.TIP",AccountsConfiguration.ADMIN_EMAIL_ID.getValue(),AccountsConfiguration.ADMIN_EMAIL_ID.toStringValue().split("@")[1]) %>';<%-- No I18N --%>
    var err_group_existmember_delete_msg = '<%=Util.getI18NMsg(request, "IAM.GROUP.EXISTMEMBER.SURE.DELETE")%>'; <%-- No I18N --%>
    var err_group_invitedmember_delete_msg = '<%=Util.getI18NMsg(request, "IAM.GROUP.INVITEDMEMBER.SURE.DELETE")%>'; <%-- No I18N --%>
    var err_closeaccount_userconfirm = '<%=Util.getI18NMsg(request, "IAM.CLOSEACCOUNT.USERCONFIRM")%>'; <%-- No I18N --%>
    var err_http_access_not_allowed = '<%=Util.getI18NMsg(request, "IAM.ERROR.REMOTE_SERVER_ERROR")%>'; <%-- No I18N --%>
    var write_operation_not_allowed = '<%=Util.getI18NMsg(request, "IAM.WRITEOPERATION.NOT.ALLOWED")%>'; <%-- No I18N --%>
    var err_authtoken_invalid_token = '<%=Util.getI18NMsg(request, "IAM.ACTIVETOKENS.INVALIDTOKEN")%>'; <%-- No I18N --%>
    var authtoken_regenerate_success = '<%=Util.getI18NMsg(request, "IAM.ACTIVETOKEN.REGENERATE.SUCCESS")%>'; <%-- No I18N --%>
    var authtoken_revoke_success = '<%=Util.getI18NMsg(request, "IAM.ACTIVETOKEN.REVOKE.SUCCESS")%>'; <%-- No I18N --%>
    var authtoken_regenerate_alert_msg = '<%=Util.getI18NMsg(request, "IAM.ACTIVETOKEN.REGENERATE.ALERT.MSG")%>'; <%-- No I18N --%>
    var authtoken_revoke_alert_msg = '<%=Util.getI18NMsg(request, "IAM.ACTIVETOKEN.REVOKE.ALERT.MSG")%>'; <%-- No I18N --%>
    var err_closeaccount_comments_length = '<%=Util.getI18NMsg(request, "IAM.CLOSEACCOUNT.COMMENTS", 250)%>';<%-- No I18N --%> 
    var err_enter_verification_code = '<%=Util.getI18NMsg(request, "IAM.TFA.ENTER.VERIFICATION.CODE")%>'; <%-- No I18N --%>
    var err_deletion_warning_msg = '<%=Util.getI18NMsg(request, "IAM.PHONE.CONFIRM.DLT.MOBILE")%>'; <%-- No I18N --%>
    var err_primary_confirm_msg='<%=Util.getI18NMsg(request, "IAM.PHONE.MAKE.PRIMARY.CONFIRM.MOBILE")%>'; <%-- No I18N --%>
    var err_primary_success='<%=Util.getI18NMsg(request, "IAM.PHONE.PRIMARY.SUCCESS")%>'; <%-- No I18N --%>
    var err_old_mob_nt_exist='<%=Util.getI18NMsg(request, "IAM.PHONE.NOT.EXIST")%>'; <%-- No I18N --%>
    var iam_push_notify_success='<%=Util.getI18NMsg(request, "IAM.DISABLE.PUSH.HINT")%>'; <%-- No I18N --%>
    var err_edit_confirm='<%=Util.getI18NMsg(request, "IAM.TFA.EDIT.CONFIRM")%>'; <%--No I18N--%>
    var err_invalid_password='<%=Util.getI18NMsg(request, "IAM.TFA.INVALID.PASSWORD")%>'; <%--No I18N--%>
    var err_generated_code='<%=Util.getI18NMsg(request, "IAM.TFA.GENERATED.CODE.SUCCESS")%>'; <%--No I18N--%>
    var err_verify_sms_message='<%=Util.getI18NMsg(request, "IAM.TFA.VERIFY.SMS.MESSAGE")%>'; <%--No I18N--%>
    var err_verify_call_message='<%=Util.getI18NMsg(request, "IAM.TFA.VERIFY.CALL.MESSAGE")%>'; <%--No I18N--%>
    var err_enter_valid_label='<%=Util.getI18NMsg(request, "IAM.TFA.ENTER.VALID.LABEL")%>'; <%--No I18N--%>
    var err_label_exist='<%=Util.getI18NMsg(request, "IAM.TFA.DEVICENAME.EXIST")%>'; <%--No I18N--%>
    var err_password_message='<%=Util.getI18NMsg(request, "IAM.TFA.PASSWORD.MESSAGE")%>'; <%--No I18N--%>
    var err_invalid_label='<%=Util.getI18NMsg(request, "IAM.TFA.INVALID.LABEL")%>'; <%--No I18N--%>
    var err_label_length_exceeded='<%=Util.getI18NMsg(request, "IAM.TFA.LABEL.LENGTH.EXCEEDED")%>'; <%--No I18N--%>
    var update_not_allowed='<%=Util.getI18NMsg(request, "IAM.TFA.UPDATE.NOT.ALLOWED")%>'; <%--No I18N--%>
    var err_gauth_verify_message='<%=Util.getI18NMsg(request, "IAM.TFA.GAUTH.VERIFY.MESSAGE")%>'; <%--No I18N--%>
    var err_verify_code_resent='<%=Util.getI18NMsg(request, "IAM.TFA.VERIFY.RESENT.MESSAGE")%>'; <%--No I18N--%>
    var err_exoauth_verify_message='<%=Util.getI18NMsg(request, "IAM.TFA.EXOAUTH.VERIFY.MESSAGE")%>'; <%--No I18N--%>
    var err_exoauth_verify_message1='<%=Util.getI18NMsg(request, "IAM.TFA.EXOAUTH.VERIFY.MESSAGE1")%>'; <%--No I18N--%>
    var linked_account_remove_sucess='<%=Util.getI18NMsg(request, "IAM.LINKED.ACCOUNT.REMOVED.MESSAGE")%>'; <%--No I18N--%>
    var linked_account_remove_error='<%=Util.getI18NMsg(request, "IAM.ERROR.GENERAL")%>'; <%--No I18N--%>
    var err_exist_in_org='<%=Util.getI18NMsg(request, "IAM.MOBILE.EXIST.IN.ORG")%>'; <%--No I18N--%>
    var err_tfa_limit_exceeded='<%=Util.getI18NMsg(request, "IAM.APP.PASSWORD.LIMIT.EXCEEDED")%>'; <%--No I18N--%>
    var err_addphone_confirm='<%=Util.getI18NMsg(request, "IAM.CONFIRM")%>'; <%--No I18N--%>
    var err_mobile_screenname_notdlt = '<%=Util.getI18NMsg(request,"IAM.ERROR.CANNOT.DELETE.SCREENNAME")%>'; <%--No I18N--%>    
    var err_mobile_configured_for_recovery = '<%=Util.getI18NMsg(request,"IAM.MOBILE.ERROR.TFA.RECOVERY")%>'; <%--No I18N--%>    
	var err_tfa_confirm_account = '<%=Util.getI18NMsg(request,"IAM.TFA.CONFIRM.ACCOUNT") %>';   <%--No I18N--%> 
	var connected_app_remove_error='<%=Util.getI18NMsg(request, "IAM.ERROR.GENERAL")%>'; <%--No I18N--%>    
	var err_phone_unverified_block ='<%=Util.getI18NMsg(request, "IAM.MOBILE.LIMIT.EXCEEDED")%>' ;<%--No I18N --%>
	var err_phone_max_linked_block ='<%=Util.getI18NMsg(request, "IAM.MOBILE.MAX.LINK.EXCEEDED",(String)AccountsConfiguration.MOBILE_MAP_COUNT_LIMIT.getValue())%>' ;<%--No I18N --%>
    
    var iam_allowedip_alert_header='<%=Util.getI18NMsg(request, "IAM.ALLOWEDIP.ALERT.HEADER")%>'; <%--No I18N--%>
    var iam_yes='<%=Util.getI18NMsg(request, "IAM.YES")%>'; <%--No I18N--%>
    var iam_cancel='<%=Util.getI18NMsg(request, "IAM.CANCEL")%>'; <%--No I18N--%>
    var iam_alert_message_fromonly='<%=Util.getI18NMsg(request, "IAM.ALERT.CONTENT.FROMONLY","__FROMIP__","__TOIP__")%>'; <%--No I18N--%>
    var iam_alert_message_fromto='<%=Util.getI18NMsg(request, "IAM.ALERT.CONTENT.FROMTO","__FROMIP__","__TOIP__")%>'; <%--No I18N--%>
    var iam_alert_message_notefrom='<%=Util.getI18NMsg(request, "IAM.ALERT.CONTENT.NOTEFROM")%>'; <%--No I18N--%>
    var iam_alert_message_note='<%=Util.getI18NMsg(request, "IAM.ALERT.CONTENT.NOTE")%>'; <%--No I18N--%>
    var iam_verify_phone_number = '<%=Util.getI18NMsg(request, "IAM.MOBILE.VERIFY")%>'; <%-- No I18N --%>  
    var iam_add_phone_number = '<%=Util.getI18NMsg(request, "IAM.ADDNEW.MOBILE")%>'; <%-- No I18N --%>    
      
    
    var err_mob_added='<%=Util.getI18NMsg(request, "IAM.TFA.MOBILE.ADDED")%>'; <%--No I18N--%>
    var err_mob_removed='<%=Util.getI18NMsg(request, "IAM.TFA.MOBILE.REMOVED")%>'; <%--No I18N--%>
    var err_backup_warn='<%=Util.getI18NMsg(request, "IAM.TFA.DELETE.BACKUP.WARN")%>'; <%--No I18N--%>
    var err_mkp_msg='<%=Util.getI18NMsg(request, "IAM.TFA.MAKEPRIMARY.MSG")%>'; <%--No I18N--%>
    var err_generate='<%=Util.getI18NMsg(request, "IAM.TFA.GENERATE")%>'; <%--No I18N--%>
    var err_generating='<%=Util.getI18NMsg(request, "IAM.TFA.GENERATING")%>'; <%--No I18N--%>
    var err_generate_new='<%=Util.getI18NMsg(request, "IAM.TFA.GENERATE.NEW")%>'; <%--No I18N--%>
    var err_generating_new='<%=Util.getI18NMsg(request, "IAM.TFA.GENERATING.NEW")%>'; <%--No I18N--%>
    var err_groupmembers_limit_exceeded='<%=Util.getI18NMsg(request, "IAM.ERROR.GROUPMEMBER.LIMIT.EXCEEDED", supportEmailId, supportEmailId)%>';<%--No I18N--%>
    var err_groupmembers_cannot_invitemore='<%=Util.getI18NMsg(request, "IAM.ERROR.GROUPMEMBER.CANNOT.INVITEMORE")%>';<%--No I18N--%>
    var err_groupmembers_cannot_invitemore_one='<%=Util.getI18NMsg(request, "IAM.ERROR.GROUPMEMBER.CANNOT.INVITEMORE_ONE")%>';<%--No I18N--%>
    var err_groupmembers_caninvite='<%=Util.getI18NMsg(request, "IAM.ERROR.GROUPMEMBER.LIMIT.CANINVITE")%>';<%--No I18N--%>
    var err_groupmembers_caninvite_one='<%=Util.getI18NMsg(request, "IAM.ERROR.GROUPMEMBER.LIMIT.CANINVITE_ONE")%>';<%--No I18N--%>
    var err_enter_password='<%=Util.getI18NMsg(request, "IAM.ENTER.PASSWORD")%>';<%--No I18N--%>
    var err_enter_phone_number='<%=Util.getI18NMsg(request, "IAM.ENTER.PHONE.NUMBER")%>';<%--No I18N--%>
    var err_backup_verification_codes='<%=Util.getI18NMsg(request, "IAM.BACKUP.VERIFICATION.CODE")%>';<%--No I18N--%>
    var err_backup_recommend_notes='<%=Util.getI18NMsg(request, "IAM.TFA.PRINTDOC.RECOMMEND.TEXT")%>';<%--No I18N--%>
    var err_tfa_setup_incomplete='<%=Util.getI18NMsg(request, "IAM.TFA.WARN.SETUP.COMPLETE")%>';<%--No I18N--%>
    var err_tfa_bkp_email='<%=Util.getI18NMsg(request, "IAM.TFA.BKP.EMAIL.ERROR")%>';<%--No I18N--%>
    var err_tfa_bkp_email_success='<%=Util.getI18NMsg(request, "IAM.TFA.BKP.EMAIL.SUCCESS")%>';<%--No I18N--%>
    var err_tfa_remote_ip_lock='<%=Util.getI18NMsg(request, "IAM.MANY.ATTEMPTS")%>';<%--No I18N--%>
    var err_blocked_domain='<%=Util.getI18NMsg(request, "IAM.TFA.BKP.EMAIL.BLOCKED.DOMAIN")%>';<%--No I18N--%>
    var err_select_authtoken_todelete = '<%=Util.getI18NMsg(request, "IAM.ACTIVETOKEN.SELECT.TOKEN")%>'; <%--No I18N--%>
    var authtoken_revoke_all_alert_msg = '<%=Util.getI18NMsg(request, "IAM.ACTIVETOKEN.REVOKE.ALL.ALERT.MSG")%>'; <%-- No I18N --%>
    var err_authtoken_invalid_token_specified = '<%=Util.getI18NMsg(request, "IAM.ACTIVETOKENS.INVALIDTOKEN.SPECIFY")%>'; <%-- No I18N --%>
    var err_authtokens_removed_success = '<%=Util.getI18NMsg(request, "IAM.ACTIVETOKENS.REMOVED_SUCCESS")%>'; <%-- No I18N --%>
    var err_authtokens_removal_process = '<%=Util.getI18NMsg(request, "IAM.ACTIVETOKENS.REMOVAL.PROCESSING")%>'; <%-- No I18N --%>
    var err_envalid_user_fname = '<%=Util.getI18NMsg(request, "IAM.ERROR.FNAME.INVALID.CHARS")%>'; <%-- No I18N --%>
    var err_envalid_user_dname = '<%=Util.getI18NMsg(request, "IAM.ERROR.DNAME.INVALID.CHARS")%>'; <%-- No I18N --%> 
    var err_envalid_user_skypeid = '<%=Util.getI18NMsg(request, "IAM.ERROR.SKYPEID.INVALID.CHARS")%>'; <%-- No I18N --%>

	var err_group_makemoderator_confirm_msg = '<%=Util.getI18NMsg(request, "IAM.GROUP.EXISTMEMBER.SURE.MAKE.MODERATOR")%>'; <%-- No I18N --%>
	var err_group_makemember_confirm_msg = '<%=Util.getI18NMsg(request, "IAM.GROUP.EXISTMEMBER.SURE.MAKE.MEMBER")%>'; <%-- No I18N --%>
	var err_max_group_per_moderator_exceeded='<%=Util.getI18NMsg(request, "IAM.GROUP.MAX.GROUP.PER.MODERATOR.THRESHOLD")%>';<%--No I18N--%>
	var err_max_group_per_user_exceeded='<%=Util.getI18NMsg(request, "IAM.GROUP.MAX.GROUP.PER.USER.THRESHOLD")%>';<%--No I18N--%>
 	var err_invalid_member ='<%=Util.getI18NMsg(request, "IAM.GROUP.INVALID.MEMBER")%>'; <%-- No I18N --%>
	var err_invalid_admin ='<%=Util.getI18NMsg(request, "IAM.GROUP.INVALID.ADMIN")%>'; <%-- No I18N --%>
	var err_unauthorized_access = '<%=Util.getI18NMsg(request, "IAM.RESERVE.UNAUTHORIZED.ACCESS")%>'; <%-- No I18N --%>
	var err_invalid_input = '<%=Util.getI18NMsg(request, "IAM.RESERVE.INVALID.INPUT")%>'; <%-- No I18N --%>
	var err_saml_process_failed = '<%=Util.getI18NMsg(request, "IAM.ERROR.PROCESS.FAILED")%>'; <%-- No I18N --%>
	var err_saml_delete_confirmation = '<%=Util.getI18NMsg(request, "IAM.SAMLSETUP.DELETE.CONFIRMATION")%>'; <%-- No I18N --%>
	var err_samlsetup_enter_loginurl = '<%=Util.getI18NMsg(request, "IAM.SAMLSETUP.ENTER.LOGIN.URL")%>'; <%-- No I18N --%>
	var err_samlsetup_enter_logouturl = '<%=Util.getI18NMsg(request, "IAM.SAMLSETUP.ENTER.LOGOUT.URL")%>'; <%-- No I18N --%>
	var err_samlsetup_enter_password_url = '<%=Util.getI18NMsg(request, "IAM.SAMLSETUP.ENTER.CHANGE.PASSWORD.URL")%>'; <%-- No I18N --%>
	var err_samlsetup_enter_publickey = '<%=Util.getI18NMsg(request, "IAM.SAMLSETUP.ENTER.PUBLICKEY")%>'; <%-- No I18N --%>
	var err_samlsetup_select_algorithm = '<%=Util.getI18NMsg(request, "IAM.SAMLSETUP.SELECT.ALGORITHM")%>'; <%-- No I18N --%>
	var err_samlsetup_url_pattern = '<%=Util.getI18NMsg(request, "IAM.SAMLSETUP.URL.PATTERN")%>'; <%-- No I18N --%>
    var err_saml_invalid_certificate = '<%=Util.getI18NMsg(request, "IAM.SAML.INVALID.CERTIFICATE")%>'; <%-- No I18N --%>
    
    var iam_mfasetup_oneauth_window_msg1 = '<%=Util.getI18NMsg(request, "IAM.MFASETUP.ONEAUTH.WINDOW.MSG1")%>'; <%-- No I18N --%>
    var iam_mfasetup_oneauth_window_msg2 = '<%=Util.getI18NMsg(request, "IAM.MFASETUP.ONEAUTH.WINDOW.MSG2")%>'; <%-- No I18N --%>
    var iam_gdpr_dpa_success_msg = '<%=Util.getI18NMsg(request, "IAM.GDPR.DPA.CLIENT.SUCCESS")%>'; <%-- No I18N --%>
    var iam_gdpr_dpa_failure_msg = '<%=Util.getI18NMsg(request, "IAM.GDPR.DPA.CLIENT.FAILURE")%>'; <%-- No I18N --%>
    var iam_gdpr_dpa_cname_err = '<%=Util.getI18NMsg(request, "IAM.GDPR.DPA.COMPANYNAME.ERROR")%>'; <%-- No I18N --%>
    var iam_gdpr_dpa_com_reg_num_err = '<%=Util.getI18NMsg(request, "IAM.GDPR.DPA.COMPANY.REGNUMBER.ERROR")%>'; <%-- No I18N --%>
    var iam_gdpr_dpa_com_address_err = '<%=Util.getI18NMsg(request, "IAM.GDPR.DPA.COMPLETE.ADDRESS.ERROR")%>'; <%-- No I18N --%>
    var iam_gdpr_dpa_data_err = '<%=Util.getI18NMsg(request, "IAM.GDPR.DPA.DATA.ERROR")%>'; <%-- No I18N --%>
    var iam_gdpr_dpa_country_err = '<%=Util.getI18NMsg(request, "IAM.GDPR.DPA.COUNTRY.ERROR")%>'; <%-- No I18N --%>
    var iam_device_delete_msg = '<%=Util.getI18NMsg(request, "IAM.TRUSTED.DEVICE.DELETE.MESSAGE")%>'; <%-- No I18N --%>
    var iam_device_terminate_msg = '<%=Util.getI18NMsg(request, "IAM.TRUSTED.DEVICE.TERMINATE.MESSAGE")%>'; <%-- No I18N --%>
    var iam_mail_client_terminate_msg = '<%=Util.getI18NMsg(request, "IAM.FETCH.DEVICE.DELETED.MSG")%>'; <%-- No I18N --%>
