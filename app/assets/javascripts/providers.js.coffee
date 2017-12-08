###global $:false###
'use strict'

 




getProviderAddress = -> 
	$.ajax
		url: "/providers/getprovideraddress"
		type: "GET"    
		data: { id: $("#provider_id").val() }
		dataType: 'json'
		success: (data) ->
			zoom = undefined
			center = undefined
			$("#latitude").val data.location[1]
			$("#longitude").val data.location[0]      
			$("#business_address").val data.address
			addresspickerMap = $("#business_address").addresspicker(
				# regionBias: "tr"
				updateCallback: showCallback
				# componentsFilter: "country:TR"
				elements:
					map: "#providermap"
					lat: "#latitude"
					lng: "#longitude"
				mapOptions: 
					zoom: 13
					center: new google.maps.LatLng($("#latitude").val(),$("#longitude").val())
					styles: [
						featureType: "landscape"
						stylers: [hue: "#00dd00"]
					,
						featureType: "road"
						stylers: [hue: "#dd0000"]
					,
						featureType: "water"
						stylers: [hue: "#000040"]
					,
						featureType: "poi.park"
						stylers: [visibility: "off"]
					,
						featureType: "road.arterial"
						stylers: [hue: "#ffff00"]
					,
						featureType: "road.local"
						stylers: [visibility: "off"]
					]           
					scrollwheel: true
					mapTypeId: google.maps.MapTypeId.ROADMAP 
			)
			gmarker = addresspickerMap.addresspicker("marker")
			gmap = addresspickerMap.addresspicker( "map");
			gmarker.setVisible true
			addresspickerMap.addresspicker "updatePosition"
			$("#reverseGeocode").change ->
				$("#addresspicker_map").addresspicker "option", "reverseGeocode", ($(this).val() is "true")
			showCallback = (geocodeResult, parsedGeocodeResult) ->
				$("#callback_result").text JSON.stringify(parsedGeocodeResult, null, 4)  
		failure: ->
			alert "Unsuccessful"  
 
