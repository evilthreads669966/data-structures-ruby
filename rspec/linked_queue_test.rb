require_relative '../queues/linked_queue'

describe LinkedQueue do
  before do
    @queue = LinkedQueue.new
    @queue.enqueue(1)
    @queue.enqueue(2)
    @queue.enqueue(3)
    @queue.enqueue(4)
    @queue.enqueue(5)
  end

  describe "enqueue" do
    it "enqueue should add a value to the end of the queue" do
      @queue.enqueue(6)
      expect(@queue.length).to eq(6)
      expect(@queue.last).to eq(6)
    end
  end

  describe "dequeue" do
    it "dequeue should remove and return the value at the front of the queue or nil if empty" do
      expect(@queue.dequeue).to eq(1)
      expect(@queue.dequeue).to eq(2)

      @queue.clear
      expect(@queue.dequeue).to be nil
    end
  end

  describe "peek" do
    it "peek should return the value at the front of the queue or nil if empty" do
      expect(@queue.peek).to eq(1)

      @queue.clear
      expect(@queue.peek).to be nil
    end
  end

  describe "length" do
    it "length should return the total number of values in the queue" do
      expect(@queue.length).to eq(5)
      @queue.dequeue
      expect(@queue.length).to eq(4)
      @queue.enqueue(6)
      expect(@queue.length).to eq(5)
      @queue.clear
      expect(@queue.length).to eq(0)
    end
  end

  describe "empty?" do
    it "empty? should return true if there are no values in the queue" do
      expect(@queue.empty?).to be false
      @queue.clear
      expect(@queue.empty?).to be true
    end
  end

  describe "clear" do
    it "clear should remove all values from the queue" do
      expect(@queue.empty?).to be false
      @queue.clear
      expect(@queue.empty?).to be true
    end
  end

  describe "include?" do
    it "include? should return true if the value is in the queue" do
      expect(@queue.include?(3)).to be true
      expect(@queue.include?(6)).to be false
    end
  end

  describe "include_all?" do
    it "include_all? should return true if all values are in the queue" do
      values = [1,3,5]
      expect(@queue.include_all?(values)).to be true
      values << 6
      expect(@queue.include_all?(values)).to be false
    end
  end

  describe "to_s" do
    it "to_s should return a string representation of the queue" do
      string = "[1 2 3 4 5]"
      expect(@queue.to_s).to eq(string)
    end
  end

  describe "each" do
    it "each should yield each value in the queue" do
      q = LinkedQueue.new
      @queue.each do |value|
        q.enqueue(value)
      end

      expect(@queue.eql?(q)).to be true
    end
  end

  describe "eql?" do
    it "eql? should return true if both queues have the same values in the same order" do
      q = LinkedQueue.new
      @queue.each do |value|
        q.enqueue(value)
      end

      expect(@queue.eql?(q)).to be true

      q.enqueue(6)
      expect(@queue.eql?(q)).to be false
    end
  end
end