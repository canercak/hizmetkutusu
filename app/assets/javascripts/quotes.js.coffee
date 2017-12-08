 
###global $:false, google:false, I18n:false###

ColoursArray = ['#0000ff', '#ff0000', '#00ffff', '#ff00ff', '#ffff00']
'use strict'

window.hizmetkutusu = window.hizmetkutusu || {}
hizmetkutusu = window.hizmetkutusu
price_arr = new Array()
quote_arr = new Array()
#price_list_arr = new Array()

convert = []
start = new Date()
end = new Date()
end.setMonth (end.getMonth() + 2)

 
hexToRgba = (color, alpha = 1) ->
  if color.charAt(0) is '#' then (h = color.substring(1,7)) else (h = color)
  "rgba(#{parseInt(h.substring(0,2),16)}, #{parseInt(h.substring(2,4),16)}, #{parseInt(h.substring(4,6),16)}, #{alpha})"

hizmetkutusu.infoWindow = new google.maps.InfoWindow
  maxWidth: 400
  pixelOffset:
    width: 0
    height: -35 

wizardPrevStep = ->
 
  step = (Number) $('div[data-step]:visible').data('step')
  return if step <= 1
  lastStep = (Number) $('div[data-step]').last().data('step')
  $("#wizard-step-#{step}-content").fadeOut ->     
    $('#wizard-next-step-button').prop('disabled', false).show()
    $('#new_quote_submit').prop('disabled', true).hide()
    $('#add_variation').hide()
    $("#facebook_share").hide()
    $("#wizard-step-#{step}-title").addClass('hidden-phone').removeClass 'active'
    $("#wizard-step-#{step}-title")
      .removeClass('hidden-phone').addClass('active')
    --step
    $("#wizard-step-#{step}-content").fadeIn()
    if step is 1
      $("#wizard-prev-step-button").prop('disabled', true).hide()
    $(window).scrollTop("#wizard-step-#{step}-title")
 
sortResults = (prop, asc) ->
  people = people.sort((a, b) ->
    if asc
      (if (a[prop] > b[prop]) then 1 else ((if (a[prop] < b[prop]) then -1 else 0)))
    else
      (if (b[prop] > a[prop]) then 1 else ((if (b[prop] < a[prop]) then -1 else 0)))
  )
  showResults()
  return  

