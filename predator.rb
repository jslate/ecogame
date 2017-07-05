class Predator

  DEFAULT_SIZE = 50
  DEFAULT_HUNGER = 35
  MAX_HUNGER = 100
  HUNGER_THRESHOLD = 30
  MAX_SIZE = 100
  FOOD_SATIATION = 5

  def initialize(window, x, y)
    @window = window
    @x = x
    @y = y
    @angle = rand(360)
    @speed = 1
    @size = DEFAULT_SIZE
    @hunger = DEFAULT_HUNGER
  end

  def color
    Gosu::Color.rgb(0, greenness, 0)
  end

  def move
    @size -= 0.1
    @dead = true if @size < 0
    @angle += rand(10) - 10 if rand(10) > 9
    @x += Gosu::offset_x(@angle, @speed)
    @y += Gosu::offset_y(@angle, @speed)
    @x %= @window.width
    @y %= @window.height
    @hunger += 1 unless @hunger >= MAX_HUNGER
  end

  def draw
    @window.draw_rect(@x, @y, quad_size, quad_size, color, ZOrder::HERBIVORE)
  end

  def quad_size
    @size / 5
  end

  def eat(herbivores)
    herbivores.each do |herbivore|
      if (collides?(herbivore.x, herbivore.y) && hungry?)
        herbivore.be_eaten
        @size += 2
        @hunger -= FOOD_SATIATION
      end
    end
  end

  def dead?
    @dead
  end

  def multiply
    if @size > MAX_SIZE
      [0,1].map { |_i| self.class.new(@window, @x, @y) }
    else
      [self]
    end
  end

  private

  def hungry?
    @hunger >= HUNGER_THRESHOLD
  end

  def greenness
    255 - [@hunger/100.0, 1.0].min * 255
  end

  def collides?(x, y)
    ((@x - x).abs + (@y - y).abs) < 40
  end

end
