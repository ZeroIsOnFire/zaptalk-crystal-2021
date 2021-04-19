def show_frame(frame)
  sleep 0.05
  system "clear"
  puts File.read("./assets/frames/#{frame}.txt")
end

loop do
  10.times { |frame| show_frame(frame) }
end