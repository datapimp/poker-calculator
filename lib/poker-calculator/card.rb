module PokerCalculator
  class Card
    attr_accessor :suit,
                  :value

    Suits = {
      "h" => "Hearts",
      "c" => "Clubs",
      "d" => "Diamonds",
      "s" => "Spades"
    }

    Values = %w{2 3 4 5 6 7 8 9 10 J Q K A} 

    InvalidCard = Class.new(Exception)

    def initialize identifier
      @value, @suit = identifier.each_char.to_a

      @suit.downcase!

      raise InvalidCard unless suit_name && rank >= 1 
    end

    def to_s
      "#{value}#{suit}"
    end

    def rank
      Values.index(self.value) + 1
    end

    def suit_name
      Suits[@suit]
    end

    def same_suit_as?(other)
      unless other.is_a?(PokerCalculator::Card)
        other = PokerCalculator::Card.new(other)
      end

      other.suit_name == self.suit_name
    end

    def ==(other)
      unless other.is_a?(PokerCalculator::Card)
        other = PokerCalculator::Card.new(other)
      end

      self.rank == other.rank
    end

    def same_value_as?(other)
      self.send(:==, other)
    end

    def ===(other)
      same_value_as?(other) && same_suit_as?(other)
    end

    def <(other)
      unless other.is_a?(PokerCalculator::Card)
        other = PokerCalculator::Card.new(other)
      end

      self.rank < other.rank
    end

    def >(other)
      unless other.is_a?(PokerCalculator::Card)
        other = PokerCalculator::Card.new(other)
      end

      self.rank > other.rank
    end
  end
end