require "big"

def fib(n : BigInt)
  return BigInt.new(1) if n <= 1
  fib(n - 1) + fib(n - 2)
end

puts fib(BigInt.new(47))
