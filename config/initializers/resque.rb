 
uri =URI.parse(APP_CONFIG.redis.url)
 

#uri = URI.parse(URI.encode('redis://redistogo:867eeea8b42fdab5e5db5819bebd79ec@cod.redistogo.com:10431/')) #URI.parse(APP_CONFIG.redis.url)
 
REDIS = Redis.new(host: uri.host, port: uri.port, password: uri.password)
Resque.redis = REDIS if defined?(Resque)

# Web interface
if defined?(Resque::Server)
  Resque::Server.use(Rack::Auth::Basic) do |user_name, password|
    user_name == APP_CONFIG.resque.user_name
    password == APP_CONFIG.resque.password
  end
end
