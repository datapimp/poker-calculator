require "spec_helper"

describe PokerCalculator::Card do

  let(:ace_of_hearts) {
    PokerCalculator::Card.new("Ah")        
  }

  let(:king_of_hearts) {
    PokerCalculator::Card.new("Kh")
  }

  let(:king_of_diamonds) {
    PokerCalculator::Card.new("Kd")
  }

  it "should recognize a card of a higher value" do
    ace_of_hearts.should > king_of_hearts
  end

  it "should recognize a card of a lesser value" do
    king_of_hearts.should < ace_of_hearts
  end

  it "should recognize a card of the same value" do
    king_of_hearts.should == king_of_diamonds
  end

  it "should recognize a card of a similar suit" do
    ace_of_hearts.same_suit_as?(king_of_hearts).should be_true
    ace_of_hearts.same_suit_as?(king_of_diamonds).should_not be_true
  end

  it "should be creatable by a string" do  
    ace_of_hearts.suit_name.should == "Hearts"
    ace_of_hearts.rank.should == 13
    ace_of_hearts.value.should == "A"
  end
end