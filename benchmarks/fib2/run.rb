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
    `rm #{run_cmd}` unless @compile_cmd.empty?
  rescue StandardError  => ex
    puts ex.message
    puts ex.backtrace.inspect
  end
end

languages = [
  ["Crystal", "crystal build --release fib.rb", "./fib"],
  ["CR-u64", "crystal build --release fib_uint64.cr", "./fib_uint64"],
  ["CR-bigint", "crystal build --release fib_bigint.cr", "./fib_bigint"]
  # ["Ruby", "", "ruby fib.rb"]
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
