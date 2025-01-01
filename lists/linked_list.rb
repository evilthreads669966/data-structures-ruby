require 'set'
require_relative '../exceptions'
require_relative '../sorting_type'
require_relative '../node'

class LinkedList
  include Enumerable

  private
  attr :head, :tail

  public
  attr_reader :length

  def initialize(*values)
    @head = nil
    @tail = nil
    @length = 0

    values.each do |value|
      append(value)
    end
  end

  def self.from_array(array)
    list = LinkedList.new

    array.each do |value|
      list << value
    end

    list
  end

  def copy
    list = LinkedList.new
    list.add_all(self)

    list
  end

  def eql?(other)
    return false unless other.kind_of?(LinkedList)
    return false if @length != other.length

    curr = @head
    idx = 0
    while curr
      return false if other.fetch(idx) != curr.value

      curr = curr.next
      idx += 1
    end

    true
  end


  def empty?
    length == 0
  end

  def clear
    @head = nil
    @tail = nil
    @length = 0
  end

  def push(value)
    @length += 1
    node = Node.new(value)

    if @head.nil?
      @head = node
      @tail = node
      return
    end

    node.next = @head
    @head = node
  end

  def pop()
    raise NoSuchElementError.new if empty?

    @length -= 1
    value = @head.value
    @head = @head.next

    value
  end

  def peek
    raise NoSuchElementError.new if @head.nil?
    @head.value
  end

  def fetch(index)
    get_node(index).value
  end

  def fetch_or_nil(index)
    begin
      return fetch(index)
    rescue IndexError
      return nil
    end
  end

  def fetch_or_else(default_value, index)
    begin
      return fetch(index)
    rescue IndexError
      return default_value
    end
  end

  def set(index, value)
    get_node(index).value = value
    value
  end

  def delete(value)
    return false if self.empty?

    if @head.value == value
      pop
      return true
    end

    curr = @head.next
    prev = @head

    while curr
      if curr.value == value
        prev.next = curr.next
        @length -= 1

        unless prev.next
          @tail = prev
        end

        return true
      end

      prev = curr
      curr = curr.next
    end

    false
  end

  def delete_if(&predicate)
    removed = false

    return removed if empty?

    curr = @head
    prev = nil

    while curr
      if predicate.call(curr.value)
        curr = curr.next
        if prev.nil?
          @head = curr
        else
          prev.next = curr
        end

        removed = true
        @length -= 1

        unless curr
          @tail = prev
        end

        next
      end

      prev = curr
      curr = curr.next
    end

    removed
  end

  def delete_all(values)
    removed = false

    return removed if empty? || values.empty?

    return removed if @head.next.nil?

    curr = @head
    prev = nil

    while curr
      if values.include? curr.value
        curr = curr.next
        if prev.nil?
          @head = curr
        else
          prev.next = curr
        end

        unless curr
          @tail = prev
        end

        @length -= 1
        removed = true

        next
      end

      prev = curr
      curr = curr.next
    end

    removed
  end

  def delete_at(index)
    raise IndexError.new if empty? || index < 0 || index >= @length

    if @head.next.nil?
      value = @head.value
      @head = nil

      return value
    end

    curr = @head.next
    prev = @head
    idx = 1

    while curr
      if idx == index
        value = curr.value
        prev.next = curr.next
        @length -= 1

        unless prev.next
          @tail = prev
        end

        return value
      end

      idx += 1
      prev = curr
      curr = curr.next
    end

    raise IndexError.new
  end

  def insert(index, value)
    raise IndexError.new if empty? || index < 0 || index >= @length

    if index == 0
      node = Node.new(value)
      node.next = @head
      @head = node
    end

    curr = @head.next
    prev = @head
    idx = 1

    while curr
      if idx == index
        node = Node.new(value)
        prev.next = node
        node.next = curr
        @length += 1
        return
      end

      idx += 1
      prev = curr
      curr = curr.next
    end

    raise IndexError.new
  end

  def append(value)
    @length += 1
    node = Node.new(value)

    if @head.nil?
      @head = node
      @tail = @head
      return
    end

    @tail.next = node
    @tail = @tail.next
  end

  def add_all(values)
    values.each do |value|
      self << value
    end
  end

  def add_all_with_index(index, values)
    raise IndexError.new if index >= @length || index < 0 || empty?

    return false if values.empty?

    if index == 0
      push(values.delete_at(0))
      curr = get_node(0)
    else
      curr = get_node(index - 1)
    end

    values.each do |value|
      node = Node.new(value)
      node.next = curr.next
      curr.next = node

      @length += 1
      curr = curr.next
    end

    true
  end
  def include?(value)
    curr = @head

    while curr
      if curr.value == value
        return true
      end

      curr = curr.next
    end

    false
  end

  def include_all?(values)
    return false if empty? || values.empty?

    values.each do |value|
      return false if include?(value) == false
    end

    true
  end


  def find_index(value)
    curr = @head
    idx = 0

    while curr
      return idx if curr.value == value

      idx += 1
      curr = curr.next
    end

    -1
  end

  def find_last_index(value)
    curr = @head
    idx = 0
    index = -1

    while curr
      if curr.value == value
        index = idx
      end

      curr = curr.next
      idx += 1
    end

    index
  end

  def min
    raise NoSuchElementError.new if empty?

    curr = @head
    min = curr

    while curr
      if min > curr
        min = curr
      end

      curr = curr.next
    end

    min.value
  end

  def min_or_nil
    begin
      return min
    rescue NoSuchElementError
      return nil
    end
  end

  def max
    raise NoSuchElementError.new if empty?

    curr = @head
    max = curr

    while curr
      if max < curr
        max = curr
      end

      curr = curr.next
    end

    max.value
  end

  def max_or_nil
    begin
      return max
    rescue NoSuchElementError
      return nil
    end
  end

  def chunked(n)
    linked_list = LinkedList.new

    quotient = @length / n
    remainder = @length % n

    if quotient == 0 || (quotient == 1 && remainder == 0)
      linked_list << self

      return linked_list
    end

    if remainder > 0
      groups = quotient + 1
    else
      groups = quotient
    end

    curr = @head
    range = 1..groups
    for i in range
      count = 0
      list = LinkedList.new

      while curr && count < n
        list << curr.value

        curr = curr.next
        count += 1
      end

      linked_list << list
    end

    linked_list
  end

  def chunked_map(n, &transform)
    linked_list = LinkedList.new

    quotient = @length / n
    remainder = @length % n

    if quotient == 0 || (quotient == 1 && remainder == 0)
      linked_list << self.map{|value| transform.call(value)}

      return linked_list
    end

    if remainder > 0
      groups = quotient + 1
    else
      groups = quotient
    end

    curr = @head
    range = 1..groups
    for _ in range
      count = 0
      list = LinkedList.new

      while curr && count < n
        list << transform.call(curr.value)

        curr = curr.next
        count += 1
      end

      linked_list << list
    end

    linked_list
  end

  def retain_all(values)
    removed = false

    return removed if empty? || values.empty?

    curr = @head
    prev = nil

    while curr
      unless values.include?(curr.value)
        curr = curr.next
        if prev.nil?
          @head = curr
        else
          prev.next = curr
        end

        removed = true
        @length -= 1

        unless curr
          @tail = prev
        end

        next
      end

      prev = curr
      curr = curr.next
    end

    removed
  end

  def last
    raise NoSuchElementError.new if empty?
    @tail.value
  end

  def last_or_nil
    begin
      return last
    rescue NoSuchElementError
      return nil
    end
  end

  def last_with_predicate(&predicate)
    curr = @head
    value = nil

    while curr
      if predicate.call(curr.value)
        value = curr.value
      end

      curr = curr.next
    end

    if value.nil?
      raise NoSuchElementError.new
    else
      value
    end
  end

  def first
    peek
  end

  def first_or_nil
    begin
      return first
    rescue NoSuchElementError
      return nil
    end
  end

  def count_occurrences(value)
    return 0 if empty?

    curr = @head
    count = 0

    while curr
      if curr.value == value
        count += 1
      end

      curr = curr.next
    end

    count
  end

  def count_occurrences_with_predicate(&predicate)
    return 0 if empty?

    curr = @head
    count = 0

    while curr
      if predicate.call(curr.value)
        count += 1
      end

      curr = curr.next
    end

    count
  end

  def each(&block)
    curr = @head
    while curr
      block.call(curr.value)

      curr = curr.next
    end
  end

  def each_indexed
    curr = @head
    idx = 0

    while curr
      yield curr.value, idx

      curr = curr.next
      idx += 1
    end
  end


  def zip(array)
    list = LinkedList.new

    return [] if empty? || array.empty?

    idx = 0

    array.each do |value|
      v = fetch_or_nil(idx)
      break if v.nil?
      list.append(Pair.new(v, value))

      idx += 1
    end

    list
  end

  def flat_map(&transform)
    list = []

    curr = @head

    while curr
      values = transform.call(curr.value)
      list += values

      curr = curr.next
    end

    list
  end

  def map(&transform)
    curr = @head
    list = LinkedList.new

    while curr
      list << transform.call(curr.value)

      curr = curr.next
    end

    list
  end

  def map_indexed(index, &transform)
    raise IndexError.new if empty? || index < 0 || index >= @length

    curr = get_node(index)
    list = LinkedList.new

    while curr
      curr.value = transform.call(curr.value)
      list << curr.value

      curr = curr.next
    end

    list
  end

  def fold(initial, &operation)
    return initial if empty?

    curr = @head
    accumulator = initial

    while curr
      accumulator = operation.call(accumulator, curr.value)
      curr = curr.next
    end

    accumulator
  end

  def filter(&predicate)
    return self if empty?

    list = LinkedList.new
    curr = @head

    while curr
      if !predicate.call(curr.value)
        list << curr.value
      end

      curr = curr.next
    end

    list
  end

  def any?(&predicate)
    return false if empty?

    curr = @head

    while curr
      return true if predicate.call(curr.value)

      curr = curr.next
    end

    false
  end

  def take(n)
    raise ArgumentError.new if n < 0

    list = LinkedList.new

    return self if empty? || n >= @length

    return list if n == 0

    curr = @head
    idx = 0

    while curr && idx < n
      list << curr.value

      curr = curr.next
      idx +=1
    end
    list
  end

  def take_while(&predicate)
    list = LinkedList.new
    curr = @head

    while curr
      if predicate.call(curr.value)
        list << curr.value
      else
        return list
      end

      curr = curr.next
    end

    list
  end

  def drop(n)
    raise ArgumentError.new if n < 0

    list = LinkedList.new

    return list if empty? || n >= @length

    return self if n == 0

    curr = @head
    idx = 0

    while curr && idx < @length - n
      list << curr.value

      idx += 1
      curr = curr.next
    end
    list
  end

  def drop_while(&predicate)
    list = LinkedList.new

    return list if empty?

    curr = @head

    while curr && predicate.call(curr.value)
      curr = curr.next
    end

    while curr
      list << curr.value

      curr = curr.next
    end

    list
  end

  def <<(value)
    append(value)
  end

  def +(list)
    add_all(list)
  end

  def -(list)
    delete_all(list)
  end

  def slice(range)
    raise IndexError.new if range.first > range.last

    curr = get_node(range.first)
    list = LinkedList.new
    idx = range.first

    while curr && idx <= range.last
      list << curr.value

      curr = curr.next
      idx += 1
    end

    list
  end

  def reversed
    list = LinkedList.new
    curr = @head

    while curr
      list.push(curr.value)

      curr = curr.next
    end

    list
  end

  def to_set
    set = Set.new
    curr = @head

    while curr
      set << curr.value

      curr = curr.next
    end

    set
  end

  def to_sorted_set
    self.selection_sort!(SortingType::ASCENDING)

    set = Set.new
    curr = @head

    while curr
      set << curr.value

      curr = curr.next
    end

    set
  end

  def sort!(sorting_type = SortingType::ASCENDING)
    selection_sort!(sorting_type)
  end

  def selection_sort!(sorting_type = SortingType::ASCENDING)
    return if empty?

    starting_node = @head
    curr = @head.next

    while curr
      while curr
        if sorting_type == SortingType::ASCENDING
          if curr < starting_node
            swap_values(starting_node, curr)
          end
        else
          if curr > starting_node
            swap_values(starting_node, curr)
          end
        end

        curr = curr.next
      end

      starting_node = starting_node.next
      curr = starting_node.next
    end
  end

  def bubble_sort(sorting_type = SortingType::ASCENDING)
    return if empty? || @length == 1

    for i in 0..@length - 1
      curr = @head
      idx = 0

      while idx < @length - 1 - i
        if sorting_type == SortingType::ASCENDING
          if curr.value > curr.next.value
            swap_values(curr, curr.next)
          end
        else
          if curr.value < curr.next.value
            swap_values(curr, curr.next)
          end
        end

        curr = curr.next
        idx += 1
      end
    end
  end

  def join_to_string(separator = " ", prefix = "[", postfix = "]", &transform)
    string = prefix
    curr = @head

    while curr
      s = transform.call(curr.value)

      if curr.next.nil?
        string << s
        break
      else
        string << s << separator
      end

      curr = curr.next
    end

    string << postfix
  end

  def to_s
    string = ""

    return string if empty?

    string << "["

    curr = @head

    while curr
      if curr.next.nil?
        string << "#{curr}]"
      else
        string << "#{curr}, "
      end

      curr = curr.next
    end

    string
  end

  def iterator
    LinkedIterator.new(@head)
  end

  class Pair
    attr_accessor :left, :right

    def initialize(left, right)
      @left = left
      @right = right
    end
  end

  private

  class Node
    include Comparable

    attr_accessor :value, :next

    def initialize(value)
      @value = value
      @next = nil
    end

    def <=>(other)
      value <=> other.value
    end

    def to_s
      "#{value}"
    end
  end

  def get_node(index)
    raise IndexError.new if self.empty? || index >= @length || index < 0

    curr = @head
    idx = 0

    while curr
      return curr if idx == index

      curr = curr.next
      idx += 1
    end
  end

  def swap_values(left_node, right_node)
    temp = left_node.value
    left_node.value = right_node.value
    right_node.value = temp
  end
end