<%-- $Id$ --%>
<%@ include file='/components/jsp/CommonIncludes.jspf'%>
 

    <act:ShowMenu 
        menuId="<%=viewContext.getModel().getViewName()%>" 
        uniqueId='<%=request.getParameter("menuActionUniqueId")%>' 
        type="link" 
        orientation="vertical"/>    

