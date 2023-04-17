// $Id: $
ZResource = function() {
};
// ********************
// $INSTANCE_METHODS
// ********************
$.extend(ZResource.prototype, {
	resourceName : null,
	parent : null, // ZResource Object
	identifier : null,
	attrs : null, // Array<String>. Example: ['first_name', 'last_name'] // No I18N
	subResources : null, // Array<ZResource>. Example: [Emails, ScreenName]

	set : function(k, v) {
		this[k] = v;
		return this;
	},

	get : function(k) {
		return this[k];
	},

	addSubResource : function(resource) {
		if (!(resource instanceof ZResource)) {
			throw '\'' + resource + '\' must be a sub class of \'ZResource\''; // No I18N
		}
		var rmd = resource.getRMD();
		var name =ICREST.Utils.camelize(rmd.resourceName); 
		//var name = ZContacts.Utils.camelize(rmd.resourceName);
		if (!this.getSubResourceType(name)) {
			throw '\'' + name + '\' resource is not a sub resource of \'' + this.getRMD().resource + '\''; // No I18N
		}
		var arr = this.get(name);

		if (!rmd.identifier) {
			this.set(name, resource);
		} else {
			if (!arr) {
				arr = [];
				this.set(name, arr);
				arr.push(resource);
			} else {
				arr.push(resource);
			}
		}
		return this;
	},

	getSubResourceType : function(varName) {
		var resourceMetaData = this.getRMD();
		return resourceMetaData._subResourceObjMap && resourceMetaData._subResourceObjMap.hasOwnProperty(varName) && resourceMetaData._subResourceObjMap[varName];
	//	return resourceMetaData._subResourceObjMap && resourceMetaData._subResourceObjMap[varName];
	},

	_validate : function(methodType) {
		var validateMethod = methodType === 'POST' ? 'validate' : 'validatePartial'; // No I18N
		//var validateMethod = isPost ? 'validate' : 'validatePartial'; // No I18N
		var errors = [], j;
		var validatedOutput = this[validateMethod] && this[validateMethod]();
		errors = this.addErrors(errors, validatedOutput);
		// Call validate method of all SubResources
		var subResourcesList = this.getRMD()._subResourcesList;
		if (!ICREST.Utils.isEmptyArray(subResourcesList)) {  //*********have to change
			errors = !errors ? [] : errors;
			for (var i = 0, len = subResourcesList.length; i < len; i++) {
				var arr = this.get(subResourcesList[i]);
				if (!arr) {
					continue;
				}

				if (!arr.length) {
					validatedOutput = arr.validate && arr.validate();
					errors = this.addErrors(errors, validatedOutput);
					continue;
				}
				for (j = 0; j < arr.length; j++) {
					validatedOutput = arr[j].validate && arr[j].validate();
					errors = this.addErrors(errors, validatedOutput);
				}
			}
		}
		return errors.length ? errors : null;
	},

	addErrors : function(errors, errorObj) {
		if (!errorObj) {
			return errors;
		}
		if (!$.isArray(errorObj) && !$.isEmptyObject(errorObj)) {
			//errors.pushObject(errorObj);
			errors.push(errorObj);
		} else {
			if (errorObj.length) {
				errors = errors.concat(errorObj);
			} else {
				errors = errorObj;
			}
		}
		return errors;
	},

	getParentIdentifier : function() {
		var rmd = ZResource.getResourceMetaData(this.getRMD().parent);
		return rmd && this.get('parent.' + rmd.identifier);
	},

	clearSubResources : function() {
		var subResourcesList = this.getRMD()._subResourcesList;
		if (subResourcesList) {
			for (var i = 0, len = subResourcesList.length; i < len; i++) {
				this.set(subResourcesList[i], null);
			}
		}
	},

	/* Serialize / DeSerialize */
	serialize : function() {
		var jsonObj = {};
		var json = {};
		var rmd = this.getRMD();
		var attrs = rmd.attrs || [];
		for (var i = 0, len = attrs.length; i < len; i++) {
			var key = attrs[i], value = this.get(key);
			if (value !== null && value !== undefined) {
				json[key] = this.serializeAttr(key, value);
			}
		}
		jsonObj[rmd.resourceName.toLowerCase()] = json;
		return jsonObj;
	},

	/* To set file obj to multipart key */
	setMultipartAttrs : function() {
		var formObj = this.get('__form');
		if (!formObj || !$(formObj).is('form')) {
			return;
		}
		var multipartKeys = this.getRMD().multipartAttrs, keyIndex;
		var $formObj = $(formObj);
		if(!multipartKeys) {
			return;
		}
		
		
		for (keyIndex = 0; keyIndex < multipartKeys.length; keyIndex++) {
			var multiPartKey = multipartKeys[keyIndex];
			//If there is multiPartKey, no need to set the value again.
			if(!this.get(multiPartKey)) {				
				var $file = $formObj.find("input[name='" + multiPartKey + "']");
				this.set(multiPartKey, $file.get(0));
			}
		}
		
	/*	for (keyIndex = 0; keyIndex < multipartKeys.length; keyIndex++) {
			var multiPartKey = multipartKeys[keyIndex];
			var $file = $formObj.find("input[name='" + multiPartKey + "']");
			this.set(multiPartKey, $file.get(0));
		}*/
	},

	build : function() {
		this.setMultipartAttrs();
		var subResourcesList = this.getRMD()._subResourcesList;
		if (!ICREST.Utils.isEmptyArray(subResourcesList)) { ///important : have to discuss
			for (var i = 0; i < subResourcesList.length; i++) {
				var subResource = this.get(subResourcesList[i]);
				if (!subResource) {
					continue;
				} else if (!$.isArray(subResource)) {
					subResource.build();
					continue;
				}
				for (var j = 0; j < subResource.length; j++) {
					subResource[j].build();
				}
			}
		}
	},

	serializeAttr : function(key, value) {
		var subResourceType = this.getSubResourceType(key);
		var serializedData;
		if (subResourceType && value) {
			var arr = [];
			if ($.isArray(value)) {
				for (var j = 0; j < value.length; j++) {
					serializedData = value[j] ? value[j].serialize()[key.toLowerCase()] : null;
					//serializedData = value[j] ? value[j].serialize()[key] : null;
					arr.push(serializedData);
				}
				return arr;
			} else {
				return value.serialize()[key.toLowerCase()];
			}
		}
		return value;
	},

	deserialize : function(json) {
		//Em.beginPropertyChanges(this);   //have to discuss with mani anna
		for ( var key in json) {
			if (json.hasOwnProperty(key)) {
				this.deserializeAttr(key, json[key]);
			}
		}
		//Em.endPropertyChanges(this); //have to check with mani anna
		return this;
	},

	deserializeAttr : function(key, value) {
		var subResourceType = this.getSubResourceType(key);
		if (subResourceType) {
			if ($.isArray(value)) {
				for (var i = 0, len = value.length; i < len; i++) {
					this.addSubResource(subResourceType.create().deserialize(value[i]));
				}
			} else {
				this.addSubResource(subResourceType.create().deserialize(value));
			}

		} else {
			this.set(key, value);
		}
		return this;
	},

/*	merge : function(zresource) {
		for ( var key in zresource) {
			if (zresource.hasOwnProperty(key)) {
				this.set(key, zresource[key]);
			}
		}
		return this;
	},*/

	getIdentifier : function() {
		return this.get(this.getRMD().identifier);
	},

	getURI : function(isInstance/* , identifiers ... */) {
		var type = this.constructor;
		var identifiers = Array.prototype.slice.apply(arguments).slice(1);

		if (arguments.length === 1) { // Identifiers not passed.
			var rmd = this.getRMD();
			while(rmd.parent) {
				rmd = ZResource.getResourceMetaData(rmd.parent);

				var value = this.get('parent.' + rmd.identifier);
				if (!value) {
					throw new Error('Parent Identifier (' + rmd.resourceName + '.' + rmd.identifier + ') is missing in the ZResource.'); // No I18N
				}
				identifiers.splice(0, 0, value);
			}
		}
		if (isInstance) {
			identifiers.push(this.getIdentifier());
		}
		return new URI([ type ].concat(identifiers));
	},

	POST : function() {
		var args = Array.prototype.slice.apply(arguments);
		args.splice(0, 0, false);
		return this.getURI.apply(this, args).POST(this);
	},

	PUT : function() {
		var args = Array.prototype.slice.apply(arguments);
		args.splice(0, 0, true);
		return this.getURI.apply(this, args).PUT(this);
	},
	
	
	PATCH : function() { //added extra
		var args = Array.prototype.slice.apply(arguments);
		args.splice(0, 0, true);
		return this.getURI.apply(this, args).PATCH(this);
	},

	DELETE : function(paramsObj) {
		var uri = this.getURI(true);
		if ($.isPlainObject(paramsObj)) { // Add all params
			for ( var param in paramsObj) {
				uri.addDeleteParams(param, paramsObj[param]);
			}
		}
		return uri.DELETE(this);
	},

	getRMD : function() {
		return RMD.getMetaData(this);
	},
	
	clone : function() {
		return this.constructor.create().deserialize(this);
	}
});

