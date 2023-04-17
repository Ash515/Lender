<%--$Id$--%>
<%@page import="com.adventnet.iam.IAMException.IAMErrorCode"%>
<%@page import="com.zoho.accounts.internal.announcement.Announcement"%>
<%@page import="com.zoho.accounts.phone.SMSUtil"%>
<%@page import="com.zoho.accounts.SystemResourceProto.ISDCode"%>
<%@page import="javax.imageio.ImageIO"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.awt.image.BufferedImage"%>
<%@ include file="../../static/includes.jspf" %>
<%@page import="java.util.Map,java.util.List"%>
<%@ include file="../../static/include-favicons.jspf" %>
<html>
	<head>
	<script type="text/javascript">(function(w,s){var e=document.createElement("script");e.type="text/javascript";e.async=true;e.src="https://cdn.pagesense.io/js/gf3vpwny/69d532aafeb84a3983368483187479bc.js";var x=document.getElementsByTagName("script")[0];x.parentNode.insertBefore(e,x);})(window,"script");</script>
	
	<%
		User user = IAMUtil.getCurrentUser();
		String serviceUrl = request.getParameter("serviceurl");
		String servicename = request.getParameter("servicename");
		Service service = com.adventnet.iam.internal.Util.SERVICEAPI.getService(servicename);
		String goToServiceName =  null;
		if(Util.isValid(service)){
			goToServiceName = service.getDisplayName();			
		}
		List<ISDCode> countryList = SMSUtil.getAllowedISDCodes(); 
		String supportEmail = AccountsConfiguration.getConfigurationValue(AccountsConfiguration.SUPPORT_EMAILID.getConfigName());
		String oneAuthUrl= AccountsConfiguration.TFA_BANNER_ONE_AUTH_URL.getValue(); 
		%>
	
 <script src="<%=jsurl%>/jquery-1.12.2.min.js" type="text/javascript"></script><%-- NO OUTPUTENCODING --%>
 <script src="<%=jsurl%>/select2.min.js" type="text/javascript"></script><%-- NO OUTPUTENCODING --%>
<script src="<%=jsurl%>/jquery.ztooltip.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
<script src="<%=jsurl%>/u2f-api.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
<script src="<%=jsurl%>/common.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
	
	
        <meta name="viewport"content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no" />
		<link rel="stylesheet" href="<%=cssurl%>/flagStyle.css" /> <%-- NO OUTPUTENCODING --%>
		<title><%=Util.getI18NMsg(request, "IAM.ZOHO.ACCOUNTS")%></title>
	</head>
	<style>
		body
		{
			margin: 0;
			display: block;
			height:100%;
			font-family: 'Open Sans', sans-serif;
		}
		.bodybg
		{
			height: 100%;
			min-width:320px;
			width: 18%;
			display: block;
			position: fixed;
			background: url('<%=imgurl%>/bg_green_gradient.png')  no-repeat transparent;	<%-- NO OUTPUTENCODING --%>
			background-size:100%;
			left: 0;
			top: 0;
			z-index: 1;
			opacity: .6;
		}
		.left_illustration
		{
			display: block;
			min-height: 300px;
			min-width: 300px;
			max-height: 500px;
			max-width: 500px;
			width: 26%;
			height: 45%;
			float: left;
			position: fixed;
			z-index: 2;
			background: url('<%=imgurl%>/LaptopImage.png') no-repeat transparent;	<%-- NO OUTPUTENCODING --%>
			background-size: 100%;
			left: 5%;
			top: 100px;
		}
		.container
		{
			display: block;
			height: auto;
			width: calc(100% - 50% );
			position: absolute;
			margin-top: 60px;
			right: 100px;
		}
		.zoho_logo
		{
			display: block;
			height: 27px;
			width: 78px;
			background: url('<%=imgurl%>/Zoho_logo.png') no-repeat transparent;	<%-- NO OUTPUTENCODING --%>
			background-size: 100%;
				
		}
		.heading
		{
			display: block;
			margin-top: 30px;
			font-size: 24px;
			font-weight: 600;
			line-height: 40px;
		}
		.content
		{
			display: block;
			margin-top: 10px;
			line-height: 30px;
			color: #111;
		}
		.bold
		{
			font-weight: 600;
		}
		.link
		{
			cursor: pointer;
			text-decoration: none;
		}
		.link:after
		{
			display: inline-block;
			content: "";
			height: 12px;
			width: 12px;
			background: url("<%=imgurl%>/open%20link.png") no-repeat transparent;	<%-- NO OUTPUTENCODING --%>
			background-size: 100%;
			margin: 0px 5px;
			opacity: 0.3;
			transition: all .2s ease;
		}
		.link:hover:after
		{
			opacity: .7;
		}
		.link:active, .link:visited
		{
			color: #000;
		}
		.btn
		{
			display: block;
			height: 40px;
			padding: 0px 38px;
			border: none;
			border-radius: 2px;
			font-size: 14px;
			margin-top: 30px;
			outline: none;
			letter-spacing: .5;
			cursor: pointer;
		}
		.green
		{
			background-color: #69C585;
			color: #fff;
		}
		.inline
		{
			display: inline-block;
		}
		.right_btn
		{
			float: right;
		}
		.secoundary_btn
		{
			background-color: transparent;
			color: #999;
			font-weight: 400;
			float: right;
			font-size: 12px;
			letter-spacing: 0;
			height: auto;
			width: auto;
			padding: 0;
			margin-top: 40px;
			border-bottom: 1px solid #999;
			margin-bottom:20px;
		}

		.list_div
		{
			display: block;
			margin-top: 30px;
			padding: 0;
			margin-bottom: 0px;
		}
		.list
		{
			display: block;
			font-size: 16px;
			margin-top: 20px;
		}
		
		.list_subtext
		{
			display: block;
			font-size: 14px;
			color: #6D6D6D;
			margin-left: 27px;
			margin-top: 2px;
		}
		.list:before
		{
			display: inline-block;
			content: "";
			height:8px;
			width: 8px;
			border-radius: 50%;
			background-color: #69C584;
			margin:2px;
			margin-right: 17px;
		}
		.radio_btn
		{
			display: block;
			margin-top: 30px;
			cursor: pointer;
		}
		
	.textindent58{
		text-indent:58px !important;
	}
	.textindent66{
		text-indent:66px !important;
	}
	.textindent78{
		text-indent:78px !important;
	}
		.realradiobtn
		{
			display: block;
			position: relative;
			height: 14px;
			width: 14px;
			float:left;
			z-index: 1;
			opacity: 0;
		}
		.radiobtn_style
		{
			display: inline-block;
			height: 16px;
			width: 16px;
			box-sizing: border-box;
			border: 2px solid #E3E3E3;
			border-radius: 50%;
			float: left;
			margin-right: 10px;
			cursor: pointer;
			position: relative;
			margin-left: -14px;	
			margin-top: 2px;
		}
		.realradiobtn:hover ~ .radiobtn_style
		{
			border: 2px solid #69c585;
		}

		.radiobtn_text
		{
			display: inline-block;
			font-size: 16px;
			line-height: 20px;
			cursor: pointer;
		}
		.radio_on:before
		{
			content: "";
			display: block;
			transform:scale(0);
			height: 6px;
			width: 6px;
			border-radius: 50%;
			background-color: #69c585;
			margin: 3px;
			transition: all .2s ease-in-out;
		}
		.realradiobtn:checked ~ .radiobtn_style
		{
			border: 2px solid #69c585;
		}
		.realradiobtn:checked ~ .radio_on:before
		{
			transform:scale(1);
		}
		
		
		.selectedbox
		{
			display: block;
			height: auto;
			width: 480px;
			border-radius: 2px;
			background: transparent;
			border: 2px solid transparent;
			padding: 0 20px;
			box-sizing: border-box;
			margin-top: 30px;
			transition: all .2s ease-in-out;
		}
		.highlight_selectmode
		{
			border: 2px solid #90DFA8;
			background-color: #FBFFFC;
			padding: 20px;
		}
		.mode_description,.mode_verify
		{
			display: block;
			margin-top: 10px;
			font-size: 13px;
			color: #444;
			margin-left: 32px;
			line-height: 20px;
		}
		.selectedbox .radio_btn
		{
			margin: 0;
		}
		

		#smsmode_div .mode_description, #gauthmode_div .mode_description
		{
			display: none;
		}
		#gauth_textbox_btn,#yubikey_textbox_btn
		{
			display: none;
			margin-left:30px;
		}
		.download_link
		{
			display: block;
			margin-top: 20px;
		}
		.textbox_with_btn
		{
			display: block;
			margin-top: 20px;
		}
		.textbox
		{
			display: inline-block;
			height: 34px;
			box-sizing: border-box;
			border: 2px solid #90DFA8;
			width: 270px;
			outline: none;
			text-indent: 5px;
			font-size: 14px;
			float: left;
			line-height: 34px;
			font-family: 'Open Sans', sans-serif;
		}
		.textend_btn
		{
			display: inline-block;
			width: 124px;
			height: 34px;
			background-color: #69C585;
			color: #fff;
			font-size: 13px;
			border: none;
			outline: none;
			margin-left: -5px;
			cursor: pointer;
		}
		.btn_link
		{
			display: inline-block;
			height: 34px;
			background-color: #69C585;
			color: #fff;
			font-size: 13px;
			border: none;
			outline: none;
			margin-left: 0;
			cursor: pointer;
			text-decoration: none;
			box-sizing: border-box;
			padding: 7px 20px; 
			text-align: center;
			text-transform:uppercase;
		}
		#nextbtn
		{
			display: block;
			margin-top: 20px;
		}
		#mobilenumber
		{
			text-indent: 70px;
		}
		.qrcode
		{
		    display: inline-block;
		  	height: 70px;
			  float: left;
			  margin: 5px;
			  width: 70px;
			  margin-right: 10px;
			  background-size: 100%;
		}
		.manualentrytext
		{
			margin-top:20px;
		}
		.textwithqr
		{
		    display: inline-block;
		    width: 295px;
		    font-size: 13px;
		    line-height: 20px;
		    margin-top: 10px;
    		height: auto;
		}
				
		
		.popup
		{
			display: none;
			position: fixed;
			left: 0;
			right: 0;
			margin: auto;
			top: 20%;
			height: auto;
			width: 500px;
			box-sizing: border-box;
			padding: 30px;
			background-color: #fff;
			border-radius: 2px;
			border: 1px solid #e3e3e3;
			z-index: 11;
			box-shadow: 0px 0px 6px #E1E1E1;
		}
		.bg_blur
		{
			display: none;
			position: fixed;
			left: 0;
			top: 0;
			height: 100%;
			width: 100%;
			background-color: #fff;
			opacity: .9;
			z-index: 10;
		}
		.success_img
		{
			display: block;
			margin: auto;
			margin-top: 10px;
			height: 40px;
			width: 40px;
			background: url('<%=imgurl%>/success.png') no-repeat transparent;	<%-- NO OUTPUTENCODING --%>
			background-size: 100%;
		}
		.success_text
		{
			display: block;
			text-align: center;
			font-size: 24px;
			color: #6AC685;
			margin-top: 10px;
			
		}
		.success_details
		{
			display: block;
			text-align: center;
			font-size: 15px;
			line-height: 24px;
			margin-top: 10px;
		}
		.info
		{
			display: block;
			margin-top: 20px;
			text-align: center;
			line-height: 22px;
			font-size: 14px;
			color: #888888;
		}
		.link_text
		{
			color: #4A90E2;
			cursor: pointer;
		}
