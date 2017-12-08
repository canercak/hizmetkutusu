
SimpleConfig.for :application do
  group :facebook do
    set :cache_expiry_time, 1.minute
  end
end
