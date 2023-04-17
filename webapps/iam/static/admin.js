
//$Id$ 
//common scripts
function loadAdmin() {	
    de(mainmenu).className = 'inactive';
    de('admin').className = 'activemenu';
    mainmenu = 'admin';//No I18N

    de('pagecontent').style.display='none';
    de('grid').style.display='';

    if(de('home_continer').style.display != 'none') {
        de('home_continer').style.display='none';
        de('panel_div').style.display='';
        de('content_div').style.display='';
    }

    if(show_usr_page) {
        loadPage('user_panel','/ui/admin/userinfo.jsp');// No I18N
    } else {
        loadPage('newsletter_panel','/ui/admin/newsletter.jsp?mode=view'); //No I18N
     }
}

function switchTab(order) {
	if(order == "service")		// No I18n
		{
		document.getElementById("tabpage_1").style.display="block";
		document.getElementById("tabpage_2a").style.display="none";
		document.getElementById("tabpage_2b").style.display="none";

		}
	else 
		{
		document.getElementById("tabpage_2a").style.display="block";
		document.getElementById("tabpage_2b").style.display="block";
		document.getElementById("tabpage_1").style.display="none";

		}
		
}
function selectFromClass(api) {
    var x = document.getElementById("func");
    while(x.length>0)
    {
   	  x.remove(x.length-1);
    }
	var classAndFunction=api.split(",");
	var className=[],funcName=[],i,temp,count=0;
	temp=document.getElementById("class").value;
	for(i=0;i<classAndFunction.length;i++){
		className[i]=classAndFunction[i].split(".")[0];
		if(className[i]==temp){
			funcName[count]=classAndFunction[i].split(".")[1];
			count++;
		}
	}
	var hash = {}, result = [];
    for ( var i = 0, l = funcName.length; i < l; ++i ) {
        if ( !hash.hasOwnProperty(funcName[i]) ) { 
            hash[ funcName[i] ] = true;
            result.push(funcName[i]);
        }
    }
    select = document.getElementById('func');
    var opt = document.createElement('option');
    opt.value = "SELECT"; //No I18n
    opt.innerHTML = "SELECT";//No I18n
    select.appendChild(opt);
    for (var i = 0; i<result.length; i++){
        opt = document.createElement('option');
        opt.value = result[i];
        opt.innerHTML = result[i];
        select.appendChild(opt);
    }
    opt = document.createElement('option');
    opt.value = ""; //No I18n
    opt.innerHTML = "SELECT ALL";//No I18N
    select.appendChild(opt);
		
}

function sortDropDownListByText() {
    $("select").each(function() {
        var selectedValue = $(this).val();
        $(this).html($("option", $(this)).sort(function(a, b) {
            return a.text == b.text ? 0 : a.text < b.text ? -1 : 1
        }));
        $(this).val(selectedValue);
    });
}

function displaySchedulerSpace(ele) {
	if(de('display')!=null)
 	{
		de('display').style.display = 'none';
	}
	
	sortDropDownListByText();
	if(ele == "schedulerselect") {
		de("schelink").className = 'disablerslink';
		de("spacelink").className = 'activerslink';
		de('sche').style.display='';
		de('space').style.display='none';
	} else if(ele == "spaceselect") {	//No I18N
		de("spacelink").className = 'disablerslink';
		de("schelink").className = 'activerslink';
		de('space').style.display='';
		de('sche').style.display='none';
	}
}
function loadSche() {
	de('view').value = "";	//No I18N
}
function showHideDivs(showdiv, hidediv) {
	$("."+hidediv).hide();
	$("."+showdiv).css("display","block");
}
function loadSchedulerSpace(type, value, id) {
	loadui("/ui/admin/scheduler.jsp?t=edit&name="+value);	//No I18N
	displaySchedulerSpace(type);
	de('display').style.display='';
	de('view').name = type;
	de('view').value = value;	//No I18N
	de('view')[de('view').selectedIndex] = document.createElement("option");
	de('view')[de('view').selectedIndex].setAttribute("id",id);
}
function reloadDiv() {
	var type = de('view').name;	//No I18N
	var id = de('view')[de('view').selectedIndex].id;	//No I18N
	loadSchedulerSpace(type, de('view').value, id);	//No I18N
}
function editJob(count,scheduler, space, jobid) {
	var status = false;
	if(de("status-"+count).checked) {
		status = true;
	}
	var params ="op=edit&jid="+euc(jobid.trim())+"&space="+euc(space)+"&status="+euc(status)+"&class="+euc(de('class-'+count).value)+"&net="+euc(de('time-'+count).value)+"&"+csrfParam; //No I18N
	return showverificationform("/admin/scheduler",params, schedulerResponse);	//No I18N
}
function deleteSchedulerJob(jobID, space, showdiv, hidediv) {
	var params ="op=delete&jid="+euc(jobID)+"&space="+euc(space)+"&"+csrfParam; //No I18N
    showverificationform("/admin/scheduler",params, schedulerResponse); //No I18N
}
function addNewScheduler(p) {
	if(p == 'show') {
		sortDropDownListByText();
	    de('addnewbtn').style.display='none';
	    de('addsys').style.display='';
	}
	else if(p == 'hide') {
	    de('addnewbtn').style.display='';
	    de('addsys').style.display='none';
	}
}
function addSchedulerJob(f) {
    var jobid = f.addjobid.value.trim();
    var space = f.addspace.value.trim();
    var scheduler = f.addscheduler.value.trim();
    var time = f.addtime.value.trim();
    var pwd = f.pwd.value.trim();
    if(scheduler == "SELECT") {
        showerrormsg("Please Enter Scheduler Name"); // No I18N
        f.addscheduler.focus();
    } else if(space == "SELECT") {	// No I18N
        showerrormsg("Please Enter Space Name"); // No I18N
        f.addspace.focus();
    } else if(isEmpty(jobid)) {
        showerrormsg("Please Enter Job ID"); // No I18N
        f.addjobid.focus();
    } else if(isEmpty(time)) {
        showerrormsg("Please Enter Excecution Time"); // No I18N
        f.addtime.focus();
    } else if(isEmpty(pwd)) {
        showerrormsg("Please Enter Administrator password"); // No I18N
        f.pwd.focus();
        return false;
    } else {
    	var params = "op=add&jid=" + euc(parseFloat(jobid)) + "&space=" + euc(space) + "&sche="+euc(scheduler) + "&net="+euc(time) + "&pwd="+euc(pwd) +"&"+ csrfParam; // No I18N
        var resp = getPlainResponse(contextpath+"/admin/scheduler",params); //No I18N
    	resp = resp ? resp.trim() : "";//No I18N
    	var jsonStr = JSON.parse(resp);
   	 	if(jsonStr != null && jsonStr['status'] === "success") {//No I18N
        	addNewScheduler("hide");	// No I18N
   	 		showsuccessmsg(jsonStr['message']); // No I18N
        	if(typeof de('view').value != 'undefined' && de('view').value != "") {
        		reloadDiv();
   	 		}
        } else {
	    	if(jsonStr != null) {
	    		showerrormsg(jsonStr['message']); // No I18N
	    	} else {
	    		showerrormsg("Error Occurred");	// No I18N
	    	}
        }
    }
    return false;
}
function schedulerResponse(resp){
	 resp = resp ? resp.trim() : "";//No I18N
	 var jsonStr = JSON.parse(resp);
	 if(jsonStr != null && jsonStr['status'] === "success") {//No I18N
		 showsuccessmsg(jsonStr['message']); // No I18N
		 hideverificationform();
		 reloadDiv();
	 } else {
		 if(jsonStr != null) {
			 showerrormsg(jsonStr['message']); // No I18N
		 } else {
	  		showerrormsg("Error Occurred");	// No I18N
		 }
	 }
	 return false;
}

var http,response;
function displayTable(formid)
{

	var order;  
	if(formid == "service")		// No I18n	
		{
		order = document.getElementById("s").value;
		}
	else if(formid=="class"){
		order = document.getElementById("class").value;
		document.getElementById("func").value = "SELECT";   // No I18n
	}
	else{
		order = document.getElementById("func").value;
	}
	var className=document.getElementById("class").value;
	if(formid=="service" || className=="SELECT"){ 
	className="";
	}
	var uri=contextpath+"/ui/admin/tableForAgentCacheReport.jsp?order="+order+"&class="+className; // No I18n
	sendRequestWithCallback(uri, order, true, processResponseTable);
	document.getElementById("table").style.display="block";

}


function processResponseTable(response) {
    //check if the response has been received from the server
    	document.getElementById("table").innerHTML = response;
}
// on click of one of tabs
function loadservice() {
    loadPage('service_panel','/ui/admin/service.jsp?t=view');// No I18N
}



function showverificationform(uri ,p, callbackFunction) {
    de("verifyapassword").style.display="";
    de("opacity").style.display="";
    de("continuebtn").onclick = function() {continueprocess(uri, p, callbackFunction);}; //No I18N
    de("verifypwd").onkeypress = function(event) { // No I18N
        if(event.keyCode==13) {
            continueprocess(uri, p, callbackFunction);
        }
    };
    de('verifypwd').focus();
    return false;
}

function hideverificationform() {
    de('verifyapassword').style.display='none';
    de('opacity').style.display='none';
    de('verifypwd').value='';
    return false;
}

function continueprocess(uri, params, callbackFunction) {
    var pwd = de('verifypwd').value.trim();
    if(isEmpty(pwd)) {
        showerrormsg("Please Enter Administrator password"); // No I18N
        de('verifypwd').focus();
    }
    else {
        params += "&pwd="+euc(pwd); // No I18N
        sendRequestWithCallback(uri, params, true, callbackFunction);
    }
    return false;
}

function saveAccount(f, isSuperAdminView) {
	var serviceName;
	var roleName=f.roleName.value.trim();
	if(isSuperAdminView == 'true') {
		html5support()?serviceName=f.serviceName[1].value.trim():serviceName=f.serviceName[0].value.trim();
	} else {
		serviceName = f.serviceName.value;
	}
	var loginName = f.loginName.value.trim();
    if(isEmpty(roleName) || roleName.indexOf("select role")!=-1) {
        showerrormsg("Please enter the Role Name"); // No I18N
        f.roleName.focus();
    }
    else if(isEmpty(loginName)) {
        showerrormsg("Please enter the Login Name"); // No I18N
        f.loginName.focus();
    }
    else {
        var params="sname="+euc(serviceName)+"&rname="+euc(roleName)+"&uname="+euc(loginName)+"&"+csrfParam; //No I18N
        var result = getPlainResponse(contextpath+'/admin/addaccount', params); //No I18N
        result = result.trim();
        if(result == "success") {
            showsuccessmsg("Account added successfully"); // No I18N
            f.loginName.value = ''; //No I18N
            f.pwd.value = ''; //No I18N
            f.isEnabled.checked=false
        }
        else if(result == "INVALID_ADMINPASSWORD") {
            showerrormsg("Invalid Administrator password"); // No I18N
            f.pwd.value='';
            f.pwd.focus();
        }
        else {
            showerrormsg("Failed:"+result); // No I18N
        }
    }
    return false;
}

function saveRole(f) {
    var roleName = f.roleName.value.trim();
    var serviceName;
    if(isEmpty(roleName)) {
        showerrormsg("Please enter the Role Name"); // No I18N
        f.roleName.focus();
    }
    else {
    	html5support()?serviceName=f.serviceName[1].value.trim():serviceName=f.serviceName[0].value.trim();
        var params = "sname="+ euc(serviceName) + "&rname="+ euc(roleName) +"&rdesc="+f.description.value; //No I18N
        params += "&default="+f.isDefault.checked+"&"+csrfParam; //No I18N
        var result = getPlainResponse(contextpath+'/admin/addrole', params); //No I18N
        var sresult=result.split('-')
        result=sresult[0].trim();
        var iplist=sresult[1];
        if(result == "success") {
            showsuccessmsg("Role added successfully"); // No I18N
            clearSelectedAppServers("Do you want to clear cache in all app servers",false,iplist);// No I18N
            f.reset();
        }
        else {
            showerrormsg("Failed:"+result); // No I18N
        }
    }
    return false;
}

function closeusraccount(f){
    var user = f.user.value.trim();
    var pwd = f.pwd.value.trim();
    var comment = f.comment.value.trim();
    if(isEmpty(user)) {
        showerrormsg("Please Enter the User Name (or) Email Id"); // No I18N
        f.user.focus();
    }
    else if(isEmpty(pwd)) {
        showerrormsg("Please Enter Administrator password"); // No I18N
        f.pwd.focus();
    }else if(isEmpty(comment)){ 
    	showerrormsg("Please enter the comment"); // No I18N
    	f.comment.focus();
    	return false;
    }else{
        if(confirm("Are you sure to close account of this User ('"+user+"') ?")) {
            var params = "userName="+euc(user)+"&pwd="+euc(pwd)+"&comment="+euc(comment)+"&"+csrfParam; //No I18N
            var resp=getPlainResponse(contextpath+'/admin/closeaccount',params); //No I18N
            resp = resp.trim();
            if(resp=="USER_DELETED") {
                showsuccessmsg("User account closed successfully"); // No I18N
                f.reset();
            }
            else if(resp=="INVALID_USER") {
                showerrormsg("Invalid User cannot be close account"); // No I18N
            }
            else if(resp=="INVALID_ADMINPASSWORD") {
                showerrormsg("Invalid Administrator password"); // No I18N
            }
            else {
                showerrormsg("Error occurred"); // No I18N
            }
        }
    }
    return false;
}

function confirmEmail(f,serviceurl) {
    var emailId=f.emailId.value.trim();
    var confirmEmail=f.confirmationlink.checked;
    var pwd = f.pwd.value.trim();
    var reason = f.reason.value.trim();
    if(isEmpty(emailId)) {
        showerrormsg("Please Enter the Email Id"); // No I18N
        f.emailId.focus();
        return false;
    }
    else if(!isEmailId(emailId)) {
        showerrormsg("Invalid Email Id ' "+emailId+" ' specified"); // No I18N
        return false;
    }
    else if(isEmpty(reason)) {
    	showerrormsg("Please Enter the reason with support ticket ID");//No I18N
    	f.reason.focus();
    	return false;
    }
    else if(isEmpty(pwd)) {
        showerrormsg("Please Enter Administrator password"); // No I18N
        f.pwd.focus();
    }
    else {
        var params ="confirmationurl="+serviceurl+"&emailId="+euc(emailId)+"&isConfirmationlink="+confirmEmail+"&pwd="+euc(pwd)+"&reason="+euc(reason)+"&"+csrfParam; // No I18N
        var resp=getPlainResponse(contextpath+"/admin/confirmemail",params); //No I18N
        resp = resp.trim();
        var obj = JSON.parse(resp);
        if(obj.result=="SUCCESS_CONFIRMATION") {
            showsuccessmsg("Confirmation Successful"); // No I18N
            f.reset();
        }
        else if(obj.result == "INVALID_CONFIRMATION") {
            showerrormsg("Invalid Confirmation"); // No I18N
        }
        else if(obj.result == "INVALID_USER") {
            showerrormsg("Invalid User cannot be reset password"); // No I18N
        }
        else if(obj.result=="INVALID_ADMINPASSWORD") {
            showerrormsg("Invalid Administrator password"); // No I18N
        } else if(obj.result === "INVALID_REASON") { //No I18N
        	showerrormsg("Please Enter the reason with support ticket ID");//No I18N
        } else if(obj.result === "NOT_AUTHORIZED") { //No I18N
        	showerrormsg("You are not authorized");//No I18N
        }else if(obj.result=="URL GENERATED"){ // No I18N
        	 showsuccessmsg("Confirmation link generated successfully"); // No I18N
        	 f.reset();
             $("#confirmeail").html(obj.email);// No I18N
             $("#resetpasswordurl").html(obj.url);// No I18N
             $(".resetoptionlink").show();
        }
        	 else {
                 showerrormsg(obj.result); // No I18N
        	    }
             }
    }

function confirmClientUserEmail(f) {
	if($(".resetoptionlink").is(":visible")){
		$(".resetoptionlink").hide();		
	}
    var zuid=f.zuid.value.trim();
    var zaid=f.zaid.value.trim();
    if(isEmpty(zuid) || isNaN(zuid)) {
        showerrormsg("Please enter Valid Zuid"); // No I18N
        f.zuid.focus();
        return false;
    }
    if(isEmpty(zaid) || isNaN(zaid)) {
        showerrormsg("Please enter Valid Zaid"); // No I18N
        f.zaid.focus();
        return false;
    }
        	var param="zuid="+euc(zuid)+"&zaid="+zaid+"&"+csrfParam;//No I18N
            var resp = getPlainResponse(contextpath+"/admin/clientuserconfirmemail",param); //No I18N
            resp = resp.trim();
            var obj = JSON.parse(resp);
            if(obj.result=="URL GENERATED"){ // No I18N
            	showsuccessmsg("Account Confirmation link generated successfully"); // No I18N
            	f.reset();
            	$("#confirmuser").html(obj.email);// No I18N
            	$("#resetpasswordurl").html(obj.url);// No I18N
            	$(".resetoptionlink").show();
            }
            else if(obj.result="INVALID_USER") {
                showerrormsg("No such user"); // No I18N
            }
            else{
            	 showerrormsg(obj.result); // No I18N
            }
        return false;  
}

function changedeactivateform(ele, show) {
    if(ele.className == 'disablerslink') {
        return false;
    }
    if(show) {
        de('single_acc_link').className = 'disablerslink';
        de('multi_acc_link').className = 'activerslink';
        de('multi_acc').style.display = 'none';
        de('single_acc').style.display = '';
    } else {
        de('multi_acc_link').className = 'disablerslink';
        de('single_acc_link').className = 'activerslink';
        de('single_acc').style.display = 'none';
        de('multi_acc').style.display = '';
    }
    document.deactivate.reset();
    return false;
}
function loadDeactivateOption() {
    var option = html5support() ? de("serviceslist").value : de("servicehtml5").options[de("servicehtml5").selectedIndex].value;	// No I18N
    if(option == "all") {
        if(de("dropdown").innerHTML.indexOf('<option value="spam">Spam</option>') == -1) {
            $("#dropdown").append("<option value='spam'>Spam</option>");
        }
    } else {
    	var selectobject = de("dropdown");	// No I18N
    	for (var i=0; i<selectobject.length; i++){
             if (selectobject.options[i].value == 'spam' ) {
                selectobject.remove(i);
             }
        }
    }
}
function deactivateAccount(f) {
    var isMulti = de('single_acc_link').className == 'activerslink';
    var sname;
    html5support()?sname=f.serviceName[1].value:sname=f.serviceName[0].value;
    if(isEmpty(sname) || sname == 'select') {
        showerrormsg("Please select a service name"); // No I18N
        f.serviceName.focus();
        return false;
    }
    var user, file;
    if(isMulti) {
        file = f.file.value.trim();
        var sub = file.substring(file.indexOf("."),file .length);
        if(isEmpty(file) || file.indexOf(".")==-1 || sub!=".txt") {
            showerrormsg("Invalid file format"); // No I18N
            f.file.value="";
            return false;
        }
    } else {
        user = f.user.value.trim();
        if(isEmpty(user)) {
            showerrormsg("Please Enter the User Name (or) Email Id"); // No I18N
            f.user.focus();
            return false;
        }
    }
    var pwd = f.pwd.value.trim();
    if(isEmpty(pwd)) {
        showerrormsg("Please Enter Administrator password"); // No I18N
        f.pwd.focus();
        return false;
    }
    var comment = f.comment.value.trim();
    if(isEmpty(comment)){ 
    	 showerrormsg("Please enter the comment"); // No I18N
         f.comment.focus();
         return false;
    }
    if(isMulti) {
        f.user.value = '';
        html5support()?document.getElementsByName("serviceName")[0].setAttribute("disabled","true"):document.getElementsByName("serviceName")[1].setAttribute("disabled","true");
        f.submit();
        html5support()?document.getElementsByName("serviceName")[0].setAttribute("disabled","false"):document.getElementsByName("serviceName")[1].setAttribute("disabled","false");
    }else {
        var activate = de("dropdown").options[de("dropdown").selectedIndex].value ;	// No I18N
        var params = "serviceName=" + euc(sname) + "&user=" + euc(user) + "&enable=" + activate + "&pwd=" + euc(pwd) +"&comment=" +euc(comment)+ "&" + csrfParam; //No I18N
        var resp = getPlainResponse(contextpath + "/admin/deactivateaccount", params); //No I18N
        resp = resp.trim();
        if(resp == "SUCCESS") {
            if(activate == "activate") {
                showsuccessmsg(user + " has been activated successfully"); // No I18N
            } else if(activate == "deactivate"){	// No I18N
                showsuccessmsg(user + " has been deactivated successfully"); // No I18N
            } else if(activate == "spam"){	// No I18N
                showsuccessmsg(user + " has been marked as spam successfully"); // No I18N
            }
            f.reset();
        }
        else {
            showerrormsg(resp);
        }
    }
    return false;
}
function deactivateAccountResp(resp) {
    if(isEmpty(resp)) {
        return false;
    }
    if(resp.indexOf("SUCCESS|||") == -1) { // No I18N
        showerrormsg(resp.trim());
        return false;
    }
    var respArr = resp.trim().split("|||");
    var validUsers = respArr[1].split(',');
    var html;
    if(validUsers.length > 1) {
        html = "<span><b>" + respArr[3]+ "</b></span><ol>"; // No I18N
    }
    for(var i=0; i<validUsers.length; i++) {
        if(!isEmpty(validUsers[i])) {
            html += "<li>" + validUsers[i] + "</li>"; // No I18N
        }
    }
    if(validUsers.length > 1) {
        html += "</ol>"; // No I18N
    }

    var failedUsers = respArr[2].split(',');
    if(failedUsers.length > 1) {
        html += "<br><span><b>Failed Users List:</b></span><ol>"; // No I18N
    }
    for(i=0; i<failedUsers.length; i++) {
        if(!isEmpty(failedUsers[i])) {
            html += "<li>" + failedUsers[i] + "</li>"; // No I18N
        }
    }
    if(failedUsers.length > 1) {
        html += "</ol>"; // No I18N
    }
    if(!isEmpty(html)) {
        html += "<span class='smalltxt' onclick='de(\"deactivate_resp\").style.display=\"none\";'><a href='javascript:;'>Click here to hide the results &laquo;</a></span>";
    }
    de('deactivate_resp').innerHTML = html;
    de('deactivate_resp_link').style.display = '';// No I18N
    de('deactivate_resp').style.display='';
    showsuccessmsg("Successfully updated"); // No I18N
    de('deactivate').reset();
    return false;
}
function changeImportType(ele) {
    document.importuser.zoid.value = '';
    if(ele.value.trim() == 'org') {
        de('importusertype').style.display = '';
    } else {
        de('importusertype').style.display = 'none';
    }
}
var importuser;
function importUser(f) {
    var val=f.file.value.trim();
    var sub=val.substring(val.indexOf("."),val.length);
    if(isEmpty(val) || val.indexOf(".")==-1 || sub!=".csv"){
        showerrormsg("Invalid file format"); // No I18N
        f.file.value="";
    } else if((de('importusertype').style.display == '') && (f.zoid.value.trim() == '')) {
        showerrormsg('Please Enter Organization Id'); // No I18N
        f.zoid.focus();
    } else {
        if(f.isconfirm.checked) {
            f.isconfirm.value = 'true';
        } else {
            f.isconfirm.value = 'false';
        }
        f.submit();
    }
    return false;
}

function importUserResponse(resp) {
    if(!isEmpty(resp.trim()) && resp.trim().indexOf("|||") != -1) {
        if(document.importuser) {
            document.importuser.reset();
            de('importusertype').style.display = 'none';
        }
        var respArr = resp.trim().split('|||');
        if(respArr.length >= 3) {
            var result = respArr[0];
            var existUsers = respArr[1];
            var invalidUsers = respArr[2];
            var existUserArr = existUsers.split(",");
            var invalidUserArr = invalidUsers.split(",");
            
            var re = "";
            if(existUserArr.length > 1 || invalidUserArr > 1) {re+="<ul>";}
            if(existUserArr.length > 1) {re += "<li>Already Exists Users (<b>Dropped</b>) :-</li><ol>";}
            for(var i=0; i<existUserArr.length; i++) {
                if(!isEmpty(existUserArr[i].trim())) {
                    re += "<li>"+existUserArr[i]+"</li>";
                }
            }
            if(existUserArr.length > 1) {re += "</ol>";}
            
            if(invalidUserArr.length > 1) {re += "<li>Invalid Users (<b>Dropped</b>) :-</li><ol>";}
            for(var j=0; j<invalidUserArr.length; j++){
                if(!isEmpty(invalidUserArr[j].trim())) {
                    re+="<li>"+invalidUserArr[j]+"</li>";
                }
            }
            if(invalidUserArr.length > 1) {re += "</ol>";}
            if(existUserArr.length > 1 || invalidUserArr > 1) {re+="</ul>";}

            re+="<a href=\"javascript:;\" onclick=\"de('result').style.display='none';de('note').style.display='';\">Ok &laquo;</a>";
            if(invalidUserArr.length <= 1 && existUserArr.length <= 1) {
                re="<center>User's are imported successfully!!</center><a href=\"javascript:;\" onclick=\"de('result').style.display='none';de('note').style.display='';\">Ok &laquo;</a>"; //No I18N
            }
            if(de('result')) {
                de('result').innerHTML=re;
            }
            if(result=="success"){
                showsuccessmsg("Click Details to view the Result."); // No I18N
                de('details').style.display='';
            }
            return;
        }
    }
    showerrormsg("Error Occurrred"); // No I18N
}

function clearThisCache(key, pool) {
    var ele = document.getElementById(key + "_" + pool);
    ele.style.backgroundColor = "pink";
    if(confirm("Are you sure to delete the key \"" + key + "\" ?" )) {
        var p = "op=key&key=" + euc(key) + "&pool=" + pool + "&" + csrfParam; //No I18N
        var resp = getPlainResponse(contextpath+"/admin/memcache/clear", p); //No I18N
        resp = resp ? resp.trim() : "";
        if(resp == "SUCCESS") {
            showsuccessmsg("Cache cleared"); // No I18N
            ele.parentNode.removeChild(ele);
            return;
        }
        else if(resp == "INVALIDUSER") {
            showerrormsg("Invalid User"); // No I18N
        }
        else if(resp == "NOTIMPL") {
            showerrormsg("Not Implemented"); // No I18N
        }
        else {
            showerrormsg("Error Occurrred"); // No I18N
        }
        ele.style.backgroundColor = "grey";
    }
    else {
        ele.style.backgroundColor = "";
    }
}

function clearMobileCache( key,  pool){
	var p = "op=key&key=" + key + "&pool=" + pool + "&" + csrfParam; //No I18N
	getPlainResponse(contextpath+"/admin/memcache/clear", p); //No I18N
}

