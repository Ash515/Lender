//$Id$ 

var photo_src;
function close_dp_popup()
{
	$(".dp_change").fadeOut(200,function(){ 
		$('html, body').css({
		    overflow: 'auto' //No I18N
		});
		$(".photo_loading").hide();
		$(".photo_loading .loader").hide();
		$(".popup_bg").hide();
		document.getElementById("ppvalue").value="0";
	});
	$(".dp_change").removeClass("pop_anim");
}


function Usercrop(f)
{

		$("#t").val("user"); //No I18N
		$(".photo_loading").show();
		$(".photo_loading .loader").show();
		crop(f);
}

function crop(f)
{
	
	var openStyle=clear_img.style;
	
	var curH=parseFloat($("#clear_img").css("height"));//No I18N
	var curW=parseFloat($("#clear_img").css("width"));//No I18N
	
	var H_ratio = orgW / curW;
	var W_ratio = orgH / curH;

	var adjustH=0;
    var adjustW=0;
    
    if(isPicTurned())
	{
    	adjustW=(curH-curW)/2;
        adjustH=(curW-curH)/2;
	}
	
    
    
	var crop_X= W_ratio * Math.abs(parseFloat(openStyle.left)-adjustW);
	var crop_Y= H_ratio * Math.abs(parseFloat(openStyle.top)-adjustH) ;
	
	//220 is the distace of the visible pic	
	var crop_H,crop_W;
	if(curW<220||curH<220){
		if(curW<220){
		    if(isPicTurned())
			{
		    	crop_Y = 0;
	            crop_W = H_ratio * 220;
			    crop_H = W_ratio * curW;
			}
		    else{
	            crop_H = H_ratio * 220;
			    crop_W = W_ratio * curW;
		    	crop_X = 0;
		    }
		}
		else{
		    if(isPicTurned())
			{
		    	crop_W = H_ratio * curH;
			    crop_H = W_ratio * 220;
		    	crop_X = 0;
			}
		    else{
		    	crop_H = H_ratio * curH;
			    crop_W = W_ratio * 220;
		    	crop_Y = 0;
		    }
		}
		if(curW<=220 && curH<=220){
			crop_X= 0;
			crop_Y= 0;
		}
	}
	else{
		crop_H = H_ratio * 220;
		crop_W = W_ratio *220;
	}
	
	$("#x1").val(Math.floor(crop_X));
	$("#y1").val(Math.floor(crop_Y));
	$("#h").val(Math.floor(crop_H));
	$("#w").val(Math.floor(crop_W));
	
	$("#transform_value").val(r_value);

	
  		
	uploadPhoto(f,update_dp);
}


function update_dp()
{
	var ct = new Date().getTime();
	var img=user.cpath+"/file?fs=thumb&nocache="+ct;//No i18N
	if($("#dp_pic").length)
	{
		$("#dp_pic").attr("src",img);//No i18N
	}
	if($("#ztb-profile-image-pre").length)
	{
		$("#ztb-profile-image-pre").attr("src",img);//No i18N
	}
	if($("#ztb-profile-image").length)
	{
		$("#ztb-profile-image").attr("src",img);//No i18N
	}
	close_dp_popup();
}

