###global $:false, I18n:false, HandlebarsTemplates:false###

'use strict'

$(document).ready ->
  if $('.navbar-profile-link').attr("data-login-count") is "1"  
    $("#navbar-user-info").popover
      placement: "bottom"
      trigger: "manual"
      html: "true"
      title: I18n.t "shared.navbar.giving_service" 
      content: "<div style='vertical-align:middle;'> <div> <a href='/fiyat-veren/yeni/' title='test add link'>#{I18n.t "shared.navbar.come_here"}</a> </div></div>"
    $("#navbar-user-info").popover "toggle"
    $("#navbar-user-info").popover "show"
    $("#navbar-user-info").on "shown.bs.popover", ->
    setTimeout (->
      $("#navbar-user-info").popover "hide"
      $.ajax
        data: "update=update"
        type: "get"
        url: "/increment_login_count"
        success: (data) ->
          if data.result is true
            $(".popover").remove()
            return            
      return
    ), 10000
    return

 

 
# Needed to follow links in popovers
$(document).on 'click', '.popover a', (e) ->
  e.stopPropagation()

$(document).on 'click', '.notifications', (e) ->
  e.preventDefault()
  $me = $(this)
  $('.notifications').not("##{$me.attr('id')}").removeClass('active').find('a').popover 'hide'
  $popoverElement = $me.toggleClass('active').find 'a'
  if $me.find('.popover')[0]?
    $popoverElement.popover 'hide'
  else
    $popoverElement.popover 'show'
  if $('.popover.in')[0]? and $popoverElement.data('load')?
    $.ajax
      url: $popoverElement.data 'load'
      success: (data) ->
        messages = ''
        for message in data
          messages += HandlebarsTemplates['messages/show_in_popup'](message)
        if data.length > 0
          $popoverElement.find('span.count').text data.length
          $('.popover-ajax-content').html """
            <ul class="unstyled popover-elements">
              #{messages}
            </ul>
          """
        else
          $popoverElement.find('span.count').remove()
          $('.popover-ajax-content').html I18n.t('shared.navbar.no_new_messages')
  false
