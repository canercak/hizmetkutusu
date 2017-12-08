object @quote

attributes :id, :description, :verification_code
node(:url) { |quote| quote_url(quote) }
child :user do
  attributes :name, :uid, :to_param, :profile_picture, :facebook_verified
end
