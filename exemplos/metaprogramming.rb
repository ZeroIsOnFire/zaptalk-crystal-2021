def define_methods(hash)
  hash.each do |key, value|
    define_method key do |numero|
      value * numero
    end
  end
end

define_methods({ dobro: 2, triplo: 3 })

puts "O dobro de 3 é #{dobro(3)}"
puts "O triplo de 3 é #{triplo(3)}"