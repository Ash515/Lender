<!-- $Id: $ -->
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@page import="com.adventnet.iam.internal.Util"%>
<%@taglib prefix="s" uri="/struts-tags" %>
<footer>
	<span><s:text name="IAM.FOOTER.COPYRIGHT"><s:param><%=IAMEncoder.encodeHTML(Util.getCopyRightYear())%></s:param></s:text></span> <%-- No I18N --%>
	<a href='<s:text name="IAM.LINK.SECURITY"/>' target="_blank"><s:text name="IAM.FOOTER.SECURITY"/></a>
	<a href='<s:text name="IAM.LINK.PRIVACY"/>' target="_blank"><s:text name="IAM.PRIVACY"/></a>
	<a href='<s:text name="IAM.LINK.TOS"/>' target="_blank"><s:text name="IAM.SIGNUP.TERMS.OFSERVICE"/></a>
	<a href='<s:text name="IAM.LINK.ABOUT.US"/>' target="_blank"><s:text name="IAM.ABOUT.US"/></a>
</footer>