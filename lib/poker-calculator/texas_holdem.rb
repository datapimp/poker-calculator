module PokerCalculator
  class TexasHoldem

    def initialize(options={})
      @number_of_players = options[:number_of_players] || 9
      @players = {}
    end

    def simulate!
      deal
      flop
      turn
      river
      @hands = hands
    end

    def players
      @players
    end

    def deck
      @deck ||= PokerCalculator::Deck.new()
    end

    def completed_hands
      @hands
    end 

    def winners
      @rankings = {} 

      player_hands.map do |player|
        seat, hand = player
        @rankings[seat] = hands.index(hand)
      end      

      @rankings
    end

    def player_hands
      return @player_hands if @player_hands

      @player_hands = {} 
      
      players.map do |player|
        seat, hole_cards = player        
        @player_hands[seat] = PokerCalculator::Hand.new((community + hole_cards).map(&:to_s).join(" "))
      end

      @player_hands
    end 

    def hands
      return @hands if @hands

      @hands = player_hands.values
      @hands.sort! {|a,b| a <=> b}
      @hands.reverse!

      @hands
    end

    def deal
      @number_of_players.times do |seat|
        @players[seat] = []
        @players[seat] << deck.deal << deck.deal
      end
    end

    def burn
      deck.deal
    end

    def flop
      deal if @players.empty?
      @flop ||= 3.times.map { deck.deal }
    end

    def turn
      @turn ||= deck.deal
    end

    def river
      @river ||= deck.deal 
    end

    def community
      [@flop,@turn,@river].compact.flatten
    end

  end
end