spawn do
  loop do
    10.times do |frame|
      sleep 0.05
      system "clear"
      puts File.read("./assets/frames/#{frame}.txt")
    end
  end
end

channel = Channel(Bool).new

spawn do
  loop do
    sleep 5
    channel.send Random.new.next_bool
  end
end

loop do
  stop_the_party = channel.receive
  break if stop_the_party
end

puts "Acabou :("
