module IdentitiesHelper
  def translate_errors(errors)
  	error_list = []
  	if errors[:password_confirmation].include? "doesn't match confirmation"
  		error_list <<  t('shared.navbar.pass_confirm')
  	end
  	if errors[:name].include? "can't be blank"
  		error_list <<  t('shared.navbar.name_blank')
  	end 
  	if errors[:email].include? "can't be blank"
  		error_list <<  t('shared.navbar.email_blank')
  	end 
  	if errors[:password].include?  "can't be blank"
  		error_list <<  t('shared.navbar.pass_blank')
  	end
  	if errors[:password_confirmation].include?  "can't be blank"
  		error_list <<  t('shared.navbar.pass_confirm_blank')
  	end
  	if errors[:email].include? "email is already in use"
  		error_list <<  t('shared.navbar.name_blank')
  	end 
 
  end
end