initProviderForm = ->  
	$("#office_phone").setMask() 
	$("#district").remoteChained
		parents: "#province"
		url: "/district.json"
		clear: true
		loading: "Yükleniyor..."

	$("#neigbor").remoteChained
		parents: "#district"
		url: "/neigbor.json"
		clear: true
		loading: "Yükleniyor..."

	$("#local").remoteChained
		parents: "#neigbor"
		url: "/local.json"
		clear: true
		loading: "Yükleniyor..."

	typingTimer = undefined 
	doneTypingInterval = 1000
	$("#no_door").keyup ->
		clearTimeout typingTimer
		if $("#no_door").val
			typingTimer = setTimeout(->
				local = undefined
				if $('#neigbor').val() != null && $('#local').val() !=null
					local = $('#local').val() 
				$("#business_address").val(local + ', ' + $('#street').val() + ' No:' + $('#no_door').val() + ', ' + $('#district').val() + '/' + $('#province').val())
				$("#business_address").focus()
				event = jQuery.Event("keypress")
				event.which = 40
				event.keyCode = 40 
				$("#business_address").trigger event
				$("#business_address").trigger event
				return 
			, doneTypingInterval)
		return
 
	$("#tree").fancytree
		activeVisible: true  
		aria: false  
		autoActivate: true 
		#autoCollapse: true  
		autoScroll: true  
		clickFolderMode: 3  
		checkbox: true  
		debugLevel: 0  
		disabled: false  
		generateIds: false  
		idPrefix: "ft_"  
		icons: false  
		keyboard: true  
		keyPathSeparator: "/"  
		minExpandLevel: 1  
		selectMode: 3  
		tabbable: true  
		titlesTabbable: true  
		strings: 
			loading: "yükleniyor..."
			loadError: "yükleme başarısız"	
		extensions: [
			"filter"
			"glyph"
		]
		filter:
			mode: "dim"
		source:
			url: "/categories/get_allcategories"
			data:
				provider_id: $("#provider_id").val()
			cache: false
		onPostInit: ->
			$.map @getSelectedNodes(), (node) ->
				node.makeVisible()
				return 
			return
		select: (e, data) ->
			selKeys = $.map(data.tree.getSelectedNodes(), (node) ->
				node.key
			)
			$("#echoSelection3").text selKeys.join(", ")
			selRootNodes = data.tree.getSelectedNodes(true)
			selRootKeys = $.map(selRootNodes, (node) ->
				node.key
			)
			$("#echoSelectionRootKeys3").text selRootKeys.join(", ")
			return
		click: (event, data) ->
			node = data.node
			tt = $.ui.fancytree.getEventTargetType(event.originalEvent)
			if tt is "checkbox"
				data.node.toggleExpanded()
				c1 = data.node.getChildren()
				if c1 != null
					$.each c1, (index, v1) ->
						v1.toggleExpanded()
						c2 = v1.getChildren()
						if c2 != null
							$.each c2, (index, v2) ->
								v2.toggleExpanded()
								c3 = v2.getChildren()
								if c3 != null
									$.each c3, (index, v3) ->
										v3.toggleExpanded()
										c4 = v3.getChildren()
										if c4 != null
											$.each c4, (index, v4) ->
												v4.toggleExpanded()
										else
											if v3.extraClasses is "fancytree-selected"
												 v3.extraClasses = ""
											else
												v3.extraClasses = "fancytree-selected"
										return
								else
									if v2.extraClasses is "fancytree-selected"
										 v2.extraClasses = ""
									else
										v2.extraClasses = "fancytree-selected"
								return
						else
							if v1.extraClasses is "fancytree-selected"
								 v1.extraClasses = ""
							else
								v1.extraClasses = "fancytree-selected"
						return
				else
					if data.node.extraClasses is "fancytree-selected"
						 data.node.extraClasses = ""
					else
						data.node.extraClasses = "fancytree-selected"
				return
 
	rootnode = undefined
	tree = $("#tree").fancytree("getTree")
	$("input[name=search]").keyup((e) ->
		n = undefined
		leavesOnly = $("#leavesOnly").is(":checked")
		match = $(this).val()
		if e and e.which is $.ui.keyCode.ESCAPE or $.trim(match) is ""
			$("button#btnResetSearch").click()
			return
		if $("#regex").is(":checked")
			n = tree.filterNodes((node) ->
				new RegExp(match, "i").test node.title
			, leavesOnly)
		else
			n = tree.filterNodes(match, leavesOnly) 
		$("button#btnResetSearch").attr "disabled", false
		$("span#matches").text "(" + n + " eşleşme bulundu. Siyah kategorilere tıklayınız.)"
		return false
	).focus()
	$("button#btnResetSearch").click((e) ->
		$("input[name=search]").val ""
		$("span#matches").text ""
		tree.clearFilter()
		return false
	).attr "disabled", true
	$("input#hideMode").change((e) ->
		tree.options.filter.mode = (if $(this).is(":checked") then "hide" else "dimm")
		tree.clearFilter()
		$("input[name=search]").keyup()
		return
	).prop "checked", true
	$("input#leavesOnly").change (e) ->
		
		# tree.options.filter.leavesOnly = $(this).is(":checked");
		tree.clearFilter()
		$("input[name=search]").keyup()
		return

	$("input#regex").change (e) ->
		tree.clearFilter()
		$("input[name=search]").keyup()
		return 

	businessHoursManager = $("#business_hours_selector").businessHours()
	$("#business_hours_selector").businessHours
		operationTime: 
			if $("#business_hours").val() != "null"
				JSON.parse $("#business_hours").val()
		postInit: ->
			$(".operationTimeFrom, .operationTimeTill").timepicker
				timeFormat: "H:i"
				step: 30 
			return  
		dayTmpl: "<div class=\"dayContainer\" style=\"width: 80px;\">" + "<div data-original-title=\"\" class=\"colorBox\"><input type=\"checkbox\" class=\"invisible operationState\"></div>" + "<div class=\"weekday\"></div>" + "<div class=\"operationDayTimeContainer\">" + "<div class=\"operationTime input-group\"><span class=\"input-group-addon\"><i class=\"fa fa-sun-o\"></i></span><input type=\"text\" name=\"startTime\" class=\"mini-time form-control operationTimeFrom\" value=\"\"></div>" + "<div class=\"operationTime input-group\"><span class=\"input-group-addon\"><i class=\"fa fa-moon-o\"></i></span><input type=\"text\" name=\"endTime\" class=\"mini-time form-control operationTimeTill\" value=\"\"></div>" + "</div></div>"
	
	$.each $(".select2-container"), (i, n) ->
		$(n).next().show().fadeTo(0, 0).height("0px").css "left", "auto" # make the original select visible for validation engine and hidden for us
		$(n).prepend $(n).next()
		$(n).delay(500).queue ->
			#$(this).removeClass "validate[required]" #remove the class name from select2 container(div), so that validation engine dose not validate it
			$(this).dequeue()  

	$("#reg1_form").validate
		ignore: null
		errorClass: "error_class"
		rules:
			"provider_image2":
				extension: "png|bmp|jpeg|tif|jpg"
			"provider_image3":
				extension: "png|bmp|jpeg|tif|jpg"
			"provider_image4":
				extension: "png|bmp|jpeg|tif|jpg"
			"provider_image5":
				extension: "png|bmp|jpeg|tif|jpg"
			"provider_image6":
				extension: "png|bmp|jpeg|tif|jpg"
			"certificate_image1":
				extension: "png|bmp|jpeg|tif|jpg"
			"certificate_image2":
				extension: "png|bmp|jpeg|tif|jpg"
			"certificate_image3":
				extension: "png|bmp|jpeg|tif|jpg"
			"certificate_image4":
				extension: "png|bmp|jpeg|tif|jpg"
			"provider[business_address]":
				required: true
			"provider[business_phone]":
				required: true
				exactlength: 14
				remote: "/providers/check_phone" 
			"provider[business_email]":
				required: true
				email: true
				remote: "/providers/check_email" 
			"provider[officialname]":
				required: true
				minlength: 5 
				maxlength: 50
			"provider[business_description]":
				required: true
				minlength: 20
				maxlength: 500
			"neigbor":
				required: true
			"district":
				required: true
			"no_door":
				required: true
			"street":
				required: true
		messages:
			"neigbor":
				required: I18n.t "provider.address.neigbor"
			"district":
				required: I18n.t "provider.address.district"
			"no_door":
				required: I18n.t "provider.address.no_door"
			"street":
				required: I18n.t "provider.address.street"
			"provider_image2":
				extension: I18n.t "provider.provider_image.file_type"
			"provider_imag3":
				extension: I18n.t "provider.provider_image.file_type"
			"provider_image4":
				extension: I18n.t "provider.provider_image.file_type"
			"provider_image5":
				extension: I18n.t "provider.provider_image.file_type"
			"provider_image6":
				extension: I18n.t "provider.provider_image.file_type"
			"certificate_image1":
				extension: I18n.t "provider.provider_image.file_type"
			"certificate_image2":
				extension: I18n.t "provider.provider_image.file_type"
			"certificate_image3":
				extension: I18n.t "provider.provider_image.file_type"
			"certificate_image4":
				extension: I18n.t "provider.provider_image.file_type"
			"provider[business_address]":
				required: I18n.t "provider.business_address.presence"
			"provider[business_phone]":
				required: I18n.t "provider.business_phone.blank" 
				remote:  I18n.t "provider.business_phone.uniqueness"
				exactlength:   I18n.t "provider.business_phone.length"
			"provider[business_email]":
				required: I18n.t "provider.business_email.blank" 
				remote:  I18n.t "provider.business_email.uniqueness"
				email:   I18n.t "provider.business_email.invalid"
			"provider[officialname]":
				required: I18n.t "provider.officialname.presence" 
				minlength: I18n.t "provider.officialname.too_short" 
				maxlength: I18n.t "provider.officialname.too_long" 
			"provider[business_description]":
				required: I18n.t "provider.business_description.blank" 
				minlength: jQuery.validator.format(I18n.t "provider.business_description.too_short" )
				maxlength: jQuery.validator.format( I18n.t "provider.business_description.too_long" )
				 
	$("#provider_business_type").bind "change", -> 
		if $(this).val() is "0" or $(this).val() is "1"
			$("#taxpersonal").show()
			$("#taxbusiness").hide()
			$("#provider_tax_business_name").rules "remove"
			$("#provider_tax_office").rules "remove"
			$("#provider_tax_number").rules "remove"
			$("#provider_tax_pin").rules "add",
				required: true
				remote: "/providers/check_pin" 
				exactlength: 11        
				messages:
					required: I18n.t "provider.tax_pin.blank" 
					remote: I18n.t "provider.tax_pin.uniqueness"  
					length: I18n.t "provider.tax_pin.wrong_length" 
			$("#provider_tax_fullname").rules "add",
				required: true  
				messages:
					required: I18n.t "provider.tax_fullname.blank" 
		else
			$("#taxpersonal").hide()
			$("#taxbusiness").show()
			$("#provider_tax_pin").rules "remove"
			$("#provider_tax_fullname").rules "remove"
			$("#provider_tax_office").rules "add",
				required: true
				messages:
					required: I18n.t "provider.tax_office.blank"
			$("#provider_tax_number").rules "add",
				required: true
				remote: "/providers/check_tax_number" 
				exactlength: 10        
				messages:
					required: I18n.t "provider.tax_number.blank" 
					remote: I18n.t "provider.tax_number.uniqueness"  
					length: I18n.t "provider.tax_number.wrong_length"  
			$("#provider_tax_business_name").rules "add",
				required: true
				messages:
					required: I18n.t "provider.tax_business_name.blank"
	$('#provider_business_type').trigger "change"  
	
	$("#form1_submit").click  ->        
		$("#business_hours").val JSON.stringify(businessHoursManager.serialize())
		phonetext = $("#contact_phone").val().replace("(", "").replace(") ", "")
		testStr = $('#current_phones').val() 
		tree = $("#tree").fancytree("getTree")
		d = tree.toDict(true)
		selected_nodes = tree.getSelectedNodes()
		$('#categories').val(JSON.stringify(d)) 
		if ($("#provider_image1").val().length is 0) && ($("#reg1_form").attr("edit") is "false")
			$("#provider_image1").rules "add",
				required: true  
				extension: "png|bmp|jpeg|tif|jpg"  
				messages:
					required:  I18n.t "provider.provider_image.blank"  
					extension: I18n.t "provider.provider_image.file_type"
		else
			$("#provider_image1").rules "remove","required"
			$("#provider_image1").rules "add",
				extension: "png|bmp|jpeg|tif|jpg"  
				messages:
					extension: I18n.t "provider.provider_image.file_type"
		
		if selected_nodes.length is 0 
		  $("#search_tree").rules "add",
		    required: true  
		    messages:
		      required:  I18n.t "provider.category.blank"
		else
		  $("#search_tree").rules "remove","required"

		if $("#reg1_form").valid() is true 
			# if (($("#hidden_phone").val() != phonetext) && (testStr.indexOf(phonetext) is -1)) || $("#contact_phone").val().length is 0
			# 	$("#phone-verification").modal "show"
			# 	$("#verification_phone").val $("#contact_phone").val()
			# 	$("#general-error").hide()
			# 	return false
			# else 
			$("#form1_submit").prop "disabled", true 
			$("#form1_submit").prop "value", I18n.t "shared.navbar.pleasewait"  
			$("#general-error").hide()      
			$("#reg1_form").submit() 
		else
			$("#general-error").show()
			return false 
		
	getProviderAddress()
	$("#provider_tax_pin").setMask()
	$("#provider_tax_number").setMask() 

