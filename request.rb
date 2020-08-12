require 'httparty'
require 'json'
require 'securerandom'

round = 0

loop do
  round += 1

  puts "\nround number: #{round}"

  threads = []
  result = Queue.new
  # simulate 5 concurrent users request to our service
  (1..5).each do |i|
    threads << Thread.new do
      begin
        unique_req_param = "#{i}_#{Time.now.to_i}"
        # replace this port with the kong proxy port
        response = HTTParty.get("http://localhost:50254/example/#{unique_req_param}")
        # check the response for each request
        if response.code == 200
          if unique_req_param != response.parsed_response
            result << "request #{unique_req_param} but response is #{response.parsed_response}, #{response.headers['hostname']} handled this req"
          else
            result << true
          end
        end
      rescue StandardError => e
        puts e
      end
    end
  end

  # wait for all jobs to complete
  threads.each(&:join)

  # loop over the result and print out the error
  abort_program = false
  until result.empty?
    cur_result = result.pop
    if cur_result != true
      puts "NOT OK #{cur_result}"
      abort_program = true
    end
  end

  break if abort_program
end
