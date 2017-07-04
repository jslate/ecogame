class Food

  SIZE = 6
  BROWN = Gosu::Color.rgb(177,98,50)

  attr_reader :eaten, :x, :y

  def initialize(window, x, y)
    @window = window
    @x = x
    @y = y
    @color = BROWN
    @eaten = false
  end

  def draw
    @window.draw_rect(@x, @y, SIZE, SIZE, @color, ZOrder::FOOD)
  end

  def eat
    @eaten = true
  end

end
