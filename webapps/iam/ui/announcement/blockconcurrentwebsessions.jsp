<%-- $Id$ --%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN" "http://www.w3.org/TR/REC-html40/frameset.dtd">
<%@ include file="../../static/includes.jspf" %>
<html>

<%
User user =  IAMUtil.getCurrentUser();
%>
    <head><title><%=Util.getI18NMsg(request, "IAM.CONCURRENTSESSION.ACCESS.BLOCKED")%></title>
    <style type="text/css">
/* new style */


body
{
    font-family: 'Open Sans', sans-serif;
    margin: 0;
}
.container
{
    margin-top: 4%;
    width: 60%;
    margin-left: auto;
    margin-right: auto;
}
.zoho_logo
{
    height: auto;
    width: auto;
}
.head_text
{
    display: block;
    font-size: 1.4em;
    margin-bottom:5%;
    margin-top: 5px;
}
.name
{
    font-size: .9em;
    font-weight: bold;
    display: block;
}
.announcement_text
{
    line-height: 1.5;
    font-size: .9em;
    display: block;
}

.msg_head 
{
    display: block;
    font-size: 0.8em;
    margin: 30px 0 -30px;
 }

.verify_btn , .skip_btn
{
    margin-right: 10px;
    cursor: pointer;
    font-size: .8em;
    border: none;
    background-color: #1ab2f1;
    padding: 10px 10px;
    color: #fff;
    display: inline-block;
    font-weight: 100;
}
.verify_btn:hover
{
    background-color: #18a9e5;
}
.skip_btn
{
    margin-top: 10px;
    background-color: #eeeeee;
    color: #000;
   }
input:focus
{
    outline: none;
}
.time
{
    display: block;
    margin: 4% 0px;
    font-weight: bold;
    font-size: .8em;
}
.update_btn
{
    margin-top: 20px;
    cursor: pointer;
    font-size: .8em;
    border: none;
    background-color: #1ab2f1;
    padding: 10px 20px;
    color: #fff;
    display: block;
}
.update_btn:hover
{
    background-color: #18a9e5;
}
.btns
{
    display: block;
    margin-top: 30px;
}
.spacing
{
    line-height: 2.5;
}
.accept_btn
{
    cursor: pointer;
    font-size: 1em;
    font-weight: 100;
    margin-top: 20px;
    width: 300px;
    height: 35px;
    display: block;
    color: #fff;
    background-color: #00b1f4;
    border: none;
}
.accept_btn:hover
{
    background-color: #00a5e4;
}



/* new style end */


/*---------------Top message-----------------*/ 
.top_div 
{
 left: 0;
 right: 0;
 margin-left: auto; 
 margin-right: auto; 
 top: 0px; 
 position: absolute; 
 height: 40px; 
 width: 400px; 
 background: rgba(221, 221, 221, 0.22); 
 border-right: 3px solid #ef4444; 
 color: #ef4444; 
 display:none; 
 }
.cross_mark 
{
 position: relative;
 display: inline-block; 
 background-color: #ef4444; 
 height: 40px; 
 width: 40px; 
 } 
.crossline1 
{ 
 top: 18px; 
 margin: auto; 
 position: relative; 
 border-radius: 2px; 
 height: 4px; 
 width: 20px; 
 display: block; 
 background-color: #fff; 
 transform: rotate(45deg); 
 }
.crossline2 
{ 
 top: 14px; 
 border-radius: 2px; 
 height: 4px; 
 width: 20px; 
 display: block; 
 background-color: #fff; 
 transform: rotate(-45deg); 
 position: relative; 
 margin: auto; 
 }
.top_msg 
{   
 position: relative;   
 font-size: 13px;   
 display: inline-block;   
 text-align: center;   
 color: #000;   
 width: 86%;   
 height: 100%;   
 box-sizing: border-box;   
 float: right;   
 padding: 10px;   
 left: -15px;    
 }  
