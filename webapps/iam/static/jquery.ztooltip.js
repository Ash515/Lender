/* $Id$ */
jQuery(function($){
	var options = {};
	var isMouseLeave = false;
	var tempTooltipEle = undefined;
	var position;
	var content;
	var isMouseEntered = false;
	var tooltipTimer = undefined;
	var tooltipTimeDelay = 800;
	var tooltip =  undefined;
	var targetEle = undefined;
	var targetTitle = undefined;
	var tooltipHeader = undefined;
	var tooltipContent = undefined;
	var tooltipCallout = undefined;
	var tooltipIcon = undefined;
	var tooltipShowTimer = undefined;
	var tooltipAjaxTimer = undefined;
	var tooltipTimeoutValue= undefined;
	var tooltipOptions = {};
	var calloutDirection =  {
		'northwest': 'top',
		'north': 'top',
		'northeast': 'top',
		'west': 'left',
		'east': 'right',
		'southwest': 'bottom',
		'south': 'bottom',
		'southeast': 'bottom'
	};
	$.ZtoolTip = function(ele, _options){
		tooltipOptions = _options;
		bindEvents(ele);
	}
	var defaults = {
		callout: 'north',	//No i18n
		autohide: true,
		mousetrack: false,
		mouseEnter: false,
		showShortcutKey: true,
		contentType: 'text',	//No i18n
		positionAlterable: true,
		calloutHideMode: false
	}
	function parseTitle(ele, title){
		try{
			var parseOptions = $.parseJSON(title);
			if(!parseOptions.componentOptions){
				parseOptions = {"content": title};
				return parseOptions;
			}
			return parseOptions.componentOptions;
		}catch(e){
			eleOptions = {"content": title};
			return eleOptions;
		}
	}
	function traverseAndGetContextElement(ele, attr){
		var selector = "["+attr+"]";
		try{
			ele =  ele.is(selector)? ele: $(ele.parents(selector).get(0));
		}catch(e){
			//Meaning the ele has no title attr
		}
		return ele;
	}
	var currentEle = undefined;
	function bindEvents(ele){
		this._windowEle = $(window);
		this._windowWidth = this._windowEle.width();
		var baseObj = this;
		this._windowEle.on('resize.'+this.widgetName, function(ev){ //No I18N
			baseObj._windowWidth = baseObj._windowEle.width();
		});
		this._documentEle = $(document);
		this._documentEle.on('keydown.'+this.widgetName, function( eventObj ) {	//No I18N
  			if (eventObj.keyCode == 27) {
  				removeTip( eventObj );
 			}
		});
		$(ele).on('buttondisabled', function(orgEvent, ui){	//No I18N
			var objEle = $(ui.element);
			var title = objEle.attr('title');	//No I18N
			if(ui.disabled){
				objEle.removeAttr('title');	//No I18N
				objEle.data('ztooltip', title);	//No I18N
			}
			else{
				objEle.attr('title', objEle.data('ztooltip'));	//No I18N
			}
		});
   		$(ele).on('mouseover mouseup', function(ev){ //No I18N
			var objEle = traverseAndGetContextElement($(ev.target), 'title');
			var title = objEle.attr('title');
			if(!title){
				return;
			}
			if(objEle.length && objEle[0].nodeName.toLowerCase() !== 'document'){	//No I18N
				if(tooltipTimer){
                    clearTimeout(tooltipTimer);
                }
                ev.stopPropagation();
				ev.preventDefault();
				if(objEle.attr('disabled') || objEle.hasClass('ui-state-disabled')){	//No I18N
					clearTitle(objEle);
					removeTip();
					return false;
				} 
				/*if(currentEle && options.autohide){
					clearTitle(currentEle, true);
					removeTip();
				}*/
				currentEle = objEle;
				clearTitle(objEle);
				options = $.extend({}, defaults, parseTitle(objEle, title));
				if($(tooltip).length){
					$(tooltip).find('.ui-ztooltip-close').remove();	//No I18N
				}
				tooltipTimeDelay = 800;
				showTip(ev, objEle);
				targetEle = objEle;
				targetTitle = title;
				objEle.on('click.ztooltip', function(ev){	//No I18N
					removeTip();
				});
				objEle.off('mouseout.ztooltip').on('mouseout.ztooltip', function(ev){	//No i18n
					if(options.timeout){
						clearTimeout(tooltipTimeoutValue);
				    }
                    if(tooltipTimer){
						clearTimeout(tooltipTimer);
					}
					tooltipTimer = setTimeout(function() {
						if(options.autohide ){
							objEle.unbind('mousemove');	//No I18N
							removeTip(ev);
						}
    				},200);
					clearTitle(objEle, true);
				});
				baseObj._documentEle.off('mousedown.ztooltip').on('mousedown.ztooltip', function(ev){	//No i18n
					if(options.autohide){
						objEle.unbind('mousemove');	//No I18N
						removeTip(ev);
					}
					clearTitle(objEle, true);
				});
				if(options.mousetrack){
					objEle.off('mousemove.ztooltip').on('mousemove.ztooltip', function(ev){	//No i18n
						moveTip(ev, objEle);
					});
				}
			}
		});
	}
	function clearTitle(ele, reset){
		var parents = !reset? ele.parents('[title]'): ele.data('parents');
		if(!reset){
			parents.push(ele);
			ele.data('parents', parents);
		}else{
			ele.data('parents', undefined);
		}
		if(parents){
			$.each(parents, function(i, _ele){
				_ele = $(_ele);
				var title = '';
				var eleTitle =  _ele.attr('title');	//No i18n
				if(reset){
					if(eleTitle != _ele.data('title') && eleTitle!=''){	//No i18n
						title = eleTitle;
					}
					else{
						title = _ele.data('title');	//No i18n
					}					
				}else{
					_ele.data('title', eleTitle);	//No i18n
				}
				_ele.attr('title', title);
			});
		}
	}
	function createToolTip(ele){
		var checkTooltip = !tooltip? false : true;	//No i18n
		var contentCornerClass = 'ui-corner-all';	//No I18N
		var contentClass = (options.ajaxContent)? 'ui-ztooltip-ajaxcontent': (options.autohide)? 'ui-ztooltip-content': 'ui-ztooltip-contentwithclose';	//No I18N
		if(!checkTooltip ){
			tooltip = $("<div>").attr('class','ui-ztooltip ui-widget');	//No I18N
			tooltipCallout = undefined;
			var overlaydiv =  $("<div>").attr('class','ui-ztooltip-overlaydiv ui-corner-all');	//No I18N
			tooltipHeader = $("<div>").attr('class','ui-ztooltip-header ui-corner-top');	//No I18N
			tooltipContent = $("<div>").attr('class', contentClass+' '+contentCornerClass);	//No I18N
			tooltipIcon = $("<span>").attr('class','ui-ztooltip-img '+options.iconclass).appendTo(overlaydiv);	//No I18N
			tooltipHeader.appendTo(overlaydiv);
			tooltipContent.appendTo(overlaydiv);
			overlaydiv.appendTo(tooltip);
			$('body').append(tooltip);	//No I18N
		}
		else{
			tooltipTimeDelay=0;
		}
		tooltipHeader.css('display','');	//No I18N
		tooltipIcon.css('display','');	//No I18N
		if(options.iconclass){
			tooltipIcon.css({'display': 'inline-block'});	//No I18N
		}
		if(options.title){
			contentCornerClass = 'ui-corner-bottom';
			tooltipHeader.css({'display':'inline-block'});	//No I18N
		}
		if(!options.autohide){
			var closeBtn = $("<span>").attr('class','ui-ztooltip-close ui-icon ui-components-icon').on('click', function(ev){ //No I18N
						$(targetEle).off('mousemove'); //No I18N
						removeTip(ev);
						$(targetEle).attr('title', targetTitle);
					});
			closeBtn.appendTo(tooltip);
			$(targetEle).attr('noAutoHide', true);
		}

		tooltipContent.attr('class', contentClass+' '+contentCornerClass);	//No I18N
		if(!options.ajaxContent){
			content = options.content;
			var isHtmlContent = (options.contentType == 'html');
			if(isHtmlContent && options.isContentElementId){
				var tmpParent = $("<div>").append($('#'+options.content).show());
				content = tmpParent.html();
			}
			if(tooltipOptions && tooltipOptions.showShortcutKey){
				ele = ele.is('label.ui-button')? ele.prev('input'): ele;
				var key = this._documentEle.shortcutkeys('getShortcutKey', ele);	//No I18N
				if(key){
					content = content+" ("+key+")";
				}
			}
		}
		if(!tempTooltipEle){
			tempTooltipEle = $("<div class='ui-ztooltip-content'></div>");	//No I18N
			$('body').append(tempTooltipEle);	//No I18N
		}
		var isHtmlContent = (options.contentType == 'html');	//No I18N
		tempTooltipEle.removeAttr('style').hide();	//No I18N
		tempTooltipEle[isHtmlContent? 'html': 'text'](content);	//No I18N
		tempTooltipEle.width(tempTooltipEle.width()+16);
		tempTooltipEle.height(tempTooltipEle.height()+9);
		
		if(options.callout && !options.ajaxContent){
			if(!tooltipCallout){
				tooltipCallout = $("<div>").attr('class', 'ui-ztooltip-callout').appendTo(tooltip);	//No I18N
			}
			position = getCalloutPosition(options.callout, tooltipCallout);
		}
		else{
			tooltipCallout = undefined;
		}
		return tooltip;
	}
	function showTip(ev, ele){
		var isHtmlContent = (options.contentType == 'html');	//No I18N
		ele.on('mouseleave.ztooltip',function() {	//No I18N
			isMouseLeave = false;
    	});
		if(options.mouseEnter === true || options.mousetrack === true){
			options.callout = 'northwest';	//No i18n
		}
		if(!isMouseLeave){
            var tooltipEle = createToolTip(ele);
            isMouseLeave = true;
		}
		if(tooltipEle){
			var toolTipPos = undefined;
			if(ev.originalEvent){
				toolTipPos = (options.callout && !options.ajaxContent)? 
						getTooltipPosition(ev): {'left':((ev.pageX+10)),'top':(ev.pageY+10)};
			}else{
				toolTipPos = ele.offset();
				toolTipPos.left+=ele.width();
				toolTipPos.top+=ele.height();
			}
			toolTipPos = adjustTooltipPosition(toolTipPos, ele, tempTooltipEle);
			clearTimeout(tooltipShowTimer);
			clearTimeout(tooltipAjaxTimer);
			tooltipShowTimer = setTimeout(function(){
				if(ele.is(':visible') || ele.is('option')){ //Chrome & IE says option element is always hidden. So we have to skip option element.
					if(options.ajaxContent){
						var loader = $("<div>").attr('class', 'ui-ztooltip-content-loading');	//No I18N
						$(tooltip).find('.ui-ztooltip-ajaxcontent').append(loader);	//No I18N
						tooltipAjaxTimer = setTimeout(function(){
							$.ajax({
								type: 'GET', //No I18N
								url: options.ajaxContent,
								data:"",
								success: function(resp){
									$(tooltip).find('.ui-ztooltip-ajaxcontent').html(resp);	//No I18N
								},
								error:function(){
									$(tooltip).find('.ui-ztooltip-ajaxcontent').empty();	//No I18N
								}
							});
						});
					}
					if(options.timeout && options.autohide){
						tooltipTimeoutValue = setTimeout(function(){
							removeTip(ev);
						}, parseInt(options.timeout));
					}					
					tooltipEle.show(1, function(){
						tooltipHeader.text(options.title);
						tooltipContent[isHtmlContent? 'html': 'text'](content);	//No I18N
						tooltipCallout.css(position);
						toolTipPos = fixTooltip(ev, tooltipEle, toolTipPos, ele);
						if(toolTipPos){
							tooltipEle.css(toolTipPos);
						}
						if(options.calloutHideMode){
							tooltip.find('.ui-ztooltip-callout').hide();	//No I18N
						}	
					});
				}
			}, tooltipTimeDelay);
		}
	}
	function adjustTooltipPosition(toolTipPos, ele, tooltipEle, dir){
		var direction = options.callout? options.callout: dir;
		var ele_offset = ele.offset();
		var ele_offset_left = ele_offset.left;
		var ele_offset_top = ele_offset.top;
		if(ele.is('option')){   //Chrome && IE returns option.offset as 0 .So we have to calculate the offset from select element
			ele_offset_left = ele.parent('select').offset().left;
			ele_offset_top = ele.parent('select').offset().top+ele.offset.top;
		}
		if(direction){
			if(direction.indexOf('north') != -1){
				if(!options.mouseEnter && !options.mousetrack){
					toolTipPos.left=((ele_offset_left-8)-(tooltipEle.width()/2-8)+ele.outerWidth()/2);
				}
				toolTipPos.top = (ele_offset_top+ele.outerHeight())+9;
			} else if(direction.indexOf('south') != -1){
				toolTipPos.left=((ele_offset_left-8)-(tooltipEle.width()/2-8)+ele.outerWidth()/2);
				toolTipPos.top = (ele_offset_top-tooltipEle.outerHeight())-9;
			} else if(direction === 'west'){	//No I18N
				toolTipPos.left = parseInt((ele_offset_left+ele.outerWidth())+9);
				toolTipPos.top = (ele_offset_top - tooltipEle.height()/2)+ele.outerHeight()/2;
			} else if(direction === 'east'){	//No I18N
				toolTipPos.left = parseInt((ele_offset_left-tooltipEle.width())-9);
				toolTipPos.top = (ele_offset_top - tooltipEle.height()/2)+ele.outerHeight()/2;
			}
		}

		return toolTipPos;
	}
	function getCalloutPosition(dir, callout){
		if(!tooltip){
			return false;
		}
		var pos = {};
		callout.removeAttr('class').attr('class', 'ui-ztooltip-callout ui-ztooltip-callout-'+calloutDirection[dir]);  //No I18N
		var calloutWidth = callout.outerWidth();
		var calloutHeight = callout.outerHeight();
		var baseEleWidth = tempTooltipEle.width();
		var baseEleHeight = tempTooltipEle.height();
		switch(dir){
			case 'north':
				pos = {'left':((baseEleWidth/2)-(calloutWidth/2))+'px', 'top':'-'+(calloutHeight-1)+'px'};	//No I18N
				break;
			case 'west':
				pos = {'left':'-'+(calloutWidth-1)+'px', 'top':((baseEleHeight/2)-(calloutHeight/2))+'px'};	//No I18N
				break;
			case 'east':
				pos = {'left':(baseEleWidth-1)+'px', 'top':((baseEleHeight/2)-(calloutHeight/2))+'px'};	//No I18N
				break;
			case 'south':
				pos = {'left':((baseEleWidth/2)-(calloutWidth/2))+'px', 'top':(baseEleHeight-1)+'px'};	//No I18N
				break;
 			case 'northeast': 	//No I18N
				pos = {'left':(baseEleWidth-(calloutWidth*2))+'px', 'top':'-'+(calloutHeight-1)+'px'};	//No I18N
				break;
			case 'northwest':
				pos = {'left':calloutWidth+'px', 'top':'-'+(calloutHeight-1)+'px'};	//No I18N
				break;
			case 'southwest':
				pos = {'left':calloutWidth+'px', 'top':(baseEleHeight-1)+'px'};	//No I18N
				break;
			case 'southeast':
				pos = {'left':(baseEleWidth-(calloutWidth*2))+'px', 'top':(baseEleHeight-1)+'px'};	//No I18N
				break;
			default:
				callout.addClass('ui-ztooltip-callout-top');
				pos = {'left':calloutWidth+'px', 'top':'-'+(calloutHeight-1)+'px'};	//No I18N
		}
		return pos
	}
	var tooltipPositions = {
		north: function (ev){
			return {
				'left': (ev.pageX - (ev.tooltipWidth/2)),	//No I18N
				'top': (ev.pageY + (ev.calloutHeight+ev._OFFSET))	//No I18N
			};
		},
		west: function(ev){
			return {
				'left': (ev.pageX + (ev.calloutWidth+ev._OFFSET)),	//No I18N
				'top': (ev.pageY - ((ev.tooltipHeight/2)))	//No I18N
			};
		},
		east: function(ev){
			return {
				'left': ((ev.pageX - (ev.calloutWidth+ev._OFFSET)) - ev.tooltipWidth),	//No I18N
				'top': (ev.pageY - ((ev.tooltipHeight/2)))	//No I18N
			};
		},
		south: function(ev){
			return {
				'left': (ev.pageX - (ev.tooltipWidth/2)),	//No I18N
				'top': ((ev.pageY - (ev.calloutHeight+ev._OFFSET))-ev.tooltipHeight)	//No I18N
			};
		},
		northeast: function(ev){
			return {
				'left': (ev.pageX - (ev.tooltipWidth-(ev.calloutWidth+(ev.calloutWidth/2)))),	//No I18N
				'top': (ev.pageY + ev.calloutHeight+ev._OFFSET)	//No I18N
			};
		},
		northwest: function(ev){
			return {
				'left': (ev.pageX - (ev.calloutWidth+(ev.calloutWidth/2))),	//No I18N
				'top': (ev.pageY + ev.calloutHeight+ev._OFFSET)	//No I18N
			};
		},
		southwest: function(ev){
			return {
				'left': (ev.pageX - (ev.calloutWidth+(ev.calloutWidth/2))),	//No I18N
				'top': ((ev.pageY - (ev.calloutHeight+ev._OFFSET))-ev.tooltipHeight)	//No I18N
			};
		},
		southeast: function(ev){
			return {
				'left': (ev.pageX - (ev.tooltipWidth-(ev.calloutWidth+(ev.calloutWidth/2)))),	//No I18N
				'top':((ev.pageY - (ev.calloutHeight+ev._OFFSET))-ev.tooltipHeight)	//No I18N
			};
		},
		defaultFn: function(ev){
			return tooltipPositions.north(ev, ev.calloutHeight, ev.calloutWidth);
		}
	}
	function getTooltipPosition(ev){
		ev.tooltipWidth = tooltip.outerWidth();
		ev.tooltipHeight = tooltip.height();
		var position = {};
		ev._OFFSET = 10;
		if(!tooltip){
			return false;
		}
		var callout = tooltip.find('.ui-ztooltip-callout');
		ev.calloutWidth = callout.outerWidth();
		ev.calloutHeight = callout.outerHeight();
		var fn = tooltipPositions[options.callout];
		if(!fn){
			fn = tooltipPositions["defaultFn"];
		}
		return fn(ev);
	}

	function removeTip(ev){
		if(tooltip){
			if(options.contentType === 'html' && options.isContentElementId){
				$(tooltip).find('#'+options.content).appendTo('body').hide();
			}
			$(tooltip).remove();
			tooltip = undefined;
		}
	}
	function fixTooltip(ev, tooltipEle, toolTipPos, ele){
		if(tooltipEle && toolTipPos){
			var offsetTop = toolTipPos.top - this._documentEle.scrollTop();
			var offsetLeft = toolTipPos.left - this._documentEle.scrollLeft();
			var t_left = offsetLeft + tooltipEle.width();
			var t_top = offsetTop + tooltipEle.height();
			var dir = undefined, window_space = 5, offset_Top;

			if(t_left >= this._windowWidth){ 
				toolTipPos.left = this._windowWidth - (tooltipEle.outerWidth(true)+window_space); //5px space added to avoid cross browser width problem. Tooltip broken in Firefox, IE.				
				if((toolTipPos.left+tooltipEle.width()) - ele.offset().left <= 15){
					options.callout = 'east';	//No i18n					
				}
				dir = options.callout;
			}
			else if(offsetLeft < 0){
				toolTipPos.left = toolTipPos.left+window_space-(offsetLeft);				
				if(((ele.offset().left + ele.width()) - this._documentEle.scrollLeft()) <= 20){
					options.callout = 'west';	//No i18n
				}
				dir = options.callout;
			}
			if(t_top >= this._windowEle.height()){
				toolTipPos.top = (ele.offset().top-tooltipEle.outerHeight())-9;
				dir = 'south';	//No i18n
				offset_Top = offsetTop;
			}
			else if(offsetTop < 0){
				toolTipPos.top = (ele.offset().top+ele.outerHeight())+9;
				dir = 'north';	//No i18n
				offset_Top = offsetTop;
			}			
			if(dir){
				var callout = tooltipEle.find('.ui-ztooltip-callout');	//No I18N
				alterTooltip(ev, dir, callout, tooltipEle, toolTipPos, offsetLeft, offset_Top);
			}			
		}
		return toolTipPos;	
	}
	function alterTooltip(ev, dir, calloutEle, tooltipEle, toolTipPos, offsetLeft,offset_Top){
		var callout = options.callout? options.callout: dir;
		switch(dir){
			case 'north':
				callout = (callout == 'south')?
						'north': (callout == 'southeast')?
					       		'northeast': (callout == 'southwest')?
						       		'northwest':callout; 
				break;
			case 'south':
				callout = (callout == 'north')?
						'south': (callout == 'northeast')?
					       		'southeast': (callout == 'northwest')?
						       		'southwest':callout;
				break;
			case 'west':
				callout = (callout == 'east')? 'west': callout;
				break;
			case 'east':
				callout = (callout == 'west')? 'east': callout;
				break;
		}
		return positionTooltip(ev, callout, calloutEle, tooltipEle, dir, toolTipPos, offsetLeft,offset_Top);
	}
	function positionTooltip(ev, callout, calloutEle, tooltipEle, dir, toolTipPos,offsetLeft,offset_Top){
		if(calloutEle){
			options.callout = callout;
			var position = calloutEle.position();
			if(offset_Top){
				position = getCalloutPosition(callout, calloutEle);
				if(!position){
					position = calloutEle.position();
				}
			}
			if(callout === 'east'||callout === 'west'){	//No I18N
				position = getCalloutPosition(callout, calloutEle);
				toolTipPos = adjustTooltipPosition(toolTipPos, $(ev.target), tooltipEle,dir);
			}
			else if(callout === 'northwest'|| callout === 'northeast' ||callout === 'southwest' || callout === 'southeast'){	//No I18N
				position = getCalloutPosition(callout, calloutEle);
			}
			else if(offsetLeft < 0){
				position.left = ((tooltipEle.width()/2-calloutEle.outerWidth()/2)+(offsetLeft)-5);
				if(position.left <= 10){
					position.left = 10;
				}
			}
			else{
				position.left = ((tooltipEle.width()/2-calloutEle.outerWidth()/2)+(offsetLeft-toolTipPos.left));
				if(tooltipEle.width() - position.left <= 20){
					position.left = tooltipEle.width()-20;
				}
			}
			if(position){
				calloutEle.css(position);
			}
		}
		return toolTipPos;
	}
	function moveTip(ev, ele){
		var tooltipEle  = $(tooltip);
		var tooltipWidth = tooltipEle.width();
		var tooltipHeight = tooltipEle.height();
		var toolTipPos = (options.callout && !options.ajaxContent)?
					      getTooltipPosition(ev): {'left': ((ev.pageX+5)), 'top': (ev.pageY+5)};	//No I18N
		toolTipPos = fixTooltip(ev, tooltip, toolTipPos, ele);
		if((tooltipEle.width() + parseInt(toolTipPos.left) ) > this._windowWidth){
			tooltipEle.width(this._windowWidth - (parseInt(toolTipPos.left) + 50) );
		}
		tooltipEle.css(toolTipPos);
	}
	$.fn.ztooltip = function(_options){
		$.ZtoolTip(this, _options);
	}
});