.btn_center
		{
			display: block;
			margin: auto;
			margin-top: 30px;
		}
		#content_verify_edit{
			padding-right: 25px;
		}
#edit_mob_btn{
	color: #4A90E2;
   	width: auto;
   	cursor: pointer;
}
.error_textbox,.err_text
		{
			display: none;
			font-size: 14px;
			margin-top: 10px;
			color: #ec6e6e;
		}
		.err_text
		{
			display:block;
		}
		.error_box
		{
			display:inline-block;
			height: 48px;
			width: auto;
			position: fixed;
			background-color: #2C2C2C;
			border-radius: 3px;
			box-sizing: border-box;
			padding:  12px;
			transition:all .3s ease-in-out;
			margin: auto;
			z-index: 20;
			left: 50%;
			top: -200px;
			transform: translateX(-50%);
		}
		
		.tick
		{
			display: inline-block;
			height: 24px;
			width: 24px;
			background: url('<%=imgurl%>/tick.png') no-repeat transparent;	<%-- NO OUTPUTENCODING --%>
			background-size: 100%;
			float: left;
		}
		.cross
		{
			background: url('<%=imgurl%>/cross.png') no-repeat transparent;	<%-- NO OUTPUTENCODING --%>
			background-size: 100%;
		}
		.error_message
		{
			display: inline-block;
			line-height: 24px;
			font-size: 14px;
			color: #fff;
			margin-left: 10px;
		}
		.move_errordiv
		{
			top:10px;
		}
		#manual_entry_div{
		display:none;
		}
		#manual_entry{
		margin-top:0;
		}
		#manual_totp_code{
			font-size: 20px;
			font-weight:500;
			line-height: 28px;
			margin-bottom: 10px;
			margin-top:10px;
		}
		
		.totp_code{
			width: 10px;
    display: inline-block;
		}
		.back_to_scan_qr{
	    	color: #4A90E2;
	    	width: auto;
	    	display: inline-block;
	    	cursor: pointer;
	    	text-decoration: none;
		}
		#ode_container{
			position:relative;
		}
		
		.hide
		{
			display:none;
		}
