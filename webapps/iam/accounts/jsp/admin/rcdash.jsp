
<%--$Id$--%>
<%@page import="com.zoho.protobuf.Message"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.zoho.resource.RESTRepresentation"%>
<%@page import="com.zoho.resource.Representation"%>
<%@page import="com.zoho.accounts.AppResource"%>
<%@page import="com.zoho.accounts.AppResource.CacheClusterURI"%>
<%@page import='com.zoho.accounts.internal.util.Util'%>
<%@page import='com.zoho.accounts.internal.util.AccountsInternalConst'%>
<%@page import='com.zoho.accounts.AccountsConfiguration'%>

<%
if(request.getParameter("getdata")!=null){//No I18N
	response.setContentType("application/json"); //No I18N
	JSONObject respObj = new JSONObject();
	JSONArray arr = new JSONArray();
	for(Message m  : AppResource.getCacheClusterURI().GETS()){
		arr.put(new JSONObject(Representation.toJSONString(m)));
	}
	respObj.put("representation", arr);//No I18N
	out.print(respObj.toString());//NO OUTPUTENCODING
	return;
}
%>
<html>
<head>
<title>Cluster Monitor</title><%--No I18N--%>
<style>
svg {
	overflow: visible;
	font: 10px sans-serif;
	shape-rendering: crispEdges;
}

text {
	cursor: default;
	text-anchor: middle;
}

body {
	width: 100%;
	height:100%;
	overflow:hidden;
	margin: 0px;
	padding: 0px;
}

circle{
-webkit-backface-visibility: hidden;
  stroke-width: 1.5px;
shape-rendering: geometricPrecision;
}
.chart {
	margin: 0px;
	padding: 0px;
	background-color: whitesmoke;
}

#frame {
	float: right;
	border: 0px solid transparent;
}

#title {
	height: 5%;
	width: 100%;
	margin-top: 0px;
	padding: 0px;
	background-color: #29B6F6;
	color: white;
	font-size: xx-large;
	font-weight: bold;
	text-align: center;
}

#title span {
	margin-right: 5%;
}

.constrained {
	width: 24%;
	float: left;
	height:100%;
	clear:both;
	-webkit-user-select: none; /* Chrome/Safari */        
	-moz-user-select: none; /* Firefox */
	-ms-user-select: none; /* IE10+ */
	/* Rules below not implemented in browsers yet */
	-o-user-select: none;
	user-select: none;
}

#cluster{
	z-index: 10000;
	width:25%;
}
</style>
</head>
<body>
	<div class='constrained'>
		<div id='title'>
			<span>Cluster Monitor</span>		<%--No I18N--%>
		</div>
		<svg id='cluster'></svg>		<%--No I18N--%>
	</div>
</body>
<iframe id='frame'></iframe>
<script>
	var h = window.innerHeight, w = percent(window.innerWidth,25), r = percent(w * 4,2.3), nodes, g, colors = [ '#d77fb3', '#79c36a', '#599ad3','#f1595f', '#727272', '#f9a65a', '#9e66ab', '#cd7058', '#d77fb3' ]; //No I18N
	h = h - percent(h, 5);
	function draw() {
		node = d3.select('#cluster').attr('h', h).attr('w', w).selectAll('g.node'); //No I18N
		var force = d3.layout.force().nodes(nodes).links([]).charge(-(r * 10))
					.gravity(0).size([ w, h ]).on('tick', tick);//No I18N
		force.start();
		node = node.data(nodes).enter();
		g = node.append('g').attr('class', 'node');//No I18N
		g.append('circle')//No I18N
		.on('click', function(d) {//No I18N
        	loadRanges(d);
			g.selectAll('circle').style('stroke', function(d, i) {//No I18N
				return d3.rgb(colors[i]).darker();
			}).style('stroke-width','1.5px');//No I18N
			d3.select(this).style('stroke','lightgreen').style('stroke-width','5px');//No I18N
		})
		.attr('cx', function(d) {//No I18N
			return d.x;
		}).attr('cy', function(d) {//No I18N
			return d.y;
		}).attr('r', function(d) {//No I18N
			return r;
		}).style('fill', function(d, i) {//No I18N
			return colors[i];
		}).style('stroke', function(d, i) {//No I18N
			return d3.rgb(colors[i]).darker(2);
		}).style('stroke-width', '1.5px')//No I18N
		.call(force.drag)
        .style("opacity", 1);//No I18N

        g.append('text').attr('width', r * 2).attr('dx', function(d) {//No I18N
			return -r + 10;
		}).attr('dy', '.35em').text(function(d) {//No I18N
			return d.cluster_name;
		}).style('fill', function(d, i) {//No I18N
			return 'white';//No I18N
		}).on('click', function(d) {//No I18N
        	loadRanges(d);
			g.selectAll('circle').style('stroke', function(d, i) {//No I18N
				return d3.rgb(colors[i]).darker();
			}).style('stroke-width','1.5px');//No I18N
			d3.select(this.parentNode).selectAll("circle").style('stroke','lightgreen').style('stroke-width','5px');//No I18N
		})
		.style('font-weight', 'bold');//No I18N
	}

	function loadRanges(data) {
		$('#frame').attr('src','/accounts/admin/rcrangevis.jsp?cluster='+ encodeURIComponent(data.cluster_name));//No I18N
	}

	function tick(e) {
		var k = .1 * e.alpha;
		nodes.forEach(function(o, i) {
			o.y += (window.innerHeight / 2 - (o.y)) * k;
			o.x += (window.innerWidth / 8 - (o.x)) * k;
		});
		g.selectAll('circle').attr('cx', function(d) {//No I18N
			return d.x;
		}).attr('cy', function(d) {//No I18N
			return d.y;
		})
		g.selectAll('text').attr('x', function(d) {//No I18N
			return d.x;
		}).attr('y', function(d) {//No I18N
			return d.y;
		});
	}
	function percent(val, percent) {
		return Math.round(val * (percent / 100));
	}
</script>
<%
	String cPath = request.getContextPath() + "/accounts"; //No I18N
	String jsurl = (AccountsConfiguration.USE_STATIC_SERVER.toBooleanValue() ? Util.getJSStaticURL(AccountsInternalConst.STATIC_SERVER_CONTEXT): cPath) + "/js"; //No I18N
%>
<script type='text/javascript' src='<%=jsurl%>/tplibs/jquery/jquery-1.12.2.min.js'></script>
<script src='<%=jsurl%>/tplibs/d3.js'></script>
<script>
	$('.constrained').css('height',window.innerHeight+"px");//No I18N
	$('#cluster').css('height',window.innerHeight+"px").css('width',w+"px");//No I18N
	$('#frame').attr('width', window.innerWidth - w).attr('height', window.innerHeight);//No I18N	
	//do rest call and draw graph
	$.ajax({
		url : '/accounts/admin/rcdash.jsp?getdata=true',//No I18N
		success : function(data) {
			nodes = data.representation;
			draw();
		}
	});
</script>
</html>
<!--No I18N-->