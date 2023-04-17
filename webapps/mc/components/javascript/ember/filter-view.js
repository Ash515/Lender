//$Id$

/**
 *
 */
(function(){
MC.FilterViewComponent = Ember.Component.extend(MC.AjaxApiMixin, {
	selectedFilter: {},
	/**
	 * In UI, By toggle this property, the form for "Create custom filter" will be opened. 
	 * Default : false 
	 */
	isCustomFilterTriggered: false,
	wholeContent: [],
	// unique index for each criteria
	uniqueIndex: 1,
	editFilterName: "",
	isAndChecked: false,
	isOrChecked: true,
	EVENT_TYPE: "",
	updatecustomFilterTrigger: function() {
		if (!this.get("filterData.isCustomFilter")) {
			this.set("isCustomFilterTriggered", false);
		}
		this.beginPropertyChanges();
		this.set("wholeContent", []);
		this.initializeSelectedFilter();
		this.endPropertyChanges();
	}.observes("filterData"),
	initializeSelectedFilter: function() {
		if (this.get("filterData")) {
			this.updateSelectedFilter();
			var wholeContent = this.get("wholeContent");
			if (wholeContent.length == 0) {
				this.send("add");
			}
		}
	}.on("init"),
	updateSelectedFilter: function() {
		var filterData = this.get("filterData");
		if (filterData) {
			this.set("selectedFilter", filterData.filters.filterBy("name", filterData.SELFILTER)[0]);
		}
	}.observes("filterData"),
	sendSelectedFilter: function() {
		var selectedFilter = this.get("selectedFilter.name");
		if (selectedFilter) {
			if (!Ember.isEqual(selectedFilter, this.get("filterData.SELFILTER"))) {
				this.sendAction("changeFilter", this.get("selectedFilter").name);
			}
		}
	}.observes("selectedFilter"),
	isCustomFilter: function() {
		return this.get("filterData.isCustomFilter");
	}.property("filterData"),
	getCustomFilterConfig: function() {
		// var customFilter = this.get("filterData").customFilterConfig || [];
		// return customFilter;
		return this.get("customFilterConfig");
	},
	resetFilter: function() {
		this.beginPropertyChanges();
		this.set("wholeContent", []);
		this.set("uniqueIndex", 1);
		this.set("editFilterName", "");
		this.set("isAndChecked", false);
		this.set("isOrChecked", true);
		this.endPropertyChanges();
	},
	/**
	 * It is for internal purpose only. It will display the status message and update the table with new filter.
	 */
	_saveSuccessCallback: function(obj, data) {
		var filterName = obj.filterName;
		get(this, 'flashes').success(data.htmlSafe(), 3000);
		this.sendAction("changeFilter", filterName);
		this.send("cancel");
	},
	_failureCallback : function(jqXHR, textStatus, errorThrown)
	{
		var msg = (errorThrown + " : "+jqXHR.responseText).htmlSafe();
		(jqXHR.status === 400) ? get(this, 'flashes').warning(msg, 3000) : get(this, 'flashes').danger(msg, 3000);	
	},

	/**
	 * It will display the status message and update the table with default filter.
	 */
	_deleteSuccessCallback: function(obj, data) {
		get(this, 'flashes').success(data.htmlSafe(), 3000);
		this.sendAction("changeFilter", this.get("filterData.filters")[0].name);
	},
	actions: 
	{
		createFilter: function() 
		{
			this.sendRequest({
				url: "EmberFilterCreateForm.ec?customFilterViewName="+this.get("viewName")+"&EVENT_TYPE=Create",
				onSuccessFunc: "_createFilterCallback"
			});	
		},
		_createFilterCallback : function(customFilterConfig)
		{
			this.beginPropertyChanges();
				this.set("customFilterConfig", customFilterConfig.criteriaDefn);
				this.resetFilter();
				this.initializeSelectedFilter();
				this.set("isCustomFilterTriggered", true);
				this.set("EVENT_TYPE", "Add");
			this.endPropertyChanges();
		},
		/**
		 * It will add a new criteria row in custom filter form on-demand.
		 */
		add: function() {
			var obj = {};
			obj.data = this.getCustomFilterConfig();
			obj.index = this.get("uniqueIndex"); 
			this.beginPropertyChanges();
			this.get("wholeContent").pushObject(obj);
			this.incrementProperty("uniqueIndex");
			this.endPropertyChanges();
		},
		/**
		 * It will remove the selected criteria row(determined by given index) from the custom filter form on-demand.
		 */
		remove: function(index) {
			var selected = this.get("wholeContent").filterBy("index", index)[0];
			this.get("wholeContent").removeObject(selected);
		},
		/**
		 * It saves the filter with given criteria(s). It will also validate, whether all the required values are entered or not.
		 * After the successful validation, it will submit the form and call the callback function "_saveSuccessCallback".
		 */
		save: function() {
			var filterTitle = jQuery('input[name=filterName]').val();
			var filterName = filterTitle;
			var event_type = this.get("EVENT_TYPE");
			var newFilterName = null;
			/**
			 *	For edit filter, filterName should be the old-filterName.
			 */
			if (isNotNullString(event_type) && (event_type === "Edit") && this.get("relCriteriaList")) {
				filterName = this.get("relCriteriaList.filterName");
				newFilterName = filterTitle.replace(/[&\/\\#,`=+()$~%.'":*?<>{}! ]/g, '_');
			}
			filterName = filterName.replace(/[&\/\\#,`=+()$~%.'":*?<>{}! ]/g, '_');
			var viewName = this.get("viewName");
			var boolenOperator = jQuery('input[name=boolCriteria]:checked').val();
			var columnCombos = jQuery('select[name="columnCombos"]').map(function() {
				return this.value;
			}).get();
			var comparatorCombos = jQuery('select[name="comparatorCombos"]').map(function() {
				return this.value;
			}).get();
			var filterCriteriaValue = jQuery(".valueCombos").map(function() {
				if (!Ember.isEmpty(this.value)) {
					return this.value;
				}
			}).get();
			if (!Ember.isEmpty(filterTitle) && filterCriteriaValue.length > 0 && filterCriteriaValue.length == columnCombos.length) {
				var queryStr = "FILTERTITLE=" + encodeURIComponent(filterTitle) + "&FILTERNAME=" + filterName;
				queryStr = queryStr + "&VIEWNAME=" + encodeURIComponent(viewName) + "&EVENT_TYPE=" + this.get("EVENT_TYPE", "Add") + "&booleanoperator=" + boolenOperator + "&LISTID=" + this.get("filterData.LISTID") + "&";
				for (i = 0; i < columnCombos.length; i++) {
					if (i > 0) {
						queryStr = queryStr + "&";
					}
					queryStr = queryStr + "ROWIDX=" + (i + 1);
					queryStr = queryStr + "&COLNAME_" + (i + 1) + "=" + columnCombos[i];
					queryStr = queryStr + "&COMPARATOR_" + (i + 1) + "=" + comparatorCombos[i];
					queryStr = queryStr + "&COLVALUE_" + (i + 1) + "=" + filterCriteriaValue[i];
				}
				this.sendRequest({
					url: "EmberFilterCreateForm.ve?" + queryStr,
					onSuccessFunc: "_saveSuccessCallback",
					onFailureFunc:"_failureCallback",
					onSuccessFuncArg: {
						filterName: newFilterName ? newFilterName : filterName,
						filterTitle: filterTitle
					}
				});
			} 
			else 
			{
				var msg = "";
				if (Ember.isEmpty(filterName)) {
					msg = "mc.components.customfilter.name.empty.warning";//"Filter name should not be empty";
				} else if (filterCriteriaValue.length == 0) {
					msg = "mc.components.customfilter.criteria.empty.warning";//"Criteria value should not be null";
				} else if (filterCriteriaValue.length != columnCombos.length) {
					msg = "mc.components.customfilter.some.criteria.missed.warning";//"Some Criteria values may missed";
				}
				get(this, 'flashes').warning(I18N.getMsg(msg), 3000);
			}
		},
		cancel: function() {
			this.set("isCustomFilterTriggered", false);
			this.resetFilter();
			this.send("add");
		},
		deleteFilter: function(view) {
			var confirm = window.confirm(I18N.getMsg("mc.components.filter.Do_you_really_want_to_delete_this_filter",[this.get("selectedFilter").name]));
			if (confirm) {
				var viewName = this.get("viewName");
				var filterName = null;
				if (this.get("selectedFilter")) {
					filterName = this.get("selectedFilter").name;
				}
				var queryStr = "VIEWNAME=" + viewName + "&EVENT_TYPE=Delete&LISTID=" + this.get("filterData.LISTID") + "&FILTERNAME=" + filterName;
				this.sendRequest({
					url: "EmberFilterCreateForm.ve?" + queryStr,
					onSuccessFunc: "_deleteSuccessCallback",
					onFailureFunc:"_failureCallback",
					onSuccessFuncArg: {
						filterName: filterName
					}
				});
			}
			this.set("isCustomFilterTriggered", false);
		},
		editFilter: function() {
			this.sendRequest({
				url: "EmberFilterCreateForm.ec?customFilterViewName="+this.get("viewName")+"&FILTERNAME="+this.get("selectedFilter.name")+"&EVENT_TYPE=Edit"+"&LISTID="+this.get("filterData.LISTID"),
				onSuccessFunc: "_editFilterCallback"
			});	
		},
		_editFilterCallback : function(editFilterModel)
		{
			this.beginPropertyChanges();
				this.resetFilter();
				this.set("customFilterConfig", editFilterModel.criteriaDefn);
				this.set("relCriteriaList", editFilterModel.relCriteriaList);
			this.endPropertyChanges();
			var comparators = getAllComparators();
			if (editFilterModel.relCriteriaList)
			{
				var relCriteria = editFilterModel.relCriteriaList;
				var criteriaList = relCriteria.criteria;
				for (i = 0; i < criteriaList.length; i++) {
					var criteria = criteriaList[i];
					var obj = {};
					obj.data = this.getCustomFilterConfig();
					obj.index = this.get("uniqueIndex");
					obj.selectedColumn = this.getCustomFilterConfig().filterBy("COLNAME", criteria.COLNAME)[0];
					obj.selectedComparator = criteria.COMPARATOR;
					if (obj.selectedColumn.allowedValues) {
						var colValue = isNaN(criteria.COLVALUE) ? criteria.COLVALUE : parseInt(criteria.COLVALUE);
						obj.selectedCriteriaValue = obj.selectedColumn.allowedValues.filterBy("optVal", colValue)[0];
					} else {
						obj.selectedCriteriaValue = criteria.COLVALUE;
					}
					this.get("wholeContent").pushObject(obj);
					this.incrementProperty("uniqueIndex");
				}
				this.set("editFilterName", relCriteria.displayName);
				var booleanoperator = relCriteria.booleanOperator;
				if (Ember.isEqual(booleanoperator, "and")) {
					this.set("isAndChecked", true);
					this.set("isOrChecked", false);
				}
				this.set("isCustomFilterTriggered", true);
				this.set("EVENT_TYPE", "Edit");
			}
		}
	}
});
Ember.Handlebars.helper('filter-view', MC.FilterViewComponent);})();