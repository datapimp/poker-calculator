require "spec_helper"

describe PokerCalculator::Hand do
  describe "Identifying hands" do
    it "should automatically sort the cards by rank in descending order" do 
      hand = PokerCalculator::Hand.new("2c 8c 5c 3d Ah")    
      hand.cards.collect(&:value).should == ["2","3","5","8","A"].reverse
    end

    it "should recognize an ace high hand" do
      hand = PokerCalculator::Hand.new("Ah 2d 5c 8d 9h")
      hand.ranking.should == :high_card
      hand.high_card.should == "Ah"
    end

    it "should recognize straight hands" do
      hand = PokerCalculator::Hand.new("2d 3h 4d 5c 6h")
      hand.should be_straight
    end

    it "should recognize straight hands" do
      hand = PokerCalculator::Hand.new("2d 3h 4d 5c 7h")
      hand.should_not be_straight
    end

    it "should recognize straight flush hands" do
      hand = PokerCalculator::Hand.new("2h 3h 4h 5h 6h")
      hand.should be_straight_flush
    end

    it "should recognize the wheel" do
      hand = PokerCalculator::Hand.new("Ac 2d 3h 4d 5c")
      hand.should be_wheel
      hand.should be_straight
    end

    it "should recognize flush hands" do
      hand = PokerCalculator::Hand.new("As Ks Qs Js 9s")
      hand.should be_flush
    end

    it "should recognize one pair hands" do
      hand = PokerCalculator::Hand.new("8s 8c Ad Kd Qd")
      hand.should be_one_pair
    end

    it "should recognize two pair hands" do
      hand = PokerCalculator::Hand.new("8s 8c Ad Ac Qd")
      hand.should be_two_pair
    end

    it "should recognize three of a kind hands" do
      hand = PokerCalculator::Hand.new("8s 8c 8d Ac Qd")
      hand.should be_three_of_a_kind
    end

    it "should recognize four of a kind hands" do
      hand = PokerCalculator::Hand.new("8s 8c 8d 8h Qd")
      hand.should be_four_of_a_kind
    end

    it "should recognize a full house" do
      hand = PokerCalculator::Hand.new("8s 8c 8d Qh Qd")
      hand.should be_full_house
    end    
  end
end