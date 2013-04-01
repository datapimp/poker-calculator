require "spec_helper"

describe PokerCalculator::Hand do
  describe "Comparing hands" do
    let(:ace_high) { PokerCalculator::Hand.new("8c 9d 7d 3h As")}
    let(:king_high) { PokerCalculator::Hand.new("8c 9d 7d 3h Ks")}
    let(:eights) { PokerCalculator::Hand.new("8c 8d Ac Kd 2s") }
    let(:nines) { PokerCalculator::Hand.new("9c 9d Ac Kd 2s") }
    let(:trip_nines) { PokerCalculator::Hand.new("9c 9d 9s Kd 2s") }
    let(:trip_aces) { PokerCalculator::Hand.new("Ac Ad As Kd 2s") }
    let(:aces_and_deuces) { PokerCalculator::Hand.new("Ac Ad 2c 2d Kc") }
    let(:aces_and_queens) { PokerCalculator::Hand.new("Ac Ad Qc Qd Kc") }
    let(:kings_and_queens) { PokerCalculator::Hand.new("Kc Kd Qc Qd Ac") }
    let(:broadway) { PokerCalculator::Hand.new("Tc Jc Qd Ks Ac") }
    let(:wheel) { PokerCalculator::Hand.new("Ac 2d 3c 4s 5h") }
    let(:king_high_flush) { PokerCalculator::Hand.new("Kh Jh 9h 3h 6h") }
    let(:ace_high_flush) { PokerCalculator::Hand.new("Ah Jh 9h 3h 6h") }
    let(:kings_full) { PokerCalculator::Hand.new("Kh Kd Kc As Ad")}
    let(:kings_full_of_queens) { PokerCalculator::Hand.new("Kh Kd Kc Qs Qd")}
    let(:queens_full) { PokerCalculator::Hand.new("Qh Qd Qc As Ad")}
    let(:quad_deuces) { PokerCalculator::Hand.new("2c 2d 2s 2h Ah")}
    let(:quad_aces) { PokerCalculator::Hand.new("Ac Ad As Ah 2h")}
    let(:straight_flush) { PokerCalculator::Hand.new("4h 5h 6h 7h 8h") }
    let(:royal_flush) { PokerCalculator::Hand.new("Tc Jc Qc Kc Ac") }

    it "should know that a high card is beaten by a higher card" do
      ace_high.should_not be_beaten_by(king_high)
      king_high.should be_beaten_by(ace_high)
    end

    it "should know that a high card is beaten by a pair" do
      ace_high.should be_beaten_by(eights)
    end

    it "should know that a pair is beaten by a higher pair" do
      eights.should be_beaten_by(nines)
    end

    it "should know that kings and queens is beaten by aces and deuces" do
      kings_and_queens.should be_beaten_by(aces_and_deuces)
    end

    it "should know that aces and deuces is beaten by aces and queens" do
      aces_and_deuces.should be_beaten_by(aces_and_queens)
    end

    it "should know that two pair is beaten by trips" do
      aces_and_deuces.should be_beaten_by(trip_nines)
    end

    it "should know that trips is beaten by higher trips" do
      trip_nines.should be_beaten_by(trip_aces)
      trip_aces.should_not be_beaten_by(trip_nines)
    end

    it "should know that trips is beaten by a straight" do
      trip_nines.should be_beaten_by(broadway)
      broadway.should_not be_beaten_by(trip_nines)
    end

    it "should know that a straight is beaten by a higher straight" do
      wheel.should be_beaten_by(broadway)
      broadway.should_not be_beaten_by(wheel)
      broadway.should_not be_beaten_by(broadway)
    end

    it "should know that a king high flush is beaten by an ace high flush" do
      king_high_flush.should be_beaten_by(ace_high_flush)
    end

    it "should know that a flush is beaten by a full house" do
      ace_high_flush.should be_beaten_by(kings_full)
    end

    it "should know that a full house is beaten by a bigger full house" do
      queens_full.should be_beaten_by(kings_full)
      kings_full.should_not be_beaten_by(queens_full)
      kings_full_of_queens.should be_beaten_by(kings_full)
    end

    it "should know that full houses are beaten by quads" do
      quad_deuces.should_not be_beaten_by(kings_full)
      kings_full.should be_beaten_by(quad_deuces)
    end

    it "should know a bad beat when it sees one!" do
      quad_deuces.should be_beaten_by(quad_aces)
    end

    it "should know quads is beaten by a straight flush" do
      straight_flush.should_not be_beaten_by(quad_aces)
      quad_aces.should be_beaten_by(straight_flush)
    end

    it "should know a royal flush beats all" do
      straight_flush.should be_beaten_by(royal_flush)
    end
  end

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
      hand.should_not be_one_pair
      hand.should_not be_two_pair
      hand.should_not be_trips
      hand.should be_full_house
    end    
  end
end