function showcacheform(id) {
    if(id == 'viewmc') {
        if('activememcachelink' == de('cachebyid').className) {
            de('cachebyid').className = 'disablememcachelink';
            de('cachebykey').className = 'activememcachelink';
            de('cleark').style.display='none';
            de('viewmc').style.display='';
        }
    }
    else if(id == 'cleark') {
        if('activememcachelink' == de('cachebykey').className) {
            de('cachebykey').className = 'disablememcachelink';
            de('cachebyid').className = 'activememcachelink';
            de('viewmc').style.display='none';
            de('cleark').style.display='';
        }
    }
}
function viewCache(f) {
    try {
        var uniqueId = f.uniqueId.value.trim();
        if(isEmpty(uniqueId)) {
            showerrormsg("Missing mandatory field ID"); // No I18N
            f.uniqueId.focus();
            return false;
        }
        var p = "action=" + f.action.value + "&uid=" + uniqueId + "&pool=" + euc(f.pool.options[f.pool.options.selectedIndex].value) + "&" + csrfParam; //No I18N
        var resp = getPlainResponse(contextpath+"/ui/admin/viewcache.jsp", p); //No I18N
        document.getElementById("output_mc").innerHTML = resp;
        document.getElementById("output_mc").style.display='';
        return false;
    }
    catch(e) {
        alert(e.message);
    }
    return false;
}

function viewCacheByKey(f) {
    try {
        var uniqueId = f.uniqueId.value.trim();
        if(isEmpty(uniqueId)){
            showerrormsg("Missing mandatory field ID"); // No I18N
            f.uniqueId.focus();
            return false;
        }
        var datatype = f.datatype.value;
        var p = "iskey=true&action=" + f.action.value + "&uid=" + euc(uniqueId) + "&pool=" + euc(f.pool.options[f.pool.options.selectedIndex].value) + "&" + csrfParam+"&datatype="+euc(datatype); //No I18N
        var resp = getPlainResponse(contextpath+"/ui/admin/viewcache.jsp", p); //No I18N
        document.getElementById("output_mc").innerHTML = resp;
        document.getElementById("output_mc").style.display='';
        return false;
    }
    catch(e) {
        alert(e.message);
    }
    return false;
}

var memcachevalue;
function loadall(pool,key,datatype){
	var params = "pool="+euc(pool)+"&key="+euc(key)+"&datatype="+datatype+"&"+csrfParam; //No I18N
	var resp = getPlainResponse(contextpath+"/admin/memcache/loadmore", params); //No I18N
	var json = JSON.parse(resp);
	var size = json.size;
	memcachevalue = json.array;
	de('valsize').innerText = "(Size = "+size+")"; //No I18N
	loadMore(0);
}

function loadMore(start){
	for(let i=start; i < start+25 && i < memcachevalue.length; i++){
		de('itrlis').innerHTML += memcachevalue[i].value; //No I18N		
	}
	let end = start+25;
	if(end>=memcachevalue.length){
		de('loadmoree').style.display='none';
	}else{
		de('loadmoree').onclick = function(){ //No I18N
			loadMore(end);
		}
	}
}

function loadSortedSet(key,start){
	var params = "key="+euc(key)+"&"+csrfParam+"&start="+euc(start); //No I18N
	var resp = getPlainResponse(contextpath+"/admin/memcache/loadmore", params); //No I18N
	if("EMPTY" == resp){
		de('sortedload').style.display='none';
		return false;
	}
	var json = JSON.parse(resp);
	de('sortedlis').innerHTML += json.val; //No I18N
	if(json.count<25){
		de('sortedload').style.display='none';
	}
	de('sortedload').onclick = function(){ //No I18N
		loadSortedSet(key,start+25);
	}
}

function selectOpt(s){
	if(s.value=="sortedset"){
		showsuccessmsg("SortedSet is Supported For Optional Pool only"); //No I18N
	}
}

function showHelpCard(ele) {
    for(var i = 0; i < ele.options.length; i++) {
		var helpEle = de("hc_" + ele.options[i].value.toLowerCase());
		if(!helpEle) {
			continue;
		}
		if (i == ele.options.selectedIndex) {
			helpEle.style.display = "";
		} else {
			helpEle.style.display = "none";
		}
    }
}

function clearCache(f) {
    var uniqueId = f.uniqueId.value.trim();
    if(isEmpty(uniqueId)) {
        showerrormsg("Missing mandatory field ID"); // No I18N
        f.uniqueId.focus();
        return false;
    }
    var p = "op=uid&uid=" + uniqueId + "&pool=" + euc(f.pool.options[f.pool.options.selectedIndex].value) + "&" + csrfParam; //No I18N
    var resp = getPlainResponse(contextpath+"/admin/memcache/clear", p); //No I18N
    resp = resp ? resp.trim() : "";
    if(resp == "SUCCESS") {
        showsuccessmsg("Cache cleared"); // No I18N
    }
    else if(resp == "INVALIDUSER") {
        showerrormsg("Invalid User"); // No I18N
    }
    else if(resp == "NOTIMPL") {
        showerrormsg("Not Implemented"); // No I18N
    }
    else {
        showerrormsg("Error Occurrred"); // No I18N
    }
    return false;
}

function clearCacheByKey(f) {
    var key = f.key.value.trim();
    if(isEmpty(key)) {
        showerrormsg("Missing mandatory field Key"); // No I18N
        f.key.focus();
        return false;
    }
    var p = "op=key&key=" + key + "&pool=" + euc(f.pool.options[f.pool.options.selectedIndex].value) + "&" + csrfParam; //No I18N
    var resp = getPlainResponse(contextpath+"/admin/memcache/clear", p); //No I18N
    resp = resp ? resp.trim() : "";
    if(resp == "SUCCESS") {
        showsuccessmsg("Cache cleared"); // No I18N
    }
    else if(resp == "INVALIDUSER") {
        showerrormsg("Invalid User"); // No I18N
    }
    else if(resp == "NOTIMPL") {
        showerrormsg("Not Implemented"); // No I18N
    }
    else {
        showerrormsg("Error Occurrred"); // No I18N
    }
    return false;
}
function savePartner(f) {
    var partner_name = f.pname.value.trim();
    var partner_emailid = f.peid.value.trim();
    var partner_domain = f.pdomain.value.trim();
    if(isEmpty(partner_name)) {
        alert("Please Enter the Partner Name"); // No I18N
        f.pname.focus();
        return false;
    }
    else if(isEmpty(partner_emailid)) {
        alert("Please Enter the Partner Email id"); // No I18N
        f.peid.focus();
        return false;
    }
    else if(!isEmailId(partner_emailid)) {
        alert("Please Enter a valid Email id"); // No I18N
        f.peid.focus();
        return false;
    }
    else if(isEmpty(partner_domain)) {
        alert("Please Enter the Partner Domain"); // No I18N
        f.pdomain.focus();
        return false;
    }
    var params="type=add"+"&partner_domain="+euc(partner_domain)+"&partner_name="+euc(partner_name)+"&partner_emailid="+euc(partner_emailid)+"&partner_status="+euc(f.pstatus.checked)+"&"+csrfParam; //No I18N
    var response=getPlainResponse(contextpath+'/partner',params); // No I18N
    if(response.trim() == "success") {
        showsuccessmsg("Partner added successfully"); // No I18N
        setTimeout(loadui('/ui/admin/partners.jsp?t=view'),500);
        return false;
    }
    else {
        showerrormsg(response); // No I18N
        return false;
    }
}
function updatePartner(f) {
    var pdomain = f.editpdomain.value.trim();
    var partner_name = f.editpname.value.trim();
    var partner_emailid = f.editpeid.value.trim();
    var pwd = f.pwd.value.trim();
    if(isEmpty(partner_name)) {
        alert("Please Enter the Partner Name"); // No I18N
        f.editpname.focus();
    }
    else if(isEmpty(partner_emailid)) {
        alert("Please Enter the Partner Email id"); // No I18N
        f.editpeid.focus();
    }
    else if(!isEmailId(partner_emailid)) {
        alert("Please Enter a valid Email id"); // No I18N
        f.editpeid.focus();
    }
    else if(isEmpty(pwd)) {
        showerrormsg("Please Enter Administrator password"); // No I18N
        f.pwd.focus();
    }
    else {
        var params="type=update&partner_domain="+euc(pdomain)+"&partner_name="+euc(partner_name)+"&partner_emailid="+euc(partner_emailid)+"&partner_status="+euc(f.pstatus.checked)+"&pwd="+euc(pwd)+"&"+csrfParam; //No I18N
        var response=getPlainResponse(contextpath+'/partner',params); //No I18N
        if(response.trim() == "success") {
            showsuccessmsg("Partner Updated successfully"); // No I18N
            setTimeout(loadui('/ui/admin/partners.jsp?t=view'),100);
        }
        else if(response.trim() == "INVALID_ADMINPASSWORD") {
            showerrormsg("Invalid Administrator password"); // No I18N
            f.pwd.value='';
            f.pwd.focus();
        }
        else {
            showerrormsg(response); // No I18N
        }
    }
    return false;
}

function deletePartner(partnerdomain) {
    if(confirm("Are sure to delete the Partner?")) {
        var params="type=delete"+"&partner_domain="+euc(partnerdomain)+"&"+csrfParam; //No I18N
        showverificationform(contextpath+'/partner', params, deletePartnerResponse); // No I18N
    } 
    return false;
}

function deletePartnerResponse(resp) {
    res = resp ? resp.trim() : "";
    if(res == "success") {
        showsuccessmsg("Partner deleted successfully"); // No I18N
        setTimeout(loadui('/ui/admin/partners.jsp?t=view'),500);
        hideverificationform();
    }
    else if(res == "INVALID_ADMINPASSWORD") {
        showerrormsg("Invalid Administrator password"); // No I18N
    }
    else {
        showerrormsg(response); // No I18N
    }
    return false;
}

function reserveUser(f) {
    var user = f.user.value.trim();
    var pwd = f.pwd.value.trim();
    if(isEmpty(user)) {
        showerrormsg("Please Enter the User Name"); // No I18N
        f.user.focus();
    }
    else if(isEmpty(pwd)) {
        showerrormsg("Please Enter Administrator password"); // No I18N
        f.pwd.focus();
    }
    else {
        var params="userName="+euc(user)+"&reserve="+f.action[0].checked+"&pwd="+euc(pwd)+"&"+csrfParam; //No I18N
        var resp=getPlainResponse(contextpath+"/admin/reserveuser",params); //No I18N
        resp = resp.trim();
        if(resp=="SUCCESS") {
            showsuccessmsg("Successfully updated"); // No I18N
            f.reset();
        }
        else if(resp=="FAILED") {
            showerrormsg("Failed"); // No I18N
        }
        else if(resp=="INVALID_USER") {
            showerrormsg("Invalid UserName"); // No I18N
        }
        else if(resp=="DUPLICATE_ENTRY") {
            showerrormsg(user+" already exists"); // No I18N
        }
        else if(resp == "INVALID_ADMINPASSWORD") {
            showerrormsg("Invalid Administrator password"); // No I18N
            f.pwd.value='';
            f.pwd.focus();
        }
        else {
            showerrormsg("Error Occurrred"); // No I18N
        }
    }
    return false;
}

function getIPRange(f) {
    var user = f.user.value.trim();
    if(isEmpty(user)) {
        showerrormsg("Please Enter the User Name"); // No I18N
        f.user.focus();
        return false;
    }
    else {
        loadui('/ui/admin/reset_ips.jsp?user='+euc(user)); // No I18N
        return false;
    }
}

function deleteIPs(zuid,f_ip,t_ip) {
    if(confirm("Are you sure to delete this IP(s)?")) {
        var params = "zuid="+euc(zuid)+"&fip="+euc(f_ip)+"&tip="+euc(t_ip)+"&"+csrfParam; //No I18N
        showverificationform(contextpath+"/admin/deleteIPs", params, deleteIPsResponce); //No I18N
    }
    return false;
}

function deleteOrgIPs(zoid, roleName, fromIpRange, toIpRange) {
    if(confirm("Are you sure to delete this IP(s)?")) {
        var params = "zoid="+ euc(zoid) +"&roleName="+euc(roleName)+"&fip="+ euc(fromIpRange) +"&tip="+ euc(toIpRange) +"&"+ csrfParam; //No I18N
        showverificationform(contextpath+"/admin/deleteOrgIPs", params, deleteIPsResponce); //No I18N
    }
    return false;
}

function deleteIPsResponce(resp) {
    var res = resp.trim();
    if(res == "SUCCESS") {
        showsuccessmsg("Successfully deleted"); // No I18N
        loadui('/ui/admin/reset_ips.jsp?user='+euc(de('ips_user').value.trim())); //No I18N
        hideverificationform();
    }
    else if(res == "FAILED") {
        showerrormsg("Delete IPs process failed"); // No I18N
    }
    else if(res == "INVALID_ADMINPASSWORD") {
        showerrormsg("Invalid Administrator password"); // No I18N
    }
    else {
        showerrormsg("Error Occurrred"); // No I18N
    }
    return false;
}

function resetPassword(f,serviceurl) {
	if($(".resetoptionlink").is(":visible")){
		$(".resetoptionlink").hide();		
	}
    var user = f.user.value.trim();
    var password = '';
	var resetpwd = f.resetpwd && f.resetpwd.checked;
	var vali='';
	if(resetpwd){
		if(f.password) {
	    	password = f.password.value.trim();
	    }
	}else{
		vali=f.validityperiod.value;
	}
    
    var pwd = f.pwd.value.trim();
    var reason = f.reason.value.trim();
    if(isEmpty(user)) {
        showerrormsg("Please Enter the User Name (or) Email Id"); // No I18N
        f.user.focus();
    }
    else if(resetpwd && isEmpty(password)) {
    		showerrormsg("Please Enter the New Password"); // No I18N
            f.password.focus();	
    }
	else if(isEmpty(reason)) {
    	showerrormsg("Please Enter the reason with support ticket ID");//No I18N
    	f.reason.focus();
    	return false;
    }
    else if(isEmpty(pwd)) {
        showerrormsg("Please Enter Administrator password"); // No I18N
        f.pwd.focus();
    }
    else {
    	var exparam="isResetpassword="+euc(resetpwd)+"&resetpasswordurl="+euc(serviceurl)+"&reason="+euc(reason);//No I18N
    	var _p = "user="+euc(user)+"&pwd="+euc(pwd)+"&"+exparam+"&"+csrfParam; //No I18N
    	if(resetpwd) {
    		_p += "&password="+euc(password); //No I18N
    	}else{
    		_p += "&validityperiod="+euc(vali); //No I18N
    	}
        var resp = getPlainResponse(contextpath+"/admin/resetpassword",_p); //No I18N
        resp = resp.trim();
        var obj = JSON.parse(resp);
        if(obj.result=="SUCCESS") {
            showsuccessmsg("Password has been reset successfully"); // No I18N
            f.reset();
        }
        else if(obj.result == "FAILED") {
            showerrormsg("Unable to reset password"); // No I18N
        }
        else if(obj.result == "INVALID_USER") {
            showerrormsg("Invalid User cannot be reset password"); // No I18N
        }
        else if(obj.result=="INVALID_ADMINPASSWORD") {
            showerrormsg("Invalid Administrator password"); // No I18N
        }else if(obj.result==="INVALID_REASON") {//No I18N
        	showerrormsg("Please Enter the reason with support ticket ID"); // No I18N
        } else if(obj.result === "NOT_AUTHORIZED") { //No I18N
        	showerrormsg("You are not authorized");//No I18N
        }else if(obj.result=="URL GENERATED"){ // No I18N
            showsuccessmsg("Password link generated successfully"); // No I18N
            f.reset();
            $("#resetusername").html(obj.email);// No I18N
            $("#resetpasswordurl").html(obj.url);// No I18N
            $(".resetoptionlink").show();
            $("#resetoption").show();
        }
        else {
            showerrormsg(obj.result); // No I18N
        }
    }
     return false;
}
function getuserRoles(f, isSuperAdminView) {
    var loginName = f.loginName.value;
    var service;
    if(isSuperAdminView == 'true') {
    	html5support()?service=f.serviceName[1].value:service=f.serviceName[0].value;
    } else {
    	service = f.serviceName.value;
    }
    if(isEmpty(service) || service == '--Select--') {
    	showerrormsg("Please select a valid service"); // No I18N
    } else if(isEmpty(loginName)) {
        showerrormsg("Please enter the values"); // No I18N
    }
    else {
        loaduiviaPOST('/ui/admin/roleinfo.jsp?sname='+ euc(service) +'&uname='+ euc(loginName)); //No I18N
        if(isSuperAdminView == 'true') {
        	showSupportedList();
        }
    }
    return false;
}

function getOAuthScopesbasedonService()
{
	var scopeform = document.getElementById("scopesearchform");
	var servicename = scopeform.serviceName.value.trim();
	if(isEmpty(servicename)) {
		showerrormsg("Please select valid serviceName"); // No I18N
        scopeform.serviceName.focus();
        return false;
	}
	loadui('/ui/admin/oauthScope.jsp?sname=' + euc(servicename) + '&t=view'); //No I18N
	initSelect2();
	}
function deleteRole(uName, sname, roleid) {
	if(isEmpty(uName) || uName=='') {
		showerrormsg("Role associated user not found"); //No I18N
		return false;
	}
    var params = "uname=" + euc(uName) + "&sname=" + sname + "&roleid=" + roleid + "&" + csrfParam; //No I18N
    var resp = getPlainResponse(contextpath+"/admin/deleterole", params); // No I18N
    if(resp.includes("invalid_password_token")){
    	showerrormsg(err_refresh_page);
    	return;
    }
    deleteRoleResponce(resp);
    return false;
}

