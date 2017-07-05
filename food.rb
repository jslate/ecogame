class Food

  SIZE = 6
  BROWN = Gosu::Color.rgb(177,98,50)
  MAX_AGE = 200

  attr_reader :eaten, :x, :y

  def initialize(window, x, y)
    @window = window
    @x = x
    @y = y
    @color = BROWN
    @eaten = false
    @age = 0
  end

  def draw
    @window.draw_rect(@x, @y, SIZE, SIZE, @color, ZOrder::FOOD)
    @age += 1
    age_out
  end

  def eat
    @eaten = true
  end

  def age_out
    if @age > MAX_AGE
      eat
    end
  end

end
