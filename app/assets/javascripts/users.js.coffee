###global $:false###

'use strict'

# jQuery Turbolinks
$ ->

  $("#form1xxx_submit").click ->
    phonetext = $("#contact_phone").val().replace("(", "").replace(") ", "")
    if $("#reg1_form").valid() is true
      testStr = $('#current_phones').val()
      if (($("#hidden_phone").val() != phonetext) && (testStr.indexOf(phonetext) is -1)) || $("#contact_phone").val().length is 0
        $("#phone-verification").modal "show"
        $("#verification_phone").val $("#contact_phone").val()
      else
        $("#form1_submit").prop "disabled", true 
        $("#form1_submit").prop "value", I18n.t "shared.navbar.pleasewait"        
        $("#reg1_form").submit()
      return false
    return false 
      
  if $("#passwordarea")[0]?
    $("#updatepassword").click  ->
      $("#updatepassword").hide();
      $("#passwordarea").show();


  setTimeout ->
    $('li.unread').removeClass 'unread'
  , 5000 
  
  $("#user_settings_form").validate
    errorClass: "error_class"
    validClass: "valid_class"
    rules:
      user_name: "required"
      user_email:
        required: true
        email: true
        remote: "/users/check_email" 
      user_password:
        required: true
        minlength: 5 
      user_password_confirmation:
        required: true
        minlength: 5
        equalTo: "#password" 
    messages:
      name: I18n.t "signup.name.required"  
      password:
        required: I18n.t "signup.password.required"  
        minlength: I18n.t "signup.password.minlength"  
      password_confirmation:
        required: I18n.t "signup.password_confirmation.required" 
        minlength: I18n.t "signup.password_confirmation.minlength" 
        equalTo: I18n.t "signup.password_confirmation.equalTo" 
      email:
        required: I18n.t "signup.email.required" 
        email: I18n.t "signup.email.email" 
        remote: I18n.t "signup.email.remote" 



 





  
  
  
