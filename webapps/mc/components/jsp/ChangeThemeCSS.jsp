<%-- $Id$ --%>
<%@page import="com.adventnet.client.themes.web.ThemesAPI"%>
<%@page import="com.adventnet.client.util.web.WebClientUtil"%>
<%@page import="com.adventnet.persistence.*"%>
<%@ page import="com.adventnet.i18n.I18N"%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@ taglib uri="http://www.adventnet.com/webclient/clientframework" prefix="client"%>
<%@ page isELIgnored="false" %>
<% 

DataObject dataObject = ThemesAPI.getThemesForContext(); 
String currentTheme = (String)ThemesAPI.getThemeForAccount(WebClientUtil.getAccountId()).get("THEMENAME"); 
String themeDir = ThemesAPI.getThemeDirForRequest(request);%>

<script>function changeTheme(){
document.theme.submit();
}
function applyTheme(themeName){
var length = document.theme.selectedTheme.length;
for(var i =0; i < length; i++){
var value = document.theme.selectedTheme[i].value;
if(value == themeName){
document.theme.selectedTheme[i].checked = true;
break;
}
}
document.theme.submit();
}</script>
<link href="<%out.print(themeDir);//NO OUTPUTENCODING%>/styles/style.css" rel="stylesheet" type="text/css"><%--NO OUTPUTENCODING --%>
<table width="100%" cellpadding="0" cellspacing="0" class="productLogo" height="30"> 
  <tr> 
    <td class="titleText"><%=IAMEncoder.encodeHTML(I18N.getMsg("Personalize - Themes"))%></td>
  </tr> 
</table> 
<form name="theme" action="ChangeThemeAction.ma" method="post"> 
  <table width="100%" cellspacing="1" cellpadding="5" border = "0" class = "tborder" align="center"> 
    <tr> 
      <% java.util.Iterator iterator = dataObject.getRows("Theme"); 
	  	while(iterator.hasNext())
		{ 
			Row row = (Row) iterator.next(); 
			String themeName = (String) row.get("THEMENAME"); 
			String imageClassName = (String) 
			row.get("ICON"); 
	 if(themeName.equals(currentTheme)){%> 
      <td align="center" class="bodyText"><span class='<%=IAMEncoder.encodeHTMLAttribute(imageClassName)%>'onClick="return applyTheme('<%=IAMEncoder.encodeJavaScript(themeName)%>')">&nbsp;</span><br><br><br><br><br><br><br><br>
        <input type="radio" name="selectedTheme" value="<%=IAMEncoder.encodeHTMLAttribute(themeName)%>" checked onClick="return changeTheme()"> 
&nbsp;<%out.print(IAMEncoder.encodeHTML(I18N.getMsg(themeName)));//NO OUTPUTENCODING%></td> <%--NO OUTPUTENCODING --%>
      <% } else {%> 
      <td align="center" class="bodyText" ><span class='<%=IAMEncoder.encodeHTMLAttribute(imageClassName)%>' onClick="return applyTheme('<%=IAMEncoder.encodeJavaScript(themeName)%>')">&nbsp;</span><br><br><br><br><br><br><br><br>
        <input type="radio" name="selectedTheme" value="<%=IAMEncoder.encodeHTMLAttribute(themeName)%>" onClick="return changeTheme()"> 
&nbsp;<%=IAMEncoder.encodeHTML(I18N.getMsg(themeName))%></td> 
      <% } }%> 
      </td> 
    </tr> 
  </table> 
</form> 

