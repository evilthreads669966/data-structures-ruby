require_relative '../exceptions'
require_relative '../node'
require_relative '../sorting_type'

class LinkedStack
  include Enumerable

  private
  attr :head

  public
  attr_reader :length

  def initialize
    @head = nil
    @length = 0
  end

  def each(&block)
    return if empty?

    curr = @head

    while curr
      block.call(curr.value)

      curr = curr.next
    end
  end

  def push(value)
    node = Node.new(value)
    node.next = @head
    @head = node

    @length += 1
  end

  def pop
    raise NoSuchElementError if @head.nil?

    value = @head.value
    @head = @head.next
    @length -= 1

    value
  end

  def peek
    raise NoSuchElementError if @head.nil?
    @head.value
  end

  def clear
    @head = nil
    @length = 0
  end

  def empty?
    @head.nil?
  end

  def include?(value)
    return false if empty?

    curr = @head

    while curr
      return true if curr.value == value

      curr = curr.next
    end

    false
  end

  def include_all?(values)
    return false if empty?

    values.each do |value|
      return false unless include?(value)
    end

    true
  end

  def selection_sort(sortingType = SortingType::ASCENDING)
    return if empty?

    starting_node = @head
    curr = starting_node.next

    while curr
      while curr
        if sortingType == SortingType::ASCENDING
          if starting_node.value < curr.value
            swap_values(starting_node, curr)
          end
        else
          if starting_node.value > curr.value
            swap_values(starting_node, curr)
          end
        end

        curr = curr.next
      end

      starting_node = starting_node.next
      curr = starting_node.next
    end
  end

  def swap_values(left_node, right_node)
    temp = left_node.value
    left_node.value = right_node.value
    right_node.value = temp
  end

  def to_s
    string = ""

    return string if empty?

    string << "["

    curr = @head

    while curr
      if curr.next
        string << curr.value.to_s << " "
      else
        string << curr.value.to_s
      end

      curr = curr.next
    end

    string << "]"
  end
end