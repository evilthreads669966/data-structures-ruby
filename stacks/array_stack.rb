require_relative '../exceptions'
require_relative '../sorting_type'

class ArrayStack
  include Enumerable

  private
  attr :array, :top

  public
  attr_reader :length

  def initialize
    @array = []
    @top = -1
    @length = 0
  end

  def each(&block)
    @array.each(&block)
  end


  def empty?
    @top == -1
  end

  def push(value)
    @length += 1

    @top += 1
    @array[@top] = value
  end

  def pop
    raise NoSuchElementError if empty?

    @length -= 1

    value = @array[@top]
    @top -= 1

    value
  end

  def peek
    raise NoSuchElementError if empty?

    @array[@top]
  end

  def clear
    @array = []
    @top = -1
    @length = 0
  end

  def include?(value)
    @array.include?(value)
  end

  def include_all?(values)
    values.each do |value|
      unless @array.include?(value)
        return false
      end
    end

    true
  end

  def selection_sort(sorting_type = SortingType::ASCENDING)
    return if empty?

    for i in 0..top
      for j in i + 1..top
        if sorting_type == SortingType::ASCENDING
          if @array[i] > @array[j]
            temp = array[i]
            @array[i] = @array[j]
            @array[j] = temp
          end
        else
          if @array[i] < @array[j]
            temp = @array[i]
            @array[i] = @array[j]
            @array[j] = temp
          end
        end
      end
    end
  end

  def to_s
    return "" if empty?

    string = "["

    @array.each do |value|
      string << value.to_s << " "
    end

    string << "]"
  end
end