getData = -> 
  # $('#providers-thumbs').ajaxSpin
  $("#selected_providers").val ''
  $("#selected_prices").val ''
  arr = []
  Gmaps.map = new Gmaps4RailsGoogle() 
  lat = undefined
  lng = undefined
  variation_id = $("#quote_variation_id").val()
  location =  ($("#longitude").val() + "," + $("#latitude").val())
  distance = $("#distance").val()
  div = document.createElement 'div'   
  div.setAttribute 'class', "arrow_box"
  div.style.width = '27px'
  div.style.height = '27px'
  img = document.createElement 'img'
  img.setAttribute 'width', '25px'
  img.setAttribute 'height', '25px'
  img.setAttribute 'alt', ''
  user_image= $("img[alt=\"userimage\"]").attr "src"
  if user_image is undefined
    img.src = "/assets/profile_pic_small.png"
  else 
    img.src = $("img[alt=\"userimage\"]").attr "src"
  div.appendChild img  
  $.ajax
    url: "/providers/getlocation"
    data:
      location: location 
      distance:  distance 
      variation_id: variation_id 
    type: "POST"    
    success:  ->
      locationArray = location.split(",")
      $.getJSON "/providers/getlocation", (json) ->
        json.sort (a, b) ->
           parseFloat(a.price) - parseFloat(b.price) 
        Gmaps.load_map = ->  
          Gmaps.map.initialize() 
          Gmaps.map.rich_marker = true
          Gmaps.map.createMarker
            Lat: locationArray[1]
            Lng: locationArray[0]
            draggable: false
            rich_marker: div
            marker_picture: ""
          Gmaps.map.addMarkers json
          if Gmaps.map.markers.length is 0 ||  Gmaps.map.markers.length is 1
            centerpoint = new google.maps.LatLng(locationArray[1], locationArray[0])
            Gmaps.map.map.setCenter centerpoint
            if distance > 100 && distance < 300
              Gmaps.map.map.setZoom 9
            else if distance > 300 && distance < 500
              Gmaps.map.map.setZoom 7
            else if distance > 500 && distance < 1501
              Gmaps.map.map.setZoom 5
            else
              Gmaps.map.map.setZoom 11
          else
            Gmaps.map.map_options.auto_zoom = true
            #Gmaps.map.map.adjust_map_to_bounds()
          i = 0
          while i < Gmaps.map.markers.length
            marker = Gmaps.map.markers[i].serviceObject
            marker.marker_id = Gmaps.map.markers[i].id
            google.maps.event.addListener marker, "click", ->
              pane = "#pane1_" + @marker_id
              $.smoothScroll
                scrollTarget: pane
                offset: -200
            ++i
        Gmaps.loadMaps()   
        Gmaps.map.callback = ->
        $('#providers-thumbs').html ''
        index = 0
        row_template = $("<div class=\"span12\" id=\"providerselect\"></div>");
        row = row_template
        $(json).each ->
          $('#providers-thumbs').append(row = row_template.clone(true)) if (index % 2) is 0
          color = ColoursArray[index++ % ColoursArray.length]
          this.borderColor = hexToRgba(color, 0.45)
          row.append HandlebarsTemplates['providers/thumbnailnew'](this)    
        if json.length is 0
          $('.result-notfound').text(I18n.t 'shared.navbar.result_not_found', distance:distance)
          $('.result-notfound').show() 
        else
          $('.result-notfound').hide()
        $(".price_check").checkbox
          buttonStyle: "btn-danger"
          buttonStyleChecked: "btn-success"
          checkedClass: "icon-check"
          uncheckedClass: "icon-check-empty"
        $(".quote_check").checkbox
          buttonStyle: "btn-danger"
          buttonStyleChecked: "btn-success"
          checkedClass: "icon-check"
          uncheckedClass: "icon-check-empty"
        $(".ratingstars").jRating
          isDisabled: true
          step: true
          rateMax: 5
          length: 5
          decimalLength: 0


    failure: ->
      alert "Unsuccessful" 
  $("#mapsrow.row").show() 
    
wizardNextStep = ->   
  step = (Number) $('div[data-step]:visible').data('step')
  lastStep = (Number) $('div[data-step]').last().data('step') 
  
  if step is lastStep
    return false 
  
  $("#wizard-step-#{step}-content").fadeOut ->
    $("#wizard-step-#{step}-title")
      .removeClass('active').addClass('hidden-phone') 
    ++step
 
    $("#wizard-step-#{step}-title").removeClass('hidden-phone').addClass 'active'

    $("#wizard-step-#{step}-content").fadeIn ->
      getData() 
      $(window).scrollTop("#wizard-step-#{step}-title")

    if step > 1
      $("#wizard-prev-step-button").prop('disabled', false).show()
      if step is lastStep
        $('#wizard-next-step-button').prop('disabled', true).hide()
        if $("#selected_providers").val().length > 0 
          $('#new_quote_submit').prop('disabled', false).show()
          $('#add_variation').show()
        else if $("#selected_prices").val().length > 0 
          $('#new_quote_submit').prop('disabled', false).show()
          $('#add_variation').show()
        else
          $('#new_quote_submit').prop('disabled', true).show()
          $('#add_variation').hide()
          $("#facebook_share").show() 
 
