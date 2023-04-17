<%-- $Id$ --%>
<%@page import="com.zoho.accounts.AppResourceProto.App.MailTypes"%>
<%@page import="com.zoho.resource.URI"%>
<%@page import="com.zoho.accounts.AppResourceProto.App.MailTypes.MailSender"%>
<%@page import="com.zoho.accounts.AccountsConstants"%>
<%@page import="com.zoho.accounts.AppResource"%>
<%@page import="com.zoho.accounts.AppResourceProto.App.MailDetails"%>
<%@ include file="includes.jsp" %>
<div class="maincontent">
    <div class="menucontent">
	<div class="topcontent"><div class="contitle" id="restoretitle">Transmail Details</div></div>
	<div class="subtitle">Admin Services</div>
    </div>
    <%
    String action = request.getParameter("t");
    action = action == null ? "view" : action;
    String type = request.getParameter("type");
    type = type == null ? "td" : type;
    %>
    <div class="field-bg">

        <div class="tdlink">
            <a href="javascript:;" id="auolink" onclick="loadui('/ui/admin/transMail.jsp?t=view&type=td')" class="<%= type.equals("td") ? "disablerslink" : "activerslink" %>">Transmail Details</a> /
            <a href="javascript:;" id="auolink" onclick="loadui('/ui/admin/transMail.jsp?t=view&type=md')" class="<%= type.equals("md") ? "disablerslink" : "activerslink" %>">MailDetails</a> /
            <a href="javascript:;" id="auolink" onclick="loadui('/ui/admin/transMail.jsp?t=view&type=mt')" class="<%= type.equals("mt") ? "disablerslink" : "activerslink" %>">MailTypes</a>
        </div>
        <% if(type.equals("td")) {
        if(action.equals("view") ) { %>
        <!-- Transmil view Starts here -->
    <div id="tdetailsview">
    
    <div class="Hcbtn topbtn">
                  <div class="addnew" onclick="loadui('/ui/admin/transMail.jsp?t=add&type=td')">
                        <span class="cbtnlt"></span> <span class="cbtnco">Add New</span> <span class="cbtnrt"></span><%--No I18N--%>
                  </div>
            </div>

            <div class="apikeyheader" id="headerdiv">
                  <div class="apikeytitle" style="width: 29%;">Mail Type</div>                  <%--No I18N--%>
                  <div class="apikeytitle" style="width: 29%;">Mail Sender</div>                  <%--No I18N--%>
                  <div class="apikeytitle" style="width: 29%;">Mail From</div>
                  <div class="apikeytitle" style="width: 10%;">Action</div>              <%--No I18N--%>
            </div>
            <div class="content1" id="overflowdiv">
            <%
            MailSender[] mds = AppResource.getMailSenderURI(AccountsConstants.ACCOUNTS_SERVICE_NAME, URI.JOIN).GETS();
            if( mds != null) {
          		for (MailSender md : mds) {
           %>
                         <div class="apikeycontent">
                        <div class="sysname" style="width: 25%;"><%=IAMEncoder.encodeHTML(md.getParent().getMailTypeName())%></div>
                        <div class="apikey" style="width: 25%;"><%=IAMEncoder.encodeHTML(md.getConnectorName())%></div>
                        <div class="apikey" style="width: 29%;"><%=IAMEncoder.encodeHTML(md.getMailSender())%></div>
                        <div class="apikey apikeyaction">
                              <div class="Hbtn">
                                    <div class="savebtn"  onclick="loadui('/ui/admin/transMail.jsp?t=edit&&type=td&mType=<%=IAMEncoder.encodeJavaScript(md.getParent().getMailTypeName())%>')" >
                                          <span class="cbtnlt"></span> <span class="cbtnco" style="width: 35px;">Edit</span> <span class="cbtnrt"></span><%--No I18N--%>
                                    </div>
                        </div>
                        </div>
                        <div class="clrboth"></div>
                  </div>
                        
                        <%
          		}    
            } else { %>
          	  <div class="apikey"> No Data's exist</div> 
            <%}
                  
          %>
            </div>
    
    </div>    
    
    <% } else if(action.equals("add") ) { 
    	 MailDetails[] mds = AppResource.getMailDetailsURI(AccountsConstants.ACCOUNTS_SERVICE_NAME).GETS();
    	 MailTypes[] mts = AppResource.getMailTypesURI(AccountsConstants.ACCOUNTS_SERVICE_NAME).GETS();
    	 MailSender[] mss = AppResource.getMailSenderURI(AccountsConstants.ACCOUNTS_SERVICE_NAME, URI.JOIN).GETS();
    	 List<String> existingsender = new ArrayList<String>();
    	 if(mss != null) {
    		 for(MailSender m: mss) {
    			 existingsender.add(m.getParent().getMailTypeName());
    		 }
    	 }
    	 boolean allDataAdded = false;
    	 if(mts != null && mts.length == existingsender.size()){
    		 allDataAdded = true;
    	 }
    	 if(mds != null && mts != null)  {
    		 if(!allDataAdded) {
    			
    %>
    <div id="tdetailsadd">
    
		<form name="addNewTd" id="addNewTd" class="zform" onsubmit="return postForTransMail(this, '/admin/transmail/mailsender/add', ['mtype', 'msender', 'email', 'pwd'], '/ui/admin/transMail.jsp?t=view&type=td');" method="post">
		    <div class="labelmain">
	                <div class="labelkey">Mail Type :</div>
			<div class="labelvalue">
			
				<select name="mtype" style="width: 200px;">
				<%for(MailTypes mt : mts) {
					if(!existingsender.contains(mt.getMailTypeName())) {
					%>
					<option value="<%=IAMEncoder.encodeHTMLAttribute(mt.getMailTypeName()) %>" selected><%=IAMEncoder.encodeHTML(mt.getMailTypeName())%></option>
					<%}
					}%>
				</select>
			
			</div>
			<div class="labelkey">Mail Sender :</div>
			<div class="labelvalue">
			<% String dfrom = ""; 
			int i =0;%>
			<select name="msender" style="width: 200px;" onchange="updateSender(this)">
				<%for(MailDetails md : mds) { i++;
				if(i ==1) {
					dfrom = md.getDefaultMailFrom();
				}
				%>
					<option value="<%=IAMEncoder.encodeHTMLAttribute(md.getConnectorName())%>" send="<%=IAMEncoder.encodeHTMLAttribute( md.getDefaultMailFrom())%>"  <%=(i ==1 ? "selected" : "")%>><%=IAMEncoder.encodeHTML(md.getConnectorName())%></option>
					<%}%>
				</select>
			</div>
			<div class="labelkey">Mail From :</div>
			<div class="labelvalue"><input type="text" id="senderemail" name="email" class="input" value="<%=IAMEncoder.encodeHTML(dfrom)%>"/></div>
	                <div class="labelkey">Enter Admin password :</div>
	                <div class="labelvalue"><input type="password" class="input" name="pwd"/></div>
			<div class="accbtn Hbtn">
			    <div class="savebtn" onclick="postForTransMail(document.addNewTd, '/admin/transmail/mailsender/add', ['mtype', 'msender', 'email', 'pwd'], '/ui/admin/transMail.jsp?t=view&type=td');">
				<span class="btnlt"></span>
				<span class="btnco">Add Details</span>
				<span class="btnrt"></span>
			    </div>
			    <div onclick="loadui('/ui/admin/transMail.jsp?t=view&type=td');">
				<span class="btnlt"></span>
				<span class="btnco">Cancel</span>
				<span class="btnrt"></span>
			    </div>
			</div>
			<input type="submit" class="hidesubmit" />
		    </div>
		</form>
	</div>
	<%  } else {
		%> 
		All Mail types added.
	<%
	}
    	 }  else {
	%> 
		Either MailDetails or MailTypes not present
	<%
		}  } else if(action.equals("edit") ) { 
	    	 MailDetails[] mds = AppResource.getMailDetailsURI(AccountsConstants.ACCOUNTS_SERVICE_NAME).GETS();
	    	 String mType = request.getParameter("mType");
	    	 MailSender mss = AppResource.getMailSenderURI(AccountsConstants.ACCOUNTS_SERVICE_NAME, mType).GET();
	    			
	    %>
	    <div id="tdetailsadd">
	    
			<form name="addNewTd" id="addNewTd" class="zform" onsubmit="return postForTransMail(this, '/admin/transmail/mailsender/update', ['mtype', 'msender', 'email', 'pwd'], '/ui/admin/transMail.jsp?t=view&type=td');" method="post">
			    <div class="labelmain">
		                <div class="labelkey">Mail Type :</div>
				<div class="labelvalue">
					<input type="text" name="mtype" class="input" value="<%=IAMEncoder.encodeHTML(mss.getParent().getMailTypeName())%>" disabled="disabled"/>
				</div>
				<div class="labelkey">Mail Sender :</div>
				<div class="labelvalue">
				
				<select name="msender" style="width: 200px;" onchange="updateSender(this)">
					<%for(MailDetails md : mds) { %>
						<option value="<%=IAMEncoder.encodeHTMLAttribute(md.getConnectorName()) %>" <%=md.getConnectorName().equals(mss.getConnectorName()) ? "selected" : "" %> send="<%=IAMEncoder.encodeHTMLAttribute( md.getDefaultMailFrom())%>" ><%=IAMEncoder.encodeHTML(md.getConnectorName())%></option>
						<%}%>
					</select>
				</div>
				<div class="labelkey">Mail From :</div>
				<div class="labelvalue"><input type="text" name="email" id="senderemail" class="input" value="<%=IAMEncoder.encodeHTMLAttribute(mss.getMailSender())%>"/></div>
		                <div class="labelkey">Enter Admin password :</div>
		                <div class="labelvalue"><input type="password" class="input" name="pwd"/></div>
				<div class="accbtn Hbtn">
				    <div class="savebtn" onclick="postForTransMail(document.addNewTd, '/admin/transmail/mailsender/update', ['mtype', 'msender', 'email', 'pwd'], '/ui/admin/transMail.jsp?t=view&type=td');">
					<span class="btnlt"></span>
					<span class="btnco">Add Details</span>
					<span class="btnrt"></span>
				    </div>
				    <div onclick="loadui('/ui/admin/transMail.jsp?t=view&type=td');">
					<span class="btnlt"></span>
					<span class="btnco">Cancel</span>
					<span class="btnrt"></span>
				    </div>
				</div>
				<input type="submit" class="hidesubmit" />
			    </div>
			</form>
		</div>
		<%
		}  
        } else if(type.equals("md")) {
        if(action.equals("view") ) { %>
        <!-- Transmil view Starts here -->
    <div id="tdetailsview">
    
    <div class="Hcbtn topbtn">
                  <div class="addnew" onclick="loadui('/ui/admin/transMail.jsp?t=add&type=md')">
                        <span class="cbtnlt"></span> <span class="cbtnco">Add New</span> <span class="cbtnrt"></span><%--No I18N--%>
                  </div>
            </div>

            <div class="apikeyheader" id="headerdiv">
                  <div class="apikeytitle" style="width: 13%;">Connector Name</div>                  <%--No I18N--%>
                  <div class="apikeytitle" style="width: 19%;">Connector ID</div>                  <%--No I18N--%>
                  <div class="apikeytitle" style="width: 19%;">Connector Key</div>                  <%--No I18N--%>
                  <div class="apikeytitle" style="width: 17%;">Default From</div>
                  <div class="apikeytitle" style="width: 14%;">Sender Type</div>                  <%--No I18N--%>
                  <div class="apikeytitle" style="width: 10%;">Action</div>              <%--No I18N--%>
            </div>
            <div class="content1" id="overflowdiv">
            <%
            MailDetails[] mds = AppResource.getMailDetailsURI(AccountsConstants.ACCOUNTS_SERVICE_NAME).GETS();
            if( mds != null) {
          		for (MailDetails md : mds) {
           %>
                         <div class="apikeycontent">
                        <div class="sysname" style="width: 13%;"><%=IAMEncoder.encodeHTML(md.getConnectorName())%></div>
                        <div class="apikey" style="width: 19%;"><%=IAMEncoder.encodeHTML(md.getConnectorId())%></div>
                        <div class="apikey" style="width: 19%;"><%=IAMEncoder.encodeHTML(md.getConnectorKey())%></div>
                        <div class="apikey" style="width: 17%;"><%=IAMEncoder.encodeHTML(md.getDefaultMailFrom())%></div>
                        <div class="apikey" style="width: 8%;"><%=md.getMailSenderType()%></div> <%--No OUTPUTENCODING--%>
                        <div class="apikey apikeyaction">
                              <div class="Hbtn">
                                    <div class="savebtn"  onclick="loadui('/ui/admin/transMail.jsp?t=edit&&type=md&mType=<%=IAMEncoder.encodeJavaScript(md.getConnectorName())%>')" >
                                          <span class="cbtnlt"></span> <span class="cbtnco" style="width: 35px;">Edit</span> <span class="cbtnrt"></span><%--No I18N--%>
                                    </div>
                                 <div onclick="paramPostForTransMail('/admin/transmail/maildetails/delete', 'cName=<%=IAMEncoder.encodeJavaScript(md.getConnectorName()) %>', deleteTransMailDetail)">
                                                <span class="cbtnlt"></span> <span class="cbtnco">Delete</span>      <%--No I18N--%>
                                                <span class="cbtnrt"></span>
                                          </div>
                                 </div>
                        </div>
                        <div class="clrboth"></div>
                  </div>
                        
                        <%
          		}    
            } else { %>
          	  <div class="apikey"> No Data's exist</div> 
            <%}
                  
          %>
            </div>
    
    </div>    
    
    <% } else if(action.equals("add") ) { %>
    <div id="tdetailsadd">
    
		<form name="addNewTd" id="addNewTd" class="zform" onsubmit="return postForTransMail(this, '/admin/transmail/maildetails/add', ['cName', 'cId', 'cKey', 'demail', 'msType', 'pwd'], '/ui/admin/transMail.jsp?t=view&type=md');" method="post">
		    <div class="labelmain">
	                <div class="labelkey">Enter Connector Name:</div>
			<div class="labelvalue"><input type="text" name="cName" class="input"/></div>
			<div class="labelkey">Enter Connector Id :</div>
			<div class="labelvalue"><input type="text" name="cId" class="input"/></div>
			<div class="labelkey">Enter Connector Key :</div>
			<div class="labelvalue"><input type="text" name="cKey" class="input"/></div>
			<div class="labelkey">Enter Default MailFrom :</div>
			<div class="labelvalue"><input type="text" name="demail" class="input"/></div>
			<div class="labelkey">Enter Mail SenderType :</div>
			<div class="labelvalue">
			<select name="msType" style="width: 200px;">
					<option value="1" selected>Trans Mail</option>
				</select>
			</div>
	                <div class="labelkey">Enter Admin password :</div>
	                <div class="labelvalue"><input type="password" class="input" name="pwd"/></div>
			<div class="accbtn Hbtn">
			    <div class="savebtn" onclick="postForTransMail(document.addNewTd, '/admin/transmail/maildetails/add', ['cName', 'cId', 'cKey', 'demail', 'msType', 'pwd'], '/ui/admin/transMail.jsp?t=view&type=md');">
				<span class="btnlt"></span>
				<span class="btnco">Add Details</span>
				<span class="btnrt"></span>
			    </div>
			    <div onclick="loadui('/ui/admin/transMail.jsp?t=view&type=md')">
				<span class="btnlt"></span>
				<span class="btnco">Cancel</span>
				<span class="btnrt"></span>
			    </div>
			</div>
			<input type="submit" class="hidesubmit" />
		    </div>
		</form>
	</div>
	<% } else if(action.equals("edit") ) {

		String mType = request.getParameter("mType");
		 MailDetails md = AppResource.getMailDetailsURI(AccountsConstants.ACCOUNTS_SERVICE_NAME, mType).GET();
		 if(md != null)  {
		
		%>
    <div id="tdetailsedit">
    
		<form name="addNewTd" id="addNewTd" class="zform" onsubmit="return postForTransMail(this, '/admin/transmail/maildetails/update', ['cName', 'cId', 'cKey', 'demail', 'msType', 'pwd'], '/ui/admin/transMail.jsp?t=view&type=md');" method="post">
		    <div class="labelmain">
	                <div class="labelkey">Enter Connector Name:</div>
			<div class="labelvalue"><input type="text" name="cName" class="input" value="<%=IAMEncoder.encodeHTML(md.getConnectorName()) %>" disabled="disabled"/></div>
			<div class="labelkey">Enter Connector Id :</div>
			<div class="labelvalue"><input type="text" name="cId" class="input" value="<%=IAMEncoder.encodeHTML(md.getConnectorId()) %>" /></div>
			<div class="labelkey">Enter Connector Key :</div>
			<div class="labelvalue"><input type="text" name="cKey" class="input" value="<%=IAMEncoder.encodeHTML(md.getConnectorKey()) %>" /></div>
			<div class="labelkey">Enter Default MailFrom :</div>
			<div class="labelvalue"><input type="text" name="demail" class="input" value="<%=IAMEncoder.encodeHTML(md.getDefaultMailFrom()) %>" /></div>
			<div class="labelkey">Enter Mail SenderType :</div>
			<div class="labelvalue">
			
				<select name="msType" style="width: 200px;">
					<option value="1" <%=md.getMailSenderType() == 1 ? "selected" :"" %>>Trans Mail</option>
				</select>
			</div>
	                <div class="labelkey">Enter Admin password :</div>
	                <div class="labelvalue"><input type="password" class="input" name="pwd"/></div>
			<div class="accbtn Hbtn">
			    <div class="savebtn" onclick="postForTransMail(document.addNewTd, '/admin/transmail/maildetails/update', ['cName', 'cId', 'cKey', 'demail', 'msType', 'pwd'], '/ui/admin/transMail.jsp?t=view&type=md');">
				<span class="btnlt"></span>
				<span class="btnco">Update Details</span>
				<span class="btnrt"></span>
			    </div>
			    <div onclick="loadui('/ui/admin/transMail.jsp?t=view&type=md')">
				<span class="btnlt"></span>
				<span class="btnco">Cancel</span>
				<span class="btnrt"></span>
			    </div>
			</div>
			<input type="submit" class="hidesubmit" />
		    </div>
		</form>
	</div>
	<%} 
        }
        
        } else if(type.equals("mt")) {
        if(action.equals("view") ) { %>
        <!-- Transmil view Starts here -->
    <div id="tdetailsview">
    
    <div class="Hcbtn topbtn">
                  <div class="addnew" onclick="loadui('/ui/admin/transMail.jsp?t=add&type=mt')">
                        <span class="cbtnlt"></span> <span class="cbtnco">Add New</span> <span class="cbtnrt"></span><%--No I18N--%>
                  </div>
            </div>

            <div class="apikeyheader" id="headerdiv">
                  <div class="apikeytitle" style="width: 39%;">Mail Type</div>                  <%--No I18N--%>
                  <div class="apikeytitle" style="width: 39%;">Mail Type Description</div>                  <%--No I18N--%>
                  <div class="apikeytitle" style="width: 10%;">Action</div>              <%--No I18N--%>
            </div>
            <div class="content1" id="overflowdiv">
            <%
            MailTypes[] mts = AppResource.getMailTypesURI(AccountsConstants.ACCOUNTS_SERVICE_NAME).GETS();
            if( mts != null) {
          		for (MailTypes mt : mts) {
           %>
                         <div class="apikeycontent">
                        <div class="sysname" style="width: 39%;"><%=IAMEncoder.encodeHTML(mt.getMailTypeName())%></div>
                        <div class="apikey" style="width: 39%;"><%=IAMEncoder.encodeHTML(mt.getMailTypeDescription())%></div>
                        <div class="apikey apikeyaction">
                              <div class="Hbtn">
                                    <div class="savebtn"  onclick="loadui('/ui/admin/transMail.jsp?t=edit&type=mt&mType=<%=IAMEncoder.encodeJavaScript(mt.getMailTypeName())%>', '/ui/admin/transMail.jsp?t=view&type=mt')" >
                                          <span class="cbtnlt"></span> <span class="cbtnco" style="width: 35px;">Edit</span> <span class="cbtnrt"></span><%--No I18N--%>
                                    </div>
                                 <div onclick="paramPostForTransMail('/admin/transmail/mailtypes/delete', 'mailtype=<%= IAMEncoder.encodeJavaScript(mt.getMailTypeName()) %>', deleteTransMailType)">
                                                <span class="cbtnlt"></span> <span class="cbtnco">Delete</span>      <%--No I18N--%>
                                                <span class="cbtnrt"></span>
                                          </div>
                                 </div>
                        </div>
                        <div class="clrboth"></div>
                  </div>
                        
                        <%
          		}    
            } else { %>
          	  <div class="apikey"> No Data's exist</div> 
            <%}
                  
          %>
            </div>
    
    </div>    
    
    <% } else if(action.equals("add") ) { %>
    <div id="tdetailsadd">
    
		<form name="addNewTd" id="addNewTd" class="zform" onsubmit="return postForTransMail(this, '/admin/transmail/mailtypes/add', ['mailtype', 'mtdesc', 'pwd'], '/ui/admin/transMail.jsp?t=view&type=mt');" method="post">
		    <div class="labelmain">
	                <div class="labelkey">Mail Type :</div>
			<div class="labelvalue"><input type="text" name="mailtype" class="input"/></div>
			<div class="labelkey">Mail Type Desc :</div>
			<div class="labelvalue"><input type="text" name="mtdesc" class="input"/></div>
	                <div class="labelkey">Enter Admin password :</div>
	                <div class="labelvalue"><input type="password" class="input" name="pwd"/></div>
			<div class="accbtn Hbtn">
			    <div class="savebtn" onclick="postForTransMail(document.addNewTd, '/admin/transmail/mailtypes/add', ['mailtype', 'mtdesc', 'pwd'], '/ui/admin/transMail.jsp?t=view&type=mt');">
				<span class="btnlt"></span>
				<span class="btnco">Add Details</span>
				<span class="btnrt"></span>
			    </div>
			    <div onclick="loadui('/ui/admin/transMail.jsp?t=view&type=mt')">
				<span class="btnlt"></span>
				<span class="btnco">Cancel</span>
				<span class="btnrt"></span>
			    </div>
			</div>
			<input type="submit" class="hidesubmit" />
		    </div>
		</form>
	</div>
	
	<% } else if(action.equals("edit") ) { 
	
		String mtype = request.getParameter("mType");
		MailTypes mt = AppResource.getMailTypesURI(AccountsConstants.ACCOUNTS_SERVICE_NAME, mtype).GET();
		if(mt != null) {
	%>
    <div id="tdetailsadd">
    
		<form name="addNewTd" id="addNewTd" class="zform" onsubmit="return postForTransMail(this, '/admin/transmail/mailtypes/update', ['mailtype', 'mtdesc', 'pwd'], '/ui/admin/transMail.jsp?t=view&type=mt');" method="post">
		    <div class="labelmain">
	                <div class="labelkey">Mail Type :</div>
			<div class="labelvalue"><input type="text" name="mailtype" class="input" disabled="disabled" value="<%=IAMEncoder.encodeHTML(mt.getMailTypeName())%>"/></div>
			<div class="labelkey">Mail Type Desc :</div>
			<div class="labelvalue"><input type="text" name="mtdesc" class="input" value="<%=IAMEncoder.encodeHTML( mt.getMailTypeDescription())%>"/></div>
	                <div class="labelkey">Enter Admin password :</div>
	                <div class="labelvalue"><input type="password" class="input" name="pwd"/></div>
			<div class="accbtn Hbtn">
			    <div class="savebtn" onclick="postForTransMail(document.addNewTd, '/admin/transmail/mailtypes/update', ['mailtype', 'mtdesc', 'pwd'], '/ui/admin/transMail.jsp?t=view&type=mt');">
				<span class="btnlt"></span>
				<span class="btnco">Update Details</span>
				<span class="btnrt"></span>
			    </div>
			    <div onclick="loadui('/ui/admin/transMail.jsp?t=view&type=mt')">
				<span class="btnlt"></span>
				<span class="btnco">Cancel</span>
				<span class="btnrt"></span>
			    </div>
			</div>
			<input type="submit" class="hidesubmit" />
		    </div>
		</form>
	</div>
	<% } } 
        } %>
    </div>
</div>