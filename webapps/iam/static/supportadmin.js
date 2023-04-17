//$Id$
function getUserEmails(f){
	var email = f.email.value.trim();
	if(isEmpty(email)){
		showerrormsg("Invalid Email/UserName"); //No I18N
		return false;
	}
	var params = "email="+euc(email)+"&"+csrfParam; //No I18N
	var resp = getPlainResponse("/support/email/fetch", params); //No I18N
	if(isJson(resp)){
		if(resp=="null"){
			de("nouser").style.display='block';
			return false;
		}
		de("nouser").style.display='none';
		var list="<table class='usremailtbl' border='1' cellpadding='4'><tr><td class='usrinfoheader'>Email Address</td><td class='usrinfoheader'>Type</td><td class='usrinfoheader'>Status</td><td class='usrinfoheader'>Created Time</td><td class='usrinfoheader'>Options</td></tr>"; //No I18N
		var useremails = JSON.parse(resp);
		if(useremails==null){
			showerrormsg("No Emails"); //No I18N
			return false;
		}
		var prim = useremails.PRIMARY;
		for(var i=0;i<useremails.EMAILS.length;i++){
			var ue = useremails.EMAILS[i];
			list += "<tr><td>"+ue.email+"</td><td>"+ue.type+"</td><td>"+ue.status+"</td><td>"+new Date(ue.created)+"</td>"; //No I18N
			if(prim>1 && ue.type=="Primary"){ //No I18N
				list += "<td><div class='savebtn' onclick=updateEmail('" +ue.email + "','delete')><span class='cbtnlt'></span><span class='cbtnco'>Delete</span><span class=cbtnrt'></span></div><div class='savebtn' onclick=updateEmail('"+ue.email+"','update',"+prim+")><span class='cbtnlt'></span><span class='cbtnco'>Make This Secondary</span><span class='cbtnrt'></span></div></td>"; //No I18N
			}else if(prim<2 && ue.type=="Primary"){ //No I18N
				list += "<td><div style='color : #7e7e7f;'>No Options</div></td>"; //No I18N
			}
			if(ue.type!="Primary"){ //No I18N
				list += "<td><div class='savebtn' onclick=updateEmail('" +ue.email + "','delete')><span class='cbtnlt'></span><span class='cbtnco'>Delete</span><span class=cbtnrt'></span></div><div class='savebtn' onclick=updateEmail('"+ue.email+"','update',"+prim+")><span class='cbtnlt'></span><span class='cbtnco'>Make This Primary</span><span class='cbtnrt'></span></div></td>" //No I18N
			}
			list+="</tr>"
		}
		de("emailListDiv").innerHTML = list;
		de("emailListDiv").style.display = 'block';
		return false;
	}
	de("emailListDiv").style.display = 'none';
	showerrormsg(resp);
	return false;
}

function updateEmail(email,action,prim){
	if(isEmpty(email)){
		showerrormsg("Invalid Email/UserName"); //No I18N
		return false;		
	}
	var params="email="+euc(email)+"&type="+euc(action)+"&"+csrfParam; //No I18N
	if(!isEmpty(prim)){
		params+="&prim="+prim; //No I18N
	}
	if(confirm("Are you Sure you want to "+action+" "+email+"?")){ //No I18N
		showverificationform(contextpath+"/support/email/update", params, emailResponse); //No I18N		
	}
	return false;
}

function emailResponse(resp){
	if(resp=="SUCCESS"){ //No I18N
		hideverificationform();
		getUserEmails(document.getEmails);
		showsuccessmsg(resp);
		return false;
	}
	if(resp!="INVALID_ADMINPASSWORD"){ //No I18N
		hideverificationform();
	}
	showerrormsg(resp);
	return false;
}

function getDomain(f){
	var domain = f.domain.value.trim();
	if(isEmpty(domain) || !isDomain(domain)){
		showerrormsg("Invalid Domain"); //No I18N
		return false;
	}
	loadui("ui/support/domain.jsp?domainName="+euc(domain)); //No I18N
	return false;
}

function deleteDomain(f){
	var domain = f.domain.value.trim();
	if(isEmpty(domain) || !isDomain(domain)){
		showerrormsg("Invalid Domain"); //No I18N
		return false;
	}
	if(confirm("Are you Sure you want to delete the domain "+ domain + "?")){ //No I18N
		var params = "domain="+euc(domain)+"&"+csrfParam; //No I18N
		showverificationform("/support/domain/delete", params, deleteDomainResponse); //No I18N
	}
	return false;
}

function deleteDomainResponse(resp){
	if(resp.trim()=="SUCCESS"){ //No I18N
		hideverificationform();
		loadui("ui/support/domain.jsp"); //No I18N
		showsuccessmsg("Domain Deleted Successfully"); //No I18N
	}
	else{
		if(resp!="INVALID_ADMINPASSWORD"){ //No I18N
			hideverificationform();
		}
		showerrormsg(resp);
	}
	return false;
}

function isJson(response){
	try{
		var obj = JSON.parse(response);
		return true;
	}catch(Exception){
		return false;
	}
}

function isEmptyJson(obj) {
    for(var prop in obj) {
        if(obj.hasOwnProperty(prop)){
        	return false;
        }
    }
    return true;
}

function getSecurityqa(f){
	var email = f.email.value.trim();
	if(isEmpty(email)){
		showerrormsg("Invalid Email/UserName"); //No I18N
		return false;
	}
	var params = "email="+euc(email)+"&pwd=''&type="+euc("get")+"&"+csrfParam; //No I18N
	var resp = getPlainResponse("/support/securityqa", params); //No I18N
	if(isJson(resp)){
		var g = document.deletesecurityqa;
		var obj = JSON.parse(resp);
		if(obj!=null){
			g.zuid.value = obj.parent.zuid;
			g.email.value = email;
			g.question.value = obj.question;
			g.answer.value = obj.answer;
		}
		f.reset();
		f.style.display='none';
		g.style.display='block';
	}else{
		resp = resp.trim();
		showerrormsg(resp);
	}
	return false;
}

function deleteSecurityqa(f){
	var email = f.email.value.trim();;
	if(isEmpty(email) || ! isEmailId(email)){
		showerrormsg("Ivalid Email"); //No I18N
		return false;
	}
	if(confirm("Are you Sure you want to delete security Question?")){ //No I18N
		var params = "email="+euc(email)+"&type="+euc("delete")+"&"+csrfParam; //No I18N
		showverificationform("/support/securityqa", params, deleteSecurityqaResponse); //No I18N	
	}
	return false;
}

function deleteSecurityqaResponse(resp){
	resp = resp.trim();
	if(resp=="SUCCESS"){ //No I18N
		hideverificationform();
		document.deletesecurityqa.reset(); 
		document.deletesecurityqa.style.display='none'; 
		document.securityqa.style.display='block';
		showsuccessmsg("Deleted Successfully"); //No I18N
	}
	else{
		resp = resp.trim();
		if(resp!="INVALID_ADMINPASSWORD"){ //No I18N
			hideverificationform();
		}
		showerrormsg(resp);
	}
	return false;	
}

var orgmap;
function getOrgPolicy(f){
	var zoid = f.zoid.value.trim();
	if(isEmpty(zoid) || isNaN(zoid)){
		showerrormsg("Invalid ZOID"); //No I18N
		return false;
	}
	var params="zoid="+euc(zoid)+"&"+csrfParam; //No I18N
	var resp = getPlainResponse("/support/orgpolicy/fetch", params) //No I18N
	if(isJson(resp)){
		orgmap = JSON.parse(resp);
		orgmap.ZOID=zoid;
		var customcount=0;
		var custom = "<select class='select select2Div' onclick='showAppList(this)' name='policykey'><option value=''>Select the New Policy Name</option>"; //No I18N
		if(orgmap.API_ACCESS_ALLOWED==null){ 
			custom+= "<option value='API_ACCESS_ALLOWED'>API_ACCESS_ALLOWED</option>"; //No I18N
			customcount++;
		}
		if(orgmap.RESTRICTED_API_ACCESS==null){ 
			custom+= "<option value='RESTRICTED_API_ACCESS'>RESTRICTED_API_ACCESS</option>"; //No I18N
			customcount++;
		}
		if(orgmap.MAX_CHILD_ACCOUNT==null){ 
			custom+= "<option value='MAX_CHILD_ACCOUNT'>MAX_CHILD_ACCOUNT</option>"; //No I18N
			customcount++;
		}
		var apps="<select class='select select2Div' id='applistoption'><option value=''>Select a Service</option>" //No I18N
		var list = "<select class='select select2Div' name='policykey' onchange=getValue(this)><option value=''>Select a Policy</option>"; //No I18N
		var appcount=0;
		for(var key in orgmap){
			if(key=="ZOID"){ //No I18N
				continue;
			}
			if(key=="APP_ACCOUNT_LIST"){
				for(var i=0;i<orgmap[key].length;i++){
					var app = orgmap[key][i];
					if(orgmap[app.app_name.toUpperCase()+"_APP_ACCOUNT_COUNT_SUFIX"]==null){ //No I18N
						apps += "<option value='"+app.app_name+"'>"+app.app_name+"</option>"; //No I18N
						appcount++;
					}
				}
				if(orgmap[key].length<=appcount){
					custom+= "<option value='_APP_ACCOUNT_COUNT_SUFIX'>_APP_ACCOUNT_COUNT_SUFIX</option>"; //No I18N
					customcount++;
				}
				continue;
			}
			list += "<option value='"+key+"'>"+key+"</option>"; //No I18N
		}
		list+="</select>"; //No I18N
		apps+="</select>"; //No I18N
		custom+="</select>"; //No I18N
		document.newPolicy.reset();
		de("orgpolicy").style.display='block';
		de('policyMap').innerHTML = list;
		de("applistitems").innerHTML = apps;
		de("custompolicylist").innerHTML = custom;
		de("addNewPolicy").style.display='none';
		de("orgpolicy").style.display='block';
		de("appliedValue").innerHTML = '';
		de("newValue").innerHTML = '';

		
		if(customcount<1){
			de("addNewPolicyButton").style.display='none';
		}else{
			de("addNewPolicyButton").style.display='block';
		}

	}
	else{
		showerrormsg(resp);
	}
	return false;
}

