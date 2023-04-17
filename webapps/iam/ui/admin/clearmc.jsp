<%-- $Id$ --%>
<%@page import="com.zoho.accounts.cache.MemCacheUtil"%>
<%@ include file="includes.jsp" %>
<%
String[] poolArray = {"user", "org", "ticket", "group", "serviceorg"}; // No I18n
%>
<div class="maincontent">
    <div class="menucontent">
	<div class="topcontent"><div class="contitle">Clear Memcache</div></div>
	<div class="subtitle">Admin Services</div>
    </div>

    <div class="field-bg">

	<div class="Hcbtn topbtn">
	    <div class="addnew" onclick="loadui('/ui/admin/viewcache.jsp'); initSelect2();">
		<span class="cbtnlt"></span>
		<span class="cbtnco">View Memcache</span>
		<span class="cbtnrt"></span>
	    </div>
	</div>

	<div class="viewmc">
	<div class="clearcachetitle">
	    <span class="disablememcachelink">Clear Memcache by the ZUID / ZOID / ZGID / TICKET / PHOTO_ID</span>
	</div>

	<form class="clearform" name="clear" method="post" onsubmit="return clearCache(this)">
	    <div class="labelmain">
		<div class="labelkey">Select the pool :</div>
		<div class="labelvalue">
		    <select name="pool" class="select select2Div">
			<%for (String pool : poolArray) {%><option value="<%=IAMEncoder.encodeJavaScript(pool)%>"><%=IAMEncoder.encodeHTML(pool)%></option><%}%>
		    </select>
		</div>
		<div class="labelkey">Please select the corresponding ID :</div>
		<div class="labelvalue"><input type="text" name="uniqueId" class="input"/></div>
		<div class="accbtn Hbtn">
		    <div class="savebtn" onclick="clearCache(document.clear)">
			<span class="btnlt"></span>
			<span class="btnco">Clear</span>
			<span class="btnrt"></span>
		    </div>
		    <div onclick="loadui('/ui/admin/viewcache.jsp'); initSelect2();">
			<span class="btnlt"></span>
			<span class="btnco">Cancel</span>
			<span class="btnrt"></span>
		    </div>
		</div>
		<input type="submit" class="hidesubmit" />
	    </div>
	</form>

	<div class="clearcachetitle">
	    <span class="disablememcachelink">Clear Memcache by key</span>
	</div>

	<form class="cleark" name="cleark" method="post" onsubmit="return clearCacheByKey(this)">
	    <div class="labelmain">
		<div class="labelkey">Select the pool :</div>
		<div class="labelvalue">
		    <select name="pool" class="select select2Div">
			<%for (String pool : poolArray) {%><option value="<%=IAMEncoder.encodeJavaScript(pool)%>"><%=IAMEncoder.encodeHTML(pool)%></option><%}%>
		    </select>
		</div>
		<div class="labelkey">Enter the Key :</div>
		<div class="labelvalue"><input type="text" name="key" class="input"/></div>
		<div class="accbtn Hbtn">
		    <div class="savebtn" onclick="clearCacheByKey(document.cleark)">
			<span class="btnlt"></span>
			<span class="btnco">Clear</span>
			<span class="btnrt"></span>
		    </div>
		    <div onclick="loadui('/ui/admin/viewcache.jsp'); initSelect2();">
			<span class="btnlt"></span>
			<span class="btnco">Cancel</span>
			<span class="btnrt"></span>
		    </div>
		</div>
		<input type="submit" class="hidesubmit" />
	    </div>
	</form>
	</div>
    </div>
</div>