/*		------------------------*/
		
	#combobox{
		display: none;
    }
    
    .resend_btn{
        margin-top: 10px;
    	color: #4A90E2;
    	width: auto;
    	display: inline-block;
    	cursor: pointer;
    }

    .select2-selection:hover{
      cursor:pointer;
    }

		.cntrysearch{
			width:260px;
			height: 32px;
			border-radius: 2px;
			font-size: 14px;
			box-sizing: border-box;
			padding:8px 10px;
			background: #F7F7F7;
			outline: none;
			border:none;
			margin-top: 10px;
		}
    .select2-results__option{
      list-style-type: none;
      height:40px;
      box-sizing: border-box;
      padding:10px 20px;
      font-size: 14px;
      line-height: 20px;
    }
    .select2-search__field{
      width:260px;
      height:32px;
      border: none;
      outline:none;
      background: #F7F7F7;
      border-radius: 2px;
      margin-left: 10px;
      font-size: 14px;
      padding: 10.5px 8px;
		margin-top: 10px;
    }
   
  .select2-selection{
      outline: none;
  }
  .selection{

      transition: all .2s ease-in-out;
      -webkit-user-select: none;
      display:inline-block;
			white-space: nowrap;
      overflow: hidden;
      width:auto;
      height: 34px;
	  outline: none;
    }
    #select2-combobox-results{
      padding-left: 0px;
	  max-height: 180px;
      overflow-y: scroll;
      overflow-x: hidden;
      width:280px;
      margin-top: 10px;
      margin-bottom: 0px;
      background: white;
    }
    .select2-container{
      z-index:10;
      background: #FFFFFF;
			box-shadow: 0 2px 4px 0 rgba(0,0,0,0.13);
      width:280px;
      box-sizing: border-box;
    }
    .select2{
      background: transparent;
      box-shadow: none;
      width:72px !important	;
      position: absolute;
      left:2px;
    }
    #combobox,#verify_mobile{
      display:none;
    }
    #verify_mobile{
    margin-top: 10px;
    font-size: 13px;
    color: #444;
    margin-left: 32px;
    line-height: 20px;
    }
    .pic{
      width:20px;
      height:14px;
      margin-top:3px;
      background-size: 280px 252px;
      background-image: url('<%=imgurl%>/Flags2x.png');	<%-- NO OUTPUTENCODING --%>
      float: left;
    }
    .cc{
      float:right;
      color:#AEAEAE;
    }
    .cn{
    display: inline-block;
    margin-left: 10px;
    width: 150px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    }
    .textbox_div{
      margin-left: 90px;
    }
    .select2-results__option--highlighted{
      background: #F4F6F8;
    }
    .select2-selection__rendered{
      display: inline-block;
		position: absolute;
		padding: 7px;
		padding-left: 35px;
		line-height: 20px;
		color: #000;
		font-size: 14px;
    }
    .searchparent{
      position: relative;
      width:280px;
    }
    #selectflag{
      display: block;
      width:20px;
      height:14px;
		margin: 10px;
      background-size: 280px 252px;
      background-image: url('<%=imgurl%>/Flags2x.png');	<%-- NO OUTPUTENCODING --%>
    }
    .qrimg
    {
   	    height: 80px;
	    width: 80px;
	    position: relative;
	    top: -5px;
	    left: -10px;
    }
    
	#first_step,#second_step,#third_step,#yubikey_textbox_btn
	{
		display:none;
	}
		@media screen and (max-width: 800px)
		{
			.bodybg
			{
				display: none;
			}
			
			.left_illustration
			{
				display: none;
			}
			.container
			{
				display: block;
				width: 82%;
				margin: auto;
				left: 0;
				right: 0;
				position: relative;
				margin-top: 50px;
			}
			.zoho_logo
			{
				display: block;
				float: none;
				
			}
			.heading
			{
				margin-top: 30px;
				font-size: 20px;
				line-height: 30px;
			}
		}
		@media screen and (max-width: 425px)
		{
			.bodybg
			{
				display: none;
			}
			
			.left_illustration
			{
				display: none;
			}
			.container
			{
				display: block;
				width: 82%;
				margin: auto;
				left: 0;
				right: 0;
				position: relative;
				margin-top: 30px;
			}
			.zoho_logo
			{
				display: block;
				float: none;
			}
			.heading
			{
				margin-top: 30px;
				font-size: 20px;
				line-height: 30px;
			}
			.btn
			{
				display: block;
				text-align: center;
				width: 100%;
			}
			.inline
			{
				display: block;
				
			}
			.secoundary_btn
			{
				display: block;
				border-bottom: none;
				font-size: 14px;
				margin-bottom: 20px;
			}
			.highlight_selectmode
			{
				width: 100%;
			}
			.mode_description
			{
				display: block;
				margin-left: auto;
				margin-right: auto;
				
			}
			.selectedbox
			{
				display: block;
				width: 100%;
			}
			.textbox
			{
				display: block;
				float: none;
				border-radius: 0px;
			}
			.textend_btn
			{
				display: block;
				margin-left: 0;
				margin-top: 10px;
			}
			input[type=text] {
  				-webkit-appearance: none;
			}
			.error_box
			{
				width:90%;
				height:auto;
			}
			.error_message
			{
				width:80%;
			}
			#verify_mobile
			{
				margin-left:10px;
				margin-top:20px;
			}
			#gauth_textbox_btn
			{
				margin-left:0px;
			}
		}

		
	</style>
	
	<body>
	<div class="error_box">
				<span class="tick"></span>
				<span class="error_message"></span>
			</div>
	<div class="popup">		
			<div class="success_img"></div>
			<div class="success_text"><%=Util.getI18NMsg(request, "IAM.TFA.BANNER.HURRAY")%></div>
			<div class="success_details"></div>
			<div class="info">
				<span class="link_text" onclick="goToTFAPage()"><%=Util.getI18NMsg(request, "IAM.TFA.BANNER.CLICK.HERE")%> </span><%=Util.getI18NMsg(request, "IAM.TFA.BANNER.SUCCESS.BANNER.DESCRIPTION")%>
			</div>
			<button class="btn green btn_center" id="continue_to_service" onclick="continueToService()"> <%if(Util.isValid(goToServiceName)){ %> <%=Util.getI18NMsg(request, "IAM.TFA.BANNER.CONTINUE.TO")%> <%=IAMEncoder.encodeHTML(goToServiceName.toUpperCase())%> <%} else { %> <%=Util.getI18NMsg(request, "IAM.TFA.BANNER.CONTINUE")%> <%}%></button>
		</div>
	<div class="bg_blur"></div>
		
		<div class="bodybg"></div>
		<div class="left_illustration"></div>
		<div class="container">
			
			<div class="zoho_logo"></div>
			
			<div class="heading"><%=Util.getI18NMsg(request, "IAM.TFA.BANNER.ENABLE.TFA") %><br>
				<%=Util.getI18NMsg(request, "IAM.TFA.BANNER.SECURE.ACCOUNT") %> </div>
			
			<div class="content"><%=Util.getI18NMsg(request, "IAM.TFA.BANNER.CONTENT") %></div>
	

			<div class="selectedbox" id="oneauthmode_div">
				<div class="radio_btn">
					<input id="oneauthmode" type="radio" name="selectmode" class="realradiobtn">
					<span class="radiobtn_style radio_on"></span>
					<label class="radiobtn_text" for=""><%=Util.getI18NMsg(request, "IAM.TFA.BANNER.ONE.AUTH.RECOMMENDED.TITLE") %></label>
				</div>	
				<div class="mode_description hide">
					<div class="text"><%=Util.getI18NMsg(request, "IAM.TFA.BANNER.ONE.AUTH.DESCRIPTION") %></div>
					<div class="download_link">
						<a href="<%=IAMEncoder.encodeHTMLAttribute(oneAuthUrl)%>" id="oneAuthButton" class="btn_link" onclick="continueToService()" target="_blank"><%=Util.getI18NMsg(request, "IAM.TFA.BANNER.INSTALL.NOW") %></a>
					</div>
					
				</div>
			</div>
			
			<div class="selectedbox" id="smsmode_div">
				<div class="radio_btn">
					<input id="smsmode" type="radio" name="selectmode" class="realradiobtn" >
					<span class="radiobtn_style radio_on"></span>
					<label class="radiobtn_text" for=""><%=Util.getI18NMsg(request, "IAM.MOBILE.NUMBER") %></label>
				</div>	
				<div class="mode_description numberinput">
					<div class="text" id="enter_your_mob_msg"><%=Util.getI18NMsg(request, "IAM.TFA.BANNER.ENTER.MOBILE.DESC") %></div>
					<div id="ode_container">
					<div class="textbox_with_btn" id="get_mobile">
			 <select id="combobox">
		   	 <%
							
		    	for(ISDCode isdCode : countryList)
		    	{	int dialingCode = 	isdCode.getDialingCode();
			%>
					<option value="<%=IAMEncoder.encodeHTMLAttribute(isdCode.getCountryCode()) %>" data-num="+<%=dialingCode%>"><%=IAMEncoder.encodeHTML(isdCode.getCountryName())%> </option>
			<% }%>
			</select> 
						<input id="mobilenumber" type="text" class="textbox" required="">
					</div>
					<button class="textend_btn" id="sendcodebtn" onclick = "addmobile()"><%=Util.getI18NMsg(request, "IAM.TFA.BANNER.SEND.CODE") %></button>
					<div id="error_sendcode_div" class="error_textbox"></div>
					</div>
					
      		
					</div>
					<div id="verify_mobile">
						<div id="content_verify_edit">
						<span id="edit_mob_msg"><%=Util.getI18NMsg(request, "IAM.TFA.BANNER.ENTER.CODE") %> <span id="mobile_edit" style="font-weight: bold;"></span> <span id="edit_mob_btn" onclick="editMobile()"><%=Util.getI18NMsg(request, "IAM.EDIT") %></span> </span> 
						</div>
						<div class="textbox_with_btn">
							<input type="text" class="textbox" id="verification_code" required="" oninput="this.value = this.value.replace(/[^\d]+/g,'')">
						</div>
						
						<button class="textend_btn" id="smsVerifyButton" onclick="verifycode()"><%=Util.getI18NMsg(request, "IAM.TFA.VERIFY") %></button>
						<div class="error_textbox" id="error_verify_div"></div>
						<div id="resend_div" class="resend_btn" onclick="sendcode()"><%=Util.getI18NMsg(request, "IAM.MOBILE.RESEND") %></div>
					</div>
				</div>
			
			<div class="selectedbox" id="gauthmode_div">
				<div class="radio_btn">
					<input id="gauthmode" type="radio" name="selectmode" class="realradiobtn">
					<span class="radiobtn_style radio_on"></span>
					<label class="radiobtn_text" for=""><%=Util.getI18NMsg(request, "IAM.GOOGLE.AUTHENTICATOR") %></label>
				</div>	
				<div class="mode_description">
				<div id="qr_display_div">
					<span class="qrcode">
					<img class="qrimg" id="gauthimg" alt="barcode image" />
					</span>
					<span class="textwithqr"><%=Util.getI18NMsg(request, "IAM.TFA.BANNER.GOOGLE.AUTHENTICATOR.DESCRIPTION") %> </span><div class="manualentrytext"><span> <%=Util.getI18NMsg(request, "IAM.TFA.BANNER.PROBLEM.SCAN") %></span> <span id="manual_entry" onclick="manualEntry()" class="resend_btn"> <%=Util.getI18NMsg(request, "IAM.TFA.BANNER.MANUAL.ENTRY") %></span></div>
					</div>
				<div id="manual_entry_div">
				<div id="manual_totp_code"></div>
				<div><%=Util.getI18NMsg(request, "IAM.TFA.BANNER.TYPE.SECRET") %> <%=Util.getI18NMsg(request, "IAM.TFA.BANNER.BACK.TO.SCAN.QR") %></div>
				</div>
				</div>
				
					<div class="textbox_with_btn" id="gauth_textbox_btn">
						<input type="text" id="gauth_code" class="textbox" required="" oninput="this.value = this.value.replace(/[^\d]+/g,'')">
						<button id="gauth_ver_btn" class="textend_btn" onclick="verifyGauthCode()"><%=Util.getI18NMsg(request, "IAM.TFA.VERIFY") %></button>
						<div id="error_gauthverify_div" class="error_textbox"></div>
					</div>
					
			</div>
			
			<div class="selectedbox " id="yubikeymode_div">
				<div class="radio_btn">
					<input type="radio" name="selectmode" class="realradiobtn">
					<span class="radiobtn_style radio_on"></span>
					<label class="radiobtn_text" for=""><%=Util.getI18NMsg(request, "IAM.MFA.YUBIKEY") %></label>
				</div>	
									
				<div class="mode_description" id="first_step">
					<div class="text"><%=Util.getI18NMsg(request, "IAM.MFA.YUBIKEY.INSERT.HEAD") %></div>
					<div class="download_link">
						<button  name="confirm_btn" class="btn_link "  onclick="show_yubikey_configure()"><%=Util.getI18NMsg(request, "IAM.NEXT") %></button>
					</div>
					
				</div>
				<div class="mode_verify" id="second_step">
					<div class="text"><%=Util.getI18NMsg(request, "IAM.TFA.YUBIKEY.TOUCH") %></div>
					<div class="download_link">
						<button  name="confirm_btn" id="ubkey_wait_butt" class="btn_link" ><%=Util.getI18NMsg(request, "IAM.GDPR.DPA.WAITING") %></button>
						<button  name="confirm_btn" id="ubkey_tryagain_butt" class="btn_link hide" onclick="yubikey_register()" ><%=Util.getI18NMsg(request, "IAM.YUBIKEY.TRY.AGAIN") %></button>
						<button  name="confirm_btn" onclick="show_yubikey_step1()" class="btn_link hide" ><%=Util.getI18NMsg(request, "IAM.BACK") %></button>
					</div>
				</div>
				<div class="mode_verify" id="third_step">
					<div class="text"><%=Util.getI18NMsg(request, "IAM.YUBIKEY.NAME.DESC") %></div>
				</div>
				<div class="textbox_with_btn hide" id="yubikey_textbox_btn">
					<input onkeypress="$('.err_text').remove()" id="yubikey_name" class="textbox" required="">
					<button class="textend_btn" id="yubikey_name_confirm" onclick="configure_yubikey()"><%=Util.getI18NMsg(request, "IAM.CONFIGURE") %></button>									
				</div>
			</div>
			<button class="btn secoundary_btn inline" id="rmLaterBtn" onclick="remindMeLater()"><%=Util.getI18NMsg(request, "IAM.TFA.BANNER.REMIND.LATER") %></button>
			
		</div>
		
	</body>
	
	<script type="text/javascript">
	var csrfParam = "<%=SecurityUtil.getCSRFParamName(request)+"="+SecurityUtil.getCSRFCookie(request)%>"; //NO OUTPUTENCODING    
	var contextpath = "<%=request.getContextPath()%>"; //NO OUTPUTENCODING
	function goToTFAPage(){
		window.open(
				  contextpath+"/home#multiTFA/recovery",	//No I18N
				  '_blank'	//No I18N
				);
	}
	
	function continueToService(){
		window.location.href = '<%=IAMEncoder.encodeJavaScript(Announcement.getVisitedNextURL(request))%>';
	}
	
	function remindMeLater(){
		window.location.href = '<%=IAMEncoder.encodeJavaScript(Announcement.getRemindMeLaterURL(request))%>';
	}
	
	function manualEntry(){
		$('#qr_display_div').hide();
		$('#manual_entry_div').show();
	}
	function backToQrScan(){
		$('#qr_display_div').show();
		$('#manual_entry_div').hide();
	}
	
	function editMobile(){
		$("#verify_mobile").hide();
		$(".numberinput").show();
	}
	
	$(".textbox").focus(function(){
		$('.error_textbox').slideUp(200);

	});
	
	function addmobile(){
		var mobile=$("#mobilenumber").val();
		if(!isValidMobile(mobile)){
			$('#error_sendcode_div').html("<%=Util.getI18NMsg(request, "IAM.PHONE.ENTER.VALID.MOBILE") %>");
			$('#error_sendcode_div').slideDown(200);
			return;
		}
		
		var countryCode = $( "#combobox option:selected" ).attr("value");	//No I18N
		var parms={"mobile":{"ph":mobile,"cc":countryCode }};//No I18N
		parms=JSON.stringify(parms);
		  var data = $.ajax({
			    url: "/webclient/v1/mfa/setup/mobile", //No I18N
			    data: parms,
			    headers: {
			       "X-ZCSRF-Token": csrfParam   //No I18N
			       },
			    type: "POST", //No I18N
			    success: function(data, status, xhr) {
			        successAddMobile(data);
			    }
		  }).mobile;
	}
	
	function successAddMobile(data){
		var mobile=$("#mobilenumber").val();
		 if( data.status_code== "429"){
		    	$('.error_message').html("<%=Util.getI18NMsg(request, "IAM.MANY.ATTEMPTS")%>");
				$('.error_box').addClass("move_errordiv");
				$('.tick').addClass("cross");
				setTimeout(function(){
					$('.error_box').removeClass("move_errordiv");
				},3000);
				
				return;
	    	}
		if(data.mobile){
			var msg = data.mobile.i18_message;
			if(data.mobile.status == "success"){
				
				$(".numberinput").hide();
				$("#verify_mobile").show();
				var dialingCode = $( "#combobox option:selected" ).attr("data-num");	//No I18N
				$('.tick').removeClass("cross");
				$("#mobile_edit").html(dialingCode+" "+mobile);
				$('.error_message').html(msg);
				$('.error_box').addClass("move_errordiv");
				setTimeout(function(){
					$('.error_box').removeClass("move_errordiv");
				},3000);
				
				return;
			} else if(data.mobile.status == "error"){	//No I18N
				if(data.mobile.code == "<%=IAMErrorCode.U118.getErrorCode()%>"){	 <%-- NO OUTPUTENCODING --%>
					$('#error_sendcode_div').html(msg);
					$('#error_sendcode_div').slideDown(200);
					return;
				}
				$('.tick').addClass("cross");
				$('.error_message').html(msg);
				$('.error_box').addClass("move_errordiv");
				setTimeout(function(){
					$('.error_box').removeClass("move_errordiv");
				},3000);
				
				return;
			} else if(data.mobile.status=="exception"){	//No I18N
				$('.error_message').html(msg);
				$('.error_box').addClass("move_errordiv");
				$('.tick').addClass("cross");
				setTimeout(function(){
					$('.error_box').removeClass("move_errordiv");
				},3000);
				
				return;
			}
		}
		var obj = JSON.parse(data);
		
		var ar = obj.cause;
		if(!isEmpty(ar)){
			ar = ar.trim();
		    if(ar === "invalid_password_token") {   //No I18N
		    	var serviceurl = window.location.origin + window.location.pathname; 
		    	var redirecturl = obj.redirect_url; 
		   	    window.location.href =contextpath + redirecturl +'?serviceurl='+euc(serviceurl); //No I18N
		    	return;
		    }
		} else {
			$('.error_message').html("<%=Util.getI18NMsg(request,"IAM.TFA.BANNER.TRY.OTHER.OPTION")%>");
			$('.error_box').addClass("move_errordiv");
			$('.tick').addClass("cross");
			setTimeout(function(){
				$('.error_box').removeClass("move_errordiv");
			},3000);
			
			return;
		}
	}
	
	function sendcode(){
		var mobile=$("#mobilenumber").val();
		if(!isValidMobile(mobile)){
			$('#error_sendcode_div').html("<%=Util.getI18NMsg(request, "IAM.PHONE.ENTER.VALID.MOBILE") %>");
			$('#error_sendcode_div').slideDown(200);
			return;
		}
		var countryCode = $( "#combobox option:selected" ).attr("value");	//No I18N
		var res = getPutResponse(contextpath + "/webclient/v1/mfa/setup/mobile/" + mobile.trim() + "/resend?cc=" + countryCode, csrfParam);	//No I18N
		var obj = JSON.parse(res);
		var ar = obj.cause;
		if( obj.status_code== "429"){
	    	$('.error_message').html("<%=Util.getI18NMsg(request, "IAM.MANY.ATTEMPTS")%>");
				$('.error_box').addClass("move_errordiv");
				$('.tick').addClass("cross");
				setTimeout(function(){
					$('.error_box').removeClass("move_errordiv");
				},3000);
				
				return;
	    }
		if(!isEmpty(ar)){
				ar = ar.trim();
			    if(ar === "invalid_password_token") {   //No I18N
			    	var serviceurl = window.location.origin + window.location.pathname; 
			    	var redirecturl = obj.redirect_url; 
			   	    window.location.href =contextpath + redirecturl +'?serviceurl='+euc(serviceurl); //No I18N
			    	return;
			    }
		} else if(obj.resend[0].status == 'success'){
				$(".numberinput").hide();
				$("#verify_mobile").show();
				var dialingCode = $( "#combobox option:selected" ).attr("data-num");	//No I18N
				$('.tick').removeClass("cross");
				$("#mobile_edit").html(dialingCode+" "+mobile);
				$('.error_message').html(obj.resend[0].i18_message);
				$('.error_box').addClass("move_errordiv");
				setTimeout(function(){
					$('.error_box').removeClass("move_errordiv");
				},3000);
				
				return;
		} else if(obj.resend[0].status == 'error'){
			$(".numberinput").hide();
			$("#verify_mobile").show();
			$('.tick').addClass("cross");
			var dialingCode = $( "#combobox option:selected" ).attr("data-num");	//No I18N
			$("#mobile_edit").html(dialingCode+" "+mobile);
			$('.error_message').html(obj.resend[0].i18_message);
			$('.error_box').addClass("move_errordiv");
			setTimeout(function(){
				$('.error_box').removeClass("move_errordiv");
			},3000);
			
			return;
		} else if(obj.resend[0].status == 'exception'){
			$('.error_message').html(obj.resend[0].i18_message);
			$('.error_box').addClass("move_errordiv");
			$('.tick').addClass("cross");
			setTimeout(function(){
				$('.error_box').removeClass("move_errordiv");
			},3000);
			
			return;
		} else {
			$('.error_message').html("<%=Util.getI18NMsg(request,"IAM.TFA.BANNER.TRY.OTHER.OPTION",supportEmail)%>");
			$('.error_box').addClass("move_errordiv");
			$('.tick').addClass("cross");
			setTimeout(function(){
				$('.error_box').removeClass("move_errordiv");
			},3000);
			
			return;
		}
	}
	
	function verifyGauthCode(){
		var code = $("#gauth_code").val();
		if(!isValidCode(code)){
			$('#error_gauthverify_div').html("<%=Util.getI18NMsg(request,"IAM.PHONE.INVALID.VERIFY.CODE")%>");
			$('#error_gauthverify_div').slideDown(200);
			return;
		}
		var en_tkn = "";
		var parms={"totpverify":{"code":code}};//No I18N
		  parms=JSON.stringify(parms);
		  var data = $.ajax({
			    url: "/webclient/v1/mfa/setup/totp/verify", //No I18N
			    data: parms,
			    headers: {
			       "X-ZCSRF-Token": csrfParam   //No I18N
			       },
			    type: "POST", //No I18N
			    success: function(data, status, xhr) {
			        redirectToTFAPage(data);
			    },
				error: function (jqXhr, textStatus, errorMessage) 
			      {
					SuccesERRORMsg(errorMessage);
			      }
        }).totpverify;
	}

	function SuccesERRORMsg(data){
		data = data == "" ? "<%=Util.getI18NMsg(request,"IAM.TFA.BANNER.TRY.OTHER.OPTION",supportEmail)%>" : data;
		$('.error_message').html(data);
		$('.error_box').addClass("move_errordiv");
		$('.tick').addClass("cross");
		setTimeout(function(){
			$('.error_box').removeClass("move_errordiv");
		},3000);
		
		return;
	}
	
	function redirectToTFAPage(data){
		 if( data.status_code== "429"){
		    	$('.error_message').html("<%=Util.getI18NMsg(request, "IAM.MANY.ATTEMPTS")%>");
				$('.error_box').addClass("move_errordiv");
				$('.tick').addClass("cross");
				setTimeout(function(){
					$('.error_box').removeClass("move_errordiv");
				},3000);
				
				return;
	    	}
		if(data.totpverify){
			var msg = data.totpverify.i18_message;
			if(data.totpverify.status == "success"){
				
				$('.tick').removeClass("cross");
				$('.error_message').html(msg);
				$('.error_box').addClass("move_errordiv");
				<%
				String gatex = Util.getI18NMsg(request, "IAM.GOOGLE.AUTHENTICATOR");
				%>
				var msg = "<%=Util.getI18NMsg(request, "IAM.TFA.BANNER.SUCCESS.CONFIGURE.MSG", gatex)%>";
				$('.success_details').html(msg);
				setTimeout(function(){
					$('.error_box').removeClass("move_errordiv");
				},2000);
				
				$('.popup').show();
				$('.bg_blur').show();
				return;
			} else if(data.totpverify.status == "error"){	//No I18N
				if(data.totpverify.code == "<%=IAMErrorCode.U117.getErrorCode()%>"){	 <%-- NO OUTPUTENCODING --%>
					$('#error_gauthverify_div').html(data.totpverify.i18_message);
					$('#error_gauthverify_div').slideDown(200);
					return;
				}
				$('.error_message').html(msg);
				$('.tick').addClass("cross");
				$('.error_box').addClass("move_errordiv");
				setTimeout(function(){
					$('.error_box').removeClass("move_errordiv");
				},3000);
				
				return;
			} else if(data.totpverify.status=="exception"){	//No I18N
				$('.error_message').html(msg);
				$('.error_box').addClass("move_errordiv");
				setTimeout(function(){
					$('.error_box').removeClass("move_errordiv");
				},3000);
				
				return;
			}
		}
		var obj = JSON.parse(data);
		
		var ar = obj.cause;
		if(!isEmpty(ar)){
			ar = ar.trim();
		    if(ar === "invalid_password_token") {   //No I18N
		    	var serviceurl = window.location.origin + window.location.pathname; 
		    	var redirecturl = obj.redirect_url; 
		   	    window.location.href =contextpath + redirecturl +'?serviceurl='+euc(serviceurl); //No I18N
		    	return;
		    }
		} else {
			$('.error_message').html("<%=Util.getI18NMsg(request,"IAM.TFA.BANNER.TRY.OTHER.OPTION")%>");
			$('.error_box').addClass("move_errordiv");
			$('.tick').addClass("cross");
			setTimeout(function(){
				$('.error_box').removeClass("move_errordiv");
			},3000);
			
			return;
		}
	}
	function isValidMobile(mobile){
     	if(mobile.trim().length != 0){
     		var mobilePattern = new RegExp("^([0-9]{5,12})$");
     		if(mobilePattern.test(mobile)){
     			return true;
     		}
     	}
     	return false;
     }
	
	 function isValidCode(code){
	        if(code.trim().length != 0){
	            var codePattern = new RegExp("^([0-9]{5,7})$");
	            if(codePattern.test(code)){
	                return true;
	            }
	        }
	        return false;
	    }
	 
	function verifycode(){
		var mobile = $("#mobilenumber").val();
		var code = $("#verification_code").val();
		if(!isValidCode(code)){
			$('.error_textbox').html("<%=Util.getI18NMsg(request,"IAM.PHONE.INVALID.VERIFY.CODE")%>");
			$('.error_textbox').slideDown(200);
			return;
		}
		var countryCode = $( "#combobox option:selected" ).attr("value");	//No I18N
		
		var res = getPutResponse(contextpath + "/webclient/v1/mfa/setup/mobile/" + mobile.trim() + "/verify?cc="+ countryCode+"&code=" + code, csrfParam);	//No I18N
		var obj = JSON.parse(res);
		var ar = obj.cause;
		if( obj.status_code== "429"){
	    	$('.error_message').html("<%=Util.getI18NMsg(request, "IAM.MANY.ATTEMPTS")%>");
				$('.error_box').addClass("move_errordiv");
				$('.tick').addClass("cross");
				setTimeout(function(){
					$('.error_box').removeClass("move_errordiv");
				},3000);
				
				return;
	    }
		if(!isEmpty(ar)){
			ar = ar.trim();
		    if(ar === "invalid_password_token") {   //No I18N
		    	  var serviceurl = window.location.origin + window.location.pathname; 
		    	  var redirecturl = obj.redirect_url; 
		    	  window.location.href =contextpath + redirecturl +'?serviceurl='+euc(serviceurl); //No I18N
		    	  return;
		    	}
			} else if(obj.verify[0].status == 'success'){
				$('.error_message').html(obj.verify[0].i18_message);
				$('.error_box').addClass("move_errordiv");
				$('.tick').removeClass("cross");
				var msg = "<%=Util.getI18NMsg(request, "IAM.TFA.BANNER.SUCCESS.CONFIGURE.MSG", "SMS/Voice Call" )%>";
				$('.success_details').html(msg)
				setTimeout(function(){
					$('.error_box').removeClass("move_errordiv");
				},3000);
				
				
				$('.popup').show();
				$('.bg_blur').show();
				return;
		}  else if(obj.verify[0].status == 'error') {
				if(obj.verify[0].code == "<%=IAMErrorCode.U117.getErrorCode()%>"){	 <%-- NO OUTPUTENCODING --%>
					$('#error_verify_div').html(obj.verify[0].i18_message);
					$('#error_verify_div').slideDown(200);
					return;
				}
			$('.error_message').html(obj.verify[0].i18_message);
			$('.error_box').addClass("move_errordiv");
			$('.tick').addClass("cross");
			setTimeout(function(){
				$('.error_box').removeClass("move_errordiv");
			},7000);
			
			return;
		}
		 else if(obj.verify[0].status == 'exception') {
				$('.error_message').html(obj.verify[0].i18_message);
				$('.error_box').addClass("move_errordiv");
				$('.tick').addClass("cross");
				setTimeout(function(){
					$('.error_box').removeClass("move_errordiv");
				},3000);
				
				return;
			}
		 else {
				$('.error_message').html("<%=Util.getI18NMsg(request,"IAM.TFA.BANNER.TRY.OTHER.OPTION",supportEmail)%>");
				$('.error_box').addClass("move_errordiv");
				$('.tick').addClass("cross");
				setTimeout(function(){
					$('.error_box').removeClass("move_errordiv");
				},3000);
				
				return;
			}
	}
	
		$(".selectedbox").click(function(){
			var check=$(this).hasClass("highlight_selectmode");
			if(check){
				return;
			}
			var checkopen=$(this).hasClass("highlight_selectmode");
			$(".realradiobtn").attr("checked", false);	//No I18N
			$("#first_step,#second_step,#third_step,#yubikey_textbox_btn").hide();
			if(checkopen=="1")
			{
				$(this).find(".realradiobtn").attr("checked", true);	//No I18N
				$(this).find(".radio_btn").find(".realradiobtn").prop("checked", true);	//No I18N
			}
			else
			{
			$(".selectedbox").find(".mode_description").slideUp(200);
			$(".selectedbox").removeClass("highlight_selectmode");
			$(this).addClass("highlight_selectmode");
			$(this).find(".mode_description").slideDown(200);
			$(this).find(".radio_btn").find(".realradiobtn").prop("checked", true);	//No I18N
			}
			if(this.id == "oneauthmode_div"||this.id == "yubikeymode_div"){
				$('#verify_mobile').hide();
			}
			if(this.id == "gauthmode_div"){
				$('#verify_mobile').hide();
				$('#gauth_textbox_btn').show();
		    	 var resp2 = getOnlyGetPlainResponse("/webclient/v1/mfa/setup/totp/download", "");	//No I18N
				 var a = JSON.parse(resp2);
				 if(a.status_code=='200' && a.totpdownload[0].status !="error"){
					var b64 = a.totpdownload[0].b64;
			     	de('gauthimg').src  = "data:image/jpg;base64, "+ b64;
			     	 var sk= a.totpdownload[0].sk;
				     var dispkey = sk.substring(0, 4) + "<span class='totp_code'></span>"+ sk.substring(4, 8) +"<span class='totp_code'></span>"+sk.substring(8,12)+"<span class='totp_code'></span>"+sk.substring(12); //No I18N
				     $('#manual_totp_code').html(dispkey);
			     	return;
				 }
					 
				  $('#gauth_textbox_btn').show();
				 
				  var parms={"totpsecret":{"en_tkn": "_e_t_" }}; //No I18N
				  parms=JSON.stringify(parms);
				  var data = $.ajax({
					    url: "/webclient/v1/mfa/setup/totp/secret", //No I18N
					    data: parms,
					    headers: {
					       "X-ZCSRF-Token": csrfParam   //No I18N
					       },
					    type: "POST", //No I18N
					    success: function(data, status, xnr) {
					        generateQR(data);
					    },
						error: function (jqXhr, textStatus, errorMessage) 
					      {
							handleSecretFailure(errorMessage);
					      }
	                }).totpsecret;
				} else {
				$('#gauth_textbox_btn').hide();
			}
		});
		
		function generateQR(data){
			 if( data.status_code== "429"){
			    	$('.error_message').html("<%=Util.getI18NMsg(request, "IAM.MANY.ATTEMPTS")%>");
					$('.error_box').addClass("move_errordiv");
					$('.tick').addClass("cross");
					setTimeout(function(){
						$('.error_box').removeClass("move_errordiv");
					},3000);
					
					return;
		    	}
			if(data.totpsecret){
			 var resp2 = getOnlyGetPlainResponse("/webclient/v1/mfa/setup/totp/download", "");	//No I18N
			 var a = JSON.parse(resp2);
			 var b64 = a.totpdownload[0].b64;
		     de('gauthimg').src  = "data:image/jpg;base64, "+ b64;
		     
		     var sk= a.totpdownload[0].sk;
		     var dispkey = sk.substring(0, 4) + "<span class='totp_code'></span>"+ sk.substring(4, 8) +"<span class='totp_code'></span>"+sk.substring(8,12)+"<span class='totp_code'></span>"+sk.substring(12); //No I18N
		     $('#manual_totp_code').html(dispkey);
		     return;
			}
			var obj = JSON.parse(data);
			var ar = obj.cause;
			if(!isEmpty(ar)){
				ar = ar.trim();
			    if(ar === "invalid_password_token") {   //No I18N
			    	  var serviceurl = window.location.origin + window.location.pathname; 
			    	  var redirecturl = obj.redirect_url; 
			    	  window.location.href =contextpath + redirecturl +'?serviceurl='+euc(serviceurl); //No I18N
			    	  return;
			    }
			}
		}
		
		function handleSecretFailure(data){
			 if(data.status_code=="429"){
			    	$('.error_message').html("<%=Util.getI18NMsg(request, "IAM.MANY.ATTEMPTS")%>");
					$('.error_box').addClass("move_errordiv");
					$('.tick').addClass("cross");
					setTimeout(function(){
						$('.error_box').removeClass("move_errordiv");
					},3000);
					
					return;
		    	}
			$('.error_message').html("<%=Util.getI18NMsg(request,"IAM.TFA.BANNER.PROBLEM.QR")%>");
			$('.error_box').addClass("move_errordiv");
			$('.tick').addClass("cross");
			setTimeout(function(){
				$('.error_box').removeClass("move_errordiv");
			},3000);
			
			return;
		}
		
		  $("#combobox").select2({
    templateResult: format,
    templateSelection: function (option) {
          return option.text;
    },
    escapeMarkup: function (m) {
      return m;
    }
  }).on("select2:open", function() {
       $(".select2-search__field").attr("placeholder", "Search...");	//No I18N
       selectIndent();
  });
 function selectIndent(){

		$("#mobilenumber").removeClass("textindent58");
		$("#mobilenumber").removeClass("textindent78");
	    $("#mobilenumber").removeClass("textindent66");
	    
		if($("#select2-combobox-container").html().length==3){
			$("#mobilenumber").addClass("textindent66");
	    }
	    if($("#select2-combobox-container").html().length==2){
	        $("#mobilenumber").addClass("textindent58");
	    }
	    if($("#select2-combobox-container").html().length==4){
	        $("#mobilenumber").addClass("textindent78");
	    }
	}

 window.onload = function(){    
					$("#select2-combobox-container").html($("#combobox option:selected").attr("data-num"));   $(".select2-selection--single").append("<span id='selectflag'></span>");    
					selectFlag();
					$(".selectedbox:first").click();
				};  

	function selectFlag(){
		
		var flagpos="flag_"+$("#combobox").find('option:selected').attr("data-num").slice(1)+"_"+$("#combobox").find('option:selected').val();
		$("#selectflag").attr("class",""); //No I18N
		$("#selectflag").addClass(flagpos);	//No I18N
		//$("#combobox").find('option:selected');
		
	}



  $("#combobox").change(function(){
	  
	    $(".country_code").html($("#combobox option:selected").attr("data-num"));
	    $("#select2-combobox-container").html($("#combobox option:selected").attr("data-num"));
   selectFlag();
   selectIndent();
  });

  function format (option) {
      var spltext;
      if (!option.id) { return option.text; }
         spltext=option.text.split("(");
         var num_code = $(option.element).attr("data-num");
					 var string_code = $(option.element).attr("value");


      var ob = '<div class="pic flag_'+(num_code.slice(1))+'_'+string_code+'" ></div><span class="cn">'+spltext[0]+"</span><span class='cc'>"+num_code+"</span>" ;
      return ob;
};
var yubikey_challenge = {};
function show_yubikey_configure()
{
	  var parms={};
      parms=JSON.stringify(parms);
	  var data = $.ajax({
		    url: contextpath+"/webclient/v1/account/self/user/self/mfa/mode/yubikey", //No I18N
		    data: parms,
		    headers: {
		       "X-ZCSRF-Token": csrfParam   //No I18N
		       },
		    type: "POST", //No I18N
		    success: function(data, status, xhr) {
		        $("#ubkey_wait_butt").show();
				show_yubikey_step2();
				
		 		if(data != null)
		 		{
		 			yubikey_challenge=data.mfayubikey[0];
		 			delete yubikey_challenge.href;
		 			yubikey_register();
		 		}
		    },
			error: function (jqXhr, textStatus, errorMessage) 
		    {
				var obj = JSON.parse(jqXhr.responseText);			
				var ar = obj.cause;
				if(!isEmpty(ar)){
					ar = ar.trim();
				    if(ar === "invalid_password_token") {   //No I18N
				    	var serviceurl = window.location.origin + window.location.pathname; 
				    	var redirecturl = obj.redirect_url; 
				   	    window.location.href =contextpath + redirecturl +'?serviceurl='+euc(serviceurl); //No I18N
				    	return;
				    }
				} else {
					SuccesERRORMsg(errorMessage);
					return;
				}
		    }
		}).mfayubikey;
}

