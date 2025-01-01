require_relative '../exceptions'
require_relative '../node'

class LinkedStack
  private
  attr :head

  public
  attr_reader :length

  def initialize
    @head = nil
    @length = 0
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
end
