<%-- $Id$ --%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@page import="com.zoho.accounts.AppResource"%>
<%@page import="com.zoho.accounts.AppResourceProto.App.Configuration"%>
<%@page import="com.zoho.accounts.AppResourceProto.App"%>

<%@ include file="../../static/includes.jspf"%>
<%@ include file="includes.jsp"%>
<div class="maincontent">
	<div class="menucontent">
		<div class="topcontent">
			<div class="contitle">Screen</div>
		</div>
		<div class="subtitle">Admin Services</div>
	</div>

	<div class="field-bg">
		<form name="upload" id="upload" action="/admin/i18n/update" method="post" target="uploadaction" enctype="multipart/form-data" onsubmit="return validate(this)">
		<input type="hidden" name ="iamcsrcoo" value="<%=IAMEncoder.encodeHTMLAttribute(IAMUtil.getCookie(request, "iamcsr"))%>" />
			<div class="labelmain" style="overflow: hidden">
				<div class="labelkey">App Name :</div>
				<div class="labelvalue">
					<select name="appname" id="appname" class="select select2Div">
					<option value="select">----select----</option>
					<%
						for(Service s: ss){
				%>
				<option value="<%=IAMEncoder.encodeHTMLAttribute(s.getServiceName())%>"><%=IAMEncoder.encodeHTML(s.getServiceName())%></option>
				<%
					}
				%>
				</select>
				</div>
				<div class="labelkey" style="padding-top: 12px">I18NProperties :</div>
				<div class="labelvalue">
					<input name="i18nfile" type="file" id="file" class="input" multiple=""> <div class="labelvalue">Note: Please give valid file name.Ex:- MessageResources_en.properties.</div> 
				</div> 
				<div class="accbtn Hbtn">
				<div class="savebtn" onclick="validate(document.upload)">
				<span class="btnlt"></span>
					<span class="btnco">Update Template</span>
					<span class="btnrt"></span>
				</div>
				</div>
			</div>
		</form>
	</div>
</div>
<iframe name="uploadaction" id="uploadaction" class="hide" frameborder="0" height="0%" width="0%"></iframe>