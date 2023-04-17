	$( ".pencil" ).click(function() 
	{

		$('#opacity').show();
		console.log($(this).attr('id'));
		$.get("/saml2/app/get?issuer="+$(this).attr('id'), function(data) 
				{
			for(var i in data.data) {
				console.log(i);
				$('#edit input[name='+ i+ ']').val(data.data[i]);
				$('#edit').show();
			}
			$('#edit input[name=old_issuer]').val(data.data['issuer']);
			$('#edit').show();
			});
		
		
	});
	

	$(".certificate").click(function() {
	var aa = "/saml2/app/getcertificate?issuer=" + $(this).attr('sid');  // No I18N
	$.ajax({
		url : aa,
		type : 'POST',// No I18N
		success : function() {
			window.location = aa;
		}
	});
	});
	
	$(".metadata").click(function() {
		var aa = "/saml2/idp/metadata"; // No I18N
		
		var $iframeElem = $("<iframe src='javascript:;' width='0' name='filedownloadIframe' id='filedownloadIframe' border='0' style='display:none;'></iframe>"); // No I18N
		var $formElem = $("<form method='POST' target='" + $iframeElem[0].name + "' action='" + aa + "' encoding='multipart/form-data' enctype='multipart/form-data' style='display:none;'></form>");// No I18N
		$formElem.append($("<input value='" +  encodeURIComponent(getCookie(csrfCookieName)) + "' name='" +csrfParam + "'/>")); // No I18N
		$formElem.append($("<input value='" +  $(this).attr('sid') + "' name='id'/>")); // No I18N
		
		$("body").append($iframeElem).append($formElem);
		$formElem.submit();		
		});
	
	$( "#appName" ).click(function() 
			{
		var url = $(this).attr('url');
		var issur = $(this).attr('issur');
		var f = document.getElementById('openAppForm');
		  f.idp.value = issur;
		  f.csrf.value = encodeURIComponent(getCookie(csrfCookieName));
		  f.csrf.name = csrfParam;
		  f.action = url;
		  window.open('', 'TheWindow');
		  f.submit();
	});

	$( ".trash" ).click(function() 
	{

		$('#opacity').show();
		$('#delete input[name=issuer]').val($(this).attr('id'));
		$('#delete').show();

	});


	$( "#cancel" ).click(function() 
	{

		$('#edit').hide();
		$('#opacity').hide();

	});
	$( "#Abort" ).click(function() 
	{

		$('#delete').hide();
		$('#opacity').hide();

	});


	$( ".x" ).click(function() 
	{

		$('#edit').hide();
		$('#delete').hide();
		$('#opacity').hide();

	});

	function getCSRFParamValue() {
    	return csrfParam + "=" + encodeURIComponent(getCookie(csrfCookieName));
    }
	
	
	function getCookie(cookieName) {
        var nameEQ = cookieName + "=";
        var ca = document.cookie.split(';');
        for(var i=0;i < ca.length;i++) {
            var c = ca[i].trim();
            if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
        }
        return null;
    }
	
	function updateApp() {
		var params = getCSRFParamValue();
		for(var i in $('#edit input[type != Submit]')) {
			if(!Number.isNaN(Number.parseInt(i)) && $($('#edit input')[i]).val()){
				console.log(i);
				params = params+ "&" + $($('#edit input[type != Submit]')[i]).attr('name') + "=" + $($('#edit input')[i]).val(); 
				
			}
		}
		$.post( "/saml2/app/update", params, function( data ) { //No I18N
			  if((data.data.result) == "sucess") {
				$('#opacity').hide();
				$("#wrap").load("viewapp.jsp");
			  } else {
				  alert("Error Occured"); //No I18N
			  }
		});
		console.log(params);
	}
	
	function deleteApp() {
		var params = getCSRFParamValue();
		params = params+ "&issuer=" + $('#delete input[name=issuer]').val();
		$.post( "/saml2/app/delete", params, function( data ) { //No I18N
			  if( data.data && (data.data.result) == "sucess") {
				$('#opacity').hide();
				$("#wrap").load("viewapp.jsp");
			  } else {
				  alert("Error Occured"); //No I18N
			  }
		});
		console.log(params);
	}
	function addApp() {
	$("#wrap").load("addapp.jsp");
	}