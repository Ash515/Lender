 <%--$Id$--%>
<%@page import="com.zoho.accounts.AppResource.RESOURCE.NODERANGE"%>
<%@page import="com.zoho.resource.URI"%>
<%@page import="com.zoho.resource.Representation"%>
<%@page import="com.zoho.accounts.AppResource"%>
<%@page import="com.zoho.protobuf.Message"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@page import="com.zoho.accounts.internal.util.Util"%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst"%>
<%@page import="com.zoho.accounts.AccountsConfiguration"%>

<%
if(request.getParameter("getdata")!=null){//No I18N
	response.setContentType("application/json");//No I18N
	JSONObject respObj = new JSONObject();
	JSONArray arr = new JSONArray();
	URI u = AppResource.getNodeRangeURI(request.getParameter("getdata"),"");//No I18N
	for(Message m  : u.GETS()){
		arr.put(new JSONObject(Representation.toJSONString(m)));
	}
	respObj.put("representation", arr);//No I18N
	out.print(respObj.toString());//NO OUTPUTENCODING
	return;
}
%>


<html>
<head>
<title>Placeholder for Dash</title><%--No I18N--%>
<style>
svg {
	overflow: visible;
	font: 10px sans-serif;
	shape-rendering: crispEdges;
}
body{
	width:100%;
	overflow-y:scroll;
	margin: 0px;
	padding:0px;
}

.chart {
	margin: 0px;
	padding:0px;background-color: whitesmoke;
}

#visual {
	margin:0px;
}

.tick {
	stroke: black;
}

.tick line {
	stroke: rgb(32, 19, 19);
	stroke-width: 2px;
}