initProviderPrices = ->
	$('#username').editable()
	$("#tableity").filterable editableOptions:
		title: I18n.t("javascript.enter_keyword")
	$(".discount").tooltip()
	$(".market_prices").tooltip()
	$(".price").tooltip()
	$(".pricevalue").setMask()
	$(".discountvalue").setMask()
	$(".multiselect").multiselect()
	$('#my_prices').filterable({editableOptions: {"title": I18n.t('javascript.enter_keyword')}});


initProviderShow = -> 
	$.ajax(
		url: "/activities/get_provider_counts"
		type: "GET"
		data:
			id: $("#provider_id").val()
		dataType: "json"
		).success (data) -> 
		moment.lang "tr"
		calendar = new CalHeatMap()
		calendar.init
			itemSelector: "#example-g"
			data: data
			start: new Date(2014, 1)
			domain: "month"
			subDomain: "day"
			range: 7
			cellSize: 15
			cellPadding: 5
			domainGutter: 20
			displayScale: false
			previousSelector: "#example-g-PreviousDomain-selector"
			nextSelector: "#example-g-NextDomain-selector"
			domainLabelFormat: (date) ->
				moment(date).format("MMMM")
			subDomainDateFormat: (date) ->
				moment(date).format "LL"
			subDomainTitleFormat:
				empty: "{date} tarihinde hiç faaliyeti yok"
				filled: "{date} tarihinde {count} faaliyeti var"
			onClick: (date) ->
				$.ajax
					type: "GET"
					url: "/activities/get_activity"
					data: { id: $("#provider_id").val(), selected: date}
					success: (data) ->
						text1= ""
						text2 =""
						text3 = ""
						if data.selected > 0
							text1 = data.selected + " " +I18n.t "shared.navbar.selected"
						if data.returned > 0
							text2 = data.returned + " " +I18n.t "shared.navbar.returned"
						if data.done > 0
							text3 = data.done + " " + I18n.t "shared.navbar.done"
						if text1.length > 0
							$("#onClick-placeholder").html text1 + "<br/>" + text2 + "<br/>" + text3
							$("#onClick-placeholder").show()
						else
							$("#onClick-placeholder").html ""
							$("#onClick-placeholder").hide()              
					error: (data) ->
							return
				return
			legend: [
				1
				3
				5
			]
			legendColors: [
				"#ecf5e2"
				"#232181"
			]
	$(".ratingstars").jRating
		isDisabled: true
		step: true
		rateMax: 5
		length: 5
		decimalLength: 0
	return
 



# jQuery Turbolinks
$ ->  
	if $('#taxbusiness')[0]?
		initProviderForm()
	if $('#provider_profile').length > 0
		initProviderShow()
	if $('#my_prices').length > 0
		initProviderPrices()
 

 