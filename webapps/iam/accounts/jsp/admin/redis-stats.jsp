<%-- $Id: $ --%>
<%@page import="com.adventnet.iam.xss.IAMEncoder"%>
<%@page import="com.zoho.accounts.messaging.RedisMessageHandler"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="javax.swing.text.html.HTML"%>
<%@page import="org.owasp.validator.html.util.HTMLEntityEncoder"%>
<%@page import="freemarker.template.utility.HtmlEscape"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.apache.catalina.startup.TldConfig"%>
<%@page import="java.util.Map"%>
<%@page import="com.zoho.resource.RedisMessageProto.*" import="com.zoho.jedis.v320.JedisPubSub" import="com.zoho.jedis.v320.exceptions.JedisConnectionException"%>
<%@page import="java.util.*"%>
<%@page import="com.zoho.resource.redis.JedisPoolUtil"%>
<%@page import="com.zoho.resource.redis.JedisPoolUtil.Pools"%>
<%@page import="com.zoho.jedis.v320.Jedis"%>
<%@page import="com.zoho.accounts.AccountsConstants"%>
<%@page import="com.zoho.resource.RESTProperties"%>
<%@page import="com.zoho.accounts.AccountsConfiguration"%>
<%@page import="com.zoho.resource.RESTProperties"%>
<%@page import="com.zoho.accounts.internal.util.AccountsInternalConst"%>
<%@page import="com.zoho.accounts.internal.util.Util"%>

<style type="text/css">
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
tr:nth-child(2n):not(.hidden){
	background-color: #E3EEFF;
	color:#34495e;	
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

@keyframes infinite-rotate {
  0%    { transform: rotate(0deg); }
  100%  { transform: rotate(360deg); }
}
</style>

<%
	String cPath = request.getContextPath()+"/accounts"; //No I18N
    String jsurl = (AccountsConfiguration.USE_STATIC_SERVER.toBooleanValue() ? Util.getJSStaticURL(AccountsInternalConst.STATIC_SERVER_CONTEXT) : cPath) +"/js"; //No I18N
%>
<head>
<title>Stats Dashboard </title><%--No I18N--%>
<body>

<script type="text/x-handlebars">
<div class='left'>
<p class='title'>Redis Stats Monitor</p>
<p>{{input id='search' placeholder='Filter' key-down='onSearch'}}</p>
	<ul> 
	{{#each model as |item|}}
		{{#if item.s}}
			<li><a class='toggle' onclick='toggle(this)' id={{item.i}}>{{item.i}}</a></li>
			{{#each item.s as |inv|}}
				<li class='collapse {{item.i}}'>{{#link-to 'instance' (concat item.i '_' inv) class='inset'}}{{inv}}{{/link-to}}</li>
			{{/each}}
		{{else}}
			<li>{{#link-to 'instance' item.i}}{{item.i}}{{/link-to}}</li>
		{{/if}}
	{{/each}}
	</ul>
</div>
<div class='center'>
		{{outlet}}    
</div>
</script>

<script type="text/x-handlebars" id="instance">
	<table>
    {{#each model as |item|}}
      <tr><td>{{item.k}}</td><td title='{{item.v}}'>{{item.vr}}</td></tr>
    {{/each}}
    </table>
</script>
<script type="text/x-handlebars" id="loading">
	<div class='loading'/>
</script>
</body>
<script type="text/javascript" src="<%=jsurl%>/tplibs/jquery/jquery-1.12.2.min.js"></script>
<script src='<%=jsurl%>/tplibs/ember.min.js'></script>
<script src='<%=jsurl%>/tplibs/handlebars.min.js'></script>
<script src='<%=jsurl%>/tplibs/ember-template-compiler.js'></script>
<script src='<%=jsurl%>/tplibs/d3.js'></script>

<script type="text/javascript">
	function toggle(thisR){
		if($(thisR).hasClass('_expanded')){
			$(thisR).removeClass('_expanded');		
			$('.'+$(thisR)[0].id).addClass('collapse');
		}else{
			$('.expanded').addClass('collapse');
			$('.expanded').removeClass('expanded');
			$('._expanded').removeClass('_expanded');
			$('.'+$(thisR)[0].id).removeClass('collapse');
			$('.'+$(thisR)[0].id).addClass('expanded');
			$(thisR).addClass('_expanded');
		}
	}
	
	function makeReadable(value) {
		    if (value >= 1000) {
		        var suffixes = [' k', ' m', ' b',' t'];//No I18N
		        var d = Number.parseInt(value);
		        if(d<1000){
		                return number;
		        }
		        var exp = Math.floor((Math.log(d) / Math.log(1000)));
		        return Math.floor(d / Math.pow(1000, exp)) +" "+ suffixes[exp-1];
		    }
		    return value;
	}

</script>
<script>
	App = Ember.Application.create();
	App.Router.map(function(){
		this.route('instance',{path:'/instance/:instance'});
	});
	
	App.InstanceRoute =  Em.Route.extend({
		model: function(data){
			return Ember.$.getJSON('/accounts/admin/stats?get=true&instance='+data.instance).then(function(data){
				var s =  data.stats;
				for(var i in s){
					if(!Number.isNaN(Number.parseInt(i))){
						s[i].vr = makeReadable(s[i].v);
					}
				}
				if((new Date().getTime()) - data['cached-time'] > 60000){
					Ember.$.getJSON('/accounts/admin/stats?refresh=true'); //No I18N
				}
				return s.sort(function(a,b){
					return b.v - a.v;
				});
			});
		}
	});
	
	
	App.ApplicationRoute =  Em.Route.extend({
		model: function(){
			return Ember.$.getJSON('/accounts/admin/stats?instances=true').then(function(data){
				var stuffed = {}, ret = [];
				for(var i in data){
					if(!Number.isNaN(Number.parseInt(i))){
						var str = data[i];
						if(str.indexOf('_')>0){
							var ins = str.substring(0,str.indexOf('_'));
							if(stuffed.hasOwnProperty(ins)){
								stuffed[ins].push(str.substring(str.indexOf('_')+1, str.length));
							}else{
								stuffed[ins] = [str.substring(str.indexOf('_')+1, str.length)];
							}
						}else{
							stuffed[str] = null;
						}
					}
				}
				for(var i in stuffed){
					if(stuffed[i] && stuffed[i].length==1){
						ret.push({'i':i+'_'+stuffed[i][0],'s':null});
					}else{
						ret.push({'i':i,'s':stuffed[i]});						
					}
				}
				return ret.sort(function(a,b){
					return b.i.toLowerCase() < a.i.toLowerCase() ? 1 : -1;
				});
			});
		}
	});
	
	
	App.ApplicationController = Ember.Controller.extend({
		actions : {
			onSearch : function(e) {
				$.each($("table").find("tr"), function() { //No I18N
					if ($(this).text().toLowerCase().indexOf(e.toLowerCase()) == -1)
						$(this).hide();
					else
						$(this).show();
				});
				return false;
			},
			openFirst: function() {
				this.transitionToRoute('/instance/' + this.get('model')[0].i);
			}
		},
	    init: function () {
			    this._super();
			    if(!window.location.hash){
			    	Ember.run.schedule("afterRender",this,function() {
			      		this.send("openFirst");
			    	});
			    }
	    }
	});
 </script>