module Concerns
  module User
    module Authentication
      extend ActiveSupport::Concern

      included do
        def set_fields_from_omniauth(auth)
          set_credentials auth.credentials
          set_info auth.info 
          if self.locale != nil
            self.locale = auth.extra.raw_info.locale.gsub(/_/,'-') unless self.locale?
          else
            self.locale = :tr
          end
          self.username_or_uid = [ username, uid ]
          if auth.provider != "identity"
            set_extra_raw_info auth.extra.raw_info
            set_extra_raw_info_special_permissions auth.extra.raw_info  
            set_permissions 
            Resque.enqueue(FacebookDataCacher, id) 
          end
          rescue Redis::CannotConnectError 
        end

        def has_access?
          return true unless APP_CONFIG.facebook.restricted_group_id
          facebook do |fb|
            groups = fb.get_connections('me', 'groups')
            group = groups.select{ |g| g['id'] == APP_CONFIG.facebook.restricted_group_id }.first
            self.admin = group.present? && group['administrator']
            group.present?
          end
        end

        private
        def set_credentials(credentials)
          self.oauth_token = credentials.token  
          self.oauth_expires_at =  Time.at credentials.expires_at || Time.now
        end

        def set_info(info)
          self.email = info.email
          self.name = info.name
          self.facebook_verified = info.verified || false
        end
        
        def set_extra_raw_info(raw_info)
          self.username =  raw_info.username
          self.gender = raw_info.gender  
          self.bio = raw_info.bio 
          self.languages = raw_info.languages|| []#{}
        end

        def set_extra_raw_info_special_permissions(raw_info)
          self.birthday = Date.strptime(raw_info.birthday, "%m/%d/%Y").at_midnight if raw_info.birthday
          self.work = raw_info.work || []#{}
          self.education = raw_info.education || []#{}
        end

        def set_permissions
           facebook do |fb|
            self.facebook_permissions = fb.get_connections('me', 'permissions')[0]
          end
        end
      end

      module ClassMethods
        def from_omniauth(auth, current_identity)
          user,admin_password = nil,nil
          if current_identity.blank?
            user = where(auth.slice(:provider, :uid)).first_or_initialize
            admin_password = Identity.find(auth[:uid]).admin_password if auth.provider == "identity"
          else
            user = current_identity
          end
          return nil if user.new_record? && !user.has_access?
            user.provider = auth.provider
            user.uid = auth.uid
            user.email = auth.email
            user.admin_password = admin_password
            user.username = (auth.provider == "identity" ?  "identity_user" : "facebook_user")
            user.set_fields_from_omniauth auth
            user.login_count = user.login_count+ 1
            user.save!
            if user.login_count == 1 
              UserMailer.welcome_email(user, user.email, admin_password).deliver 
            end
            user 
        end
      end
    end
  end
end
