require_relative '../node'
class LinkedQueue
  include Enumerable

  private
  attr :head, :tail

  public
  attr_reader :length

  def initialize
    @head = nil
    @tail = nil
    @length = 0
  end

  def enqueue(value)
    node = Node.new(value)
    @length += 1

    if head
      @tail.next = node
      @tail = node
    else
      @head = Node.new(value)
      @tail = head
    end
  end

  def dequeue
    return nil if empty?

    @length -= 1
    value = @head.value
    @head = @head.next

    value
  end

  def peek
    @head&.value
  end

  def clear
    @head = nil
    @tail = nil
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

  def last
    @tail&.value
  end

  def each(&block)
    return if empty?

    curr = @head

    while curr
      block.call curr.value

      curr = curr.next
    end
  end

  def eql?(other)
    return false if @length != other.length

    curr = @head

    other.each do |value|
      return false if curr.value != value

      curr = curr.next
    end

    true
  end

  def to_s
    string = ""

    return string if empty?

    string << "["

    curr = @head

    while curr
      if curr.next.nil?
        string << curr.value.to_s
      else
        string << curr.value.to_s << " "
      end

      curr = curr.next
    end

    string << "]"
  end
end
