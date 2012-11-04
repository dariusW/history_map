
(function($) {

	$.fn.historyMap = function(options) {

		//APPLICATION SETTING
		var setting = $.extend({
			key : 'AIzaSyCaZbAvvE0z0Go_SOeivdAxwakkrXC8GVU',
			map_canvas_id : 'map_canvas',
			pusher_key : 'b2c8a1f93ceea7e108b7'

		}, options);

		var mapOptions = {

		};

		//TODO: enable cache for release
		$.ajaxSetup({
			url : 'stories/',
			cache : false,

		});
		//APLICATION SETTING

		//variables init
		var map;
		var mapCanvas;
		var pusher;
		var public_channel;
		var private_channel;
		//main html space HTML object
		var infoPad;
		var context;
		var container;
		//variables init

		if (!Array.prototype.forEach) {
			Array.prototype.forEach = function(fun /*, thisp*/) {
				var len = this.length;
				if ( typeof fun != "function")
					throw new TypeError();

				var thisp = arguments[1];
				for (var i = 0; i < len; i++) {
					if ( i in this)
						fun.call(thisp, this[i], i, this);
				}
			};
		}

		//initialization
		init = function() {
			container = new Object();
			container.page = $('#pageContainer');
			container.menu = $('');
			container.inner = $('#innerMenuContainer');
			container.map = $('#display');
			container.window = $(window);
			container.page.css({
			});
			container.page.height(container.window.height() - 40 - 40);
			container.menu.basicWidth = 320;
			container.menu.width(container.menu.basicWidth);
			container.menu.css({
			});
			container.inner.width(container.menu.basicWidth - 20);
			container.inner.css({
			})
			container.map.css({
			});
			container.map.width(container.page.width() - container.menu.basicWidth);

			mapCanvas = document.getElementById(setting.map_canvas_id);
			mapCanvas.$ = $(mapCanvas);
			mapCanvas.map = document.createElement('div');
			mapCanvas.$map = $(mapCanvas.map);
			mapCanvas.$map.width(mapCanvas.$.width());
			mapCanvas.$map.height(mapCanvas.$.height());
			mapCanvas.$map.css({
			});
			mapCanvas.$.append(mapCanvas.$map)
			mapCanvas.infoPad = document.createElement('div');
			mapCanvas.$infoPad = $(mapCanvas.infoPad);
			mapCanvas.$infoPad.width(mapCanvas.$.width());
			mapCanvas.$infoPad.height(mapCanvas.$.height());
			mapCanvas.$infoPad.css({
			})
			mapCanvas.$.append(mapCanvas.$infoPad)

			mapCanvas.timeLine = document.createElement('div');
			mapCanvas.$timeLine = $(mapCanvas.timeLine);
			mapCanvas.$timeLine.css({
				'height' : '96%',
				'margin' : '2%',
				'background' : '#dedede',
				'position' : 'absolute',
				'top' : '0',
				'right' : '0',
				'z-index' : '1000'
			});
			mapCanvas.$timeLine.width(20);
			mapCanvas.$.append(mapCanvas.$timeLine);

			infoPad = mapCanvas.$infoPad;
			infoPad.f = new Object();
			map = new google.maps.Map(mapCanvas.map, mapOptions);
			
		}
		context = new Object();
		//initialization

		//init();
		

		//APP RESiZE
		// $(window).resize(function() {
			// container.page.height($(this).height() - 40 - 40);
			// container.map.width(container.page.width() - container.menu.basicWidth);
		// });
		// //

		//TODO: prepera a simple list of stories

		//QUERY CONTEXT
		// context.getList = function() {
			// jqXHR = $.ajax().done(function(json) {
				// json.forEach(function(item, jsonIndex, array) {
					// $('#list-stories').find('ul').append(function(index, html) {
						// element = document.createElement('li');
						// $(element).append('<a  href="#"><div class="story-item"><span class="story-item-name">' + item.full_title + '</span><span class="story-item-date">' + item.bottom_boundry.years + ' - ' + item.top_boundry.years + '</span></div></a>').click(function() {
							// context.loadStory(item);
						// });
						// return element;
					// });
				// });
			// });
		// }
// 
		// context.loadStory = function(item) {
			// $('.fullCanvasWindow .loadIndicator').fadeIn();
			// jqXHR = $.ajax({
				// data : {
					// id : item.id
				// }
			// }).done(function(data) {
				// $('.fullCanvasWindow .loadIndicator').fadeOut().attr('src', '');
				// $('.fullCanvasWindow').fadeOut();
			// });
		// };
// 
		// context.simpleLoad = function(url, callback, setting) {
// 
			// jqXHR = $.ajax(url, $.extend({
				// accepts : "text/html"
			// }, setting)).on;
			// $.load(url, function(responceText, status, jqXHR) {
				// callback(responseText, textStatus, jqXHR)
			// });
		// }
		//QUERY CONTEXT

		//infoPad handler
		// infoPad.f.welcome = function() {
			// infoPad.load('contents/welcome', {}, function(responseText, textStatus, XMLHttpRequest) {
// 
			// });
		// }
		//infoPad handler

		//MAIN
		// context.getList();
		// infoPad.f.welcome();


		//return this;
		//MAIN

	}
	
})(jQuery);

