	var effect = 'slide'; // No I18N
	var options ="left";  // No I18N
	var duration = 500;




  	function newpage(url)
  	{
  		$( "#wrap" ).load( url, function() 
  		{
  			      $('#loading').toggle();

   		 });

	}
	
	function check()
	{
					
		var ch= new Array();
		ch[0] ="Name is necessary";
		ch[1] ="URL is necessary";
		ch[2] ="Issuer Details is necessary";
		ch[3] ="Private key cannot be empty";
		ch[4] ="Public key cannot be empty";

		var x = new Array();
		x[0]=$("#AN").val();
		x[1] =document.getElementById("AU").value;
		x[2] =document.getElementById("IS").value;
		x[3] =$("#PRK").val();
		x[4] =$("#PUK").val();	

			if(x[0]=="")
			{

				$("#one").html(ch[0]);
			}
			if(x[1]=="")
			{

				$("#two").html(ch[1]);
			}
			if(x[2]=="")
			{

				$("#twe").html(ch[2]);
			}
			if(x[3]=="")
			{

				$("#for").html(ch[3]);
			}
			if(x[4]=="")
			{

				$("#fiv").html(ch[4]);
			}
	}


$( document ).ready(function()
{

	$( ".menu" ).hide();








	  $(window).load(function() 
			  {
			  	$("#loading").delay(1000).toggle("slow");
			  	setTimeout(function()
			  		{
			  			  	$("#wrap").load("viewapp.jsp");
			  		}
			  		,1400);
			 	
			  });
			   $('.sub').click(function() 
			   {
			   		$( ".menu" ).toggle(effect, options, duration);
			        $("#loading").toggle();
			        var url = $(this).attr('url');
			        newpage(url); 
			        return false; 
			   }); 


	$( ".hamb" ).click(function() 
	{

		$('.menu').show(effect, options, duration);

	});

	$("#cross").click(function ()
	{
		$( ".menu" ).toggle("slide","right",500);
	});


 	$("#top").click(function() 
 	{
		$( ".menu" ).hide(effect, options, duration);
	});
 	$("#wrap").click(function() 
 	{
		$( ".menu" ).hide(effect, options, duration);
	});
 	$("#footer").click(function() 
 	{
		$( ".menu" ).hide(effect, options, duration);
	});
 	

});