
OmniAuth.config.logger = Rails.logger 
Rails.application.config.middleware.use OmniAuth::Builder do
  APP_CONFIG.facebook.scope.concat(', user_groups') if APP_CONFIG.facebook.restricted_group_id
  provider :facebook,
    APP_CONFIG.facebook.app_id,
    APP_CONFIG.facebook.app_secret,
    { scope: APP_CONFIG.facebook.scope }
    
  provider :identity, fields: [:email, :name, :admin_password],  on_failed_registration: lambda { |env|
    IdentitiesController.action(:new).call(env)
  }
 
	OmniAuth.config.on_failure = Proc.new { |env|
	  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
	}
end