function getValue(f){
	var key = f.value;
	if(key==''){
		de("appliedValue").innerHTML = '';
		de("newValue").innerHTML ='';
		return false;
	}
	switch(orgmap[key]+""){
	case '-1' :
		de("appliedValue").innerHTML = 'No Members'; //No I18N
		de("newValue").innerHTML = "<select name='policyvalue' class='select'><option value='-1' selected>No Members</option><option value='0'>All Members</option><option value='1'>Moderators</option><option value='2'>Super Admin</option></select>"; //No I18N
		break;
	case '0' :
		de("appliedValue").innerHTML = 'All Members'; //No I18N
		de("newValue").innerHTML = "<select name='policyvalue' class='select'><option value='-1'>No Members</option><option value='0' selected>All Members</option><option value='1'>Moderators</option><option value='2'>Super Admin</option></select>"; //No I18N
		break;
	case '1' :
		de("appliedValue").innerHTML = 'Moderators'; //No I18N
		de("newValue").innerHTML = "<select name='policyvalue' class='select'><option value='-1'>No Members</option><option value='0'>All Members</option><option value='1' selected>Moderators</option><option value='2'>Super Admin</option></select>"; //No I18N
		break;
	case '2' :
		de("appliedValue").innerHTML = 'SuperAdmin'; //No I18N
		de("newValue").innerHTML = "<select name='policyvalue' class='select'><option value='-1'>No Members</option><option value='0'>All Members</option><option value='1'>Moderators</option><option value='2' selected>Super Admin</option></select>"; //No I18N
		break;
	case 'true':
		de("appliedValue").innerHTML = 'TRUE'; //No I18N
		de("newValue").innerHTML = "<select name='policyvalue' class='select'><option value='true' selected>TRUE</option><option value='false'>FALSE</option></select>"; //No I18N
		break;
	case 'false':
		de("appliedValue").innerHTML = 'FALSE'; //No I18N
		de("newValue").innerHTML = "<select name='policyvalue' class='select'><option value='true' >TRUE</option><option value='false' selected>FALSE</option></select>"; //No I18N
		break;
	default:
		de("appliedValue").innerHTML = orgmap[key];
		de("newValue").innerHTML = "<input type='text' class='input' name='policyvalue'>"; //No I18N
		break;
	}
	return false;
}

function showAppList(f){
	var v = f.value;
	if(v=="_APP_ACCOUNT_COUNT_SUFIX"){ //No I18N
		de("applist").style.display='block';
	}
	else{
		de("applistoption").value='';
		de("applist").style.display='none';
	}
	return false;
}

function updateOrgPolicy(f,type){
	var policyKey = f.policykey.value;
	if(policyKey==''){
		showerrormsg("Please Select Valid Policy"); //No I18N
		return false;
	}
	var app = '';
	if(f.applistoption){
		app = f.applistoption.value;
	}
	var policyValue = '';
	if(f.policyvalue && f.policyvalue.value){
		policyValue = f.policyvalue.value.trim();
	}else if(type!="delete"){ //No I18N
		showerrormsg("Please Enter Valid Policy Value"); //No I18N
		f.policyValue.focus();
		return false;
	}
	if(policyKey == "_APP_ACCOUNT_COUNT_SUFIX"){ //No I18N
		policyKey = app.toUpperCase() +policyKey;
	}
	var params = "type="+euc(type)+"&key="+euc(policyKey)+"&zoid="+euc(orgmap.ZOID)+"&"+csrfParam; //No I18N
	if(type!="delete"){ //No I18N
		if(policyValue=='' && policyValue!='true' && policyValue!='false' && isNan(policyValue) ){
			showerrormsg("Enter Valid Value"); //No I18N
			return false;
		}
		params += "&value="+euc(policyValue); //No I18N
	}
	if(confirm("Are you sure you want to "+type+" the orgpolicy?")){ //No I18N
		showverificationform("/support/orgpolicy/update", params, updateOrgPolicyResponse); //No I18N
	}
	return false;
}

function updateOrgPolicyResponse(resp){
	if(resp=="SUCCESS"){ //No I18N
		hideverificationform();
		getOrgPolicy(document.getzoid);
		initSelect2();
		showsuccessmsg("Org Policy Updated Successfully"); //No I18N
		document.updatePolicy.policykey.value = '';
		getValue(document.updatePolicy.policykey);
		de("applistoption").value=''; //No I18N
		de("applist").style.display='none';
		return false;
	}
	showerrormsg(resp);
	if(resp!="INVALID_ADMINPASSWORD"){ //No I18N
		hideverificationform();
	}
	return false;
}

function getEmailDigest(f){
	var email = f.email.value.trim();
	if(isEmpty(email) || !isEmailId(email)){
		showerrormsg("Invalid Email"); //No I18N
		return false;
	}
	var params = "email="+euc(email)+"&"+csrfParam; //No I18N
	var resp = getPlainResponse("/support/digest", params); //No I18N
	if(isJson(resp)){
		var digests = JSON.parse(resp);
		var list="";
		for(var type in digests){
			list += "<p style='padding : 10px;'>"+type+"</p><table class ='usremailtbl' border='1'><tr><td class='usrinfoheader'>ZID</td><td class='usrinfoheader'>ZID_TYPE</td><td class='usrinfoheader'>Service_URL</td><td class='usrinfoheader'>APP_NAME</td><td class='usrinfoheader'>IS_VALID</td><td class='usrinfoheader'>DIGEST</td><td class='usrinfoheader'>Created_Time</td></tr>"; //No I18N
			for(var i=0; i<digests[type].length; i++){
				var digest = JSON.parse(digests[type][i]);
				list+= "<tr><td>"+digest.zid+"</td><td>"+digest.zid_type+"</td>"; //No I18N
				list+= "<td><div style='width: 250px; word-wrap: break-word;'>"+digest.service_url+"</div></td><td>"+digest.app_name+"</td><td>"+digest.is_validated+"</td>"; //No I18N
				list+= "<td><div style='width: 250px; word-wrap: break-word;'>"+digest.digest+"</div></td><td>"+new Date(digest.created_time)+"</td></tr>"; //No I18N
			}
			list+= "</table>"; //No I18N
		}
		de("digestDetails").style.display="block";
		list+="</table>"; //No I18N
		de("digestDetails").innerHTML = list;
	}
	else{
		showerrormsg(resp);
	}
	return false;
}

