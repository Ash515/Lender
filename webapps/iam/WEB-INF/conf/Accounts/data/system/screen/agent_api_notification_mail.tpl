<html>
	<body>
		<table border="0" style="text-align:left" cellpadding="3px">
			<tr>
				<td colspan="2"><center><strong>${ztpl.servicename}'s ${ztpl.apiservicename} ${ztpl.prefix} agent api's usage percentage</strong><center></td>
			</tr>
			<tr>
				<td style="width:250px;font-weight:bold;text-align:right;">Ratio :</td>
				<td>${ztpl.threshold_noofrequests} no of requests allowed per ${ztpl.threshold_duration} minutes</td>
			</tr>
			<tr>
				<td style="width:250px;font-weight:bold;text-align:right;">Exclude Methods :</td>
				<td>${ztpl.exclude_methods}</td>
			</tr>
			<tr>
				<td style="width:250px;font-weight:bold;text-align:right;">Remote app server :</td>
				<td>${ztpl.remote_ip}</td>
			</tr>
			<tr>
				<td style="width:250px;font-weight:bold;text-align:right;">No of requests made :</td>
				<td>${ztpl.noofrequests}</td>
			</tr>
			<tr>
				<td style="width:250px;font-weight:bold;text-align:right;">Percentage :</td>
				<td>${ztpl.percent}</td>
			</tr>
			<tr>
				<td style="width:250px;font-weight:bold;text-align:right;">Increased percentage per duration :</td>
				<td><strong>${ztpl.increased_percent}</strong> increased compared to the previous one for the last <strong>${ztpl.notify_duration}</strong> minutes</td>
			</tr>
		</table>
	</body>
</html>