function uploadPhoto(f,callback)
{
	if(validateForm(f))
	{
	   // var formObj = this.get('__form');
//		var parms=
//		{
//			"height":$('#'+f.id).find('input[name="height"]').val(),//No I18N
//			"width":$('#'+f.id).find('input[name="width"]').val(),//No I18N
//			"x_point":$('#'+f.id).find('input[name="x_point"]').val(),//No I18N
//			"y_point":$('#'+f.id).find('input[name="y_point"]').val(),//No I18N
//			"__form":$('#'+f.id).find('input[type=file]').prop('files')[0],//No I18N
//		};
			var parms=
			{
				"height":$('#'+f.id).find('input[name="height"]').val(),//No I18N
				"width":$('#'+f.id).find('input[name="width"]').val(),//No I18N
				"x_point":$('#'+f.id).find('input[name="x_point"]').val(),//No I18N
				"y_point":$('#'+f.id).find('input[name="y_point"]').val(),//No I18N
				"r_value":rotate_val, //No I18N
				"photo_Permission":$("#photo_permission").val(),//No I18N
				"__form":$('#'+f.id)//No I18N	
			};
		var payload = Photo.create(parms);
		payload.build();
		payload.POST("self","self").then(function(resp)	//No I18N
		{
			 var ct = new Date().getTime();
			 SuccessMsg(getErrorMessage(resp));
			 $("#dp_pic").attr("src",profile_data.photo_url+"&nocache="+ct);//No i18N
			 $("#headder_thumb_pic").attr("src",profile_data.photo_url+"&nocache="+ct);//No i18N
			 $("#info_thumb_pic").attr("src",profile_data.photo_url+"&nocache="+ct);//No i18N
			 $(".dp_pic_blur_bg,.headder_thumb_pic_blur_bg,.info_thumb_pic_blur_bg").css("background-image","url("+profile_data.photo_url+"&nocache="+ct+")");
			 close_dp_popup();
		},
		function(resp)
		{
			showErrorMessage(getErrorMessage(resp));
			$(".photo_loading").hide();
			$(".photo_loading .loader").hide();
		});
	}

}






$('#picsrc').on('click touchstart' , function(){
    $(this).val('');
});

var _URL = window.URL || window.webkitURL;
var img = document.getElementById("img");
var clear_img=document.getElementById("clear_img");
var wrp = document.getElementById("wrp");
var scale=document.getElementById("ppvalue");
var orgH,orgW,drgsize,imgdetail;
var drag=false;
var r_value;


var rotation = {
		  1: 'rotate(0deg)',//No i18N
		  2: 'rotate(0deg) scaleX(-1)',//No i18N
		  3: 'rotate(180deg)',//No i18N
		  4: 'rotate(180deg) scaleX(-1)',//No i18N
		  5: 'rotate(90deg) scaleY(-1)',//No i18N
		  6: 'rotate(90deg)',//No i18N
		  7: 'rotate(270deg) scaleY(-1)',//No i18N
		  8: 'rotate(270deg)'  //No i18N
		}


function getOrientation(file, callback) 
{
  var reader = new FileReader();

  reader.onload = function(event) 
  {
    var view = new DataView(event.target.result);

    if (view.getUint16(0, false) != 0xFFD8) 
    {
    	return callback(-2);
    }

    var length = view.byteLength,
        offset = 2;

    while (offset < length) 
    {
      var marker = view.getUint16(offset, false);
      offset += 2;

      if (marker == 0xFFE1) 
      {
        if (view.getUint32(offset += 2, false) != 0x45786966) 
        {
          return callback(-1);
        }
        var little = view.getUint16(offset += 6, false) == 0x4949;
        offset += view.getUint32(offset + 4, little);
        var tags = view.getUint16(offset, little);
        offset += 2;

        for (var i = 0; i < tags; i++)
        {
          if (view.getUint16(offset + (i * 12), little) == 0x0112)
          {
            return callback(view.getUint16(offset + (i * 12) + 8, little));
          }

        }
      }
      else if ((marker & 0xFF00) != 0xFF00) 
      {
    	  	break;
      }
      else
      {
    	  offset += view.getUint16(offset, false);
      }
    }
    return callback(-1);
  };

  reader.readAsArrayBuffer(file.slice(0, 64 * 1024));
};

