<%-- $Id$ --%>
<%@page import="com.zoho.accounts.SystemResource"%>
<%@page import="com.zoho.accounts.AccountsProto"%>
<%@page import="com.zoho.accounts.SystemResourceProto.Listener"%>
<%@page import="com.zoho.iam2.rest.RestProtoUtil"%>
<%@page import="com.adventnet.iam.IAMUtil"%>
<%@include file="../../static/includes.jspf" %>
<%@include file="includes.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<body>
<div class="maincontent">
    <div class="menucontent">
	<div class="topcontent"><div class="contitle">Listener</div></div> <%--No I18N--%>
	<div class="subtitle">Admin Services</div> <%--No I18N--%>
    </div>
<div class="field-bg">
<% 

String type=request.getParameter("t");
if("edit".equals(type)){
	String ListenerId = request.getParameter("listenerid");
    Listener ListenerID= CSPersistenceAPIImpl.getListener(ListenerId);
	%>
	<div class="topbtn Hcbtn">
	    <div class="addnew" onclick="loadui('/ui/admin/listener.jsp?t=view');">
		<span class="cbtnlt"></span>
		<span class="cbtnco">Back To List</span> <%--No I18N--%>
		<span class="cbtnrt"></span>
	    </div>
	</div>
              <div class="labelmain">
             <form name="editlistener" class="zform" method="post" onsubmit="return updatelistener(this)">
             <input type="hidden" name="action" value="update"/>
             <input type="hidden" name="listener" value="<%=IAMEncoder.encodeHTMLAttribute(ListenerID.getName())%>" />
             <table class="usrinfotbl" width="100%">
	         <tr>
		     <td valign="top" width="50%">
		    <table cellpadding="3">
			<tr>
			<td class="usrinfotdlt">Listener ID</td> <%--No I18N--%>
			     <td class="usrinfotdrt"><%=IAMEncoder.encodeHTML(ListenerID.getName())%></td>
			</tr>
			<tr>
			    <td class="usrinfotdlt">Statement Pattern</td> <%--No I18N--%>
			 <td> <textarea   class="txtarea" name="resourcepattern" cols="22" rows="1"> <%=IAMEncoder.encodeHTML(ListenerID.getResourceTypePattern())%></textarea></td>
	      </tr>
	      <tr>
	             <td class="usrinfotdlt">Created Time</td> <%--No I18N--%>
			    <td class="usrinfotdrt"><%=new Date(ListenerID.getCreatedTime()) %></td> <%-- NO OUTPUTENCODING --%>
			</tr>
			<tr>
			    <td class="usrinfotdlt">Last Notified Time</td> <%--No I18N--%>
			    <td class="usrinfotdrt"><%=new Date(ListenerID.getLastNotifiedTime()) %></td> <%-- NO OUTPUTENCODING --%>
			</tr>
			<tr>
			    <td class="usrinfotdlt">Last Updated Time</td> <%--No I18N--%>
			    <td class="usrinfotdrt"><%=new Date(ListenerID.getLastUpdatedTime())%></td> <%-- NO OUTPUTENCODING --%>
			</tr>
			<tr>
			<td class="usrinfotdlt">Enter Admin Password</td> <%--No I18N--%>
			<td><input type="password" class="input" name="pwd"/></td>
			</tr>
			</table>
			<div class="accbtn Hbtn">
		    <div class="savebtn" onclick="updatelistener(document.editlistener)">
			<span class="btnlt"></span>
			<span class="btnco">Update</span> <%--No I18N--%>
			<span class="btnrt"></span>
		    </div>
		    <div onclick="loadui('/ui/admin/listener.jsp?t=view')">
			<span class="btnlt"></span>
			<span class="btnco">Cancel</span> <%--No I18N--%>
			<span class="btnrt"></span>
		    </div>
		</div>
		<input type="submit" class="hidesubmit" />
		</table>
		</form>
			
			
		
	  <% } 
