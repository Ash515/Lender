<%-- $Id$ --%>
<%@page import="com.zoho.accounts.PhotoUtil.Type"%>
<%@page import="com.zoho.accounts.PhotoUtil"%>
<%@ include file="../../static/includes.jspf" %>
<html>
    <head>
  <% 
  if (request.getHeader("X-Proxied-for") != null) {
      response.setHeader("Content-Encoding", "nogzip");//No i18N
  }
  boolean https = Boolean.parseBoolean(request.getParameter("https"));
  String absoluteurl=AccountsConfiguration.getConfiguration("iam.server.url", "localhost:8080");//No I18N
  String filepath=https?absoluteurl:request.getContextPath();
  String jspath=https?absoluteurl+jsurl:jsurl;
  String cspath=https?absoluteurl+"/"+cssurl:cssurl;
  String imgpath=https?absoluteurl+"/"+imgurl:imgurl;
  UserPreference userPreference = IAMUtil.getCurrentUser().getUserPreference();
  int viewPermission = userPreference == null ? UserPreference.PHOTO_VIEW_ZOHO : userPreference.getPhotoViewPermission();
  String type = request.getParameter("type");
  int ot = IAMUtil.getInt(request.getParameter("ot"));
  boolean isGroup=type != null && !type.equals("user");
  if (Type.SERVICEORG.name().equalsIgnoreCase(type) && ot == -1) {
		throw new IllegalArgumentException("ServiceOrgType is must to upload ServiceOrg logo"); // No I18N
	}
  %>
  <script type="text/javascript">
  	var is_msie = /msie/.test(navigator.userAgent.toLowerCase());
	if(!window.jQuery){
		addscriptTag("<%=jspath%>/jquery-1.12.2.min.js",documentLoaded); <%-- NO OUTPUTENCODING --%>//No I18N
		if(is_msie){
			addscriptTag("<%=jspath%>/jquery.Jcrop.js"); <%-- NO OUTPUTENCODING --%> //No I18N	
		}
	}else{
		documentLoaded();
	}
	function documentLoaded(){
		addscriptTag("<%=jspath%>/jquery.Jcrop.js"); <%-- NO OUTPUTENCODING --%> //No I18N
		$.ajaxSetup({ cache: false });
		$(document).ready(function(){
			if(document.photo.photoViewPermission){
				document.photo.photoViewPermission.value = "<%=viewPermission%>";	
			}
			$.ajaxSetup({ cache:true});}
		);
	}
	function addscriptTag(url,isJqueryLoaded){
			var scriptag = document.createElement("script");
			scriptag.type = "text/javascript";
			scriptag.src = url;
			scriptag.onload=isJqueryLoaded;
			document.getElementsByTagName("head")[0].appendChild(scriptag);
	}
  </script>
  <link href="<%=cspath%>/style.css" type="text/css" rel="stylesheet" />  <%-- NO OUTPUTENCODING --%>
  <link href="<%=cspath%>/jquery.Jcrop.css" type="text/css" rel="stylesheet" />  <%-- NO OUTPUTENCODING --%>
