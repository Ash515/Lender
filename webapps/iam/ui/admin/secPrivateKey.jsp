<%-- $Id$ --%>
<%@page import="com.zoho.accounts.dcl.DCLUtil"%>
<%@page import="com.zoho.accounts.SystemResourceProto.DCLocation"%>
<%@page import="com.zoho.accounts.agent.AuthUtil"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.security.PublicKey"%>
<%@page import="java.security.Signature"%>
<%@page import="java.security.spec.X509EncodedKeySpec"%>
<%@page import="org.apache.commons.codec.binary.Hex"%>
<%@page import="java.security.KeyFactory"%>
<%@page import="java.security.PrivateKey"%>
<%@page import="java.security.spec.PKCS8EncodedKeySpec"%>
<%@ include file="../../static/includes.jspf" %>
<%@ include file="includes.jsp"%>

<%! 


public static String sign(PrivateKey key, String serviceName) throws Exception {

	String currentTimeStr = String.valueOf(System.currentTimeMillis());
	byte[] reqBytes = currentTimeStr.getBytes();
	Signature rsa = Signature.getInstance("MD5withRSA");

	rsa.initSign(key);
	rsa.update(reqBytes);

	byte[] realSig = rsa.sign();
	String sStr = SecurityUtil.BASE16_ENCODE(realSig);
	return getISCSignatureHash(serviceName, currentTimeStr, sStr);
}

private static String getISCSignatureHash(String serviceName, String currentTimeStr, String sStr) {
	return serviceName + "-" + currentTimeStr + "-" + sStr;
}

public static boolean verifyISCSignature(String iscsignature, String pubKeyStr) {
	String[] sigparams = iscsignature.split("-");
	if (sigparams.length == 3) {

		String reqTimeStr = sigparams[1].trim();

		if (SecurityUtil.isValid(reqTimeStr)) {
			long signGeneratedTime = -1;
			try {
				signGeneratedTime = Long.parseLong(reqTimeStr);
			} catch (Exception ex) {
				ex.printStackTrace();
			}

			long diffTime = Math.abs(System.currentTimeMillis() - signGeneratedTime);
			long signatureExpiryTime = 600000;
			if (diffTime > signatureExpiryTime) {
				System.out.println("Expired");
			}

			String sign = sigparams[2].trim();

			try {
				Hex hexCodec = new Hex();
				String[] key=pubKeyStr.split("-");
				byte[] pubKeyBytes = (byte[]) hexCodec.decode(key[0]);
				X509EncodedKeySpec pubKeySpec = new X509EncodedKeySpec(pubKeyBytes);
				PublicKey publicKey = SecurityUtil.getKeyFactory().generatePublic(pubKeySpec);
				Signature sig = Signature.getInstance("MD5withRSA");
				sig.initVerify(publicKey);
				sig.update(reqTimeStr.getBytes());
				byte[] sigToVerify = SecurityUtil.BASE16_DECODE(sign);
				if (sig.verify(sigToVerify)) {
					return true;
				} else {
					return false;
				}
			} catch (Exception ex) {
				Logger.getLogger("SecPrt_JSP").log(Level.WARNING, "Exception while getting ISC", ex);
			}
		}
	}
	return false;
}


%>
<%
        String type = request.getParameter("action"); //NO I18N
        if("verify".equals(type)){
        	String serName = request.getParameter("sId");
        	Service s = Util.SERVICEAPI.getService(serName);
        	String priKey = request.getParameter("privateKey");
        	String pwd = request.getParameter("pwd");
        	String label=request.getParameter("label");
        	User u = IAMUtil.getCurrentUser();
        	if(!AuthUtil.verifyPassword(u.getZaid(), String.valueOf(u.getZUID()), pwd)) {
        		out.write("Invalid Password");
        		return;
        	}
        	String publickey=IAMProxy.getInstance().getServiceAPI().getServicePublicKey(serName, label);
        	if(s != null && priKey != null && publickey != null) {
        		try {
        		Hex hexCodec = new Hex();
        		byte[] privateKeyBytes = (byte[]) hexCodec.decode(priKey);
        		PrivateKey privateKey = KeyFactory.getInstance("RSA").generatePrivate(new PKCS8EncodedKeySpec(privateKeyBytes));
				String sign = sign(privateKey, s.getServiceName());
				boolean isVer =  verifyISCSignature(sign, publickey);
				if(isVer) {
					out.write("Success");//No I18N
				} else {
					out.write("Invalid Private Key");
				}
				}catch(Exception e) {
					out.write("Invalid Private Key");
				}
        	} else if(s != null) {
        		out.write("Invalid  Service");
        	} else if(priKey != null) {
        		out.write("Invalid  Private Key");
        	} else if(publickey != null) {
        		out.write("Public Key Not configured");
        	}
        	return;
        } else if("info".equals(type)){
        	String serName = request.getParameter("sId");
        	String label=request.getParameter("label");
        	Service s = Util.SERVICEAPI.getService(serName);
        	if(s == null) {
        		out.write("Invalid Service");
        	} 
        	else{
        		String publickey=IAMProxy.getInstance().getServiceAPI().getServicePublicKey(serName, label);
            	if(publickey != null) {
            		out.write("SKEY_PRESENT");
            	} else {
            		out.write("SKEY_ABSENT");
            	}
        	}
        	return;
        }
        %>
    <%
	Collection<DCLocation> dcLocations = DCLUtil.getLocationList();
	String loc ="";
	for(DCLocation d : dcLocations){
		if(Util.isValid(loc)){
			loc += ",";
		}
		loc+=d.getLocation();
		
	}
	%>
