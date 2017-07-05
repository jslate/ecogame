class GameWindow < Gosu::Window

  WIDTH = 720
  HEIGHT = 480
  MENU_WIDTH = 200
  MENU_HEIGHT = 90
  NEW_FOODS_MULTIPLIER = 0.01
  TEXT_SIZE = 25

  WHITE = Gosu::Color.rgb(255,255,255)
  BLACK = Gosu::Color.rgb(0, 0, 0)
  SEMITRANSPARENT = Gosu::Color.rgba(0, 0, 0, 128)

  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = "EcoGame"
    @font = Gosu::Font.new(TEXT_SIZE, {name: 'default'})
    @foods = []
    @herbivores = []
    @predators = []
    @herbivore_slider = Gosui::Slider.new(self, 50, 200, ZOrder::TEXT, 200, 100, label: 'Herbivores', markers: 1)
    @food_slider = Gosui::Slider.new(self, 50, 100, ZOrder::TEXT, 200, 1000, label: 'Food', markers: 1)
    @predator_slider = Gosui::Slider.new(self, 50, 300, ZOrder::TEXT, 200, 20, label: 'Predators', markers: 1)
    @start_button = Gosui::Button.new(self, 50, 400, ZOrder::TEXT, self.method(:start), label: 'Submit', height: 50, width: 100)
    @started = false
  end

  def start
    return if @started
    @herbivores = add_to_window(Herbivore, @herbivore_slider.value)
    @foods = add_to_window(Food, @food_slider.value)
    @predators = add_to_window(Predator, @predator_slider.value)
    @started = true
  end

  def needs_cursor?
    true
  end

  def add_to_window(klass, count)
    1.upto(count).to_a.map do |_i|
      klass.new(self, rand(WIDTH), rand(HEIGHT))
    end
  end

  def update
    update_herbivores
    update_predators
    update_foods
    unless @started
      @food_slider.update
      @herbivore_slider.update
      @predator_slider.update
      @start_button.update
    end
  end

  def draw
    @herbivores.each(&:draw)
    @predators.each(&:draw)
    @foods.each(&:draw)
    draw_background
    if @started
      draw_menu
    else
      @herbivore_slider.draw
      @food_slider.draw
      @predator_slider.draw
      @start_button.draw
    end
  end

  def button_down(id)
    case id
    when Gosu::KbEscape
      close
    when Gosu::KbReturn
      start
    end
  end

  def draw_rect(x, y, width, height, color, zorder)
    draw_quad(
      x, y, color,
      x + width, y, color,
      x, y + height, color,
      x + width, y + height, color,
      zorder)
  end

  private

  def update_herbivores
    @herbivores.reject! do |herbivore|
      herbivore.eat(@foods)
      herbivore.move
      herbivore.dead?
    end
    @herbivores = @herbivores.map(&:multiply).flatten
  end

  def update_predators
    @predators.reject! do |predator|
      predator.eat(@herbivores)
      predator.move
      predator.dead?
    end
    @predators = @predators.map(&:multiply).flatten
  end

  def update_foods
    @foods.reject!(&:eaten)
    @foods += add_to_window(Food, new_food_count)
  end

  def new_food_count
    (@foods.count * NEW_FOODS_MULTIPLIER).to_i
  end

  def draw_background
    self.draw_rect(0, 0, WIDTH, HEIGHT, WHITE, ZOrder::BACKGROUND)
  end

  def draw_menu
    self.draw_rect(0, 0, MENU_WIDTH, MENU_HEIGHT, SEMITRANSPARENT, ZOrder::MENU)
    @font.draw('Herbivores', 10, 10, ZOrder::TEXT)
    @font.draw_rel(@herbivores.count, MENU_WIDTH - 10, 10, ZOrder::TEXT, 1, 0)
    @font.draw('Food', 10, 35, ZOrder::TEXT)
    @font.draw_rel(@foods.count, MENU_WIDTH - 10, 35, ZOrder::TEXT, 1, 0)
    @font.draw('Predators', 10, 60, ZOrder::TEXT)
    @font.draw_rel(@predators.count, MENU_WIDTH - 10, 60, ZOrder::TEXT, 1, 0)
  end

end
