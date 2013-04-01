require 'rubygems'
require 'pry'

module PokerCalculator
  class Hand
    attr_accessor :cards
	
    Rankings = [
      :high_card,
      :one_pair,
      :two_pair,
      :three_of_a_kind,
      :straight,
      :flush,
      :full_house,
      :four_of_a_kind,
      :straight_flush
    ]

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
      return :full_house if full_house?
      return :flush if flush?
      return :straight if straight?
      return :three_of_a_kind if three_of_a_kind?
      return :two_pair if two_pair?
      return :one_pair if one_pair?
      return :high_card
    end
    
    # pairs are beaten by higher pairs
    # trips are beaten by higher trips, etc
    def inner_ranking
      case ranking
      when :straight, :straight_flush
        Array(straight_high_card.rank)
      when :four_of_a_kind
        [high_group,kickers]
      when :full_house
        high = groups.detect {|v| v[1] == 3 }
        low  = groups.detect {|v| v[1] == 2 }
        [high[0],low[0]] 
      when :flush
        [high_card.rank, kickers].compact.flatten
      when :one_pair, :three_of_a_kind
        [high_group, kickers].compact.flatten
      when :two_pair
        Array([high_group, low_pair, kickers].compact.flatten)
      else
        [kickers]
      end.flatten
    end

    def beaten_by?(other) 
      other_rank_value = Rankings.index(other.ranking) 
      my_rank_value    = Rankings.index(self.ranking)

      return true if other_rank_value > my_rank_value
      
      if other_rank_value == my_rank_value
        inner_ranking.each_with_index do |rank,index|
          return true if other.inner_ranking[index] > rank
        end
      end 

      false
    end

    def <=>(other)
      return -1 if beaten_by?(other)
      return 1 if other.beaten_by?(self)
      return 0
    end

    def <(other)
      beaten_by?(other)
    end

    def >(other)
      other.beaten_by?(self)
    end

    def to_s
      cards.map(&:to_s)
    end

    def straight_high_card
      wheel? ? cards[1] : cards[0]
    end

    def high_card
      cards.first
    end

    def high_kicker
      kickers.max
    end

    def kicker_cards
      cards.select {|card| kickers.include?(card.rank) }
    end

    def kickers
      grouped = groups.collect(&:first)
      cards.reject {|card| grouped.include?(card.rank) }.collect(&:rank)
    end

    def pairs
      count_by_rank.to_a.select {|v| v[1] == 2}
    end

    def trips
      count_by_rank.to_a.select {|v| v[1] == 3}
    end

    def groups
      count_by_rank.to_a.select {|v| v[1] >= 2}.sort {|a,b| a[1]<=>b[1] }.reverse
    end

    def high_group
      groups.map(&:first).max
    end

    def high_pair
      pairs.map(&:first).max
    end

    def high_pair_cards
      cards.select {|card| card.rank == high_pair }
    end

    def low_pair
      pairs.map(&:first).sort.reverse[1]
    end

    def low_pair_cards
      cards.select {|card| card.rank == low_pair }
    end

    def sum_of_card_values 
      cards.inject(0) {|memo,card| memo += card.rank }
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
      values = count_by_rank.values
      counts = values.select {|v| v == 2}
      !values.include?(3) && values.include?(2) && counts.length == 1
    end

    def two_pair?
      values = count_by_rank.values
      counts = values.select {|v| v == 2}
      !values.include?(3) && counts.length == 2
    end

    def three_of_a_kind?
      values = count_by_rank.values
      counts = values.select {|v| v == 2}
      values.include?(3) && !values.include?(2)
    end

    def straight?
      return true if wheel?
      return false unless ranks.uniq.length == 5

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
