
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<style>
body,table {
	font-size: 17px;
	padding:0px;
	margin:0px;
	font-family: "Open Sans";
}
.maindiv {
	width: 900px;
	margin: 0px auto;
	border-radius: 2px;
	margin-top: 5%;
}

.tfabutton {
	background-color: #6DA60A;
	border: 1px solid #65990B;
	color: #FFFFFF;
	font-size: 14px;
	padding: 6px 14px;
	text-decoration: none;
}

.cancelbutton {
	background-color: #CACACA;
	font-size: 14px;
	padding: 6px 14px;
	text-decoration: none;
	color:#333;
	margin-left: 5px;
	border: 1px solid #c3c3c3;
}
.cancelbutton1 {
	background-color: #CACACA;
	font-size: 14px;
	padding: 6px 14px;
	text-decoration: none;
	color:#333;
	margin-left: 5px;
	border: 1px solid #c3c3c3;
}

.continuelink {
	text-decoration: underline;
	color: #0483C8;
	margin-left: 30px;
}
input{
	height: 26px;
	width: 220px;
	padding-left: 6px;
    font-size: 13px;
}

#error{
color: red;
}

.mobileimage {
background: url("${za.config.iam_img_url}/strong_password.png") no-repeat scroll -2px -8px;  
    display: inline-block;
    height: 192px;
    margin-left: 5px;
    margin-top: 34px;
    width: 192px;
}
.saveBtn {
    -moz-border-bottom-colors: none;
    -moz-border-left-colors: none;
    -moz-border-right-colors: none;
    -moz-border-top-colors: none;
    background-color: #5ac7f0;
    border-color: #47b0d8 #47b0d8 #2c8fb4;
    border-image: none;
    border-radius: 2px;
    border-style: solid;
    border-width: 1px;
    color: #fff;
    cursor: pointer;
    font-size: 13px;
    padding: 5px 10px;
    position: relative;
    text-align: center;
    margin-right: 6px;
    text-decoration:none;
}
.saveBtn:hover, .saveBtn:focus ,.minisaveBtn:hover, .minisaveBtn:focus {
    -moz-border-bottom-colors: none;
    -moz-border-left-colors: none;
    -moz-border-right-colors: none;
    -moz-border-top-colors: none;
    background-color: #55c0e8;
    border-color: #47b0d8 #47b0d8 #2c8fb4;
    border-image: none;
    border-style: solid;
    border-width: 1px;
    color:#fff;
	text-decoration:none;
}
.cancelBtn {
	-moz-border-bottom-colors: none;
    -moz-border-left-colors: none;
    -moz-border-right-colors: none;
    -moz-border-top-colors: none;
    background-color: #e4e4e4;
    border-color: #e4e4e4 #e4e4e4 #bbbbbb;
    border-image: none;
    border-radius: 2px;
    border-style: solid;
    border-width: 1px;
    color: #141823;
    cursor: pointer;
    font-size: 13px;
    padding: 5px 10px;
    text-align: center;
    margin-right: 6px;
    text-decoration:none;
}
.cancelBtn:hover, .cancelBtn:focus ,.minicancelBtn:hover, .minicancelBtn:focus {
    -moz-border-bottom-colors: none;
    -moz-border-left-colors: none;
    -moz-border-right-colors: none;
    -moz-border-top-colors: none;
    background-color: #e0e0e0;
    border-color: #d4d4d4 #d4d4d4 #bbbbbb;
    border-image: none;
    border-style: solid;
    border-width: 1px;
}
@font-face {
    font-family: 'Open Sans';
    font-weight: 400;
    font-style: normal;
	src :local('Open Sans'),url('<%=imgurl%>/font.woff') format('woff');  
}
.title-banner{
  font-size: 24px;
  width: 185px;
  text-align: right;
  line-height: 45px;
  }
  
  td{
  height:20%;
}
#curpassmsg,#newpassmsg,#confirmpassmsg{
color: red;
font-size:12px;
}
#update{
margin-bottom: 2%;
margin-top: 3%;

}
.cls {
width:28%;
}
</style>


</head>
<body>
<table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0">
<tr><td valign="top" style="height:40px;">
<header>
	<#include "header">
</header></td></tr>
<tr>
<td valign="top">
<div class="maindiv">
	<div style="border-right:1px solid #8d8d8d;width: 235px;float: left;"><div class='title-banner'><@i18n key="IAM.TFA.BANNER.TITLE" /></div>
		<div class="mobileimage"></div>
	</div>
<div style="margin:0px 0 0 282px;">
<div style="width: 600px;line-height: 22px;float: left;">
<div style="margin-top: 20px;"><@i18n key="IAM.TFA.HI.USERNAME" arg0="${announcement.display_name}" /></div>
<div id="updatediv"></div>
<div id="message">
<div style="margin-top: 10px;"><@i18n key="IAM.PASSWORD.CHANGE.INTIMATION" /></div>
<div style="margin-top: 10px;"><@i18n key="IAM.WEAK.PASSWORD.CHARACTERISTICS" /></div>
<div id="suggestion" style="margin-top: 10px;"><@i18n key="IAM.PASSWORD.CHANGE.JOIN.TXT" /> <a href="${announcement.wiki_url}" target="_blank" class="continuelink" style="font-size: 12px;margin-left: 5px;"><@i18n key="IAM.TFA.LEARN.MORE" /></a> </div>
<div id="update" Style="display:none;">
<table style="height:100%; width:auto;">
  <tr>
    <td class="cls"></td>
    <td id="error" Style="font-size: 12px;"><p></p></td> 
    <td></td>
  </tr>

  <tr>
    <td class="cls" style="text-align:right;padding-right: 2%; white-space: nowrap;"><@i18n key="IAM.CURRENT.PASS" /> :</td>
    <td class="curpass" style="width:30%;"><input type="password" placeholder="Old Password" id="text_1" name="cur" Style="width: 185px;" ></td> 
    <td id="curpassmsg" Style="display:none;"></td>
  </tr>
  <tr>
    <td class="cls" Style="text-align:right;padding-right: 2%; white-space: nowrap;"><@i18n key="IAM.NEW.PASS" /> :</td>
    <td class="newpass" style="width:30%;"><input type="password" placeholder="New Password" id="text_2" name="new" Style="width: 185px;"></td> 
    <td id="newpassmsg" Style="display:none;"></td>
  </tr>
  <tr>
    <td class="cls" Style="text-align:right;padding-right: 2%; white-space: nowrap;"><@i18n key="IAM.REENTER.PASSWORD" /> :</td>
    <td class="retypepass" style="width:30%;"><input type="password" placeholder="New Password" id="text_3" name="retype" Style="width: 185px;"></td> 
    <td id="confirmpassmsg" Style="display:none;"></td>
  </tr>
