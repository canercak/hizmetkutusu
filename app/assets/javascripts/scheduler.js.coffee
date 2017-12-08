###global $:false###
'use strict' 
 
loadSchedulerData = ->  
	start = new Date()
	end = new Date()
	end.setMonth (end.getMonth() + 2)
	scheduler.config.cascade_event_display = true
	scheduler.config.cascade_event_count = 10     
	scheduler.config.cascade_event_margin = 30  
	scheduler.config.xml_date= "%d-%m-%Y %H:%i" 
	scheduler.config.load_date = "%d-%m-%Y"
	scheduler.config.start_on_monday = true
	scheduler.config.multi_day = true
	scheduler.config.multi_day_height_limit = 30
	scheduler.config.prevent_cache = true 
	scheduler.config.time_step  = 60
	scheduler.config.fix_tab_position = false 
	scheduler.config.touch = true  
	scheduler.config.mark_now = false 
	scheduler.config.select = false
	scheduler.config.details_on_dblclick = false
	scheduler.config.dblclick_create = false
	scheduler.config.first_hour = 9
	scheduler.config.last_hour = 18
	scheduler.config.hour_size_px = 88
	scheduler.locale.labels.map_tab = "İş Listesi";
	scheduler.config.map_start = start 
	scheduler.config.map_end = end
	scheduler.locale.labels.section_location = "Location" 
	scheduler.xy.map_date_width = 180 
	scheduler.xy.map_description_width = 400 
	scheduler.config.lightbox.sections=[    
			{name:"description", height:50,map_to:"text", type:"textarea", focus:true},
			{name:"location", height:43, map_to:"event_location", type:"textarea"},
			{name:"time", height:72, type:"time", map_to:"auto"}    
	]
	scheduler.config.update_render = true 
	scheduler.attachEvent "onTemplatesReady", ->
		scheduler.templates.event_text = (start, end, event) ->
			 event.variation_names + " - " +event.text 
			return 

	scheduler.attachEvent "onEmptyClick", (date) ->
		$.ajax
			url: "/reservations/check_blocked"
			type: "GET"
			data:
				provider_id: $("#provider_id").val()
				category_id: $("#provider_services").val()
				staff_id: $("#personel_services").val()
				date: date 
			dataType: "json"
			success: (data) ->
				scheduler.showLightbox data , date
				return 
		return 

	scheduler.attachEvent "onClick", (id) ->
	  scheduler.showLightbox(id)   
  
	scheduler.attachEvent "onXLE", -> 
		scheduler.deleteMarkedTimespan()
		$.ajax 
			url: "/reservations/get_user_blocks"
			type: "GET"
			data: 
				provider_id: $("#provider_id").val()
			dataType: 'json'
			success: (data) -> 
				if data.length > 0
					$.each data, (index, value) ->
						scheduler.blockTime
							start_date: new Date(value[0])
							end_date: new Date(value[1])
							html:"<b>"+ value[2]+"</b>"
							type: "dhx_time_block"
						scheduler.updateView() 
				return false 

