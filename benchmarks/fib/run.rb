class Language
  attr_accessor :name, :compile_cmd, :run_cmd, :compile_time, :run_time
  def initialize(name, compile_cmd, run_cmd)
    @name = name
    @compile_cmd = compile_cmd
    @run_cmd = run_cmd
    @run_time = 0
  end

  def run
    unless compile_cmd.empty?
      raise "compile failed" unless system("#{compile_cmd} 2>/dev/null")
    end

    times = `{ bash -c "time #{run_cmd}" ; } 2>&1`.split("\n")[2].split("\t")[1].split(/[ms]/)
    @run_time = (times[0].to_i * 60) + times[1].gsub(',', '.').to_f
    `rm ./fib` if run_cmd == "./fib"
  rescue StandardError  => ex
    puts ex.message
    puts ex.backtrace.inspect
  end
end

languages = [
  ["C", "gcc -fno-inline-small-functions -O3 -o fib fib.c", "./fib"],
  ["C++", "g++ -fno-inline-small-functions -O3 -o fib fib.cpp", "./fib"],
  ["Rust", "rustc -C opt-level=3 fib.rs", "./fib"],
  ["Crystal", "crystal build --release fib.cr", "./fib"],
  ["Go", "go build fib.go", "./fib"],
  ["Java", "javac Fib.java", "java Fib"],
  ["Node", "", "node fib.js"],
  ["Elixir", "", "elixir fib.exs"],
  ["Ruby", "", "ruby fib.rb"],
  ["Python", "", "python3 fib.py"]
].map { |lang| Language.new(*lang) }

begin
  languages.each do |lang|
    puts "Running #{lang.name}"
    lang.run
  end
rescue Interrupt
end

puts "\n"*2

puts "Language |    Time"
languages.sort_by {|l| l.run_time}.each do |lang|
  puts "#{lang.name.ljust(9, " ")}|#{("%.3f" % lang.run_time).rjust(8, " ")}"
end
