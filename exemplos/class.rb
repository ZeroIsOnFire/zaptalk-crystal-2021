module Zaptalk
  class Parrot
    FRAME_TIME = 0.05

    def self.aviso
      puts "Iniciando festa..."
    end

    def initialize
      @frame = 0
    end

    def dance!
      loop do
        sleep FRAME_TIME
        system "clear"
        puts display_frame
        @frame = next_frame
      end
    end

    def current_frame
      @frame
    end

    def display_frame
      File.read("./assets/frames/#{@frame}.txt")
    end

    def next_frame
      @frame >= 9 ? 0 : @frame + 1
    end
  end

  class AlternateParrot < Parrot
    def next_frame
      @reverse ? (@frame -= 1) : (@frame += 1)
      @reverse = true if @frame >= 9
      @reverse = false if @frame <= 0
      @frame
    end
  end
end

my_parrot = Zaptalk::AlternateParrot.new
my_parrot.dance!