var fileInput = document.getElementById("file-input");
$("#picsrc").change(function(e) 
{
    var picture;
    $(".rotate_opt").attr("onclick","setRotateVal(this,0)");
    rotate_val = 0;
    closePopup(close_dp_popup,"dp_change",true);	//No i18N
    $("#photo_permission").val(parseInt(photoPermission));
    if(!isMobile){
    	$("#photo_permission").select2({
    		theme: "photo_perm",		//No i18N
    		minimumResultsForSearch: Infinity
    	});    	
    }
    $("#select2-photo_permission-container").removeAttr("title");
    $("#photo_permission").change(function(){
    	$("#select2-photo_permission-container").removeAttr("title");
    });
    if ((picture = this.files[0])) 
    {
        imgdetail = new Image();
        imgdetail.src = _URL.createObjectURL(picture);
        drag=false;    
		imgdetail.onload=function()
		{
			orgH=this.height;
			orgW=this.width;
        var file = picture;
        if(file) 
        {
			$(".dp_change").show(0,function(){
				$(".dp_change").addClass("pop_anim");
				$(".dp_change").focus();
				//$(".popup_bg").attr("onclick","close_dp_popup()");
			});
			$(".popup_bg").show();
			$("html").css("overflow","hidden");//No I18N
			getOrientation(file, function(orientation) 
			{
				if($("#orientation_check").css("image-orientation") == "none" || orientation<=0){
					orientation=1;
				}
            	var rotated = $('#img').attr('src', imgdetail.src);//No I18N
            	var rotated1 = $('#clear_img').attr('src', imgdetail.src);//No I18N
            	if (rotation[orientation]) 
            	{
					
                	rotated.css('transform', rotation[orientation]);
                	rotated1.css('transform',rotation[orientation]);
						
				}
				else
				{
                	rotated.css('transform', "rotate(0deg)");//No I18N
                	rotated1.css('transform',"rotate(0deg)");//No I18N
					
				}
				r_value=orientation;
				if(orgW>orgH)
				{
					if((r_value==6)||(r_value==8)||(r_value==5)||(r_value==7))
					{
						$("#ppvalue").val("140");
					}
					else
					{
						$("#ppvalue").val("280");
					}
				}
				if(orgW<orgH)
				{
					if((r_value==6)||(r_value==8)||(r_value==5)||(r_value==7))
					{
						$("#ppvalue").val("280");
					}
					else
					{
						$("#ppvalue").val("140");
					}
				}
				if(orgW==orgH)
				{
					$("#ppvalue").val("280");
				}
				backScale();
				var intval;
				
/*           		$("#clear_img").css({"left":(((400-width1)/2)-90)+"px","top":(((280-height1)/2)-30)+"px"});//No I18N
           		$("#img").css({"left":((400-width1)/2)+"px","top":((280-height1)/2)+"px"});//No I18N
*/			
				draZoomX=parseInt(de("img").style.left);//No I18N
           		draZoomY=parseInt(de("img").style.top);//No I18N
				draWidth=parseInt(de("img").style.width);//No I18N
				draHeight=parseInt(de("img").style.height);//No I18N
				$("#dp_change").focus();
         });
		} 
		}   
    } 
});


var lastsize=0;
var lastsizeCon=0;
var size,width1,height1,conheight,conwidth,divd;





function sizeAnalize()//size analyzer return picture type
{                                           
  size = document.getElementById("ppvalue").value;
  size = parseInt(size);
  if(orgW < orgH)
    {
	  //"width is bigger than height"
      height1=size+220;
      divd=orgH/height1;
      conwidth=orgW/divd;
      width1=conwidth;  
    }
    if(orgW > orgH)
    {
      //"height bigger then width"
      width1=size+220;
      divd=orgW/width1;
      conheight=orgH/divd;
      height1=conheight;
   
    }
     if(orgH===orgW)
    {
      //"width and height saame value"
      height1=size+220;
      width1=size+220;
      divd=orgH/220;   
    }
} 
		
