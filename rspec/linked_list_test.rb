require 'rspec'
require_relative '../lists/linked_list'
require_relative '../sorting_type'

describe LinkedList do
  before do
    @list = LinkedList.new(1,2,3,4,5)
  end

  describe "clear" do
    it "clear should empty the list" do
      @list.clear
      expect(@list.empty?).to be true
    end
  end

  describe "empty?" do
    it "should be empty after a clear" do
      @list.clear
      expect(@list.empty?).to be true
    end
  end

  describe "include?" do
    it "include? should return true if the value is in the list" do
      expect(@list.include?(2)).to be true
      expect(@list.include?(6)).to be false
    end
  end

  describe "include_all?" do
    it "include_all? should return true if all of the values are in the list" do
      values = [2,4]
      expect(@list.include_all?(values)).to be true
      values << 6
      expect(@list.include_all?(values)).to be false
    end
  end

  describe "length" do
    it "length should be 5" do
      expect(@list.length).to eq(5)
    end
  end

  describe "push" do
    it "pushes values to the front of the list" do
      @list.push(6)
      expect(@list.length).to eq(6)
      expect(@list.first).to eq(6)
    end
  end

  describe "pop" do
    it "pop should remove the first value" do
      @list.pop
      expect(@list.length).to eq(4)
      expect(@list.first).to eq(2)
      @list.clear
      expect{ @list.pop }.to raise_error(NoSuchElementError)
    end
  end

  describe "peek" do
    it "peek should return the first value" do
      expect(@list.peek).to eq(1)
      @list.clear
      expect{ @list.peek }.to raise_error(NoSuchElementError)
    end
  end

  describe "fetch" do
    it "fetch should return the value at the specified index in the list" do
      expect(@list.fetch(2)).to eq(3)
      expect{ @list.fetch(-1) }.to raise_error(IndexError)
      expect{ @list.fetch(@list.length) }.to raise_error(IndexError)
      @list.clear
      expect{ @list.fetch(1) }.to raise_error(IndexError)
    end
  end

  describe "fetch_or_nil" do
    it "fetch_or_nil should return the values at the specified index in the list or nil if it is out of bounds or the list is empty" do
      expect(@list.fetch_or_nil(2)).to eq(3)
      expect(@list.fetch_or_nil(-1).nil?).to be true
      expect(@list.fetch_or_nil(@list.length).nil?).to be true
      @list.clear
      expect(@list.fetch_or_nil(0).nil?).to be true
    end
  end



  describe "first" do
    it "first should return the first value" do
      expect(@list.first).to eq(1)
      @list.clear
      expect{ @list.first }.to raise_error(NoSuchElementError)
    end
  end

  describe "first_or_nil" do
    it "first_or_nil should return the first value if the list is not empty and nil otherwise" do
      expect(@list.first_or_nil.nil?).to be false
      @list.clear
      expect(@list.first_or_nil.nil?).to be true
    end
  end

  describe "last" do
    it "last should return the last value" do
      expect(@list.last).to eq(5)
      @list.clear
      expect{ @list.last }.to raise_error(NoSuchElementError)
    end
  end

  describe "append" do
    it "append should append a value to the end of the list" do
      @list.append(6)
      expect(@list.length).to eq(6)
      expect(@list.last).to eq(6)
    end
  end

  describe "<<" do
    it "<< should append a value to the end of the list" do
      @list << 6
      expect(@list.last).to eq(6)
      expect(@list.length).to eq(6)
    end
  end

  describe "add_all" do
    it "add_all should append all values to the end of the list" do
      values = [6,7,8]
      @list.add_all(values)
      expect(@list.include_all?(values)).to be true
      expect(@list.last).to eq(8)
      expect(@list.length).to eq(8)
    end
  end

  describe "add_all_with_index" do
    it "add_all_with_index should append all values to the value of the index argument" do
      values = [6,7,8]
      @list.add_all_with_index(2, values)
      expect(@list.fetch(2)).to eq(6)
      expect(@list.include_all?(values)).to be true
      expect(@list.length).to eq(8)

      @list.add_all_with_index(0, values)
      expect(@list.first).to eq(6)
      expect{ @list.add_all_with_index(-1, 10) }.to raise_error(IndexError)
      expect{ @list.add_all_with_index(@list.length, 10) }.to raise_error(IndexError)
      @list.clear
      expect{ @list.add_all_with_index(1, 10) }.to raise_error(IndexError)
    end
  end

  describe "insert" do
    it "should add the value at the value of the index argument" do
      value = 6
      @list.insert(2, value)
      expect(@list.fetch(2)).to eq(6)
      expect(@list.fetch(3)).to eq(3)
      expect(@list.length).to eq(6)
      expect{ @list.insert(-1, 10) }.to raise_error(IndexError)
      expect{ @list.insert(@list.length, 10) }.to raise_error(IndexError)
      @list.clear
      expect{ @list.insert(1, 10) }.to raise_error(IndexError)
    end
  end

  describe "delete" do
    it "delete should remove the first occurrence of the value from the list" do
      @list.delete(3)
      expect(@list.length).to eq(4)
      expect(@list.include?(3)).to be false
    end
  end

  describe "delete_all" do
    it "delete_all should remove all values from the list" do
      values = [2,4]
      expect(@list.include_all?(values)).to be true
      @list.delete_all(values)
      expect(@list.length).to eq(3)
      expect(@list.include_all?(values)).to be false
    end
  end

  describe "delete_if" do
    it "delete_if should remove all values return true when passed to the predicate block" do
      @list.delete_if { |value| value % 2 == 0 }
      expect(@list.length).to eq(3)
      values = [2,4]
      expect(@list.include_all?(values)).to be false
    end
  end

  describe "delete_at" do
    it "delete_at should remove the value at the index" do
      @list.delete_at(2)
      expect(@list.fetch(2)).to eq(4)
      expect(@list.include?(3)).to be false
      expect(@list.length).to eq(4)
      expect{ @list.delete_at(-1) }.to raise_error(IndexError)
      expect{ @list.delete_at(@list.length) }.to raise_error(IndexError)
      @list.clear
      expect{ @list.delete_at(1) }.to raise_error(IndexError)
    end
  end

  describe "max" do
    it "max should return the maximum value" do
      expect(@list.max).to eq(5)
      @list.clear
      expect{ @list.max }.to raise_error(NoSuchElementError)
    end
  end

  describe "max_or_nil" do
    it "max_or_nil should return the maximum value or nil if the list is empty" do
      expect(@list.max_or_nil).to eq(5)
      @list.clear
      expect(@list.max_or_nil.nil?).to be true
    end
  end

  describe "min" do
    it "min should return the minimum value" do
      expect(@list.min).to eq(1)
      @list.clear
      expect{ @list.min }.to raise_error(NoSuchElementError)
    end
  end

  describe "min_or_nil" do
    it "min_or_nil should return the minimum value of the list or nil if empty" do
      expect(@list.min_or_nil).to eq(1)
      @list.clear
      expect(@list.min_or_nil.nil?).to be true
    end
  end

  describe "find_index" do
    it "find_index should return the index of the first occurrence of a value" do
      expect(@list.find_index(3)).to eq(2)
      expect(@list.find_index(6)).to eq(-1)
    end

    describe "find_last_index" do
      it "find_last_index should return the last occurrence of a value" do
        @list << 1
        expect(@list.find_last_index(1)).to eq(5)
        expect(@list.find_last_index(6)).to eq(-1)
      end
    end
  end

  describe "zip" do
    it "zip should return a list of pair objects that is the length of the shortest list" do
      values = ["a", "b", "c"]
      pairs = @list.zip(values)
      expect(pairs.length).to eq(3)
    end
  end

  describe "flat_map" do
    it "flat_map should take a list of values and return a list of new values that are either of a new type or the same" do
      list = LinkedList.new(Box.new(1,2,3), Box.new(4,5,6))
      values = list.flat_map{ |box| box.values }
      expect(values.length).to eq(6)

    end
  end

  describe "map" do
    it "map should return a list of new values that are transformed by the transform block" do
      values = @list.map{ |value| value + 1}

      value = 2

      values.each do |v|
        expect(v == value).to be true
        value += 1
      end
    end
  end

  describe "fold" do
    it "fold should take an accumulator and apply the operation block to each value and adjust the accumulator" do
      total = @list.fold(0){ |acc, value| acc + value}
      expect(total).to eq(15)
    end
  end

  describe "filter" do
    it "filter should return a new list with all values that evaluate to true when passed to the predicate to be removed" do
      list = @list.filter{ |value| value % 2 == 0 }
      expect(list.length).to eq(3)
    end
  end

  describe "reversed" do
    it "reversed should return a new list with all of the same values in reverse" do
      list = @list.reversed
      expect(list.fetch(0)).to eq(5)

    end
  end

  describe "take" do
    it "take should return a new list containg the first n values" do
      list = @list.take(3)
      expect(list.length).to eq(3)
      values = [1,2,3]
      expect(list.include_all?(values)).to be true
      expect{ list.take(-1) }.to raise_error(ArgumentError)
    end
  end

  describe "drop" do
    it "drop should return a new list with n number of values removed from the end of the new list" do
      list = @list.drop(2)
      expect(list.length).to eq(3)
      values = [1,2,3]
      expect(list.include_all?(values)).to be true
      expect{ list.drop(-1) }.to raise_error(ArgumentError)
    end
  end

  describe "slice" do
    it "slice should return a new list starting at the start index and ending at the end index of the original list" do
      slice = @list.slice(Range.new(1,3))
      expect(slice.length).to eq(3)
      expect(slice.first).to eq(2)
      expect(slice.last).to eq(4)
    end
  end

  describe "chunked" do
    it "chunked should return a list of lists that are the size of n" do
      chunks = @list.chunked(2)
      expect(chunks.length).to eq(3)
      expect(chunks.first.length).to eq(2)
      expect(chunks.last.length).to eq(1)
    end
  end

  describe "chunked_map" do
    it "chunked_map should perform a transformation on each value in the list and return a list that contains the same number of lists as n" do
      chunks = @list.chunked_map(5){|value| value.to_s }
      expect(chunks.length).to eq(1)
      expect(chunks.first.length).to eq(5)

      chunks = @list.chunked_map(2){|value| value.to_s }
      expect(chunks.length).to eq(3)
      expect(chunks.first.length).to eq(2)
      expect(chunks.last.length).to eq(1)
      expect(chunks.first.first).to eq("1")
    end
  end

  describe "count_occurrences" do
    it "returns number of occurrences of the value in the list" do
      @list << 1
      expect(@list.count_occurrences(1)).to eq(2)
    end
  end

  describe "count" do
    it "count_occurrences_with_predicate should return the number of times the predicate evaluates to true" do
      count = @list.count_occurrences_with_predicate{ |value| value % 2 == 0}
      expect(count).to eq(2)
    end
  end

  describe "set" do
    it "set should replace the value at the index given with the new value" do
      @list.set(2, 10)
      expect(@list.fetch(2)).to eq(10)
    end
  end

  describe "retain_all" do
    it "retain_all should remove all values from the list that are not in the values argument" do
      values = [1,3,5]
      @list.retain_all(values)
      expect(@list.length).to eq(3)
      expect(@list.include_all?(values))
    end
  end

  describe "from_array" do
    it "from_array should return a new LinkedList object with values from the array argument" do
      values = [1,2,3]
      list = LinkedList.from_array(values)
      expect(list.length).to eq(3)
    end
  end

  describe "selection_sort" do
    it "selection_sort should sort the list's values in ascending order or descending if specified" do
      values = [4,5,3,1,2]
      list = LinkedList.from_array(values)
      list.selection_sort!
      value = 1
      list.each do |v|
        expect(value == v).to be true
        value += 1
      end
      list.selection_sort!(SortingType::DESCENDING)
      value = 5
      list.each do |v|
        expect(value == v).to be true
        value -= 1
      end
    end
  end

  describe "to_s" do
    it "to_s should return a comma separated list of the values in brackets" do
      string = "[1, 2, 3, 4, 5]"
      expect(@list.to_s).to eq(string)
      @list.clear
      expect(@list.to_s).to eq("")
    end
  end

  describe "copy" do
    it "copy should return an identical list to the one copied" do
      expect(@list.copy.eql?(@list)).to be true
    end
  end

  describe "any?" do
    it "any? should return true if the predicate block evalutes to true with any value in the list" do
      expect(@list.any?{|value| value % 2 == 0 }).to be true
    end
  end

  describe "bubble_sort" do
    it "bubble_sort should sort the list's values in either ascending order or descending order" do
      list = LinkedList.new(3,1,4,5,2)
      expect(list.length).to eq(5)
      list.bubble_sort
      value = 1
      list.each do |v|
        expect(v).to eq(value)
        value += 1
      end

      list = LinkedList.new(3,1,4,5,2)
      list.bubble_sort(SortingType::DESCENDING)
      value = 5
      list.each do |v|
        expect(v).to eq(value)
        value -= 1
      end
    end
  end

  describe "last_with_predicate" do
    it "last_with_predicate should return the last value of the list that evalutes to true when passed to the predicate" do
      expect(@list.last_with_predicate{|value| value % 2 == 0 }).to eq(4)
      expect{ @list.last_with_predicate{|value| value > 6 }}.to raise_error(NoSuchElementError)
    end
  end

  describe "map_indexed" do
    it "map_indexed transforms the values in list starting from the index passed as an argument to the end of the list" do
      values = @list.map_indexed(2){|value| value + 1}
      value = 4
      values.each do |v|
        expect(v).to eq(value)
        value += 1
      end

      expect{ @list.map_indexed(-1){|value| value}}.to raise_error(IndexError)
      expect{ @list.map_indexed(@list.length){|value| value}}.to raise_error(IndexError)
      @list.clear
      expect{ @list.map_indexed(0){|value| value}}.to raise_error(IndexError)
    end
  end

  describe "join_to_string" do
    it "join_to_string should return a list separated by a separator argument and enclosed in prefix and postfix arguments. The string is transformed from the value provided to the transform block" do
      string = @list.join_to_string{|value| value.to_s}
      expect(string).to eq("[1 2 3 4 5]")

      string = @list.join_to_string(separator = ","){|value| value.to_s}
      expect(string).to eq("[1,2,3,4,5]")

      string = @list.join_to_string(separator = " ", prefix = "{", postfix = "}"){|value| value.to_s}
      expect(string).to eq("{1 2 3 4 5}")
    end
  end

  describe "take_while" do
    it "take_while adds iterates over the list and adds the values to the new list until the predicate returns false" do
      values = @list.take_while{|value| value < 4 }
      expect(values.length).to eq(3)

      value = 1

      values.each do |v|
        expect(v).to eq(value)
        value += 1
      end
    end
  end

  describe "+" do
    it "+ operator should add another list to itself" do
      @list + [6,7,8,9,10]
      expect(@list.length).to eq(10)
      expect(@list.last).to eq(10)
    end
  end

  describe "fetch_or_else" do
    it "fetch_or_else should return the value at the index or the default value if the index is out of bounds" do
      value = @list.fetch_or_else(10, 10)
      expect(value).to eq(10)

      value = @list.fetch_or_else(10, 2)
      expect(value).to eq(3)
    end
  end

  describe "drop_while" do
    it "drop_while should drop values until the predicate evaluates to false starting from the beginning of the list" do
      values = @list.drop_while{|value| value < 3 }
      expect(values.length).to eq(3)
    end
  end

  describe "-" do
    it "- operator should subtract a list from another list. It will remove all of the values that it contains." do
      @list - [2,4]
      expect(@list.length).to eq(3)
      expect(@list.include_all?([2,4]))
    end
  end
end

class Box
  attr_accessor :values

  def initialize(*values)
    @values = []
    values.each do |value|
      @values << value
    end
  end
end