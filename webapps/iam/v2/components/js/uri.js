// $Id: $
/**
 * To send Multipart params you need to send form id as controller's property named '__form'. Add a variable named `multipartAttrs` in the model and add the multipart parameter names in it.(Ex:multipartAttrs : [ "public_key" ]. Validate multipart attr's in your model's `validate`/`validate partial` method.
 */

/*-
 * # URI Instance We can create an instance of URI object in following ways. 
 * ``` 
 * new URI(<full uri>, OZ.Users); // `/user`. Full URI and respective ZResource type
 * 
 * new URI(OZ.Users); // `/user`. ZResource type, URI will be computed from ResourceMetaData
 * 
 * new URI(OZ.Users, '107'); // `/users/107`. ZResource type and identifier to construct instance URI
 * 
 * new URI(OZ.Emails, '107', 'mani@mg.com'); // `/users/107/emails/mani@mg.com`. ZResource type and parent / self identifier. To construct URI for sub resource.
 * 
 * ``` 
 * # Parameters 
 * 
 * ```
 * userURI.param('type', 'active'); // Set Parameter
 * 
 * userURI.param('type'); // Get the value of a Parameter
 * 
 * userURI.param({type: 'active', 'status': 'all'}); // Object. To set list of parameters 
 * 
 * ``` 
 * # CRUD 
 * ## GETS userURI.GETS(); // Array of User 
 * ## GET userURI.GET(); // User object ## POST userURI.POST(user); // User object ## PUT userURI.PUT(user); // User object ## DELETE userURI.DELETE(user); // User object or Array of User object to delete multiple resources.
 * 
 */

var _rsvbObj = {};
function URI(/* uri, type */) {
	// TODO: Fix this. Don't hard code the value.
	//this.contextpath = ZContacts.getContextPath() + '/api/v1'; // No I18N
	this.restContext = 'accounts'; // No I18N
	this.contextpath = URI.options.contextpath; 
	this.apiResponse = null;
	this.resourceIdentifier = null;
	this.authUser = null;
	this.authPassword = null;

	var args = arguments;
	// Array of arguments will be passed from ZResource.getURI method.
	if ($.isArray(arguments[0])) {
		args = arguments[0];
	}
	this.init.apply(this, args);
}


URI.options = {
		contextpath: '',
		csrfParam: null,
		csrfValue: null
	};

