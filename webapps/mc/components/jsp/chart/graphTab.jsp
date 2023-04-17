<!--$Id$-->
<%@ include file='/components/jsp/CommonIncludes.jspf'%>

<%@ page import="com.adventnet.persistence.*" %>
<%@ page import="org.jfree.chart.plot.DefaultDrawingSupplier" %>
<%@ page import="com.adventnet.client.components.chart.util.*" %>
<%@ page import="com.adventnet.client.components.chart.web.*" %>
<%@ page import="com.adventnet.client.components.chart.table.internal.*" %>
<%@ page import="com.adventnet.clientcomponents.*" %>

<%
    String imgFile  = (String)viewContext.getViewModel();
String imMap  = (String)viewContext.getTransientState(ChartConstants.IMAGE_MAP);  
%>

<%@ page import="java.util.*, com.adventnet.client.components.chart.util.ChartUtil , com.adventnet.client.components.chart.web.ChartConstants, com.adventnet.client.components.chart.table.GraphData" %>
<%@ page import="javax.swing.table.TableModel" %>
<%@ page import="java.awt.Color" %>
<%@ page import="java.util.*" %>

<%
String url = (String)viewContext.getTransientState(ChartConstants.URL);
GraphData graphData = (GraphData)viewContext.getTransientState(ChartConstants.GRAPHDATA);
String seriesCol = (String)graphData.getAxisColumns().get(GraphData.SERIES_COLUMN);
String xCol = (String)graphData.getAxisColumns().get(GraphData.X_COLUMN);
String headLabel = ChartUtil.getPropValue(viewContext , "ALL" , ChartConstants.HEAD_LABEL );
headLabel = headLabel == null ? " " : headLabel;
TableModel tm = graphData.getData();

DataObject data = viewContext.getModel().getViewConfiguration();
Object viewName =  data.getFirstValue(CHARTVIEWCONFIG.TABLE , CHARTVIEWCONFIG.VIEWNAME);        
Row pkRow = new Row(AXISCOLUMN.TABLE);
pkRow.set(AXISCOLUMN.VIEWNAME , viewName);
pkRow.set(AXISCOLUMN.COLUMNTYPE , "COLOR");
Row tcRow = data.getRow(AXISCOLUMN.TABLE , pkRow);
int clrColIndex=-1;
if(tcRow != null)
{
    String colCol = (String)tcRow.get(AXISCOLUMN.DATACOLUMN);
    clrColIndex = FilterUtil.getFirstColumnIndex(tm ,  colCol);
}


int seriesIndex = -1;
int xColIndex = -1;
if(seriesCol != null)
{
    seriesIndex = ChartUtil.getColumn( tm , seriesCol);
}
if(xCol != null)
{
    xColIndex = ChartUtil.getColumn( tm , xCol);
}

if(url != null)
{
    if (url.indexOf("?") > -1) 
    {
        url=url+"&";
    }
    else
    {
        url=url+"?";
    }
}
%>

<table class="navigatorTable"  cellspacing="0">
  <tbody>

    <tr class"tableHeader">
      <td class"sortedTableHeader" width="100%">&nbsp;<%=IAMEncoder.encodeHTML(headLabel)%></td>
    </tr>
  </tbody>
</table>
<table class="tableComponent" cellpadding="3" cellspacing="0" width="100%">
<tr>
<td width="35%" align="leftr"  valign="top">
<%
if(imMap != null)
{
%>
<%@ include file='/components/jsp/chart/toolTip.jspf'%>
<%=IAMEncoder.encodeHTML(imMap)%>
<img src="<%out.print(request.getContextPath());//NO OUTPUTENCODING%>/test.chart?filename=<%out.print(imgFile);//NO OUTPUTENCODING%>" border="0" USEMAP="#<%out.print(imgFile);//NO OUTPUTENCODING%>" /><%--NO OUTPUTENCODING --%>
<%
}
else
{
%>
<img src="<%out.print(request.getContextPath());//NO OUTPUTENCODING%>/test.chart?filename=<%out.print(imgFile);//NO OUTPUTENCODING%>" border="0"/><%--NO OUTPUTENCODING --%>
<%
 
}
%>
<td>

 <%


if(tm != null)
{
%>
<td width="65%" align="leftr"  valign="top">
<table  class="propertySheetTable" border="0" cellpadding="3" cellspacing="0" width="100%">
<tbody>
<tr>
           
<%
  loop: for(int i=0; i<tm.getColumnCount();i++)
{
    if(i == clrColIndex)
    {
        continue loop;
    }
%>
 <td>
                      <%=IAMEncoder.encodeHTML(tm.getColumnName(i).toString())%>
 </td>
<%
 }
%>
</tr>
<%
  for(int j=0; j<tm.getRowCount(); j++)
        {
            String rowClass = j%2 == 0 ? "evenRow" : "oddRow";
%>
   <tr class="<%=rowClass%>"> 
         <%
           clLoop: for(int k=0 ;k<tm.getColumnCount(); k++)
            {
                if(k == clrColIndex)
                {
                    continue clLoop;
                }
              %>
           <td width="50%" align="left"  valign="top"  >
               </a>
<%
              
              if(tm.getValueAt(j,k) != null)
              {
                  String value = tm.getValueAt(j,k).toString();
                  if(url != null && (k == seriesIndex || k == xColIndex))
                  {
                      if(k == seriesIndex)
                      {
                          String xVal = tm.getValueAt(j,xColIndex).toString();
                          String surl = url+xCol+"="+xVal+"&"+seriesCol+"="+value;
                          %>
                              <a href="<%=IAMEncoder.encodeHTMLAttribute(surl)%>"><%=IAMEncoder.encodeHTML(value)%></a>
                                   <%
                      }
                      else if(k == xColIndex)
                      {
                          String surl = url+xCol+"="+value;
                          %>
                              <a href="<%=IAMEncoder.encodeHTMLAttribute(surl)%>"><%=IAMEncoder.encodeHTML(value)%></a>
                                   <%
                    }
                  }
                  else
                  {
                      out.println(IAMEncoder.encodeHTML(value));
                  }
              }
              else
              {
                  out.println("NULL");//NO OUTPUTENCODING
              }
              %>
              </td>
              <%
}
       %>
</tr>
<%
        }

%>

    </tbody>
    </table>
</td>
<%
}
%>
</tr>
</table>
</html>




