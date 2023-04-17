//$Id$
function WmsliteImpl(){}

WmsliteImpl.serverdown=function(){}
WmsliteImpl.serverup=function(){}
WmsliteImpl.handleLogout=function(reason){
	$(window).unbind('beforeunload');
    sendRequestWithCallback(contextpath+"/u/clearusercache", "nocache="+((new Date()).getTime()), true, function() {window.location.reload();}); //No I18N
}
WmsliteImpl.handleMessage=function(mtype,msgObj){
    if(mtype && mtype === '37') {//Language changed
        sendRequestWithCallback(contextpath+"/u/clearusercache", "nocache="+((new Date()).getTime()), true, function() {}); //No I18N
    }
    else if(mtype && mtype == '2'){
    	if(msgObj=="checkStatus"){ //No I18N
    		isVerifiedFromDevice();
    	}else if(msgObj=="checkisDisableApproved"){ //No I18N
    		isDisableApproved();
    	}
    }
}               
WmsliteImpl.handleAccountDisabled=function(reason){}
WmsliteImpl.handleServiceMessage=function(msg){}