// ********************
// $PUBLIC_FUNCTIONS
// ********************
$.extend(URI.prototype, {
	/*-
	 * We can create instance for an URI object in following ways :
	 * ```
	 * new URI(<full uri>, OZ.Users); // /users
	 * new URI(OZ.Users); // /users
	 * new URI(OZ.Users, '107'); // /user/107
	 * new URI(OZ.Emails, '107', 'mani@mg.com'); // /users/107/useremail/mani@mg.com
	 * ```
	 */
	init : function(type/* , ... parentIdentifiers, identifier */) {
		// Request URI
		var identifier, isFullURI = (typeof type === 'string'); // No I18N

		this.type = isFullURI ? arguments[1] : type;
		if (!this.type || !this.type.superclass.__zresource) {
			throw new Error('' + this.type + ' is not a type of "ZResource"'); // No I18N
		}

		if (isFullURI) { // new URI(<full uri>, OZ.User);
			var path = URI.trimSlash(type);
			this.requestURI = this.contextpath + '/' + path;

			var uriArr = path.split('/');
			if (uriArr.length % 2 === 0) { // Instance URI
				identifier = uriArr[uriArr.length - 1];
			}
		} else {
			var rmd = this.getRMD();
			var uriSB = new StringBuilder();
			if (rmd.parents) {
				var parentIdIdx = 1;
				for (var i = 0; i < rmd.parents.length; i++) {
					var parent = rmd.parents[i], parentRMD = this.getRMD(parent);
					var parentPath = parentRMD.path;
					if (!parentPath) {
						parentPath = parentRMD.resourceName.toLowerCase();
					}
					var parentIdentifier = arguments[parentIdIdx++];
					uriSB.append('/').append(parentPath);
					if (parentIdentifier) {
						uriSB.append('/').append(parentIdentifier);
					} else if (parentRMD.identifier) {
						throw new Error('Unable to construct URI. Parent Identifier for the resource ' + parentRMD.resourceName + ' is missing for ' + rmd.resourceName + ''); // No I18N
					}
				}
				identifier = arguments[parentIdIdx];
			} else {
				identifier = arguments[1];
			}
			if (rmd.path) {
				uriSB.append('/').append(rmd.path);
			} else {
				uriSB.append('/').append(rmd.resourceName.toLowerCase());
			}
			if (identifier) {
				uriSB.append('/').append(identifier);
			}
			this.requestURI = this.contextpath + uriSB.toString();
		}
		this.isInstance = (!!identifier);
		if (identifier && $.isArray(identifier) && identifier.length > 1) {
			this.isInstance = false;
		}
		this.resourceIdentifier = identifier;
		return this;
	},

	include : function(value) {
		this.includes = this.includes || [];
		this.includes.push(value);
		return this;
	},

	header : function(name, value) {
		this.headers = this.headers || {};

		if ($.isPlainObject(name)) { // Add all params
			for ( var key in name) {
				this.headers[key] = name[key];
			}
		} else if (name) {
			if (value === null) {
				return this.headers[name];
			}
			this.headers[name] = value;
		}
		return this;
	},

	setSortBy : function(sortBy, asc) {
		asc = asc ? "" : "-"; // No I18N
		this.sort = asc + sortBy;
		return this;
	},
	
	addFilter : function(name, value) {
		this.filters = this.filters || {};
		this.filters[name] = value;
		return this;
	},

	addSearchQuery : function(query) {
		this.query = query;
		return this;
	},

	addSearchComparator : function(comparator) {
		this.search_comparator = comparator;
		return this;
	},

	addSearchFields : function(value) {
		this.searchFields = this.searchFields || [];
		this.searchFields = this.concat(value.split(','));
		return this;
	},

	addFields : function(value) {
		this.fields = this.fields || [];
		this.fields = this.fields.concat(value.split(','));
		return this;
	},

	setPagination : function(page, perPage) {
		this.pagination = this.pagination || {};
		this.pagination.page = page;
		this.pagination.per_page = perPage;
		return this;
	},
	
	addQueryParam : function(key, value) {
		this.queryParams = this.queryParams || {};
		this.queryParams[Constants.Params.QUERYSTRING_PREFIX + key] = value;
		return this;
	},
	
	addParam : function(key, value) {
		if (!value) {
			return this;
		}
		this.parameters = this.parameters || {};
		this.parameters[key] = value;
		return this;
	},
	
	setParams : function(json) {
		for(var key in json) {
		    if(json.hasOwnProperty(key)) {
		        this.addParam(key, json[key]);
		    }
		}
		return this;
	},
	
	setRange : function(start, limit) {
		this.range = this.range || {};
		this.range.start = start;
		this.range.limit = limit;
		return this;
	},

	addDeleteParam : function(key, value) {
		this.deleteParams = this.deleteParams || {};
		this.deleteParams[ZContacts.Constants.Params.DELETEALL_PREFIX + key] = value;
		return this;
	},
	
	addPostParam : function(key, value) {
		this.postParams = this.postParams || {};
		this.postParams[key] = value;
		return this;
	},

	getParams : function() {
		return $.param(this.getParamsObj());
	},

	getParamsObj : function() {
		var params = {};
		if (this.includes) {
			params.include = this.includes.join();
		}
		if (this.filters) {
			for ( var key in this.filters) {
				params[ZContacts.Constants.Params.FILTER_PREFIX + key] = this.filters[key];
			}
		}
		if (this.query) {
			params.q = this.query;
			if (this.search_comparator) {
				params.search_comparator = this.search_comparator;
			}
			if (this.searchFields) {
				params.search_fields = this.searchFields.join();
			}
		}
		if (this.sort) {
			params.sort = this.sort;
		}
		
		if (this.parameters) {
			for ( var keyParam in this.parameters) {
				params[keyParam] = this.parameters[keyParam];
			}
		}
		
		if (this.fields) {
			params.fields = this.fields.join();
		}
		if (this.pagination) {
			params.page = this.pagination.page;
			params.per_page = this.pagination.per_page;
		}
		if (this.range) {
			params.start = this.range.start;
			params.limit = this.range.limit;
		}
		return params;
	},

	/*
	 * @param type - instance of ZResource/ Referring ZResource
	 * 
	 * `type` required only when we need MetaData object for parent of current resource(`this.type`). By default will use this.type to call static/instance method of it.
	 * 
	 * This method will trigger responsive method(static/instance) of ZResource based on type
	 */
	getRMD : function(type) {
		if (!type) {
			type = this.type;
		}
		if (type.getResourceMetaData) {
			return type.getResourceMetaData(type);
		}
		return type.getRMD();
	},

	setAuthHeader : function(zuid, password) {
		zuid = zuid+"";
		if (zuid.indexOf(':') !== -1) {
			throw new Error('Invalid character present in ZUID ' + zuid + ''); // No I18N
		}
		this.authUser = zuid || ''; // No I18N
		this.authPassword = password; 
		return this;
	}
});