var mymove=false;
var scalemove=false;
var moveX,moveY,backwidth,backheight,fpointX,fpointY;
$(document).ready(function(){
  $("#ppvalue").mousedown(function(event)
  {
    if(imgdetail)
    {
      scalemove=true;
      mymove=false;
    }
    else
    {
      alert("upload pic");//No I18N
    } 
  });
  $("#ppvalue").on('touchstart',function(event)
		  {
		    if(imgdetail)
		    {
		      scalemove=true;
		      mymove=false;
		    }
		    else
		    {
		      alert("upload pic");//No I18N
		    } 
		  });
  $("#ppvalue").mouseup(function(event)
  {
      scalemove=false;
      mymove=false;
      lastsizeCon=document.getElementById("ppvalue").value;
      lastsize=document.getElementById("ppvalue").value;
      lastsizeCon=parseInt(lastsizeCon);
      lastsize=parseInt(lastsize);        
  });
  $("#ppvalue").on('touchend',function(event)
  {
		      scalemove=false;
		      mymove=false;
		      lastsizeCon=document.getElementById("ppvalue").value;
		      lastsize=document.getElementById("ppvalue").value;
		      lastsizeCon=parseInt(lastsizeCon);
		      lastsize=parseInt(lastsize);        
  });
  $("#ppvalue").mousemove(function(event)
  {
      if(scalemove==true){
            lastsizeCon=size; 
            backScale();
      }
  });
  $("#ppvalue").on('touchmove',function(event)
		  {
		      if(scalemove==true){
		            lastsizeCon=size; 
		            backScale();
		      }
		  });
 $("#wrp").mousedown(function(event)
 {
	 event.preventDefault();
 });
 
 
  $("#clear_img").mousedown(function(event)
  {
	  drag_start_point(event);
  });
  $("#clear_img").on('touchstart',function(event){
	  drag_start_point(event.originalEvent.touches[0]);
  });
  
 function drag_start_point(e){
	  e.originalEvent.preventDefault();
      backheight = parseInt(de("clear_img").style.height);//No I18N
      backwidth = parseInt(de("clear_img").style.width);//No I18N

	  moveX = parseInt(de("img").style.left);//No I18N
      moveY = parseInt(de("img").style.top);//No I18N
      mymove=true;
      fpointX=e.clientX-(wrp.offsetLeft);
      fpointY=e.clientY-(wrp.offsetTop);
//       console.log(wrp.offsetLeft+"   "+wrp.offsetTop);
  }
  
  
  $("#clear_img").parents().mouseup(function(event)
  {
      mymove=false;
      $("#clear_img").parents().css("cursor","default");//No I18N
  });
  $("#clear_img").parents().on('touchend',function(event)
  {
	  mymove=false;
	  $("#clear_img").parents().css("cursor","default");//No I18N
  });
  $("#wrp").parents().on('touchend', function(event)
  {
	  mymove=false;
  });
  $("#wrp").parents().mouseup(function(event)
  {
      mymove=false;
  });                                            //using to mouse drag handling;    
  
  $("#clear_img").parents().mousemove(function(event)
  {
	  move_object(event);
    });
  $("#clear_img").parents().on('touchmove', function(event)
  {
	  move_object(event.originalEvent.touches[0]);
  });
function move_object(event){  
	    if(mymove==true)
	    {
//			  if((parseInt(de("img").style.left) >= $(".inContainer")[0].offsetLeft || parseInt(de("img").style.left)==0)&&((parseInt(de("img").style.width)<=220)||(parseInt(de("img").style.height)<=220))){
//				  return false;
//			  }
		      $("#clear_img").parents().css("cursor","move");//No I18N
		      
		      draZoomX=parseInt(de("img").style.left);//No I18N
		      draZoomY=parseInt(de("img").style.top);//No I18N
			  draWidth=parseInt(de("img").style.width);//No I18N
		  	  draHeight=parseInt(de("img").style.height);//No I18N
				
		      spointX=(event.clientX-(wrp.offsetLeft)-fpointX);
		      spointY=(event.clientY-(wrp.offsetTop)-fpointY);
		       
		      var point_x,point_y,limitx,limity,x,y;   
		  
			if(isPicTurned())
			{
				point_x=((backheight-backwidth)/2)+$(".inContainer")[0].offsetLeft;		//any posi change shuffle height and width
		        point_y=(backwidth-backheight)/2+20; 
				x=moveX+spointX;
		        y=moveY+spointY;
				
				if(point_x<=x)
				{
		           x=point_x;
		        }
				if(point_y<=y)
				{
				   y=point_y;
				}
				if((point_y-(backwidth-220))>=y)
				{
		        	y=(point_y-(backwidth-220));
				}
		      	if((0-(backheight-220))+point_x>=x)
		      	{
		        	x=(0-(backheight-220))+point_x;  
		      	}
		      	drgsize=(size);        
		      	drag=true;
			  
		      	if((backwidth>backheight) && ((backheight<=220))){
		      		$("#clear_img").css({"right":"unset","left":(picalignX)-$(".inContainer")[0].offsetLeft+"px","top":(y-20)+"px"});//No I18N
				    $("#img").css({"right":"unset","left":(picalignX)+"px","top":y+"px"});//No I18N
			    	return false;
		      	}
		      	else if((backwidth<backheight) && ((backwidth<=220))){
		      		$("#clear_img").css({"right":"unset","left":(x-$(".inContainer")[0].offsetLeft)+"px","top":"unset"});//No I18N
		      		$("#img").css({"right":"unset","left":(x)+"px","top":(picalignY)+"px"});//No I18N
		      		return false;
			    }
		    }
			else
			{
				 point_x=(backwidth-220);
		         point_y=(backheight-220); 
				 limitx=$(".inContainer")[0].offsetLeft;
				 limity=20;
				 x=moveX+spointX;
		         y=moveY+spointY;
		      if((limitx-point_x)>x)
		      {
		        x=(limitx-point_x);
		      }
		      if((x>=(limitx)))
		      {
		        x=limitx;
		      }
		      if(y>=limity)
		      {
		        y=limity;
		      }
		      if(-(point_y)>=(y-20))
		      {
		        y=limity-point_y;
		      }
			  drgsize=(size);        
		      drag=true;
			  
		      if((backwidth<backheight) && ((backwidth<=220))){
		    	  $("#clear_img").css({"right":"0px","left":"0px","top":(y-20)+"px"});//No I18N
			      $("#img").css({"right":"unset","left":(picalignX)+"px","top":y+"px"});//No I18N
		    	  return false;
		      }
		      else if((backwidth>backheight) && ((backheight<=220))){
		    	  $("#clear_img").css({"right":"unset","left":(x-$(".inContainer")[0].offsetLeft)+"px","top":"unset"});//No I18N
			      $("#img").css({"right":"unset","left":(x)+"px","top":(picalignY)+"px"});//No I18N
		    	  return false;
		      }
			}

		      $("#clear_img").css({"left":(x-$(".inContainer")[0].offsetLeft)+"px","top":(y-20)+"px"});//No I18N
		      $("#img").css({"left":(x)+"px","top":y+"px"});//No I18N
		
		}
	}
});



