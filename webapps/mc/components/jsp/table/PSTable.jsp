<%-- $Id$ --%>
<%@ include file='../CommonIncludes.jspf'%>
<%@ page import = "com.adventnet.ds.query.*,java.util.*, com.adventnet.persistence.*,com.adventnet.client.util.LookUpUtil,com.adventnet.customview.*,com.adventnet.ds.query.util.*, com.adventnet.client.components.table.web.*"%>
<%@ page import="com.adventnet.i18n.I18N"%>
	
  	<DIV id="<%out.print(referenceId);//NO OUTPUTENCODING%>_Border" class="divBorder"><%--NO OUTPUTENCODING --%>
			<%@ include file='InitTableVariables.jspf'%>
			<%@ include file='../rangenavigator/NavigateByPageX.jspf'%>
			<br>
			<components:row viewContext="<%=viewContext%>" javaScriptRow = "true">
				<%
                                Long psConfig = (Long) viewModel.getTableViewConfigRow().get("PSCONFIGLIST"); 
				HashMap criteriaMap = new HashMap();
				criteriaMap.put("CONFIGNAME", psConfig);
				DataObject psdo = (DataObject) viewContext.getModel().getCompiledData("PSDO"+uniqueId);
				if(psdo == null){
					Row customViewRow = new Row(CUSTOMVIEWCONFIGURATION.TABLE);
					customViewRow.set(CUSTOMVIEWCONFIGURATION.CVNAME,"PSCV");

					DataObject customViewDO = LookUpUtil.getPersistence().get(CUSTOMVIEWCONFIGURATION.TABLE, customViewRow);
					long queryID = ((Long)customViewDO.getFirstValue(CUSTOMVIEWCONFIGURATION.TABLE, CUSTOMVIEWCONFIGURATION.QUERYID)).longValue();

					SelectQuery query = QueryUtil.getSelectQuery(queryID);
					Criteria crit = new Criteria(new Column("ACPSConfiguration","CONFIGNAME"), psConfig, QueryConstants.EQUAL);
					query.setCriteria(crit);
					psdo = LookUpUtil.getPersistence().get(query);
					viewContext.getModel().addCompiledData("PSDO"+uniqueId,  psdo);
				}
				Iterator iterator = psdo.getRows("ACPSConfiguration");
				int previousRowIndex = -1;
				%>
   		<table id="<%out.print(uniqueId);//NO OUTPUTENCODING%>_TABLE" class="propertySheet" cellspacing=1 align=center border='0'><%--NO OUTPUTENCODING --%>
				<%
				while(iterator.hasNext()){
					Row requiredRow = (Row) iterator.next();
					int currentRowIndex = ((Integer) requiredRow.get("ROWINDEX")).intValue();
					int currentColIndex = ((Integer) requiredRow.get("COLUMNINDEX")).intValue();
					if(previousRowIndex != currentRowIndex){
						if(currentRowIndex > 0){
						%>
							</tr>
						<%
						}
						previousRowIndex = currentRowIndex;
						%>
						<tr>
					<%
					}
					String dataType = (String) requiredRow.get("DATATYPE");
					String dataValue = (String) requiredRow.get("DATAVALUE");
					String width = "";
					if(requiredRow.get("WIDTH") != null){
						width = "width='" + (Integer) requiredRow.get("WIDTH") + "%'";
					}
					String height = "";
					if(requiredRow.get("HEIGHT") != null){
						height = "height='" + (Integer) requiredRow.get("HEIGHT") + "%'";
					}
					%>
					
					<td colspan='<%out.print(Integer.parseInt(IAMEncoder.encodeHTMLAttribute(String.valueOf(requiredRow.get("COLSPAN")))));//NO OUTPUTENCODING%>' rowspan='<%out.print(Integer.parseInt(IAMEncoder.encodeHTMLAttribute(String.valueOf(requiredRow.get("ROWSPAN")))));//NO OUTPUTENCODING%>' valign="top" class="<%out.print(IAMEncoder.encodeHTMLAttribute(dataType));//NO OUTPUTENCODING%>Class <%out.print(transformerContext.getColumnCSS(true));//NO OUTPUTENCODING%>" <%out.print(width);//NO OUTPUTENCODING%> <%out.print(height);//NO OUTPUTENCODING%>><%--NO OUTPUTENCODING --%>
						<%
						if("Label".equals(dataType) || "Text".equals(dataType) || "FieldName".equals(dataType)){
						%>
							<%=IAMEncoder.encodeHTML(I18N.getMsg(requiredRow.get("DATAVALUE").toString()))%>
						<%
						}
						else if("FieldValue".equals(dataType)){
                                                                    tableIter.setCurrentColumn(dataValue);
								%>
								<components:cell viewContext="<%=viewContext%>">
    							<%
    							props = transformerContext.getRenderedAttributes();
							    %>
							    <%@ include file='CellRenderer.jspf'%> 
								</components:cell>
								<%
						}
						%>
					</td>
					<%
				}
				%>
			</table>
			<br>
			</components:row> 
		</DIV>
		<%@ include file = "DisplayNoRowsMessage.jspf" %>