function configure_yubikey()
{
	var name=$("#yubikey_name").val();
	$('.err_text').remove();
	var er_msg;
	if(isEmpty(name))
	{
		er_msg = '<%=Util.getI18NMsg(request,"IAM.ERROR.EMPTY.FIELD")%>';
		$("#yubikey_textbox_btn").append( '<div class="err_text " >'+er_msg+'</div>');
		return false;
	}
	else if(/^[a-zA-Z0-9_\-]*$/.test(name) == false)
	{
		er_msg = '<%=Util.getI18NMsg(request,"IAM.MFA.YUBIKEY.INVALID.YUBIKEY_NAME")%>';
		$("#yubikey_textbox_btn").append( '<div class="err_text">'+er_msg+'</div>');
		return false;
	}
	
	var parms={
			"mfayubikey":{		//No I18N
				"appId":yubikey_challenge.appId,//No I18N		
				"clientData":yubikey_challenge.clientData,//No I18N	
				"registrationData":yubikey_challenge.registrationData//No I18N	
			}
	};
	
	
	parms=JSON.stringify(parms);
	  var data = $.ajax({
		    url: contextpath+"/webclient/v1/account/self/user/self/mfa/mode/yubikey/"+name, //No I18N
		    contentType: 'application/json', //No I18N
		    data: parms,
		    headers: {
		       "X-ZCSRF-Token": csrfParam   //No I18N
		       },
		    type: "PUT", //No I18N
		    success: function(data, status, xhr) {
		    	if( data.status_code== "429"){
			    	$('.error_message').html("<%=Util.getI18NMsg(request, "IAM.MANY.ATTEMPTS")%>");
					$('.error_box').addClass("move_errordiv");
					$('.tick').addClass("cross");
					setTimeout(function(){
						$('.error_box').removeClass("move_errordiv");
					},3000);
					
					return;
		    	}
		    	var msg = data.localized_message;
				if(data.mfayubikey){
					if(data.status_code == 200){
						
						$('.tick').removeClass("cross");
						$('.error_message').html(msg);
						$('.error_box').addClass("move_errordiv");
						<%
						String yubi = Util.getI18NMsg(request, "IAM.MFA.YUBIKEY");
						%>
						var msg = "<%=Util.getI18NMsg(request, "IAM.TFA.BANNER.SUCCESS.CONFIGURE.MSG",yubi)%>";
						$('.success_details').html(msg);
						setTimeout(function(){
							$('.error_box').removeClass("move_errordiv");
						},2000);
						
						$('.popup').show();
						$('.bg_blur').show();
						return;
					} else{
						$('.error_message').html(msg);
						$('.tick').addClass("cross");
						$('.error_box').addClass("move_errordiv");
						setTimeout(function(){
							$('.error_box').removeClass("move_errordiv");
						},3000);
						
						return;
					}
				}
				else{
					$('.error_message').html(msg);
					$('.tick').addClass("cross");
					$('.error_box').addClass("move_errordiv");
					setTimeout(function(){
						$('.error_box').removeClass("move_errordiv");
					},3000);
				}
		    },
			error: function (jqXhr, textStatus, errorMessage) 
		    {

				var obj = JSON.parse(jqXhr.responseText);			
				var ar = obj.cause;
				if(!isEmpty(ar)){
					ar = ar.trim();
				    if(ar === "invalid_password_token") {   //No I18N
				    	var serviceurl = window.location.origin + window.location.pathname; 
				    	var redirecturl = obj.redirect_url; 
				   	    window.location.href =contextpath + redirecturl +'?serviceurl='+euc(serviceurl); //No I18N
				    	return;
				    }
				} else {
					SuccesERRORMsg(errorMessage);
					return;
				}
				
		    }
		}).mfayubikey;
}

