<%--
    $Id: $ // No I18N
    Document   : photo // No I18N
    Created on : Feb 14, 2011, 4:38:48 PM // No I18N
    Author     : manikandanmg // No I18N
--%>

<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@page import="com.zoho.accounts.PhotoUtil.Type"%>
<%@page import="com.zoho.accounts.PhotoUtil.PhotoRequestInfo"%>
<%@page import="com.adventnet.iam.IAMUtil"%>
<%@page import="com.zoho.resource.URI"%>
<%@page import="com.zoho.accounts.PhotoUtil"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
            String zid = request.getParameter("id");
            String type=request.getParameter("t");
            if (zid == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }
            String contextpath = request.getContextPath()+ "/photo"; // No I18N
            String callback = request.getParameter("callback");
            boolean hasCallback = callback != null && !callback.trim().isEmpty();
            callback = !hasCallback ? "parent.photoResponse" : callback; // No I18N
            PhotoRequestInfo photoRequestInfo = new PhotoRequestInfo(IAMUtil.getInt(request.getParameter("ot")), zid, PhotoUtil.Type.get(request.getParameter("t")));
            PhotoUtil.PhotoInfo photoInfo = PhotoUtil.getPhotoInfo(photoRequestInfo);
            if (photoRequestInfo.getType() == Type.SERVICEORG && photoRequestInfo.getOrgType() == -1) {
				throw new IllegalArgumentException("ServiceOrgType is must to download ServiceOrg logo"); // No I18N
			}
            boolean fromSecProxy = request.getHeader("X-Proxied-for") != null;
            if (fromSecProxy) {
                response.setHeader("Content-Encoding", "nogzip"); //No I18N
            }
%>
<html>
    <head>
        <title>Upload your Photo/Logo</title><%--No I18N--%>
        <style type="text/css">
            <%if (!fromSecProxy) {%>
            body {
                font-family: DejaVu Sans,Roboto,Helvetica,sans-serif;
                font-size: 11px;
                margin: 0; padding: 0;
            }
            <%}%>
            .cs-title {
                font-size: 15px;font-weight: bold; padding-bottom: 2px;
                border-bottom: 1px solid #c3d9ff;
            }
            .cs-field-title {
                margin-top: 5px;
                text-align: right;
                width: 40%; float: left;
                padding-bottom: 10px; font-size: 11px;
                font-weight: bold; color: #938E8E;
            }
            .cs-field-value {
                padding-bottom: 10px;
                width: 60%; float: left;
            }
            .cs-field-value .cs-hint {
                font-size: 10px; color: #777777;
            }
        </style>
        <%if (!hasCallback) {%>
        <script type="text/javascript">
            function photoResponse(_r) {
                if(_r.success) {
                    alert("Photo uploaded successfully. View Photo @ "+_r.url); <%--No I18N--%>
                    document.csPhotoForm.photo.value = "";
                } else if(_r.photo_too_large) {
                    alert("File size should be less than 1 MB"); <%--No I18N--%>
                } else if(_r.cancel){
                    alert("Cloase dialog");<%--No I18N--%>
                } else {
                    alert("Error Occurred"); <%--No I18N--%>
                }
            }
        </script>
        <%}%>
    </head>
    <body>
        <div class="cs-title">
            Upload your Photo / Logo<%--No I18N--%>
        </div>
        <div style="margin-top: 20px;">
            <iframe name="csPhotoLoadder" frameborder="0" height="0" width="0" style="display: none;"></iframe>
            <form name="csPhotoForm" action="<%=IAMEncoder.encodeHTMLAttribute(contextpath)%>/w" method="POST" enctype="multipart/form-data" target="csPhotoLoadder">
                <input type="hidden" name="callback" value="<%=IAMEncoder.encodeHTMLAttribute(callback)%>" />
                <input type="hidden" name="id" value="<%=IAMEncoder.encodeHTMLAttribute(zid)%>" />
                <input type="hidden" name="t" value="<%=IAMEncoder.encodeHTMLAttribute(type)%>" />
                <label class="cs-field-title">Choose a picture :&nbsp;</label><%--No I18N--%>
                <label class="cs-field-value">
                    <input type="file" name="photo"><br>
                    <span class="cs-hint">
                        <ul style="padding-left: 15px;margin: 5px 0 0 0;">
                            <li>Supported file formats are JPG / GIF / PNG / JPEG)</li><%--No I18N--%>
                            <li>File size should be less than 1 MB</li><%--No I18N--%>
                            <li>Please don't upload nude/copyrighted/celebrity images.</li><%--No I18N--%>
                        </ul>
                    </span>
                </label>
                <label class="cs-field-title">View Permission :&nbsp;</label><%--No I18N--%>
                <label class="cs-field-value">
                    <select name="permission">
                        <% for (PhotoUtil.Permission p : PhotoUtil.Type.get(type).permissions) { // p.name() --> Change it to User-Friendly message. %>
                        <option value="<%=IAMEncoder.encodeHTMLAttribute(p.name())%>" <%=photoInfo != null && photoInfo.permission == p ? "selected" : ""%>><%=IAMEncoder.encodeHTMLAttribute(p.name())%></option>
                        <% }%>
                    </select>
                </label>
                <label class="cs-field-title">&nbsp;</label>
                <div class="cs-field-value">
                    <input type="submit" value="Upload">
                  <input type="button" value="Cancel" onclick="<%=IAMEncoder.encodeHTMLAttribute(callback)%>({cancel:true})">
                </div>
            </form>
        </div>
    </body>
</html>
