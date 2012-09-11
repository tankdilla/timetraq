ENV["REDISTOGO_URL"] ||= "redis://darrellj:294aa35b4ede8789f4e6a0cdc78091df@barb.redistogo.com:9666/"

uri = URI.parse(ENV["REDISTOGO_URL"])
Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true)
Dir["/app/jobs/*.rb"].each { |file| require file }