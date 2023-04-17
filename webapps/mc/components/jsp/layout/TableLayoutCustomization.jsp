<%-- $Id$ --%><head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Table Layout Customization</title>
<script src='<%out.print(request.getContextPath());//NO OUTPUTENCODING%>/components/javascript/DragAndDrop.js'></script><%--NO OUTPUTENCODING --%>
<script src='<%out.print(request.getContextPath());//NO OUTPUTENCODING%>/components/javascript/Personalization.js'></script><%--NO OUTPUTENCODING --%>
<script src='<%out.print(request.getContextPath());//NO OUTPUTENCODING%>/components/javascript/TableLayout.js'></script><%--NO OUTPUTENCODING --%>
<%@ page import = "com.adventnet.client.components.util.web.*, com.adventnet.client.util.web.*,java.util.*, com.adventnet.persistence.*, com.adventnet.client.view.*"%>
<%@ page import = "com.adventnet.client.view.web.WebViewAPI" %>
<%@ include file='/components/jsp/CommonIncludes.jspf'%>
</head>
<%
boolean isNewView = false;
String custView = request.getParameter("VIEWNAME");
if(custView == null){
	isNewView = true;
	custView = PersonalizationUtil.getFromReqOrFeatureParams(viewContext,"VIEWNAME");
}
%>
<%@ include file='viewTemplates.html'%>
<%@ include file='../table/InitTableVariables.jspf'%>
<%@ include file='/framework/jsp/StatusMsg.jspf'%>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="layoutArea">
  <tr> 
    <td valign="top" nowrap> 
      <%@ include file='HowToPers.jspf'%>
      <table class="editAreaBorder" width="100%" align="center">
        <tr> 
          <td class="editAreaMenuBar">Table Layout - <%=IAMEncoder.encodeHTML(custView)%> Page</td>
          <td align="right" class="editAreaMenuBar"> <span id='undoDisable'>
            <input type='button' class='undoDisabled'/>
            Undo</span><a href="javascript:undo()" id='undoEnable'>
            <input type='button' class='undo'>
            Undo</a> <span style="font-weight:normal">|</span> <span id='redoDisable'>
            <input type='button' class='redoDisabled'>
            Redo</span><a id='redoEnable' href="javascript:redo()">
            <input type='button' class='redo'>
            Redo</a>&nbsp;
          </td>
        </tr>
        <tr> 
          <td colspan="2" class="editAreaBg" id='layoutDAC'>&nbsp;</td>
        </tr>
        <tr> 
          <td class="editAreaMenuBar">&nbsp;</td>
          <td align="right" class="editAreaMenuBar"> 
            <form name="TableLayoutForm">
              <select name="TL_VIEWNAMES" class="hide" multiple>
              </select>
              <select name="TL_TITLE" class="hide" multiple>
              </select>
              <select name="TL_DESCRIPTION" class="hide" multiple>
              </select>
              <select name="TL_ROWINDEX" class="hide" multiple>
              </select>
              <select name="TL_COLUMNINDEX" class="hide" multiple>
              </select>
              <select name="TL_COLSPAN" class="hide" multiple>
              </select>
              <select name="TL_ROWSPAN" class="hide" multiple>
              </select>
              <input type="hidden" name="VIEWNAME" value='<%=IAMEncoder.encodeHTMLAttribute(custView)%>'/>
              <input type = "hidden" name = "UNIQUEID"  value = '<%=IAMEncoder.encodeHTMLAttribute(request.getParameter("UNIQUEID"))%>'>
              <input type = "hidden" name = "ISNEWVIEW"  value = '<%out.print(isNewView);//NO OUTPUTENCODING%>'><%--NO OUTPUTENCODING --%>
              <input type = "hidden" name = "TITLE"  value = ''>
            </form>
            <script>
							var currentViewNames = new Array();
							var rIndex = 0;
							var cIndex = 0;
							var tableLayoutCustomization = new Object();
							tableLayoutCustomization["getTableCellConstruct"] = getCellConstructForView;
							initMethodContainer("tableLayoutCustomization");
						</script> <components:row> <components:column> 
            <script>
									<%Object viewnameno = transformerContext.getAssociatedPropertyValue("ChildViewName");%><%--NO OUTPUTENCODING --%>
									currentViewNames[<%out.print(transformerContext.getRowIndex());//NO OUTPUTENCODING%>] = '<%out.print(IAMEncoder.encodeJavaScript((String)WebViewAPI.getViewName(viewnameno)));//NO OUTPUTENCODING%>';<%--NO OUTPUTENCODING --%>
									addViewObject(new Array('<%out.print(IAMEncoder.encodeJavaScript((String)WebViewAPI.getViewName(viewnameno)));//NO OUTPUTENCODING%>', '<%out.print(IAMEncoder.encodeJavaScript((String)transformerContext.getAssociatedPropertyValue("Title")));//NO OUTPUTENCODING%>', '<%out.print(IAMEncoder.encodeJavaScript((String)transformerContext.getAssociatedPropertyValue("Description")));//NO OUTPUTENCODING%>', <%out.print(transformerContext.getAssociatedPropertyValue("RowIndex"));//NO OUTPUTENCODING%>, <%out.print(transformerContext.getAssociatedPropertyValue("ColumnIndex"));//NO OUTPUTENCODING%>, <%out.print(transformerContext.getAssociatedPropertyValue("ColumnSpan"));//NO OUTPUTENCODING%>, <%out.print(transformerContext.getAssociatedPropertyValue("RowSpan"));//NO OUTPUTENCODING%>, -1, -1));<%--NO OUTPUTENCODING --%>
									var temp1 = <%out.print(transformerContext.getAssociatedPropertyValue("RowIndex"));//NO OUTPUTENCODING%><%--NO OUTPUTENCODING --%>
									var temp2 = <%out.print(transformerContext.getAssociatedPropertyValue("ColumnIndex"));//NO OUTPUTENCODING%><%--NO OUTPUTENCODING --%>
									if(temp1 > rIndex){
										rIndex = temp1;
									}
									if(temp2 > cIndex){
										cIndex = temp2;
									}
								</script>
            </components:column> </components:row> <script>
							init(currentViewNames,cIndex+1,rIndex+1);
						</script> </td>
        </tr>
      </table>
      <table align='center'>
        <tr>
          <td align='center'><br> 
            <%@ include file='RestoreFrm.jspf'%>
          </td>
          <td> <br> <input name="Submit" type="button" class="btn" value="Save Changes" onClick="submitValues(document.TableLayoutForm);"> 
            <input name="Submit2" type="button" class="btn" value="Exit" onClick="window.close()"> 
          </td>
        </tr>
      </table></td>
    <%@ include file='RightBar.jspf'%>
  </tr>
</table>
<div id="movableDiv" class='hide' style="width:250px;background-color:transparent; position: absolute; cursor: default;filter:alpha(opacity=25);-moz-opacity:0.5;opacity: 0.5;"> 
  <table cellspacing='0' cellpadding='0' width='250px'>
    <tr> 
      <td class="smTopLeft">&nbsp;</td>
      <td  class="smTopBg">&nbsp;</td>
      <td class="smTopRight">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="3" class="smContent" id='movableDivContent'></td>
    </tr>
  </table>
</div>	