var draZoomX,draZoomY,draWidth,draHeight;   


function positionFix()
{
	var ZoomX,ZoomY,point_x,point_y;
    var aaa=(drgsize-size)/2;

	picalignX=(($(".dp_container").width())-width1)/2;
    picalignY=(260-height1)/2;
    
	var widthvar=draWidth/(250-draZoomX);		//half of popup width
	var heightvar=draHeight/(130-draZoomY);
	
	if((width1<=220)||(height1<=220))		//clear space width and height
	{
		draZoomX=parseInt($("#img")[0].offsetLeft);//No I18N
		draZoomY=parseInt($("#img")[0].offsetTop);//No I18N
		draWidth=parseInt(de("img").style.width);//No I18N
		draHeight=parseInt(de("img").style.height);//No I18N
	}
	
    if(drag==true)
    { 

    	if(isPicTurned())
       {
			backheight = parseInt(de("clear_img").style.height);//No I18N
	      	backwidth = parseInt(de("clear_img").style.width);//No I18N
			point_x=((height1-width1)/2)+$(".inContainer")[0].offsetLeft; 
	    	point_y=((width1-height1)/2)+20; 
	    	widthvar=draHeight/(250-draZoomX);
	    	heightvar=draWidth/(130-draZoomY);
			ZoomX=draZoomX-((height1-draHeight)/widthvar);
			ZoomY=draZoomY-((width1-draWidth)/heightvar);
			   
			   if(ZoomX>=point_x)
			   {
				  ZoomX=point_x;
			   }
			   if(ZoomY>=point_y)
			   {
				   ZoomY=point_y;
			   }
			   if((ZoomX)<=(point_x+220)-height1)
			   {
				  ZoomX=(point_x+220)-height1;
			   }
			   if((ZoomY)<=(point_y+220)-width1)
			   {
				  ZoomY=(point_y+220)-width1;
			   }
		       if((backwidth>backheight) && ((backheight<=220))){

		    	   $("#clear_img").css({"left":(picalignX)-$(".inContainer")[0].offsetLeft+"px","top":(ZoomY-20)+"px"});//No I18N
		           $("#img").css({"right":"unset","left":(picalignX)+"px","top":(ZoomY)+"px"});//No I18N 
		           return false;
		       }
		       else if((backwidth<backheight) && ((backwidth<=220))){
		        	
		    	   $("#clear_img").css({"right":"unset","left":(ZoomX)-$(".inContainer")[0].offsetLeft+"px","top":"unset"});//No I18N
		           $("#img").css({"right":"unset","left":(ZoomX)+"px","top":picalignY+"px"});//No I18N 
		           return false;
		       }
	   }
       else
       {
			ZoomX=draZoomX-((width1-draWidth)/widthvar);
			ZoomY=draZoomY-((height1-draHeight)/heightvar);
	        if((ZoomX+width1)<=($(".inContainer")[0].offsetLeft+220))		//360 is clear pic width(220) + 140
	        {
	            ZoomX=($(".inContainer")[0].offsetLeft+220)-width1;
	        }
	        if((ZoomX>=($(".inContainer")[0].offsetLeft)))
	        {
	            ZoomX=$(".inContainer")[0].offsetLeft;            
	        }
	        if(ZoomY>=20)
	        {
	            ZoomY=20;
	        }
	        if((ZoomY+height1)<=240)			//240 is clear pic width(220) + 20
	        {
	           ZoomY=240-height1;
	        }
	  
	        if((backwidth<backheight) && ((backwidth<=220))){
	    		$("#clear_img").css({"right":"0px","left":(ZoomX)-$(".inContainer")[0].offsetLeft+"px","top":(ZoomY-20)+"px"});//No I18N
	    		$("#img").css({"right":"0px","left":"0px","top":ZoomY+"px"}); //No I18N 
	    		return false;
	    	}
	    	else if((backwidth>backheight) && ((backheight<=220))){
	    		$("#clear_img").css({"right":"unset","left":(ZoomX)-$(".inContainer")[0].offsetLeft+"px","top":"unset"});//No I18N
	    		$("#img").css({"right":"unset","left":(ZoomX)+"px","top":(picalignY)+"px"}); //No I18N 
	    		return false;
	    	}
	   }
		$("#clear_img").css({"right":"unset","left":(ZoomX)-$(".inContainer")[0].offsetLeft+"px","top":(ZoomY-20)+"px"});//No I18N
		$("#img").css({"right":"unset","left":(ZoomX)+"px","top":ZoomY+"px"});      //No I18N    
    }
    else
    {
    	if(picalignX >= $(".inContainer")[0].offsetLeft){
    		$("#clear_img").css({"right":"0px","left":"0px","top":(picalignY-20)+"px"});//No I18N
    	}
    	else{
    		$("#clear_img").css({"right":"unset","left":(picalignX)-$(".inContainer")[0].offsetLeft+"px","top":(picalignY-20)+"px"});//No I18N
    	}
        $("#img").css({"right":"unset","left":(picalignX)+"px","top":picalignY+"px"});//No I18N 
    }    
}
    
