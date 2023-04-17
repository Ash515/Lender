<%-- $Id$ --%>
<%@ include file='../CommonIncludes.jspf'%>
<%@ page import="com.adventnet.client.components.tab.web.*" %>

<%
  TabModel model = (TabModel)viewContext.getViewModel();
  TabModel.TabIterator ite = model.getIterator();
  String ctxPath = ((HttpServletRequest)pageContext.getRequest()).getContextPath();
%>
<script>
function reloadData(tabName){
	updateState('<%out.print(uniqueId);//NO OUTPUTENCODING%>', 'selectedView', tabName.replace(' ', '_'),true);<%--NO OUTPUTENCODING --%>
	window.location.reload();
}
</script>
<DIV id="<%out.print(uniqueId);//NO OUTPUTENCODING%>_Border" class="divBorder"><%--NO OUTPUTENCODING --%>
	<table cellspacing="0" cellpadding="0" border="0" width="100%">
		<tr>
			<%
			if(model.getChildConfigList().size() > 0){
			%>
				<td>
					<ul class='listViews'>
						<%
							while(ite.next()){
								%>
								<li>
								<p>
								<a href='<%=IAMEncoder.encodeHTMLAttribute(ite.getTabAction())%>'  class='<%=IAMEncoder.encodeHTMLAttribute(ite.getCurrentClass())%>'>
								<%
								if(ite.getImage() != null){
									//String imgSrc = ite.getImage();
									String imgSrc = ThemesAPI.handlePath(ite.getImage(),request,themeDir);
                					//imgSrc = (imgSrc.charAt(0) == '/')?request.getContextPath() + imgSrc:imgSrc;
									%>
									<img src='<%out.print( imgSrc);//NO OUTPUTENCODING%>'/><%}%><br><%out.print(IAMEncoder.encodeHTMLAttribute(ite.getTitle()));//NO OUTPUTENCODING%></a></p><%--NO OUTPUTENCODING --%>
								</li>
								<%
							}
						%>
					</ul>
				</td>
				<%
				if(model.getViewType().equals("verticaltab")){
				%>
					</tr>
					<tr>
						<td>
						<span id="MC-Customization" class="hide customize">
							&nbsp;<button onClick="javascript:window.open('TabCustomization.cc?TYPE=Navigation&VIEWNAME=<%out.print(viewContext.getModel().getViewName());//NO OUTPUTENCODING%>&UNIQUEID=<%out.print(uniqueId);//NO OUTPUTENCODING%>&DefaultGroup=Reports&DisplayName=Links', null, 'height=500,width=800,scrollbars=1,resizable=1')" class="customizeButton" onMouseOver="return showBorder('<%out.print(uniqueId);//NO OUTPUTENCODING%>')" onMouseOut="return hideBorder('<%out.print(uniqueId);//NO OUTPUTENCODING%>')">Add / Remove Links</button><%--NO OUTPUTENCODING --%>
						</span>
						</td>
					<%
				}
				else {
					%>
					<td align="right" valign="top">
						<span id="MC-Customization" class="hide customize">
							&nbsp;<button class="customizeButtonPull" id="ICMTab<%out.print(uniqueId);//NO OUTPUTENCODING%>" onClick="showCustomizeLinks('TabCustomizationLinks','ICMTab<%out.print(uniqueId);//NO OUTPUTENCODING%>',event, '<%out.print(uniqueId);//NO OUTPUTENCODING%>')" onMouseOver="return showBorder('<%out.print(uniqueId);//NO OUTPUTENCODING%>')" onMouseOut="return hideBorder('<%out.print(uniqueId);//NO OUTPUTENCODING%>')">Customize &nbsp;&nbsp;</button><%--NO OUTPUTENCODING --%>
						</span>
					</td>
					<%
				}
				%>
				<%
			}
			else {
			%>
				<%
				if(model.getViewType().equals("verticaltab")){
					%>
					<tr>
						<td align="center" valign="middle">
							<span class="subTitle">[&nbsp;<%=IAMEncoder.encodeHTML((String)viewContext.getModel().getViewConfiguration().getFirstValue("ViewConfiguration", "TITLE"))%>&nbsp;]</span> <br>
							&nbsp;<button onClick="javascript:window.open('TabCustomization.cc?TYPE=Navigation&VIEWNAME=<%out.print(viewContext.getModel().getViewName());//NO OUTPUTENCODING%>&UNIQUEID=<%out.print(uniqueId);//NO OUTPUTENCODING%>&DefaultGroup=Reports&DisplayName=Links', null, 'height=500,width=800,scrollbars=1,resizable=1')" class="customizeButton" onMouseOver="return showBorder('<%out.print(uniqueId);//NO OUTPUTENCODING%>')" onMouseOut="return hideBorder('<%out.print(uniqueId);//NO OUTPUTENCODING%>')">Add / Remove Links</button><%--NO OUTPUTENCODING --%>
						</td>
					<%
				}
				else {
					%>
					<td align="center" valign="middle">
						<span class="subTitle">[&nbsp;<%out.print(IAMEncoder.encodeHTML((String)viewContext.getModel().getViewConfiguration().getFirstValue("ViewConfiguration", "TITLE")));//NO OUTPUTENCODING%>&nbsp;]</span> <br><%--NO OUTPUTENCODING --%>
						&nbsp;<button class="customizeButtonPull" id="ICMTab<%out.print(uniqueId);//NO OUTPUTENCODING%>" onClick="showCustomizeLinks('TabCustomizationLinks','ICMTab<%out.print(uniqueId);//NO OUTPUTENCODING%>',event, '<%out.print(uniqueId);//NO OUTPUTENCODING%>')" onMouseOver="return showBorder('<%out.print(uniqueId);//NO OUTPUTENCODING%>')" onMouseOut="return hideBorder('<%out.print(uniqueId);//NO OUTPUTENCODING%>')">Customize &nbsp;&nbsp;</button><%--NO OUTPUTENCODING --%>
					</td>
				<%
				}
			}
		%>
		</tr>
	</table>
</DIV>


<DIV id = 'TabCustomizationLinks<%out.print(uniqueId);//NO OUTPUTENCODING%>' class = 'customizeMenu' style='display:none;'><%--NO OUTPUTENCODING --%>
	<TABLE border = '0' cellspacing = '0' cellpadding = '0'>
		<TR onClick="openCustomizationWindow('AddTab.do?VIEWNAME=<%out.print(viewContext.getModel().getViewName());//NO OUTPUTENCODING%>', 'height=200,width=250,scrollbars=1,resizable=1,status=yes')" class = 'customizeMenuItem' onMouseOver='this.className="customizeMenuItemOver"' onMouseOut='this.className="customizeMenuItem"'><%--NO OUTPUTENCODING --%>
			<TD>Create New Tab ...</TD>
		</TR>
		<TR onClick="openCustomizationWindow('TabCustomization.cc?TYPE=Tab&VIEWNAME=<%out.print(viewContext.getModel().getViewName());//NO OUTPUTENCODING%>&DefaultGroup=Tabs', 'height=500,width=800,scrollbars=1,resizable=1')" class = 'customizeMenuItem' onMouseOver='this.className="customizeMenuItemOver"' onMouseOut='this.className="customizeMenuItem"'><%--NO OUTPUTENCODING --%>
			<TD>Modify Existing Tabs ...</TD>
		</TR>
	</TABLE>
</DIV>

