class GameWindow < Gosu::Window

  WIDTH = 720
  HEIGHT = 480
  MENU_WIDTH = 200
  WHITE = Gosu::Color.rgb(255,255,255)
  BLACK = Gosu::Color.rgb(0, 0, 0)
  SEMITRANSPARENT = Gosu::Color.rgba(0, 0, 0, 128)

  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = "EcoGame"
    @foods = 1.upto(1000).to_a.map {|_i| Food.new(self, *random_location) }
    @herbavores = 1.upto(5).to_a.map {|_i| Herbavore.new(self, *random_location) }
  end

  def random_location
    [rand(WIDTH), rand(HEIGHT)]
  end

  def update
    @herbavores.each(&:move)
    @herbavores.each { |herbavore| herbavore.eat(@foods) }
    @foods.reject!(&:eaten)
    @herbavores.reject!(&:dead)
    @herbavores = @herbavores.map(&:multiply).flatten
    new_food_count.times { @foods << Food.new(self, *random_location) }
  end

  def new_food_count
    (@foods.count * 0.004).to_i
  end

  def draw
    @herbavores.each(&:draw)
    @foods.each(&:draw)
    draw_background
    menu_text = Gosu::Font.new(25, {name: 'default'})
    menu_text.draw('Herbivores', 10, 10, ZOrder::TEXT)
    menu_text.draw_rel(@herbavores.count, MENU_WIDTH - 10, 10, ZOrder::TEXT, 1, 0)
    menu_text.draw('Food', 10, 35, ZOrder::TEXT)
    menu_text.draw_rel(@foods.count, MENU_WIDTH - 10, 35, ZOrder::TEXT, 1, 0)
    # Gosu::Image.from_text(self, "herbavores: #{@herbavores.count}",
    #   Gosu.default_font_name, 45).draw(20, 10, ZOrder::TEXT, 1, 1, WHITE)
    # Gosu::Image.from_text(self, "foods: #{@foods.count}",
    #   Gosu.default_font_name, 45).draw(20, 50, ZOrder::TEXT, 1, 1, WHITE)
  end

  def button_down(id)
    case id
    when Gosu::KbEscape
      close
    end
  end

  def draw_background
    self.draw_rect(0, 0, MENU_WIDTH, 65, SEMITRANSPARENT, ZOrder::MENU)
    self.draw_quad(
      0, 0, WHITE,
      self.width, 0, WHITE,
      0, self.height, WHITE,
      self.width, self.height, WHITE,
      ZOrder::BACKGROUND)
  end

  def draw_rect(x, y, width, height, color, zorder)
    draw_quad(
      x, y, color,
      x + width, y, color,
      x, y + height, color,
      x + width, y + height, color,
      zorder)
  end

end
