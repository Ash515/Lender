<%--$Id$--%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst"%>
<%@page import="com.zoho.accounts.internal.util.Util"%>
<%@page import="com.zoho.accounts.AccountsConfiguration"%>
<%@page import="java.util.TreeSet"%>
<%@page import="java.util.TreeMap"%>
<%@page import="com.zoho.accounts.AppResourceProto.CacheCluster"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%--No I18N--%>
<%
	String cPath = request.getContextPath()+"/accounts"; //No I18N
    String jsurl = (AccountsConfiguration.USE_STATIC_SERVER.toBooleanValue() ? Util.getJSStaticURL(AccountsInternalConst.STATIC_SERVER_CONTEXT) : cPath) +"/js"; //No I18N
%>

<html>

<head>
<title>Cache Monitor</title><%--No I18N--%>
</head>

<style type="text/css">

text{
	cursor:default;	
}
body {
	font-family: Consolas, Menlo, Monaco, Lucida Console, Liberation Mono,
		DejaVu Sans Mono, Bitstream Vera Sans Mono, Courier New, monospace,
		serif;
	font-size: 10px;
	margin: 0px;
	overflow: hidden;
}

div .left{
	float:left;
	width:17%;
	height: 100%;
	z-index:10;
	background-color: #044F67;
	border-right:1px solid #e5e5e5;
	overflow: hidden;
}

div .center{
	float:left;
	width:82%;
	height: 100%;
	z-index:-1;
	box-shadow: inset 6px -1px 10px rgba(212,212,212,0.5);
}

html, body {
      height: 100%;
}
    
div{
    overflow-y:scroll;
}

ul{
  padding-left:0px;
  margin-left:0px;
  height:100%;
  overflow: scroll;
}

ul li{
  list-style-type:none;
}

a, a:visited { 
	display:block; 
	width:94%; 
	font-family:Roboto, DejaVu Sans, sans-serif; 
    font-size:1.4em;
	text-decoration:none;
	padding-top:5%;
	padding-bottom:5%;
	padding-left:5%;
	padding-right:1%;
	color:white;
} 

.hidden{
	display:none;
}
.collapse{
	display:none;
}
td{
	padding:2%;
}
table{
	width: 80%;
	margin-left:10%;
}
tr:nth-child(2n):not(.hidden):not(.us4):not(.us3){
	background-color: #E3EEFF;
	color:#34495e;	
}

tr.us4{
	background-color: #2ECC71;
	color: white;	
}
tr.us3{
	background-color: #3498DB;
	color:white;	
}
.title{
	font-size: 1.5em;
	background-color: #19B5FE;
	font-family:Roboto, DejaVu Sans, sans-serif; 
    font-size:2.0em;
	text-decoration:none;
	padding-top:5%;
	padding-bottom:5%;
	padding-left:5%;
	margin-top:0px;
	color:white;
}

#search{
	width:90%;
	margin-left:5%;
	padding:2%;
	z-index:20px;
	border-radius: 5px;
	border:0px;
	user-select:none;
}

#search:focus{
	outline:0px;
}

.toggle{
	cursor:default;
	cursor:hand;
	background-color: #67809F;
}

.toggle:after{
	content:'\2771';
	float:right;
	font-size:1.0em;
	letter-spacing: -.05em;
	margin-right:10px;
	color:white;
}

a {
    user-select: none;
    -webkit-touch-callout: none;
    -webkit-user-select: none;
    -khtml-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
}

.inset{
	padding-left:20%;
}

.active{
	background-color: #4183D7;
	border:1px solid #2c82c9;
}

.loading {
  margin-top: 20%;
  margin-left: 45%;
  width: 50px;
  animation: infinite-rotate 0.8s infinite linear;
  border: 3px solid #4183D7;
  border-right-color: transparent;
  border-radius: 50%;
  height: 50px;
}

.hidden{
	opacity:0;
}

@keyframes infinite-rotate {
  0%    { transform: rotate(0deg); }
  100%  { transform: rotate(360deg); }
}

.us3{
	fill: #2fefd;
}
.us4{
	fill: #2ECC71;
}

.node {
  stroke-width: 1.5px;
}


</style>



<body>