function getScreenMobile(f){
	var email = f.email.value.trim();
	if(isEmpty(email)){
		showerrormsg("Invalid Email/UserName");  //No I18N
		return false;
	}
	var params = "email="+euc(email)+"&"+csrfParam; //No I18N
	var resp = getPlainResponse("/support/screenname/fetch", params); //No I18N
	if(isJson(resp)){
		var obj = JSON.parse(resp);
		var set = new Set();
		var list="<p style='padding:10px;'>Login Names</p>"; //No I18N
		if(obj.ScreenName==null && obj.MobileScreenName==null){
			list+=nodata;
		}
		else{
			list += "<table class='usremailtbl' border='1' cellpadding='4'><tr><td width='22%' class='usrinfoheader'>Login Name</td><td width='22%' class='usrinfoheader'>Type</td><td width='22%' class='usrinfoheader'>Login Enabled</td><td class='usrinfoheader'>Options</td></tr>";  //No I18N
			if(obj.ScreenName!=null){
				for(var i=0;i<obj.ScreenName.length;i++){
					var data = JSON.parse(obj.ScreenName[i]);
					var button = "<div class='savebtn' onclick='updateScreenName("+data.screen_name+",1)'><span class='cbtnlt'></span><span class=cbtnco>Delete</span><span class=cbtnrt></span></div>";  //No I18N
					list+="<tr><td>"+data.screen_name+"</td><td>ScreenName</td><td>"+data.is_login_name+"</td><td>"+button+"</td></tr>";  //No I18N
				}
			}
			var nodata = "<div id='nouser' class='nosuchusr' style='display:block;'><p align='center'>No Data</p></div>";  //No I18N	
			
			if(obj.MobileScreenName!=null){
				for(var i=0;i<obj.MobileScreenName.length;i++){
					var data = JSON.parse(obj.MobileScreenName[i]);
					var button = "<div class='savebtn' onclick='updateScreenName(\""+data.mobile_screen_name+"\",2)'><span class='cbtnlt'></span><span class=cbtnco>Delete</span><span class=cbtnrt></span></div>";  //No I18N
					list+="<tr><td>"+data.mobile_screen_name+"</td><td>MobileScreenName</td><td>true</td><td>"+button+"</td></tr>"; //No I18N
					var num = data.mobile_screen_name.split('-');
					set.add(num[num.length-1]);
				}
			}
			list+="</table>"; //No I18N
		}
		var mob="<p style='padding:10px;'>User Mobile List</p>"; //No I18N
		if(obj.UserMobile!=null){
			mob += "<table class='usremailtbl' border='1' cellpadding='4'><tr><td width='22%' class='usrinfoheader'>Mobile Number</td><td width='22%' class='usrinfoheader'>Status</td><td width='22%' class='usrinfoheader'>Is Primary</td><td class='usrinfoheader'>Options</td></tr>"; //No I18N
			for(var i=0;i<obj.UserMobile.length;i++){
				var data = JSON.parse(obj.UserMobile[i]);
				var button = "<div class='savebtn' onclick='updateMobile("+data.parent.zaid+","+data.parent.zuid+","+data.mobile+",\"update\",\""+data.country_code+"\")'><span class='cbtnlt'></span><span class=cbtnco>Make This ScreenName</span><span class=cbtnrt></span></div>"; //No I18N
				var conf = "<div class='savebtn' onclick='updateMobile("+data.parent.zaid+","+data.parent.zuid+","+data.mobile+",\"verify\")'><span class='cbtnlt'></span><span class=cbtnco>Verify</span><span class=cbtnrt></span></div>"; //No I18N

				mob+="<tr><td>"+data.mobile+" ("+data.country_code+")</td><td>"+ (data.is_verified ? 'Confirmed' : 'UnConfirmed') +"</td><td>"+ (data.is_primary? 'Primary' : 'Secondary') +"</td><td>"; //No I18N
				if(!set.has(data.mobile)){
					mob+= "&nbsp;&nbsp;&nbsp;" + button; //No I18N
				}
				if(!data.is_verified){
					mob+= "&nbsp;&nbsp;&nbsp;" + conf; //No I18N
				}
				mob+="</td></tr>" //No I18N
			}
			mob+="</table>"; //No I18N
		}
		else{
			mob+=nodata;
		}
		de('screenname').innerHTML = list;
		de('screenname').style.display = 'block';
		
		de('usermobile').innerHTML = mob;
		de('usermobile').style.display = 'block';
	}else{
		showerrormsg(resp);
	}
	return false;
}

function updateScreenName(id,code){
	if(isEmpty(id)){
		showerrormsg("Invalid ScreenName"); //No I18N
		return false;
	}
	var params = "id="+euc(id)+"&type="+euc('delete')+"&code="+euc(code)+"&"+csrfParam; //No I18N
	if(confirm("Are you sure you want to Delete ScreenName?")){ //No I18N
		showverificationform("/support/screenname/update", params, updateScreenNameResponse); //No I18N
	}
	return false;
}

function updateScreenNameResponse(resp){
	if(resp=="SUCCESS"){ //No I18N
		hideverificationform();
		getScreenMobile(document.getEmail)
		showsuccessmsg("Screen Name Successfully Deleted"); //No I18N
	}
	else{
		if(resp!="INVALID_ADMINPASSWORD"){ //No I18N
			hideverificationform();
		}
		showerrormsg(resp);
	}
	return false;
}

function updateMobile(zaid,zuid,id,type,code){
	if(isEmpty(zaid) || isEmpty(zuid)){
		showerrormsg("INVALID DATA"); //No I18N
		return false;
	}
	var params = "zaid="+euc(zaid)+"&zuid="+euc(zuid)+"&type="+euc(type)+"&id="+euc(id)+"&code="+euc(code)+"&"+csrfParam; //No I18N
	if(confirm("Are you sure you want to "+type+" this Mobile?")){ //No I18N
		showverificationform("/support/screenname/update", params, updateMobileResponse); //No I18N
	}
	return false;
}

function updateMobileResponse(resp){
	if(resp=="SUCCESS"){ //No I18N
		hideverificationform();
		getScreenMobile(document.getEmail)
		showsuccessmsg("Mobile Number Successfully Updated"); //No I18N
	}
	else{
		if(resp!="INVALID_ADMINPASSWORD"){ //No I18N
			hideverificationform();
		}
		showerrormsg(resp);
	}
	return false;	
}

function getServiceOrgs(f){
	var email = f.email.value.trim();
	if(isEmpty(email)){
		showerrormsg("Invalid Email/UserName");  //No I18N
		return false;
	}
	var type = f.serviceorgtype.value.trim();
	if(type==''){
		showerrormsg("Select A Valid ServiceOrg"); //No I18N
		return false;
	}
	var params = "email="+euc(email)+"&type="+euc(type)+"&"+csrfParam; //No I18N
	var resp = getPlainResponse("/support/defserviceorg/fetch", params); //No I18N
	if(isJson(resp)){
		var obj = JSON.parse(resp);
		if((obj.SORG==null ||obj.SORG.length <1) && obj.DEFAULT == null){
			showerrormsg("No ServiceOrg For the User"); //No I18N
			return false;
		}
		var list = "<br><br><table class ='usremailtbl' border='1' cellpadding='4'><tr><th class='usrinfoheader'>ZSOID</th><th class='usrinfoheader'>ORG NAME</th><th class='usrinfoheader'>Action</th></tr>"; //No I18N
		if(obj.DEFAULT!=null){
			list+= "<tr><td width='40%' align='center'>"+obj.DEFAULT.ZSOID+"</td><td width='40%' align='center'>"+obj.DEFAULT.ORG_NAME+"</td><td width='40%'  style='color: #005bec;font-weight: bold;' align='center'>Default</td></tr>"; //No I18N
		}
		for(var i=0;i<obj.SORG.length;i++){
			var sorg = obj.SORG[i]; align='center'
			var button = "<div class='savebtn' onclick='makeThisDefault("+sorg.ZSOID+","+sorg.ORG_TYPE+","+sorg.ZUID+")'><span class='cbtnlt'></span><span class=cbtnco>Make This Default</span><span class=cbtnrt></span></div>"; //No I18N
			list += "<tr><td width='44%' align='center'>"+sorg.ZSOID+"</td><td width='44%' align='center'>"+sorg.ORG_NAME+"</td>"; //No I18N
			if(obj.SORG.length>0 && (obj.DEFAULT == null || obj.DEFAULT.zsoid != sorg.zsoid)){
				list+= "<td align='center'>"+button+"</td></tr>"; //No I18N
			}
			else{
				list+= "<td align='center'><div style='color : #7e7e7f;'>No Options</div></td></tr>"; //No I18N
			}

		}
		list+="</table>"; //No I18N
		de("serviceorgdetails").innerHTML = list;
		de("serviceorgdetails").style.display='block'	
	}
	else{
		showerrormsg(resp);
	}
}

function makeThisDefault(zsoid,type,zuid){
	var params = "zsoid="+euc(zsoid)+"&type="+euc(type)+"&zuid="+euc(zuid)+"&"+csrfParam; //No I18N
	if(confirm("Are You Sure?")){ //No I18N
		showverificationform("/support/defserviceorg/set", params, setDefaultResponse); //No I18N
	}
	return false;
}

function setDefaultResponse(resp){
	if(resp=="SUCCESS"){ //No I18N
		hideverificationform();
		getServiceOrgs(document.useremail);
		showsuccessmsg("SUCCESSFULLY SET DEFAULT"); //No I18N
	}
	else{
		if(resp!="INVALID_ADMINPASSWORD"){ //No I18N
			hideverificationform();
		}
		showerrormsg(resp);
	}
	return false;
}

function getExternalUsers(f){
	de('externalUsersDiv').style.display='none';
	var zaaid = f.zaaid.value.trim();
	if(isEmpty(zaaid) || isNaN(zaaid)){
		showerrormsg("INVALID ZOHOONE ORGID"); //No I18N
		return false;
	}
	var params = "zaaid="+euc(zaaid)+"&"+csrfParam; //No I18N
	var resp = getPlainResponse("/support/externalusers/fetch", params); //No I18N
	if(isJson(resp)){
		var obj = JSON.parse(resp);
		var list="<table width=50% cellspacing='10'>"; //No I18N
		for(var i=0;i<obj.length;i++){
			var button = "<span class='removeEDicon hideicon' onclick='removeUser("+zaaid+","+obj[i].zuid+")'>&nbsp;</span>"; //No I18N
			list+="<tr><td>"+obj[i].zuid+"</td><td>"+((obj[i].user_status == '1') ? 'Active' : 'Inactive' )+"</td><td>"+button+"</tr>"; //No I18N
		}
		
		list+="</table>"; //No I18N
		de('externalList').innerHTML = list;
		de('externalUsersDiv').style.display = 'block';
	}else{
		showerrormsg(resp);
	}
	return false;
}

