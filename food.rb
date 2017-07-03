class Food

  SIZE = 6
  attr_reader :eaten, :x, :y

  def initialize(window, x, y)
    @window = window
    @x = x
    @y = y
    @color = Gosu::Color.rgb(177,98,50)
    @eaten = false
  end

  def draw
    @window.draw_quad(@x, @y, @color,
      @x + SIZE, @y, @color,
      @x, @y + SIZE, @color,
      @x + SIZE, @y + SIZE, @color,
    ZOrder::FOOD)
  end

  def eat
    @eaten = true
  end

end
