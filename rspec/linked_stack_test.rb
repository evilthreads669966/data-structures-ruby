require 'rspec'
require_relative '../stacks/linked_stack'

describe LinkedStack do
  before do
    @stack = LinkedStack.new
    @stack.push(1)
    @stack.push(2)
    @stack.push(3)
    @stack.push(4)
    @stack.push(5)
  end

  describe "clear" do
    it "clear should remove all values from the stack" do
      @stack.clear
      expect(@stack.length).to eq(0)
    end
  end

  describe "empty?" do
    it "empty? should return true if there are no values in the stack" do
      expect(@stack.empty?).to be false
      @stack.clear
      expect(@stack.empty?).to be true
    end
  end

  describe "push" do
    it "push should add a value to the top of the stack" do
      @stack.push(6)
      expect(@stack.pop).to eq(6)
    end

    describe "pop" do
      it "pop should remove and return the value at the top of the stack" do
        expect(@stack.pop).to eq(5)

        @stack.clear
        expect{ @stack.pop }.to raise_error(NoSuchElementError)
      end
    end

    describe "peek" do
      it "peek should return the value at the top of the stack" do
        expect(@stack.peek).to eq(5)

        @stack.clear
        expect{ @stack.peek }.to raise_error(NoSuchElementError)
      end
    end

    describe "length" do
      it "length should return the number of values in the stack" do
        expect(@stack.length).to eq(5)
        @stack.push(6)
        expect(@stack.length).to eq(6)
        @stack.pop
        expect(@stack.length).to eq(5)
        @stack.clear
        expect(@stack.length).to eq(0)
      end
    end
  end

  describe "selection_sort" do
    it "selection_sort should sort the values in the stack in either ascending or descending order" do
      @stack.clear
      @stack.push(3)
      @stack.push(5)
      @stack.push(1)
      @stack.push(4)
      @stack.push(2)

      @stack.selection_sort

      for i in 5..1
        expect(@stack.pop).to eq(i)
      end
    end
  end

  describe "to_s" do
    it "to_s should return a string representation of the stack" do
      string = "[5 4 3 2 1]"
      expect(@stack.to_s).to eq(string)
    end
  end
end