getCustomerAddress = -> 
  $.ajax
    url: "/quotes/getaddress"
    type: "GET"    
    dataType: 'json'
    success: (data) ->
      zoom = undefined
      center = undefined
      $("#latitude").val data.location[1] 
      $("#longitude").val data.location[0] 
      $("#customer_address").val data.customer_address
      addresspickerMap = $("#customer_address").addresspicker(
        regionBias: "tr"
        updateCallback: showCallback
        componentsFilter: "country:TR"
        elements:
          map: "#quotemap"
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
      gmarker.setVisible true
      addresspickerMap.addresspicker "updatePosition"
      setTimeout (->
        addresspickerMap.addresspicker "updateMap"
        addresspickerMap.addresspicker "reloadPosition"
        return 
      ), 1 
      $("#reverseGeocode").change ->
        $("#addresspicker_map").addresspicker "option", "reverseGeocode", ($(this).val() is "true")
      showCallback = (geocodeResult, parsedGeocodeResult) ->
        $("#callback_result").text JSON.stringify(parsedGeocodeResult, null, 4) 
       
    failure: ->
      alert "Unsuccessful" 


initQueryDetails = ->
  getCustomerAddress()
  $('#wizard-next-step-button').on 'click', wizardNextStep
  $('#wizard-prev-step-button').on 'click', wizardPrevStep 
  $(window).scroll ->
    if $(this).scrollTop() > 100
      $(".scrollup").fadeIn()
    else
      $(".scrollup").fadeOut()  

  $(".scrollup").click ->
    $.smoothScroll
      scrollTarget: "#map"
      offset: -120  

  $("#query_date").datepicker
    weekStart: 1
    startDate: start
    endDate: end
    language: "tr"
    autoclose: true
    todayHighlight: true  

  $("#query_date").datepicker().on "show", (e) ->
    $(".datepicker").css("font-size", 14);
    $(".table-condensed").css "width", "100px"
    return false
  $("#query_date").datepicker().on "show", (e) ->
    $(".datepicker").css("font-size", 14);
    $(".table-condensed").css "width", "100px"
    return false

 
  
  $("#quote_variation_id").select2
    placeholder: I18n.t("shared.navbar.please_enter_work_type")
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
    dropdownCssClass: "bigdrop"
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
    initSelection: (element, callback) ->
      data1 = []
      data1.push
        id: element.val()
        text: $("#quote_variation_text").val()
      callback data1[0]

 
initFaceBookCheck= -> 
  $("input[type=\"checkbox\"].facebook_check").checkbox
    buttonStyle: "btn-facebook btn-mini"
    buttonStyleChecked: "btn-facebook btn-mini"
    checkedClass: "icon-check"
    uncheckedClass: "icon-check-empty"
    checked: "true"
    enabled: "true"
  $("#facebook_share").click ->
    if $("#share_on_facebook_timeline").val() is "true"
      $("#share_on_facebook_timeline").val("false")
    else
      $("#share_on_facebook_timeline").val("true")
    return 
  $("#facebook_share").hide()

initProviderThumbs = ->   
  if $("#selected_providers").val() is ''
    $('#new_quote_submit').prop('disabled', true) 
    $('#add_variation').hide()
    $("input[value=\"unchecked\"].quote_check").checkbox
      enabled:true 
    $("input[value=\"unchecked\"].price_check").checkbox
      enabled:true
  else      
    $('#new_quote_submit').prop('disabled', false)  
    $('#add_variation').show()    
    if $("#selected_providers").val().length > 96
       $("input[value=\"unchecked\"].quote_check").checkbox
          enabled:false
    else if $("#selected_providers").val().length > 0
       $("input[value=\"unchecked\"].price_check").checkbox
          enabled:false
    else
       $("input[value=\"unchecked\"].quote_check").checkbox
          enabled:true 
       $("input[value=\"unchecked\"].price_check").checkbox
          enabled:false

  $('#userpricesbody').on 'click', '#pricelist_price', (e) ->  
    value2 = $(this).data('id') 
    value1 = $("#selected_prices").val()
    price = parseFloat($(this).data('price'))
    total_price = parseFloat($("#total_price").text()) 
    if value1.indexOf(value2) > -1      
      price_arr.splice $.inArray(value2, price_arr), 1
      $("#userpricesbody").find(":input[data-id=" + value2 + "]").val 'unchecked'
      $("#total_price").text(total_price - price) 
    else
      price_arr.push value2       
      $("#userpricesbody").find(":input[data-id=" + value2 + "]").val 'checked'  
      $("#total_price").text(total_price + price)
    $("#selected_prices").val price_arr
    
 
  $('#providers-thumbs').on 'click', '#giveprice', (e) ->  
    provider_id =  $(this).data('id') 
    value2 = $(this).data('priceid') 
    priceid = $(this).data('priceid')
    categoryid = $(this).data('categoryid') 
    value1 = $("#selected_prices").val() 
    distance2 = $("#result-distance_" +value2).text()
    distance1 = $("#provider_distance").val()     
    if value1.indexOf(value2) > -1
      price_arr.splice $.inArray(value2, price_arr), 1
      $("#new_quote").find(":input[data-id=" + value2 + "]").val 'unchecked'
      $("#selected_providers").val('')  
    else
      price_arr.push value2  
      $("#new_quote").find(":input[data-id=" + value2 + "]").val 'checked' 
      $("#selected_providers").val(provider_id)  
    $("#selected_prices").val price_arr 
    if $("#selected_prices").val().length > 0
      $('#new_quote_submit').prop('disabled', false)  
      $('#add_variation').show()    
      $("input[value=\"unchecked\"].quote_check").checkbox
        enabled:false
      $("input[value=\"unchecked\"].price_check").checkbox
        enabled:false 
      $("input[data-priceid=" + value2 + "].price_check").checkbox
        enabled:true 
      $.smoothScroll
        scrollTarget: "#new_quote_submit"
        offset: -120 
        easing: 'swing'
        speed: 800
        beforeScroll: ->
          $("#new_quote_submit").prop "value", "Randevu Alın"
        afterScroll: ->
          $("#add_variation").tooltip()
          # $("#add_variation").popover
          #   placement: "right"
          #   trigger: "manual"
          #   html: "true"
          #   title: "Hizmet sağlayıcınızı seçtiniz"
          #   content: "<table><tr><th rowspan='2'><img class='hasan_pic' src='/assets/hasan_popover.png'/></th><th><a id='price_list#{provider_id}' href='#'>Burdan diğer hizmetlerini de ekleyebilirsiniz</a> </th></tr><tr><th style='display:none'><a id='price_list#{provider_id}' href='#'>Başka hizmetlerini ekleyin</a> </th></tr></table>"
          # $("#add_variation").popover "show"       
          $("#add_variation").click (event) ->
            if $("#selected_prices").val().length < 49
              $.get "/quotes/user_prices/",
                provider_id: provider_id,
                category_id: categoryid,
                price_id: priceid,
              , null, "script"
            # $(".popover").remove()
            $("#user_prices").modal "show"
            $("#accordion2").collapse toggle: false 
            # $.smoothScroll
            #   scrollTarget: "#price_list#{id}"
            #   offset: -120 
            #   easing: 'swing'
            #   speed: 800 
    else
      $('#new_quote_submit').prop('disabled', true) 
      $('#add_variation').hide()
      $("input[value=\"unchecked\"].quote_check").checkbox
        enabled:true 
      $("input[value=\"unchecked\"].price_check").checkbox
        enabled:true
      #$('.popover').remove()

initDistance = -> 
  $("#search_distance").text 10 + ' '+ I18n.t("shared.navbar.search_distance") 
  x = 20
  $("#B").slider()
  $("#B").slider().on "slideStop", (ev) ->
    $("#distance").val x
    getData()
  $("#B").slider().on "slide", (ev) ->
    s = $("#B").data("slider").getValue()
    switch $("#B").data("slider").getValue()
      when 55
        s = "100"
      when 60
        s = "150"
      when 65
        s = "200"
      when 70
        s = "300"
      when 75
        s = "400"
      when 80
        s = "500"
      when 85
        s = "600"
      when 90
        s = "700"
      when 95
        s = "800"
      when 100
        s = "900"
      when 105
        s = "1000"
      when 110
        s = "1100"
      when 115
        s = "1200"
      when 120
        s = "1300"
      when 125
        s = "1400"
      when 130
        s = "1500"
    $(".tooltip-inner").text s
    $("#search_distance").text s + ' '+ I18n.t("shared.navbar.search_distance")
    x = parseInt(s)


#selected_date1 = undefined
 
setTime= (selected_date) ->
  $.ajax
    url: "/providers/available_hours"
    type: "GET"    
    data:
      provider_id: $("#selected_providers").val()
      prices: $("#selected_prices").val()
      date: selected_date
    dataType: 'json'
    success: (data) ->
      $("#reserve_booking").prop "disabled", "disabled"
      $("#booking_first").html ""
      $("#booking_second").html ""
      $("#booking_third").html ""
      selected_date1 = data.date
      $("#datetime_text").text data.date
      lenght = data.times.length
      $("#available-times tbody").empty()
      $("#available-times tbody:last").append "<tr>"
      $.each data.times, (index, item) ->
        if index < 5 || (index > 5 && index < 11) || (index > 11 && index < 16) || (index > 16 && index < 21)
          $("#available-times tr:last").append "<td><div class='btn btn-default button button-cal time-button' data-value=" + item + ">" +  item  + "</div></td>"
        else if index is (length - 1)
          $("#available-times tbody:last").append "</tr>"
        else
          $("#available-times tbody:last").append "<tr>" 
      $(".btn.btn-default.button.button-cal.time-button").click ->                  
        $("#available-times>table>tbody>tr>td>div.active").removeClass "active"
        $(this).addClass 'active'
        selected_time = $(this).attr "data-value"
        reservation_date = moment(selected_date + ' ' + selected_time);
        $("#reservation_date").val(reservation_date._i)
        $("#booking_first").html ""
        $("#booking_second").html ""
        $("#booking_third").html ""
        $("#booking_first").append I18n.t("shared.navbar.booking_first", fulltime: (selected_date1 + ' ' + selected_time), variation_names: variation_names)

        $("#booking_second").append I18n.t("shared.navbar.booking_second", sum_prices: sum_prices, provider: provider_name)
        $("#booking_third").append I18n.t("shared.navbar.booking_third")
        $("#reserve_booking").prop "disabled", false
        
        return
      return false 

variation_names = undefined
provider_name = undefined
duration = undefined
service_s = undefined
sum_prices = undefined 
updateBookingCalendar= ->  
  $("#appointment_datepicker div").datepicker "remove" 
  $.ajax
    url: "/providers/disabled_days"
    type: "GET"    
    data:
      provider_id: $("#selected_providers").val()
      prices: $("#selected_prices").val()
    dataType: 'json'
    success: (data) -> 
      dateDisabled =  data.disabled_days 
      i = 0
      l = dateDisabled.length
      while i < l
        convert.push(moment(dateDisabled[i]).toDate().getTime())
        i++  
      $("#duration_text").html ""  
      #$("#booking_header").html "" 
      variation_names = data.variation_names 
      provider_name = data.provider_name 
      duration = data.duration
      service_s = data.service_s
      sum_prices = data.sum_prices
      $("#duration_text").append I18n.t("shared.navbar.estimated_duration", service_s: service_s,  duration: duration) 
      #$("#booking_header").append I18n.t("shared.navbar.booking_header", provider_name: provider_name)
      return   

  $("#appointment_datepicker div").datepicker( 
    language: "tr"
    todayHighlight: true
    format: "dd.mm.yyyy"
    startDate: start
    endDate: end
    beforeShowDay: (date) ->
      unless $.inArray(date.getTime(), convert) is -1
        return enabled: false
      return 
  ).on  "changeDate", (ev) -> 
    setTime(ev.format())

  #$("#appointment_datepicker div").datepicker "update", new Date()

startBooking= ->
  if $("#selected_prices").val().length > 0 
    $("#user_prices").modal "hide"
    $("#appointment-booking").modal "show"
    updateBookingCalendar()
    setTime($("#query_date").val()) 
    return false
  else 
    if $("#current_user").val().length > 0 
      testStr = $('#current_phones').val()
      if testStr.length is 0
        $.get "/quotes/verification/"
        $("#phone-verification").modal "show"
        return false 
      else       
        $("#new_quote_submit, #new_price_submit").prop "value", I18n.t "shared.navbar.pleasewait" 
        $("#new_quote_submit, #new_price_submit").prop "disabled", "disabled"   
        $('#add_variation').hide()           
        $("#new_quote").submit() 
    else
      $("#login-identity").modal "show"
      return

startReserving= ->
  testStr = $('#current_phones').val()
  current_user = $("#current_user").val()
  if current_user.length > 0 && testStr.length is 0
    $("#appointment-booking").modal "hide" 
    $.get "/quotes/verification/"
    $("#phone-verification").modal "show" 
    return false
  else if current_user.length is 0
    $("#appointment-booking").modal "hide" 
    $("#login-identity").modal "show"
    $.cookie "nologin_variation",  $("#quote_variation_id").val() 
    $.cookie "nologin_date", $("#reservation_date").val()
    $.cookie "nologin_selected_prices", $("#selected_prices").val() 
    return false
  else
    $("#reserve_booking").prop "disabled", "disabled"
    $("#reserve_booking").prop "value", I18n.t "shared.navbar.pleasewait"   
    $("#new_quote_submit").prop "disabled", "disabled"
    $('#add_variation').hide()
    $("#new_quote_submit").prop "value", I18n.t "shared.navbar.pleasewait"        
    $("#new_quote").submit()
 
initBooking= -> 
  selected_date = undefined 
  $("#new_quote_submit, #new_price_submit").click  ->
    $(".popover").remove()
    startBooking() 
  $("#reserve_booking").click  ->
    startReserving()
 
initQuoteNew = ->
  initQueryDetails()
  initFaceBookCheck()
  initProviderThumbs()
  initDistance()
  initBooking() 
  $('#tableity').filterable({editableOptions: {"title": I18n.t('javascript.enter_keyword')}});


  


initQuoteShow= ->
  # $("#pay_quote").popover
  #   placement: "right"
  #   trigger: "manual"
  #   html: "true"
  #   title: "Şimdi Ödeyin, Avantajlı Olsun"
  #   content: "<table><tr><th rowspan='2'><img src='/assets/hasan_popover.png'/></th><th><a  href='#'>Hem Taksit Yapın</a> </th></tr><tr><th style='display:none'><a href='#'>Hem Puan Kazanın</a> </th></tr></table>"
  # $("#pay_quote").popover "show"   

 
$ ->
  if $('#new_quote')[0]? 

    no_login_var = $.cookie "nologin_variation"
    no_login_date = $.cookie "nologin_date"
    no_login_prices = $.cookie "nologin_selected_prices"
    $.removeCookie "nologin_variation"
    $.removeCookie "nologin_date"
    $.removeCookie "no_login_prices"

    if no_login_var != undefined && no_login_date != undefined && no_login_prices != undefined
      $("#quote_variation_id").val(no_login_var)
      $("#reservation_date").val(no_login_date)
      $("#selected_prices").val(no_login_prices)
      startReserving()

    initQuoteNew()    
    if $("#quote_variation_id").val() != ""
      $("#wizard-step-1-content").hide()
      $("#wizard-step-1-title").removeClass('active').addClass 'hidden-phone'  
      $("#wizard-step-2-title").removeClass('hidden-phone').addClass 'active' 
      $("#wizard-step-2-content").show()
      loc = $.cookie("geolocation").split("|");
      $("#latitude").val(loc[0]) 
      $("#longitude").val(loc[1]) 
      getData() 
      $(window).scrollTop("#wizard-step-2-title")  
      $("#wizard-prev-step-button").prop('disabled', false).show()
      $('#wizard-next-step-button').prop('disabled', true).hide()
      $('#new_quote_submit').prop('disabled', true).show()
      $('#add_variation').hide()
      $("#facebook_share").show()  
  if $('#pay_quote')[0]?
    initQuoteShow()

    
