require "spec_helper"

describe PokerCalculator::TexasHoldem do
  let(:game) { PokerCalculator::TexasHoldem.new(:players=>9) } 

  it "should have a deck with 52 cards" do
    game.deck.cards.length.should == 52
  end

  it "should deal a flop by burning a card and dealing 3 to the community" do
    game.flop
    game.community.length.should == 3
  end

  it "should deal a turn card" do
    game.flop
    game.turn
    game.community.length.should == 4
  end

   it "should deal a river card" do
    game.flop
    game.turn
    game.river
    game.community.length.should == 5
  end 

  it "should deal hole cards to players" do
    game.deal
    binding.pry
  end
end