// ZResource.getResourceMetaData(type); // static
// zresource.getRMD(); // instance
// new URI().getRMD(type);

// ********************
// $STATIC_METHODS
// ********************
$.extend(ZResource, {
	extendClass : function(resourceProps) {    //have to discuss with kams
		var superclass = ZResource;

		var subclass = function ZResourceExtend() {
		};
		subclass.prototype = new ZResource();
		subclass.prototype.constructor = subclass;

		// Copy static methods
		for ( var name in superclass) {
			if (superclass.hasOwnProperty(name) && !subclass[name]) {
				subclass[name] = superclass[name];
			}
		}
		subclass.superclass = superclass;
		subclass.superproto = superclass.prototype;

		subclass.resourceProps = resourceProps;
		$.extend(subclass.prototype, resourceProps);
		return subclass;
	},

	create : function(prop) {
		var fn = this;
		var ins = (new fn());
		if (prop) 
		{
			if(!this.getResourceMetaData(this).multipartAttrs)
			{
				prop=JSON.parse(JSON.stringify(prop));
			}
			ins.deserialize(prop);
		}
		return ins;
	},

	// Due to a cyclic dependence problem between URI.js / ZResource.js, resolver doen't load only one.
	// `__zresource` property defined to verify whether intance of ZResource object onlt passed.
	// `__zresource` will the verified without refering ZResource directly.
	__zresource : true,
	/**
	 * @param type -
	 *            ZResource object
	 */
	getResourceMetaData : function(type) {
		return RMD.getMetaData(type);
	},

	/**
	 * Possible arguments : User.GET(107), User.GET(107, {}), Emails.GET(107, 'mg@mg.com'), UserEmail.GET(107, 'mg@mg.com', {})
	 */
	GET : function(parentIdentifier, identifier, params) {
		if (!params && $.isPlainObject(identifier)) {
			params = identifier;
			identifier = undefined;
		}
		return new URI(this, parentIdentifier, identifier).GET();
	},

	GETS : function(parentIdentifier, params) {
		if (!params && $.isPlainObject(parentIdentifier)) { // User.GET({type: 'all'})
			params = parentIdentifier;
			parentIdentifier = undefined;
		}
		return new URI(this, parentIdentifier).GETS();
	}
});

