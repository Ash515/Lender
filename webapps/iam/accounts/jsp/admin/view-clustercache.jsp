<%-- $Id: $ --%>
<%@page import="com.zoho.resource.cluster.impl.RedisNodeImpl"%>
<%@page import="com.zoho.resource.redis.ClusterTransferer"%>
<%@page import="com.zoho.resource.Transferer.Method"%>
<%@page import="com.zoho.resource.TransfererImpl"%>
<%@page import="com.zoho.resource.util.RESTConstants"%>
<%@page import="com.zoho.accounts.AccountsConstants.Header"%>
<%@page import="com.zoho.resource.internal.LocalTransferer"%>
<%@page import="org.apache.tomcat.jni.Local"%>
<%@page import="com.zoho.resource.RESTRepresentation"%>
<%@page import="com.zoho.resource.util.RESTUtil"%>
<%@page import="sun.nio.cs.ext.SJIS"%>
<%@page import="org.json.JSONArray"%>
<%@page import="com.zoho.jedis.v320.exceptions.JedisConnectionException"%>
<%@page import="com.zoho.resource.Representation"%>
<%@page import="com.zoho.protobuf.JsonFormat"%>
<%@page import="com.zoho.protobuf.Message"%>
<%@page import="java.util.*"%>
<%@page import="com.zoho.resource.RepresentationProto.PBRepresentation"%>
<%@page import="com.zoho.resource.redis.JedisPoolUtil.Pools"%>
<%@page import="com.zoho.resource.redis.JedisPoolUtil"%>
<%@page import="com.zoho.jedis.v320.Jedis"%>
<%@page import="com.zoho.accounts.AccountsConstants"%>
<%@page import="com.zoho.resource.RESTProperties"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="com.zoho.resource.ResourceException"%>
<%@page import="com.zoho.data.DBUtil"%>
<%@page import="com.zoho.accounts.Accounts"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.zoho.resource.URI"%>
<%@include file="../../../static/includes.jspf" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!private static final Logger LOGGER = Logger.getLogger("com.zoho.accounts.jsp.view-clustercache_jsp"); // No I18N%>
<%
	String action = request.getParameter("ac");
    boolean enabled = RESTProperties.getInstance(AccountsConstants.REST_CONTEXT).getRedisCacheEnabledProperty();
    if (action == null || !enabled) {
        action = "ui"; // No I18N
    }
    if (!"ui".equals(action)) {
        response.setContentType("application/json"); // No I18N
        String uriStr = request.getParameter("uri"); // No I18N
        URI uri = URI.getInstance(AccountsConstants.REST_CONTEXT, null, uriStr);
        String sha5key = ClusterTransferer.SHA5(uri,null);
       	RedisNodeImpl node = null;
       	boolean broken = false;
        try {
        	node = (RedisNodeImpl)JedisPoolUtil.getCorrectNode(Pools.DATA_POOL, sha5key);
            if ("view".equals(action)) { // No I18N
            	String value = null;
            	String runkey = null;
            	String hash = ClusterTransferer.getHashName(uri);
            	Map<String, String> map = node.hgetall(sha5key);
		if (!map.isEmpty()) {
			runkey = map.get("runkey"); //No I18N
			hash = hash+ map.get("rootid"); //No I18N
		}
		if (runkey != null) {
			byte cachedPbr[] = node.hget(hash.getBytes(), runkey.getBytes());
			if (cachedPbr != null) {
				PBRepresentation.Builder tpbr = PBRepresentation.parseFrom(cachedPbr).toBuilder();
				tpbr.setHitFrom(ClusterTransferer.HIT_FROM);
				value = Representation.toJSONString(tpbr.build());
			}
		}
		out.print(new JSONObject().put("k", IAMEncoder.encodeHTML(sha5key)).put("v", (value == null ? "-- Data Not Found --" : value))); // No I18N
	} else if ("rm".equals(action)) { //No I18N
		List<String> rootIdentifiersUsingUri = ClusterTransferer.getAllRootIdentifiers(uri);
		if(rootIdentifiersUsingUri==null||rootIdentifiersUsingUri.isEmpty()){
			 String rootid = node.hgetall(sha5key).get("rootid");//No I18N
			 String hash = ClusterTransferer.getHashName(uri)+rootid;
			 node.del(hash);
		}else{
			uri.setIdChange(true);
			uri.setRootIdChange(true);
			uri.getRESTProperties().getClusterTransferer().handleClearance(uri);
		}
		out.print(new JSONObject().put(IAMEncoder.encodeHTML("k"), IAMEncoder.encodeHTML(uriStr)).put(IAMEncoder.encodeHTML("v"), IAMEncoder.encodeHTML("-- Removed from Cache --"))); // No I18N 
	} else if ("ca".equals(action)) {//No I18N
		out.print(new JSONObject().put("k", IAMEncoder.encodeHTML("SETS Involved")).put("v", new JSONArray(ClusterTransferer.getSets(uri)).toString()));//No I18N
	} else if ("sc".equals(action)) {//no I18N
		boolean status = false;
		Map<String,String> map = node.hgetall(sha5key);
		String runkey = map.get("runkey");//No I18N
		if (runkey != null) {
			byte cachedPbr[] = node.hget((ClusterTransferer.getHashName(uri)+map.get("rootid")).getBytes(), runkey.getBytes());
			if (cachedPbr != null) {
				PBRepresentation pbr = PBRepresentation.parseFrom(cachedPbr);
				RESTRepresentation output = uri.addHeader(RESTConstants.HTTPHeader.IGNORE_REDISCACHE, "true")._getResponse();
				if (output.getRepresentationCount() == pbr.getRepresentationCount() && output.getResourceType().equalsIgnoreCase(pbr.getResourceType()) && output.getPBROrBuilder().getHttpResponseCode() == pbr.getHttpResponseCode()) {
					out.print(new JSONObject().put("k", "Validity").put("v", "VALID"));//No I18N
				} else {
					out.print(new JSONObject().put("k", "Validity").put("v", "INVALID"));//No I18N
				}
			} else {
				out.print(new JSONObject().put("k", "Validity").put("v", "Not In Cache"));//No I18N
			}
		} else {
			out.print(new JSONObject().put("k", "Validity").put("v", "Not In Cache"));//No I18N
		}
	}
		} catch (JedisConnectionException ex) {
	LOGGER.log(Level.INFO, null, ex);
		} catch (Exception ex) {
	LOGGER.log(Level.INFO, null, ex);
	out.print(new JSONObject().put("err", IAMEncoder.encodeHTML(ex.getClass().getSimpleName()) + ": " + IAMEncoder.encodeHTML(ex.getMessage()))); // No I18N
		}
		return;
	}
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Redicache Explorer</title><%--No I18N--%>
        <style type="text/css">
            body {
                font-size: 12px; font-family: DejaVu Sans,Roboto,Helvarica;
                margin: 0; padding: 5px;
            }
            input[type="text"], input[type="password"], textarea, select {
                border: 1px solid #888;
            }
            input[type="text"]:focus, input[type="password"]:focus, textarea:focus, select:focus {
                box-shadow:0 0 5px rgba(82, 168, 236, 0.5);
                -webkit-box-shadow:0 0 5px rgba(82, 168, 236, 0.5);
                -moz-box-shadow:0 0 5px rgba(82, 168, 236, 0.5);
                border-color: rgba(121, 187, 238, 0.75) !important;
                outline:medium none;
            }
            #valcontainer { display: none; border: 1px solid #ccc; padding: 5px; border-top: 4px solid #EE9022; }
            #valcontainer.loading span, #valcontainer.loading p,#valcontainer div { display: none; }
            #valcontainer.loading div { display: block; }
            #valcontainer p { margin-bottom: 0; line-height: 18px; word-wrap: break-word; white-space: pre-wrap; }
            .hint { color: #AAA; font-size: 11px; }
            .header { font-size: 15px; font-weight: bold; border-bottom: 2px solid #C7C7C7; margin-bottom: 5px; padding-bottom: 2px; }
            .input {
                width: 450px; font-size: 17px; padding: 5px;
                margin: 5px 0; font-weight: normal;
            }
            <%if (!enabled) {%>
            #valcontainer { display: block; }
            <%}%>
        </style>
    </head>
    <body>
        <div class="header">
            RediCache Explorer<%--No I18N--%>
        </div>
        <form action="view-clustercache.jsp" method="post" onsubmit="return getRediCache(this);">
            <br>
            <input type="text" name="uri" required placeholder="Enter the URI" class="input" style="width: 439px;">
            <div class="hint">Ex: account/1003/user/1005/useremail</div><%--No I18N--%>
            <br>
            <input type="submit" value="Fetch" class="input" style="width: auto;" <%=!enabled ? "disabled" : ""%>>
            <input type="button" value="Remove" class="input" style="width: auto;" title="Removes the given key from the Redis cache" onclick="return getRediCache(this.form, 'rm');" <%=!enabled ? "disabled" : ""%>>
      	    <input type="button" value="Calculate" class="input" style="width: auto;" title="Removes the given key from the Redis cache" onclick="return getRediCache(this.form, 'ca');" <%=!enabled ? "disabled" : ""%>>	
        	<input type="button" value="Validate" class="input" style="width: auto;" title="Removes the given key from the Redis cache" onclick="return getRediCache(this.form, 'sc');" <%=!enabled ? "disabled" : ""%>>	
        	
        </form>
        <div id="valcontainer">
            <div>Loading ...</div><%--No I18N--%>
            <%if (enabled) {%>
            <span></span>
            <p></p>
            <%} else {%>
            <p style="margin-top: 0;text-align: center;font-weight: bold;">RediCache is not enabled</p><%--No I18N--%>
            <%}%>
        </div>
        <script src="<%=jsurl%>/jquery-1.12.2.min.js" type="text/javascript"></script> <%-- NO OUTPUTENCODING --%>
        <script type="text/javascript">
            function getRediCache(f, ac) {
                if(f.uri.value.trim() == "") {
                    alert("Please enter the URI");<%--No I18N--%>
                } else {
                    var _p = $(f).serialize();
                    _p += "&ac="+(ac ? ac : "view");<%--No I18N--%>
                    $('#valcontainer').addClass("loading").show();<%--No I18N--%>
                    $.getJSON("view-clustercache.jsp", _p, function(j) {<%--No I18N--%>
                        var keyUI = j.err ? "<b>Error : <b>"+j.err : "<b>Key : </b>"+j.k;<%--No I18N--%>
                        var valUI = j.err ? "" : (j.v || "");<%--No I18N--%>
                        try {
                        	valUI = JSON.stringify(JSON.parse(valUI), null, "\t"); <%--No I18N--%>
                        } catch(e) {
                        }
                        var $p = $('#valcontainer').removeClass("loading").find("span").html(keyUI).end().find("p").text(valUI);<%--No I18N--%>
                        if(!j.err) {
                            $p.prepend("<b>Value : </b>");<%--No I18N--%>
                        }
                    });
                }
                return false;
            }
        </script>
    </body>
</html>
