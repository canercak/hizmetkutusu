class IdentitiesController < ApplicationController

  def new
    @identity = env['omniauth.identity']
  end
   
  def failure
    redirect_to new_sessions_path,  flash: { success:  t('shared.navbar.sign_in_fail') }  
  end

end
