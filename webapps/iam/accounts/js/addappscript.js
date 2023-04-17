
	var privateInput;
	var publicInput;

 	$("#AN").focus(function()
 	{
		$('#an').fadeIn();
		$("#one").html("");
		$("#two").html("");
		$("#twe").html("");
		$("#for").html("");
		$("#fiv").html("");
 	});

  	$("#AU").focus(function()
  	{
		$('#au').fadeIn();
		$("#one").html("");
		$("#two").html("");
		$("#twe").html("");
		$("#for").html("");
		$("#fiv").html("");		
 	});

  	$("#IS").focus(function()
  	{
		$('#is').fadeIn();
		$("#one").html("");
		$("#two").html("");
		$("#twe").html("");
		$("#for").html("");
		$("#fiv").html("");		
 	});

  	$("#NID").focus(function()
  	{
		$('#nid').fadeIn();
		$("#one").html("");
		$("#two").html("");
		$("#twe").html("");
		$("#for").html("");
		$("#fiv").html("");	
 	});

  	$("#SURL").focus(function()
  	{
		$('#surl').fadeIn();
		$("#one").html("");
		$("#two").html("");
		$("#twe").html("");
		$("#for").html("");
		$("#fiv").html("");	
 	});

  	$("#DES").focus(function()
  	{
		$('#des').fadeIn();
		$("#one").html("");
		$("#two").html("");
		$("#twe").html("");
		$("#for").html("");
		$("#fiv").html("");	
 	});

  	$("#fakePrivate").focus(function()
  	{
		$('#prk').fadeIn();
		$("#one").html("");
		$("#two").html("");
		$("#twe").html("");
		$("#for").html("");
		$("#fiv").html("");		
		privateInput = document.getElementById("privateKeyDuplicate");
    	privateInput.value = document.getElementById("PRK").value;
 	});

  	$("#fakePublic").focus(function()
  	{
		$('#puk').fadeIn();
		$("#one").html("");
		$("#two").html("");
		$("#twe").html("");
		$("#for").html("");
		$("#fiv").html("");		
		publicInput = document.getElementById("publicKeyDuplicate");
    	publicInput.value = document.getElementById("PUK").value;
 	});




 	$("#AN").blur(function()
 	{
		$('#an').fadeOut();
 	});
  	$("#AU").blur(function()
  	{
		$('#au').fadeOut();
 	});
  	$("#IS").blur(function()
  	{
		$('#is').fadeOut();
 	});
  	$("#NID").blur(function()
  	{
		$('#nid').fadeOut();
 	});
  	$("#SURL").blur(function()
  	{
		$('#surl').fadeOut();
 	});
  	$("#DES").blur(function()
  	{
		$('#des').fadeOut();
 	});
  	$("#fakePrivate").blur(function()
  	{
		$('#prk').fadeOut();
 	});
  	$("#fakePublic").blur(function()
  	{
		$('#puk').fadeOut();
 	});
	
	//function publicKeyFill()
	$("#fakePublic").click(function()
	{
  	  	var fileinput = document.getElementById("PUK");
    	fileinput.click();
    	publicInput = document.getElementById("publicKeyDuplicate");
    	publicInput.value = document.getElementById("PUK").value;
	});

	//function privateKeyFill()
	$("#fakePrivate").click(function()
	{
  	  	var fileinput = document.getElementById("PRK");
    	fileinput.click();
    	privateInput = document.getElementById("privateKeyDuplicate");
    	privateInput.value = document.getElementById("PRK").value;
	});


	document.getElementById("info").onsubmit = function() 
	{
		
		$('#an').hide();
		$('#au').hide();
		$('#is').hide();
		$('#nid').hide();
		$('#surl').hide();
		$('#des').hide();
		$('#prk').hide();
		$('#puk').hide();
		var x = new Array();
		x[0] =$("#AN").val();
		x[1] =document.getElementById("AU").value;
		x[2] =document.getElementById("IS").value;
		x[3] =document.getElementById("PRK").value;
		x[4] =document.getElementById("PUK").value;
		if((x[0])&&(x[1])&&(x[2])&&(x[3])&&(x[4]))
		{
			
			return (true);
		}
		else
		{
			check();
			return (false);
		}

	};