<script type="text/x-handlebars">
<div class='left'>
<p class='title'>Cache Monitor <span class='live'>*</span></p><%--No I18N--%>
<p>{{input id='search' placeholder='Filter' key-down='onSearch'}}</p><%--No I18N--%>
	<ul> 
	{{#each model as |item|}}	
			<li>{{#link-to 'instance' item.server_ip_port}}{{item.parent.cluster_name}}{{/link-to}}</li><%--No I18N--%>
	{{/each}}
	</ul>
</div>
<div class='center'>
		{{outlet}}    
</div>
</script>

<script type="text/x-handlebars" id="instance">
	<table>
	<tr><td>Replication Status : {{model.repl}}</td></tr>
	<tr><td>Memory Usage : {{model.mem}}</td></tr>
    {{#each model.data as |item|}}
      <tr><td>{{item}}</td></tr>
    {{/each}}
    </table>
</script>
<script type="text/x-handlebars" id="loading">
	<div class='loading'/>
</script>


<script type="text/x-handlebars" id="dashboard">
	{{bubble-chart model=model}}
</script>

<script type="text/x-handlebars" id="clusterview">
	{{force-bubble-chart model=model}}
</script>


<script type="text/x-handlebars" id="table">
	<table>
<tr><th>Service Name</th><th>Ips</th></tr>
    {{#each model as |item|}}
      <tr class='{{item.className}}'><td>{{item.name}}</td><td>{{item.ips}}</td></tr>
    {{/each}}
    </table>	
</script>


<script type="text/x-handlebars" id="components/bubble-chart">
	<div class='d3-out'/><%--No I18N--%>
</script>
<script type="text/x-handlebars" id="components/force-bubble-chart">
	<svg class='d3-out' width='1180' height='800'/><%--No I18N--%>
</script>


<script type="text/x-handlebars" id="message">
	<form {{action "sendMessage" on="submit"}}>
	Choose Deployment : 
	{{#each model.dep as |item|}}
		{{item}} <input type='radio'  value=model.lastName name='dep' data={{item}} class='dep_radio'/>
<br/>
	{{/each}}
	
	Choose Pool :
	{{#each model.pools as |item|}}
		{{item}} <input type='radio' name='pool' data={{item}} class='pool_radio'/>
<br/>
	{{/each}}
	{{input type='submit' value='SUBMIT'}}<%--No I18N--%>
	</form>
</script>
</body>
<script type="text/javascript" src="<%=jsurl%>/tplibs/jquery/jquery-1.12.2.min.js"></script>
<script src='<%=jsurl%>/tplibs/ember.min.js'></script>
<script src='<%=jsurl%>/tplibs/handlebars.min.js'></script>
<script src='<%=jsurl%>/tplibs/ember-template-compiler.js'></script>
<script src='<%=jsurl%>/tplibs/d3.js'></script>

<script type="text/javascript">

</script>


<script>
	var target = 'GLOBAL';<%--No I18N--%>
	App = Ember.Application.create();
	App.Router.map(function(){
		this.route('instance',{path:'/instance/:instance'});<%--No I18N--%>
		this.route('dashboard',{path:'/dashboard'});<%--No I18N--%>
		this.route('table',{path:'/table'});<%--No I18N--%>
		this.route('message',{path:'/message'});<%--No I18N--%>
		this.route('clusterview',{path:'/clusterview'});<%--No I18N--%>
	});
	
	App.InstanceRoute =  Em.Route.extend({
		model: function(data){
			var data = data.instance.replace(/\s+/g, '');
		    var ipPort = data.indexOf("]:") != -1 ? data.substring(1,data.length).split("]:") :  data.split(":") ;
			return Ember.$.getJSON('/accounts/admin/stats?cachestats=true&op=2&ip='+ipPort[0]+'&port='+ipPort[1]).then(function(data){<%--No I18N--%>
				return data;
			});
		}
	});
	
	
	App.ApplicationRoute =  Em.Route.extend({
		model: function(){
			return Ember.$.getJSON('/accounts/admin/stats?cachestats=true&op=1').then(function(data){<%--No I18N--%>
				var stuffed = [];
				for(var i in data){
					if(!Number.isNaN(Number.parseInt(i))){
						stuffed.push(JSON.parse(data[i]));
					}
				}
				return stuffed;
			});
		}
	});
	
	
	App.ApplicationController = Ember.Controller.extend({
		actions : {
			onSearch : function(e) {
				$.each($('table').find('tr'), function() { //No I18N
					if ($(this).text().toLowerCase().indexOf(e.toLowerCase()) == -1){
						$(this).hide();
					} else {
						$(this).show();
					}
				});
				return false;
			},
			openFirst: function() {
				this.transitionToRoute('/clusterview');<%--No I18N--%>
			}
		},
	    init: function () {
			    this._super();
			    if(!window.location.hash){
			    	Ember.run.schedule('afterRender',this,function() {<%--No I18N--%>
			      		this.send("openFirst");<%--No I18N--%>
			    	});
			    }
	    }
	});
	
	App.TableRoute = Em.Route.extend({
		model : function(){			
			return Ember.$.getJSON('/accounts/admin/stats?cachestats=true&op=3').then(function(data){<%--No I18N--%>
				var unique = [];
				$.each(data, function(index, value) {
					var ips= [];
					$.each(value.ips, function(index, ip) {
						if ($.inArray(ip, ips) === -1) {
				     	   ips.push(ip);
				    	}
					});
					value.ips = ips;
					unique.push(value);
				});
				return unique;
			});
			
		}
	});
	
	App.DashboardRoute =  Em.Route.extend({
		model: function(){
			return Ember.$.getJSON('/accounts/admin/stats?cachestats=true&op=3').then(function(data){//No I18N
				return {'children' : data };//No I18N
			});
		}
	});
	
	App.ClusterviewRoute =  Em.Route.extend({
		model: function(){
			return Ember.$.getJSON('/accounts/admin/stats?cachestats=true&op=3').then(function(data){<%--No I18N--%>
				return data;
			});
		}
	});

	
	App.MessageRoute = Em.Route.extend({
		model : function(){
			return {'pools' : ['all','user','org','serviceorg','group','photo','ticket'],'dep':['us3','us4','lz','lzro','m123','eu1','eu2','SV4']};<%--No I18N--%>
		}
	});
	
	App.MessageController = Em.Controller.extend({
		actions :{
			sendMessage : function(){
				var dep = $('input[name=dep]:checked')[0];<%--No I18N--%>
				var pool = $('input[name=pool]:checked')[0];<%--No I18N--%>
				if(!dep){
					alert('choose a deployment');<%--No I18N--%>
					return;
				}
				if(!pool){
					alert('choose a pool');<%--No I18N--%>
					return;
				}
				Ember.$.get('/accounts/admin/stats?message=true&target='+target+'&pool='+$(pool).attr('data')+'&dep=_'+$(dep).attr('data')).then(function(data){<%--No I18N--%>
					alert('sent message to '+data+' servers');<%--No I18N--%>
				});
			}
		}
	});
	var data = null, svg = null,bubble = null;
	
	App.BubbleChartComponent = Ember.Component.extend({
		didInsertElement : function(){
			data = this.get('model');<%--No I18N--%>
			svg = d3.select('.d3-out').append('svg')<%--No I18N--%>
			.attr('width', 1000)<%--No I18N--%>
			.attr('height', 700);<%--No I18N--%>

		bubble = d3.layout.pack()
			.size([1000, 700])
			.value(function(d) {return 1;})
			.padding(3);
			this.redraw();
		},
		redraw : function (){
			var nodes = bubble.nodes(data)
			.sort(null)
				.filter(function(d) { return !d.children; });

			var vis = svg.selectAll('circle')<%--No I18N--%>
				.data(nodes, function(d){return d.name+'_'+d.className;});

			var duration = 500;
			var delay = 0;

			vis.transition()						
				.style('fill', function(d){return d.className=='us4'?'#2ECC71':'#3498DB';});<%--No I18N--%>

			var tmp = vis.enter().append('svg:g')<%--No I18N--%>
		         .attr('class', 'node')//No I18N
		         .attr('transform', function(d) { return 'translate(' + d.x + ',' + d.y + ')';});<%--No I18N--%>
			tmp.append("svg:title")<%--No I18N--%>
			     .text(function(d) { return d.ips; });
			//tmp.on('click', function(d){'connected to '+ d.redisip;});
			tmp.append('circle')<%--No I18N--%>
				.attr('class', function(d) { return d.className; })<%--No I18N--%>
				.attr('r', function(d) { return 40; })<%--No I18N--%>
				.style('opacity', 1)<%--No I18N--%>
				.style('fill', function(d){return d.className=='us4'?'#2ECC71':'#3498DB';});
			tmp.append('svg:text')<%--No I18N--%>
				.attr('text-anchor','middle')<%--No I18N--%>
				.attr('dy', '.3em')<%--No I18N--%>
				.text(function(d) { return d.name.substring(0, d.r / 3); })
				.style('fill', function(d){return d.className=='us4'?'white':'white';});<%--No I18N--%>
			vis.exit().remove();
			self = this;
		}
	});

	var  force = null;
	App.ForceBubbleChartComponent = Em.Component.extend({
		didInsertElement : function(){
			data = this.get('model');<%--No I18N--%>
			this.draw();
		},
		draw: function() {
			var w = 1180, h = 1000,  r = 30;
			var hc = Math.floor((window.innerWidth - $('.left').width())/3);
			var vc = Math.floor(window.innerHeight/2);

			force = d3.layout.force().nodes(data,function(d){return d.name+'_'+d.className}).links([]).charge(-6*r)
			.gravity(0).size([ w, h ]).on('tick', function (e) {<%--No I18N--%>
				node = d3.select('.d3-out').attr('h', h).attr('w', w)//No I18N
			    .attr('transform', 'translate(250,0)') <%--No I18N--%>
				.selectAll('g.node'); //No I18N
			node = node.data(data, function(d){return d.name+'_'+d.className});
			node.exit().remove();

			node = node.enter();
			
			g = node.append('g').attr('class', 'node');//No I18N
			g.append('circle')//No I18N
			.on('click', function(d) {//No I18N
				g.selectAll('circle').style('stroke', function(d, i) {//No I18N
					return d3.rgb(d.className=='us4'?'#2ECC71':'#3498DB').darker();//No I18N
				}).style('stroke-width','1.5px');//No I18N
				d3.select(this).style('stroke','lightgreen').style('stroke-width','5px');//No I18N
			}).attr('cx', function(d) {//No I18N
					return d.x+250;
			}).attr('cy', function(d) {//No I18N
					return d.y;
			}).attr('r', function(d) {//No I18N
					return r;
			}).style('fill', function(d, i) {//No I18N
					return d.className=='us4'?'#2ECC71':'#3498DB';
			}).style('stroke', function(d, i) {//No I18N
					return d3.rgb(d.className=='us4'?'#2ECC71':'#3498DB').darker(2);
			}).style('stroke-width', '1.5px')//No I18N
			  .call(force.drag)
    		  .style("opacity", 1);//No I18N

    	    g.append('text').attr('width', r * 2)//No I18N
    		 .attr('dy', '.25em').text(function(d) {//No I18N
					return d.name.substring(0, r / 3);
			}).attr('text-anchor', 'middle')//No I18N
			  .style('fill', function(d, i) {//No I18N
					return 'white';//No I18N
			}).call(force.drag)
			  .on('click', function(d) {//No I18N
				//TODO
			}).style('font-weight', 'bold');//No I18N
	
			g.append('svg:title')//No I18N
			 .attr('dx', function(d) {//No I18N
					return -r + 10;
			 }).attr('dy', '.35em').style('fill', function(d, i) {//No I18N
					return 'white';//No I18N
			}).text(function(d) {
				return (d.name.indexOf('.')==-1?d.name+'\n':'')+getUnique(d.ips)+'\n redis ip : '+ d.redis; 
			});

			var k = 0.1 * e.alpha;
			data.forEach(function(d, i) {
				if(d.className == 'us4'){
					d.x += (hc - d.x - 100) * k;
				}else{
					d.x += (hc - d.x + 100) * k;
				}
				d.y += (vc - d.y) * k;
			});
			g = d3.select('.d3-out');//No I18N
			g.selectAll('circle').attr('cx', function(d) {//No I18N
				return d.x+250;
			}).attr('cy', function(d) {//No I18N
				return d.y;
			}).style('fill', function(d, i) {//No I18N
				return d.className=='us4'?'#2ECC71':'#3498DB';
			}).style('stroke', function(d, i) {//No I18N
				return d3.rgb(d.className=='us4'?'#2ECC71':'#3498DB').darker(2);
			}).style('stroke-width', '1.5px');//No I18N
			g.selectAll('text').attr('x', function(d) {//No I18N
				return d.x+250;
			}).attr('y', function(d) {//No I18N
				return d.y;
			});			
	 	  });
		  force.start();
		  this.redraw();
		},
		redraw: function(){
			self = this;
			Ember.run.later(function () {
				Ember.$.getJSON('/accounts/admin/stats?cachestats=true&op=3').then(function(tdata){//No I18N
					generateDiff(tdata);
					force.start();
	    	   		$('.live').toggleClass('hidden');//No I18N
	    	   		self.redraw();
				});
			}, 10000);			
		}
	});
	
	function generateDiff(newData){
		if (data && newData) {
			var newNodes ={};
			newData.forEach(function(d){
				newNodes[d.className+'_'+d.name] = d;	
			});
			data.forEach(function(od,i) {
				newData.forEach(function(d) {
					if (d.name == od.name) {
						newNodes[d.className+'_'+d.name]= 'null';
						if (d.className != od.className) {
							od.className = '' + d.className;
							od.ips = JSON.parse(JSON.stringify(getUnique(d.ips)));
						}
					}
				});
				if(!newNodes[od.className+'_'+od.name]){
					console.log('removed ' + od.name);
				//	data = data.splice(i,1);
				}
			});
			newData.map(function(d){
				if(newNodes[d.className+'_'+d.name]!='null'){
					data.push(d);
				}
			});
		} else {
			data = JSON.parse(JSON.stringify(newData));
		}
	}
	
	function getUnique(ips){
		uniq = [];
		ips.forEach(function(d){
			var isExists = false;
			uniq.forEach(function(ud){
				if(ud.ip == d){
					isExists = true;
					ud.cnt = ud.cnt+1;
				}
			});
			if(!isExists){
				uniq.push({ip:d,cnt:1});
			}
		});
		return uniq.map(function(d){
			return d.ip+' -> '+d.cnt + '\n';//No I18N
		});
	}
</script>
</html>