initModal = -> 

	$("#event-modal").on "hidden.bs.modal", ->
		clear_event_modal()
		$("#provider_services").trigger "change" 
 
	$("#event_service").on "select2-selecting", (e) ->
		$.ajax
			url: "/reservations/update_price"
			type: "GET"    
			data:
				current_val: $("#event_service").val() 
				selected_val: e.val
			dataType: 'json'
			success: (data) ->        
				$("#event_service").select2 "val", data
				$.ajax
					url: "/reservations/get_price"
					type: "GET"
					data:
						provider_id:  $("#provider_id").val() 
						price_ids:  $("#event_service").val().split(",") 
					dataType: "json"
					success: (data) ->
						$("#total_price").text(parseFloat(data))
						#update_personel_event($("#event_service").val().split(","))
						return
				return


	$("#event_block").on "select2-selecting", (e) -> 
		$.ajax
			url: "/reservations/manage_blocks"
			type: "GET"    
			data:
				current_val: $("#event_block").val() 
				selected_val: e.val
			dataType: 'json'
			success: (data) ->        
				$("#event_block").select2 "val", data
				update_personel_block($("#event_block").val().split(","))
				return 

	$("#personel_block").on "select2-selecting", (e) -> 
		validate_personel_block(e)

	$("#event_personel").on "select2-selecting", (e) -> 
		validate_personel_block(e) 

	$("#event_block").on "select2-removed", ->
		if $("#event_block").val() is ""
			$("#personel_block").select2
				data: ""
				multiple: true
			$("#personel_block").val("")
			$("#personel_block").select2 "enable", false
		return 

	$("#event_service").on "select2-removed", ->
		if $("#event_service").val() is ""
			$("#event_personel").select2
				data: ""
				multiple: true
			$("#event_personel").val("")
			$("#event_personel").select2 "enable", false
		return 


	$("#event_form").validate
		ignore: null
		errorClass: "error_class"
		rules:
			"event_text":
				required: false
			"event_customers":
				required: true 
			"event_personel":
				required: true 
			"event_service":
				required: true 
 
		messages:
			"event_text":
				required: I18n.t "event.text.blank"
			"event_customers":
				required: I18n.t "event.customer.blank"
			"event_personel":
				required: I18n.t "event.personel.blank"
			"event_service":
				required: I18n.t "event.service.blank"

	$("#event_service").css "width", "70%"
	$("#event_block").css "width", "70%"
	$("#personel_block").css "width", "60%"
	$("#event_customers").css "width", "50%"
	$("#event_personel").css "width", "60%"
	$("#personel_services").css "width", "15%"
	$("#provider_services").css "width", "20%" 
	$("#provider_services").css "margin-left", "16%" 

	prepare_customer_form = ->
		$("#customer_phone").setMask()
		$("#customer_address").prop "disabled", "disabled"
		$("#customer_name").prop "disabled", "disabled"
		$("#customer_name").val('')
		$("#customer_phone").val('')
		$("#customer_email").val('')
		$("#customer_address").val('')

	validate_match_personel = ->
		staff_ids = $("#event_personel").val()
		if $("#event_service").val() is ""
			staff_ids = $("#personel_block").val()
		$.ajax
			url: "/reservations/match_personel"
			type: "GET"    
			data:
				price_ids: $("#event_service").val()
				staff_ids: staff_ids 
				category_ids: $("#event_block").val()
			dataType: 'json'
			success: (data) ->
				if data.event_validate is true 
					if data.personel is false
						validator = $("#event_form").validate ignore: [] 
						validator.showErrors "event_personel": data.category + " hizmeti için personel seçmediniz. Lütfen kontrol ediniz."
						$("label[for='event_personel']").css "color", @errorText
						return false
					else
						$("label[for='event_personel']").remove()
						$.ajax
							url: "/reservations/save"
							type: "POST"    
							data:
								provider_id: $("#provider_id").val()
								date: $("#date1").val()
								start: $("#time1").val()
								end: $("#time2").val()
								customer: $("#event_customers").val() 
								personel: $("#event_personel").val() 
								prices: $("#event_service").val()
								text: $("#event_text").val() 
								type: $("#event_type").val()  
								reservation_id: $("#reservation_id").val()  
							dataType: 'json'
							success: (data) -> 
								$("#event-modal").modal "hide"
								return false
				else
					if data.personel is false
						validator = $("#block_form").validate ignore: [] 
						validator.showErrors "personel_block": data.category + " hizmeti için personel seçmediniz. Lütfen kontrol ediniz."
						$("label[for='personel_block']").css "color", @errorText
						return false
					else
						$("label[for='personel_block']").remove()
						$.ajax
							url: "/blocked_hours/save"
							type: "POST"    
							data:
								provider_id: $("#provider_id").val()
								date: $("#date1").val()
								start: $("#time1").val()
								end: $("#time2").val()
								categories_block: $("#event_block").val() 
								staff_block: $("#personel_block").val() 
								block_reason: $("#block_reason").val()  
								block_id: $("#block_id").val() 
							dataType: 'json'
							success: (data) -> 
								$("#provider_services").trigger "change"
								clear_event_modal()
								$("#event-modal").modal "hide" 
								return false 
 

	$("#new_staff").on "click", ->
		id = $("#provider_id").val()
		$("#staff_added").val("true")
		href = "/fiyat-veren/" + id + "/customers/yeni.1/"
		window.open href
		return false 

	$("#new_customer").on "click", ->
		id = $("#provider_id").val()
		$("#customer_added").val("true")
		href = "/fiyat-veren/" + id + "/customers/yeni.0/"
		window.open href
		return false 

	$("#event_customers").on "select2-open", ->
		if $("#customer_added").val() is "true"
			update_event_customers()
			$("#customer_added").val("false") 

	$("#event_personel").on "select2-open", ->
		if $("#staff_added").val() is "true"
			$("#staff_added").val("false") 
			update_event_personel()
 

 
	$("#save_event").on "click", (e) -> 
		# if confirm("Are you sure you want to delete this?")
		if ($("ul#navtabs li.active a").prop("href").indexOf "pane2") < 0
			if $("#event_form").valid()
				validate_match_personel()			  
		else
			if $("#block_id").val().length > 0 && $("#event_block").val() is ""
				$.ajax
					url: "/reservations/delete_block"
					type: "GET"    
					data:
						block_id: $("#block_id").val() 
					dataType: 'json'
					success: (data) ->
						clear_event_modal()
						$("#event-modal").modal "hide" 
						return false 
			else
				validate_match_personel()

	

 
	prepare_partly_new = ->
		$("#pane1_header").prop "hidden", false
		$("#pane2_header").prop "hidden", false 
		$("a[href=\"#pane1\"]").trigger "click"

	validate_personel_block = (e)->
		$.ajax
			url: "/reservations/check_block_valid"
			type: "GET"    
			data:
				provider_id: $("#provider_id").val() 
				date: $("#date1").val()
				start: $("#time1").val()
				end: $("#time2").val()
				block_id: $("#block_id").val() 
				reservation_id: $("#reservation_id").val() 
				category_ids: $("#event_block").val()
				price_ids: $("#event_service").val()
				event_staff: $("#event_personel").val()
				block_staff: $("#personel_block").val()
				selected_val: e.val
			dataType: 'json'
			success: (data) ->
				event_b = true
				if $("#event_service").val() is ""
					event_b = false

				if event_b is false 
					if data.invalid is ""
						$("label[for='personel_block']").remove()
					else
						validator = $("#block_form").validate ignore: []  
						new_data = $.grep($("#personel_block").select2("data"), (value) ->
							value["id"] isnt e.val
						)
						$("#personel_block").select2 "data", new_data 
						if data.invalid is "block"
							validator.showErrors "personel_block": "Seçtiğiniz zaman aralığında " + data.invalid_title+ " hizmeti için " + data.invalid_name + " adlı personelin kapanmış alanı var. Lütfen kontrol ediniz."
						else if data.invalid is "event"
							validator.showErrors "personel_block": "Seçtiğiniz zaman aralığında " + data.invalid_title + " hizmeti için " + data.invalid_name + " adlı personelin randevusu var. Lütfen kontrol ediniz."
						else
							validator.showErrors "personel_block": "Seçtiğiniz zaman aralığında " + data.invalid_title + " hizmeti için " + data.invalid_name + " adlı personelin kapanmış alanı ve randevusu var. Lütfen kontrol ediniz."
						$("label[for='personel_block']").css "color", @errorText
				else
					if data.invalid is ""
						$("label[for='event_personel']").remove()
					else
						validator = $("#event_form").validate ignore: []  
						new_data = $.grep($("#event_personel").select2("data"), (value) ->
							value["id"] isnt e.val
						)
						$("#event_personel").select2 "data", new_data 
						if data.invalid  is "block"
							validator.showErrors "event_personel": "Seçtiğiniz zaman aralığında " + data.invalid_title + " hizmeti için " + data.invalid_name+ " adlı personelin kapanmış alanı var. Lütfen kontrol ediniz."
						else if data.invalid  is "event"
							validator.showErrors "event_personel": "Seçtiğiniz zaman aralığında " + data.invalid_title + " hizmeti için " + data.invalid_name + " adlı personelin randevusu var. Lütfen kontrol ediniz."
						else
							validator.showErrors "event_personel": "Seçtiğiniz zaman aralığında " + data.invalid_title + " hizmeti için " + data.invalid_name+ " adlı personelin kapanmış alanı ve randevusu var. Lütfen kontrol ediniz."
						$("label[for='event_personel']").css "color", @errorText
				return


	scheduler.showLightbox = (id, date) ->
		clear_event_modal()
		end_date = undefined
		ev = undefined
		start_date = undefined
		$("#event-modal").modal "show"
		ev = scheduler.getEvent(id)
		$('#event_modal').ajaxSpin()
		update_event_service()
		update_event_customers()
		update_event_personel()
		update_event_block() 
		if ( id > 0 || id.lenght > 0 || id[0] != undefined)
			if ev is undefined && id[0].category_ids.length > 0 
				start_date = moment(id[0].start_date)._d
				end_date = moment(id[0].end_date)._d 
				$("a[href=\"#pane2\"]").trigger "click"
				$("#pane1_header").prop "hidden", true
				$("#block_reason").val(id[0].block_reason)
				$("#block_id").val(id[0].block_id) 
				update_personel_block(id[0].category_ids)
				$("#event_block").val(id[0].category_ids)
				$("#personel_block").val(id[0].staff_ids) 
				$("#personel_block").select2 "enable", true
			else if ev is undefined && (id[0].category_ids.length < 0 )
				start_date = moment(id[0].start_date)._d
				end_date = moment(id[0].end_date)._d
				prepare_partly_new()
			else
				prepare_partly_new()
				$.ajax 
					url: "/reservations/load_event"
					type: "GET"
					data: 
						reservation_id: id 
					dataType: 'json'
					success: (data) -> 
						$("#event_service").select2 "val", data[0].prices 
						$("#event_customers").select2 "val", data[0].user_id 
						$("#event_personel").select2 "val", data[0].staff_ids 
						update_event_type(data[0].types)
						if $('#event_type option').length is 1
							$("#save_event").prop "disabled", "disabled"
						$("#event_text").val(data[0].text) 
						$("#reservation_id").val(id)
						$("#pane2_header").prop "hidden", "hidden"
						$("#add_event_text").text "Randevu Düzenle"
						$.ajax
							url: "/reservations/get_price"
							type: "GET"
							data:
								provider_id:  $("#provider_id").val() 
								price_ids:  data[0].prices
							dataType: "json"
							success: (data) ->
								$("#total_price").text(parseFloat(data))
								return
						return 
				$("#event_personel").select2 "enable", true
				start_date = ev.start_date
				end_date = ev.end_date
				# prepare_partly_new()
				# $("#add_event_text").text "Bu Zamana Randevu Ekle"
		else 
			start_date = moment(date)._d
			end_date = moment(date).add(1, "hour")._d
			update_event_type([["Yeni Randevu", 0]])
			$("#event_type").prop "disabled", "disabled"
			$("a[href=#pane1]").tab "show"
 

		$("a[data-toggle=\"tab\"]").on "shown", (e) ->
			clear_event_modal()
			return

		$("#eventsExample .time").timepicker
			showDuration: true
			timeFormat: "H:i"
			minTime: "9:00"
			maxTime: "18:00"

		$("#eventsExample .date").datepicker
			format: "dd.mm.yyyy"
			autoclose: true

		$("#eventsExample").datepair().on("rangeSelected", ->
			$("#eventsExampleStatus").text "Valid range selected"
			return
		).on("rangeIncomplete", ->
			$("#eventsExampleStatus").text "Incomplete range"
			return
		).on "rangeError", ->
			$("#eventsExampleStatus").text "Invalid range"
			return

		$("#time1").timepicker "setTime", start_date
		$("#time2").timepicker "setTime", end_date
		$("#date1").datepicker "setDate", start_date
		return false
 
	clear_event_modal= ->
		$("#event_customers").val('') 
		$("#event_personel").val('') 
		$("#event_service").val('')
		$("#event_block").val('')
		$("#personel_block").val('')
		$("#block_reason").val('')
		$("#event_text").val('') 
		$("#event_type").val(0)  
		$("#event_type").prop "disabled", false
		$("#save_event").prop "disabled", false
		$("#reservation_id").val('') 
		$("#block_id").val('') 
		$("#total_price").text(0) 
		$("#event_service").select2 "data", null
		$("#event_block").select2 "data", null 
		$("#event_customers").select2 "data", null 
		$("#event_personel").select2 "data", null
		$("#event_personel").select2 "enable", false
		$("#personel_block").select2
			multiple: true
			placeholder: "Lütfen seçiniz"
			formatNoMatches: ->
				I18n.t "shared.navbar.no_matches_found"
			formatInputTooShort: (input, min) ->
				I18n.t("shared.navbar.please_select") + " " + (min - input.length) + " " + I18n.t("shared.navbar.more_characters")
			formatSelectionTooBig: (limit) ->
				I18n.t("shared.navbar.you_can_only_select") + " " + limit + " " + I18n.t("shared.navbar.item") + ((if limit is 1 then "" else "s"))
			formatLoadMore: (pageNumber) ->
				I18n.t "shared.navbar.loading_more_results"
			formatSearching: ->
				I18n.t "shared.navbar.searching"
			data: ""
		$("#personel_block").select2 "enable", false
		$("#pane1_header").prop "hidden", false
		$("#pane2_header").prop "hidden", false  
		validEvent = $("#event_form").validate()
		validBlock = $("#block_form").validate()
		validEvent.resetForm()
		validBlock.resetForm() 

	update_event_customers = ->
		$.ajax
			url: "/providers/customer_list"
			type: "GET"    
			data:
				id: $("#provider_id").val()
			dataType: 'json'
			success: (data) ->        
				$("#event_customers").select2
					data: data.data
					placeholder: "Lütfen Hizmet Alan Kişiyi Seçiniz"
					formatNoMatches: ->
						I18n.t "shared.navbar.no_matches_found"
					formatInputTooShort: (input, min) ->
						I18n.t("shared.navbar.please_select") + " " + (min - input.length) + " " + I18n.t("shared.navbar.more_characters")
					formatSelectionTooBig: (limit) ->
						I18n.t("shared.navbar.you_can_only_select") + " " + limit + " " + I18n.t("shared.navbar.item") + ((if limit is 1 then "" else "s"))
					formatLoadMore: (pageNumber) ->
						I18n.t "shared.navbar.loading_more_results"
					formatSearching: ->
						I18n.t "shared.navbar.searching"
				return 

	update_event_personel = ->
		$.ajax
			url: "/providers/personel_list"
			type: "GET"    
			data:
				id: $("#provider_id").val()
			dataType: 'json'
			success: (data) ->        
				$("#event_personel").select2
					multiple: true
					data: data.data
					placeholder: "Lütfen Hizmet Veren Personeli Seçiniz"
					formatNoMatches: ->
						I18n.t "shared.navbar.no_matches_found"
					formatInputTooShort: (input, min) ->
						I18n.t("shared.navbar.please_select") + " " + (min - input.length) + " " + I18n.t("shared.navbar.more_characters")
					formatSelectionTooBig: (limit) ->
						I18n.t("shared.navbar.you_can_only_select") + " " + limit + " " + I18n.t("shared.navbar.item") + ((if limit is 1 then "" else "s"))
					formatLoadMore: (pageNumber) ->
						I18n.t "shared.navbar.loading_more_results"
					formatSearching: ->
						I18n.t "shared.navbar.searching"
				return 




	update_event_service =  ->
		$.ajax
			url: "/reservations/provider_all"
			type: "GET"    
			data:
				id: $("#provider_id").val()
			dataType: 'json'
			success: (data) ->        
				$("#event_service").select2     
					multiple: true
					placeholder: "Lütfen Verilen Hizmeti Seçiniz"
					formatNoMatches: ->
						I18n.t "shared.navbar.no_matches_found"
					formatInputTooShort: (input, min) ->
						I18n.t("shared.navbar.please_select") + " " + (min - input.length) + " " + I18n.t("shared.navbar.more_characters")
					formatSelectionTooBig: (limit) ->
						I18n.t("shared.navbar.you_can_only_select") + " " + limit + " " + I18n.t("shared.navbar.item") + ((if limit is 1 then "" else "s"))
					formatLoadMore: (pageNumber) ->
						I18n.t "shared.navbar.loading_more_results"
					formatSearching: ->
						I18n.t "shared.navbar.searching"
					data: data.data
				return 

	update_event_block = ->
		$.ajax
			url: "/reservations/events_block"
			type: "GET"    
			data:
				id: $("#provider_id").val()
			dataType: 'json'
			success: (data) ->  
				$("#event_block").select2 
					minimumInputLength: 0  
					multiple: true
					placeholder: "Lütfen seçiniz"
					formatNoMatches: ->
						I18n.t "shared.navbar.no_matches_found"
					formatInputTooShort: (input, min) ->
						I18n.t("shared.navbar.please_select") + " " + (min - input.length) + " " + I18n.t("shared.navbar.more_characters")
					formatSelectionTooBig: (limit) ->
						I18n.t("shared.navbar.you_can_only_select") + " " + limit + " " + I18n.t("shared.navbar.item") + ((if limit is 1 then "" else "s"))
					formatLoadMore: (pageNumber) ->
						I18n.t "shared.navbar.loading_more_results"
					formatSearching: ->
						I18n.t "shared.navbar.searching"
					data: data.data 
				return


	update_personel_event = (price_ids) -> 
		$.ajax
			url: "/reservations/events_personel"
			type: "GET"
			data:
				id: $("#provider_id").val()
				price_ids: price_ids 
			dataType: "json"
			success: (data) ->
				$("#event_personel").select2
					multiple: true
					placeholder: "Lütfen seçiniz"
					formatNoMatches: ->
						I18n.t "shared.navbar.no_matches_found"
					formatInputTooShort: (input, min) ->
						I18n.t("shared.navbar.please_select") + " " + (min - input.length) + " " + I18n.t("shared.navbar.more_characters")
					formatSelectionTooBig: (limit) ->
						I18n.t("shared.navbar.you_can_only_select") + " " + limit + " " + I18n.t("shared.navbar.item") + ((if limit is 1 then "" else "s"))
					formatLoadMore: (pageNumber) ->
						I18n.t "shared.navbar.loading_more_results"
					formatSearching: ->
						I18n.t "shared.navbar.searching"
					data: data.data
				$("#event_personel").select2 "enable", true
				return


	update_event_type = (data) ->
		$("#event_type option").each ->
		  $(this).remove()
		  return 
		$.each data, (id, item1) ->
		  row = "<option value=" + id + ">" + item1[0] + "</option>"
		  $(row).appendTo "select#event_type"
		  return 


	update_personel_block = (category_ids) -> 
		$.ajax
			url: "/reservations/personels_block"
			type: "GET"
			data:
				id: $("#provider_id").val()
				category_ids: category_ids 
			dataType: "json"
			success: (data) ->
				$("#personel_block").select2
					multiple: true
					placeholder: "Lütfen seçiniz"
					data: data.data
				$("#personel_block").select2 "enable", true
				return

 

	personel_validate = (block_id) -> 
		if block_id is ""
			$("#event_block").rules "add",
				required: true      
				messages:
					required: I18n.t "provider.tax_pin.blank" 
			$("#personel_block").rules "add",
				required: true      
				messages:
					required: I18n.t "provider.tax_pin.blank" 
		else
			$("#event_block").rules "remove", "required"
			$("#personel_block").rules "remove", "required"


