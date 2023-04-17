<html>
	<script src="${za.tpkg_url}/jquery-3_5_1.min.js" type="text/javascript"></script>
	<script>
		var response_obj = {
				"status" : "${status}",
				"idp_name" : "${provider_name}",
				"email" : "${email}",
				"message" : "${message}"
		}
		$( document ).ready(function() {
		    var parent = window.opener;
		    var target_origin = parent.location.href;    
		    parent.link_account_response(response_obj);  
		    window.close();	
		});
	</script>
</html>