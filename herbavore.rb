class Herbavore

  attr_reader :dead

  def initialize(window, x, y)
    @window = window
    @x = x
    @y = y
    @angle = rand(360)
    @speed = 1
    @size = 50
    @hunger = 50
  end

  def color
    Gosu::Color.rgb(redness, 0, blueness)
  end

  def blueness
    100/@hunger.to_f * 255
  end

  def redness
    255 - blueness
  end

  def move
    @size -= 0.1
    @dead = true if @size < 0
    @angle += rand(10) - 10 if rand(10) > 9
    @x += Gosu::offset_x(@angle, @speed)
    @y += Gosu::offset_y(@angle, @speed)
    @x %= @window.width
    @y %= @window.height
    @hunger += 1
  end

  def draw
    @window.draw_quad(@x, @y, color,
      @x + quad_size, @y, color,
      @x, @y + quad_size, color,
      @x + quad_size, @y + quad_size, color,
    ZOrder::HERBAVORE)
  end

  def quad_size
    @size / 5
  end

  def eat(foods)
    foods.each do |food|
      if (collides?(food.x, food.y) && @hunger > 100)
        food.eat
        @size += 2
        @hunger -= 2
      end
    end
  end

  def multiply
    if @size > 100
      [0,1].map { |_i| self.class.new(@window, @x, @y) }
    else
      [self]
    end
  end

  def collides?(x, y)
    ((@x - x).abs + (@y - y).abs) < 40
  end

end