function show_yubikey_step1()
{
	$("#first_step").show();
	$("#second_step").hide();
}

function yubikey_register()
{
	$("#ubkey_wait_butt").show();
	$("#ubkey_tryagain_butt").hide();
	u2f.register(yubikey_challenge.appId,[yubikey_challenge],[],ubkeyregister_Callback,10);
}

function ubkeyregister_Callback(data)
{
	if(data.errorCode) 
	{
		$("#ubkey_wait_butt").hide();
		$("#ubkey_tryagain_butt").show();
		 switch (data.errorCode) 
		 {
	        case 1:
	        case 5:
	        	SuccesERRORMsg('<%=Util.getI18NMsg(request,"IAM.NEW.SIGNIN.YUBIKEY.ERROR.REGISTRATION.TIMEOUT")%>'); //No I18N
	        	break;
	         case 2:
	        	SuccesERRORMsg('<%=Util.getI18NMsg(request,"IAM.NEW.SIGNIN.YUBIKEY.ERROR.BADREQUEST")%>'); //No I18N
	         	break;
	     	case 3:
	     		SuccesERRORMsg('<%=Util.getI18NMsg(request,"IAM.NEW.SIGNIN.YUBIKEY.ERROR.UNSUPPORTED")%>'); //No I18N
	             break;
	         case 4:
	        	SuccesERRORMsg('<%=Util.getI18NMsg(request,"IAM.NEW.SIGNIN.YUBIKEY.ERROR.DEVICEINELIGIBLE")%>'); //No I18N
	         	break;
	         default:
	        	SuccesERRORMsg('<%=Util.getI18NMsg(request,"IAM.MFA.YUBIKEY.ERROR.INVALID.REQUEST")%>'); //No I18N
		 }
    } 
	else 
	{
		yubikey_challenge.clientData=data.clientData;
		yubikey_challenge.registrationData=data.registrationData;

		get_YUBIKEY_name();
	}
}


function get_YUBIKEY_name()
{
	$("#second_step").hide();
	$("#third_step").show();
	$("#yubikey_textbox_btn").show();
	$("#yubikey_name").keyup(function(event) 
	{
	    if (event.keyCode === 13) 
	    {
	        $("#yubikey_name_confirm").click();
	    }
	});
}

function show_yubikey_step2()
{
	$("#first_step").hide();
	$("#third_step").hide();
	$("#yubikey_textbox_btn").hide();
	$("#second_step").show();
}	
		
	</script>
</html>