function backScale()
{                                             //its return the picture size and zoom in out function
	var scaleBar = document.getElementById("ppvalue");
	scaleBar.style.background = 'linear-gradient(to right, #10BC83 0%, #10BC83 ' + ((scaleBar.value/600)*100) + '%, #E6E6E6 ' + ((scaleBar.value/600)*100) + '%, #E6E6E6 100%)'
	if(r_value||r_value==0)
   {
        sizeAnalize();
     if(size!=lastsizeCon)
     {
            positionFix();
     }
    
      $("#img").css({"width":width1+"px","height":height1+"px"});//No I18N
      $("#clear_img").css({"width":width1+"px","height":height1+"px"});//No I18N
	    
      moveX = parseInt($("#img").css("left"));//No I18N
      moveY = parseInt($("#img").css("top"));//No I18N
      backheight = parseInt(de("clear_img").style.height);//No I18N
      backwidth = parseInt(de("clear_img").style.width);//No I18N
	   
   }
}
var rotate_val = 0;
function setRotateVal(ele,val){
	$(ele).hasClass('icon-RotateRight') ? val++ : val--;
	val = val < 0 ? 3 : val;
	val = val > 3 ? 0 : val;
	rotate_val = val;
	$(".rotate_opt").attr("onclick","setRotateVal(this,"+val+")");
	var angle = parseInt(rotation[r_value].match(/\d+/)[0])+(val*90);
	var scale_val = document.getElementById('img').style.transform.split(" ")[1];
	if(scale_val){
		$('#img').css('transform', "rotate("+angle+"deg) "+scale_val);
		$('#clear_img').css('transform',"rotate("+angle+"deg) "+scale_val);
	}
	else{
		$('#img').css('transform', "rotate("+angle+"deg)");
		$('#clear_img').css('transform',"rotate("+angle+"deg)");
	}

	backScale();
			
	draZoomX=parseInt(de("img").style.left);//No I18N
	draZoomY=parseInt(de("img").style.top);//No I18N
	draWidth=parseInt(de("img").style.width);//No I18N
	draHeight=parseInt(de("img").style.height);//No I18N
}