// ********************
// $CRUD
// ********************
$.extend(URI.prototype, {
	GETS : function() {

		if (this.isInstance) {
			throw new Error('GETS operation is not supported in Multi URI for ' + this.type + ''); // No I18N
		}

		return this._sendRequest('GETS'); // No I18N
	},

	GET : function() {

		var rmd = this.getRMD();

		if (rmd.identifier && !this.isInstance) {
			throw new Error('GET operation is not supported in Multi URI for ' + this.type + ''); // No I18N
		}

		return this._sendRequest('GET'); // No I18N
	},

	POST : function(resource) {
		if (resource.length) {
			return this._saveAll(resource, 'POST'); // No I18N
		}
		return this._save(resource, 'POST'); // No I18N
	},

	PUT : function(resource) {
		if (resource && resource.length) {
			return this._saveAll(resource, 'PUT'); // No I18N
		}
		return this._save(resource, 'PUT'); // No I18N
	},
	
	PATCH : function(resource) {
		if (resource && resource.length) {
			return this._saveAll(resource, 'PATCH'); // No I18N
		}
		return this._save(resource, 'PATCH'); // No I18N
	},

	DELETE : function(resource) {
		//if (!$.isEmptyObject()) {
			if ($.isArray(resource)) {
				return this.DELETEALL(resource);
			}
			if (resource && !(resource instanceof this.type)) {
				throw new Error('' + resource + ' is not an instance of ' + this.type + ''); // No I18N
			}
		//}
		return this._sendRequest('DELETE'); // No I18N
	},

	DELETEALL : function(resources) {
		if (!resources.length && !$.isArray(resources)) {
			throw new Error('Invalid argument passed ' + resources + '. Expecting Array of "ZResource"'); // No I18N
		}

		var rmd = this.getRMD();
		if (rmd.identifier && this.isInstance) {
			throw new Error('DELETEALL operation is supported only in Multi URI for ' + this.type + ''); // No I18N
		}

		var identifiers = new StringBuilder();

		for (var i = 0, len = resources.length; i < len; i++) {
			var resource = resources[i];
			if (!(resource instanceof this.type)) {
				throw new Error('' + resource + ' is not an instance of ' + this.type + ''); // No I18N
			}
			var identifier = resource.getIdentifier();
			if (!identifier) { // Identifier must for a DELETE operation
				throw new Error('Identifier is must to DELETE Mutliple ' + rmd.resourceName + ''); // No I18N
			}
			if (i !== 0) {
				identifiers.append(',');
			}
			identifiers.append(identifier);
		}

		// Include identifiers in params.
		this.addQueryParam(rmd.identifier, identifiers.toString());
		return this._sendRequest('DELETE'); // No I18N
	}
});
// ********************
// $PRIVATE_FUNCTIONS
// ********************
$.extend(URI.prototype, {
	_sendRequest : function(type, options) {
		var _this = this;
		var promise = $.Deferred();

		// Promise Block
		options = options || {};
		options.url = _this.requestURI;
		var rmd = _this.getRMD();
		options.exports = rmd.exports;

		var isWrite = false;

		// HTTP Method
		if (!options.type) {
			options.type = type === 'GETS' ? 'GET' : type; // No I18N
		}

		// Request Params
		if (!$.isEmptyObject(_this.params)) {
			options.data = $.param(_this.params);
		}

		// Headers
		options.headers = options.headers || {};

		if (_this.headers) {
			$.extend(options.headers, _this.headers);
		}
		/*if (!options.type) {
			options.type = type === 'GETS' ? 'GET' : type; // No I18N
		}*/

		if (options.type && options.type !== 'GET') {
			if(options.type !== 'POST')
			{
				options.headers['X-HTTP-Method-Override'] = options.type; // No I18N
			}
			
			if (_this.queryParams) {
				options.url += '?' + $.param(_this.queryParams);
				options.data = options.type === 'DELETE'? null : options.data;
			}
			options.type = 'POST';
			isWrite = true;
			
		/*	options.Accept = "application/json"; // No I18N
			if (options.type === 'DELETE' && _this.deleteParams) {
				options.url += '?' + $.param(_this.deleteParams);
				options.data = null;
			}
			if(_this.postParams) {
				options.url += "?" + $.param(_this.postParams);
			}
			options.type = 'POST';
			isWrite = true;*/
		} else {
			options.data = _this.getParams();
		}
		options.headers['X-ZCSRF-TOKEN'] = URI.options.csrfParam + '=' + URI.options.csrfValue; // No I18N
		//options.headers['X-ZCSRF-TOKEN'] = ZContacts.meta.serviceInfo.csrf_param_name + '=' + ZContacts.Cookie.getCSRFValue(); // No I18N
		if (_this.authUser) {
			options.headers['X-Authorization'] = new StringBuilder('iCREST-password ').append(_this.authPassword); // No I18N
			//options.headers['X-Authorization'] = new ZContacts.StringBuilder('ZohoContacts-password ').append(_this.authPassword); // No I18N
		}

		// Request Payload
		if (($.type(options.data) === 'object' || $.type(options.data) === 'array') && (!options._multiPartAttrs || (options._multiPartAttrs && !options.formObj)) && !options.exports) {
			options.contentType = 'application/json'; // No I18N
			options.data = JSON.stringify(options.data);
		} else if (options._multiPartAttrs || options.exports) {
			var multipartAttrs = options._multiPartAttrs, fileCount = 0, formData;
			var resourceName = rmd.resourceName.toLowerCase();
			var dataJson = options.data[resourceName];
			if (window.FormData && !options.exports) {
				formData = new window.FormData();
				
				
				for ( var elem in dataJson) {
					var elemValue = dataJson[elem];
					if (multipartAttrs.indexOf(elem) !== -1 && $(elemValue).prop('files') && $(elemValue).prop('files').length) {
						dataJson[elem] = $(dataJson[elem]).prop('files')[0];
					} else if (multipartAttrs.indexOf(elem) !== -1 && $(elemValue).length) {
						dataJson[elem] = $(elemValue)[0];
						fileCount++;
					} else if( $.type(elemValue) == 'object'){    // No I18N
						dataJson[elem] =  JSON.stringify(elemValue);
					}
					formData.append(resourceName + "[" + elem + "]", dataJson[elem]);
				}
				
				
			} else {
				var $iframeElem = $("<iframe src='javascript:;' width='0' name='fileUploadIframe' id='" + resourceName + "fileUploadIframe' border='0' style='display:none;'></iframe>"); // No I18N
				var $formElem = $("<form method=" + options.type + " target='" + $iframeElem[0].name + "' action='" + options.url + "' encoding='multipart/form-data' enctype='multipart/form-data' style='display:none;'></form>");// No I18N
				var isGetRequest = (options.type.toLowerCase() === 'get'); // No I18N
				if (isGetRequest) {
					dataJson = _this.getParamsObj();
				}
				
				$formElem.append($("<input value='" + URI.options.csrfValue + "' name='" + URI.options.csrfParam + "'/>")); // No I18N

				
				//$formElem.append($("<input value='" + ZContacts.Cookie.getCSRFValue() + "' name='" + ZContacts.meta.serviceInfo.csrf_param_name + "'/>")); // No I18N
				/*if(options.headers['X-Authorization']) {
					var password = options.headers['X-Authorization'].toString(); // No I18N
					password = password.replace("ZohoContacts-password ", "");
					$formElem.append($("<input type='hidden' value='" + password + "' name='password'/>")); // No I18N
				}*/

				for ( var attrName in dataJson) {
					var nodeName = isGetRequest ? attrName : resourceName + '[' + attrName + ']';
					var elemNode = $("<input name='" + nodeName + "'/>");
					elemNode.val(dataJson[attrName]);
					if (multipartAttrs && multipartAttrs.indexOf(attrName) !== -1 && dataJson[attrName].value) {
						$(dataJson[attrName].parentElement).append(dataJson[attrName].cloneNode());
						elemNode = dataJson[attrName];
						elemNode.name = nodeName;
						fileCount++;
					}
					$formElem.append(elemNode);
				}
				$("body").append($iframeElem).append($formElem);
				window.handleIFrameResponse = _this.handleIFrameResponse;
				
				/*_rsvbObj[resourceName] = {
						resolve : resolve,
						reject : reject,
						iframeElem : $iframeElem,
						formElem : $formElem
					};*/
				
				_rsvbObj[resourceName] = { //// Have to discuss (important)
					resolve : promise.resolve,
					reject : promise.reject,
					iframeElem : $iframeElem,
					formElem : $formElem
				};
			}
			if (fileCount === 0 && multipartAttrs) {
				for (var i = 0; i < multipartAttrs.length; i++) {
					delete options.data[resourceName][multipartAttrs[i]];
				}
			}
			if (!window.FormData || options.exports) {
				_rsvbObj[resourceName].formElem.submit();
				return;
			} else {
				options.data = formData;
				options.processData = false;
				options.contentType = false;
			}
		}

		options.success = function(json/* , textStatus, jqXHR */) {
			_this.apiResponse = json;

			var isError = !$.isEmptyObject(json.error) || json.status_code < 200 || json.status_code >= 300;

			var representation = json[rmd.resourceName.toLowerCase()];
			if (json.status_code === 404 && !isWrite) { // 404 for GET is not an Error
				isError = false;
			}

			if (isError) {
				promise.reject(json);  //have to discuss
				return;
			}

			if (type === 'GETS') {
				var array = [];
				if (representation) {
					for (var i = 0, len = representation.length; i < len; i++) {
						array.push(_this.type.create().deserialize(representation[i]));
					}
				}
				array._apiResponse = _this.apiResponse;
				promise.resolve(array); //have to discuss
			} else if (type === 'GET') { // No I18N
				var o = _this.type.create();

				// Set identifier to avoid setting undefined in URI by router.
				if (_this.resourceIdentifier) {
					o.set(rmd.identifier, _this.resourceIdentifier);
				}
				if (representation) {
					o.deserialize(representation);
					promise.resolve(o);  // have to discuss
				} else {
					promise.resolve(json);  //have to discuss
				}
			} else {
				promise.resolve(json);   //have to discuss
			}
		};

		options.error = function(jqXHR /* textStatus, errorThrown */) {
			var json;
			try {
				json = $.parseJSON(jqXHR.responseText);
			} catch (e) {
				json = {
					status_code : jqXHR.status
				};
			}
			promise.reject(json);  // have to discuss
		};
		$.ajax(options);

		return promise;  //have to discuss
	},
	handleIFrameResponse : function(responseData) {
		var json = responseData;
		var resourceName = json.resource_name.toLowerCase();
		if (resourceName) {
			var isError = !$.isEmptyObject(json.error) || json.status_code < 200 || json.status_code >= 300;
			var rsvpObj = _rsvbObj[resourceName];
			$(rsvpObj.iframeElem).remove();
			$(rsvpObj.formElem).remove();
			if (isError) {
				rsvpObj.reject(json);
			} else {
				rsvpObj.resolve(json);
			}
			delete _rsvbObj[resourceName];
		}
	},
	_save : function(resource, methodType) {
		if ((methodType === 'POST' && !resource) || (resource && !(resource instanceof this.type))) {
			throw new Error('' + resource + ' is not an instance of ' + this.type + ''); // No I18N
		}

		var rmd = this.getRMD(), errorObj = null;
		if (resource) {
			resource.build(); // 1) Mulit Part Attr Set. 2) sub resource.build()
			errorObj = resource._validate(methodType);
		} 

		if (errorObj) {
			var promise = $.Deferred();  ///// have to discuss
			promise.reject({
				errors : errorObj
			});
			return promise;
		}

		var serializedData = resource ? resource.serialize() : null;
		var ajaxOptions = {
			data : serializedData,
			_multiPartAttrs : rmd.multipartAttrs,
		// to check which mode to submit data to server
		};
		if (resource && resource.get('__form')) {
			ajaxOptions.formObj = resource.get('__form');
		}
		return this._sendRequest(methodType, ajaxOptions); 
	},

	_saveAll : function(resources, methodType) {
		var ajaxOptions = {
			data : {}
		};
		var dataArr = [];
		var resourceName = this.getRMD().resourceName.toLowerCase();
		for (var i = 0; i < resources.length; i++) {
			//dataArr.pushObject(resources[i].serialize()[resourceName]);
			dataArr.push(resources[i].serialize()[resourceName]);
		}
		ajaxOptions.data[resourceName + Constants.Params.MULTIPOST_SUFFIX] = dataArr;
		return this._sendRequest(methodType, ajaxOptions); 
	},
});

URI.Headers = {
	POST_AND_GET : 'X-Post-And-Get', // No I18N
	X_HTTP_REST_Method_Override : 'X-HTTP-REST-Method-Override', // No I18N
};
URI.trimSlash = function(path) {
	if (path) {
		if (path.charAt(0) === '/') {
			path = path.substring(1);
		}
		if (path.endsWith('/')) {
			path = path.substring(0, path.length - 1);
		}
	}
	return path;
};

var StringBuilder = function(_iv) {
	var arr = _iv ? [ _iv ] : [];
	this.append = function(v) {
		arr.push(v);
		return this;
	};
	this.toString = function() {
		return arr.join("");
	};
	this.isEmpty = function() {
		return this.length() < 1;
	};
	this.length = function() {
		return arr.length;
	};
}