<html>
	<head>
        <meta name="viewport"content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no" />
        	<script src="${za.config.iam_js_url_static}/jquery-3_5_1.min.js" type="text/javascript"></script>
		    <script type="text/javascript" src="${za.config.iam_js_url_static}/select2.min.js"></script>
			<script src="${za.config.iam_js_url_static}/common.js" type="text/javascript"></script>
    <script>
  	function continueToService(){
  		var serviceurl = "${announcement.visited_url}";
  		window.location.href = serviceurl;
  		return;
  	}
  
    </script>
		
	</head>
	<style>
		body
		{
			margin: 0;
			display: block;
			font-family: 'Open Sans', sans-serif;
		}
		.bodybg
		{
			height: 100%;
			min-width:320px;
			width: 18%;
			display: block;
			position: fixed;
			background: url("${za.config.iam_img_url}/bg_green_gradient.png") no-repeat transparent;
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
			background: url("${za.config.iam_img_url}/Illustration_TFABanner.png") no-repeat transparent;
			background-size: 100%;
			left: 8%;
			top: 100px;
		}
		.container
		{
			display: block;
			height: auto;
			width: calc(100% - 50% );
			position: fixed;
			margin-top: 100px;
			right: 100px;
		}
		.zoho_logo
		{
			display: block;
			height: 27px;
			width: 78px;
			background: url("${za.config.iam_img_url}/Zoho_logo.png") no-repeat transparent;
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
		.login_details
		{
			display: block;
			margin-top: 30px;
		}
		.login_details_div
		{
			display: inline-block;
			height: 24px;
			margin-right: 30px;
		}
		.login_icon
		{
			display: inline-block;
			height: 18px;
			width: 18px;
			margin: -3px 0px;
		}
		.icon_device
		{
			background: url("${za.config.iam_img_url}/device.png") no-repeat transparent;
			
			background-size: 100%;
		}
		.icon_location
		{
			background: url("${za.config.iam_img_url}/location.png") no-repeat transparent;
			background-size: 100%;
		}
		.login_text
		{
			font-size: 16px;
			line-height: 24px;
		}
		.btn
		{
			display: inline-block;
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
		.list_div
		{
			display: block;
			font-size: 16px;
			padding-left: 0;
	    	margin-bottom: 0px;	
		}
		.list_content
		{
			display: block;
			margin-top: 20px;
			list-style: none;
			
		}
		.list_content:before
		{
			display: inline-block;
			content: "";
			height: 8px;
			width: 8px;
			background-color: #69C584;
			border-radius: 50%;
			margin: 3px;
			margin-right: 10px;
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
		}
		a{
			text-decoration: none;
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
			.textbox
			{
				display: block;
				float: none;
				border-radius: 0px;
			}
		}
	</style>
	<body>
		<div class="bodybg"></div>
		<div class="left_illustration"></div>
		<div class="container">
			<div class="zoho_logo"></div>
			<div class="heading"><@i18n key="IAM.ONE.AUTH.INSTALL.HEADING" /><br>
Secure your Zoho Account. </div>
			
			<div class="content"><@i18n key="IAM.ONE.AUTH.BANNER.CONTENT.MAIN" />
			</div>
		
			<ul class="list_div">
				<li class="list_content"><@i18n key="IAM.ONE.AUTH.BANNER.CONTENT1" />
				</li>
				<li class="list_content"><@i18n key="IAM.ONE.AUTH.BANNER.CONTENT2" /></li>
			</ul>
	
		
		<a href="${announcement.one_auth_url}" target="_blank"><button class="btn green" onclick="continueToService()"><@i18n key="IAM.TFA.BANNER.CONTINUE"/></button></a>
		
			
		<a href="${announcement.remind_me_later_url}"><button class="btn secoundary_btn inline"><@i18n key="IAM.TFA.BANNER.REMIND.LATER"/></button></a>
			
		</div>
	</body>
	
</html>