</table>
</div>
<div style="clear: both;margin-top: 50px;">
<a href="javascript:evaluate();" class="saveBtn"><@i18n key="IAM.CHANGE.PASSWORD.NOW" /></a>
<a href="${announcement.remind_me_later_url}" class="cancelBtn"><@i18n key="IAM.TFA.BANNER.REMIND.LATER" /></a>
</div>
<div style=" margin: 19px auto 100px; "><a href="${announcement.skip_url}" class="continuelink" style="margin: 0px auto 0;font-size: 12px;"><@i18n key="IAM.PASSWORD.UPDATE.SKIP" /></a></div>
</div>

</div>
</div>
</td></tr>
<tr><td valign="bottom">
<footer>
	<#include "footer">
</footer></td></tr>
</table>
</body>
<script src="${za.config.iam_js_url_static}/jquery-1.12.2.min.js" type="text/javascript"></script>
<script src="${za.config.iam_js_url_static}/common.js" type="text/javascript"></script>
<script>

var csrfParam = '${za.config.csrfParam}='+getIAMCookie('${za.config.csrfCookie}');;


function redirect() {
	window.location.href = '${announcement.visited_url}';
	return;
}
$( ".curpass" )
  .focusout(function() {
	  var curpass = $('#text_1').val();
	  if(curpass && curpass.length>=3){
		sendRequestWithCallback('${announcement.iam_url}'+"/u/verifycurrentpassword",csrfParam+"&oldpasswd="+euc(curpass),true,function(response){return callback(response,'#curpassmsg')});  
	  } else if(curpass){
			$("#curpassmsg").text('<@i18n key="IAM.ERROR.INVALID.CURRENTPASS" />');
			$("#curpassmsg").fadeIn();
	  }
  });
$( ".newpass" )
  .focusout(function() {
	  var newpass = $('#text_2').val();
	  if(newpass && newpass.length>3){
		sendRequestWithCallback('${announcement.iam_url}'+"/u/validatenewpassword",csrfParam+"&newpasswd="+euc(newpass),true,function(response){return callback(response,'#newpassmsg')});  
	  }else if(newpass){
			$("#newpassmsg").text('<@i18n key="IAM.ERROR.INVALID.PASS" />');
			$("#newpassmsg").fadeIn();
	  }
  });
$( ".retypepass" )
  .focusout(function() {
	  var newpass = $('#text_2').val();
	  var retypepass = $('#text_3').val();

	if (retypepass) {
			if (newpass != retypepass) {
				$("#confirmpassmsg").text('<@i18n key="IAM.ERROR.WRONG.CONFIRMPASS" />');
				$("#confirmpassmsg").fadeIn();
			} else {
				$("#confirmpassmsg").fadeOut();
				$("#confirmpassmsg").empty();
			}
		}
	});


	$('input').keypress(function(e) {
		if($('#error').text().length > 0){
		$('#error').empty();
		}
	});
	
	function evaluate(){
		if(!$('#updatediv').size()){
		if(isValid($('#text_1').val()) && isValid($('#text_2').val()) && isValid($('#text_3').val()) && !isValid($('#curpassmsg').text()) && !isValid($('#newpassmsg').text()) && !isValid($('#confirmpassmsg').text())){
			var oldpass = $('#text_1').val();
			var newpass = $('#text_2').val();
			sendRequestWithCallback('${announcement.iam_url}'+"/u/updatestrongpassword",csrfParam+"&oldpasswd="+euc(oldpass)+"&newpasswd="+euc(newpass),true,redirect);  
			return;
		}else{
			if(!isValid($('#curpassmsg').text()) && !isValid($('#newpassmsg').text()) && !isValid($('#confirmpassmsg').text())){
			if(!isValid($('#text_1').val())){
				$('#error').text('<@i18n key="IAM.ERROR.ENTER.CURRENTPASS" />')
			}else if(!isValid($('#text_2').val())){
				$('#error').text('<@i18n key="IAM.ERROR.ENTER.NEW.PASS" />')
			}else if(!isValid($('#text_3').val())){
				$('#error').text('<@i18n key="IAM.PASSWORD.CONFIRM.PASSWORD" />')
			}
			$('#error').fadeIn();
			}
		} 
		}else{
			$('#update').fadeIn();
			$('#updatediv').remove();
		}
	}
	
	function isValid(text){
		if(!text || text=="" || text.length<=3){
			return false;
		}
		return true;
	}

	function callback(jsonResponse, id) {
		var obj = JSON.parse(jsonResponse);
		if (obj.status == "error") {
			$(id).text(obj.message);
			$(id).fadeIn();
		} else if(obj.status == "success"){
			$(id).fadeOut();
			$(id).empty();
		}
		return true;
	}
	
</script>
</html>