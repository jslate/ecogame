class Predator

  DEFAULT_SIZE = 50
  DEFAULT_HUNGER = 35
  MAX_HUNGER = 100
  HUNGER_THRESHOLD = 30
  MAX_SIZE = 62
  BASE_FOOD_SATIATION = 2
  MOVE_SPEED = 2

  def initialize(window, x, y)
    @window = window
    @x = x
    @y = y
    @angle = rand(360)
    @speed = MOVE_SPEED
    @size = DEFAULT_SIZE
    @hunger = DEFAULT_HUNGER
    @victim = nil
  end

  def color
    Gosu::Color.rgb(0, greenness, 0)
  end

  def hunt(herbivores)
    @victim ||= herbivores.reject(&:dead?).sample
    if @victim.dead?
      @victim = nil
      return hunt(herbivores)
    end
    angle = Gosu::angle(@x, @y, @victim.x, @victim.y)
    angle
  end

  def move(herbivores)
    @size -= 0.1
    @dead = true if @size < 0
    @angle = hunt(herbivores)
    @x += Gosu::offset_x(@angle, @speed)
    @y += Gosu::offset_y(@angle, @speed)
    @x %= @window.width
    @y %= @window.height
    @hunger += 1 unless @hunger >= MAX_HUNGER
  end

  def draw
    @window.draw_rect(@x, @y, quad_size*5, quad_size*5, color, ZOrder::HERBIVORE)
  end

  def quad_size
    @size / 5
  end

  def eat(herbivores)
    herbivores.each do |herbivore|
      if (collides?(herbivore.x, herbivore.y) && hungry?)
        @size += herbivore.size * 0.2
        @hunger -= herbivore.size * BASE_FOOD_SATIATION
        herbivore.be_eaten
        @victim = nil
      end
    end
  end

  def dead?
    @dead
  end

  def multiply
    if @size >= MAX_SIZE
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
