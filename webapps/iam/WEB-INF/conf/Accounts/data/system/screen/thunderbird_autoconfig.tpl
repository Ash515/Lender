<clientConfig version="1.1">
<emailProvider id="zoho.com">
	<domain>zoho.com</domain>
	<displayName>Zoho Mail</displayName>
	<displayShortName>Zoho</displayShortName>
	<incomingServer type="imap">
		<hostname>imap.zoho.com</hostname>
		<port>993</port>
		<socketType>SSL</socketType>
		<authentication>password-cleartext</authentication>
		<username>${USER_EMAIL}</username>
		<password>${PASSWORD}</password>
	</incomingServer>
	<outgoingServer type="smtp">
		<hostname>smtp.zoho.com</hostname>
		<port>465</port>
		<socketType>SSL</socketType>
		<authentication>password-cleartext</authentication>
		<username>${USER_EMAIL}</username>
		<password>${PASSWORD}</password>
	</outgoingServer>
</emailProvider>
</clientConfig>