function removeUser(zaaid,zuid){
	if(isEmpty(zuid)){
		showerrormsg("INVALID ZUID"); //No I18N
		return false;
	}
	var params = "zuid="+euc(zuid)+"&zaaid="+euc(zaaid)+"&"+csrfParam; //No I18N
	if(confirm("Are you sure you want to remove this user? -- "+zuid)){ //No I18N
		showverificationform("/support/externalusers/update", params, removeUserResponse); //No I18N
	}
	return false;
}

function removeAllUsers(f){
	var zaaid = f.zaaid.value.trim();
	if(isEmpty(zaaid) || isNaN(zaaid)){
		showerrormsg("INVALID ZAAID"); //No I18N
		return false;
	}
	var params = "zaaid="+euc(zaaid)+"&"+csrfParam; //No I18N
	if(confirm("Are you sure you want to remove all users?")){ //No I18N
		showverificationform("/support/externalusers/update", params, removeUserResponse); //No I18N
	}
	return false;
}

function removeUserResponse(resp){
	if(resp=="SUCCESS"){ //No I18N
		hideverificationform();
		getExternalUsers(document.getZaaid);
		showsuccessmsg("USER/USERS REMOVED SUCCESSFULLY"); //No I18N
	}
	else{
		if(resp!="INVALID_ADMINPASSWORD"){ //No I18N
			hideverificationform();
		}
		showerrormsg(resp);
	}
	return false;
}

function getOrgDetails(f){
	de('orgdetailsdiv').style.display='none';
	de('fetchorg').style.display='block'
	var zoid = f.zoid.value.trim();
	if(isEmpty(zoid) || isNaN(zoid)){
		showerrormsg("INVALID ZOID"); //No I18N
		return false;
	}
	var params ="zoid="+euc(zoid)+"&"+csrfParam; //No I18N
	var resp = getPlainResponse("/support/orgdetails/fetch", params); //No I18N
	if(isJson(resp)){
		var obj = JSON.parse(resp);
		if(obj.CONTACT!=null){
			var g =document.orgdetails;
			g.zoid.value = zoid;
			g.oldcontact.value = obj.CONTACT;
			de('orgdetailsdiv').style.display='block';
			de('fetchorg').style.display='none'
		}
	}
	else{
		showerrormsg(resp);
	}
	return false;
}

function updateOrgDetails(f){
	var email= f.newcontact.value.trim();
	if(isEmpty(email) || !isEmailId(email)){
		showerrormsg("INVALID EMAIL ID"); //No I18N
		return false;
	}
	var zoid = f.zoid.value.trim();
	var params = "zoid="+euc(zoid)+"&email="+euc(email)+"&"+csrfParam; //No I18N
	if(confirm("Are you Sure to Update the "+zoid+" Org Contact to "+email+"?")){ //No I18N
		showverificationform("/support/orgdetails/update", params, updateOrgDetailsResponse); //No I18N
	}
	return false;
}

function updateOrgDetailsResponse(resp){
	if(resp=="SUCCESS"){ //No I18N
		hideverificationform();
		document.getzoid.reset();
		document.orgdetails.reset();
		de('orgdetailsdiv').style.display='none';
		de('fetchorg').style.display='block'
		showsuccessmsg("Org Contact Changed Successfully"); //No I18N
	}
	else{
		if(resp!="INVALID_ADMINPASSWORD"){ //No I18N
			hideverificationform();
		}
		showerrormsg(resp);
	}
	return false;
}

function showGroupOption(ele, show) {
    if(ele.className == 'disablerslink') {
        return false;
    }
    if(show) {
        de('dolink').className = 'disablerslink';
        de('dufolink').className = 'activerslink';
        
        de('groupdeletediv').style.display = '';
        de('groupmemberdeletediv').style.display = 'none';
        document.groupdelete.reset();

        de('grouptitle').innerHTML = 'Delete Group'; // No I18N
    } else {
        de('dufolink').className = 'disablerslink';
        de('dolink').className = 'activerslink';

        de('groupmemberdeletediv').style.display = '';
        de('groupdeletediv').style.display = 'none';
        document.groupmemberdelete.reset();

        de('grouptitle').innerHTML = 'Dissociate User from Group'; // No I18N
    }
    return false;
}

function deleteGroup(f){
	var zgid = f.zgid.value.trim();
	if(isEmpty(zgid) || (!isEmailId(zgid) && isNaN(zgid))){
		showerrormsg("Please Enter Valid ZGID/GroupEmail"); //No I18N
		f.zgid.focus();
		return false;
	}
	var params = ""; //No I18N
	if(isEmailId(zgid)){
		params += "id="+euc(zgid)+"&type="+euc("email"); //No I18N
	}
	if(!isNaN(zgid)){
		params+= "id="+euc(zgid)+"&type="+euc("id"); //No I18N
	}
	params += "&"+ csrfParam; //No I18N
	if(confirm("Are You Sure You want to delete this group "+zgid+" ?")){ //No I18N
		showverificationform("/support/group/delete", params, deleteGroupResponse); //No I18N
	}
	return false;
}

function deleteGroupResponse(resp){
	if(resp=="SUCCESS"){ //No I18N
		hideverificationform();
		document.groupdelete.reset();
		showsuccessmsg("Group Deleted Successfully"); //No I18N
	}
	else{
		if(resp!="INVALID_ADMINPASSWORD"){ //No I18N
			hideverificationform();
		}
		showerrormsg(resp);
	}
	return false;
}

function deleteGroupMember(f){
	var zgid = f.zgid.value.trim();
	if(isEmpty(zgid) || (!isEmailId(zgid) && isNaN(zgid))){
		showerrormsg("Please Enter Valid ZGID/GroupEmail"); //No I18N
		return false;
	}
	var params = ""; //No I18N
	if(isEmailId(zgid)){
		params += "id="+euc(zgid)+"&type="+euc("email"); //No I18N
	}
	if(!isNaN(zgid)){
		params+= "id="+euc(zgid)+"&type="+euc("id"); //No I18N
	}
	var email = f.email.value.trim();
	if(isEmpty(email) || !isEmailId(email)){
		showerrormsg("INVALID EMAIL ID"); //No I18N
		f.email.focus();
		return false;
	}
	params += "&email="+euc(email)+"&"+ csrfParam; //No I18N
	if(confirm("Are You Sure You want to delete this group "+zgid+" ?")){ //No I18N
		showverificationform("/support/group/delete", params, deleteGroupMemberResponse); //No I18N
	}
	return false;
}

function deleteGroupMemberResponse(resp){
	if(resp=="SUCCESS"){ //No I18N
		hideverificationform();
		document.groupmemberdelete.reset();
		showsuccessmsg("Group Member Deleted Successfully"); //No I18N
	}
	else{
		if(resp!="INVALID_ADMINPASSWORD"){ //No I18N
			hideverificationform();
		}
		showerrormsg(resp);
	}
	return false;
}

function deletePendingUser(f){
	var zoid = f.zoid.value.trim();
	if(isEmpty(zoid) || isNaN(zoid)){
		showerrormsg("INVALID ZOID"); //No I18N
		return false;
	}
	var email = f.email.value.trim();
	if(isEmpty(email) || !isEmailId(email)){
		showerrormsg("INVALID EMAIL ID"); //No I18N
		f.email.focus();
		return false;
	}
	var params = "email="+euc(email)+"&zoid="+euc(zoid)+"&"+csrfParam; //No I18N
	if(confirm("Are You Sure You Want to DELETE the Invitation to "+email+" ?")){ //No I18N
		showverificationform("/support/pendinguser/delete", params, pendingUserDeleteResponse) //No I18N
	}
	return false;
}

function pendingUserDeleteResponse(resp){
	if(resp == "SUCCESS"){ //No I18N
		hideverificationform();
		document.pendinguser.reset();
		showsuccessmsg("User Invitation Deleted Successfully"); //No I18N
	}
	else{
		if(resp!="INVALID_ADMINPASSWORD"){ //No I18N
			hideverificationform();
		}
		showerrormsg(resp);
	}
	return false;
}

//AppAccountOperations
function showAppAccOption(ele) {
    if(ele.className == 'disablerslink') {
        return false;
    }
	var can = document.getElementsByName('cancel'); //No I18N
	for(var i=0;i<can.length;i++){
		can[i].click();
	}
    var options = ["appacc","appaccser","accattr","accmem","appacclic"]; //No I18N
    for(var i=0 ; i<options.length; i++){
    	if(options[i]==ele.id){
    		ele.className = 'disablerslink';
    		de(ele.id+'div').style.display='block';
    	}else{
    		de(options[i]).className = 'activerslink';
    		de(options[i]+'div').style.display='none';
    	}
    }
    return false;
}

