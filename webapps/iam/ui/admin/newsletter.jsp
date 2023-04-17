<%-- $Id$ --%>
<%@page import="com.zoho.iam2.rest.CSPersistenceAPIImpl"%>
<%@ page import="com.adventnet.iam.internal.Util"%>
<%@ page import="com.adventnet.iam.security.SecurityUtil"%>
<%@ page import="java.io.InputStream"%>
<%@ page import="java.io.InputStreamReader"%>
<%@ page import="java.io.ByteArrayInputStream"%>
<%@ page import="java.io.OutputStream"%>
<%@ page import="java.io.IOException"%>
<%@ page import="com.csvreader.CsvReader"%>
<%@ include file="includes.jsp" %>
<%    
    InputStream req_file = Util.getUploadedFile(request);
    String isDownload = request.getParameter("read");
    if(isDownload == null && req_file != null) {
        InputStreamReader is = new InputStreamReader(req_file);
        boolean isSubcribe = "true".equals(request.getParameter("subscribe")) ? true : false;
        try {
            if(is != null) {
                CsvReader csvreader = new CsvReader(is);
                if(!csvreader.readHeaders()) {
                    out.println("<script>parent.newsletterErrorMsg('Invalid file(header not found in this CVS file)')</script>"); //No I18N
                } else {
                    String[] headers = csvreader.getHeaders();
                    int emailIdpos = -1;
                    for(int i = 0; i < headers.length; i++) {
                        if(headers[i].trim().toLowerCase().indexOf("email") != -1 || headers[i].trim().toLowerCase().indexOf("e-mail") != -1 || headers[i].trim().toLowerCase().indexOf("e_mail") != -1) {
                            emailIdpos = i;
                            break;
                        }
                    }
                    if(emailIdpos != -1) {
                        String invalidEmailIds = "";
                        String subscribedEmailIds = "";
                        String unSubscribedEmailIds = "";
                        String failedEmailIds = "";
                        while (csvreader.readRecord()) {
                            String emailId = csvreader.get(headers[emailIdpos]).trim().toLowerCase();
                            if(IAMUtil.isValidEmailId(emailId)) {
                                List<Map> newsLetter=CSPersistenceAPIImpl.getNewsLetter(emailId);
                                if (newsLetter != null  && !newsLetter.isEmpty()) {
                                    for(Map map : newsLetter) {
                                        if(isSubcribe) {
                                           CSPersistenceAPIImpl.addNewsLetter(map.get("zuid")) ;
                                            subscribedEmailIds += emailId + ",";
                                        } else {
                                           CSPersistenceAPIImpl.updateNewsLetter(emailId);
                                            unSubscribedEmailIds += emailId + ",";
                                        }
                                    }
                                } else {
                                    failedEmailIds += emailId + ",";
                                }
                            } else {
                                invalidEmailIds += emailId + ",";
                            }
                        }
                        String exp_res = isSubcribe ? subscribedEmailIds : unSubscribedEmailIds;
                        String result = exp_res + "|||" + invalidEmailIds + "|||" + failedEmailIds + "|||" + isSubcribe;
                        out.println("<script>parent.newsletterUserResponse('"+IAMEncoder.encodeJavaScript(result)+"')</script>"); //No I18N
                    } else {
                        out.println("<script>parent.newsletterErrorMsg('Invalid file(check the CSV file headers)')</script>"); //No I18N
                    }
                }
            } else {
                out.println("<script>parent.newsletterErrorMsg('InputStreamReader object is null')</script>"); //No I18N
            }
        } catch (Exception ex) {
            out.println("<script>parent.newsletterErrorMsg('"+IAMEncoder.encodeJavaScript(ex.getMessage())+"')</script>"); //No I18N
        }
        return;
    } else if(isDownload != null && "true".equals(isDownload)){
        ByteArrayInputStream in = null;
        try {
            List<Map> newsLetter=CSPersistenceAPIImpl.getAllNewsLetter();
            if (newsLetter != null  && !newsLetter.isEmpty()) {
                String delim = ",";
                StringBuilder sb = new StringBuilder("ZUID"+delim+"FULL_NAME"+delim+"EMAIL_ID"+delim+"NEWS_LETTER_SUBSCRIPTION\n");
                for(Map map : newsLetter) {
                    sb.append(map.get("ZUID")).append(delim);
                    String full_name = (String)map.get("FULL_NAME");
                    full_name = full_name == null ? full_name : full_name.replace("\"", "\"\"");
                    sb.append("\"").append(full_name).append("\"").append(delim);
                    sb.append(map.get("EMAIL_ID")).append(delim);
                    sb.append(map.get("NEWS_LETTER_SUBSCRIPTION")).append("\n");
                }
                String output = sb.toString();
                String charset = "UTF-8"; //No I18N
                response.setContentType("application/download;charset=" + charset); //No I18N
                String file = "ZohoAccounts_Newsletter_Users.csv";
                String userAgent = request.getHeader("USER-AGENT");
                if (userAgent != null && userAgent.indexOf("Gecko") != -1 && userAgent.indexOf("Firefox") != -1) {
                    response.setHeader("Content-Disposition", "attachment;filename*=\"" + Util.encode(file).replace("+", " ") + "\"");
                } else {
                    response.setHeader("Content-Disposition", "attachment;filename=\"" + Util.encode(file).replace("+", " ") + "\"");
                }
                response.setHeader("Pragma", "public");
                response.setHeader("Cache-Control", "max-age=0");
                byte bytes[] = output.getBytes(charset);
                in = new ByteArrayInputStream(bytes);
                int size = in.available();
                response.setContentLength(size);
                in.read(bytes);
                OutputStream os = response.getOutputStream();
                os.write(bytes);
                os.flush();
                os.close();
                out.clear();
                out = pageContext.pushBody();
            } else {
                out.println("<script>parent.newsletterErrorMsg('No users subscribed')</script>"); //No I18N
            }
        } catch(Exception ex) {
            out.println("<script>parent.newsletterErrorMsg('"+IAMEncoder.encodeJavaScript(ex.getMessage())+"')</script>"); //No I18N
        } finally {
            try {
                if (in != null) {
                    in.close();
                }
            } catch (IOException ioe) {
            }
        }
        return;
    } else {
%>
<div class="maincontent">
    <div class="menucontent">
	<div class="topcontent"><div class="contitle">Newsletter</div></div>
	<div class="subtitle">Admin Services</div>
    </div>

    <div class="field-bg">
        <form method="post" class="zform" target="importaction" name="newsletteruser" onsubmit="return false;" style="margin-bottom: 2px;">
        <div class="labelmain">
            <div class="labelkey"></div>
            <div class="labelvalue">
                <a href="javascript:;" onclick="getNewsletterUsers(document.newsletteruser)">Click here</a> to get the all subscribed users.
                <input type="hidden" name="<%=SecurityUtil.getCSRFParamName(request)%>" value="<%=SecurityUtil.getCSRFCookie(request)%>"/> <%-- NO OUTPUTENCODING --%>
            </div>
        </div>
        </form>
	<form method="post" class="zform" target="importaction" enctype="multipart/form-data" name="newsletterform" onsubmit="return newsletterUser(this);">
	    <div class="labelmain">
		<div class="labelkey">Import Newsletter User :</div>
		<div class="labelvalue">
		    <input type="file" name="file" id="file" class="input"/>
                    <div class="labelvalue">
                        <label>(Supported file formats: .csv)</label>
                        <div style="padding:3px 0px 3px 5px;line-height: 17px;margin-top: 5px;background-color: #fffafa; float: left;">
                            <div style="color:#ff4500;">Import fields</div>
                            <div>1. EMAIL_ID - Email Address or Username of the User enclosed in double ("") quotes(<font color='#F60000'>Mandatory</font>)</div>
                        </div>
                    </div>
		</div>
	    </div>
            <div class="labelmain">
                <div class="labelkey">Specify the action :</div>
                <div class="labelvalue">
		    <input type="radio" name="subscribe" class="activateradio" value="true" checked>
		    <div class="fllt" style="padding:3px 0px;">Subscribe</div>
		    <input type="radio" name="subscribe" class="inactivateradio" value="false">
		    <div style="padding:3px 0px;">Un subscribe</div>
		</div>
            </div>
	    <div class="accbtn Hbtn">
		<div class="savebtn" onclick="newsletterUser(document.newsletterform)">
		    <span class="btnlt"></span>
		    <span class="btnco">Submit</span>
		    <span class="btnrt"></span>
		</div>
	    </div>
            <input type="hidden" name="<%=SecurityUtil.getCSRFParamName(request)%>" value="<%=SecurityUtil.getCSRFCookie(request)%>"/> <%-- NO OUTPUTENCODING --%>
	    <input type="submit" class="hidesubmit" />
	</form>
    </div>
</div>
<iframe name="importaction" id="importaction" class="hide" frameborder="0" height="0%" width="0%"></iframe>
<%
}
%>