<%
                    String action = request.getContextPath() + "/image/upload";//No I18N
                    String photoid = request.getParameter("EID");
                    if (photoid == null) {
                        photoid = CryptoUtil.encryptWithSalt("photo", request.getParameter("ID"), ":", IAMUtil.getCurrentTicket(), true);//No I18N
                    }
                    if (type != null) {
                        action = request.getContextPath() + "/image/upload?t=" + request.getParameter("type") + "&EID=" + photoid; //NO OUTPUTENCODING //No I18N
                    }
                    if (ot != -1) {
                    	action += "&ot=" + ot; // No I18N
                    }
        %>
        <script>

            <%if ("true".equals(AccountsConfiguration.getConfiguration("use.https", "true"))) {%>
                var loc_port = window.location.port;
                if(loc_port =="" || loc_port == "80") {
                    var iurl=window.location.href;if(iurl.indexOf("http://")==0){iurl=iurl.replace("http://", "https://");window.location.href=iurl;}
                }
            <%}%>

            var photoSize = "ori";//No I18N
            photoSize = "<%=request.getParameter("fs") != null ? IAMEncoder.encodeJavaScript(request.getParameter("fs")) : "ori"%>";
    
            //-----------------------Photo Upload------------------
            function uploadPhoto(f) {
                var file = f.ph.value;
                var substr = file.lastIndexOf(".") == -1 ? "" : file.substring(file.lastIndexOf(".")+1).toLowerCase();
                if(f.ph.value == "") {
                    showUplloadPhotoError('<%=Util.getI18NMsg(request, "IAM.ERROR.VALID.IMAGE")%>');
                    f.ph.focus();
                    return false;
                }
                else if(file != "" && (file.lastIndexOf(".") == -1 || (substr != "jpg" && substr != "gif" && substr != "png" && substr != "jpeg"))) {
                    showUplloadPhotoError('<%=Util.getI18NMsg(request, "IAM.ERROR.INVALID.IMAGE")%>');
                    f.ph.focus();
                    return false;
                    
                }
                /* $("#zformphoto,.photosubtitle,.uploadedit").hide();//No I18N */
                showLoading('-225px');//No i18N
                f.submit();
                f.ph.value="";
                return false;
            }
            function showUplloadPhotoError(msg) {
                var ele = de('photo_errmsg');//No I18N
                ele.className = "pherrmsg";//No I18N
                ele.innerHTML = msg;
                setTimeout("de('photo_errmsg').className='hide'", 5000);
                if($("#loadingImg").is(":visible")){
                	$(".photopopup").css("height","auto");//No I18N
                	hideLoading();
                	showDefaultPhoto();
                }
            }
            function showPhoto(a) {
            	var isJcrop=a=='j';//No I18N
                var ct = new Date().getTime();
                var img = new Image();
                var srcimg=new Image();
			<%if (isGroup) {%>
				isJcrop?img.src = "<%=filepath%>/file?fs=normal&t=<%=IAMEncoder.encodeJavaScript(type)%>&ID=<%=IAMEncoder.encodeJavaScript(photoid)%>&ot=<%=ot%>&nocache="+ct :img.src="<%=filepath%>/file?fs=tempnormal&t=<%=IAMEncoder.encodeJavaScript(type)%>&ID=<%=IAMEncoder.encodeJavaScript(photoid)%>&ot=<%=ot%>&nocache="+ct;<%-- NO OUTPUTENCODING --%>
         	<%} else {%>
         		isJcrop?img.src = "<%=filepath%>/file?fs=normal&nocache="+ct:img.src = "<%=filepath%>/file?fs=tempnormal&nocache="+ct;<%-- NO OUTPUTENCODING --%>
          	<%}%>
           		 initJcropImage(a,img,srcimg,isJcrop);
 			}
 			function closePhotoPopUp(main){
            	if(<%=https%>){
            		window.close();
            		closeAccountsPhotoPop();
            	}
            	$('#opacity,.photopopup').hide(); //No I18N
            	if(!main){
            		showDefaultPhoto();
            }}
            function de(id) {
                return document.getElementById(id);
            }
            function pde(id) {
                return document.getElementById(id);
            }
            /*----jcrop functionality----*/
            function initJcrop(isGroup){
            	var bounds, boundx, boundy;
            	if (is_msie) {
            		jQuery.Jcrop('#target',{//No I18N
            			onChange: showPreview,
                	    onSelect: showPreview,
                	    bgFade:     true,
                        bgOpacity: .5,
                        addClass: 'jcrop-holder',//No I18N
                        minSize: [25, 25],
                        aspectRatio: isGroup ? 0 : 1
            			});
            	}else{
            		$('#target').Jcrop({//No I18N
                	    onChange: showPreview,
                	    onSelect: showPreview,
                	    bgFade:     true,
                        bgOpacity: .5,
                        addClass: 'jcrop-holder',//No I18N
                        minSize: [25, 25],
                        aspectRatio: isGroup ? 0 : 1
                	},function(){
                		var jcrop_api = this;
                		bounds = jcrop_api.getBounds();
                	    boundx = bounds[0];
                	    boundy = bounds[1];
                	    jcrop_api.setSelect(getDimensions(jcrop_api));
                	});	
            	}
            	function showPreview(coords)
            	{
            	    if (parseInt(coords.w) > 0)
            	    {
            	        updateCoords(coords);
            	        var rx = 100 / coords.w;
            	        var ry = 100 / coords.h;
            	        var width=Math.round(rx * boundx) + 'px';//No I18N
            	        var height=Math.round(ry * boundy) + 'px';//No I18N
            	        var marginleft='-' +Math.round(rx * coords.x) + 'px';//No I18N
            	        var marginright='-' +Math.round(rx * coords.y) + 'px';//No I18N
            	        $('#preview').css({//No I18N
            	            width: width,
            	            height: height,
            	            marginLeft: marginleft,
            	            marginTop: marginright
            	        });
            	    }
            	};
            	function updateCoords(c){
            		document.photocrop.x.value=Math.round(c.x);//No I18N
            		document.photocrop.y.value=Math.round(c.y);//No I18N
            		document.photocrop.w.value=Math.round(c.w);//No I18N
            		document.photocrop.h.value=Math.round(c.h);//No I18N
            	}
            }
            function getDimensions(jcrop_api){
                var cropbox = jcrop_api.ui.holder;
                var cropbox_width = $(cropbox).width();
                var cropbox_height = $(cropbox).height();
                if(cropbox_width == cropbox_height) {
                    return [0, 0, cropbox_width, cropbox_height];
                }
                
                if(cropbox_width < cropbox_height) {
                    var a = cropbox_width;
                    var x = Math.round((cropbox_height - cropbox_width) / 2);
                    return [0, x, 0, x + a];
                }
                if(cropbox_width > cropbox_height) {
                    var a = cropbox_height;
                    var x = Math.round((cropbox_width - cropbox_height) / 2);
                    return [x, 0, x + a, 0];
                }
                return [
                    Math.round(cropbox_width/2 - preview_width/2),
                    Math.round(cropbox_height/2 - preview_height/2),
                    Math.round(cropbox_width/2 + preview_width/2),
                    Math.round(cropbox_height/2 + preview_height/2)
                ];
            }
            function saveCroppedPhoto(form){
            	var width = document.photocrop.w.value;
            	if(parseInt(width) === 0){
            		showUplloadPhotoError('<%=Util.getI18NMsg(request, "IAM.PHOTO.NOT.SELECTED")%>');
            		return false;
            	}
            	$(".cropimage").css("opacity","0");//No i18N
            	/* $(".previewholder ,.secondaryphoto,.mainphoto,.croptxt,.buttonholder,.uploadedit").hide();//No I18N */
            	showLoading('54px');//No i18N
            	var params = $(form).serialize();
            	<%if (isGroup) {%>
            		params += "&EID=<%=IAMEncoder.encodeJavaScript(photoid)%>&t=<%=IAMEncoder.encodeJavaScript(type)%>&ot=<%=ot%>"; //No I18N
    			<%}else{%>
    				params += "&t=user";//No I18N
    			<%}%>
            	var csrfParam = '<%=SecurityUtil.getCSRFParamName(request)+"="+SecurityUtil.getCSRFCookie(request)%>';  <%-- NO OUTPUTENCODING --%>
            	params+="&jcrop=true&"+csrfParam;//No I18N 
            	$.ajax({
                    type: "POST",//No I18N
                    url: "/uploadcrop",//No I18N
                    data:params,
                    dataType: "text",//No I18N
                    success: function(){
                    	showPhoto('j');//No I18N
                    }
            	});
            }
            function showEditLoad(px){
            	$(".photodefault").hide();//No I18N
             	$(".photopopup").css("height","500px");//No I18N 
            	$(".loadingContainer").css("marginTop",px);//No i18N
            	$("#loadingImg").show();//No I18N
            }
            function showLoading(px){
            	$("#uploadcontainer").attr("disabled",true)//No i18n
            	$(".loadingContainer").css("marginTop",px);//No i18N
            	$(".uploadttl").hide();//No I18N
            	$(".photodefault").css("opacity","0.1");//No I18N
            	if(<%=https%>){
            		$(".wrapper").css("marginBottom","70px");//No I18N
            	}
            	$("#loadingImg").show();//No I18N
            }function hideLoading(){
            	$(".photopopup").css("height","auto");//No I18N
            	$("#uploadcontainer").attr("disabled",false);//No i18N 
                $("#loadingImg").hide();//No I18N
                $(".photodefault,.cropimage").css("opacity",1);//No i18N
            }
            function showEditPhoto(type){
            		if($(".editbtnphoto").css("border").indexOf("2px")==-1){
            			showEditLoad("54px");//no i18N
            			document.photocrop.currentphoto.value=true;//No I18N
                    	$(".editbtnphoto").css("border-bottom","2px solid #5ac7f0");//No i18N
                    	$(".editbtnphoto").css("cursor","default");//No I18N
                    	$(".uploadbtn").css("cursor","pointer");//No I18N
                    	$(".uploadbtn").css("border","none");//No I18N
                    	var ct = new Date().getTime();
                        var img = new Image();
                        var srcimg=new Image();
						if(type=="group"){
		                    img.src ="<%=filepath%>/file?fs=normal&t=<%=IAMEncoder.encodeJavaScript(type)%>&ID=<%=IAMEncoder.encodeJavaScript(photoid)%>&ot=<%=ot%>&nocache="+ct; <%-- NO OUTPUTENCODING --%>
						}else{
							img.src = "<%=filepath%>/file?fs=normal&nocache="+ct;  <%-- NO OUTPUTENCODING --%>	
						}
                        img.onload = function() {
                        $(".photodefault").hide();//No I18N
                		$(".mainphoto")[0].innerHTML="<img src="+img.src+" id='target'/>";//No I18N
                		$(".secondaryphoto")[0].innerHTML="<img src="+img.src+" id='preview' class='previmg'/>";//No I18N
                		hideLoading();
                		$(".cropimage").show();//No I18N
            			initJcrop(<%=isGroup%>);
            }}}
            function showDefaultPhoto(type){
            	if(type=="group"){hideLoading();}
            	$(".photodefault").css("opacity","1");//No I18N
            	$('.cropimage').hide();//No I18N
            	$('.photodefault').show();//No I18N
            	$(".editbtnphoto").css("cursor","pointer");//No I18N
            	$(".uploadbtn").css("cursor","default");//No I18N
            	$("#zformphoto,.photosubtitle,.uploadedit").show();//No I18N
                $(".editbtnphoto").css("border","none");//No I18N
                $(".uploadbtn").css("border-bottom","2px solid #5ac7f0");//No I18N
           }
            function initJcropImage(a,img,srcimg,isJcrop){
            	img.onload = function() {
                   	try {
                   		$("#photo_permission").val($("#photoViewPermission_pop").val());	//No I18N
                       	if(a!='j'&& a!="d"){
                       		document.photocrop.currentphoto.value=false;//No I18N
                       		$(".photodefault").hide();//No I18N
                       		$(".mainphoto")[0].innerHTML="<img src="+img.src+" id='target'/>";//No I18N
                       		$(".secondaryphoto")[0].innerHTML="<img src="+img.src+" id='preview' class='previmg'/>";//No I18N
                       		hideLoading();
                       		$("img#target").load(function(){//No I18N
                           			$(".cropimage,.uploadedit,.uploadttl").show();//No I18N
                           			$(".editbtnphoto").css("border-bottom","2px solid #5ac7f0");//No I18N
                                   	$(".uploadbtn").css("border","none");//No I18N
                           			initJcrop(<%=isGroup%>);
                           		});
                       		}else{
                       			hideLoading();
                       		}
                     }
                     catch(e){}
                       if(isJcrop){
                       closePhotoPopUp($(".photodefault").is(":visible"));//No I18N
                       if(<%=!https%>){
                    	   try {showsuccessmsg('<%=Util.getI18NMsg(request,"IAM.PHOTO.CROP.UPDATE")%>');$('#msg_div').css('marginLeft','0px');$('#msg_div').css('top','0px');} catch (e) {window.close();}
                       	}}
                   }
            	
            	/**********   Group | User image Loading progress *************************/
				var ct = new Date().getTime();
            	if(a=='j'){
                    <%if (isGroup) {%>
      				img.onload = function() {
      					var newImg=new Image();
      					newImg.src="<%=filepath%>/file?fs=thumb&t=<%=IAMEncoder.encodeJavaScript(type)%>&ID=<%=IAMEncoder.encodeJavaScript(photoid)%>&ot=<%=ot%>&nocache="+ct;  <%-- NO OUTPUTENCODING --%>
      		            document.getElementById('<%=IAMEncoder.encodeJavaScript(type+"_"+photoid)%>').src = newImg.src ;
      		            hideLoading();
      		            closePhotoPopUp($(".photodefault").is(":visible"));// No i18N
      			}<%}else{%>
                      	srcimg.src="<%=filepath%>/file?fs=thumb&nocache="+ct;  <%-- NO OUTPUTENCODING --%>
                      	if(<%=!https%>){document.images.userphoto.src = srcimg.src;
                      		$("#ztb-topband #ztb-profile>img").attr('src',img.src);//no i18N
                      	}
                   <%}%>
                     }else if(a=="d"){ //No i18N
                      	img.src = contextpath+"/file?fs=thumb&nocache="+new Date().getTime();
                  	    document.images.userphoto.src = img.src;
                  	  $("#ztb-topband #ztb-profile>img").attr('src',img.src);//no i18N
                      }
                      if(de('phurl')) {
                          de('phurl').value = "";
                      }
            }
            function changefileTxt(){
            	$('.ttl').text($('#phurl').val());
            }
        </script>
    </head>
    <body>
	<div class="photomain">
		<span id="photo_errmsg"></span> 
		<div class="closeicoposition" onclick=closePhotoPopUp($(".photodefault").is(":visible"))>
			<span class="popupclose" style="margin-top:10px"></span>
		</div>
		<%
                                         if (type == null || "user".equals(type)) {//No i18n
                         %>
		<div class="phototitle"><%=Util.getI18NMsg(request, "IAM.USER.PROFILE.PHOTO")%></div>
		<div class="uploadedit">
			<span class="uploadbtn" onclick="showDefaultPhoto('user')"><%=Util.getI18NMsg(request, "IAM.USER.UPLOAD.TITLE")%></span>
				<%
			if(!Util.USERAPI.isUserPhotoExist(IAMUtil.getCurrentUser().getZUID())){
				%>		
				<span class="editbtnphoto cropdisable"><%=Util.getI18NMsg(request,"IAM.USER.UPLOAD.CROP.TITLE")%></span>
				<span class="editbtnphoto cropdisable"><%=Util.getI18NMsg(request,"IAM.DELETE.PHOTO")%></span>
			<%
			}else{
			%>
			<span class="editbtnphoto" onclick="showEditPhoto('user')"><%=Util.getI18NMsg(request,"IAM.USER.UPLOAD.CROP.TITLE")%></span>
			<span class="editbtnphoto" onclick="deletePhoto()"><%=Util.getI18NMsg(request,"IAM.DELETE.PHOTO")%></span>
			<%} %>
			
		</div>
		<%}else{%>
		<div class="phototitle"><%=Util.getI18NMsg(request, "IAM.UPLOAD.PHOTO.LOGO")%></div>
		<div class="uploadedit">
			<span class="uploadbtn" onclick="showDefaultPhoto('group')"><%=Util.getI18NMsg(request, "IAM.USER.LOGO.UPLOAD.TITLE")%></span>
				<%
				String userid = CryptoUtil.decryptWithSalt("photo", photoid, ":", false); // No I18N
			if(!Util.GROUPAPI.isGroupLogoExists(IAMUtil.getLong(userid))){
				%>		
				<span class="editbtnphoto cropdisable"><%=Util.getI18NMsg(request,"IAM.USER.UPLOAD.CROP.GROUP.TITLE")%></span>
			<%
			}else{
			%>
			<span class="editbtnphoto" onclick="showEditPhoto('group')"><%=Util.getI18NMsg(request,"IAM.USER.UPLOAD.CROP.GROUP.TITLE")%></span>
			<%} %>
			
		</div>
		<%}%>
		<div class="photodefault">
		<div class="photosubtitle"><%=Util.getI18NMsg(request, "IAM.UPLOAD.TEXT")%></div>
		<form name="photo" id="zformphoto" class="zform" target="dummy" enctype="multipart/form-data" method="post" action="<%=IAMEncoder.encodeHTMLAttribute(action)%>" onSubmit="return false;">
			<div style="margin-top: 10px; padding: 6px;">
				<div style="margin-bottom: 10px;  margin-left: 11%;">
					<div class="label">
						<label class="inlineLabel" style="margin-top:0;"><%=Util.getI18NMsg(request, "IAM.PHOTO.CHOOSE.PICTURE")%> </label> <label class="cancelBtn"><span class="ttl"><%=Util.getI18NMsg(request, "IAM.PHOTO.UPLOAD.FROM.COMPUTER")%></span><input type="file" name="ph" id="phurl" class="inputText" onchange="changefileTxt()"></label>
					</div>
					<input type="hidden" name="iamcsrcoo" value="<%=IAMEncoder.encodeHTMLAttribute(IAMUtil.getCookie(request, "iamcsr"))%>"/>
					<%if (type == null || "user".equals(type)) {//No i18n %>
						<div class="label">
							<label class="inlineLabel"><%=Util.getI18NMsg(request, "IAM.PHOTO.VIEW.PERMISSION")%>  </label> <label> <select name="photoViewPermission" id="photoViewPermission_pop" class="photoselect inputSelect chosen-select"> 
									<option value="<%=UserPreference.PHOTO_VIEW_ZOHO%>"><%=Util.getI18NMsg(request, "IAM.PHOTO.PERMISSION.ZOHO.USERS")%></option>  <%-- NO OUTPUTENCODING --%>
									<option value="<%=UserPreference.PHOTO_VIEW_BUDDIES%>"><%=Util.getI18NMsg(request, "IAM.PHOTO.PERMISSION.CHAT.CONTACTS")%></option>  <%-- NO OUTPUTENCODING --%>
									<%if (IAMUtil.getCurrentUser().getZOID() != -1) {%>
									<option value="<%=UserPreference.PHOTO_VIEW_ORG%>"><%=Util.getI18NMsg(request, "IAM.PHOTO.PERMISSION.ORG.USERS")%></option>  <%-- NO OUTPUTENCODING --%>
									<%}%> 
									<option value="<%=UserPreference.PHOTO_VIEW_PUBLIC%>"><%=Util.getI18NMsg(request, "IAM.PHOTO.PERMISSION.EVERYONE")%></option>  <%-- NO OUTPUTENCODING --%>
									<option value="<%=UserPreference.PHOTO_VIEW_NONE%>"><%=Util.getI18NMsg(request, "IAM.PHOTO.PERMISSION.ONLY.MYSELF")%></option>  <%-- NO OUTPUTENCODING --%>
							</select>
							<span class="select-arrow" onclick="changeChoosenDropDown('photoViewPermission_pop_chzn')"></span>
							</label>
						</div>
					<%}%>
					<div style="clear: both;"></div>
				</div>
				<div class="label" style="  margin-left: 11%;">
				<div class="inlineLabel"></div>
					<button class="saveBtn"  id="uploadcontainer" onclick="uploadPhoto(this.form);"><%=Util.getI18NMsg(request, "IAM.UPLOAD")%></button>
				</div>
				<div style="margin-left:267px;">
					<ol class="phnotes">
						<li style="color:#999;font-size: 13px;"><%=Util.getI18NMsg(request, "IAM.NOTE")%></li>
						<li><%=Util.getI18NMsg(request, "IAM.UPLOAD.NOTE1")%></li>
						<li><%=Util.getI18NMsg(request, "IAM.UPLOAD.NOTE2", 10)%></li>
						<li><%=Util.getI18NMsg(request, "IAM.UPLOAD.NOTE3")%></li>
				</ol>
				</div>
			</div>

		</form>
		</div>
	</div>
	<iframe src="<%=filepath%>/static/blank.html" frameborder="0" height="0" width="0" style='display: none;' name=dummy id=dummy onload="getDropDown()"></iframe>  <%-- NO OUTPUTENCODING --%>
	<div class='cropimage'>
	<%-- <div class="uploadttl"><%=Util.getI18NMsg(request,"IAM.USER.UPLOAD.CROP.TITLE")%></div> --%>
		<div class='croptxt'><%=Util.getI18NMsg(request,"IAM.PHOTO.CROP.NOTE")%></div>
		<div class='mainphoto'></div>
		<div class='previewholder'>
			<div class='secondaryphoto'></div>
		</div>
		<div class='buttonholder'>
			<form name="photocrop" method="post" action="/uploadcrop" target="dummy">
				<input type="hidden" name="photoViewPermission" value="0" id="photo_permission"/><input type="hidden" name="x" value="0" /> <input type="hidden" name="y" value="0" /> <input type="hidden" name="w" value="0" /> <input type="hidden" name="h" value="0" />
				<input type="hidden" name="currentphoto" value="false" />
				 <input type="button"  id="j_uploadphoto" value="<%=Util.getI18NMsg(request, "IAM.PHOTO.CROP")%>" onclick="saveCroppedPhoto(this.form);return false;" class="saveBtn"  style=" padding: 5px 34px;"/>
			</form>
		</div>
	</div>
	<div class="loadingContainer" id="loadingImg">
		<div id="progressbar"><div id="progressloader" ><div id="animationbar"></div></div></div>
		<span style="font-style: italic;"><%=Util.getI18NMsg(request, "IAM.LOADING")%>...</span>
	</div>
</body>
</html>