function getAppAcc(f){
	var zaaid = f.zaaid.value.trim();
	if(isEmpty(zaaid) || isNaN(zaaid)){
		showerrormsg("INVALID ZAAID"); //No I18N
		return false;
	}
	var params = "zaaid="+euc(zaaid)+"&"+csrfParam; //No I18N
	var resp = getPlainResponse("/support/appaccount/fetch", params); //No I18N
	if(isJson(resp)){
		var app = JSON.parse(resp);
		var g = document.appaccop;
		g.zaaid.value = zaaid;
		g.zaid.value = app.parent.zaid;
		g.currentstatus.value = app.account_status==1? 'Active' : app.account_status==2? 'Closed' : 'InActive'; //No I18N
		var list = "<select name='status' style= 'float:left;margin-left: 10px;' class='select'><option value=''>Status</option>";
		for(var i=0;i<3;i++){
			if(i==app.account_status){
				continue;
			}
			list+= "<option value='"+i+"'>"+ (i==1? 'Active' : i==2? 'Closed' : 'InActive' )  + "</option>"; //No I18N
		}
		list+="</select>"; //No I18N
		de('statuscontent').innerHTML = list; //No I18N
		f.style.display='none'
		de('editbtn').style.display='block';
		g.style.display='block'
	}
	else{
		showerrormsg(resp);
	}
}

function deleteAppAccount(f){
	var zaid = f.zaid.value.trim();
	if(isEmpty(zaid) || isNaN(zaid)){
		showerrormsg("INVALID ZAID"); //No I18N
		return false;
	}
	var zaaid = f.zaaid.value.trim();
	if(isEmpty(zaaid) || isNaN(zaaid)){
		showerrormsg("INVALID ZAAID"); //No I18N
		return false;
	}
	if(confirm("Are you sure to Delete the appaccount : "+zaaid)){ //No I18N
		var params = "zaid="+euc(zaid)+"&zaaid="+euc(zaaid)+"&"+csrfParam; //No I18N
		showverificationform("/support/appaccount/delete", params, appAccountOpsResponse) //No I18N
	}
	return false;
}

function updateAppAccountStatus(f){
	var zaaid = f.zaaid.value.trim();
	if(isEmpty(zaaid) || isNaN(zaaid)){
		showerrormsg("INVALID ZAAID"); //No I18N
		return false;
	}
	var status = f.status.value.trim();
	if(isEmpty(status) || status=='' && ( status!='1' || status !='2' || status!='0' )){
		showerrormsg('INVALID Staus'); //No I18N
		return false;
	}
	var params = "zaaid="+euc(zaaid)+"&status="+euc(status)+"&"+csrfParam; //No I18N
	if(confirm("Want to change AppAccount status?")){ //No I18N
		showverificationform("/support/appaccount/status",params,appAccountOpsResponse) //No I18N
	}
	return false;
}

function getAppAccSer(f){
	var zaaid = f.zaaid.value.trim();
	if(isEmpty(zaaid) || isNaN(zaaid)){
		showerrormsg("INVALID ZAAID"); //No I18N
		return false;
	}
	var subtype = f.subtype.value.trim();
	if(isEmpty(subtype) || subtype==''){
		showerrormsg('Select Valid Service'); // No I18N
		f.subtype.focus();
		return false;
	}
	var params = "zaaid="+euc(zaaid)+"&subtype="+euc(subtype)+"&"+csrfParam; //No I18N
	var resp = getPlainResponse("/support/appaccountservice/fetch", params); //No I18N
	if(isJson(resp)){
		var app = JSON.parse(resp);
		var g = document.appaccserop;
		g.zaaid.value = zaaid;
		g.subtype.value = subtype;
		g.currentstatus.value = app.account_status==1? 'Active' : app.account_status==2? 'Closed' : 'InActive'; //No I18N
		var list = "<select name='status' style= 'float:left;margin-left: 10px;' class='select'><option value=''>Status</option>";
		for(var i=0;i<3;i++){
			if(i==app.account_status){
				continue;
			}
			list+= "<option value='"+i+"'>"+ (i==1? 'Active' : i==2? 'Closed' : 'InActive' )  + "</option>"; //No I18N
		}
		list+="</select>"; //No I18N
		de('appaccserstatuscontent').innerHTML = list; //No I18N
		f.style.display='none'
		g.style.display='block'
	}
	else{
		showerrormsg(resp);
	}
}

function updateAppAccountServiceStatus(f){
	var zaaid = f.zaaid.value.trim();
	if(isEmpty(zaaid) || isNaN(zaaid)){
		showerrormsg("INVALID ZAAID"); //No I18N
		return false;
	}
	var status = f.status.value.trim();
	if(isEmpty(status) || status=='' && ( status!='1' || status !='2' || status!='0' )){
		showerrormsg('INVALID Staus'); //No I18N
		return false;
	}
	var subtype = f.subtype.value.trim();
	if(isEmpty(subtype) || subtype==''){
		showerrormsg('Invalid Service Type'); // No I18N
		return false;
	}
	var params = "zaaid="+euc(zaaid)+"&status="+euc(status)+"&subtype="+euc(subtype)+"&"+csrfParam; //No I18N
	if(confirm("Want to change AppAccountService status?")){ //No I18N
		showverificationform("/support/appaccountservice/status",params,appAccountOpsResponse) //No I18N
	}
	return false;
}


function getAppAccountWithRoles(f){
	var zaaid = f.zaaid.value.trim();
	if(isEmpty(zaaid) || isNaN(zaaid)){
		showerrormsg("INVALID ZAAID"); //No I18N
		return false;
	}
	var subtype = f.subtype.value.trim();
	if(isEmpty(subtype) || subtype==''){
		showerrormsg('Select Valid Service'); // No I18N
		return false;
	}
	var params = "zaaid="+euc(zaaid)+"&subtype="+euc(subtype)+"&"+csrfParam; //No I18N
	var resp = getPlainResponse("/support/appaccountservice/roles", params); //No I18N
	var rolecount = 0;
	if(isJson(resp)){
		var obj = JSON.parse(resp);
		if(obj.ROLES!=null){
			var list="<option value=''>Select The Role</option>"; //No I18N
				for(var i=0;i<obj.ROLES.length;i++){
					var data = JSON.parse(obj.ROLES[i]);
					list+="<option value='"+data.zarid+"'>"+data.role_name+"</option>"; //No I18N
				}
				rolecount = obj.ROLES.length;
		}
		var x = document.getElementsByClassName('roles'); //No I18N
		for(var i =0;i<x.length;i++){
			x[i].innerHTML=list;
		}
		var g = document.accmemop;
		g.zaaid.value = zaaid;
		g.subtype.value = subtype;
		f.style.display='none';
		g.style.display='block';
		de('plusroles').onclick = function(){ //No I18N
			addElement(this,3,rolecount);
		}
	}else{
		showerrormsg(resp);
	}
	return false;
}

function openOption(f){
	for(var i=0;i<3;i++){
		de('accmem'+i).style.display = 'none';
	}
	removeAllChildren(de('edipadd')); //No I18N
	removeAllChildren(de('edipupstatus')); //No I18N
	removeAllChildren(de('edipuprole')); //No I18N
	de('accmemshow').style.display = 'none';
	var value = f.value.trim();
	if(value==''){
		return false;
	}
	de('accmemsubmit').innerHTML = f.options[f.selectedIndex].innerText;
	de('accmemonclick').onclick = function (){ //No I18N
		updateAccMem(document.accmemop,value);
	}
	de('accmemshow').style.display = 'block';
	de('accmem'+value).style.display = 'block';

} 

