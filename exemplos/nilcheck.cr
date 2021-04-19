puts "String para dar upcase".upcase
puts nil.try(&.upcase)

hash = { teste: 12 }

puts hash[:teste]
puts hash[:vazio]?