<head>
<style>
.modal{
  display: none; 
  position: fixed; 
  left: 0;
  top: 0;
  width: 100%; 
  height: 100%; 
  overflow: auto; 
  background-color: rgb(0,0,0); 
  background-color: rgba(0,0,0,0.4); 
}
.modal-content{
  background-color: #fefefe;
  margin: auto;
  padding: 20px;
  border: 1px solid #888;
  width: 30%;
  margin-top: 15%;
  overflow: auto;
  border-radius: 5px;
}
.modal-content{
font-size: 13px;
}
.checkboxStyle{
      margin-bottom: 5px;
}
</style>
</head>
<div class="maincontent">
    <div class="menucontent">
    <div class="topcontent"><div class="contitle">Private Key</div></div>
	<div class="subtitle">Admin Services</div>
    </div>
    <div class="field-bg">
    	<div class="restorelink">
            <a href="javascript:;" id="currentdc" onclick="showPrivateKeyfrm(this,true)" class="disablerslink">Current DC ISC</a> / <%--No I18N--%>
            <a href="javascript:;" id="interdc" onclick="showPrivateKeyfrm(this,false)" class="activerslink">Inter DC ISC</a> / <%--No I18N--%>
        </div>
        <%
        if("view".equals(type)) { //No I18N %>        	
        <form name="privateKey" id="privatekeyfrm" class="zform" method="post" onsubmit="return false">
	    <div class="labelmain">
                <div class="labelkey">Service Name :</div>
                <div class="labelvalue">
		    <select name="serviceid" id="serid" class="select select2Div" onchange="getPrivateInfo(document.privateKey,document.getElementsByClassName('disablerslink'))">
		    <option value='null' selected >Select</option>
			<%for(Service s: ss){%><option value='<%=s.getServiceName()%>' ><%=IAMEncoder.encodeHTML(s.getServiceName())%></option><%}%> <%-- NO OUTPUTENCODING --%>
		    </select>
		</div>
		</div>
		<div id="options" style="display: none;">
			<div class="accbtn Hbtn">
		    <div class="savebtn" onclick="showVerifyfrm()">
			<span class="btnlt"></span>
			<span class="btnco">Verify</span> <%-- No I18N --%>
			<span class="btnrt"></span>
		    </div>
		    <div class="savebtn" onclick="showInterDCSyncWindow(document.privateKey.serid,'<%=loc%>')">
			<span class="btnlt"></span>
			<span class="btnco">Sync</span> <%-- No I18N --%>
			<span class="btnrt"></span>
		    </div>
		    </div>
		</div>
			            
		<div id="privateKeyTest" style="display: none;">
			<div class="labelkey">Private Key :</div>
			<div class="labelvalue"><input type="text" class="input" name="privateKey"/></div>
			
			<div class="labelkey">Enter Admin password :</div>
		    <div class="labelvalue"><input type="password" class="input" name="pwd"/></div>
			

			<div class="accbtn Hbtn">
		    <div class="savebtn" onclick="verifyPrivateKey(document.privateKey,document.getElementsByClassName('disablerslink'))">
			<span class="btnlt"></span>
			<span class="btnco">Verify</span>
			<span class="btnrt"></span>
		    </div>
		    <div class="savebtn" onclick="closeVerifyfrm()">
			<span class="btnlt"></span>
			<span class="btnco">Close</span> <%-- No I18N --%>
			<span class="btnrt"></span>
		    </div>
		    </div>
		</div>
		<div id="addPrivateKey" style="display: none;">
			<div class="accbtn Hbtn">
		    <div class="savebtn" onclick="addPrivateKey(document.privateKey,document.getElementsByClassName('disablerslink'))">
			<span class="btnlt"></span>
			<span class="btnco">Add</span>
			<span class="btnrt"></span>
		    </div>
		</div>
		</div>
		
	</form>
      <%} %>  
        
       </div>
       			
       <iframe name="uploadaction" id="uploadaction" class="hide" frameborder="0" height="0%" width="0%"></iframe>
</div>
	<div id="myModal" class="modal" style="display: none;">
		<div class="modal-content">
		<div id="synced-txt" class="synced-txt" style="margin-bottom: 10px;display: none;"> Already synced in :<span class="syncedDC" id="syncedDC"></span> </div><%-- No I18N --%>
		<div id="select-txt" class="select-txt"style="margin-bottom: 10px;display: none;"> Select a DC to Sync to: </div><%-- No I18N --%>
		<div class="modal-innertag" id="modal-innertag"></div>
  		</div>
  		</div>