function updateAccMem(f,option){
	var params = ""; //No I18N
	if(option=='0'){
		try{
			params = getParams(f);
			var x = document.getElementsByName("accmemadd"); //No I18N
			for(var i=0;i<x.length;i++){
				var zuid = x[i].getElementsByTagName('input')[0].value.trim();
				if(isEmpty(zuid) || isNaN(zuid)){
					showerrormsg("INVALID ZUID"); //No I18N
					x[i].getElementsByTagName('input')[0].focus;
					throw "";
				}
				params += "zuid="+euc(zuid)+"&"; //No I18N
				if(x[i].getElementsByTagName('select').length>0){
					var zarid = x[i].getElementsByTagName('select')[0].value.trim();
					if(zarid==""){
						showerrormsg("Please Select the Role"); //No I18N
						throw "";
					}
					params += "zarid="+euc(zarid)+"&"; //No I18N			
				}
			}
			if(confirm("Want to Add AccountMember?")){ //No I18N
				showverificationform("/support/accountmember/add",params,appAccountOpsResponse) //No I18N
			}			
		}catch(e){
			return false;
		}
	}
	if(option=='1'){
		try{
			params = getParams(f); //No I18N
			var roles = document.getElementsByName("accmemuprole"); //No I18N
			var status = document.getElementsByName("accmemupstatus"); //No I18N
			var json = {};
			var rolejson = [];
			var statjson = [];
			var dup={};
			for(var i=0;i<roles.length;i++){
				var role = roles[i].getElementsByTagName('select')[0].value.trim();
				var zuids = roles[i].getElementsByTagName('textarea')[0].value.trim();
				if(roles.length==1 && role=='' && zuids==''){
					continue;
				}
				if(isEmpty(role) || role == ''){
					showerrormsg("Please Select Role"); //No I18N
					roles[i].getElementsByTagName('select')[0].focus();
					throw "";
				}
				if(dup[role]!=null){
					showerrormsg("Select Different Role"); //No I18N
					roles[i].getElementsByTagName('select')[0].focus();
					throw "";
				}
				rj={};
				rj.roleid=role;
				rj.zuids=zuids;
				rolejson[i] = rj;
				dup[role]='a';
			}
			for(var i=0;i<status.length;i++){
				var stat = status[i].getElementsByTagName('select')[0].value.trim();
				var zuids = status[i].getElementsByTagName('textarea')[0].value.trim();
				if(status.length==1 && stat=='' && zuids==''){
					continue;
				}
				if(isEmpty(stat) || stat == ''){
					showerrormsg("Please Select Status"); //No I18N
					status[i].getElementsByTagName('select')[0].focus();
					throw "";
				}
				if(dup[stat]!=null){
					showerrormsg("Select Different Status"); //No I18N
					status[i].getElementsByTagName('select')[0].focus();
					throw "";
				}
				sj={};
				sj.status=stat;
				sj.zuids=zuids;
				statjson[i] = sj;
				dup[stat]='a';
			}
			if(isEmptyJson(rolejson) && isEmptyJson(statjson)){
				showerrormsg("Please Select a field"); //No I18N
				throw "";
			}
			if(!isEmptyJson(rolejson)){
				json.ROLES=rolejson;				
			}
			if(!isEmptyJson(statjson)){
				json.STATUS=statjson;				
			}
			params += "json="+euc(JSON.stringify(json)); //No I18N
		}catch(e){
			return false;
		}
		if(confirm("Want to Update AccountMember?")){ //No I18N
			showverificationform("/support/accountmember/update",params,appAccountOpsResponse) //No I18N
		}			
	}
	if(option=='2'){
		try{
			params = getParams(f);
			var zuids = f.delzuids.value.trim();
			if(isEmpty(zuids) || zuids==""){
				showerrormsg("Invalid Zuids"); //No I18N
				f.delzuids.focus();
			}
			params += "zuid="+euc(zuids); //No I18N
			if(confirm("Want to Delete AccountMember?")){ //No I18N
				showverificationform("/support/accountmember/delete",params,appAccountOpsResponse) //No I18N
			}			
		}catch(e){
			return false;
		}
	}
	
}

function getParams(f){
	var zaaid = f.zaaid.value.trim();
	if(isEmpty(zaaid) || isNaN(zaaid)){
		showerrormsg("INVALID ZAAID"); //No I18N
		throw "";
	}
	var subtype = f.subtype.value.trim();
	if(isEmpty(subtype) || subtype==''){
		showerrormsg('Select Valid Service'); // No I18N
		throw "";
	}
	var params= csrfParam +"&zaaid="+euc(zaaid)+"&subtype="+euc(subtype)+"&"; //No I18N
	return params;
}

function appAccountOpsResponse(resp){
	if(resp == "SUCCESS"){ //No I18N
		hideverificationform();
		var can = document.getElementsByName('cancel'); //No I18N
		for(var i=0;i<can.length;i++){
			can[i].click();
		}
		showsuccessmsg(resp);
	}
	else{
		if(resp!="INVALID_ADMINPASSWORD"){ //No I18N
			hideverificationform();
		}
		showerrormsg(resp);
	}
	return false;
}

function getAccountAttribute(f){
	var zaaid = f.zaaid.value.trim();
	if(isEmpty(zaaid) || isNaN(zaaid)){
		showerrormsg("INVALID ZAAID"); //No I18N
		return false;
	}
	var attr = f.attribute.value.trim();
	if(isEmpty(attr) || attr==''){
		showerrormsg('Invalid Attribute'); // No I18N
		return false;
	}
	var params = "zaaid="+euc(zaaid)+"&attribute="+euc(attr)+"&"+csrfParam; //No I18N
	var resp = getPlainResponse("/support/accountattribute/fetch", params); //No I18N
	if(isJson(resp) || resp=="NULL"){
		var g = document.accattrop;
		g.zaaid.value = zaaid;
		g.attribute.value =  attr;
		if(isJson(resp)){
			g.attrvalue.value = JSON.parse(resp).attribute_value;
		}else{
			g.attrvalue.value = '';
		}
		f.style.display='none'
		g.style.display='block'
	}else{
		showerrormsg(resp);
		return;
	}
}

function updateAccountAttribute(f){
	var zaaid = f.zaaid.value.trim();
	if(isEmpty(zaaid) || isNaN(zaaid)){
		showerrormsg("INVALID ZAAID"); //No I18N
		return false;
	}
	var attr = f.attribute.value.trim();
	if(isEmpty(attr) || attr==''){
		showerrormsg('Invalid Attribute'); // No I18N
		return false;
	}
	var value=f.attrvalue.value.trim();
	var params = "zaaid="+euc(zaaid)+"&attribute="+euc(attr)+"&value="+euc(value)+"&"+csrfParam; //No I18N
	if(confirm("Want to change Account Attribute?")){ //No I18N
		showverificationform("/support/accountattribute/update", params,appAccountOpsResponse) //No I18N
	}
	return false;
}

function getAppAccountLicense(f){
	var zaaid = f.zaaid.value.trim();
	if(isEmpty(zaaid) || isNaN(zaaid)){
		showerrormsg("INVALID ZAAID"); //No I18N
		return;
	}
	var subtype = f.subtype.value.trim();
	if(isEmpty(subtype) || subtype==''){
		showerrormsg('Select Valid Service'); // No I18N
		return;
	}
	var attr = f.attribute.value.trim();
	if(isEmpty(attr) || attr==''){
		showerrormsg("Enter Valid Attribute"); //No I18N
		f.attribute.focus();
		return;
	}
	var params= csrfParam +"&zaaid="+euc(zaaid)+"&subtype="+euc(subtype)+"&attribute="+euc(attr); //No I18N
	var resp = getPlainResponse("/support/appaccountlicense/fetch", params); //No I18N
	if(isJson(resp) || resp=="NULL"){
		var g = document.appacclicop;
		g.zaaid.value = zaaid;
		g.subtype.value = subtype;
		g.attribute.value =  attr;
		if(isJson(resp)){
			g.attrvalue.value = JSON.parse(resp).license_attribute_value;
		}else{
			g.attrvalue.value = '';
		}
		f.style.display='none'
		g.style.display='block'
	}else{
		showerrormsg(resp);
		return;
	}
}

function updateAppAccountLicense(f){
	params = getParams(f);
	var attr = f.attribute.value.trim();
	if(isEmpty(attr) || attr==''){
		showerrormsg("Enter Valid Attribute"); //No I18N
		f.attribute.focus();
		return;
	}
	var value=f.attrvalue.value.trim();
	params+= "attribute="+euc(attr)+"&value="+euc(value); //No I18N
	if(confirm("Want to change AppAccount License?")){ //No I18N
		showverificationform("/support/appaccountlicense/update", params,appAccountOpsResponse) //No I18N
	}
	return false;
}

function updateAppAccOwner(f) {
	var params = "";
	try{
		params = getParams(f);
	}catch (e) {
		return;
	}
	var zuid = f.zuid.value.trim();
	if(isEmpty(zuid) || zuid==''){
		showerrormsg("Enter Valid zuid"); //No I18N
		f.zuid.focus();
		return;
	}
	var role = f.role.value.trim();
	if(!isEmpty(role)) {
		params += "role="+euc(role)+"&"; //No I18N
	}
	params += "zuid="+euc(zuid); //No I18N
	if(confirm("Want to change AppAccount Owner?")){ //No I18N
		showverificationform("/support/appaccountowner/update", params,appAccOwnerResponse) //No I18N
	}
	return false;
}

function appAccOwnerResponse(resp){
	if(resp == "SUCCESS"){ //No I18N
		hideverificationform();
		showsuccessmsg(resp);
	}
	else{
		if(resp!="INVALID_ADMINPASSWORD"){ //No I18N
			hideverificationform();
		}
		showerrormsg(resp);
	}
	return false;
}

function showInviteClear(ele, show) {
	if(ele.className == 'disablerslink') {  // No I18N
        return false;
    }
    if(show) {
        de('dolink').className = 'disablerslink';  // No I18N
        de('dufolink').className = 'activerslink';  // No I18N
        
        de('clearinvitation').style.display = '';
        de('clearinvitationdetails').style.display = 'none';
        document.clearinv.reset();

        de('grouptitle').innerHTML = 'Clear Restriction in Invitations'; // No I18N
       
    } else {
        de('dufolink').className = 'disablerslink';   // No I18N
        de('dolink').className = 'activerslink';        // No I18N
        
        de('clearinvitationdetails').style.display = '';
        de('clearinvitation').style.display = 'none';
        document.clearinvdet.reset();

        de('grouptitle').innerHTML = 'Clear AppAccount specific invite restriction'; // No I18N
    }
    return false;
}