#tooltip {
	position: absolute;
	display: none;
	background-color: black;
	color: white;
	width: 70px;
	height: 16px;
	text-align: center;
	font-size: 16px;
	margin-top: 12px;
}
</style>
</head>
<body>
		<input type='checkbox' id='seeforoverlap' title='Try this to see range distribution' onchange='toggleOverlapCheck();'>Split Nodes</input><%--No I18N--%> 
		<input type='checkbox' id='dontaggregatenodes' title='Try this to see range distribution within nodes'  onchange='toggleAggregateCheck();'>Split Ranges</input><%--No I18N--%> 
		<input type='checkbox' id='seeforequality' title='Try this to see equality of distribution' onchange='toggleEqualityCheck();'>Base Align</input><%--No I18N--%> 
		<br/>
		<div id='tooltip'></div>
        <div id='visual'></div>
		
        <script type='text/javascript'>
            var valgroup,aggregation = true, w = window.innerWidth,_h = window.innerHeight,h= _h-percent(_h, 5)
            colors = ['#d77fb3','#79c36a','#599ad3','#f1595f','#727272','#f9a65a','#9e66ab','#cd7058','#d77fb3'], //No I18N
            indexMap = {},noOfLines,compoundingFactor=5,_data,easeSplit=true;
            var svg,x,y;
        	
            
            function getCompoundingFactor(){
            	var minH = (h - noOfLines*percent(h,1))/noOfLines;
            	if(minH==0){
            		compoundingFactor = 0.5;
           		 }else{
					compoundingFactor = (minH/h)*90;            		
            	 }
            }
            
            function preProcess(data){            	
            	colors = colors.concat(d3.scale.category20b().range());
             	colors = colors.concat(d3.scale.category20c().range());
             	colors = colors.concat(d3.scale.category20().range());
            	colors = colors.concat(d3.scale.category10().range());
            	indexMap = {};
            	noOfLines = data[0].length;
            	var i = 0;
            	$.each(data[0],function(cnt){
            		var d = data[0][cnt];
            		if(indexMap[d.parent.node_name]==undefined){
            			indexMap[d.parent.node_name] = i;
            			i++;
            		}
            	});
            }
            
        	function toggleOverlapCheck(){
        		if(document.getElementById('seeforoverlap').checked){
        			stackEmUp();
        		}else{        			
        			collapseEmAll();
        		}
        	}
        	
        	function toggleEqualityCheck(){
        		if(document.getElementById('seeforequality').checked){//No I18N
        			horizontalCollapse();
        		}else{        
					horizontalExpand();
        		}
        	}
        	
        	function toggleAggregateCheck(){
        		if(document.getElementById('dontaggregatenodes').checked){//No I18N
        			aggregation = false;
        		}else{        			
        			aggregation = true;
        		}
        		toggleEqualityCheck();
        		toggleOverlapCheck();
        	}
        	
			function collapseEmAll(){
				 valgroup.selectAll('rect').transition().duration(750).attr('y', h/2);//No I18N
			}
		
			function stackEmUp(){
				 valgroup.selectAll('rect').transition().duration(750).attr('y', function(d,i) {return getHeight(d,i,aggregation);});//No I18N
			}
			
			function getHeight(d,i,aggr){
				var val = h/2;
				if(aggr){
					val = y(indexMap[d.parent.node_name]*percent(h,compoundingFactor));
				}else{
					val = y(i*percent(h,compoundingFactor));
				}
				if(i>noOfLines/2){
					if(aggr){
						if(easeSplit &&_data[Math.ceil(noOfLines/2-1)].parent.node_name===d.parent.node_name){
							//first guy.. so we might need to help reuinite it based on node
							console.log("shifting it to ease split");
						}else{
							val = -y((Object.keys(indexMap).length-indexMap[d.parent.node_name])*percent(h,compoundingFactor));
						}
					}else{
						val = -y((noOfLines-i)*percent(h,compoundingFactor));
					}	
				}
				return (h/2)+val;
			}
			
			function horizontalCollapse(){
				lastXVals = {};
				valgroup.selectAll('rect').transition().attr('x',function(d,i){//No I18N
					if(lastXVals[d.parent.cluster_name+d.parent.node_name]){
						var lastval = lastXVals[d.parent.cluster_name+d.parent.node_name];
						if(d.parent.node_name==='node3'){
							console.log("lval"+lastval)
						}
						lastXVals[d.parent.cluster_name+d.parent.node_name] += x(d.end-d.start);
						if(d.parent.node_name==='node3'){
							console.log(lastval)
						}
						return lastval;
					}else{
						if(d.parent.node_name==='node3'){
							console.log(0)
						}
						lastXVals[d.parent.cluster_name+d.parent.node_name] = x(d.end-d.start);
						return 0;
					}
				});
			}
		
			function horizontalExpand(){
				lastXVals = {};
				valgroup.selectAll('rect').transition().attr('x',function(d,i){//No I18N
					return x(d.start);
				});
			}
		
			function draw(data){
				_data=data[0];
				preProcess(data);
				getCompoundingFactor();
				addBaseNode(data);        
	        	addRectangles();	      
	        	addAxis();
				addToolTip();
				addLegend(Object.keys(indexMap));//No I18N
			}	
		
			function addRectangles(){
				 valgroup.selectAll('rect')//No I18N
	    	     .data(function(d){
	    	    	return d;
	    	     })
	    	    .enter()
	    	    .append('svg:rect')//No I18N
	    	    .attr('class', 'rectangle')//No I18N
	    	    .attr('width','0')//No I18N
				.style('fill', function(d, i) { return colors[indexMap[d.parent.node_name]]; })//No I18N
	    	    .style('stroke', function(d, i) { return colors[indexMap[d.parent.node_name]]; })//No I18N
	    	    .transition().delay(100).duration(750)//No I18N
	    	    .attr('width', function(d) { return x(d.end-d.start); })//No I18N
	        	.attr('height', percent(h,1))//No I18N
	        	.attr('data-legend',function(d){return d.parent.node_name;})//No I18N
	        	.attr('x', function(d) {return x(d.start); })//No I18N
	        	.attr('y', y(h/2));//No I18N
			}
		
			function addBaseNode(data){
				svg = d3.select('#visual')//No I18N
	            .append('svg:svg')//No I18N
	            .attr('class', 'chart')//No I18N
	            .attr('width', w)//No I18N
	            .attr('height', h)//No I18N
	            .append('svg:g'); //No I18N
	            x = d3.scale.linear().range([0, w]);
	            y = d3.scale.linear().range([0, h]);
	            x.domain([0, 9223372036854775807]);
				y.domain([0, h]);

				valgroup = svg.selectAll('g.valgroup')//No I18N
	        	.data(data)
	        	.enter().append('svg:g')//No I18N
	        	.attr('class', 'valgroup');//No I18N
				valgroup.transition();
			}	
		
			function addToolTip(){
				d3.selectAll('.rectangle')//No I18N
				.on('mouseover',function(da,i,e){//No I18N
						var d=document.getElementById('tooltip'); //No I18N
						d.style.display='block';//No I18N
						d.innerHTML= ((((x(da.end-da.start)/w)*100)+'').substring(0,4)+' %');//No I18N
						d.style.top=(d3.event.pageY+5)+'px';d.style.left=(d3.event.pageX+10)+'px';//No I18N
					}
				  )
				.on('mouseleave',function(){//No I18N
						document.getElementById('tooltip').style.display='none';
					}
				   );
			}
			
			function addAxis(){
				xAxis = d3.svg.axis().scale(x).tickFormat(function(d){return (''+d).charAt(0)+' Q';}).tickSize(5,1);//No I18N
				svg.append('g')//No I18N
	        	.attr('class', 'x axis')//No I18N
	        	.attr('transform', 'translate(0,' + y(h-percent(h,2)) + ')')//No I18N
	        	.call(xAxis)
	        	.selectAll('text')//No I18N
	        	.attr('y', percent(h,1))//No I18N
	        	.attr('x', 9)//No I18N
	        	.attr('dy', '.70em')//No I18N
	        	.style('text-anchor', 'end').append('g')//No I18N
	        	.attr('class','legend');//No I18N
			}	
		
			function addLegend(data){
				var spaceBetween = percent(w,5),verticalSpacing = percent(_h,1.5);
				var heuristic = ((data.length*(spaceBetween+percent(_h,2)))/w)*50;
				var selection = d3.select('svg').append('g').attr('transform','translate('+(w/2-percent(w/2,heuristic))+',2)');//No I18N
				var a = selection.selectAll('.legend').data(data).enter().append('g').attr('x',function(d,i){return i*spaceBetween;});//No I18N
				a.append('rect').attr('x',function(d,i){return (i)*spaceBetween;}).attr('height',percent(_h,2)).attr('width',percent(_h,2)).style('fill', function(d, i) { return colors[i]; }).style('stroke', function(d, i) { return colors[i]; });//No I18N
				a.append('text').text(function(d){return d;}).attr('y',verticalSpacing).attr('x',function(d,i){return (i)*spaceBetween+percent(_h,2)+2;});//No I18N
			}
		
			function percent(val, percent){
				return Math.round(val*(percent/100));
			}
	
</script>
</body>
<%
	String cPath = request.getContextPath()+"/accounts"; //No I18N
    String jsurl = (AccountsConfiguration.USE_STATIC_SERVER.toBooleanValue() ? Util.getJSStaticURL(AccountsInternalConst.STATIC_SERVER_CONTEXT) : cPath) +"/js"; //No I18N
%>
<script src='<%=jsurl%>/tplibs/d3.js'></script>
<script type="text/javascript" src="<%=jsurl%>/tplibs/jquery/jquery-1.12.2.min.js"></script>
<script>
//do rest call and draw graph
$.ajax({url:'/accounts/admin/rcrangevis.jsp?getdata=<%=IAMEncoder.encodeJavaScript(request.getParameter("cluster"))%>',success:function(data){//No I18N
	draw([data.representation]);
}});
</script>
</html>
<!--No I18N-->