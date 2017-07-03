class Herbavore

  SIZE = 10

  attr_reader :dead

  def initialize(window, x, y)
    @window = window
    @x = x
    @y = y
    @color = Gosu::Color.rgb(22,55,100)
    @angle = rand(360)
    @speed = 1
    @fullness = 50
  end

  def move
    @fullness -= 0.1
    @dead = true if @fullness < 0
    @angle += rand(10) - 10 if rand(10) > 9
    @x += Gosu::offset_x(@angle, @speed)
    @y += Gosu::offset_y(@angle, @speed)
    @x %= @window.width
    @y %= @window.height - 100
  end

  def draw
    @window.draw_quad(@x, @y, @color,
      @x + SIZE, @y, @color,
      @x, @y + SIZE, @color,
      @x + SIZE, @y + SIZE, @color,
    ZOrder::HERBAVORE)
  end

  def eat(foods)
    foods.each do |food|
      if (collides?(food.x, food.y))
        food.eat
        @fullness += 2
      end
    end
  end

  def multiply
    if @fullness > 100
      [0,1].map { |_i| self.class.new(@window, @x, @y) }
    else
      [self]
    end
  end

  def collides?(x, y)
    ((@x - x).abs + (@y - y).abs) < 40
  end

end