function clearInvitation(f){
	var zoid = f.zoid.value.trim();
	var email = f.email.value.trim();
	if(isEmpty(zoid) || isNaN(zoid)){
		showerrormsg("Please Enter Valid ZOID"); //No I18N
		f.zoid.focus();
		return false;
	}
	if(isEmpty(email) || !isEmailId(email)){
		showerrormsg("Please Enter Valid Email Address"); //No I18N
		f.email.focus();
		return false;
	}
	
	var params = ""; 
	params += "zoid="+euc(zoid)+"&email="+euc(email)+ "&"+ csrfParam;; //No I18N
	if(confirm("Are you sure about clearing invitation restriction for the user "+email+" ?")){ //No I18N
		showverificationform("/support/clear/invitation", params, clearInvitationResponse); //No I18N
	}
	return false;
	
}

function clearInvitationResponse(resp){
	if(resp == "SUCCESS"){ //No I18N
		hideverificationform();
		document.clearinv.reset();
		showsuccessmsg("Invitation Restriction cleared successfully"); //No I18N
	}
	else{
		if(resp!="INVALID_ADMINPASSWORD"){ //No I18N
			hideverificationform();
		}
		showerrormsg(resp);
	}
	return false;
}

function clearInvitationDetails(f){
	var zoid = f.zoid.value.trim();
	var email = f.email.value.trim();
	var invid = f.invid.value.trim();
	if(isEmpty(zoid) || isNaN(zoid)){
		showerrormsg("Please Enter Valid ZOID"); //No I18N
		f.zoid.focus();
		return false;
	}
	if(isEmpty(email) || !isEmailId(email)){
		showerrormsg("Please Enter Valid Email Address"); //No I18N
		f.email.focus();
		return false;
	}
	if(isEmpty(invid) || isNaN(invid)){
		showerrormsg("Please Enter Valid AppAccount invitation id"); //No I18N
		f.invid.focus();
		return false;
	}
	var params = ""; 
	params += "zoid="+euc(zoid)+"&email="+euc(email)+"&appInvid="+euc(invid)+ "&"+ csrfParam;; //No I18N
	if(confirm("Are you sure about clearing invitation restriction for the user "+email+" ?")){ //No I18N
		showverificationform("/support/clear/invitationDetails", params, clearInvitationDetailsResponse); //No I18N
	}
	return false;
}

function clearInvitationDetailsResponse(resp){
	if(resp == "SUCCESS"){ //No I18N
		hideverificationform();
		document.clearinvdet.reset();
		showsuccessmsg("Invitation Restriction cleared successfully"); //No I18N
	}
	else{
		if(resp!="INVALID_ADMINPASSWORD"){ //No I18N
			hideverificationform();
		}
		showerrormsg(resp);
	}
	return false;
}

//ServiceOrgOperations
function showSorgOption(ele) {
    if(ele.className == 'disablerslink') {
        return false;
    }
	var can = document.getElementsByName('cancel'); //No I18N
	for(var i=0;i<can.length;i++){
		can[i].click();
	}
    var options = ["sorg","sorgsub","sorgmem"]; //No I18N
    for(var i=0 ; i<options.length; i++){
    	if(options[i]==ele.id){
    		ele.className = 'disablerslink';
    		de(ele.id+'div').style.display='block';
    	}else{
    		de(options[i]).className = 'activerslink';
    		de(options[i]+'div').style.display='none';
    	}
    }
    return false;
}

function getServiceOrg(f){
	var type = f.type.value;
	if(isEmpty(type)) {
		showerrormsg("Please Select Valid ServiceOrg Type"); //No I18N
		f.type.focus();
		return false;
	}
	var zsoid = f.zsoid.value.trim();
	if(isEmpty(zsoid) || isNaN(zsoid)){
		showerrormsg("INVALID ZSOID"); //No I18N
		f.zsoid.focus();
		return false;
	}
	var params = "type="+euc(type)+"&zsoid="+euc(zsoid)+"&"+csrfParam; //No I18N
	var resp = getPlainResponse("/support/serviceorg/fetch", params); //No I18N
	if(isJson(resp)){
		var sorg = JSON.parse(resp);
		var g = document.sorgop;
		g.zsoid.value = zsoid;
		g.type.value = type;
		g.orgname.value = sorg.org_name;
		f.style.display='none';		
		g.style.display='block';
	}
	else{
		showerrormsg(resp);
	}
}

function updateServiceOrg(f,oldName) {
	var type = f.type.value;
	if(isEmpty(type)) {
		showerrormsg("Invalid ServiceOrg Type"); //No I18N
		return false;
	}
	var zsoid = f.zsoid.value.trim();
	if(isEmpty(zsoid) || isNaN(zsoid)){
		showerrormsg("INVALID ZSOID"); //No I18N
		return false;
	}
	var orgname = f.orgname.value.trim();
	if(isEmpty(orgname)) {
		showerrormsg("Please Enter Valid OrgName"); //No I18N
		f.orgname.focus();
		return false;
	}
	var params = "type="+euc(type)+"&zsoid="+euc(zsoid)+"&orgname="+euc(orgname)+"&"+csrfParam; //No I18N
	if(confirm("Want to update ServiceOrg?")){ //No I18N
		showverificationform("/support/serviceorg/update", params,serviceOrgOpsResponse) //No I18N
	}
	return false;
}

function getServiceOrgSubService(f) {
	var type = f.type.value;
	if(isEmpty(type)) {
		showerrormsg("Please Select Valid ServiceOrg Type"); //No I18N
		f.type.focus();
		return false;
	}
	var zsoid = f.zsoid.value.trim();
	if(isEmpty(zsoid) || isNaN(zsoid)){
		showerrormsg("INVALID ZSOID"); //No I18N
		f.zsoid.focus();
		return false;
	}
	var subtype = f.subtype.value;
	if(isEmpty(subtype)) {
		showerrormsg("Please Select Valid SubServiceOrg Type"); //No I18N
		f.subtype.focus();
		return false;
	}
	var params = "type="+euc(type)+"&zsoid="+euc(zsoid)+"&subtype="+euc(subtype)+"&"+csrfParam; //No I18N
	var resp = getPlainResponse("/support/serviceorgsubservice/fetch", params); //No I18N
	if(isJson(resp)){
		var sorgsub = JSON.parse(resp);
		var g = document.sorgsubop;
		g.zsoid.value = zsoid;
		g.type.value = type;
		g.subtype.value = subtype;
		g.status.value = sorgsub.account_status;
		g.zuid.value = sorgsub.zuid;
		de('sorgsubupbutton').onclick = function() { //No I18N
			updateServiceOrgSubService(g, sorgsub.account_status, sorgsub.zuid);
		}
		f.style.display='none';		
		g.style.display='block';
	}
	else{
		showerrormsg(resp);
	}
}

function updateServiceOrgSubService(f,oldstatus,oldzuid) {
	var type = f.type.value;
	if(isEmpty(type)) {
		showerrormsg("Invalid ServiceOrg Type"); //No I18N
		return false;
	}
	var zsoid = f.zsoid.value.trim();
	if(isEmpty(zsoid) || isNaN(zsoid)){
		showerrormsg("INVALID ZSOID"); //No I18N
		return false;
	}
	var subtype = f.subtype.value;
	if(isEmpty(type)) {
		showerrormsg("Invalid SubServiceOrg Type"); //No I18N
		return false;
	}
	var status = f.status.value.trim();
	if(isEmpty(status) || status=='' && ( status!='1' || status !='2' || status!='0' )){
		showerrormsg('INVALID Staus'); //No I18N
		return false;
	}
	var zuid = f.zuid.value.trim();
	if(isEmpty(zuid) || isNaN(zuid)){
		showerrormsg("INVALID ZUID"); //No I18N
		return false;
	}
	if(oldstatus == status  && oldzuid == zuid) {
		showerrormsg("No Change"); //No I18N
		return false;
	}
	var params = "type="+euc(type)+"&zsoid="+euc(zsoid)+"&subtype="+euc(subtype)+"&status="+euc(status)+"&zuid="+euc(zuid)+"&"+csrfParam; //No I18N
	if(confirm("Want to update ServiceOrgSubService?")){ //No I18N
		showverificationform("/support/serviceorgsubservice/update", params,serviceOrgOpsResponse) //No I18N
	}
	return false;
}

