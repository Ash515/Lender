<%-- $Id$ --%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ include file="../../static/includes.jspf" %>
<%@ include file="includes.jsp"%>
<div class="maincontent">
    <div class="menucontent">
	<div class="topcontent"><div class="contitle">Secret Keys</div></div>
	<div class="subtitle">Admin Services</div>
    </div>

    <div class="field-bg">
<%
    String type = request.getParameter("t");
    if("add".equals(type)) {
%>
	<%-------Add Key Starts------%>
	<form name="addsecretkey" method="post" class="zform" id="addsecretkey" onsubmit="return submitSecretKey(this)">
	    <input type="hidden" name="mode"/>
	    <div class="labelmain">
		<div class="labelkey">Key Label :</div>
		<div class="labelvalue"><input type="text" name="label" class="input"/></div>
		<div class="labelkey">Algorithm :</div>
		<div class="labelvalue">
		    <select name="algorithm" class="select">
			<option value="AES">AES</option>
			<option value="DES">DES</option>
			<option value="DESede">DESede</option>
			<option value="Blowfish">Blowfish</option>
		    </select>
		</div>
		<div class="labelkey">Key Length :</div>
		<div class="labelvalue"><input type="text" name="klength" class="input"/></div>
		<div class="labelkey">Validity Period :</div>
		<div class="labelvalue"><input type="text" name="vperiod" class="input"/></div>
		<div class="accbtn Hbtn">
		    <div class="savebtn" onclick="submitSecretKey(document.addsecretkey)">
			<span class="btnlt"></span>
			<span class="btnco">Add</span>
			<span class="btnrt"></span>
		    </div>
		    <div onclick="loadui('/ui/admin/secret_keys.jsp?t=view')">
			<span class="btnlt"></span>
			<span class="btnco">Cancel</span>
			<span class="btnrt"></span>
		    </div>
		</div>
		<input type="submit" class="hidesubmit" />
	    </div>
	</form>
	<%-------Add Key Ends------%>
	<%----EAR1
	
	<b> Secret is deprectaed. Use EAR</b>
	<br> refer <a href="https://intranet.wiki.zoho.com/zohoear/" > https://intranet.wiki.zoho.com/zohoear </a>
	
	    EAR2----%>
	
<%
    }
    else if("view".equals(type)) {
	List<Map> secret_keys= CSPersistenceAPIImpl.getAllSecretKeys();
%>
	<div class="Hcbtn topbtn">
	    <div class="addnew" onclick="loadui('/ui/admin/secret_keys.jsp?t=add')">
		<span class="cbtnlt"></span>
		<span class="cbtnco">Add New</span>
		<span class="cbtnrt"></span>
	    </div>
	</div>
	<%if(secret_keys != null && !secret_keys.isEmpty()) {%>
	<%------Disp Key------%>
	<div class="apikeyheader" id="headerdiv">
	    <div class="apikeytitle" style="width:23%;">Key Label</div>
	    <div class="apikeytitle" style="width:20%;">Key Algorithm</div>
	    <div class="apikeytitle" style="width:17%;">Key Length</div> <%--No I18N--%>
	    <div class="apikeytitle" style="width:18%;">Validity Period</div> <%--No I18N--%>
	    <div class="apikeytitle" style="width:15%;">Actions</div>
	</div>
	<div class="content1" id="overflowdiv">
	    <%for(Map map : secret_keys) {%>
	<div class="apikeycontent">
	    <div class="apikey" style="width:23%;"><%=IAMEncoder.encodeHTML((String)map.get("KEY_LABEL"))%></div>
	    <div class="apikey" style="width:20%;"><%=IAMEncoder.encodeHTML((String)map.get("KEY_ALGORITHM"))%></div>
	    <div class="apikey" style="width:17%;"><%=map.get("KEY_LENGTH")%></div> <%-- NO OUTPUTENCODING --%>
	    <div class="apikey" style="width:18%;"><%=map.get("VALIDITY_PERIOD")%></div> <%-- NO OUTPUTENCODING --%>
	    <div class="apikey apikeyaction">
		<div class="Hbtn">
		    <div class="savebtn" onclick="loadui('/ui/admin/secret_keys.jsp?t=edit&secretkey=<%=IAMEncoder.encodeJavaScript((String)map.get("KEY_LABEL"))%>')">
			<span class="cbtnlt"></span>
			<span class="cbtnco">Edit</span> <%--No I18N--%>
			<span class="cbtnrt"></span>
		    </div>
		    <div onclick="deleteSecretKey('<%=IAMEncoder.encodeJavaScript((String)map.get("KEY_LABEL"))%>')">
			<span class="cbtnlt"></span>
			<span class="cbtnco">Delete</span> <%--No I18N--%>
			<span class="cbtnrt"></span>
		    </div>
		</div>
	    </div>
	    <div class="clrboth"></div>
	</div>
<%
	    }
	out.println("</div>");
	}
	else {
%>
	<div class="emptyobjmain">
	    <dl class="emptyobjdl"><dd><p align="center" class="emptyobjdet">No SecretKey(s) added</p></dd></dl>
	</div>
<%
	}
    }
    else if("edit".equals(type)) {
	List<Map> secret_key=CSPersistenceAPIImpl.getSecretKey(request.getParameter("secretkey"));
        if(secret_key != null && ! secret_key.isEmpty()) {
	    for(Map map : secret_key) {
%>
	<form name="updatesecretkey" class="zform" method="post" onsubmit="return submitSecretKey(this)">
	    <input type="hidden" name="mode" value="E" />
	    <input type="hidden" name="olabel" value="<%=IAMEncoder.encodeHTMLAttribute((String)map.get("KEY_LABEL"))%>"/>
	    <div class="labelmain">
		<div class="labelkey">Key Label :</div>
		<div class="labelvalue"><input type="text" name="label" class="input" value="<%=IAMEncoder.encodeHTMLAttribute((String)map.get("KEY_LABEL"))%>"/></div>
		<div class="labelkey">Algorithm :</div>
		<div class="labelvalue">
		    <select name="algorithm" class="select">
			<option value="AES">AES</option>
			<option value="DES">DES</option>
			<option value="DESede">DESede</option>
			<option value="Blowfish">Blowfish</option>
		    </select>
		</div>
		<div class="labelkey">Key Length :</div>
		<div class="labelvalue"><input type="text" name="klength" class="input" value="<%=map.get("KEY_LENGTH")%>"/></div> <%-- NO OUTPUTENCODING --%>
		<div class="labelkey">Validity Period :</div>
		<div class="labelvalue"><input type="text" name="vperiod" class="input" value="<%=map.get("VALIDITY_PERIOD")%>"/></div> <%-- NO OUTPUTENCODING --%>
		<div class="labelkey">Enter Admin password :</div>
		<div class="labelvalue"><input type="password" class="input" name="pwd"/></div>
		<div class="accbtn Hbtn">
		    <div class="savebtn" onclick="submitSecretKey(document.updatesecretkey)">
			<span class="btnlt"></span>
			<span class="btnco">Update</span>
			<span class="btnrt"></span>
		    </div>
		    <div onclick="loadui('/ui/admin/secret_keys.jsp?t=view')">
			<span class="btnlt"></span>
			<span class="btnco">Cancel</span>
			<span class="btnrt"></span>
		    </div>
		</div>
		<input type="submit" class="hidesubmit" />
	    </div>
	</form>
<%
	    }
	}
    }
%>
    </div>
</div>
