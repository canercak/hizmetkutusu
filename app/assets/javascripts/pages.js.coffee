###global $:false ###
'use strict'

# Prevent disabled links from being clicked
# Bind to document, so this is compatible with turbolinks
$(document).on 'click', 'a.disabled', (e) ->
	e.preventDefault()

$(document).on 'click', '.btn-providerhow1', (e) ->
	e.preventDefault()
	$('html, body').animate
		scrollTop: $('#providerhow1_span').offset().top
	, 'slow'

$(document).on 'click', '.btn-providerhow2', (e) ->
	e.preventDefault()
	$('html, body').animate
		scrollTop: $('#providerhow2_span').offset().top
	, 'slow'

$(document).on 'click', '.btn-providerhow3', (e) ->
	e.preventDefault()
	$('html, body').animate
		scrollTop: $('#providerhow3_span').offset().top
	, 'slow'

$(document).on 'click', '.btn-customerhow1', (e) ->
	e.preventDefault()
	$('html, body').animate
		scrollTop: $('#customerhow1_span').offset().top
	, 'slow'

$(document).on 'click', '.btn-customerhow2', (e) ->
	e.preventDefault()
	$('html, body').animate
		scrollTop: $('#customerhow2_span').offset().top
	, 'slow'

$(document).on 'click', '.btn-customerhow3', (e) ->
	e.preventDefault()
	$('html, body').animate
		scrollTop: $('#customerhow3_span').offset().top
	, 'slow'

$(document).on 'click', '.btn-aboutus', (e) ->
	e.preventDefault()
	$('html, body').animate
		scrollTop: $('.aboutus-description.toUpper').offset().top

$(document).on 'click', '.btn-aboutus2', (e) ->
	e.preventDefault()
	$('html, body').animate
		scrollTop: $('.aboutus-success.toUpper').offset().top

	, 'slow'
$(document).on 'click', '.btn-faqcustomer', (e) ->
	e.preventDefault()
	$('html, body').animate
		scrollTop: $('#faqcustomerf').offset().top
	, 'slow'
$(document).on 'click', '.btn-faqprovider', (e) ->
	e.preventDefault()
	$('html, body').animate
		scrollTop: $('#faqproviderf').offset().top
	, 'slow'
$(document).on 'click', '.btn-provider-detail', (e) ->
	e.preventDefault()
	$('html, body').animate
		scrollTop: $('.full-block.anasayfa_adimlar.ilk_adim').offset().top
	, 'slow'  

$(document).on 'click', '.btn-provider-detail', (e) ->
	e.preventDefault()
	$('html, body').animate
		scrollTop: $('.full-block.anasayfa_adimlar.ilk_adim').offset().top
	, 'slow'  

$(document).on 'click', '.btn.btn-large.btn-learn-more', (e) ->
	e.preventDefault()
	$('html, body').animate
		scrollTop: $('.ribbon-content').offset().top
	, 'slow'  



$(document).on 'ready', ->
	if $("#landing_search").length > 0
		jQuery.noConflict()
		$("#landing_search").select2
			dropdownCssClass: "bigdrop"
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
			minimumInputLength: 3
			placeholder: I18n.t "shared.navbar.searching_main_page" 
			multiple:false
			ajax:
				url: "/categories/list_styles"
				dataType: "json"
				quietMillis: 100
				data: (term, page) ->
					q: term
					page_limit: 10
					page: page
				results: (data) ->
					results: data.data

		$("#landing_search").on "change", ->
			$.ajax
			  type: "GET"
			  url: "/quotes/landing_direct/"
			  data:
			  	variation_id: $("#landing_search").select2('data').id
			  	variation_text: $("#landing_search").select2('data').text
			  dataType: "json"
			  success: (data) ->
			  	location.replace(window.location.origin + data.path)
			  	return
 
		      
	 


		$("#owl-demo").owlCarousel
			items: 4
			lazyLoad: true
			navigation: false
		$(".ratingstars").jRating
			isDisabled: true
			step: true
			rateMax: 5
			length: 5
			decimalLength: 0
		$('#why-facebook').modal({
			backdrop: 'static',
			keyboard: true,
			show:false
		}) 

		# $("#signupForm").validate
		#   errorClass: "error_class"
		#   validClass: "valid_class"
		#   rules:
		#     name: 
		#       required: true
		#     email:
		#       required: true
		#       email: true
		#       remote: "/users/check_email" 
		#     password:
		#       required: true
		#       minlength: 5 
		#     password_confirmation:
		#       required: true
		#       minlength: 5
		#       equalTo: "#password" 
		#   messages:
		#     name: I18n.t "signup.name.required"  
		#     password:
		#       required: I18n.t "signup.name"  
		#       minlength: I18n.t "signup.password.minlength"  
		#     password_confirmation:
		#       required: I18n.t "signup.password_confirmation.required" 
		#       minlength: I18n.t "signup.password_confirmation.minlength" 
		#       equalTo: I18n.t "signup.password_confirmation.equalTo" 
		#     email:
		#       required: I18n.t "signup.email.required" 
		#       email: I18n.t "signup.email.email" 
		#       remote: I18n.t "signup.email.remote" 
					
		# $("#actual-login-form").validate
		#   errorClass: "error_class"
		#   validClass: "valid_class"
		#   rules:
		#     email:
		#       required: true
		#       email: true
		#     password:
		#       required: true
		#   messages:
		#     password:
		#       required: I18n.t "signup.name"  
		#     email:
		#       required: I18n.t "signup.email.required" 
		#       email: I18n.t "signup.email.email" 
	
 



 
 
 