function chooseAction(val) {
	removeAllChildren(de('edipadd')); //No I18N
	de('sorgmemadd').style.display = 'none';
	removeAllChildren(de('edipupstatus')); //No I18N
	removeAllChildren(de('edipuprole')); //No I18N
	de('sorgmemupdate').style.display = 'none';
	de('sorgmemdelete').style.display = 'none';
	de('sorgmemact').style.display = 'none';
	switch (val) {
		case 'add' : //No I18N
		case 'update' : //No I18N
		case 'delete' : //No I18N
			de('memberbtn').innerText = val.toUpperCase() + " Member"; //No I18N
			de('sorgmemact').style.display = 'block';
			de('sorgmem'+val).style.display = 'block';
			break;
		default :
			de('sorgmemact').style.display = 'none';
			break;
	}
	return false;
}

function updateServiceOrgMember(f) {
	var type = f.type.value;
	if(isEmpty(type)) {
		showerrormsg("Invalid ServiceOrg Type"); //No I18N
		return false;
	}
	var zsoid = f.zsoid.value.trim();
	if(isEmpty(zsoid) || isNaN(zsoid)){
		showerrormsg("INVALID ZSOID"); //No I18N
		return false;
	}
	var opt = f.action.value;
	if(isEmpty(opt)) {
		showerrormsg("Invalid Action Chosen"); //No I18N
		return;
	}
	var params = "type="+euc(type)+"&zsoid="+euc(zsoid)+"&"+csrfParam+"&"; //No I18N 
	switch(opt) {
		case 'add' : //No I18N
			try{
				var x = document.getElementsByName("sorgmemadd"); //No I18N
				for(var i=0;i<x.length;i++){
					var zuid = x[i].getElementsByTagName('input')[0].value.trim();
					if(isEmpty(zuid) || isNaN(zuid)){
						showerrormsg("INVALID ZUID"); //No I18N
						x[i].getElementsByTagName('input')[0].focus;
						throw "";
					}
					params += "zuid="+euc(zuid)+"&"; //No I18N
					if(x[i].getElementsByTagName('select').length>0){
						var role = x[i].getElementsByTagName('select')[0].value.trim();
						if(role==""){
							showerrormsg("Please Select the Role"); //No I18N
							throw "";
						}
						params += "roles="+euc(role)+"&"; //No I18N			
					}
				}
				if(confirm("Want to Add ServiceOrgMember?")){ //No I18N
					showverificationform("/support/serviceorgmember/add",params,serviceOrgOpsResponse) //No I18N
				}			
			}catch(e){
				return false;
			}
			break;
		case 'update' : //No I18N
			try{
				var roles = document.getElementsByName("sorgmemuprole"); //No I18N
				var status = document.getElementsByName("sorgmemupstatus"); //No I18N
				var json = {};
				var rolejson = [];
				var statjson = [];
				var dup={};
				for(var i=0;i<roles.length;i++){
					var role = roles[i].getElementsByTagName('select')[0].value.trim();
					var zuids = roles[i].getElementsByTagName('textarea')[0].value.trim();
					if(roles.length==1 && role=='' && zuids==''){
						continue;
					}
					if(isEmpty(role) || role == ''){
						showerrormsg("Please Select Role"); //No I18N
						roles[i].getElementsByTagName('select')[0].focus();
						throw "";
					}
					if(dup[role]!=null){
						showerrormsg("Select Different Role"); //No I18N
						roles[i].getElementsByTagName('select')[0].focus();
						throw "";
					}
					rj={};
					rj.roleid=role;
					rj.zuids=zuids;
					rolejson[i] = rj;
					dup[role]='a';
				}
				for(var i=0;i<status.length;i++){
					var stat = status[i].getElementsByTagName('select')[0].value.trim();
					var zuids = status[i].getElementsByTagName('textarea')[0].value.trim();
					if(status.length==1 && stat=='' && zuids==''){
						continue;
					}
					if(isEmpty(stat) || stat == ''){
						showerrormsg("Please Select Status"); //No I18N
						status[i].getElementsByTagName('select')[0].focus();
						throw "";
					}
					if(dup[stat]!=null){
						showerrormsg("Select Different Status"); //No I18N
						status[i].getElementsByTagName('select')[0].focus();
						throw "";
					}
					sj={};
					sj.status=stat;
					sj.zuids=zuids;
					statjson[i] = sj;
					dup[stat]='a';
				}
				if(isEmptyJson(rolejson) && isEmptyJson(statjson)){
					showerrormsg("Please Select a field"); //No I18N
					throw "";
				}
				if(!isEmptyJson(rolejson)){
					json.ROLES=rolejson;				
				}
				if(!isEmptyJson(statjson)){
					json.STATUS=statjson;				
				}
				params += "json="+euc(JSON.stringify(json)); //No I18N
			}catch(e){
				return false;
			}
			if(confirm("Want to Update ServiceOrgMember?")){ //No I18N
				showverificationform("/support/serviceorgmember/update",params,serviceOrgOpsResponse) //No I18N
			}
			break;
		case 'delete' : //No I18N
			var zuids = f.delzuids.value.trim();
			if(isEmpty(zuids) || zuids==""){
				showerrormsg("Invalid Zuids"); //No I18N
				f.delzuids.focus();
			}
			params += "zuid="+euc(zuids); //No I18N
			if(confirm("Want to Delete ServiceOrgMember?")){ //No I18N
				showverificationform("/support/serviceorgmember/delete",params,serviceOrgOpsResponse) //No I18N
			}
			break;
	}
	return false;
}

function serviceOrgOpsResponse (resp) {
	if(resp == "SUCCESS"){ //No I18N
		hideverificationform();
		var can = document.getElementsByName('cancel'); //No I18N
		for(var i=0;i<can.length;i++){
			can[i].click();
		}
		showsuccessmsg(resp);
	}
	else{
		if(resp!="INVALID_ADMINPASSWORD"){ //No I18N
			hideverificationform();
		}
		showerrormsg(resp);
	}
	return false;
}

function getChildOrgTypes(f) {
	var type = f.type.value.trim();
	if(isEmpty(type)) {
		return false;
	}
	var params = csrfParam + "&type="+euc(type); //No I18N
	var resp = getPlainResponse("/support/serviceorg/childorg", params); //No I18N
	if(f.subtype) {
		f.subtype.innerHTML = resp;
	}
	return false;
}

function getRoles(f) {
	var type = f.subtype.value.trim();
	if(isEmpty(type)) {
		return false;
	}
	var params = csrfParam + "&type="+euc(type); //No I18N
	var resp = getPlainResponse("/support/app/roles", params); //No I18N
	if(f.role) {
		f.role.innerHTML = resp;
	}
	return false;
}

function changeUserRole(f) {
	var zuid = f.zuid.value.trim();
	if(isEmpty(zuid) || isNaN(zuid)) {
		showerrormsg("INVALID ZUID"); //No I18N
		return;
	}
	var role = f.role.value.trim();
	if(isEmpty(role) || isNaN(role)) {
		showerrormsg("Please select Valid Role"); //No I18N
		return;
	}
	var params = "zuid="+zuid+"&role="+role+"&"+csrfParam; //No I18N
	if(confirm("Want to Change User Role?")){ //No I18N
		showverificationform("/support/orgrole",params,changeUserRoleResponse) //No I18N
	}
	return false;
}

function changeUserRoleResponse(resp){
	if(resp == "SUCCESS"){ //No I18N
		hideverificationform();
		showsuccessmsg(resp);
	}
	else{
		if(resp!="INVALID_ADMINPASSWORD"){ //No I18N
			hideverificationform();
		}
		showerrormsg(resp);
	}
	return false;
}

function getUserDevices(f){
	var zuid = f.zuid.value.trim();
	if(isEmpty(zuid) || isNaN(zuid)){
		showerrormsg("Invalid zuid"); //No I18N
		return false;
	}
	loadui("ui/support/userdevice.jsp?zuid="+euc(zuid)); //No I18N
	return false;
}

function updateDevice(zuid,id,opt,restrict) {
	if(isEmpty(zuid) || isNaN(zuid)) {
		showerrormsg("INVALID ZUID"); //No I18N
		return;
	}
	if(isEmpty(id)) {
		showerrormsg("Invalid Device"); //No I18N
		return false;
	}
	var ch = de(id).checked;
	if(opt != "delete" && opt != "restrict") {
		showerrormsg("Invalid Option"); //No I18N
		return false;
	}
	var params = "zuid="+euc(zuid)+"&id="+euc(id)+"&opt="+euc(opt)+"&"+csrfParam; //No I18N
	if(opt === "restrict") {
		params += "&restrict="+euc(restrict); //No I18N
	}
	if(confirm("Want to Change " + opt+" device?")){ //No I18N
		showverificationform("/support/userdevice/edit",params,updateDeviceResponse) //No I18N
	}
	if(!isEmpty(restrict)) {
		de(id).checked = !ch;		
	}
}

function updateDeviceResponse(resp){
	if(resp.startsWith("SUCCESS_")) {
		hideverificationform();
		showsuccessmsg("SUCCESS");//No I18N
		loadui("ui/support/userdevice.jsp?zuid="+euc(resp.split("_")[1])); //No I18N
	}
	else{
		if(resp!="INVALID_ADMINPASSWORD"){ //No I18N
			hideverificationform();
		}
		showerrormsg(resp);
	}
	return false;
}