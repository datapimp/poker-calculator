module PokerCalculator
  class Deck
    attr_reader :cards

    def initialize    
      @cards = []

      Card::Suits.keys.each do |suit|
        Card::Values.each do |value|
          @cards << PokerCalculator::Card.new("#{ value }#{ suit }")
        end
      end

      shuffle!
    end

    def shuffle!
      @cards.shuffle!
      @cards
    end

    def deal
      @cards.pop
    end

    def remove specific
      specific = PokerCalculator::Card.new(specific) unless specific.is_a?(PokerCalculator::Card)
      @cards.reject! {|card| card == specific}
      specific
    end
  end
end