function deleteRoleResponce(resp) {
    resp = resp ? resp.trim() : "";
    if(resp.indexOf("SUCCESS") !== -1) {
        showsuccessmsg("Successfully Updated"); // No I18N
        var respOut = (resp.split("SUCCESS_")[1]).split("_IAM_");
        var isSuperAdminView = respOut[0];
        var sname = respOut[1];
        var uName = respOut[2];
        uName = uName.replace('&#x40;', '@').replace('&#x2b;', '+');
        loaduiviaPOST('/ui/admin/roleinfo.jsp?sname='+ sname +'&uname='+ euc(uName)); //No I18N
        if(isSuperAdminView == 'true') {
        	showSupportedList();
        }
        hideverificationform();
    }
    else if(resp == "FAILED") {
        showerrormsg("Unable to process..."); // No I18N
    }
    else if(resp == "INVALID_ADMINPASSWORD") {
        showerrormsg("Invalid Administrator password"); // No I18N
    } else if(resp == "INVALID_USER") { //No I18N
    	showerrormsg("User not found"); // No I18N
    } else {
        showerrormsg("Error Occurrred"); // No I18N
    }
    return false;
} 
function getTickets(f){ 
	var loginName = f.loginName.value;
	var isClientPortal = f.isClientPortal.checked;
	var tName = "";
	if(isClientPortal){
		tName = f.portalticketName.value;
	}else{
		tName = f.ticketName.value;
	}
	var zaid =f.zaid.value;
	if(isEmpty(loginName)) {
        showerrormsg("Please enter the Username"); // No I18N
    }else if (isClientPortal && zaid == -1){
    	showerrormsg("Portal Id is mandatory for clientPortal");//No I18N
    }else{
    	var pattern = /^(([A-Za-z0-9_.]+)|([A-Za-z0-9._%+\-\']+@[A-Za-z0-9.\-]+\.[a-zA-Z]{2,100}))$/;
    	if(!pattern.test(loginName)){
    		showerrormsg("Invalid String Entered");// No I18N
    		return false;
    	} else {
    		loadui('/ui/admin/ticketmanagement.jsp?tname='+ euc(tName) +'&uname='+ euc(loginName) + '&isclientportal=' + euc(isClientPortal) + "&zaid=" + euc(zaid)) ; //No I18N 
    	}
    }
    return false;
}
function deleteclientportalticket(userName,ticketType,isOne,ticketvalue,isclientportal,zaid){
	var param="";
	if(isOne){
		 if(confirm("Are you sure to delete the user tickets of \""+userName+"\"?")){
		 param += "isOne=true"; //No I18N
		 param += "&uname="+euc(userName)+"&tname="+euc(ticketType)+"&ticketvalue="+euc(ticketvalue)+"&isportal="+euc(isclientportal)+"&zaid="+euc(zaid)+"&"+csrfParam; //No I18N
		 showverificationform(contextpath+"/admin/deleteuserticket", param, deleteUserTicketResponse); //No I18N
	}
} 
	else {
		  if(confirm("Are you sure to delete the user tickets of \""+userName+"\"?")){
        param += "isOne=false"; //No I18N
        param += "&uname="+euc(userName)+"&tname="+euc(ticketType)+"&isportal="+euc(isclientportal)+"&zaid="+euc(zaid)+"&"+csrfParam; //No I18N
     showverificationform(contextpath+"/admin/deleteuserticket", param, deleteAllUserTicketResponse); //No I18N
		  }
		  return false;
   }
}
function deleteuserticket(userName,ticketType,isOne,ticketvalue){
	deleteclientportalticket(userName,ticketType,isOne,ticketvalue,false,-1);
}
function deleteUserTicketResponse(resp) {
	resp = resp ? resp.trim() : "";
	if(resp.indexOf("SUCCESS_") !== -1) {
		showsuccessmsg("Successfully deleted"); // No I18N
		hideverificationform();
        var ticketType = (resp.split("SUCCESS_")[1]).split("_IAM_")[0];
        var userName = (resp.split("SUCCESS_")[1]).split("_IAM_")[1].split("_ZAID_")[0];
        var zaid = resp.split("_ZAID_")[1] != undefined ? resp.split("_ZAID_")[1] : "";
        var isportal = false;
        if(zaid != ""){
        	isportal = true;
        }
		loadui('/ui/admin/ticketmanagement.jsp?tname='+ ticketType +'&uname='+ userName+'&isclientportal='+isportal+'&zaid='+zaid); // No I18N
	}
	else if(resp == "INVALID_ADMINPASSWORD") {
		showerrormsg("Invalid Administrator password"); // No I18N
	}
	else {
		showerrormsg("Error Occurrred"); // No I18N
		hideverificationform();
		loadui('/ui/admin/ticketmanagement.jsp'); //No I18N
	}
	return false;
}
function deleteAllUserTicketResponse(resp) {
	resp = resp ? resp.trim() : "";
	if(resp.trim() == "SUCCESS") {
		showsuccessmsg("Successfully deleted"); // No I18N
		hideverificationform();
		loadui('/ui/admin/ticketmanagement.jsp'); // No I18N

	}
	else if(resp == "INVALID_ADMINPASSWORD") {
		showerrormsg("Invalid Administrator password"); // No I18N
	}
	else {
		showerrormsg("Error Occurrred"); // No I18N
		loadui('/ui/admin/ticketmanagement.jsp'); //No I18N
		hideverificationform();
	}
	return false;
}

function submitSecretKey(f) {
    var label = f.label.value.trim();
    var algorithm = f.algorithm.value.trim();
    var vperiod = f.vperiod.value.trim();
    var klength = f.klength.value.trim();
    if(isEmpty(label)){
        showerrormsg('Please enter the Label'); // No I18N
        return false;
    } else if(isEmpty(algorithm)) {
        showerrormsg('Please enter the Algorithm'); // No I18N
        return false;
    } else if(isEmpty(vperiod)) {
        showerrormsg('Please enter the Validity Period'); // No I18N
        return false;
    } else if(isEmpty(klength)) {
        showerrormsg('Please enter the Key Length'); // No I18N
        return false;
    } else if(isNaN(vperiod)) {
        showerrormsg('Please enter the valid Validity Period'); // No I18N
        return false;
    } else if(isNaN(klength)) {
        showerrormsg('Please enter the valid Key Length'); // No I18N
        return false;
    }
    var p = "label="+euc(label)+"&algorithm="+euc(algorithm)+"&vperiod="+euc(vperiod)+"&klength="+euc(klength)+"&"+csrfParam; //No I18N
    var uri = "/admin/secretkey/add"; // No I18N
    if(f.mode.value == "E") {
        var pwd = f.pwd.value.trim();
        if(isEmpty(pwd)) {
            showerrormsg("Please Enter Administrator password"); // No I18N
            f.pwd.focus();
            return false;
        }
        uri = "/admin/secretkey/update"; // No I18N
        p += "&olabel="+euc(f.olabel.value.trim())+"&pwd="+euc(pwd); //No I18N
    }
    var resp = getPlainResponse(contextpath+uri, p);
    var sresult=resp.split('-')
    resp=sresult[0];
    var iplist=sresult[1];
    if(resp == "SUCCESS") {
        showsuccessmsg("Successfully updated"); // No I18N
        clearSelectedAppServers("Do you want to clear cache in all app servers",false,iplist);// No I18N
        loadui('/ui/admin/secret_keys.jsp?t=view'); // No I18N
    }
    else if(resp == "INVALID_ADMINPASSWORD") {
        showerrormsg("Invalid Administrator password"); // No I18N
    }
    else {
        showerrormsg("Error Occurrred"); // No I18N
    }
    return false;
}


function deleteSecretKey(label) {
    if(confirm("Are you sure to delete the secret key \""+label+"\"?")) {
        var p = "label="+euc(label)+"&"+csrfParam; // No I18N
        showverificationform(contextpath+"/admin/secretkey/delete", p, deleteSecretKeyResponse); //No I18N
    }
    return false;
}

function deleteSecretKeyResponse(resp) {
    resp = resp ? resp.trim() : "";
    if(resp.indexOf("SUCCESS_IAM_") !== -1) {
        showsuccessmsg("Successfully deleted"); // No I18N
        var iplist = resp.split("_IAM_")[1];
        clearSelectedAppServers("Do you want to clear cache in all app servers",false,iplist);// No I18N
        loadui('/ui/admin/secret_keys.jsp?t=view'); // No I18N
        hideverificationform();
    }
    else if(resp == "INVALID_ADMINPASSWORD") {
        showerrormsg("Invalid Administrator password"); // No I18N
    }
    else {
        showerrormsg("Error Occurrred"); // No I18N
    }
    return false;
}

function updateserviceform(p) {
    if(p == 'show') {
        de('editservice').style.display='none';
        de('updateservice').style.display='';
    }
    else if(p == 'hide') {
        de('updateservice').style.display='none';
        de('editservice').style.display='';
    }
}

function saveService(f) {
    if(isEmpty(f.serviceName.value) || isEmpty(f.displayName.value) || isEmpty(f.description.value) || isEmpty(f.domainName.value) || isEmpty(f.homePage.value) || isEmpty(f.orgType.value) || isEmpty(f.orgModel.value)) {
        alert("Please enter the values"); // No I18N
        return false;
    }    
	  
    var param = "serviceName=" + euc(f.serviceName.value) +  "&displayName=" + euc(f.displayName.value) +'&description='+euc(f.description.value)+'&domainName='+euc(f.domainName.value) + '&homePage=' +f.homePage.value; //No I18N
    param = param + '&autoRegistration=' + f.autoRegistration.checked + '&allowRegistration=' + f.allowRegistration.checked + '&isLN=' + f.isLN.checked + '&isPublic=' + f.isPublic.checked + "&serviceType="+f.serviceType.value;//No I18N
    param = param + "&orgType="+f.orgType.value + "&orgModel="+f.orgModel.value;//No I18N
    param = param + "&app_code="+f.app_code.value;//No I18N
    param = param + "&internal_server="+f.internal_server.value;//No I18N
    param = param + '&service_value='+f.service.value; //No I18N
    var url = "";
    if(f.name == "addservice") {
        url = "/admin/addservice"; // No I18N
    }
    else {
        url = "/admin/updateservice"; // No I18N
        param = param + "&serviceid=" + euc(f.serviceid.value); // No I18N
    }
    if(f.orgType.value == 1 || f.orgType.value == 3) {
        var result="";
     	  for (var i=0, iLen=f.accroles.length; i<iLen; i++) {
     	    opt =f.accroles.options[i];

     	    if (opt.selected) {
     	    	if(result.length != 0) {
     	    		result = result + ",";
     	    	}
     	    	result = result + (opt.value || opt.text);
     	    	
     	    }
     	  }
     	  if(isEmpty(result)) {
     		  if(f.name == "addservice") {
	     		alert("Please choose role" ); // No I18N
	     		return false;
     		  }
     	  } else {
     		 param = param + '&accroles=' + result;// No I18N
     	  }
     	 param = param + '&parentapptype=' + euc(f.parentappOrgtype.value); // No I18N
      } if(f.orgType.value == 2 || f.orgType.value == 3) {
    	  param = param + '&parentOrgtype=' + euc(f.parentOrgtype.value); // No I18N
     }
    if(!isEmpty(f.roDomainName.value)){
    	param = param +'&roDomainName='+euc(f.roDomainName.value); //No I18N
    }
    param = param + "&"+csrfParam;
    var result = getPlainResponse(contextpath+url, param);
    var sresult=result.split('-')
    result=sresult[0].trim();
    var iplist=sresult[1];
    if(result.indexOf('success') === 0) {
        if(f.serviceid==undefined) {
            showsuccessmsg("Service added successfully"); // No I18N
        }
        else {
            showsuccessmsg("Service Updated successfully"); // No I18N
        }
        clearSelectedAppServers("Do you want to clear cache in all app servers",false,iplist);// No I18N
        loadui('/ui/admin/service.jsp?t=edit&sname='+f.serviceName.value); //No I18N
        initAccMember();
    }
    else {
        showerrormsg("Failed : " + result); // No I18N
    }
    return false;
}

function addsysconfigform(p) {
    if(p == 'show') {
	if(de('updatesys')){de('updatesys').style.display='none';}
        de('addnewbtn').style.display='none';
        de('addsys').style.display='';
    }
    else if(p == 'hide') {
        document.addsys.reset();
        de('addsys').style.display='none';
        de('addnewbtn').style.display='';
    }
}

function addSysConfig(f) {
	var appname = de("appname").value.trim();// NO I18N
    var name = f.addsysname.value.trim();
    var value = f.addsysvalue.value.trim();
    var rovalue = f.addsysrovalue.value.trim();
    if(isEmpty(name)) {
        showerrormsg("Please Enter the System Configuration's Name"); // No I18N
        f.addsysname.focus();
    }
    else if(isEmpty(value)) {
        showerrormsg("Please Enter the System Configuration's Value"); // No I18N
        f.addsysvalue.focus();
    }
    else {
    	var params = "name=" + euc(name) + "&value=" + euc(value) + "&rovalue="+euc(rovalue) +"&"+ csrfParam + "&appname=" + appname; // No I18N
        var resp = getPlainResponse(contextpath+"/admin/sysconfig/add",params); //No I18N
        var sresult=resp.split('-')
        resp=sresult[0].trim();
        var iplist=sresult[1];
        if(resp=="SUCCESS") {
            showsuccessmsg("Successfully added"); // No I18N
            if(name=='admin.ip'){
            	clearSelectedAppServers("Do you want to clear cache in all app servers (CLEAR AGENT'S STATIC CACHE ALSO!!!)",false,iplist);// No I18N
            }else{
            	clearSelectedAppServers("Do you want to clear cache in all app servers",false,iplist);// No I18N
            }
            loadui('/ui/admin/systemconfig.jsp?appname='+appname); //No I18N
        }
        else if(resp == "FAILED") {
            showerrormsg("Failed"); // No I18N
        }
        else if(resp == "ERROR") {
            showerrormsg("Error occurred"); // No I18N
        }
        else if(resp.indexOf("DUPLICATE_ENTRY")>=0) {
            var c_name=resp.split("|||");
            showerrormsg(c_name[1]+" is alredy exists"); // No I18N
        }
        else {
            showerrormsg(resp); // No I18N
        }
    }
    return false;
}
function updatesysconfigform(p) {
    if(p == 'show') {
	if(de('addsys')){de('addsys').style.display='none';}
        de('updatesys').style.display='';
        de('updatesysvalue').focus();
    }
    else if(p == 'hide') {
        document.updatesys.reset();
        de('updatesys').style.display='none';
    }
}

function updateSysConfig(f) {
	var appname = de("appname").value;// NO I18N
    var name = f.updatesysname.value;
    var value = f.updatesysvalue.value;
    var rovalue = f.updatesysrovalue.value;
    var pwd = f.pwd.value.trim();
    if(isEmpty(pwd)) {
        showerrormsg("Please Enter Administrator password"); // No I18N
        f.pwd.focus();
        return false;
    }
    var params = "name=" + euc(name) + "&value=" + euc(value) + "&rovalue="+euc(rovalue)+"&pwd=" + euc(pwd) + "&" + csrfParam + "&appname="+appname; // No I18N
    var resp = getPlainResponse(contextpath+"/admin/sysconfig/update",params); //No I18N
    var sresult=resp.split('-')
    resp=sresult[0].trim();
    var iplist=sresult[1];
    if(resp=="SUCCESS") {
        showsuccessmsg("Successfully updated"); // No I18N
        clearSelectedAppServers("Do you want to clear cache in all app servers",false,iplist);// No I18N
        loadui('/ui/admin/systemconfig.jsp?appname='+appname); //No I18N
    }
    else if(resp == "FAILED") {
        showerrormsg("Failed"); // No I18N
    }
    else if(resp == "INVALID_ADMINPASSWORD") {
        showerrormsg("Invalid Administrator password"); // No I18N
    }
    else if(resp == "ERROR") {
        showerrormsg("Error occurred"); // No I18N
    }
    else {
        showerrormsg(resp); // No I18N
    }
    return false;
}

function deleteSysConfig(name) {
	var appname = de("appname").value;// NO I18N
    if(confirm('Are you sure to delete this configuration?')) {
    	var params = "name=" + euc(name) + "&" + csrfParam+"&appname="+euc(appname); // No I18N
        showverificationform(contextpath+"/admin/sysconfig/delete",params, deleteSysConfigResponse); //No I18N
    }
    return false;
}
function deleteSysConfigResponse(resp) {
	var appname = de("appname").value;// NO I18N
    resp = resp.trim();
    if(resp.indexOf("SUCCESS_IAM_") !== -1) {
        showsuccessmsg("Successfully deleted"); // No I18N
        var iplist = resp.split("_IAM_")[1];
        clearSelectedAppServers("Do you want to clear cache in all app servers",false,iplist);// No I18N
        loadui('/ui/admin/systemconfig.jsp?appname='+appname); // No I18N
        hideverificationform();
    }
    else if(resp == "FAILED"){
        showerrormsg("Failed"); // No I18N
    }
    else if(resp == "ERROR"){
        showerrormsg("Error occurred"); // No I18N
    }
    else if(resp == "INVALID_ADMINPASSWORD") {
        showerrormsg("Invalid Administrator password"); // No I18N
    }
    else {
        showerrormsg(resp); // No I18N
    }
    return false;
}

function findUser() {
    var val=$('#search').val().trim();
    var ip=$('#ip').val().trim();
    loadui("/ui/admin/passwordsupport.jsp?qry="+euc(val) +"&ip="+ip); // No I18N
}

function searchUser() {
    var val=$('#search').val().trim();
    var searchBy=$('#mode').val().trim();// No I18N
    var sText=$('#mode option:selected').text().trim();//No I18N
    if(isEmpty(val)) {
        showerrormsg(sText+" to search"); // No I18N
        return false;
    }
    else {
    	var zidPattern =/^[0-9]+$/;
    	if((searchBy=='email' && !isEmailId(val) && !isPhoneNumber(val) && !isUserName(val)) || (searchBy=='zid' && !zidPattern.test(val))){
    		showerrormsg("Invalid "+sText);// No I18N
    		if($(".ursinfoheaderdiv")){
    			$(".ursinfoheaderdiv").hide();
    			$(".usrinfomaindiv").hide();
    		}
    		if($(".nosuchusr")){
    			$(".nosuchusr").hide();
    		}
    	}
    	else{
    		loadui("/ui/admin/userinfo.jsp?"+"type="+searchBy+"&qry="+euc(val)); // No I18N
    		return false;
    	}
    }
}

function searchMail() {
    var val=de('search').value.trim(); // No I18N
    if(isEmpty(val)) {
        showerrormsg("Enter the value to search"); // No I18N
        return false;
    }
    else {
    	if(!isUserName(val) && !isEmailId(val)){
    		showerrormsg("Invalid String Entered");// No I18N
    		if($(".ursinfoheaderdiv")){
    			$(".ursinfoheaderdiv").hide();
    			$(".usrinfomaindiv").hide();
    		}
    		if($(".nosuchusr")){
    			$(".nosuchusr").hide();
    		}
    	}
    	else{
    		loadui("/ui/admin/usermailinfo.jsp?qry="+euc(val)); // No I18N
    		return false;
    	}
    }
}

function searchDigest(isEncryptedDigest) {
	var val = (!isEncryptedDigest) ? de('search').value.trim() : de('search1').value.trim(); // No I18N
	var searchBy = de('mode').value.trim();// No I18N
    if(isEmpty(val)) {
        showerrormsg("Enter the value to search"); // No I18N
        return false;
    } else {
    	if(isEncryptedDigest) {
    		loadui("/ui/admin/digestinfo.jsp?"+"val="+ euc(val)); // No I18N
    		de('encrypted_digest_link').className = 'disablerslink';
   	     	de('plain_text_digest_link').className = 'activerslink';
   	     	de('decryptDigest').style.display = '';
   	     	de('searchDigest').style.display = 'none';
    		return false;
    	}
    	var zidPattern = /^[0-9]+$/;
    	if((searchBy == 'ZID' && !zidPattern.test(val)) || (searchBy == 'EMAIL' && !isEmailId(val)) || (searchBy == 'DIGEST' && val.split("-").length != 2)){
    		showerrormsg("Invalid " + searchBy);// No I18N
    		if($(".ursinfoheaderdiv")){
    			$(".ursinfoheaderdiv").hide();
    			$(".usrinfomaindiv").hide();
    		}
    		if($(".nosuchusr")){
    			$(".nosuchusr").hide();
    		}
    	}
    	else{
    		loadui("/ui/admin/digestinfo.jsp?"+"val="+ euc(val) +"&type="+ euc(searchBy)); // No I18N
    		return false;
    	}
    }
}

function showDigestForm(element,isEncryptedDigest) {
	 if(element.className == 'disablerslink') {
	        return false;
	 }
	 if(!isEncryptedDigest) {
		 de('search').value = '';// No I18N
		 de('plain_text_digest_link').className = 'disablerslink';
	     de('encrypted_digest_link').className = 'activerslink';
	     de('decryptDigest').style.display = 'none';
	     if (de('decryptedDigest') != null) {
		     de('decryptedDigest').style.display = 'none';
	     }
	     de('searchDigest').style.display = '';
	 } else {
		 de('search1').value = '';// No I18N
	     de('encrypted_digest_link').className = 'disablerslink';
	     de('plain_text_digest_link').className = 'activerslink';
	     de('searchDigest').style.display = 'none';
	     if (de('digestInfo') != null) {
	    	 de('digestInfo').style.display = 'none';
	     }
	     de('decryptDigest').style.display = '';
	 }
}

function showDetails(id) {
    var headerIDs = new Array('panel_usrinfo','panel_usrphoto','panel_usrlogindetails','panel_usrtfadetails','panel_usrservicedetails','panel_usrchangehistory','panel_orginfo','panel_orgdomain','panel_orgpolicy', 'panel_usrserviceorgdetails', 'panel_usrappaccountdetails','panel_usrauthdomains');
    var contentIDs = new Array('userinfo','userinfo_photo','login_history','tfa_details','userservice','change_history','org_details','orgdomain_details','orgpolicy_details','serviceorg', 'appaccount','authdomains');
    for(var i=0; i<headerIDs.length; i++) {
        var tmpHeaderID = de(headerIDs[i]);
        var tmpContentID = de(contentIDs[i]);
        if(tmpHeaderID && tmpContentID) {
            if(id == headerIDs[i]) {
                tmpHeaderID.className = 'usrinfoactivediv';
                tmpContentID.style.display = '';
            } else {
                tmpHeaderID.className = 'usrinfoinactivediv';
                tmpContentID.style.display = 'none';
            }
        }
    }
}

function showLoginHistory(id,zuid,operation,action,start) {
    showDetails(id);
    if(de('login_history').getElementsByTagName('table').length == 0) {
        showlogindetails(zuid,operation,action,start);
    }
}

function showlogindetails(zuid,operation,action, start) {
    var params = "zuid="+euc(zuid)+"&operation="+euc(operation)+"&action="+euc(action)+"&start="+euc(start); //No I18N
    var resp = getOnlyGetPlainResponse(contextpath+"/ui/admin/loginhistory.jsp?"+params,""); //No I18N
    de('login_history').innerHTML=resp;
    de('login_history').style.display='';
}

function search_more(zuid,operation,action,type) {
    var start;
    if(type == 'next') {
        start = de('hide_next').value.trim(); //No i18N
        if((start%100) !== 0) {
            alert("no more data available"); // No I18N
            return false;
        }
    }
    else if(type == 'previous') {
        start = de('hide_prev').value.trim()-100; //No i18N
        if(start<0) {
            return false;
        }
    }
    showlogindetails(zuid,operation,action,start);
    return false;
}
function updateServiceOrder() {
    var product = getAttrs(de('product-sortable')); // No I18N
    var collab = getAttrs(de('collab-sortable')); // No I18N
    var biz = getAttrs(de('biz-sortable')); // No I18N
    var params = "";
    if(!isEmpty(product) && product != de('product-sortable').getAttribute("oldIds")) {
        params = "productSIds="+euc(product); // No I18N
    }
    if(!isEmpty(collab) && collab != de('collab-sortable').getAttribute("oldIds")) {
        params += "&collabSIds="+euc(collab); // No I18N
    }
    if(!isEmpty(biz) && biz != de('biz-sortable').getAttribute("oldIds")) {
        params += "&bizSIds="+euc(biz); // No I18N
    }
    if(!isEmpty(params)) {
        var _r = getPlainResponse(contextpath+"/admin/update/serviceorder", params+"&"+csrfParam); // No I18N
        if(_r.trim() == "SERVICE_ORDER_UPDATED") {
            showsuccessmsg("Reordered successfully"); // No I18N
        } else {
            showerrormsg("Error Occurred"); // No I18N
        }
    }
}
function getAttrs(ele) {
    var val = "";
    if(ele) {
        var liList = ele.getElementsByTagName("li");
        for(var i=0;i<liList.length;i++) {
            val += liList[i].getAttribute("sid");
            if(liList.length-1 > i) {
                val += ",";
            }
        }
    }
    return val;
}
function newsletterUser(f) {
    var val=f.file.value.trim();
    var sub=val.substring(val.indexOf("."),val.length);
    if(isEmpty(val) || val.indexOf(".")==-1 || sub!=".csv"){
        alert("Invalid file format"); // No I18N
    } else {
        f.action = contextpath+'/ui/admin/newsletter.jsp?mode=action'; //No I18N
        f.submit();
    }
    f.file.value="";
    return false;
}
function newsletterUserResponse(resp) {
    var title = '';
    if(!isEmpty(resp) && resp.trim().indexOf("|||") !=-1) {
        var resultsplit = resp.trim().split('|||');
        var isSubcribe = resultsplit[3];
        if(!isEmpty(isSubcribe) && "true" == isSubcribe) {
            title = "Subscribed Email Addresses"; // No I18N
        } else {
            title = "Unsubscribed Email Addresses"; // No I18N
        }
        var subscribed_html = '';
        var invalidEmail_html = '';
        var failedEmail_html = '';
        var col_span = 3;
        for(var i=0; i<(resultsplit.length-1); i++) {
            if(!isEmpty(resultsplit[i])) {
                var new_split = resultsplit[i].split(",");
                var new_split_len = new_split.length;
                for(var j=0; j<new_split_len; j++) {
                    if(!isEmpty(new_split[j])) {
                        if(i == 0) {
                            if(j == 0) {
                                subscribed_html = '<table cellspacing=\"5\" cellpadding=\"0\" border=\"0\" width=\"100%\"><tr>'; //No I18N
                                subscribed_html += '<td align=\"left\" colspan=\"'+col_span+'\"><label style=\"font-size:12px;font-weight: bold; color:#008000;\">'+title+'</label></td></tr><tr>'; //No I18N
                            }
                            subscribed_html += '<td><label style=\"color:#444444;\">'+new_split[j]+'</label></td>'; //No I18N
                            if(j != 0 && j%(col_span-1) == 0) {subscribed_html += '</tr><tr>';} //No I18N
                        }
                        else if(i == 1) {
                            if(j == 0) {
                                invalidEmail_html = '<table cellspacing=\"5\" cellpadding=\"0\" border=\"0\" width=\"100%\"><tr>'; //No I18N
                                invalidEmail_html += '<td align=\"left\" colspan=\"'+col_span+'\"><label style=\"font-size:12px;font-weight: bold; color:#F83246;\">Invalid Email Address</label></td></tr><tr>'; //No I18N
                            }
                            invalidEmail_html += '<td><label style=\"color:#444444;\">'+new_split[j]+'</label></td>'; //No I18N
                            if(j != 0 && j%(col_span-1) == 0) {invalidEmail_html += '</tr><tr>';} //No I18N
                        }
                        else if(i == 2) {
                            if(j == 0) {
                                failedEmail_html = '<table cellspacing=\"5\" cellpadding=\"0\" border=\"0\" width=\"100%\"><tr>'; //No I18N
                                failedEmail_html += '<td align=\"left\" colspan=\"'+col_span+'\"><label style=\"font-size:12px;font-weight: bold; color:#F83246;\">Failed '+title+'</label></td></tr><tr>'; //No I18N
                            }
                            failedEmail_html += '<td><label style=\"color:#444444;\">'+new_split[j]+'</label></td>'; //No I18N
                            if(j != 0 && j%(col_span-1) == 0) {failedEmail_html += '</tr><tr>';} //No I18N
                        }
                    }
                }
            }
        }
        if(subscribed_html != "") {
            subscribed_html = subscribed_html.substring(0, (subscribed_html.length-5));
            subscribed_html += '</table>';
        }
        if(invalidEmail_html != "") {
            invalidEmail_html = invalidEmail_html.substring(0, (invalidEmail_html.length-5));
            invalidEmail_html += '</table>';
        }
        if(failedEmail_html != "") {
            failedEmail_html = failedEmail_html.substring(0, (failedEmail_html.length-5));
            failedEmail_html += '</table>';
        }
        var html = subscribed_html + invalidEmail_html + failedEmail_html;
        html += '<table cellspacing=\"5\" cellpadding=\"0\" border=\"0\" width=\"100%\"><tr><td align=\"center\"><input type=\"button\" value=\"Close\" onclick=\"closeNewsletterResult()\"/></td></tr></table>'; //No I18N
        de('newsl_admin_main').innerHTML = html;
        de('newsl_admin_title').innerHTML = title + " Result"; // No I18N
        de('opacity').style.display = ''
        de('admin_newsl_div').style.display = 'block'; // No I18N
    }
}
function getNewsletterUsers(f) {
    f.action = contextpath+'/ui/admin/newsletter.jsp?mode=read&read=true';
    f.submit();
    return false;
}
function downloadLoginDetails(f) {
	var uid = f.uid.value.trim();
	if(isEmpty(uid)) {
		showerrormsg("Please enter valid username or email address"); // No I18N
		f.uid.focus();
		return false;
	}
    f.action = contextpath+'/ui/admin/signin-history.jsp';
    f.submit();
    var ele = de('actionbtn'); //No I18N
    if(ele) {
        ele.disabled = true;
        $('#actionbtn').text("Fetching...Please wait."); //No I18N
    }
    return false;
}
function handleLoginDetailsResp(resp) {
	showerrormsg(resp);
    var ele = de('actionbtn'); //No I18N
    if(ele) {
        ele.disabled = false;
        $('#actionbtn').text("Download SignIn History"); //No I18N
    }
}
function resetLoginHistoiryForm(f) {
    var ele = de('actionbtn'); //No I18N
    if(ele) {
        ele.disabled = false;
        $('#actionbtn').text("Download SignIn History"); //No I18N
    }
}
function newsletterErrorMsg(cause) {
    alert(cause);
    return false;
}
function closeNewsletterResult() {
    de('admin_newsl_div').style.display='none';
    de('opacity').style.display = 'none';
}
function restoreAccount(f) {
    var userid = f.userid.value.trim();
    var email = f.email.value.trim();
    var pwd = f.pwd.value.trim();
    if(isEmpty(userid) || isNaN(userid)) {
        showerrormsg("Please enter valid ZUID"); // No I18N
        f.userid.focus();
    } else if(isEmpty(email) || !isEmailId(email)) {
        showerrormsg("Please enter valid email address"); // No I18N
        f.email.focus();
    } else if(isEmpty(pwd)) {
        showerrormsg("Please enter administrator password"); // No I18N
        f.pwd.focus();
    } else {
        var params = "userid=" + euc(userid) + "&email=" + euc(email) + "&pwd=" + euc(pwd) + "&" + csrfParam; //No I18N
        var resp=getPlainResponse(contextpath+"/admin/restoreaccount",params); //No I18N
        resp = resp.trim();
        if(resp=="SUCCESS") {
            showsuccessmsg(email + " account restored successfully"); // No I18N
            f.reset();
        } else {
            showerrormsg(resp);
        }
    }
    return false;
}
function deleteOrg(f) {
    var email = f.emailid.value.trim();
    var pwd = f.pwd.value.trim();
    if(isEmpty(email)) {
        showerrormsg("Please enter valid email address"); // No I18N
        f.emailid.focus();
    } else if(isEmpty(pwd)) {
        showerrormsg("Please enter administrator password"); // No I18N
        f.pwd.focus();
    } else {
        var params = "email=" + euc(email) + "&pwd=" + euc(pwd) + "&" + csrfParam; //No I18N
        var resp=getPlainResponse(contextpath+"/admin/deleteorg",params); //No I18N
        resp = resp.trim();
        if(resp=="SUCCESS") {
            showsuccessmsg(email + " org deleted successfully"); // No I18N
            f.reset();
        } else {
            showerrormsg(resp);
        }
    }
    return false;
}


function dissociateUserFromOrg(f) {
    var email = f.user.value.trim();
    var pwd = f.pwd.value.trim();
    if(isEmpty(email) || !isEmailId(email)) {
        showerrormsg("Please enter valid email address"); // No I18N
        f.user.focus();
    } else if(isEmpty(pwd)) {
        showerrormsg("Please enter administrator password"); // No I18N
        f.pwd.focus();
    } else {
        var params = "email=" + euc(email) + "&pwd=" + euc(pwd) + "&" + csrfParam; //No I18N
        var resp=getPlainResponse(contextpath+"/admin/dissociateuser",params); //No I18N
        resp = resp.trim();
        if(resp=="SUCCESS") {
            showsuccessmsg(email + " dissociated successfully"); // No I18N
            f.reset();
        } else {
            showerrormsg(resp);
        }
    }
    return false;
}

function showdeletefrm(ele, show) {
    if(ele.className == 'disablerslink') {
        return false;
    }
    if(show) {
        de('dolink').className = 'disablerslink';
        de('dufolink').className = 'activerslink';
        
        de('deleteorg').style.display = '';
        de('dissociateuserfromorg').style.display = 'none';
        document.deleteorg.reset();

        de('deletetitle').innerHTML = 'Delete ORG'; // No I18N
    } else {
        de('dufolink').className = 'disablerslink';
        de('dolink').className = 'activerslink';

        de('dissociateuserfromorg').style.display = '';
        de('deleteorg').style.display = 'none';
        document.dissociateuserfromorg.reset();

        de('deletetitle').innerHTML = 'Dissociate User from Org'; // No I18N
    }
    return false;
}
function showrestorefrm(ele, show) {
    if(ele.className == 'disablerslink') {
        return false;
    }
    if(show) {
        de('ralink').className = 'disablerslink';
        de('auolink').className = 'activerslink';
        
        de('restoreaccount').style.display = '';
        de('assignuserorg').style.display = 'none';
        document.assignuserorg.reset();

        de('restoretitle').innerHTML = 'Restore Account'; // No I18N
    } else {
        de('auolink').className = 'disablerslink';
        de('ralink').className = 'activerslink';

        de('assignuserorg').style.display = '';
        de('restoreaccount').style.display = 'none';
        document.restoreaccount.reset();

        de('restoretitle').innerHTML = 'Assign User To Org'; // No I18N
    }
    return false;
}
function assignUserToOrg(f) {
    var user = f.user.value.trim();
    var zoid = f.zoid.value.trim();
    var pwd = f.pwd.value.trim();
    if(isEmpty(user)) {
        showerrormsg('Please enter valid username or emailId'); // No I18N
        f.user.focus();
        return false;
    }
    if(isEmpty(zoid) || isNaN(zoid)) {
        showerrormsg('Please enter valid organization id'); // No I18N
        f.zoid.focus();
        return false;
    }
    if(isEmpty(pwd)) {
        showerrormsg('Please enter administrator password'); // No I18N
        f.pwd.focus();
        return false;
    }
    var params = "user=" + euc(user) + "&zoid=" + zoid + "&pwd=" + euc(pwd) + "&" + csrfParam; //No I18N
    var resp = getPlainResponse(contextpath + "/admin/assign-user-org", params); //No I18N
    resp = resp.trim();
    if(resp == 'SUCCESS') {
        showsuccessmsg("Successfully assigned"); // No I18N
        f.reset();
    } else {
        showerrormsg(resp);
    }
    return false;
}
function addEDIcon(e) {
    var ele = e.parentNode.parentNode;
    var html = '<input type="text" class="input disableEDtxt" value="From IPAddress" onfocus="clearETRIPtxt(this, true, true)" onblur="clearETRIPtxt(this, true, false)"/>';
    html += '<span>&nbsp;</span>'; // No I18N
    html += '<input type="text" class="input disableEDtxt" value="To IPAddress" onfocus="clearETRIPtxt(this, false, true)" onblur="clearETRIPtxt(this, false, false)"/>';
    html += '<span class="addEDicon" onclick="addEDIcon(this)">&nbsp;</span>';
    var div = document.createElement('div');
    div.innerHTML = html;
    div.className = 'edipdiv';
    ele.appendChild(div);
    e.className = 'removeEDicon';
    e.onclick = function(){removeEDIcon(this);};
}
function removeEDIcon(e) {
    var tdEle = e.parentNode.parentNode;
    if(tdEle.getElementsByTagName('div').length > 1) {
        tdEle.removeChild(e.parentNode);
    }
}
function clearETRIPtxt(ele, from, focus) {
    var val = ele.value.trim();
    if(focus) {
        ele.className = 'input';
        if(val == 'From IPAddress' || val == 'To IPAddress') {
            ele.value = '';
        }
    } else {
        if(val == '') {
            ele.className = 'input disableEDtxt';
            if(from) {
                ele.value = 'From IPAddress'; // No I18N
            } else {
                ele.value = 'To IPAddress'; // No I18N
            }
        }
    }
}
function updateEDF(p) {
    if(p == 'show') {
        de('editEDtbl').style.display = 'none';
        de('editEDfrm').style.display = '';
    } else {
        de('editEDfrm').style.display = 'none';
        de('editEDtbl').style.display = '';
    }
}
function createEtrDomain(f, isCreate) {
    var domain = f.domain.value.trim();
    var owneremail = f.email.value.trim();
    var service = isCreate ? f.serviceName.value.trim() : null;
    if(isEmpty(domain) || !isDomain(domain)) {
        showerrormsg("Please enter valid domain"); // No I18N
        f.domain.focus();
        return false;
    }
    else if(isEmpty(owneremail) || !isEmailId(owneremail)) {
        showerrormsg("Please enter valid owner email address"); // No I18N
        f.email.focus();
        return false;
    }
    
    else if(isCreate && (isEmpty(service) || service == 'select')) {
        showerrormsg("Please enter valid service name"); // No I18N
        f.serviceName.focus();
        return false;
    }
    if(!de('etripstd')) {
        showerrormsg("Allowed IPs field not exists"); // No I18N
        return false;
    }
    var ips = de('etripstd').getElementsByTagName('div');
    var fips = '';
    var tips = '';
    for(var i=0; i<ips.length; i++) {
        var inputs = ips[i].getElementsByTagName('input');
        var fromip = inputs[0].value.trim();
        var toip = inputs[1].value.trim();
        if(isEmpty(fromip) || !isIP(fromip)) {
            showerrormsg("Please enter valid FROM ipAddress"); // No I18N
            inputs[0].focus();
            return false;
        }
        if(isEmpty(toip) || toip == 'To IPAddress') {
            toip = fromip;
        } else {
            if(!isIP(toip)) {
                showerrormsg("Please enter valid TO ipAddress"); // No I18N
                inputs[0].focus();
                return false;
            }
        }
        fips += fromip + ',';
        tips += toip + ',';
    }
    fips = fips.substring(0, fips.length-1);
    tips = tips.substring(0, tips.length-1);
    var params = "domain=" + euc(domain); //No I18N
    params += "&owneremail=" + euc(owneremail); //No I18N
    params += "&type=" + euc(f.type.value.trim()); //No I18N
    
    params += "&fromip=" + fips; //No I18N
    params += "&toip="+tips; //No I18N
    if(isCreate) {
    	params += "&servicename=" + euc(service); //No I18N
        params += "&action=add"; //No I18N
    } else {
        var apikey = f.apikey.value.trim();
        params += "&action=update&apikey="+apikey+"&status=" + f.status.value.trim(); //No I18N
    }

    if(!isCreate) {
        var pwd = f.pwd.value.trim();
        if(isEmpty(pwd)) {
            showerrormsg("Please Enter Administrator password"); //No I18N
            f.pwd.focus();
            return false;
        }
        params += "&pwd="+euc(pwd); //No I18N
    }

    params += "&" + csrfParam;
    var resp = getPlainResponse(contextpath + "/admin/enterprisedomain", params); //No I18N
    var sresult=resp.split('-')
    resp=sresult[0].trim();
    var iplist=sresult[1];
    if(resp == 'SUCCESS') {
        if(isCreate) {
            showsuccessmsg(domain+ " created successfully"); //No I18N
        } else {
            showsuccessmsg(domain+ " updated successfully"); //No I18N
        }
        clearSelectedAppServers("Do you want to clear cache in all app servers",false,iplist);// No I18N
        loadui('/ui/admin/enterprise.jsp?action=view&domain='+domain); //No I18N
    } else {
        showerrormsg(resp);
    }
    return false;
}
function deleteED(domainName) {
    domainName = domainName.trim();
    if(isEmpty(domainName) || !isDomain(domainName)) {
        showerrormsg(domainName + " is not a domain"); // No I18N
    }
    
    if(!confirm("Are you sure to delete " + domainName + "?" )) {
        return false;
    }
    var params = "action=delete&domain="+ euc(domainName) + "&" + csrfParam; //No I18N
    showverificationform(contextpath + "/admin/enterprisedomain", params, deleteEDResp); //No I18N
    return false;
}
function deleteEDResp(resp) {
    resp = resp.trim();
    if(resp.indexOf('SUCCESS_IAM_') !== -1) {
        var domainName = resp.split("_IAM_")[1];
        var iplist = resp.split("_IAM_")[2];
        showsuccessmsg(domainName + ' deleted successfully'); // No I18N
        clearSelectedAppServers("Do you want to clear cache in all app servers",false,iplist);// No I18N
        loadui('/ui/admin/enterprise.jsp?action=list'); // No I18N
        hideverificationform();
    } else {
        showerrormsg(resp);
    }
    return false;
}
/* ---- isc scope --- */
function addISCScope(f, oldScopeName) {
    var serviceId = f.serviceid.value.trim();
    var scopeName = f.scopename.value.trim();
    var internal = f.internal.value.trim();
    var parentScopeId;
    var desc = f.desc.value.trim();
    if(isEmpty(scopeName)) {
        showerrormsg("Please enter valid scopeName"); // No I18N
        f.scope.focus();
        return false;
    }
    if(internal == '1') {
        if(de('parentiscscope').style.display == 'none') {
            showerrormsg("Selected parent scope type mismatched"); // No I18N
            return false;
        }
        parentScopeId = f.parentiscscope.value.trim();
    } else if(internal == '0') {
        if(de('parentauthtoken').style.display == 'none') {
            showerrormsg("Selected parent scope type mismatched"); // No I18N
            return false;
        }
        parentScopeId = f.parentauthtoken.value.trim();
    } else {
    	parentScopeId = -1;
    }
    if(isEmpty(desc)) {
        desc = scopeName;
    }
    var params = "serviceid=" + euc(serviceId) + "&scopename=" + euc(scopeName) + "&parentscopeid=" + euc(parentScopeId) + "&desc=" + euc(desc) + "&internal=" + euc(internal) + "&" + csrfParam; //No I18N
    if(!isEmpty(oldScopeName)) {
        params += "&oldscopename=" + euc(oldScopeName.trim()); //No I18N
    }
    var resp = getPlainResponse(contextpath + "/admin/iscscope/add", params); //No I18N
    var sresult=resp.split('-');
    resp=sresult[0].trim();
    var iplist=sresult[1];
    if(resp == "SUCCESS") {
        if(isEmpty(oldScopeName)) {
            showsuccessmsg(scopeName+" scope created successfully"); //No I18N
        } else {
            showsuccessmsg(scopeName+" scope updated successfully"); //No I18N
        }
        clearSelectedAppServers("Do you want to clear cache in all app servers",false,iplist);// No I18N
        loadui('/ui/admin/iscscope.jsp?t=view'); //No I18N
    } else {
        showerrormsg(resp);
    }
    return false;
}
function deleteISCScope(scopeName, serviceId) {
    var params = "scopename=" + euc(scopeName) + "&serviceid=" + euc(serviceId) + "&" + csrfParam; //No I18N
    showverificationform(contextpath + "/admin/iscscope/delete", params, deleteISCScopeResp); //No I18N
    return false;
}
function changeScopeType(e) {
    if(e.value.trim() == '1') {
        de('parentauthtoken').style.display = 'none';
        de('parentiscscope').style.display = '';
    } else  if(e.value.trim() == '0') {
        de('parentiscscope').style.display = 'none';
        de('parentauthtoken').style.display = '';
    } else {
    	de('parentscope').style.display = 'none';
        de('parentiscscope').style.display = 'none';
        de('parentauthtoken').style.display = 'none';
    }
}
function deleteISCScopeResp(resp) {
    if(resp == 'INVALID_ADMINPASSWORD') {
        showerrormsg('Invalid Administrator password'); // No I18N
        return false;
    } else if(resp.indexOf("SUCCESS_IAM_") !== -1) {
        var scopeName = resp.split("_IAM_")[1];
        var iplist = resp.split("_IAM_")[2];
        showsuccessmsg(scopeName+" scope deleted successfully"); // No I18N
        clearSelectedAppServers("Do you want to clear cache in all app servers",false,iplist);// No I18N
        loadui('/ui/admin/iscscope.jsp?t=view'); // No I18N
    } else {
        showerrormsg(resp);
    }
    hideverificationform();
    return false;
}
function changeAppName(obj,url,type) {
	var appName = obj.value;
	var params= "appname="+euc(appName);//No I18N
	if(type){
		params += "&t="+euc(type);//No I18N
	}
	loadPage('appname', url+"?" +params);// NO I18N
	initSelect2();
}
function selectScreen(obj){
	if(obj.value=="other"){
		document.upload.alternatescreen.style.display="block";// No I18N
		obj.style.display="none";// No I18N
	}
	else{
		document.upload.alternatescreen.style.display="none";// No I18N
	}
}
function customTemplateImage(jsonArr){
	if(jsonArr.length){
		if(jsonArr.length>10){
			alert("You cannot upload "+ jsonArr.length +" custom images at a time\n"); // No I18N
		}else{
		alert("You have "+ jsonArr.length +" custom images in your template file\n"); // No I18N
		var text ="";
		for(var i=0;i < jsonArr.length;i++){
			text += " <div class=\"labelkey\" style=\"padding-top: 12px\">Image "+jsonArr[i].img_id+" :</div><div class=\"labelvalue\"><input name=\"imgfile"+(i+1)+"\" type=\"file\" id=\""+jsonArr[i].img_id+"\" class=\"input\"> <input type=\"hidden\" name=\"imgid"+i+"\" value=\""+jsonArr[i].img_id+"\"></div> ";
		}
		de("asd").innerHTML=text; // No I18N
		de("asd").style.display = 'block';
		$("#addf").hide();
		de("upload").action="admin/screen/update";
		de("next").style.display = 'none';
		de("submit").style.display = 'block';
		}
		
	}else{
		alert("You have no custom images in your template file. Click on add/update to save your template file.\n");   //NO I18N
		de("upload").action="admin/screen/update";
		de("next").style.display = 'none';
		de("submit").style.display = 'block';
		}
	
}
function verify(f,iplist){
	if (f.trim() == 'success'){
		showsuccessmsg("Template Updated Successfully");	// NO I18N
		if(iplist){
			clearSelectedAppServers("Do you want to clear cache in all app servers",false,iplist);// No I18N
		}
		document.upload.reset();
		if(!de('alternatescreen')){
			if(de('file').name == 'tplfile'){
				loadui("/ui/admin/screen.jsp?t=view");// NO I18N
			}
		}
		showMailType("screen");// No I18N
	} else if(f.trim() == 'fail') {// NO I18N
		showerrormsg("Process Failed");// NO I18N
	}	
	else{
		showerrormsg(f.trim());
	}
}

function verifyTemplate(f,iplist){
	$("#loading").hide();
	if (f.trim() == 'success'){
		showsuccessmsg("Template Updated Successfully");	// NO I18N
		if(iplist){
			clearSelectedAppServers("Do you want to clear cache in all app servers",false,iplist);// No I18N
		}
		document.upload.reset();
		if(!de('alternatescreen')){
			if(de('file').name == 'tplfile'){
				loadui("/ui/admin/screen.jsp?t=view");// NO I18N
			}
		}
		showMailType("screen");// No I18N
	} else if(f.trim() == 'fail') {// NO I18N
		showerrormsg("Process Failed");// NO I18N
	}
	else{
		showerrormsg(f.trim());
	}
}

function verifyText(f,iplist) {
	if(f.trim() == 'success') {
		showsuccessmsg("Template text file updated successfully");  // NO I18N
		if(iplist){
			clearSelectedAppServers("Do you want to clear cache in all app servers",false,iplist);// No I18N
		}
		loadui('/ui/admin/screen.jsp?t=view');  // NO I18N
	} else if(f.trim() == 'fail') {    // NO I18N
		showerrormsg("Process Failed");// NO I18N
	}
}

function popUp(status,appname,screenname){
	
	if(!status){
		loadui('/ui/admin/screen.jsp?t=edit&appname='+appname +'&screenname='+screenname);// NO I18N
		de("upload").style.display='block';
		de("iupload").style.display='none';
		return;
	}
	de("upacappname").value=appname;// NO I18N
	de("upacscreenname").value=screenname;// NO I18N
	de("select").style.display='';
	de("imgid").style.display='block';
}

function popChange(ele){
	var type = ele.id;
	var appname = de("upacappname").value;// NO I18N
	var screenname = de("upacscreenname").value;// NO I18N
	if(type == "tmpid"){
		loadui('/ui/admin/screen.jsp?t=edit&appname='+appname +'&screenname='+screenname);// NO I18N
		de("upload").style.display='block';
		de("iupload").style.display='none';
	}else if(type="imgid"){																	// NO I18N
		loadui('/ui/admin/screen.jsp?t=edit&appname='+appname +'&screenname='+screenname);	// NO I18N
		de("upload").style.display='none';
		de("iupload").style.display = 'block';
	}
}

function validate(f) {
	var appname = de("appname").value;// NO I18N
	var isTplVisible = $("#addf").is(":visible");
	if(f.i18nfile){
		if(f.i18nfile.value.trim()==''){
			showerrormsg("Please add file for corresponding field");	// NO I18N
			return false;
		}
		else if (appname == "select"){
			showerrormsg("please select app name");// NO I18N
			return false;
		}
		f.submit();
		return true;
	}
	else if(isTplVisible){ 
		if(f.tplfile){
		if(appname == "select"){
			showerrormsg("please select app name");// NO I18N
			return false;
		}
		else if(f.screen.value.trim() == 'select'){// NO I18N
			showerrormsg("Please select screen name");	// NO I18N
			return false;
		}
		else if (f.tplfile.value.trim() == '' && f.type.value != 'edit') {
				showerrormsg("Please add file for corresponding field");	// NO I18N
				return false;
		}
		else if(f.alternatescreen){
			if(f.alternatescreen.style.display=='block' && f.alternatescreen.value.trim() == ''){
			showerrormsg("Please enter screen name");	// NO I18N
			return false;
		}
		else if(f.alternatescreen.style.display == 'block'){
				var screen  = f.alternatescreen.value.trim();
				if(confirm("Are you sure to upload a template for "+screen+"?")){
					f.submit();		
				}
			}else{
				var screen  = f.screen.value.trim();
				if(confirm("Are you sure to upload a template for "+screen+"?")){
					f.submit();		
			}
		}
	}else if(f.screen){
			var screen  = f.screen.value.trim();
			if(confirm("Are you sure to upload a template for "+screen+"?")){
				f.submit();		
				}
			}
		return true;
		}
	}
	else{
		var x=$("#asd input[id]").length;
		while(x!=0){
			if (f['imgfile'+x].value.trim() == '') {
				showerrormsg("Please add file for corresponding field");	// NO I18N
				return false;
			}
			x--;
		}
		if(confirm("Are you sure to upload a template images?")){
			$("#loading").show();
			f.submit();	
			$("#asd").html("");
			$("#asd").hide();
			$("#addf").show();
			de("upload").action="admin/screen/fileinfo";
			de("next").style.display = 'block';
			de("submit").style.display = 'none';
			}
		return true;
	}
}

function validateText(f) {
	if (f.txtfile.value.trim() == '') {
		showerrormsg("Please add file for corresponding field");	// NO I18N
		return false;
	} else{
		var screen  = f.screen.value.trim();
		if(confirm("Are you sure to upload a plain text for "+screen+"?")){     // NO I18N
			f.submit();		
	      }
       }
	return true;
}

function updatescreen(p) {
	  if(p == 'hide') {
	        de('select').style.display='none';
	       }
	}

function imageUpdate(fi){
	var x=$("#imk input[id]").length;
	while(x!=0){
		if (fi['imgfile'+x].value.trim() == '') {
			showerrormsg("Please add file for corresponding field");	// NO I18N
			return false;
		}
		x--;
	}
	if(confirm("Are you sure to upload a template images?")){
		$("#loading").show();
		fi.submit();	
		}
	return true;
}
function deleteTemplate(appname,screenname){
	var appname = appname.trim();// NO I18N
	var screen = screenname.trim();
	if(appname == ''){
		showerrormsg("please give app name");// NO I18N
	}
	else if(screen == ''){// NO I18N
		showerrormsg("Please give screen name");	// NO I18N
	}
	else{
		if(confirm("Are you sure to delete this template screen?")){
		var params = "appname="+euc(appname)+"&screen="+euc(screen)+"&"+csrfParam;// NO I18N
		var resp = getPlainResponse(contextpath +"/admin/screen/delete", params);// NO I18N
		if(resp.trim() == "success"){// NO I18N
			showsuccessmsg("Template Deleted Successfully");// NO I18N
			loadui("/ui/admin/screen.jsp?t=view");// NO I18N
		}
		else if(resp.trim() == "failure"){
			showerrormsg("Process Failed");//No I18N
		}
		else{
			showerrormsg("Server Error Occured");// NO I18N
		}
	}
		}
}
function showMailType(id) {
	if (id == 'mailtype') {
		de("mailtable").style.display = 'block';
		de("template_text").style.display='block';
		de("alternatescreen").style.display = "block";
		de("screen").style.display = "none";
		de("screen").value="other";// No I18N
	} else if(id=='sms') {// No I18N
		de("mailtable").style.display = 'none';
		de("template_text").style.display='none';
		de("alternatescreen").style.display = "block";
		de("screen").style.display = "none";
		de("screen").value="other";// No I18N
	}
	else{
		de("mailtable").style.display = 'none';
		de("template_text").style.display='none';
		de("alternatescreen").style.display = "none";
		de("screen").style.display = "block";
		de("screen").value="select";// No I18N
		de("alternatescreen").value='';// No I18N
	}
}

function saveTFAAdmin() {
	var emailid = de('useremail').value.trim(); //No I18N
	var userPref = de('enable').checked ? 1 : 0; //No I18N
	var password = de('tfapassword').value.trim(); //No I18N
	if(password == "" || password == null) {
		showerrormsg("Enter valid password"); //No I18N
		de('tfapassword').focus(); //No I18N
                return;
	}
	var params = "emailid="+ euc(emailid) + "&userpref="+ userPref + "&password="+ euc(password) +"&"+ csrfParam; //No I18N
	var resp = getPlainResponse(contextpath + "/admin/enabletfa", params); //No I18N
	if(resp == "Successfully Updated") {
		showsuccessmsg(resp);
		de('useremail').value = "";
		de('tfapassword').value = "";
		de('useremail').focus(); //No I18N
	} else if(resp == "Invalid Password" || resp == "No such user") { //No I18N
		showerrormsg(resp);
		de('tfapassword').value = "";
	} else {
		showerrormsg("Error Occured"); //No I18N
		de('tfapassword').value = "";
	}
}
function makeResetpassword(f) {
	var resetpassword= f.id=="resetpwd";
	var isVisible=$("#resetoption").is(":visible");
	if(resetpassword){
		!$("#resetoption").is(":visible") && $("#resetoption").show();
		$("#valPeriod").is(":visible") && $("#valPeriod").hide();
		$("#resetbtn").html("Save");// No I18N
	}else{
		if(isVisible){
			!$("#valPeriod").is(":visible") && $("#valPeriod").show();
			$("#resetoption").is(":visible") && $("#resetoption").hide();
		}
		$("#resetbtn").html("Generate");// No I18N
	}
	$(".resetoptionlink").hide();
}
function clearCacheAppserverByInput(){
	var ips=$("#iplist").val();
	ips=ips.endsWith(',')?ips.substring(0,ips.length-1):ips;
	if(ips && confirm('Confirm clear-cache on below ip\'s\n'+ips.replace(/,/g, "\n"))){
		var param="ips="+ips+"&" + csrfParam;// No I18N
		var resp = getPlainResponse(contextpath + "/internal/invoke.jsp", param); // No I18N
		if(resp.indexOf("{}")!=-1){
			var message=admin?"cache cleared in selected app servers":"cache cleared in all app servers";//No I18N
			showsuccessmsg(message);
			$('#opacity').hide();
			$('.confirmpop').hide();
		}else{
			showerrormsg("Error in clear cache all app servers");// No I18N
			$('#opacity').hide();
			$('.confirmpop').hide();
		}
	}
}
function makeMigrateUsers(f) {
	var migserviceorg= f.id=="migserviceorg";
	var isVisible=$("#sorgname").is(":visible");
	if(migserviceorg){
		if(!isVisible){
			$("#sorgname").show();
		}
	}else{
		if(isVisible){
			$("#sorgname").hide();
		}
	}
}
function checkAllIps(check) {
	if(check){
		$("input[name=checkips]").attr("checked",true)	
	}else{
		$("input[name=checkips]").attr("checked",false)
	}
}
function clearSelectedAppServers(message,admin,appip){
	$(".pcontentconfirm").css("marginTop","14px");
	$(".pcontentconfirm").css("padding","3px");
	$(".confirmpop").css("width","400px");
	$(".confirmbutton").css("marginLeft","133px");
	var confirm=$(".confirmbutton").children();
	confirm.first().show();
	confirm.next().first().hide();
	$("#promptheader").html("Clear Cache in App Servers");//No I18N
	document.getElementById("confirmboxipsvalue").value=appip;
	if(admin){
		var getIps=$("input[name=checkips]");
		var selected="";
		for ( var i = 0; i < getIps.length; i++) {
			if(getIps[i].checked){
				selected+=getIps[i].value+",";
			}
		}
		var iplist=selected.substring(0,selected.lastIndexOf(','));
		if(iplist==""){
			showerrormsg("Please select ip and clear"); // No I18N
			return false;
		}
		viewConfirm(message); 
	}else{
		var ips=appip.substring(1,appip.lastIndexOf("]"));
		var ip=ips.split(',');
		if(ip.length>0){
			setTimeout(function(){viewConfirm(message);},"1000");
//			viewConfirm(message);
			 
		}	
	}
}
function callInternalinvokeIps(iplist){
	var getIps=$("input[name=checkips]");
	var selected="";
	for ( var i = 0; i < getIps.length; i++) {
		if(getIps[i].checked){
			selected+=getIps[i].value+",";
		}
	}
	var selectedips=selected.substring(0,selected.lastIndexOf(','));
	var admin=selectedips?true:false;
	var iamappip=admin?selectedips:iplist.substring(1,iplist.lastIndexOf("]"));
	var param="ips="+iamappip+"&" + csrfParam;// No I18N
	var resp = getPlainResponse(contextpath + "/internal/invoke.jsp", param); // No I18N
	if(resp.indexOf("{}")!=-1){
		var message=admin?"cache cleared in selected app servers":"cache cleared in all app servers";//No I18N
		showsuccessmsg(message); // No I18N
		$('#opacity').hide();
		$('.confirmpop').hide();
	}else{
		showerrormsg("Error in clear cache all app servers");// No I18N
		$('#opacity').hide();
		$('.confirmpop').hide();
	}
}
function changeRESTColor(metInp) {
	var $jsonbody = $('#jsonbodydiv')
	var $button = $('#submitbutton');
	var method = metInp.value;
	if (method == "get" || method == "delete") {	// No I18N
		$jsonbody.hide();
	} else {
		$jsonbody.show();
	}
	if (method == "get") {	// No I18N
		$button.css('background-color','green');	// No I18N
	} else if(method == "post") {	// No I18N
		$button.css('background-color','yellow');	// No I18N
	} else if (method == "put") {	// No I18N
		$button.css('background-color','orange');	// No I18N
	} else if (method == "delete") {	// No I18N
		$button.css('background-color','red');	// No I18N
	}
}
function configureauthtooauth(){
	var auth2oauthform = de('auth2oauthconfigform'); // No I18N
	var clientID = auth2oauthform.clientid.value;
	if(!clientID || clientID.trim() == "" ) {
		alert('Enter valid ClientID');	// No I18N
		return;
	}
	var password = auth2oauthform.password.value;
	if(!password || password.trim() == "" ) {
		alert('Enter valid admin password');	// No I18N
		return;
	}
	var authscopes = auth2oauthform.authscopes.value;
	if(!authscopes || authscopes.trim() == "" ) {
		alert('Enter valid Authscopes');	// No I18N
		return;
	}
	var oauthscopes = auth2oauthform.oauthscopes.value;
	if(!oauthscopes || oauthscopes.trim() == "" ) {
		alert('Enter valid OAuthscopes');	// No I18N
		return;
	}
	var tokenexpiry = auth2oauthform.tokenexpiry.value;
	if(!tokenexpiry|| tokenexpiry.trim() == "" ) {
		tokenexpiry = 1;
	}
	var apiexpiry = auth2oauthform.apiexpiry.value;
	if(!apiexpiry || apiexpiry.trim() == "" ) {
		alert('Enter valid Expiry value');	// No I18N
		return;
	}
	var params = "clientid=" + euc(clientID) + "&password=" + euc(password) + "&authscopes=" + euc(authscopes) +"&oauthscopes=" + euc(oauthscopes) + "&apiexpiry=" + euc(apiexpiry) + "&tokenexpiry=" + euc(tokenexpiry) + "&" + csrfParam; //NO I18N
	var resp = getPlainResponse(contextpath + "/admin/auth2oauthconfiguration", params); //No I18N   
	var json = JSON.parse(resp);
	auth2oauthform.password.value = '';
	if(json.response == "success")
	{
		showsuccessmsg("Operation is success.Configuration done"); //No I18N 
		auth2oauthform.reset();
	}
	else if(json.response == "error") {	// No I18N
	     if(json.message == "invalid_password") {	// No I18N
			showerrormsg("Invalid password"); // No I18N
			return;
		}
	   else if(json.message == "invalid_oauthscope") {	// No I18N
		showerrormsg("Invalid OAuthscope"); // No I18N
		return;
	    }
      else if(json.message == "invalid_authscope") { // No I18N
	   showerrormsg("Invalid AuthScope"); // No I18N
	   return;
       }
      else if(json.message == "invalid_client") { // No I18N
   	   showerrormsg("Invalid Client"); // No I18N
   	   return;
          }
	}	
}
function validateinputsonaddingoauthconfigurations(locations_count){
	var oauthconfigform = de('oauthconfigform'); // No I18N
	var clientID = oauthconfigform.clientid.value;
	var configtype = oauthconfigform.configtype.value;
	var password = oauthconfigform.password.value;
	if(!password || password.trim() == "" ) {
		alert('Enter valid admin password');	// No I18N
		return;
	}
	if(!clientID || clientID.trim() == "" ) {
		alert('Enter valid ClientID');	// No I18N
		return;
	}
	var params = "clientid=" + euc(clientID) + "&configtype=" + euc(configtype) +"&password=" + euc(password)  + "&" + csrfParam; //No I18N 
	if(configtype == 1){
		var clientscopes = oauthconfigform.clientscopes.value;
		if(!clientscopes || clientscopes.trim() == "" ) {
			alert('Enter valid ClientScopes');	// No I18N
			return;
		}
		params += "&clientscopes="+ euc(clientscopes); // No I18N
	} else if (configtype == 2){
		var subconfigtype = "";
		var inputtype = 0;
		if(oauthconfigform.ownproperty.checked){
			subconfigtype = oauthconfigform.subconfigtype1.value;
			inputtype = 1;
		}else{
		    subconfigtype = oauthconfigform.subconfigtype.value;
		}
		var subconfigvalue = oauthconfigform.subconfigval.value;
		if(!subconfigvalue || subconfigvalue.trim() == "" ) {
			alert('Enter valid configuration value');	// No I18N
			return;
		}	
		params += "&subconfigtype=" + euc(subconfigtype) + "&subconfigvalue=" + euc(subconfigvalue) + "&inputtype=" + euc(inputtype) ;  // No I18N
	} else if (configtype == 3){
		var unifiedsecret = oauthconfigform.unifiedsecret.checked;
		params += "&unifiedsecret=" + euc(unifiedsecret); // No I18N
	}
	else if (configtype == 4){
		var redirecturl = oauthconfigform.redirecturl.value;
		if(!redirecturl || redirecturl.trim() == "" ) {
			alert('Enter valid redirect url value');	// No I18N
			return;
		}
		params += "&redirecturls=" +euc(redirecturl); // No I18N
	}
	var resp = getPlainResponse(contextpath + "/admin/oauthconfiguration", params); //No I18N   
	var json = JSON.parse(resp);
	oauthconfigform.password.value = '';
	if(json.response == "success")
		{
		if( configtype == 1 || configtype == 2 || configtype == 4 ) {
		showsuccessmsg("Operation is success"); //No I18N 
		}
		else if ( configtype == 3 ){
			var oauthdcdetails = json.dcdetails;
			var oauthdcarray = oauthdcdetails.split(",");
			var PrintText = "" ;
			for(i=1;i<=locations_count;i++)
			{
			var mc = $("#cb input:nth-child("+i+")").attr("id"); //NO i18N
			if(mc!=null){
			var checked=document.getElementById(mc).checked;
			if(checked)
			{
			if(oauthdcarray.indexOf(document.getElementById(mc).value) == -1){
			var splitclient = clientID.split(".");
			var appgroupID = splitclient[0];
			var paramss = "location=" + euc(document.getElementById(mc).value) + "&client_id=" + euc(clientID) + "&client_type=" + euc(appgroupID) + "&" + csrfParam; //No I18N
			var response = getPlainResponse(contextpath+"/oauth/dc/addclient",paramss); //No I18N
			response = 	response.trim();
			if(response === 'success'){
				resp = getPlainResponse(contextpath+"/oauth/dc/getRemoteSecret",paramss); //No I18N
				PrintText += " " + document.getElementById(mc).value + "_client_secret="+ resp; //No I18N
			}
			else
				{
				showerrormsg("Multi DC support enable failed"); // No I18N
				}	
			} else {
				PrintText += " " + document.getElementById(mc).value + " - Already enabled"; //No I18N
			}
			}
			}
		    document.getElementById('multidc').innerHTML = PrintText;
		}
		}
		}
	else if(json.response == "error") {
		if(json.message == "invalid_password") {	// No I18N
			showerrormsg("Invalid password"); // No I18N
			return;
		}	
		else if(json.message == "invalid_client") { // No I18N
		   	 showerrormsg("Invalid Client"); // No I18N
		   	 return;
		      }
	    else if(json.message == "invalid_scope") {	// No I18N
			showerrormsg("Invalid scope"); // No I18N
			return;
		}
	    else if(json.message == "invalid_property_value") { // No I18N
		showerrormsg("Invalid Property Configuration"); // No I18N
		return;
	     }
	}
}
function validateinputstogenerateclientid(locations_count,currentloc){
	var clientform = de('clientidcreationform');	// No I18N
	var appgroupID = clientform.clienttype.value;
	var clientname = clientform.clientname.value;
	var clientscopes = clientform.clientscopes.value;
	if(!clientname || clientname.trim() == "" ){
		alert('Enter valid client name');	// No I18N
		document.getElementById('addclientId').innerHTML = "";
		return; 
	}
	var password = clientform.password1.value;
	if(!password || password.trim() == "" ) {
		alert('Enter valid admin password');	// No I18N
		document.getElementById('addclientId').innerHTML = "";
		return;
	}	
	var clientsub;
	var clientsubtype;
	var params = "";
	if(appgroupID == "1001" || appgroupID == "1003")
		{
		   clientsubtype = clientform.clientsubtype.value;
		   params = "client_type=" + euc(clientsubtype) + "&";  //No I18N 
		}
	
	if(clientscopes || !clientscopes.trim() == ""){
		params += "clientscopes="+ euc(clientscopes) + "&"; // No I18N
	}
	params += "password=" + euc(password) + "&clientname=" + euc(clientname) + "&appgroupID=" + euc(appgroupID) +"&" + csrfParam;	// No I18N
	var resp = getPlainResponse(contextpath + "/admin/clientidcreation", params); //No I18N   
	var json = JSON.parse(resp);
	clientform.password1.value = '';
	if(json.response == "success")
		{
		showsuccessmsg("Operation is success. See the result in response"); // No I18N
		if(appgroupID == "1001" || appgroupID == "1003")
			{
		document.getElementById('addclientId').innerHTML = "client_id=" + json.client_id +"  client_secret= "+ json.client_secret;   // No I18N
			}
		else if(appgroupID == "1004")
			{
			var PrintText = "client_id=" + json.client_id + " " +currentloc+"_client_secret= "+ json.client_secret  // No I18N	
			for(i=1;i<=locations_count;i++)
				{
				var mc = $("#cb input:nth-child("+i+")").attr("id"); //NO i18N
				if(mc!=null){
				var checked=document.getElementById(mc).checked;
				if(checked)
				{
				var paramss = "location=" + euc(document.getElementById(mc).value) + "&client_id=" + euc(json.client_id) + "&client_type=" + euc(appgroupID) + "&" + csrfParam; //No I18N
				var response = getPlainResponse(contextpath+"/oauth/dc/addclient",paramss); //No I18N
				response = 	response.trim();
				if(response === 'success'){
					resp = getPlainResponse(contextpath+"/oauth/dc/getRemoteSecret",paramss); //No I18N
					PrintText += " " + document.getElementById(mc).value + "_client_secret="+ resp; //No I18N
				}
				else
					{
					showerrormsg("Multi DC support enable failed"); // No I18N
					}	
				}
				}
				}
			    document.getElementById('addclientId').innerHTML = PrintText;
			}
		}
	else if(json.response == "error") {	// No I18N
	     if(json.message == "invalid_password") {	// No I18N
			showerrormsg("Invalid password"); // No I18N
			document.getElementById('addclientId').innerHTML = "";
			return;
		}
	     if(json.message == "email ID does not exist") // No I18N
	    	 {
	    	 showerrormsg("email ID does not exist"); // No I18N
			 document.getElementById('addclientId').innerHTML = "";
	    	 return;
	    	 }
	     if(json.message == "invalid_scope") {	// No I18N
				showerrormsg("Invalid scope"); // No I18N
				document.getElementById('addclientId').innerHTML = "";
				return;
			}
	}
}

function deleteclientid()
{
	var clientform = de('deleteclient');	// No I18N
	var clientID = clientform.clientid.value;
	var isSystemSpace = clientform.isSystemSpace.checked;
	if(!clientID || clientID.trim() == "" ){
		alert('Enter valid client ID');	// No I18N
		document.getElementById('deleteclientId').value = "";
		return; 
	}
	var password = clientform.password2.value;
	if(!password || password.trim() == "" ) {
		alert('Enter valid admin password');	// No I18N
		document.getElementById('deleteclientId').value = "";
		return;
	}	
	var params = "";
	params += "password=" + euc(password) + "&clientID=" + euc(clientID) +"&isSystemSpace="+euc(isSystemSpace)+ "&" + csrfParam; //No I18N  
	var resp = getPlainResponse(contextpath + "/admin/clientiddeletion", params); //No I18N   
	var json = JSON.parse(resp);
	clientform.password2.value = '';
	if(json.response == "success")
	{
	showsuccessmsg("Operation is success. See the result in response"); // No I18N
	$('#deleteclientId').val(json.message);
	}
	else if(json.response == "error")
		{
		if(json.message == "invalid_password") {	// No I18N
			showerrormsg("Invalid password"); // No I18N
			document.getElementById('deleteclientId').value = "";
			return;
		}
		}
	
}

function validateRESTInputs() {
	var restfrm = de('restform');	// No I18N
	var urival = restfrm.uri.value;
	if(!urival || urival.trim() == "" ) {
		alert('Enter valid rest uri');	// No I18N
		return;
	}
	
	var methodval = restfrm.method.value;
	var bodyjson = "";
	var params = "method=" + methodval + "&uri=" + euc(urival);	// No I18N
	
	var headers = "";
	var x = document.getElementsByName("addheader"); //No I18N
	for(var i=0;i<x.length;i++){
		var header = x[i].getElementsByTagName('select')[0].value.trim();
		if(isEmpty(header) && x.length > 1){
			showerrormsg("INVALID Header Selected"); //No I18N
			x[i].getElementsByTagName('select')[0].focus;
			return;
		}
		if(!isEmpty(header)){
			var value = x[i].getElementsByTagName('input')[0].value.trim();
			if(value==""){
				showerrormsg("Please Enter Valid Header Value"); //No I18N
				return;
			}
			headers += "&headers="+euc(header+":::"+value); //No I18N						
		}
	}
	if(!isEmpty(headers)) {
		params += headers;
	}
	var attributes = "";
	var x = document.getElementsByName("addattribute"); //No I18N
	for(var i=0;i<x.length;i++){
		var header = x[i].getElementsByTagName('input')[0].value.trim();
		if(isEmpty(header) && x.length > 1){
			showerrormsg("INVALID Attribute Entered"); //No I18N
			x[i].getElementsByTagName('input')[0].focus;
			return;
		}
		if(!isEmpty(header)){
			var value = x[i].getElementsByTagName('input')[1].value.trim();
			if(value==""){
				showerrormsg("Please Enter Valid Attribute Value"); //No I18N
				return;
			}
			attributes += "&attributes="+euc(header+":::"+value); //No I18N						
		}
	}
	if(!isEmpty(attributes)) {
		params += attributes;
	}
	
	if(methodval == "post" || methodval == "put") {
		var bodyval = restfrm.body.value;
		if(!bodyval || bodyval.trim() == "" ) {
			alert('Enter valid json body content');	// No I18N
			return;
		}
		bodyjson = bodyval.replace(/(\n|\r)/g, "");
	}
	
	var password = restfrm.password.value;
	if(!password || password.trim() == "" ) {
		alert('Enter valid admin password');	// No I18N
		return;
	}
	params += "&password=" + euc(password);	// No I18N
	
	if(methodval == "get" || confirm("Do you confirm to do '" + methodval.toUpperCase() + "' operation?")) {
		$.ajax({
			url: '/admin/rest?' + params,	// No I18N
			type: "POST",	// No I18N
			contentType: 'application/json',	// No I18N
			data: bodyjson,
			dataType: "json",	// No I18N
			processData: false,
			success: function(data) {
				restfrm.password.value = '';
				var json = JSON.parse(JSON.stringify(data));
				if(json.response == "success") {
					showsuccessmsg("Operation is success. See the result in response"); // No I18N
					$('#jsonresponse').val(json.message);
					return;
				} else if(json.response == "error") {	// No I18N
					if(json.message == "invalid_data") {
						showerrormsg("Invalid input details"); // No I18N
						return;
					} else if(json.message == "invalid_password") {	// No I18N
						showerrormsg("Invalid password"); // No I18N
						return;
					}
				}
				showerrormsg("Error :: " + resp); // No I18N
			},
			error: function() {
				restfrm.password.value = '';
				showerrormsg("Problem in request"); // No I18N
			},
			beforeSend: function(xhr) {
				xhr.setRequestHeader("X-ZCSRF-Token", csrfParam);
			}
		});
	}
}

function showSupportedList(){
	if(html5support()){
		$('#servicehtml5,.servicehtml5').hide();//No i18N
	}else{
		$('.canvascheck').hide();//No i18N
	}
}
function html5support(){
	$.support.datalistProp = ('list' in document.createElement('input') && 'options' in document.createElement('datalist'));//No I18N
	$.support.datalist = ($.support.datalistProp && window.HTMLDataListElement);
	var canvascheck=false;
	if ($.support.datalist){canvascheck=true;}
	return canvascheck;
}
function clearValtemp(t){
	t.value="";
	t.className='input';
}
function showRoleList(f) {
	var isHtml5=html5support();
	var serviceName;
	isHtml5?serviceName=f.serviceName.value.trim():serviceName= f.serviceName1.value.trim();
	var rolelist=getRoleNames(serviceName)
	
}
function getRoleNames(f, roleNameStr) {
		f.roleName.disabled=false;
		var service="";
		html5support()?service=f.serviceName[1].value.trim():service=f.serviceName[0].value.trim();
		if(service==""){
			return;
		}
		fetchRoleNames(f, service, roleNameStr);
}
function fetchRoleNames(f, service, roleNameStr) {
	if(!service || service=='--Select--') {
		$("#roles").html("<option value='select role'>Select Service</option>");//No I18N
		f.roleName.disabled=true;
		return false;
	}
	var param='t=getrole&serviceName='+service;//No I18N
	if(service=="all"){
		$("#roleparent").html("<input type='text' name='roleName' class='input'>");//No I18N
	}
	else {
		var resp = getPlainResponse(contextpath +'/ui/admin/addaccount.jsp?'+param,csrfParam);//No I18n
		if(resp){
			if(resp.includes("invalid_password_token"))
			{
				showerrormsg(err_refresh_page);
				return;
			}
			var resp_v=resp.trim();
			var optionlist="<select id='roles' name='roleName' class='select' >";
			if(resp_v){
				var roles_val=resp_v.substring(1,resp_v.lastIndexOf("]"));
				var rolenames=roles_val.split(",");
				for ( var i = 0; i < rolenames.length; i++) {
					rolenames[i] = rolenames[i].replace(/"/g, '');
					if(roleNameStr && rolenames[i] == roleNameStr) {
						optionlist+="<option value="+rolenames[i]+" selected>"+rolenames[i]+"</option>";
					} else {
						optionlist+="<option value="+rolenames[i]+">"+rolenames[i]+"</option>";
					}
				}
				optionlist+="</select>";
				$("#roleparent").html(optionlist);//No I18N
			}else{
				$("#roles").html("<option value='select role'>No roles from "+service+"</option>");//No I18N
				f.roleName.disabled=true;
			}
		}
	}
}

function regenerate(sname, type, interdc){
	if(type === 'add' && !confirm('Are you sure to generate ISC Key?')) {
		return false;
	} else if(type !== 'add' && !confirm('Are you sure to re-generate ISC Key?')) { //No I18N
		return false;
	}
	var params = 'type=download&servicename='+ euc(sname)+'&interdc='+interdc; //No I18N
	_constructFormData(true, generateIscPrivateKey, params);
}

function generateIscPrivateKey(allparams) {
	var formName = "updateisckeyform"; //No I18N
	var tagetWindowName = "uploadaction"; //No I18N
	$("form[name="+formName+"]").remove();
	$form = $("<form></form>");
	$form.attr({
		method : "post", //No I18N
		action : contextpath + "/admin/isckeyreg", //No I18N
		target : tagetWindowName, //No I18N
		name : formName //No I18N
	});
	
	//assign param values
	var params = allparams.split('&');
	for(var i=0; i<params.length; i++) {
		var paramAndValue = params[i].split('=');
		$form.append('<input type="hidden" name='+ paramAndValue[0] +' value='+ paramAndValue[1] +' />');
	}
	//include csrfParam in param list
	var csrf = csrfParam.split("=");
	$form.append('<input type="hidden" name='+ csrf[0] +' value='+ csrf[1] +' />');
	$('body').append($form);
	$form.submit();
	hideverificationform();
}

function _constructFormData(isUI, callbackFunction, params) {
	if(isUI){
		de("verifyapassword").style.display="";
		de("opacity").style.display="";
		de("continuebtn").onclick = function() {_constructFormData(false, callbackFunction, params);}; //No I18N
		de("verifypwd").onkeypress = function(event) { // No I18N
			if(event.keyCode==13) {
				_constructFormData(false, callbackFunction, params);
			}
		};
		de('verifypwd').focus(); //No I18N
		return false;
    } else {
    	var pwd = de('verifypwd').value.trim(); //No I18N
        if(isEmpty(pwd)) {
            showerrormsg("Please Enter Administrator password"); // No I18N
            de('verifypwd').focus(); //No I18N
        } else {
        	params = params + "&pwd=" + pwd; //No I18N
        	callbackFunction(params);
    	}
    }
}

function checktelesignref() {
	var ref_id = de('tfaref_id').value.trim(); //No I18N
	var params = "ref_id=" + euc(ref_id) +"&"+ csrfParam; //No I18N
	var resp = getPlainResponse(contextpath + "/admin/smsstatus", params); //No I18N
	if(resp == "Error Occurred") {
		showerrormsg(resp);
		de('tfaref_id').value = "";
	}else {
		showsuccessmsg("Successfully fetched"); //No i18N
		de('telesignres').value = resp; //No I18N
		de('tfaref_id').value = "";
		de('tfaref_id').focus(); //No i18N
	}
}

function resetTFA() {
	var emailid = de('reset_email').value.trim(); //No I18N
	var password = de('tfareset_pass').value.trim(); //No I18N
	if(password == "" || password == null) {
		showerrormsg("Enter valid password"); //No I18N
		de('tfareset_pass').focus(); //No I18N
		return;
	}
	var params = "emailid="+ euc(emailid) + "&password="+ euc(password) +"&"+ csrfParam; //No I18N
	var resp = getPlainResponse(contextpath + "/admin/resettfa", params); //No I18N
	if(resp.indexOf("Successful") != -1) {
		de('tfaresetstatus').value = resp; //No i18N
		de('reset_email').value = "";
		de('tfareset_pass').value = "";
		de('reset_email').focus(); //No I18N
	}else if(resp == "Invalid Password" || resp == "No such user") { //No I18N
		showerrormsg(resp);
		de('tfareset_pass').value = "";
	}else {
		showerrormsg("Error Occurred"); //No I18N
		de('tfareset_pass').value = "";
	}
}

function switchTFAClass(element) {
	if(element.id == "enabletfaheader") {
		$("#smsstatusheader").removeClass("tfasel");
		$("#resettfaheader").removeClass("tfasel");
		$("#generateRecoveryCodeheader").removeClass("tfasel");
		$(element).addClass("tfasel");
		de('smsstatus').style.display="none";
		de("resettfa").style.display="none";
		de("generateRecoveryCode").style.display="none";
		de('enabletfa').style.display="";
		de('useremail').focus(); //No I18N
	}else if(element.id == "resettfaheader") {
		$("#smsstatusheader").removeClass("tfasel");
		$("#enabletfaheader").removeClass("tfasel");
		$("#generateRecoveryCodeheader").removeClass("tfasel");
		$(element).addClass("tfasel");
		de('smsstatus').style.display="none";
		de("enabletfa").style.display="none";
		de("generateRecoveryCode").style.display="none";
		de('resettfa').style.display="";
		de('reset_email').focus(); //No I18N
	} else if(element.id == "smsstatusheader"){
		$("#enabletfaheader").removeClass("tfasel");
		$("#resettfaheader").removeClass("tfasel");
		$("#generateRecoveryCodeheader").removeClass("tfasel");
		$(element).addClass("tfasel");
		de('enabletfa').style.display="none";
		de('resettfa').style.display="none";
		de("generateRecoveryCode").style.display="none";
		de('smsstatus').style.display="";
		de('tfaref_id').focus(); //No I18N
	}else {
		$("#enabletfaheader").removeClass("tfasel");
		$("#resettfaheader").removeClass("tfasel");
		$("#smsstatusheader").removeClass("tfasel");
		$(element).addClass("tfasel");
		de('enabletfa').style.display="none";
		de('resettfa').style.display="none";
		de('smsstatus').style.display="none";
		de('generateRecoveryCode').style.display="";
		de('recEmail').focus(); //No I18N
	}
}

function generateAdminRecoveryCode(){
	var emailid = de('recEmail').value.trim(); //No I18N
	var password = de('tfa_rec_password').value.trim(); //No I18N
	if(password == "" || password == null) {
		showerrormsg("Enter valid password"); //No I18N
		de('tfa_rec_password').focus(); //No I18N
        return;
	}
	var params = "emailid="+ euc(emailid) + "&password="+ euc(password) +"&"+ csrfParam; //No I18N
	var resp = getPlainResponse(contextpath + "/admin/generaterec", params); //No I18N
	if(resp.indexOf("Recovery_Code") != -1) {
		showsuccessmsg("Successfully Generated"); //No i18N
		de('recCodeResponse').value = resp; //No i18N
		de('recEmail').value = "";
		de('tfa_rec_password').value = "";
		de('recEmail').focus(); //No I18N
	} else if(resp == "Invalid Password" || resp == "No such user") { //No I18N
		showerrormsg(resp);
		de('tfa_rec_password').value = "";
	} else {
		showerrormsg("Error Occured"); //No I18N
		de('tfa_rec_password').value = "";
	}
}

function showChangeHistory(id,zuid,start) {
	showDetails(id);
	if(de('change_history').getElementsByTagName('table').length == 0) {
		showchangedetails(zuid,start);
	}
}
function closeDetails(id){
    de(id).style.display='none';
}
function showchangedetails(zuid,start){
	var params = "zuid="+euc(zuid)+"&start="+euc(start); //No I18N
    sendRequestWithCallback(contextpath+"/ui/admin/changehistory.jsp?"+params,"",true,changedetails,"GET"); //No I18N
	return false;
}
function changedetails(rsp) {
     if(!rsp) {
            return;
        }
    de('change_history').innerHTML=rsp; //No I18N
    de('change_history').style.display=''; //No I18N
     }
function search_moreresource(zuid,type) {
	if(type == 'next') {
		start = parseInt(de('hide_next').value.trim()); // No I18N
	}
	else if(type == 'previous') {
		start = parseInt(de('hide_prev').value.trim())-10; // No I18N
		if(start<0) {
			return false;
		}
	}
	showchangedetails(zuid,start);
	return false;
}
	function submitlistener(f) {
    var listener = f.listener.value.trim();
    var resourcepattern = f.resourcepattern.value.trim();
    var pwd = f.pwd.value.trim();
    if(isEmpty(listener)) {
        showerrormsg("Please enter the listener id"); // No I18N
        f. listener.focus();
        return false;
    }
    else if(isEmpty(resourcepattern)) {
        showerrormsg("Please enter the resourcepattern"); // No I18N
        f.resourcepattern.focus();
        return false;
    }
    else if(isEmpty(pwd)) {
        showerrormsg("Please Enter Administrator password"); // No I18N
        f.pwd.focus();
        return false;
    }
    var params="listener="+euc(listener)+"&resourcepattern="+euc(resourcepattern)+"&pwd="+euc(pwd)+"&"+csrfParam; //No I18N
    var result = getPlainResponse(contextpath+'/admin/addupdatelistener', params);  //No I18N
    result = result.trim();
    if(result == "SUCCESS") {
        showsuccessmsg("Listener added successfully"); // No I18N
        loadui('/ui/admin/listener.jsp?t=view'); // No I18N
        f.reset();
    }
    else if(result == "INVALID_ADMINPASSWORD") {
        showerrormsg("Invalid Administrator password"); // No I18N
        f.pwd.value='';
        f.pwd.focus();
    }
    else {
        showerrormsg("Failed:"+result); // No I18N
    }
    return false;
}


function updatelistener(f) {
    var listener = f.listener.value.trim();
    var resourcepattern = f.resourcepattern.value.trim();
    var action=f.action.value.trim();
    var pwd = f.pwd.value.trim();
    if(isEmpty(listener)) {
        showerrormsg("Please enter the listener id"); // No I18N
        f. listener.focus();
    }
    else if(isEmpty(resourcepattern)) {
        showerrormsg("Please enter the Resourcepattern"); // No I18N
        f.resourcepattern.focus();
    }
    else if(isEmpty(pwd)) {
        showerrormsg("Please Enter Administrator password"); // No I18N
        f.pwd.focus();
    }
    else if(isEmpty(action)){
        showerrormsg("Sorry unable to update"); // No I18N
    }
    else {
        var params="listener="+euc(listener)+"&resourcepattern="+euc(resourcepattern)+"&pwd="+euc(pwd)+"&action="+euc(action)+"&"+csrfParam; //No I18N
        var result = getPlainResponse(contextpath+'/admin/addupdatelistener', params); //No I18N
        result = result.trim();
        if(result == "SUCCESS") {
            showsuccessmsg("Listener updated successfully"); // No I18N
            loadui('/ui/admin/listener.jsp?t=view'); //No I18N
        }
        else if(result == "INVALID_ADMINPASSWORD") {
            showerrormsg("Invalid Administrator password"); // No I18N
            f.pwd.value='';
            f.pwd.focus();
        }
        else {
            showerrormsg("Failed:"+result); // No I18N
        }
    }
    return false;
}
function deletelistener(listener) {
    if(confirm("Are you sure to delete the listener \""+listener+"\"?")) {
        var p = "listener="+euc(listener)+"&"+csrfParam; //No I18N
        showverificationform(contextpath+"/admin/deletelistener", p, deleteListenerResponse); //No I18N
    }
    return false;
}
function deleteListenerResponse(resp) {
    resp = resp ? resp.trim() : "";
    if(resp == "SUCCESS") {
        showsuccessmsg("Successfully deleted"); // No I18N
        loadui('/ui/admin/listener.jsp?t=view'); //No I18N
        hideverificationform();
    }
    else if(resp == "INVALID_ADMINPASSWORD") {
        showerrormsg("Invalid Administrator password"); // No I18N
    }
    else {
        showerrormsg("Error Occurrred"); // No I18N
    }
    return false;
}
function showroleinfofrm(ele, show) {
	if(ele.className == 'disablerslink') {
        return false;
    }
    if(show) {
        de('usrlink').className = 'disablerslink';
        de('ssrlink').className = 'activerslink';
        
        de('userroleinfo').style.display = '';
        de('serviceroleinfo').style.display = 'none';
        de('service_role').style.display='none';
        document.serviceroleinfo.reset();
        de('roleinfotitle').innerHTML = 'View By User'; // No I18N
    } else {
        de('ssrlink').className = 'disablerslink';
        de('usrlink').className = 'activerslink';
        
        de('user_role').style.display='none';
        de('serviceroleinfo').style.display = '';
        de('userroleinfo').style.display = 'none';
        document.userroleinfo.reset();
        de('roleinfotitle').innerHTML = 'View By Service'; // No I18N
    }
    return false;
}
function getserviceRoles(f, isSuperAdminView) {
    var roleName = f.roleName.value;
    var service;
    if(isSuperAdminView == 'true') {
    	html5support()?service=f.serviceName[1].value:service=f.serviceName[0].value;
    } else {
    	service = f.serviceName.value;
    }
    if(isEmpty(service) || service == '--Select--') {
    	showerrormsg("Please select a service"); // No I18N
    } else if(isEmpty(roleName) || isEmpty(service)) { //No I18N
        showerrormsg("Please enter the values"); // No I18N
    }
    else {
    	 de('ssrlink').className = 'disablerslink';
    	  de('userroleinfo').style.display = 'none';
        loaduiviaPOST('/ui/admin/roleinfo.jsp?sname='+ euc(service) +'&rname='+ euc(roleName) + '&ismulti=true'); //No I18N
        if(isSuperAdminView == 'true') {
        	showSupportedList();
        }
        getRoleNames(f, roleName);
    }
    return false;
}
function makeConfirmemail(f) {
	var emailconfirm= f.id=="confirmationlink";
	if(emailconfirm){
		$("#confirmbtn").html("Generate");// No I18N
	}else{
		$("#confirmbtn").html("Confirm");// No I18N
	}
	$(".resetoptionlink").hide();
}
function createPartner(f) {
	var name = f.partner_name.value.trim();
	var domain = f.partner_domain.value.trim();
	var email = f.partner_emailid.value.trim();
	var password = f.pwd.value.trim();
	var displayname = f.partner_display.value.trim();
	if(isEmpty(name)){
		showerrormsg("Please enter the partner name"); // No I18N
		f.partner_name.focus();
	}
	else if(isEmpty(displayname)){
		showerrormsg("Please Enter the display name"); // No I18N
		f.partner_display.focus();
	}
	else if(isEmpty(domain)) {
		showerrormsg("Please Enter the domain name"); // No I18N
		f.partner_domain.focus();
    }
	else if(!isDomain(domain)) {
		showerrormsg("Please Enter a valid domain name"); // No I18N
		f.partner_domain.focus();
    }
	else if (isEmpty(email)){
		showerrormsg("Please enter the email id"); // No I18N
		f.partner_emailid.focus();
	}
	else if(!isEmailId(email)) {
		showerrormsg("Please Enter a valid email id"); // No I18N
		f.partner_emailid.focus();
    }
	else if(isEmpty(password)) {
		showerrormsg("Please Enter Administrator password"); // No I18N
		f.pwd.focus();
	}else{
		var params="partner_domain="+euc(domain)+"&partner_name="+euc(name)+"&partner_emailid="+euc(email)+"&pwd="+euc(password)+"&partner_display="+euc(displayname)+"&"+csrfParam; //No I18N
		var result = getPlainResponse(contextpath+'/admin/partneraccount/add', params); //No I18N
		result = result.trim();
		var sresult=result.split('-');
        result=sresult[0].trim();
        var iplist=sresult[1];
		if(result=="success"){
			showsuccessmsg("Partner Account created successfully"); // No I18N
			clearSelectedAppServers("Do you want to clear cache in all app servers",false,iplist);// No I18N
			f.reset();
			loadui('/ui/admin/partner_signup.jsp?t=view&domain='+euc(domain)); //No I18N
		}
		else if(result == "INVALID_ADMINPASSWORD") {
            showerrormsg("Invalid Administrator password"); // No I18N
            f.pwd.value='';
            f.pwd.focus();
        }
		else if(result=="DOMAIN_NAME_EXIST"){
        	showerrormsg('Domain name already exist'); //No I18n
        	f.partner_domain.focus();
        }
		else{
			var message = result == "ORG_USERACCOUNT" ? "Email id already belongs to an organization" :result == "USER_NOTACTIVE" ? "inactive user" : //No I18n
						  result == "PARENT_ZAIDEXIST"?"Email id already belongs to another partner account":result ==	"NO_SUCHUSER"?"No such user":result; //No I18n 
			showerrormsg(message);
        	f.partner_emailid.focus();
        }
	}
	return false;
}
function updatePartnerAccount(f) {
	var name = f.partner_name.value.trim();
	var domain = f.partner_domain.value.trim();
	var partnerid = f.partnerid.value.trim();
	var email = f.partner_emailid.value.trim();
	var password = f.pwd.value.trim();
	var displayname = f.partner_display.value.trim();
	if(isEmpty(name)){
		showerrormsg("Please enter the partner name"); // No I18N
		f.partner_name.focus();
	}
	else if(isEmpty(displayname)){
		showerrormsg("Please Enter the display name"); // No I18N
		f.partner_display.focus();
	}
	else if(isEmpty(domain)) {
		showerrormsg("Please Enter the domain name"); // No I18N
		f.partner_domain.focus();
    }
	else if(!isDomain(domain)) {
		showerrormsg("Please Enter a valid domain name"); // No I18N
		f.partner_domain.focus();
    }
	else if(isEmpty(password)) {
		showerrormsg("Please Enter Administrator password"); // No I18N
		f.pwd.focus();
	}else{
		var params="partner_id="+euc(partnerid)+"&partner_domain="+euc(domain)+"&partner_name="+euc(name)+"&partner_emailid="+euc(email)+"&pwd="+euc(password)+"&partner_display="+euc(displayname)+"&"+csrfParam; //No I18N
		var result = getPlainResponse(contextpath+'/admin/partneraccount/update', params); //No I18N
		result = result.trim();
		var sresult=result.split('-');
        result=sresult[0].trim();
        var iplist=sresult[1];
		if(result=="success"){
			showsuccessmsg("Partner Account updated successfully"); // No I18N
			clearSelectedAppServers("Do you want to clear cache in all app servers",false,iplist);// No I18N
			loadui('/ui/admin/partner_signup.jsp?t=view&domain='+euc(domain)); //No I18N
		}
		else if(result == "INVALID_ADMINPASSWORD") {
            showerrormsg("Invalid Administrator password"); // No I18N
            f.pwd.value='';
            f.pwd.focus();
        }
		else if(result=="DOMAIN_NAME_EXIST"){
        	showerrormsg('Domain name already exist'); //No I18n
        	f.partner_domain.focus();
        }
		else{
			showerrormsg(result);
        }
	}
	return false;
}
function uploadPartnerLogo(f){
	var file=f.partner_logo.value;
	var extension = file.lastIndexOf(".") == -1 ? "" : file.substring(file.lastIndexOf(".")+1).toLowerCase();
	if(isEmpty(file)){
		showerrormsg("Please enter the partner logo");//No I18N
		f.partner_logo.focus();
		return false;
	}else if(file != "" && (file.lastIndexOf(".") == -1 || (extension != "jpg" && extension != "gif" && extension != "png" && extension != "jpeg"))) {//No I18N
        showerrormsg("Please enter a valid image");// No I18N
        f.partner_logo.focus();
        return false;
    }else{
    	f.submit();
    	f.reset();
    	return false;
    }
}
function searchPartnerAccountDomain() {
	var partnerDomain = de('partnerdomain').value.trim(); //No I18N
	if(isEmpty(partnerDomain)) {
		showerrormsg("Please enter a partner domain");//No I18N
		de('partnerdomain').focus(); //No I18N
		return false;
	}
	else if(!isDomain(partnerDomain)) {
		showerrormsg("Please Enter a valid domain name"); // No I18N
		de('partnerdomain').focus(); //No I18N
		return false;
	}
	loadui('/ui/admin/partner_signup.jsp?t=view&domain='+euc(partnerDomain)); //No I18N
}
function showUplloadPhotoError(msg){
	showerrormsg(msg);
}
function openLogoWindow() {
	$("#opacity").show();$(".partnerlogoform").show();
	
}function closeLogoWindow() {
	$('.partnerlogoform').hide();$('#opacity').hide();
	var imgSrc = $("#partnerimg")[0].src.substring(0,$("#partnerimg")[0].src.lastIndexOf("&"));
	 $("#partnerimg")[0].src = imgSrc+"&nocache="+(new Date()).getTime();
}
function addPartnerConfigWindow(p) {
    if(p == 'show' && de('addPartnerConfig').style.display == 'none') {
    	if(de('updatePartnerConfig')){
    		de('updatePartnerConfig').style.display='none';
    	}
    	de('addPartnerConfig').style.display='';
       } else if(p == 'hide' && de('addPartnerConfig').style.display != 'none') { //No I18N
    	   document.addpartnerconfiguration.reset();
           de('addPartnerConfig').style.display='none';
        }
}
function updatePartnerConfigWindow(p) {
    if(p == 'show' && de('updatePartnerConfig').style.display == 'none') {
    	de('updatePartnerConfig').style.display='';
    	de('updatepartnerconfigvalue').focus(); //No I18N
    } else if(p == 'hide' && de('updatePartnerConfig').style.display != 'none') { //No I18N
    	document.updatepartnerconfiguration.reset();
    	de('updatePartnerConfig').style.display='none';
    }
}
function addPartnerConfiguration(f) {
	var name = f.name.value.trim();
	var value = f.value.value.trim();
	var pwd = f.pwd.value.trim();
	var domain = f.domain.value.trim();
    if(isEmpty(name)) {
        showerrormsg("Please Enter the configuration Name"); // No I18N
        f.name.focus();
    }
    else if(isEmpty(value)) {
        showerrormsg("Please Enter the configuration Value"); // No I18N
        f.value.focus();
    }
    else if(isEmpty(pwd)) {
        showerrormsg("Please Enter Administrator password"); // No I18N
        f.pwd.focus();
    }
    else {
    	var params = "action=add&name=" + euc(name) + "&value=" + euc(value) + "&domain=" + euc(domain) + "&pwd="+euc(pwd) +"&"+ csrfParam; // No I18N
        var resp = getPlainResponse(contextpath+"/admin/partneraccount/configuration",params); //No I18N
        var sresult=resp.split('-');
        resp=sresult[0].trim();
        var iplist=sresult[1];
        if(resp=="SUCCESS") {
            showsuccessmsg("Successfully added"); // No I18N
            clearSelectedAppServers("Do you want to clear cache in all app servers",false,iplist);// No I18N
            addPartnerConfigWindow('hide'); //No I18N
        }
		else if(resp == "INVALID_ADMINPASSWORD") {
            showerrormsg("Invalid Administrator password"); // No I18N
            f.pwd.focus();
        }
		else if(resp == "INVALID_PARTNERACCOUNT") {
			showerrormsg("PartnerAccount not registered for the "+domain);//No I18N
		}
		else if(resp == "ALREADY_EXISTS") {
			showerrormsg(name+" is already exists");//No I18N
			f.name.focus();
		}
        else {
            showerrormsg(resp); // No I18N
        }
    }
	return false;
}
function updatePartnerConfiguration(f) {
	var name = f.name.value.trim();
	var value = f.value.value.trim();
	var pwd = f.pwd.value.trim();
	var domain = f.domain.value.trim();
    if(isEmpty(value)) {
        showerrormsg("Please Enter the configuration Value"); // No I18N
        f.value.focus();
    }
    else if(isEmpty(pwd)) {
        showerrormsg("Please Enter Administrator password"); // No I18N
        f.pwd.focus();
    }
    else {
    	var params = "action=update&name=" + euc(name) + "&value=" + euc(value) + "&domain=" + euc(domain) + "&pwd="+euc(pwd) +"&"+ csrfParam; // No I18N
        var resp = getPlainResponse(contextpath+"/admin/partneraccount/configuration",params); //No I18N
        var sresult=resp.split('-');
        resp=sresult[0].trim();
        var iplist=sresult[1];
        if(resp=="SUCCESS") {
            showsuccessmsg("Successfully updated"); // No I18N
            clearSelectedAppServers("Do you want to clear cache in all app servers",false,iplist);// No I18N
            updatePartnerConfigWindow('hide'); //No I18N
        }
		else if(resp == "INVALID_ADMINPASSWORD") {
            showerrormsg("Invalid Administrator password"); // No I18N
            f.pwd.focus();
        }
		else if(resp == "INVALID_PARTNERACCOUNT") {
			showerrormsg("PartnerAccount not registered for the "+domain);//No I18N
		}
		else if(resp == "INVALIED_NAME") {
			showerrormsg("Configuration name is not added yet");//No I18N
		}
        else {
            showerrormsg(resp); // No I18N
        }
    }
	return false;
}
function deletePartnerConfiguration(domain, name) {
    if(confirm('Are you sure to delete this configuration?')) {
    	var params = "domain=" + euc(domain) + "&name=" + euc(name) + "&" + csrfParam; // No I18N
        showverificationform(contextpath+"/admin/partneraccount/deleteconfig",params, deletePartnerConfigurationResp); //No I18N
    }
    return false;
}
function deletePartnerConfigurationResp(resp) {
    resp = resp.trim();
    if(resp.indexOf("SUCCESS_IAM_") !== -1) {
    	var iplist = resp.split("_IAM_")[1];
        showsuccessmsg("Successfully deleted"); // No I18N
        clearSelectedAppServers("Do you want to clear cache in all app servers",false,iplist);// No I18N
        hideverificationform();
    }
    else if(resp == "INVALID_PARTNERACCOUNT"){
        showerrormsg("PartnerAccount not registered"); // No I18N
    }
    else if(resp == "INVALIED_NAME"){
        showerrormsg("Configuration name is not added yet"); // No I18N
    }
    else if(resp == "INVALID_ADMINPASSWORD") {
        showerrormsg("Invalid Administrator password"); // No I18N
    }
    else {
        showerrormsg(resp); // No I18N
    }
    return false;
}
function clearPartnerAccountAgentCache(f) {
	$("#details ,#result").hide();
	var serviceName = html5support()?f.servicename[1].value.trim():serviceName=f.servicename[0].value.trim();
	var pwd = f.pwd.value.trim();
	if(isEmpty(serviceName)){
		showerrormsg("Please select service Name");// No I18N
	}
	else if(isEmpty(pwd)){
		showerrormsg("Please enter admin password");// No I18N
	}
	else{
		var params = "servicename="+euc(serviceName)+"&pwd="+euc(pwd)+"&"+csrfParam;// No I18N
		var sresult = getPlainResponse(contextpath +"/admin/clearpartneragentcache",params);// No I18N
		sresult = sresult.split("|||");
		var result=sresult[0].trim();
		if(result == "success"){
			showsuccessmsg("Cache cleared "+serviceName+" service");//No I18N
			if(sresult.length >= 3){
				handleClearCacheResult(sresult[1].trim(),sresult[2].trim());	
			}
			f.reset();
		}
		else if(result == "INVALID_ADMINPASSWORD"){//No I18N
			showerrormsg("Invalid Administrator password");//No I18N
			f.pwd.value = "";
		}
		else if(result == "failed"){ //No I18N
			showerrormsg("Clear cache failed");//No I18N
			f.reset();
		}
	}
}
function handleClearCacheResult(success,failed) {
	var result="<ul>";
	if(!isEmpty(success)) {
	var services = success.split(",");
	result +="<li style='font-weight:bold;padding:5px'>Cache cleared services:</li><ol>";//No I18N
	for ( var i in services) {
		if(!isEmpty(services[i])){
				result+="<li>"+services[i]+"</li>";
		}
	}
	result+="</ol>";
	}

	if(!isEmpty(failed)){
	var services = failed.split(",");
		result +="<li style='font-weight:bold;margin-top:15px;padding:5px'>Clear cache failed services:</li><ol>";//No I18N
		for ( var i in services) {
			if(!isEmpty(services[i])){
				result+="<li>"+services[i]+"</li>";
			}
		}
		result+="</ol>";	
	}
	result+="</ul>";
	result+="<a href=\"javascript:;\" onclick=\"de('result').style.display='none';\">Ok &laquo;</a>";
	if(de("result")) {
		$("#result").html(result);//No I18N
		$("#result").show();
	}
	if(de("details")) {
		$("#details").show();
	}
}

function changeClearCacheForm(ele, show) {
    if(ele.className == 'disablerslink') {
        return false;
    }
    if(show) {
        de('iam_cache_link').className = 'disablerslink';
        de('agent_cache_link').className = 'activerslink';
        de('agent_clearcache').style.display = 'none';
        de('iam_clearcache').style.display = '';
    } else {
        de('agent_cache_link').className = 'disablerslink';
        de('iam_cache_link').className = 'activerslink';
        de('iam_clearcache').style.display = 'none';
        de('agent_clearcache').style.display = '';
    }
    if(de('agent_clearcache')) {
    	document.clearagentcache.reset();
    }
    return false;
}
function clearAgentConfigurationCache(f) {
    var sobj;
    html5support() ? sobj = f.serviceName[1] : sobj = f.serviceName[0];
    var sname = sobj.value.trim(); 
	var url_param = f.url_param.value.trim();
    var pwd = f.pwd.value.trim();
    if(isEmpty(sname) || sname == 'select') {
        showerrormsg("Please select a service name"); // No I18N
        sobj.focus();
    } else if(isEmpty(url_param) || url_param == 'select') { //No I18N
        showerrormsg("Please select a configuration"); // No I18N
        sobj.focus();
    } else if(isEmpty(pwd)) {
        showerrormsg("Please Enter Administrator password"); // No I18N
        f.pwd.focus();
    } else {
    	if(f.clr_status.value.trim() == '1') {
    		if(!confirm("Are you sure to clear the AGENT cache?")) {
    			return false;
    		}
    	} else {
    		if(!confirm("You are trying to clear the AGENT cache again. Pls confirm")) {
    			return false;
    		}
    	}
    	f.clr_status.value = '0';
    	$("#details").hide();
    	$("#result").hide();
    	
		var params = "servicename="+euc(sname)+"&url_param="+euc(url_param)+"&pwd="+euc(pwd)+"&"+csrfParam;// No I18N
		var resp = getPlainResponse(contextpath +"/admin/iamagentcache/clear",params);// No I18N
		resp = resp.trim();
		if(resp == 'SUCCESS') {
			showsuccessmsg("Agent cache cleared for "+sname+" service");//No I18N
		} else if(resp.indexOf('SUCCESS') != -1) { //No I18N
			var result = resp.split("|||");
			var successResp, failedResp;
			if(result.length > 1) {
				successResp = result[1].trim();
			}
			if(result.length > 2) {
				failedResp = result[2].trim();
			}
			handleClearCacheResult(successResp, failedResp);
		} else if(resp == "INVALID_ADMINPASSWORD"){//No I18N
			showerrormsg("Invalid Administrator password");//No I18N
			f.pwd.value = "";
		} else {
			showerrormsg(resp);
		}
    }
	return false;
}

function showTFADetails(id,zuid) {
	showDetails(id);
	if(de('tfasetting_maincontainer') == null) {
		var params = "zuid="+euc(zuid); //No I18N
		sendRequestWithCallback(contextpath+"/ui/admin/tfadetails.jsp?"+params,"",true,function(res){ //No I18N
			if(!res) {
	            return;
	        }
			de('tfa_details').innerHTML=res; //No I18N
			de('tfa_details').style.display=''; //No I18N
		},"GET"); //No I18N
		return false;
	}
}

//Cache Node property add js
function addIcon(e) {
    var ele = e.parentNode.parentNode;
    var html = '<input type="text" class="input" placeholder="Key" />';
    html += '<span>&nbsp;</span>'; // No I18N
    html += '<input type="text" class="input"    placeholder="Value" />';
    html += '<span>&nbsp;</span>'; // No I18N
    html += '<span class="removeEDicon hideicons" onclick="removeADIcon(this)">&nbsp;</span>'; //No I18N
    html += '<span>&nbsp;</span>'; // No I18N
    html += '<span class="addEDicon hideicons chaceicon" onclick="addIcon(this)">&nbsp;</span>';
    var div = document.createElement('div');
    div.innerHTML = html;
    div.className = 'edipdiv';
    ele.appendChild(div);
    if(etripstd && etripstd.childElementCount <= 2){
       e.className = 'removeEDicon hideicons';
     }else{
       e.remove();
     }
    e.onclick = function(){removeADIcon(this);};
}

//Cluster UI fns begin
function deleteCluster(cluster) {
	if(confirm("Are you sure to delete "+cluster+" ?")) {//No I18N
        var params ="op=delete&cluster="+euc(cluster)+"&"+csrfParam; //No I18N
        showverificationform(contextpath+"/admin/cluster/op", params, clusterResponse); //No I18N
    }
    return false;
}

function delNode(cluster,node) {
	if(confirm("Are you sure to delete "+node+" from "+cluster+" cluster?")) {//No I18N
        var params ="op=delete&cluster="+euc(cluster)+"&node="+euc(node)+"&"+csrfParam; //No I18N
        showverificationform(contextpath+"/admin/cluster/node/op", params, clusterResponse); //No I18N
    }
    return false;
}

function addCluster(){
	$("#adddiv").toggleClass('hide');//No I18N
	$("#listdiv").toggleClass('hide');//No I18N
	$(".addbut").toggleClass('hide');//No I18N
}

function postCluster(form){
	var json ={};
	json["cluster"]=form.cluster.value.trim();//No I18N
	json["sync"]=form.sync.checked;//No I18N
	json["syncget"]=form.syncget.checked;//No I18N
	if(!isEmpty(form.syncname.value.trim())){//No I18N
		json["synccluster"]=form.syncname.value.trim();//No I18N
	}
	params="json="+euc(JSON.stringify(json))+"&op=add&"+csrfParam; //No I18N
    showverificationform(contextpath+"/admin/cluster/op", params, clusterResponse); //No I18N	
}

function postNode(form,op){
	var json ={};
	json["cluster"]=form.cluster.value.trim();//No I18N
	json["node"]=form.node.value.trim();//No I18N
	json["ctype"]=form.ctype.value.trim();//No I18N
	json["node"]=form.node.value.trim();//No I18N
	json["ipport"]=form.serverip.value.trim();//No I18N
	json["cprop"]=getCacheProps();//No I18N
	json["range"]=getRanges();//No I18N
	params="json="+euc(JSON.stringify(json))+"&op="+op+"&"+csrfParam; //No I18N
    showverificationform(contextpath+"/admin/cluster/node/op", params, clusterResponse); //No I18N	
}

function editToggle(thisR){
	if($("input[disabled='disabled']."+$(thisR).attr("cluster")).length>0){//No I18N
		$("#editbutton").text("edit");//No I18N
		$(thisR).text("Save");//No I18N
		$(".editable").attr("disabled","disabled");//No I18N
		$("input[disabled='disabled']."+$(thisR).attr("cluster")).removeAttr("disabled");//No I18N
	}else{
		$(thisR).text("Edit");//No I18N
		$(".editable").attr("disabled","disabled");//No I18N
		putClusterCache($(thisR).attr("cluster"));//No I18N
	}
}

function putClusterCache(clustername){
	var json={};
	$(".rest.editable."+clustername).each(function(){//No I18N
		if(!isEmpty($(this).val())){
			json[$(this).attr("restname")]= $(this).val();//No I18N
		}
	});
	params="json="+euc(JSON.stringify(json))+"&cluster="+euc(clustername)+"&op=update&"+csrfParam; //No I18N
    showverificationform(contextpath+"/admin/cluster/op", params, clusterResponse); //No I18N	
}

function clusterResponse(resp){
	 resp = resp ? resp.trim() : "";//No I18N
	    if(resp === "SUCCESS") {//No I18N
	        showsuccessmsg("Operation Successfull"); // No I18N
	        loadui('/ui/admin/cluster/clusteradmin.jsp?op=view');//No I18N
	        hideverificationform();
	    }
	    else if(resp === "INVALID_ADMINPASSWORD") {
	        showerrormsg("Invalid Administrator password"); // No I18N
	    }
	    else {
	        showerrormsg("Error :: "+resp); // No I18N
	    }
	    return false;
}

function getCacheProps()
{
	var ips = de('cprops').getElementsByTagName('div');// No I18N
	var cacheproperties="";
	for(var i=0;i<ips.length;i++)
	{
		 var inputs = ips[i].getElementsByTagName('input');//No I18N
	     var iputone = inputs[0].value.trim();
	     var iputtwo = inputs[1].value.trim();
	     if((iputone)&&(iputtwo))
		  {
			cacheproperties+=iputone+"="+iputtwo+",";//No I18N
		  }
	}
    cacheproperties = cacheproperties.substring(0,cacheproperties.length-1);
	return encodeURIComponent(cacheproperties);
}

function getRanges()
{
	var ips = de('cranges').getElementsByTagName('div');// No I18N 
	var synccacheproperties=[];
	for(var i=0;i<ips.length;i++)
	{
		 var inputs = ips[i].getElementsByTagName('input');//No I18N
	     var fromip = inputs[0].value.trim();
	     var toip = inputs[1].value.trim();
		if((fromip)&&(toip))
		{
			prop=[];
			prop[0]=fromip;
			prop[1]=toip;
			synccacheproperties[i] = prop;
		}
		
	}
	return encodeURIComponent(JSON.stringify(synccacheproperties));
}
//Cluster UI fns end

function postLocation(form){
	params="location="+euc(form.location.value.trim())+"&url="+euc(form.url.value.trim())+"&uloc="+euc(form.uloc.value.trim()) + "&bd="+euc(form.bd.value.trim())+ "&ebd="+euc(form.ebd.value.trim())+ "&"+csrfParam; //No I18N
    showverificationform(contextpath+"/admin/dclocation/add", params, locationResponse); //No I18N	
    
}

function addLink(){
	$("#ladddiv").toggleClass('hide');//No I18N
	$("#listdiv").toggleClass('hide');//No I18N
	$(".addbut").toggleClass('hide');//No I18N
}

function postLink(form){
	params="location="+euc(form.location.value.trim())+"&od="+euc(form.od.value.trim())+"&td="+euc(form.td.value.trim())+"&ename="+euc(form.ename.value.trim())  +"&"+csrfParam; //No I18N
    showverificationform(contextpath+"/admin/dclink/add", params, locationResponse); //No I18N	
    
}

function deleteLocation(location){
	params="location="+euc(location)+"&"+csrfParam; //No I18N
    showverificationform(contextpath+"/admin/dclocation/delete", params, locationResponse); //No I18N	
}

function locationResponse(resp){
	 resp = resp ? resp.trim() : "";//No I18N
	    if(resp == "true") {//No I18N
	        showsuccessmsg("Operation Successfull"); // No I18N
	        loadui('/ui/admin/dclocation/dclocations.jsp');//No I18N
	        hideverificationform();
	    }else if(resp === "INVALID_ADMINPASSWORD") {// No I18N
	        showerrormsg("Invalid Administrator password"); // No I18N
	    }
	    else {
	        showerrormsg("Error :: "+resp); // No I18N
	    }
	    return false;
}
//Redis message fns begin
function sendRedisMessage(form){
	if(form){
		var params ="source="+euc(form.source.value.trim())+"&dest="+euc(form.dest.value.trim())+"&msg="+euc(form.msg.value.trim());//No I18N
		if(form.template.value.trim()==="Custom"){//No I18N
			params+="&op=snd&handler="+euc(form.handler.value.trim())+"&method="+euc(form.method.value.trim());//No I18N
		}else{
			params+="&op=sndtemplate&template="+euc(form.template.value.trim());//No I18N
		}
		var result = getPlainResponse(contextpath+'/admin/redismsg', params+"&"+csrfParam);//No I18N
		result = result.trim();
		if(result==="Failed"){
	        showerrormsg("Failed to send msg"); // No I18N
		}else{	
			showsuccessmsg("Successfully recieved By "+result+" clients");//No I18N
		}
	}
}

function bindCustomChecker(sel){
		if($(sel).val()==="Custom"){
			$(".hiddenuntilcustom").css("display","block");//No I18N
		}else{
			$(".hiddenuntilcustom").css("display","none");//No I18N
		}
}
//Redis message fns end

/***** Oauth UI*/
function  showOAuthDesc(f) {
	var scopeName = f.scopename.value.trim();
	var desc = f.desc.value.trim();
	var custom = f.custom1.checked;
	var read = f.read1.checked;
	var create = f.create1.checked;
	var update = f.update1.checked;
	var del = f.delete1.checked;
	if(isEmpty(scopeName)) {
        showerrormsg("Please enter valid scopeName"); // No I18N
        f.scopename.focus();
        return;
    }
	if(isEmpty(desc)) {
        showerrormsg("Please enter valid description"); // No I18N
        f.desc.focus();
        return;
    } 
	if(!(read || create || update || del || custom)){
		showerrormsg("Scope should be valid in atleast one operation-type");//No I18N
		f.read.focus();
        return;
	}
	$(".initailOauthDiv").hide();
	$(".dessOauth").show();
	if(read){
		$(".showREAD").show();
	}
	if(create){
		$(".showCREATE").show();
	}
	if(update){
		$(".showUPDATE").show();
	}
	if(create && update){
		$(".showCREATEUPDATE").show();
	}
	if(del){
		$(".showDELETE").show();
	}
	if(create && update && del){
		$(".showWRITE").show();
	}
	if(read && create && update && del){
		$(".showALL").show();
	}
	if(custom){
		$(".showCustom").show();
	}
}

function addOAuthScope(f, oldScopeId) {
    var serviceId = f.serviceid.value.trim();
    if(isEmpty(serviceId)) {
    	showerrormsg("Please select valid serviceName"); // No I18N
        f.serviceid.focus();
        return false;
    }
    var scopeName = f.scopename.value.trim();
    var internal = f.internal.value.trim();
    var desc = f.desc.value.trim();
    var scopeExposedType = f.isExposed.value.trim();
	var read = f.read1 != null ?f.read1.checked : false;
	var create = f.create1 != null ? f.create1.checked : false;
	var update = f.update1 != null ? f.update1.checked : false;
	var del = f.delete1 != null ? f.delete1.checked : false;
	var custom = f.custom1 != null ? f.custom1.checked : false;
    if(isEmpty(scopeName)) {
        showerrormsg("Please enter valid scopeName"); // No I18N
        f.scope.focus();
        return false;
    }
    if(isEmpty(desc)) {
        desc = scopeName;
    }
    var params = "serviceid=" + euc(serviceId) + "&scopename=" + euc(scopeName) + "&desc=" + euc(desc) + "&isExposed=" + scopeExposedType + "&internal=" + euc(internal) + "&" + csrfParam; //No I18N
    
    if(!isEmpty(oldScopeId)) {
        params += "&oldScopeId=" + euc(oldScopeId.trim()); //No I18N
        if(!(read || create || update || del || custom)){
        	 showerrormsg("Scope should be valid in atleast one operation"); // No I18N
             return false;
        }
        if(read){
        	params += "&READ="+euc(read);
        }
        if(create){
        	params += "&CREATE="+euc(create); 
        }
        if(update){
        	params += "&UPDATE="+euc(update);
        }
        if(del){
        	params += "&DELETE="+euc(del);
        }
        if(custom){
        	params += "&CUSTOM="+euc(custom);//No I18N
        }
    } else {
		var ALL = f.ALL.value.trim();
		var WRITE = f.WRITE.value.trim();
		var READ = f.READ.value.trim();
		var CREATEUPDATE = f.CREATEUPDATE.value.trim();
		var CREATE = f.CREATE.value.trim();
		var UPDATE = f.UPDATE.value.trim();
		var DELETE = f.DELETE.value.trim();
		var CUSTOM = f.CUSTOM.value.trim();
		if(read && isEmpty(READ) || create && isEmpty(CREATE) || update && isEmpty(UPDATE) || del && isEmpty(DELETE)){
			showerrormsg("Please give valid description"); // No I18N
			return false;
		}

		if(!isEmpty(CREATE) && !isEmpty(UPDATE)){
			if(isEmpty(CREATEUPDATE)){
				showerrormsg("Please give valid description for CREATEUPDATE as well");//NO I18N
				f.CREATEUPDATE.focus();
				return false;
			}
		}
		
		if(!isEmpty(CREATE) && !isEmpty(UPDATE) && !isEmpty(DELETE)){
			if(isEmpty(WRITE)){
				showerrormsg("Please give valid description for WRITE as well");//NO I18N
				f.WRITE.focus();
				return false;
			}
		}
		
		if(!isEmpty(CREATE) && !isEmpty(UPDATE) && !isEmpty(DELETE) && !isEmpty(READ)){
			if(isEmpty(ALL)){
				showerrormsg("Please give valid description for ALL as well");//NO I18N
				f.ALL.focus();
				return false;
			}
		}
		
		if(custom && isEmpty(CUSTOM)){
			showerrormsg("Please give valid descruption for CUSTOM as well");//No I18N
			f.CUSTOM.focus();
			return false;
		}
    	params = params + "&isI18N=" + f.isI18N.checked + "&ALL=" + euc(ALL) + "&WRITE=" + euc(WRITE) + "&READ=" + euc(READ) + "&CREATEUPDATE=" + euc(CREATEUPDATE) + "&CREATE=" + euc(CREATE) + "&UPDATE=" + euc(UPDATE) + "&DELETE=" + euc(DELETE) + "&CUSTOM=" + euc(CUSTOM);//No I18N
    }
    var resp = getPlainResponse(contextpath + "/admin/oauthscope/add", params); //No I18N
    var sresult=resp.split('-');
    resp=sresult[0].trim();
    var iplist=sresult[1];
    if(resp == "SUCCESS") {
        if(isEmpty(oldScopeId)) {
            showsuccessmsg(scopeName+" scope created successfully"); //No I18N
            loadui('/ui/admin/oauthScope.jsp?t=view'); //No I18N
        } else {
            showsuccessmsg(scopeName+" scope updated successfully"); //No I18N
            loadui('/ui/admin/oauthScope.jsp?t=editdesc&scopeid='+sresult[2]); //No I18N
        }
        clearSelectedAppServers("Do you want to clear cache in all app servers",false,iplist);// No I18N
    } else {
        showerrormsg(resp);
    }
    return false;
}

function updateOAuthDesc(f, serviceId, scopeId) {
	var params = "serviceid=" + euc(serviceId) + "&oldScopeId=" + euc(scopeId.trim())  + "&updateDesc=true" + "&" + csrfParam; //No I18N
	var elements = f.elements;
	for(var i =0 ; i< elements.length; i++){
		if(elements[i].type == 'text' ){
			if(isEmpty(elements[i].value)){
				showerrormsg(elements[i].name + " Description cannot be empty"); // No I18N
				return false;
			}else{
				params += "&"+elements[i].name+"="+elements[i].value.trim();
			}
		}
	}
    var resp = getPlainResponse(contextpath + "/admin/oauthscope/add", params); //No I18N
    var sresult=resp.split('-');
    resp=sresult[0].trim();
    var iplist=sresult[1];
    if(resp == "SUCCESS") {
        showsuccessmsg("scope updated successfully"); //No I18N
        clearSelectedAppServers("Do you want to clear cache in all app servers",false,iplist);// No I18N
        loadui('/ui/admin/oauthScope.jsp?t=view'); //No I18N
    } else {
        showerrormsg(resp);
    }
    return false;
}

function deleteOAuthScope(scopeName, servicename) {
    var params = "scopename=" + euc(scopeName) + "&servicename=" + euc(servicename) + "&" + csrfParam; //No I18N
    showverificationform(contextpath + "/admin/oauthscope/delete", params, deleteOAuthScopeResp); //No I18N
    return false;
}

function deleteOAuthScopeResp(resp) {
    if(resp == 'INVALID_ADMINPASSWORD') {
        showerrormsg('Invalid Administrator password'); // No I18N
        return false;
    } else if(resp.indexOf("SUCCESS_IAM_") !== -1) {
        var scopeName = resp.split("_IAM_")[1];
        var iplist = resp.split("_IAM_")[2];
        showsuccessmsg(scopeName+" scope deleted successfully"); // No I18N
        clearSelectedAppServers("Do you want to clear cache in all app servers",false,iplist);// No I18N
        loadui('/ui/admin/oauthScope.jsp?t=view'); // No I18N    
        initSelect2();
    } else {
        showerrormsg(resp);
    }
    hideverificationform();
    return false;
}

function loadupdateOAuthSubScope(url) {
	loadui(url);
	$(".chosen-oath-admin-select").select2();
}

function updateOAuthSubScope(f, serviceName, scopeId) {
	
	 var options = f.subIds && f.subIds.options;
	  var opt;
	  var result="";
	  for (var i=0, iLen=options.length; i<iLen; i++) {
	    opt = options[i];

	    if (opt.selected) {
	    	if(result.length != 0) {
	    		result = result + ",";
	    	}
	    	result = result + (opt.value || opt.text);
	    }
	  }
	  
	  var params = "serviceName=" + euc(serviceName) + "&scopeId=" + euc(scopeId)+ "&subScopes=" + euc(result) + "&" + csrfParam; //No I18N
	    var resp = getPlainResponse(contextpath + "/admin/oauthscope/subscope/add", params); //No I18N
	    var sresult=resp.split('_IAM_');
	    resp=sresult[0].trim();
	    var iplist=sresult[2];
	    if(resp == "SUCCESS") {
	        showsuccessmsg(scopeId+" scope updated successfully"); //No I18N
	        clearSelectedAppServers("Do you want to clear cache in all app servers",false,iplist);// No I18N
	        loadui('/ui/admin/oauthScope.jsp?t=view'); //No I18N
	    } 
	    else if(resp == "INVALID_OPERATION") {
	    	var invalidsubscopes = sresult[1];
	    	de("invalidsubscope").style.display='block'; //No I18N
	    	de("invalidsubscopelist").innerHTML = invalidsubscopes; //No I18N
        }
	    else {
	        showerrormsg(resp);
	    }
	    return false;
}

function invalidsubscopeform(p)
{
	if( p == "hide"){
		loadui('/ui/admin/oauthScope.jsp?t=view'); //No I18N
	}
}


/**OAuthUI Changes ends*/
/*** Org Merge Cases **/
function fetchOrgdetails(f) {
	var fromOrgID = f.fromOrgId.value.trim();
    var toOrgID = f.toOrgId.value.trim();
    var params = "fromOrgID=" + euc(fromOrgID) + "&toOrgID=" + euc(toOrgID) + "&" + csrfParam; //No I18N
    var resp = getPlainResponse(contextpath + "/admin/org/fetchdetails", params); //No I18N
    if(!isJson(resp)) {
    	showerrormsg(resp);
    }
    var obj = JSON.parse(resp);
    de("idsfromOrgId").value =fromOrgID;// No I18N
    de("idstoOrgId").value =toOrgID;// No I18N
    de("idsfromorgName").value =obj.account_name;// No I18N
    de("idsfromOrgContact").value =obj.created_by;// No I18N
    de("idstoorgName").value =obj.NEW_ORG_NAME;// No I18N
    de("idstoOrgContact").value =obj.NEW_CONTACT_EMAIL;// No I18N
    de("idsfromorgdomain").value =obj.domains;// No I18N
    de("idsfromorggroup").value =obj.groups;// No I18N
    
    
    var dataloss = "";
    if(obj.dataloss_appaccounts!=null){
	    for (var i = 0; i < obj.dataloss_appaccounts.length; i++) {
	        var appacc = obj.dataloss_appaccounts[i];
	        if(dataloss.length != 0) {
	        	dataloss = dataloss + ",";
	    	}
	        dataloss = dataloss +   appacc.zaaid + "--" + appacc.screen_name + "-" + appacc.app_name;
	    }
    }
    var manditory = "";
    if(obj.manditory_appaccounts!=null){
	    for (var i = 0; i < obj.manditory_appaccounts.length; i++) {
	        var appacc = obj.manditory_appaccounts[i];
	        if(manditory.length != 0) {
	        	manditory = manditory + ",";
	    	}
	        manditory = manditory +   appacc.zaaid + "--" + appacc.screen_name + "-" + appacc.app_name;
	    }
    }
    var innerhtml = "";
    if(obj.appaccounts!=null){
    	for (var i = 0; i < obj.appaccounts.length; i++) {
            var appacc = obj.appaccounts[i];
            innerhtml = innerhtml +  "<option value=" + appacc.zaaid +  " selected>" + appacc.screen_name + "-" + appacc.app_name + "</option> ";
        }
    }
    if(obj.optional_appaccounts!=null){
    	for (var i = 0; i < obj.optional_appaccounts.length; i++) {
            var appacc = obj.optional_appaccounts[i];
            innerhtml = innerhtml +  "<option value=" + appacc.zaaid +  ">" + appacc.screen_name + "-" + appacc.app_name + "</option> ";
        }
    }
    var migrated = "";
    if(obj.migrated_to_org!=null) {
    	for(var i = 0; i < obj.migrated_to_org.length; i++) {
    		var appacc = obj.migrated_to_org[i];
        	migrated = migrated +   appacc.zaaid + "--" + appacc.screen_name + "-" + appacc.app_name;
    	}
    }
    de("idsdataLossappacc").value = dataloss;// No I18N
    alert(innerhtml);
    de("idsmantappacc").value = manditory;// No I18N
    de("idsmigorgappacc").value = migrated; //No I18N
    de("idsappaccs").innerHTML = innerhtml;// No I18N
    $("#idsappaccs").select2();
    showHideDivsByID("showDetailsdiv", "getDetailsdiv");// No I18N
    return false;
}

function mergeOrgdetails(f) {
	var fromOrgID = f.fromOrgId.value.trim();               
	var toOrgID=f.toOrgId.value.trim();
	var adminPassword = f.aminpass.value.trim();
	var options = f.subIds && f.subIds.options;
	var mandate = f.idsmantappacc.value;
	 var opt;
	 var result="";
	  for (var i=0, iLen=options.length; i<iLen; i++) {
	    opt = options[i];

	    if (opt.selected) {
	    	if(result.length != 0) {
	    		result = result + ",";
	    	}
	    	result = result + (opt.value || opt.text);
	    }
	  }
	 
	 if( mandate!=null && mandate!=""){
		 var app_array = mandate.split(',');
		 for(var i = 0; i < app_array.length; i++) {
			 var app = app_array[i];
			 var zaaid = app.split("--")[0];
			 if(result.length != 0) {
		    		result = result + ",";
			 }
			 result = result + zaaid;
		 }
	 }
    var params = "fromOrgID=" + euc(fromOrgID) + "&toOrgID=" + euc(toOrgID) +"&subIds=" + euc(result)  +"&pwd=" + euc(adminPassword) + "&retailRole=" + f.retailRole.checked  + "&" + csrfParam; //No I18N
    var resp = getPlainResponse(contextpath + "/admin/org/mergeOrgs", params); //No I18N
    var obj = JSON.parse(resp);
    if(obj.success == "true") {
    	 showHideDivsByID("resultDetailsdiv", "showDetailsdiv");// No I18N
    	 de("idsusrmig").value =obj.Users_migrated;// No I18N
    	 de("idsappaccmig").value =obj.Appaccount_migrated;// No I18N
    	 de("idsappaccskp").value =obj.Appaccount_skipped;// No I18N
    	 de("idsgrpmig").value =obj.Groups_migrated;// No I18N
    	 de("idsdomainmig").value =obj.Domains_migrated;// No I18N
    	
    } else if(obj.error) {
        showerrormsg(obj.error);
    } else {
        showerrormsg("ERROR_OCCURED");//NO I18N
    }
    return false;
}
/*** Org Merge ends **/
	
	function showHideDivsByID(showdiv, hidediv) {
		$("#"+hidediv).hide();
		$("#"+showdiv).css("display","block");
	}
	
	/**  Soid Db Admin Console**/
	
	function createSpace(resourceSpace) {
		de('IddbName').value= resourceSpace; // No I18N
		de('associateSOrgDBID').style.display='none';
		de('createSOrgDBID').style.display='';
		
		updatesysconfigform('show');// No I18N
	}
	function associateSorgDiv(resourceSpace) {
		de('IdsOrgName').value= resourceSpace; // No I18N
		de('createSOrgDBID').style.display='none';
		de('associateSOrgDBID').style.display='';
		updatesysconfigform('show');// No I18N
	}
	
	
	function createSorgDB(f) {
		var dbName = f.dbName.value.trim();
		var clusterName=f.clusterName.value.trim();
		var pwd = f.pwd.value.trim();
		var params = "dbName=" + euc(dbName) + "&clusterName=" + euc(clusterName) +"&pwd=" + euc(pwd) + "&" + csrfParam; //No I18N
		var resp = getPlainResponse(contextpath + "/admin/sorg/createDB", params).trim(); //No I18N
		if(resp=="SUCESS") {
            showsuccessmsg("Space Created SucessFully"); // No I18N
            loadui('/ui/admin/service_org_details.jsp'); //No I18N
        } else if(resp=="INVALID_ADMINPASSWORD") { // No I18N
            showerrormsg("Invalid Admin Password"); // No I18N
        } else if(resp=="DB_ALREADY_EXIST") { // No I18N
            showerrormsg("DB Already Exist"); // No I18N
        } else {
            showerrormsg("Error While Creating Space"); // No I18N
        }
		return false;
	}
	
	function associateSorg(f) {
		var sorgName = f.sorgName.value.trim();               
		var pwd = f.pwd.value.trim();
		var params = "sorgName=" + euc(sorgName) +"&pwd=" + euc(pwd) + "&" + csrfParam; //No I18N
		var resp = getPlainResponse(contextpath + "/admin/sorg/associateSorg", params).trim(); //No I18N
		if(resp=="SUCESS") {
            showsuccessmsg("ServiceOrg Space Created SucessFully"); // No I18N
            loadui('/ui/admin/service_org_details.jsp'); //No I18N
        } else if(resp=="INVALID_ADMINPASSWORD") { // No I18N
            showerrormsg("Invalid Admin Password"); // No I18N
        } else {
            showerrormsg("Error While Creating Space"); // No I18N
        }
		return false;
	}
	/**  Soid Db Ends Console**/
	
	/**  Transmail Details**/
	function postForTransMail(f, url, fileds, sucessurl) {
		var params = csrfParam; //No I18N
		var i;
		for (i = 0; i < fileds.length; i++) {
			var n = fileds[i];
			var value = f.elements[n].value.trim();
			if(isEmpty(value)) {
				showerrormsg("Enter " + n); // No I18N
				f.elements[n].focus();
				return false;
			}
			params += "&" + n + "=" + euc(value);
		}
		var resp = getPlainResponse(contextpath + url, params).trim(); //No I18N
		if(resp=="SUCESS") {
			 showsuccessmsg("TransMail details added/Updated SucessFully"); // No I18N
			 loadui(sucessurl);
		} else if(resp=="INVALID_ADMINPASSWORD") { // No I18N
            showerrormsg("Invalid Admin Password"); // No I18N
        } else {
			 showerrormsg("Error While adding TransMail detail"); // No I18N
		}
	}
	
	function paramPostForTransMail(url, params, callbackmethod) {
		params+= "&" + csrfParam;
		showverificationform(url, params, callbackmethod); // No I18N
		return false;
	}
	
	function deleteTransMailType(resp) {
		resp = resp.trim();
		if(resp.trim()=="SUCESS") {
			 showsuccessmsg("TransMail Type deleted SucessFully"); // No I18N
			 hideverificationform();
			 loadui("/ui/admin/transMail.jsp?t=view&type=mt"); //No I18N
		} else if(resp=="INVALID_ADMINPASSWORD") { // No I18N
           showerrormsg("Invalid Admin Password"); // No I18N
       } else {
			 showerrormsg("Error While adding TransMail detail"); // No I18N
		}	
	}
	
	function deleteTransMailDetail(resp) {
		resp = resp.trim();
		if(resp.trim()=="SUCESS") {
			 showsuccessmsg("TransMail Type deleted SucessFully"); // No I18N
			 hideverificationform();
			 loadui("/ui/admin/transMail.jsp?t=view&type=md"); //No I18N
		} else if(resp=="INVALID_ADMINPASSWORD") { // No I18N
           showerrormsg("Invalid Admin Password"); // No I18N
       } else {
			 showerrormsg("Error While adding TransMail detail"); // No I18N
		}	
	}
	
	function updateSender(f) {
		de("senderemail").value= f.options[f.selectedIndex].getAttribute("send"); //No I18N
		
	}
	/**  Transmail Ends Details**/	
	function initAccMember() {
		$(".chosen-select11").select2({tags: true});
		$(".chosen-serType").select2();
	}
	
	function showDivByID(id) {
		de(id).style.display = 'block';
	}

	function hideDivByID(id) {
		de(id).style.display = 'none';
	}

	/** for security xml validation and add **/
	
	function verifyPrivateKey(f,ele) {
		var sId  = f.serviceid.value.trim();
		var privateKey  = f.privateKey.value.trim();
		var pwd = f.pwd.value.trim();
		var label="isc"; //No I18N
		if(ele[0].id == 'interdc')
		{
			label="Local"; //No I18N
		}
		var params = "sId=" + euc(sId) + "&privateKey=" + privateKey + "&pwd="+euc(pwd) + "&action=verify&label="+ label + "&" + csrfParam; //No I18N
		var   uri = contextpath + "/ui/admin/secPrivateKey.jsp"; //No I18N
		var res = getPlainResponse(uri, params);
		if(res.trim() == "Sucess") {
			showsuccessmsg("Verified Sucessfully"); // No I18N
			document.privateKey.reset();
			$("#serid").val("null").change();
			
		} else if(res.trim() == "Invalid Password") { //No I18N
			showerrormsg(res.trim());
			f.pwd.focus();
		} else {
			showerrormsg(res.trim());
			document.privateKey.reset();
			$("#serid").val("null").change();
		}
		return false;
	}
	
	function getPrivateInfo(f,ele) {
		var sId  = f.serviceid.value.trim();
		if(sId == "null") {
			de("privateKeyTest").style.display = 'none';
			de("addPrivateKey").style.display = 'none';
			return false;
		}
		var label="isc"; //No I18N
		if(ele[0].id == 'interdc')
		{
			label="Local"; //No I18N
		}

		var privateKey  = f.privateKey.value.trim();
		var params = "sId=" + euc(sId) + "&action=info&label="+ label+ "&" + csrfParam; //No I18N
		var   uri = contextpath + "/ui/admin/secPrivateKey.jsp"; //No I18N
		var res = getPlainResponse(uri, params);
		if(res.trim() == "SKEY_PRESENT") {
			if(label== "Local"){
				de("options").style.display ='block';
				de("privateKeyTest").style.display = 'none';
				de("addPrivateKey").style.display = 'none';
			}
			else{
				de("privateKeyTest").style.display = 'block';
				de("addPrivateKey").style.display = 'none';
				de("options").style.display ='none';
			}	
			
		} else if(res.trim() == "SKEY_ABSENT") {//No I18N
			de("addPrivateKey").style.display = 'block';
			de("privateKeyTest").style.display = 'none';
			de("options").style.display ='none'
		} else {
			showerrormsg(res.trim());
		}
	}
	
	function addPrivateKey(f,ele) {
		var sName  = f.serviceid.value.trim();
		var result;
		if(ele[0].id == 'interdc')
		{
			result=regenerate(sName, "add",true); //NO I18N
			document.privateKey.reset();
			$("#serid").val("null").change();
			return result;
		}
		result=regenerate(sName, "add",false); //NO I18N
		document.privateKey.reset();
		$("#serid").val("null").change();
		return result;
		
	}
	
	function showPrivateKeyfrm(ele, show) {
		document.privateKey.reset();
		$("#serid").val("null").change();
		de("options").style.display ='none';
	    if(ele.className == 'disablerslink') {
	        return false;
	    }
	    if(show) {
	    	
	        de('currentdc').className = 'disablerslink';
	        de('interdc').className = 'activerslink';  
	        
	    } else {
	    	
	        de('interdc').className = 'disablerslink';
	        de('currentdc').className = 'activerslink'; 
	        
	    }
	   
	    return false;
	}
	
	function showVerifyfrm(){
		de("options").style.display ='none';
		de("privateKeyTest").style.display = 'block';
	}
	function closeVerifyfrm(){
		if( de('interdc').className == 'disablerslink'){
			de("options").style.display ='block';
		}
		
		de("privateKeyTest").style.display = 'none';
		$("#serid").val("null").change();
	}
	
	function showInterDCSyncWindow(e,locations){
		de('myModal').style.display = 'block';
		de('synced-txt').style.display = 'none';
		de('select-txt').style.display = 'none';
		$('#modal-innertag').empty();
		$('#syncedDC').empty();
		var serviceName=e.value;
		var params ="serviceName="+serviceName+"&selectedDc="+locations+"&method=get&"+ csrfParam;;//No I18N
		var resp = getPlainResponse(contextpath + "/oauth/dc/sync/interdcsignature", params);//No I18N
		var json=JSON.parse(resp);
		var dclist="";
		var syncedDc=""; //No I18N
		for(var i=0; i< json.length; i++){
			if(json[i].result == null || json[i].result == "false"){	
				if(dclist !== ""){
						
					dclist +=",";
				}
				dclist +=json[i].location;
			}
			else{
				if(syncedDc !== ""){
					
					syncedDc +=",";
				}
				syncedDc +=json[i].location;
			}
		}
		if(syncedDc!=""){
			de('synced-txt').style.display = 'block';
			$('.syncedDC').append(syncedDc);
		}
		var ls=dclist.split(",");
		if(dclist!=""){
			de('select-txt').style.display = 'block';
			var divIds = '<div class="modaldivblock" style="display: flex;"><form name="sync" onsubmit="return syncToInterDC('+serviceName+', this)"><div>';
			for(var i=0; i< ls.length; i++){
				divIds += '<input type="checkbox" style="margin-right:10px" id='+ls[i]+' value='+ls[i]+'><label for='+ls[i]+'>'+ls[i]+'</label><br>';
			}
			divIds += '</div><div class="savebtn" onclick="syncToInterDC(\''+serviceName+'\', document.sync)"><span class="btnlt"></span><span class="btnco">Sync</span><span class="btnrt"></span></div>';
			divIds += '<div class="savebtn" onclick="closeModal()"><span class="btnlt"></span><span class="btnco">Close</span><span class="btnrt"></span></div>';
			divIds += "</form></div>";
			divIds += '<div id="jsonresponsediv">';
			divIds += '<div class="labelkey">Response:</div>'
			divIds += '<div class="labelvalue">';
			divIds += '<textarea id="jsonresponse" readonly style="font-size:10px;background-color:#BDBDBD" name="response" rows="7" cols="40"></textarea></div></div>';
		}
		else{
			
			divIds = '<div class="savebtn" onclick="closeModal()"><span class="btnlt"></span><span class="btnco">Close</span><span class="btnrt"></span></div>';
		}
		$('.modal-innertag').append(divIds);
	}
	
	function syncToInterDC(serviceName, e){
		$('#jsonresponse').val('').change();
		var elements = e.elements;
		var selected="";
		var params ="serviceName="+serviceName;//No I18N
		for(var i=0; i<elements.length ; i++){
			if(elements[i].checked){
				if(selected !== ""){
					selected +=",";
				}
				selected += elements[i].value;
			}
		} 
		params += "&selectedDc="+euc(selected)+"&method=post&"+ csrfParam;//NO I18N
		var resp = getPlainResponse(contextpath + "/oauth/dc/sync/interdcsignature", params);//No I18N
		var json=JSON.parse(resp);
		var successloc="";
		var failloc="";
		for(var i=0; i< json.length; i++){
			if(json[i].result!=null && json[i].result == "true"){	
				if(successloc !== ""){
					
					successloc +=",";
				}
				successloc+=json[i].location;
			}
			else{
				if(failloc !== ""){
					
					failloc +=",";
				}
				failloc +=json[i].location;
			}
			
		}
		var restxt="";
		if(successloc!=""){
			restxt +="Successfully synced in : "+successloc; //No I18N
		}
		if(failloc!=""){
			restxt +="\nSync failed in : "+failloc; //No I18N
		}
		$('#jsonresponse').val(restxt).change();
		
		return false;
	}
	/** Sec Private key ends***/

	function initSelect2() {
		$(".select2Div").select2();
	}

	
	/** Mobile App Details Admin Console*/	
	function showmobileform(ele, show) {
	    if(ele.className == 'disablerslink') {
	        return false;
	    }
	    if(show) {
	        de('dolink').className = 'disablerslink';
	        de('dufolink').className = 'activerslink';
	        
	        de('showMobileApps').style.display = '';
	        de('showAppCategory').style.display = 'none';

	        de('deletetitle').innerHTML = 'Mobile App Creation'; // No I18N
	    } else {
	        de('dufolink').className = 'disablerslink';
	        de('dolink').className = 'activerslink';

	        de('showMobileApps').style.display = 'none';
	        de('showAppCategory').style.display = '';

	        de('deletetitle').innerHTML = 'Mobile App Category Creation'; // No I18N
	    }
	    return false;
	}
	
	function showclientform(ele, show) {
	    if(ele.className == 'disablerslink') {  //NO I18N
	        return false;
	    }
	    if(show) {
	        de('dolink').className = 'disablerslink';
	        de('dufolink').className = 'activerslink';
	        de('hiddenDiv1').style.display = 'block';
	        de('hiddenDiv3').style.display = 'none';	        
	        de('clientidcreationform').reset();  //NO I18N
	        document.getElementById('clientidcreationform').style.display = 'block';   // No I18N
	        document.getElementById('deleteclient').style.display = 'none';
	    } else {
	        de('dufolink').className = 'disablerslink';  
	        de('dolink').className = 'activerslink';    
	        de('deleteclient').reset();  //NO I18N
	        document.getElementById('deleteclient').style.display = 'block';
	        document.getElementById('clientidcreationform').style.display = 'none';
	    }
	    return false;
	}
	
	function addMobileClient(f) {
	    var packageName = f.packageName.value.trim();
	    var mobileAppName = f.mobileAppName.value.trim();
	    var signature = f.signature.value.trim();
	    var gClientId = f.gClientId.value.trim();
	    var audienceId = f.audienceId.value.trim();
	    var device = f.device.value.trim();
	    var redirectUrl = f.redirectUrl.value.trim();
	    var projectId = f.projectId.value.trim();
	    if(isEmpty(packageName)) {
	        showerrormsg("Please enter valid package Name"); // No I18N
	        f.packageName.focus();
	        return false;
	    }
	    if(isEmpty(mobileAppName)) {
	        showerrormsg("Please enter valid Mobile App Name"); // No I18N
	        f.mobileAppName.focus();
	        return false;
	    }
	    if(isEmpty(signature) && device == "Android") {
	    	showerrormsg("Please enter a valid signature");//No I18N
	    	f.mobileAppName.focus();
	        return false;
	    }
	    if(isEmpty(projectId) && device == "Android") {
	    	showerrormsg("Please enter a valid project Id");//No I18N
	    	f.projectId.focus();
	    	return false;
	    }
	    if(isEmpty(redirectUrl)){
	    	showerrormsg("Please enter a valid redirect url");//NO I18N
	    	f.redirectUrl.focus();
	    	return false;
	    }
	    if(isEmpty(audienceId)) {
	        audienceId = -1;
	    }
	    if(isEmpty(gClientId)) {
	        gClientId = -1;
	    }
	    var params = "packageName=" + euc(packageName) + "&mobileAppName=" + euc(mobileAppName) + "&redirectUrl=" + euc(redirectUrl) + "&projectId=" + euc(projectId) + "&signature=" + euc(signature) + "&audienceId=" + euc(audienceId) + "&gClientId=" + euc(gClientId) + "&device=" + euc(device) + "&" + csrfParam; //No I18N
	    var resp = getPlainResponse(contextpath + "/admin/mobileapp/add", params); //No I18N
	    var results=resp.split('_');
	    resp=results[0].trim();
	    if(resp == "success") {
			showsuccessmsg("Operation is success. See the result in response"); // No I18N
			$('#clientId').val(results[1]+","+results[2]);
			clearSelectedAppServers("Do you want to clear cache in all app servers",false,results[3]);// No I18N
		}else{
			showerrormsg(resp); 
		}
	    return false;
	}
	
	function addAudienceId(f){ 
		var emailId = f.emailId.value.trim();
		var audienceId = f.audienceId.value.trim();
		if(isEmpty(emailId)) {
			showerrormsg("Please enter a valid email Id");//NO I18N
			f.emailId.focus();
			return false;
		}
		if(isEmpty(audienceId)){
			showerrormsg("Please enter a valid audience Id");//No i18n
			f.audienceId.focus();
			return false;
		}
		var params = "emailId=" + euc(emailId) + "&audienceId=" + euc(audienceId) + "&" + csrfParam; //No I18N
		var resp = getPlainResponse(contextpath + "/admin/mobileaudience/add", params); //No I18N
		var results=resp.split('_');
	    resp=results[0].trim();
	    if(resp == "success") {
			showsuccessmsg("Audience Id Created"); // No I18N
			clearSelectedAppServers("Do you want to clear cache in all app servers",false,results[1]);// No I18N
	    } else {
	        showerrormsg(resp);
	    }
	    return false;
	}
	
	function verifyDomain(){
		var domain =  document.getElementById('domain').value;
		var reason =  document.getElementById('reason').value;
		var validations =  document.getElementById('validations').value;
		var isverified = document.getElementById('isverified').checked;
		if(isEmpty(domain)) {
	        showerrormsg("Please Enter the domain name"); // No I18N
	        f.domain.focus();
	        return false;
	    }
		if(isEmpty(reason)) {
	        showerrormsg("Please Enter the reason to confirm"); // No I18N
	        f.reason.focus();
	        return false;
	    }
		if(isEmpty(validations)) {
	        showerrormsg("Please Enter the validations done"); // No I18N
	        f.validations.focus();
	        return false;
	    }
		var params = "domain="+euc(domain)+"&isverified="+euc(isverified)+"&reason="+euc(reason)+"&validations="+euc(validations)+"&"+ csrfParam;//No I18N
		var resp = getPlainResponse(contextpath +"/admin/domain/verify",params); // No I18N
		if(resp == "SUCCESS"){
			showsuccessmsg("Successfully updated");// No I18N
			de('reason').value="";
			de('validations').value="";
		}else { 
			showerrormsg(resp);
			de('reason').value="";
			de('validations').value="";
		}
		var obj = JSON.parse(resp);
		var ar = obj.cause;
		if(!isEmpty(ar)){
			ar = ar.trim();
		    if(ar === "invalid_password_token") {   //No I18N
			showerrormsg(err_refresh_page);
		    }
		}
		
	}
	function alterapp(f){
		var appName = f.appName.value.trim();
		var signature = f.signature.value.trim();
		var projectId = f.projectId.value.trim();
		var packageName = f.packageName.value.trim();
		var appClientId = f.gClientId.value.trim();
		var oauthClientId = f.oauthClientId.value.trim();
		var audId = f.audId.value.trim();
		var redirecturl = f.redirectUrl.value.trim();
		
		if(isEmpty(appName) || isEmpty(signature) || isEmpty(projectId) || isEmpty(packageName) || isEmpty(appClientId) || isEmpty(oauthClientId) || isEmpty(redirecturl)){
			showerrormsg("Details cannot be empty"); //NO I18N
			return false;
		}
		
		var params = "appName="+euc(appName)+"&signature="+euc(signature)+"&projectId="+euc(projectId)+"&packageName="+euc(packageName)+"&audId="+audId +"&redirecturl="+redirecturl + "&gClientId=" + appClientId+"&" + csrfParam;//No I18N
		var resp = getPlainResponse(contextpath + "/admin/mobileapp/edit", params);//No I18N
		var results=resp.split('_');
	    resp=results[0].trim();
	    if(resp == "success") {
			showsuccessmsg(appName + " successfully updated"); // No I18N
			clearSelectedAppServers("Do you want to clear cache in all app servers",false,results[1]);// No I18N
			loadui('/ui/admin/mobileregistration.jsp?t=view'); //No I18N
	    } else {
	        showerrormsg(resp);
	    }
	    return false;
	}

/** Mobile AppDetails Admin Console ends */

	function showId(ele){
		var val=ele.value;
		if(val == 1004)
			{
			$("#hiddenDiv3").css("display","block");
			$("#hiddenDiv1").css("display","none");
			}
		else
			{
			$("#hiddenDiv1").css("display","block");
			$("#hiddenDiv3").css("display","none");
			}
	}
	
	function showoauthsublist(ele){
		var value = ele.value;
		if(value == "1")
			{
			$("#hiddenDiv1").css("display","none");
			$("#hiddenDiv2").css("display","none");
			$("#hiddenDiv4").css("display","none");
			$("#hiddenDiv3").css("display","block");
			$("#hiddenDiv5").css("display","none");
			$("#hiddenDiv6").css("display","none");
			}
		else if(value == "2")
			{
			$("#hiddenDiv1").css("display","block");
			$("#hiddenDiv2").css("display","block");
			$("#hiddenDiv3").css("display","none");
			$("#hiddenDiv4").css("display","none");
			$("#hiddenDiv5").css("display","none");
			$("#hiddenDiv6").css("display","none");
			}
		else if(value == "3")
			{
			$("#hiddenDiv1").css("display","none");
			$("#hiddenDiv2").css("display","none");
			$("#hiddenDiv3").css("display","none");
			$("#hiddenDiv4").css("display","block");
			$("#hiddenDiv5").css("display","block");
			$("#hiddenDiv6").css("display","none");
			}
		 else if(value == "4")
		    {
		    $("#hiddenDiv1").css("display","none");
		    $("#hiddenDiv2").css("display","none");
		    $("#hiddenDiv3").css("display","none");
		    $("#hiddenDiv4").css("display","none");
		    $("#hiddenDiv5").css("display","none");
			$("#hiddenDiv6").css("display","block");
		    }
	}
	
	function enterclientpropertykey(ele){
		if(ele.checked){
		$("#subconfiginput").css("display","block");
		$("#subconfiglist").css("display","none");
		} else {
		$("#subconfiginput").css("display","none");
		$("#subconfiglist").css("display","block");
		}
	}
	
	function changeOperationType(e){
		if(e.value.trim() == 'GENERAL') {
			de('custom_select').style.display = 'none';
		    de('general_select').style.display = '';
		} else  if(e.value.trim() == 'CUSTOM') { //NO I18N
			de('general_select').style.display = 'none';
		    de('custom_select').style.display = '';
		} else {
		   	de('general_select').style.display = '';
		    de('custom_select').style.display = '';
		}
	}
	
	function showzaid(e) {
	    if(e.checked) {
	        de('show_zaid').style.display = '';
	        de('hide_zaid').style.display = 'none';
	    } else {
	    	de('show_zaid').style.display = 'none';
	        de('hide_zaid').style.display = '';
	    }
	}
	
	function addRestrictedScope(f){
		var userEmail = f.userEmail.value.trim(); 
		var scope = f.scope.value.trim();
		var isApiKey = f.isApiKey.checked;
		if(isEmpty(userEmail) || isEmpty(scope)){
			showerrormsg("Details cannot be empty"); //NO I18N
			return false;
		}
		var params = "&userEmail="+euc(userEmail)+"&scope="+euc(scope)+"&isApiKey="+euc(isApiKey)+"&"+csrfParam;//No I18N
		var resp = getPlainResponse(contextpath + "/admin/restrictedScope/add", params);//No I18N
		var results=resp.split('_'); 
	    resp=results[0].trim();
	    if(resp == "success") {
			showsuccessmsg("Restricted scopes successfully updated"); // No I18N
			loadui('/ui/admin/restrictedScope.jsp'); //No I18N
	    } else {
	        showerrormsg(resp);
	    }
	    return false;
	}
	function showrestrictedfrm(ele, show) {
	    if(ele.className == 'disablerslink') { 
	        return false;
	    }
	    if(show) { 
	    	de('dellink').className = 'activerslink';
	        de('addlink').className = 'disablerslink';
	        
	        de('addScope').style.display = '';
	        de('delScope').style.display = 'none';
	        document.addScope.reset();

	        de('restoretitle').innerHTML = 'Add Restricted Scopes'; // No I18N
	    } else {
	    	de('addlink').className = 'activerslink';
	        de('dellink').className = 'disablerslink';

	        de('delScope').style.display = '';
	        de('addScope').style.display = 'none';
	        document.delScope.reset();

	        de('restoretitle').innerHTML = 'Delete Restricted Scopes'; // No I18N
	    }
	    return false;
	}
	function deleteRestrictedScope(f){
		var userEmail = f.userEmail.value.trim();
		var scope = f.scope.value.trim();
		var isApiKey = f.isApiKey.checked;
		if(isEmpty(userEmail) || isEmpty(scope)){
			showerrormsg("Details cannot be empty"); //NO I18N
			return false;
		}
		var params = "&userEmail="+euc(userEmail)+"&scope="+euc(scope)+"&isApiKey="+euc(isApiKey)+"&"+csrfParam;//No I18N
		var resp = getPlainResponse(contextpath + "/admin/restrictedScope/delete", params);//No I18N
		var results=resp.split('_'); 
	    resp=results[0].trim();
	    if(resp == "success") {
			showsuccessmsg("Restricted scopes deleted for user"); // No I18N
			loadui('/ui/admin/restrictedScope.jsp'); //No I18N
	    } else {
	        showerrormsg(resp);
	    }
	    return false;
	}
	
	function downloadTestAccounts() {
	    action = contextpath+'/ui/admin/testaccounts.jsp?operation=download'; //No I18N
	    window.open
	    (
	    	action,
	    	'_self' //NO I18N
	    );
	}
	function closeTestAccounts(f) {
		var fromTime = new Date(f.fromTime.value).getTime();
	    var toTime = new Date(f.toTime.value).getTime();
	    var params = "operation=close&fromTime="+euc(fromTime)+"&toTime="+euc(toTime) +"&"+ csrfParam; // No I18N
		var resp = getPlainResponse(contextpath +"/ui/admin/testaccounts.jsp",params);	//No I18N
		de('closeResp').innerHTML = resp; //No I18N
	}
	
	function addElement(e,count,max){
		var parent = e.parentNode.parentNode;
		if(max==null){
			max=10;
		}
		if(parent.childElementCount>=max){
			showerrormsg("Max Count Reached"); //No I18N
			return false;
		}
		var child = document.createElement('div');
		var inner = e.parentNode.innerHTML;
		if(e.parentNode.childElementCount==count){
			inner += "<span class='removeEDicon hideicon chaceicon' onclick='removeElement(this)'></span>";
		}
		child.innerHTML = inner;
		child.className = 'edipdiv';
		child.setAttribute("name",e.parentNode.getAttribute("name"));
		parent.appendChild(child);
		return false;	
	}

	function removeElement(e){
		var el = e.parentNode.parentNode;
		el.removeChild(e.parentNode);
		return false;
	}

	function removeAllChildren(el){
		var len = el.childElementCount;
		for(var i=1;i<len;i++){
			el.removeChild(el.children[el.childElementCount-1]);
		}
		return false;
	}	
	//@@@@Mobile App Creation
	function setAppName( selectedElement, json){
		var serviceName = selectedElement.value;
		$('#appName').empty();
		var x = '';
		for(var i =0; i< json[serviceName].length; i++){
			x += '<option value='+json[serviceName][i]+'>'+json[serviceName][i]+'</option>';//No I18N
		}
		$('#appName').append(x);
	}
	
	function configureNewMobileApp(f){
		var serviceName = f.serviceName.value.trim();
		var appName = f.appName.value.trim();
		var packageName = f.packageName.value.trim();
		var clientType = f.clientType.value.trim();
		var mobileappType = f.mobileappType.value.trim();
		var signature = f.signature.value.trim();
		var urlScheme = f.urlScheme.value.trim();
		var appClientId = f.appClientId.value.trim();
		var projectId = f.projectId.value.trim();
		var audienceId = f.audienceId.value.trim();
		if(isEmpty(serviceName) || serviceName === null){
			showerrormsg("Choose a valid Service");//No I18N
			return false;
		}
		if(isEmpty(appName) || appName === null){
			showerrormsg("Enter a valid mobile app Name");//No I18N
			return false;
		}
		if(isEmpty(packageName)){
			showerrormsg("Enter a valid packageName/Bundle Identifier");//No I18N
			return false;
		}
		if(isEmpty(urlScheme)){
			showerrormsg("Enter a valid Url Scheme");//No I18N
			return false;
		}
		var params = "&serviceName="+euc(serviceName)+"&appName="+euc(appName)+"&packageName="+euc(packageName)+"&clientType="+euc(clientType)+"&mobileappType="+euc(mobileappType)+"&signature="+euc(signature)+ //No I18N
					 "&urlScheme="+euc(urlScheme)+"&appClientId="+euc(appClientId)+"&projectId="+euc(projectId)+"&audienceId="+euc(audienceId)+"&"+csrfParam;//No I18N
		var resp = getPlainResponse(contextpath + "/admin/mobileapp/create", params);//No I18N
		var results=resp.split('_');
	    resp=results[0].trim();
	    if(resp == "success") {
			showsuccessmsg("Operation is success. See the result in response"); // No I18N
			$('#clientId').val(results[1]);
			clearSelectedAppServers("Do you want to clear cache in all app servers",false,results[2]);// No I18N
		}else{
			showerrormsg(resp); 
		}
	    return false;
	}
	
	function changeMobileDetails(e) {
	    if(e.value.trim() == '1') { //NO I18N
	        de('android_select').style.display = '';
	    } else {
	        de('android_select').style.display = 'none';
	    }
	}
	
	function updateMobileApp(f){
		var serviceName = f.serviceName.value.trim();
		var appName = f.appName.value.trim();
		var packageName = f.packageName.value.trim();
		var clientType = f.clientType.value.trim();
		var mobileappType = f.mobileappType.value.trim();
		var signature = f.signature.value.trim();
		var urlScheme = f.urlScheme.value.trim();
		var appClientId = f.appClientId.value.trim();
		var projectId = f.projectId.value.trim();
		var audienceId = f.audienceId.value.trim();
		var clientId = f.client_id.value.trim();
		if(isEmpty(packageName)){
			showerrormsg("Enter a valid packageName/Bundle Identifier");//No I18N
			return false;
		}
		if(isEmpty(urlScheme)){
			showerrormsg("Enter a valid Url Scheme");//No I18N
			return false;
		}
		var params = "&serviceName="+euc(serviceName)+"&appName="+euc(appName)+"&packageName="+euc(packageName)+"&clientType="+euc(clientType)+"&mobileappType="+euc(mobileappType)+"&signature="+euc(signature)+ //No I18N
					 "&urlScheme="+euc(urlScheme)+"&appClientId="+euc(appClientId)+"&projectId="+euc(projectId)+"&audienceId="+euc(audienceId)+"&clientId="+euc(clientId)+"&"+csrfParam;//No I18N
		var resp = getPlainResponse(contextpath + "/admin/mobileapp/edit", params);//No I18N
		var results=resp.split('_');
	    resp=results[0].trim();
	    if(resp == "success") {
			showsuccessmsg("Operation is success"); // No I18N
			loadui('/ui/admin/mobileregistration.jsp?t=view'); initSelect2();//No I18N
			clearSelectedAppServers("Do you want to clear cache in all app servers",false,results[1]);// No I18N
		}else{
			showerrormsg(resp); 
		}
	    return false;
	}
	
	function addNewMobileCategory(f){
		var serviceName = f.serviceName.value.trim();
		var mobileAppName = f.mobileAppName.value.trim();
		var displayName = f.displayName.value.trim();
		var description = f.description.value.trim();
		var appLogo = f.appLogo.value.trim();
		var mobileappType = f.mobileappType.value.trim();
		
		if(isEmpty(mobileAppName)){
			showerrormsg("Enter a valid Mobile App Name");//No I18N
			return false;
		}
		if(isEmpty(displayName)){
			showerrormsg("Enter a display Name to be shown in Zoho One App");//No I18N
			return false;
		}
		var params = "&serviceName="+euc(serviceName)+"&mobileAppName="+euc(mobileAppName)+"&displayName="+euc(displayName)+"&description="+euc(description)+"&appLogo="+euc(appLogo)+"&mobileappType="+euc(mobileappType) + "&"+csrfParam;//No I18N
		var resp = getPlainResponse(contextpath + "/admin/mobileappCatagory/create", params);//No I18N
		var results=resp.split('_');
		resp=results[0].trim();
		if(resp == "success") {
			showsuccessmsg("Operation is success."); // No I18N
			loadui('/ui/admin/mobileregistration.jsp?t=view'); //NO I18N
			initSelect2();
			clearSelectedAppServers("Do you want to clear cache in all app servers",false,results[1]);// No I18N
		}else{
			showerrormsg(resp); 
		}
		return false;
	}
	
	function editMobileAppCategory(f){
		var serviceName = f.serviceName.value.trim();
		var mobileAppName = f.mobileAppName.value.trim();
		var displayName = f.displayName.value.trim();
		var description = f.description.value.trim();
		var appLogo = f.appLogo.value.trim();
		var mobileappType = f.mobileappType.value.trim();
		
		if(isEmpty(mobileAppName)){
			showerrormsg("Enter a valid Mobile App Name");//No I18N
			return false;
		}
		if(isEmpty(displayName)){
			showerrormsg("Enter a display Name to be shown in Zoho One App");//No I18N
			return false;
		}
		var params = "&serviceName="+euc(serviceName)+"&mobileAppName="+euc(mobileAppName)+"&displayName="+euc(displayName)+"&description="+euc(description)+"&appLogo="+euc(appLogo)+"&mobileappType="+euc(mobileappType) + "&"+csrfParam;//No I18N
		var resp = getPlainResponse(contextpath + "/admin/mobileappCatagory/edit", params);//No I18N
		var results=resp.split('_');
		resp=results[0].trim();
		if(resp == "success") {
			showsuccessmsg("Operation is success. See the result in response"); // No I18N
			loadui('/ui/admin/mobileregistration.jsp?t=view'); initSelect2();//No I18N
			clearSelectedAppServers("Do you want to clear cache in all app servers",false,results[1]);// No I18N
		}else{
			showerrormsg(resp); 
		}
		return false;
	}
	
	function showSyncWindow(type, serviceName, appName, locations){
		de('myModal').style.display = 'block';
		$('#modal-innertag').empty();
		var ls = locations.split(",");
		var divIds = '<div class="modaldivblock" style="display: flex;"><form name="sync"  onsubmit="return syncToDC('+serviceName+','+appName+', this)"><div>';
		for(var i=0; i< ls.length; i++){
			divIds += '<input type="checkbox" style="margin-right:10px" id='+ls[i]+' value='+ls[i]+'><label for='+ls[i]+'>'+ls[i]+'</label>';
		}
		divIds += '</div><div class="savebtn" onclick="syncToDC(\''+serviceName+'\',\''+appName+'\',\''+type+'\', document.sync)"><span class="btnlt"></span><span class="btnco">Add</span><span class="btnrt"></span></div>';
		divIds += '<div class="savebtn" onclick="closeModal()"><span class="btnlt"></span><span class="btnco">Close</span><span class="btnrt"></span></div>';
		divIds += "</form></div>";
		divIds += '<div id="jsonresponsediv">';
		divIds += '<div class="labelkey">Response:</div>'
		divIds += '<div class="labelvalue">';
		divIds += '<textarea id="jsonresponse" readonly style="font-size:10px;background-color:#BDBDBD" name="response" rows="7" cols="40"></textarea></div></div>';
		$('.modal-innertag').append(divIds);
	}
	
	function syncToDC(serviceName, appName, type, e){
		var elements = e.elements;
		var selected="";
		var params = "type="+euc(type)+"&serviceName="+euc(serviceName)+"&mobileAppName="+euc(appName);//No I18N
		for(var i=0; i<elements.length ; i++){
			if(elements[i].checked){
				if(selected !== ""){
					selected +=",";
				}
				selected += elements[i].value;
			}
		} 
		params += "&selectedDc="+euc(selected)+"&"+csrfParam;//NO I18N
		var resp = getPlainResponse(contextpath + "/oauth/dc/sync/mobileappcategory", params);//No I18N
		de('jsonresponse').append(resp);//No I18N
		return false;
	}
	
	function closeModal(){
		de('myModal').style.display='';
		return;
	}
	
	
function changeStreamStatus() {
 	var stat = de('streamenabled').checked; //No I18N
	if(confirm("Are you sure to change stream status? Changing status will clear cache and send notification.")){ //No I18N
		var params = "enable="+euc(stat)+"&"+csrfParam; //No I18N
		showverificationform("/admin/redisstreams/changeStatus", params, changeStreamStatusResponse); //No I18N
	} else {
		de('streamenabled').checked = !stat; //No I18N
	}
}

function changeStreamStatusResponse(resp) {
	var results=resp.split('_');
	resp=results[0].trim();
	if(resp=="SUCCESS"){ //No I18N
		hideverificationform();
		showsuccessmsg("Stream status updated"); //No I18N
		clearSelectedAppServers('Do you want to Clear cache in selected app servers?',false,results[1]); //No I18N
		return false;
	}
	showerrormsg(resp);
	if(resp!="INVALID_ADMINPASSWORD"){ //No I18N
		hideverificationform();
	}
	return false;
} 
	
function openPopUp(type) {
	var url = "/ui/admin/streamsetting.jsp?type="+euc(type); //No I18N
	de('streamactionshow').style.display='';
	de('streamaction').innerHTML=  "<center>"+type.toUpperCase()+"</center>"; // No I18N
	var resp = getOnlyGetPlainResponse(contextpath+url,"");
	de('streamout').innerHTML = resp; //No I18N
	initSelect2();
	return false;
}

function showStream(service) {
 	var el = de(service);
 	if(el) {
 		el.scrollIntoView(true);
 	}
}

function updateEnabledStreams(f,type) {
	var params = "type="+euc(type)+"&"+csrfParam; //No I18N
	var selectedcount = 0;
	for(var i=0; i < f.services.options.length; i++) {
		var option = f.services.options[i];
		if(option.selected) {
			selectedcount++;
			if(selectedcount > 20) {
				showerrormsg("Cannot "+type+" more than 20 services"); //No I18N
				return;
			}
			params += "&servicenames="+euc(option.value); //No I18N
		}
	}
	if(confirm("Are you sure to "+type+" streams?")){ //No I18N
		params += "&syncRO="+f.syncro.checked; //No I18N
		showverificationform("/admin/redisstreams/updateEnabledServices", params, changeStreamStatusResponse); //No I18N
		return false;
	}
}

function editStream(sname) {
	de(sname+"_count").disabled = false; //No I18N
	de(sname+"_count").classList.remove("noborder"); //No I18N

	de(sname+"_waittime").disabled = false; //No I18N
	de(sname+"_waittime").classList.remove("noborder"); //No I18N
	
	de(sname+"_size").disabled = false; //No I18N
	de(sname+"_size").classList.remove("noborder"); //No I18N
	
	de(sname+"_buttontxt").innerText = "Save"; //No I18N
	de(sname+"_button").onclick = function () { //No I18N
		var count = de(sname+"_count").value.trim(); //No I18N
		var waittime = de(sname+"_waittime").value.trim(); //No I18N
		var size = de(sname+"_size").value.trim(); //No I18N
		var params = "sname="+euc(sname)+"&count="+euc(count)+"&waittime="+euc(waittime)+"&size="+euc(size)+"&"+csrfParam; //No I18N
		if(confirm("Update the Stream data for "+sname + "?")) {
			showverificationform("/admin/redisstreams/updateStream", params, changeStreamStatusResponse); //No I18N
			return false;
		}
	}
	de(sname+"_cancelbutton").style.display='';
}

function cancelEdit(sname) {
	de(sname+"_count").disabled = true; //No I18N
	de(sname+"_count").classList.add("noborder"); //No I18N

	de(sname+"_waittime").disabled = true; //No I18N
	de(sname+"_waittime").classList.add("noborder"); //No I18N
	
	de(sname+"_size").disabled = true; //No I18N
	de(sname+"_size").classList.add("noborder"); //No I18N
	
	de(sname+"_buttontxt").innerText = "Edit"; //No I18N
	de(sname+"_button").onclick = function () { //No I18N
		editStream(sname);
	}
	de(sname+"_cancelbutton").style.display='none';
}