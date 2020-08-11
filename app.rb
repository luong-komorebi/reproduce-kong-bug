require 'sinatra'
require 'socket'

set :bind, '0.0.0.0'

healthy = true
request_num = 0
hostname = Socket.gethostname

Signal.trap('TERM') do
  puts 'Sleep 1 secs before dying'
  sleep 1
end

# simple echo server with a header returning the hostname
get '/example/:example_name' do
  request_num += 1
  headers \
    'HOSTNAME' => hostname

  body params[:example_name].to_s
end

get '/healthy' do
  # simulate liveness check
  status 200 if healthy == true
  status 500 if healthy == false

  # adjust 3 to a higher or lower number of value to increase of decrease chance of restarts
  healthy = !(request_num % 3 == 1)
end