$ ->
	if $("#scheduler").length > 0
		
		$('#scheduler').ajaxSpin() 
		loadSchedulerData()
		scheduler.init "scheduler",new Date(), "week"
		$.ajax
			url: "/reservations/personel_list"
			type: "GET"    
			data:
				id: $("#provider_id").val()
			dataType: 'json'
			success: (data) ->  
				$("#personel_services").select2 data: data.data
				$("#personel_services").select2 "val", data.data[0]["id"]
				$("#personel_services").trigger "change"
				return 
		
		$("#personel_services").on "change" ,->
			$.ajax
				url: "/reservations/events_block"
				type: "GET"    
				data:
					id: $("#provider_id").val()
					staff_id: $("#personel_services").select2("data").id
				dataType: 'json'
				success: (data) -> 
					$("#provider_services").select2 data: data.data
					$("#provider_services").select2 "val", data.data[0]["id"]
					$("#provider_services").trigger "change"
					return

		$("#provider_services").on "change" ,->
			provider_id = $("#provider_id").val() 
			category_id = $("#provider_services").select2("data").id
			staff_id = $("#personel_services").select2("data").id
			scheduler.setLoadMode "month" 
			scheduler.load "/reservations/load_scheduler.json?category_id=" + category_id + "&staff_id=" + staff_id + "&provider_id=" + provider_id, "json" 
			scheduler.clearAll()
			return
		initModal()
		return
 

	# $.ajax 
	# 	url: "/reservations/get_calendar_range"
	# 	type: "GET"
	# 	data: 
	# 		provider_id: $("#provider_id").val()
	# 	dataType: 'json'
	# 	success: (data) -> 
	# 		scheduler.config.first_hour = parseInt(data[0]) 
	# 		scheduler.config.last_hour = parseInt(data[1])
	# 		return  
 