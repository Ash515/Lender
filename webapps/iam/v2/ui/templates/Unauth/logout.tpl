<html>
	<head>
		<form id="submitform" name="logoutpost" action="" method="post" enctype="application/x-www-form-urlencoded" >
	        <textarea name="SAMLRequest" id="req" style="display:none;"></textarea>
	        <#if (RELAY_STATE_URL)?has_content>
	        	<input name="RelayState" type="hidden" id="relay" value="" />
	        </#if>
	    </form>
		<script type="text/javascript">
			function remoteGet() {
				<#if (remotelogouturls)?has_content>
					var remotelogouturlsarr = '${remotelogouturls}';
					if(remotelogouturlsarr !== null) {
						var remotelogouturls = JSON.parse(remotelogouturlsarr);
		                for (jsonIdx in remotelogouturls) {
		                    try {
		                        var img = new Image();
		                        var url = remotelogouturls[jsonIdx];
		                        img.src = url;
		                        <#if (serviceurl)?has_content>
		                        img.onerror = function() {
		                        if ((jsonIdx + 1) >= remotelogouturls.length) {
										window.location.href='${Encoder.encodeJavaScript(serviceurl)}';
									}
		                        }
			                    img.onload = function() {
									if ((jsonIdx + 1) >= remotelogouturls.length) {
										window.location.href='${Encoder.encodeJavaScript(serviceurl)}';
									}
								}
								</#if>
		                    } catch (e) { }
						}
					}
				</#if>
			}
			
			function remotePost() {
				<#if (ACTION)?has_content>
					var action = '${ACTION}';
					var logouturl = '${LOGOUT_URL}';
					var samlmsg = '${SAML_MSG}';
					<#if (RELAY_STATE_URL)?has_content>
						var relaystateurl = '${RELAY_STATE_URL}';
						document.getElementById("relay").value = relaystateurl;
					</#if>
					document.getElementById("req").name = action;
					document.getElementById("req").innerHTML = samlmsg;
					document.getElementById("submitform").action = logouturl;
					document.getElementById("submitform").submit();
				</#if>
			}

			window.onload = function() {
				remoteGet();
				remotePost();
			}
		</script>
	</head>
</html>