function isPicTurned(){
	if($("#orientation_check").css("image-orientation") != "none"){
		if(((r_value==6)||(r_value==8)||(r_value==5)||(r_value==7))&&((rotate_val==1)||(rotate_val==3)))
		{
			return false;
		}
	}
	if((r_value==6)||(r_value==8)||(r_value==5)||(r_value==7)||(rotate_val==1)||(rotate_val==3))
	{
		return true;
	}
	return false;
}
$(document).ready(function() {
	var setint;
	$('.dp_size_small,.dp_size_large').on('mousedown touchstart',function (e) {
		clearInterval(setint);
		setint = setInterval(function () {
			if($(e.target).hasClass("dp_size_small")){
				$("#ppvalue").val(parseInt($("#ppvalue").val())-2);
			}
			else{
				$("#ppvalue").val(parseInt($("#ppvalue").val())+2);
			}
			lastsizeCon=size;
			backScale();
		},10);
	});
	$('.dp_size_small,.dp_size_large').on("mouseleave mouseup touchend touchcancel", function () {
	   clearInterval(setint);
	});
	$(".dp_size_small,.dp_size_large").click(function(e){
		if($(e.target).hasClass("dp_size_small")){
			$("#ppvalue").val(parseInt($("#ppvalue").val())-2);
		}
		else{
			$("#ppvalue").val(parseInt($("#ppvalue").val())+2);
		}
		lastsizeCon=size;
		backScale();
	});
});
