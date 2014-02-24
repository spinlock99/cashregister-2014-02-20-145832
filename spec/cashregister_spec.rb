require 'spec_helper'
require 'cashregister'

describe CashRegister do
  describe "new" do
    it "should instantiate" do
      lambda {
        CashRegister.new
      }.should_not raise_exception
    end
    it "takes an array of integers" do
      expect { CashRegister.new([10,7,1]) }.to_not raise_exception
    end
    it "throws an error when given bad input" do
      expect { CashRegister.new(5) }.to raise_exception
      expect { CashRegister.new(["a", "b", "c"]) }.to raise_exception
    end
  end

  describe ".make_change" do
    subject(:make_change) { CashRegister.new(coins).make_change(amount) }
    let(:coins)  { [25,10,5,1] }
    let(:amount) { 123 }

    it { should eq({'25' => 4, '10' => 2, '5' => 0, '1' => 3}) }

    context 'with bad input' do
      let(:amount) { 'b' }

      specify { expect { make_change }.to raise_error }
    end

    context 'another example' do
      let(:amount) { 47 }
      it { should eq({'25' => 1, '10' => 2, '5' => 0, '1' => 2}) }
    end

    it 'should handle the base case' do
      CashRegister.new.make_change(25).should eq({'25' => 1, '10' => 0, '5' => 0, '1' => 0})
    end

    it 'should handle a simple case' do
      CashRegister.new.make_change(50).should eq({'25' => 2, '10' => 0, '5' => 0, '1' => 0})
    end

    context 'crazy foreign coins' do
      let(:coins)  { [10,7,1] }
      let(:amount) { 14 }

      it { should eq({'10' => 0, '7' => 2, '1' => 0}) }

      it 'works for the null case' do
        CashRegister.new([10,7,1]).make_change(0).should eq({'10' => 0, '7' => 0, '1' => 0})
      end

      it 'works for the base case' do
        CashRegister.new([10,7,1]).make_change(1).should eq({'10' => 0, '7' => 0, '1' => 1})
      end
    end
  end
end

describe Change do
  describe "#new" do
    subject(:change) { Change.new([25,10,5,1]) }

    specify { expect { change }.to_not raise_error }
    it { should eq({'25' => 0, '10' => 0, '5' => 0, '1' => 0}) }
  end

  describe ".add!" do
    let(:change) { Change.new([25,10,5,1]) }
    let(:coin) { 5 }

    it 'adds a coin to the pile of change' do
      change.add!(coin)
      change.should eq({'25' => 0, '10' => 0, '5' => 1, '1' => 0})
    end
  end

  describe ".value" do
    let(:change) { Change.new([25,10,5,1]) }

    it 'returns the value of the pile of change' do
      change.add!(25)
      change.add!(5)
      change.add!(1)
      change.value.should eq(31)
    end
  end

  describe ".size" do
    subject(:change) { Change.new([25,10,5,1]) }

    its(:size) { should eq(0) }
    it 'returns the right value' do
      change.add!(25)
      change.add!(25)
      change.add!(1)
      change.size.should eq(3)
    end
  end
end
