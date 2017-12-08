
'use strict'
 
$ -> 
	if ($('#save_customer').length > 0 || $('#edit_customer').length > 0) 
		$("#customer_phone").setMask()
		#$("#customer_name").prop "disabled", "disabled"
		# $("#customer_name").val('')
		# $("#customer_phone").val('')
		# $("#customer_email").val('')
	 
		$("#customer_phone").on "keyup", -> 
			a =  $(this).val().length
			if a is 14
				$.ajax
					url: "/users/check_phone_exists"
					type: "GET"
					data:
						phone:  $("#customer_phone").val() 
					dataType: "json"
					success: (data) ->
						if data is null
							$("#customer_name").prop "disabled", false
							$("#customer_email").prop "disabled", false
							$("#customer_name").val('')
							$("#customer_email").val('')
							return false	
						else
							$("#customer_email").val(data.email)
							$("#customer_name").val(data.name)
							$("#customer_email").prop "disabled", "disabled"
							$("#customer_name").prop "disabled", "disabled"
							return false
 