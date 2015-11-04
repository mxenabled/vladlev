require 'spec_helper'

describe Vladlev do
  specify{ Vladlev.distance("hello", "hello").should equal(0) }
  specify{ Vladlev.distance("", "").should equal(0) }
  specify{ Vladlev.distance("hello", "jello").should equal(1) }
  specify{ Vladlev.distance("hella", "hello").should equal(1) }
  specify{ Vladlev.distance("hello", "jell").should equal(2) }
  specify{ Vladlev.distance("lo", "jello").should equal(3) }
  specify{ Vladlev.distance("jello", "lo").should equal(3) }
  specify{ Vladlev.distance("", "jello").should equal("jello".length) }
  specify{ Vladlev.distance("jello", "").should equal("jello".length) }
  specify{ Vladlev.distance("hello"*2, "jello"*2).should equal(2) }
  specify{ Vladlev.distance("hello"*2, "jelo"*2).should equal(4) }
  specify{ Vladlev.distance("hello"*2, "jell"*2).should equal(4) }
  specify{ Vladlev.distance("hello"*4, "jello"*4).should equal(4) }
  specify{ Vladlev.distance("hello"*8, "jello"*8).should equal(8) }  
  specify{ Vladlev.distance("hello"*16, "jello"*16).should equal(16) }
  specify{ Vladlev.distance("hello"*32, "jello"*32).should equal(32) }
  specify{ Vladlev.distance("hello"*64, "jello"*64).should equal(64) }
  specify{ Vladlev.distance("hello"*128, "jello"*128).should equal(128) }
  specify{ Vladlev.distance("hello"*256, "jello"*256).should equal(256) }
  specify{ Vladlev.distance("hello"*512, "jello"*512).should equal(512) }  
          
  describe "threshold" do 
    specify{ Vladlev.distance("hello"*100, "jello"*100, 10).should equal(500) }
    specify{ Vladlev.distance("hello"*100, "jello"*100, 99).should equal(500) }
    specify{ Vladlev.distance("hello"*100, "jello"*100, 100).should equal(100) }        
    specify{ Vladlev.distance("hello"*100, "jello"*100, 1000).should equal(100) }    
  end

  describe "long strings" do 
    specify{ Vladlev.distance("hello"*200, "jello"*200).should equal(200) }
    specify{ Vladlev.distance("hello"*500, "jello"*500).should equal(500) }
    specify{ Vladlev.distance("hello"*750, "jello"*750).should equal(750) }
    specify{ Vladlev.distance("hello"*950, "jello"*950).should equal(950) }    
  end

  describe "threshold long strings" do 
    specify{ Vladlev.distance("hello"*2000, "jello"*2000, 10).should equal(5*2000) }
    specify{ Vladlev.distance("hello"*5000, "jello"*5000, 10).should equal(5*5000) }
    specify{ Vladlev.distance("hello"*7500, "jello"*7500, 10).should equal(5*7500) }
    specify{ Vladlev.distance("hello"*9500, "jello"*9500, 10).should equal(5*9500) }    
  end

  describe "special chars" do 
    specify{ Vladlev.distance("*&^%$", "").should equal(5) }
    specify{ Vladlev.distance("", ",./>?").should equal(5) }
    specify{ Vladlev.distance('*&^%$+_=-)(*&^%$#@!~123456789', '*&^%$+_=-)(*&^%$#@!~').should equal(9) }
    specify{ Vladlev.distance('*&^%$+_=-)(*&^%$#@!~', "").should equal(20) }
  end

  describe "normalized distance" do
    specify{ expect(Vladlev.distance("cur", "cut", 10)).to eq(1) }
    specify{ expect(Vladlev.get_normalized_distance("hello", "hello")).to eq(0.0) }
    specify{ expect(Vladlev.get_normalized_distance("goodnight", "goodnite")).to eq(0.3333333432674408) }
    specify{ expect(Vladlev.get_normalized_distance("", "goodbye")).to eq(1.0) }
    specify{ expect(Vladlev.get_normalized_distance("goodbye", "")).to eq(1.0) }
    specify{ expect(Vladlev.get_normalized_distance("", "")).to eq(0.0) }
  end
  
  describe '#distance' do
    context "when given two strings to match" do
      it "returns the distance" do
        string1 = "lorem ipsum"
        string2 = "borem ipsum"
        described_class.distance(string1, string2).should eq(1)
      end
    end
  end
end
