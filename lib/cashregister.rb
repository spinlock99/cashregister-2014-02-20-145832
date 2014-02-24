class CashRegister
  def initialize(coins=[25,10,5,1])
    if coins.class != Array || coins.map do |coin|
      coin.class.ancestors.include?(Integer)
    end.include?(false)
      raise "CashRegister must be initialized with an Array of Integers"
    end

    @coins = coins

    @optimal_change = Hash.new do |hash, key|
      if key < coins.min
        hash[key] = Change.new(coins)
      elsif coins.include?(key)
        hash[key] = Change.new(coins).add(key)
      else
        possible_coins = Array.new(coins)
       # possible_coins.reject! { |coin| coin > key }

        #          possible_coins.reject! do |small_coin|
        #            coins.map do |large_coin|
        #              large_coin % small_coin == 0
        #            end.include?(true)
        #          end

        possible_change = possible_coins.sort.reverse.map do |coin|
          hash[key - coin].add(coin)
        end
        puts "key: #{key}"
puts "possible change: #{possible_change}"
        possible_change.reject! { |change| change.value != key }
puts "possible change filtered: #{possible_change}"

        puts "final answer: #{possible_change.min { |a, b| a.size <=> b.size }}"
        hash[key] = possible_change.min { |a, b| a.size <=> b.size } || Change.new(coins)
      end
    end
  end

  def make_change(amount)
    if !amount.class.ancestors.include?(Integer)
      raise "make_change() expects an Integer argument but received an argument of type #{amount.class}"
    end

    return(@optimal_change[amount])
  end
end

class Change < Hash
  def initialize(coins)
    coins.sort.reverse.map { |coin| self.merge!({coin.to_s => 0}) }
  end

  def add(coin)
    self.merge({coin.to_s => self[coin] + 1})
  end

  def value
    value_of_change = 0
    self.each do |key, value|
      value_of_change += key.to_i * value
    end
    return(value_of_change)
  end

  def size
    self.values.inject(:+)
  end
end