.error_notif , .captcha_error_notif 
{ 
 color: #ff6164;
 margin-left: 5px;   
 font-size: 12px;   
 margin-top: -25px; 
}
    </style>
    </head>
    
    <script src="<%=jsurl%>/jquery-1.12.2.min.js" type="text/javascript"></script><%-- NO OUTPUTENCODING --%>
    <script type="text/javascript">
	var csrfParam = "<%=SecurityUtil.getCSRFParamName(request)+"="+SecurityUtil.getCSRFCookie(request)%>"; //NO OUTPUTENCODING    
	var contextpath = "<%=request.getContextPath()%>"; //NO OUTPUTENCODING	
	
	function deleteAllTickets() {
	    var resp = getDeleteResponse(contextpath+"/rest/user/sessions",""); //No I18N
	    var obj = JSON.parse(resp);
 		if(obj.status == "success"){
 			$('#close_session').prop('disabled', true); //No I18N
			showmsg('<%=Util.getI18NMsg(request, "IAM.TFA.CLOSED.SESSIONS")%>'); //No I18N
			setTimeout(function(){window.location.href = '<%=IAMEncoder.encodeJavaScript(Util.getNextPreAnnouncementUrl("block-concurrent-websessions"))%>'},4000);
	    } else if(obj.status == "exception") { //No I18N
	    	showErrMsg(obj.message);
	    } else {
	    	showErrMsg('<%=Util.getI18NMsg(request,"IAM.ERROR.GENERAL")%>');
	    }
	    return true;
	}
	
	
	function showErrMsg(msg) { $(".top_div").css({"border-right": "3px solid #ef4444", "color": "#ef4444"});   $(".cross_mark").css("background-color","#ef4444");      $(".crossline1").css({"top": "18px", "left": "0px", "width":"20px"});     $(".crossline2").css("left","0px");   $('.top_msg').html(msg); //No I18N 
	$( ".top_div" ).fadeIn("slow");  setTimeout(function() {  $( ".top_div" ).fadeOut("slow"); }, 3000); //No I18N

	}

	function showmsg(msg) { $(".top_div").css({"border-right": "3px solid #50BF54", "color": "#50BF54"});   $(".cross_mark").css("background-color","#50BF54");      $(".crossline1").css({"top": "22px", "left": "-6px", "width":"12px"});     $(".crossline2").css("left","4px");   $('.top_msg').html(msg); //No I18N 
	$( ".top_div" ).fadeIn("slow");  setTimeout(function() {  $( ".top_div" ).fadeOut("slow"); }, 3000); //No I18N

	}
	
	
    </script>
    <script src="<%=jsurl%>/common.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
    <link href="<%=cssurl%>/style.css" type="text/css" rel="stylesheet" /> <%-- NO OUTPUTENCODING --%>

    <body>
    
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
        <img src="<%=imgurl%>/zlogo.png"/>  <%-- NO OUTPUTENCODING --%>
        <span class="head_text"><%=Util.getI18NMsg(request, "IAM.CONCURRENTSESSION.ACCESS.BLOCKED")%><br><%=Util.getI18NMsg(request,"IAM.MAXIMUM.CONCURRENT.TICKETS.LIMIT.EXCEEDED")%></span>
        <span class="name"><%=Util.getI18NMsg(request, "IAM.HI.USERNAME",user.getFullName() == null ? "" : IAMEncoder.encodeHTMLAttribute(user.getFullName()))%></span>
        <span class="announcement_text"><%=Util.getI18NMsg(request,"IAM.ANNOUNCEMENT.SESSIONREMINDER.MSG1")%><br><%=Util.getI18NMsg(request,"IAM.ANNOUNCEMENT.SESSIONREMINDER.MSG3")%></span>
        <br />
        <div class="btns">
        	<input class="verify_btn" id="close_session" type="button" onclick="deleteAllTickets()" value="<%=Util.getI18NMsg(request,"IAM.USERSESSIONS.CLOSE.ALL")%>">
        </div>
        </div>        
    </body>
</html>
