module PokerCalculator
  class Hand
    attr_accessor :cards

    def initialize cards="", options={}
      if cards.is_a?(Hash) 
        options = cards
        cards   = Array(options[:cards])
      end

      if cards.is_a?(String)
        @cards = cards.split(' ').map {|card| PokerCalculator::Card.new(card)}
      end

      @cards.sort_by!(&:rank)
      @cards.reverse! 
    end

    def ranking
      return :straight_flush if straight_flush?
      return :four_of_a_kind if four_of_a_kind?
      return :flush if flush?
      return :straight if straight?
      return :three_of_a_kind if three_of_a_kind?
      return :two_pair if two_pair?
      return :one_pair if one_pair?
      return :high_card
    end

    def to_s
      cards.map(&:to_s)
    end

    def high_card
      cards.first
    end

    def count_by_suit
      @by_suit ||= cards.inject({}) do |memo,card|
        memo[card.suit] ||= 0
        memo[card.suit] += 1
        memo
      end
    end

    def count_by_rank
      @by_rank ||= cards.inject({}) do |memo,card|
        memo[card.rank] ||= 0
        memo[card.rank] += 1
        memo
      end
    end 

    def ranks
      count_by_rank.keys
    end

    def one_pair?
      count_by_rank.values.include?(2)
    end

    def two_pair?
      counts = count_by_rank.values.select {|v| v == 2}
      counts.length >= 2
    end

    def three_of_a_kind?
      count_by_rank.values.include?(3)
    end

    def straight?
      return true if wheel?

      diffs = []

      ranks.each_cons(2) do |a,b|
        diffs << a - b
      end

      diffs.uniq == [1]
    end

    def flush?
      count_by_suit.values.any? {|v| v >= 5}
    end

    def full_house?
      values = count_by_rank.values
      values.include?(2) && values.include?(3)
    end

    def four_of_a_kind?
      count_by_rank.values.include?(4)
    end

    def quads?
      four_of_a_kind?
    end

    def trips?
      three_of_a_kind?
    end

    def straight_flush?
      straight? && flush?
    end

    def wheel?
      (ranks & [13,2,3,4,1]).length >= 5
    end

  end
end