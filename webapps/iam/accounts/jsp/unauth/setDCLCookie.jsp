<%-- $Id: $ --%>
<%@page import="com.zoho.accounts.dcl.DCLUtil"%>
<%@page import="com.adventnet.iam.IAMProxy"%>
<%@page import="com.zoho.accounts.SystemResourceProto.DCLocation"%>
<%@page import="com.zoho.accounts.handler.GeoDCHandler"%>
<%@page import="com.adventnet.iam.IAMUtil"%>
<%
	String referer = request.getHeader("Referer");//No I18N
	referer = (referer==null?request.getHeader("Origin"):referer);//No I18N
	if(referer!=null){
		DCLocation location = DCLUtil.getDCLocationFromURL(referer.substring(0, referer.indexOf('/',15)));
		if(location!=null){
			String redirectLocation = DCLUtil.deObfuscateDL(request.getParameter("dln"));//No I18N
			if(redirectLocation!=null){
				DCLUtil.setDCLCookies(response, DCLUtil.getDCLocation(redirectLocation));			
			}
		}
	}
%>