class Admin::ProvidersController < Admin::BaseController
  before_filter :check_admin
  before_filter :require_login 
   def index
    @providers = Provider.all 
   # @users = User.asc(:name, :include => :providers, :page => params[:page], :per_page => 20 )
  end

    
  def verify
    @provider = Provider.find params[:id]
    if @provider.update_attributes(verified: true)     
      @provider.workdones.each do |w|       
        self.update_scores("app_verify",nil, @provider, nil)
      end
      redirect_to admin_users_path, flash: { success: t('flash.admin.users.success.verify') }
    else
      redirect_to admin_users_path, flash: { error: t('flash.admin.users.error.verify') }
    end
  end

  def unverify
   @provider = Provider.find params[:id]
    if @provider.update_attributes(verified: false)     
      @provider.workdones.each do |w|       
        self.update_scores("app_unverify",nil, @provider, nil)
      end
      redirect_to admin_users_path, flash: { success: t('flash.admin.users.success.unverify') }
    else
      redirect_to admin_users_path, flash: { error: t('flash.admin.users.error.unverify') }
    end
  end
  
end
