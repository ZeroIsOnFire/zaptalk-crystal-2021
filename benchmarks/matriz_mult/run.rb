SIZE = 1000

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
    `rm #{run_cmd.split(' ').first}` unless @compile_cmd.empty?
  rescue StandardError  => ex
    puts ex.message
    puts ex.backtrace.inspect
  end
end

languages = [
  ["CR-ST", "crystal build --no-debug --release matmul.cr", "./matmul #{SIZE}"],
  ["CR-FB", "crystal build --no-debug --release matmul_mt.cr", "./matmul_mt #{SIZE}"],
  ["CR-FBMT2", "crystal build --no-debug --release -Dpreview_mt matmul_mt.cr", "./matmul_mt #{SIZE} 1"],
  ["CR-FBMT4", "crystal build --no-debug --release -Dpreview_mt matmul_mt.cr", "./matmul_mt #{SIZE} 3"],
  ["CR-FBMT6", "crystal build --no-debug --release -Dpreview_mt matmul_mt.cr", "./matmul_mt #{SIZE} 5"],
  ["CR-FBMT8", "crystal build --no-debug --release -Dpreview_mt matmul_mt.cr", "./matmul_mt #{SIZE} 7"],
  ["CR-FBMT10", "crystal build --no-debug --release -Dpreview_mt matmul_mt.cr", "./matmul_mt #{SIZE} 9"],
  ["CR-FBMT12", "crystal build --no-debug --release -Dpreview_mt matmul_mt.cr", "./matmul_mt #{SIZE} 11"],
  ["Ruby", "", "ruby matmul.rb #{SIZE}"]
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