else if("view".equals(type)){
	  %>
	  <div class="Hcbtn topbtn">
	    <div class="addnew" onclick="loadui('/ui/admin/listener.jsp?t=add')">
		<span class="cbtnlt"></span>
		<span class="cbtnco">Add New</span> <%--No I18N--%>
		<span class="cbtnrt"></span>
	    </div>
	</div>
	  
<% 
	Listener[] listener = (Listener[])RestProtoUtil.GETS(SystemResource.getListenerURI());
	if( listener!=null && listener.length>0 ){
		%>
    <%------Disp Key------%>
    <div class="apikeyheader" id="headerdiv">
    <div id="list_listener" onclick="showlisteners('list_listener')">
    <div class="apikeytitle" style="width:25%;">ListenerID</div> <%--No I18N--%>
    <div class="apikeytitle" style="width:24%">Created Time</div> <%--No I18N--%>
    <div class="apikeytitle" style="width:25%;">Last Updated Time</div> <%--No I18N--%>
    <div class="apikeytitle" style="width:15%;">Action</div><%--No I18N--%>
</div>
</div>
<div class="content1" id="overflowdiv">
 <% for(Listener listeners : listener) {%>
			<div class="apikeycontent">
		    <div class="apikey" style="width:25%;"><%=IAMEncoder.encodeHTML(listeners.getName()) %></div>
	        <div class="apikey" style="width:24%;"><%=new Date(listeners.getCreatedTime())%></div> <%-- NO OUTPUTENCODING --%>
	        <div class="apikey" style="width:25%;"><%=new Date(listeners.getLastUpdatedTime())%></div> <%-- NO OUTPUTENCODING --%>
	        <div class="apikey apikeyaction">
	        <div class="Hbtn flrt" style="width:94%;">
            	<div class="savebtn" onclick="loadui('/ui/admin/listener.jsp?t=edit&listenerid=<%=IAMEncoder.encodeJavaScript(listeners.getName())%>')">
            <span class="cbtnlt"></span>
			<span class="cbtnco" style="width:35px;">Edit</span> <%--No I18N--%>
			<span class="cbtnrt"></span>
		    </div>
		     <div onclick="deletelistener('<%=IAMEncoder.encodeJavaScript(listeners.getName())%>')">
			<span class="cbtnlt"></span>
			<span class="cbtnco">Delete</span> <%--No I18N--%>
			<span class="cbtnrt"></span>
		    </div>
	    </div>
	    </div>
	    <div class="clrboth">
	    </div>
	    </div>
	    
	<%   }
 out.println("</div>");
              }else{ %>
	<div class="emptyobjmain">
	    <dl class="emptyobjdl"><dd><p align="center" class="emptyobjdet">No listeners added</p></dd></dl> <%--No I18N--%>
	</div>
	
<% }
     } 
        else if("add".equals(type)){%>
        <%-------Add listener------%>
        <form name="addlistener" method="post" class="zform"  onsubmit="return submitlistener(this)">
        <input type="hidden" name="action" value="new"/>
	    <div class="labelmain">
		<div class="labelkey">Listener ID :</div>
		<div class="labelvalue"><input type="text" name="listener" class="input"/></div>
		<div class="labelkey">Statement Pattern :</div>
		<div><textarea class="txtarea" name="resourcepattern" cols="22" rows="1"></textarea></div>
		<div class="labelkey">Admin Password :</div>
		<div class="labelvalue"><input type="password" name="pwd" class="input"/></div>
		<div class="accbtn Hbtn">
		    <div class="savebtn" onclick="submitlistener(document.addlistener)">
			<span class="btnlt"></span>
			<span class="btnco">Add</span>
			<span class="btnrt"></span>
		    </div>
		    <div onclick="loadui('/ui/admin/listener.jsp?t=view')">
			<span class="btnlt"></span>
			<span class="btnco">Cancel</span>
			<span class="btnrt"></span>
		    </div>
		</div>
		<input type="submit" class="hidesubmit" />
		 </div>
        </form>
    

<% }	%>     

</div>
</div>
</div>
</body>
</html>