// ********************
// $RESOURCE_META_DATA
// ********************
//ZContacts.RMD = {
var RMD = {
	/* used to store the meta values of ZResource */
	RESOURCE_META_DATA : {},

	/**
	 * This method will return the properties of an ZResource.
	 * 
	 */
	getMetaData : function(type) {
		// if (type instanceof ZResource)
		if (!type.create) { // Not a instance variable.
			type = type.constructor;
		}
		var metadata = this.RESOURCE_META_DATA[type.__zresource_name__];
		if (!metadata) {// If resource already exist in RESOURCE_META_DATA we don't need to overwrite it
			
		  //metadata = this.getFilteredMetaData(type.resourceProps);
			metadata = this.getFilteredMetaData(type.resourceProps);
			
			
			// Compute `parents` property of the resource

			if (metadata.parent) {
				var parents = [], parent = metadata.parent;
				while(parent) {
					parents.splice(0, 0, parent);
					parent = this.getMetaData(parent).parent;
				}
				metadata.parents = parents;
			}
			type.__zresource_name__ = !metadata.parents || metadata.parents.length < 1 ? metadata.resourceName : metadata.parents[0].__zresource_name__ + metadata.resourceName;
			this.RESOURCE_META_DATA[type.__zresource_name__] = metadata;

	/*		if (metadata.fixed_data) {                 ** have to ask kams**
				var fixedData = metadata.fixed_data;
				var modifiedData = [];
				for (var i = 0; i < fixedData.length; i++) {
					var d = fixedData[i];
					modifiedData.push(type.create(d));
				}
				metadata.fixed_data = modifiedData;
			}*/
			/**
			 * Handling `SubResources` before storing metadata will become recursive and nothing will be there in `RESOURCE_META_DATA`.
			 * 
			 * To avoid recursive calls moved it to a seperate method and triggered it after storing `Meta`.
			 * 
			 */
			this.setSubResources(type);
		}
		return metadata;
	},

	/* Adding a subresource as attr of resource */
	setSubResources : function(type) {
		var metaData = this.RESOURCE_META_DATA[type.__zresource_name__];// getting stored cache value of current resource.
		var subResources = metaData.subResources;// Subresources of current resource
		if (!ICREST.Utils.isEmptyArray(subResources)) { //  *** have to discuss ****
			metaData._subResourceObjMap = {};
			for (var i = 0, len = subResources.length; i < len; i++) {
				var subResource = subResources[i];
				var resourceName = this.getMetaData(subResource).resourceName;
				// Convert Resource Name to variable Name (User ==> user, Emails ==> emails)
				
				var varName = ICREST.Utils.camelize(resourceName);
			   //var varName = ZContacts.Utils.camelize(resourceName);
				
				metaData.attrs.push(varName); //push --> pushobject
				metaData._subResourceObjMap[varName] = subResource; // contains <ZResource> name of the subresoures available for current resource
			}
			metaData._subResourcesList = Object.keys(metaData._subResourceObjMap);
		}

		/**
		 * Removing properties added in MetaData to avoid accessing properties directly from ZResource model object.
		 * 
		 */
		var properties = {};
		var requiredMetaAttrs = this.requiredMetaAttrs;
		for (var index = 0; index < requiredMetaAttrs.length; index++) {
			properties[requiredMetaAttrs[index]] = null;
		}
		$.extend(type.prototype, properties);
	},

	requiredMetaAttrs : [ 'resourceName', 'attrs', 'parent', 'identifier', 'multipartAttrs', 'subResources', 'exports', 'path' ],    //*** removed  fixed date property // No I18N

	getFilteredMetaData : function(metaData) {
		var metaJson = {};
		var requiredMetaAttrs = this.requiredMetaAttrs;
		for (var i = 0; i < requiredMetaAttrs.length; i++) {
			var attr = requiredMetaAttrs[i];
			if (metaData[attr]) {
				metaJson[attr] = metaData[attr];
			}
		}
		return metaJson;
	}
};
/*
ICREST.Utils = {
		camelize : function(str) {
			return str.charAt(0).toLowerCase() + str.substring(1);
		},

		isEmptyArray : function(arr) {
			return !arr || !arr.length;
		}
};*/

var ICREST={
		 Utils : {
				camelize : function(str) {
					return str.charAt(0).toLowerCase() + str.substring(1);
				},

				isEmptyArray : function(arr) {
					return !arr || !arr.length;
				}
		}
		};