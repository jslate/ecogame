class GameWindow < Gosu::Window

  WIDTH = 720
  HEIGHT = 480
  WHITE = Gosu::Color.rgb(255,255,255)
  BLACK = Gosu::Color.rgb(0, 0, 0)

  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = "EcoGame"
    @foods = 1.upto(1000).to_a.map {|_i| Food.new(self, *random_location) }
    @herbavores = 1.upto(5).to_a.map {|_i| Herbavore.new(self, *random_location) }
  end

  def random_location
    [rand(WIDTH), rand(HEIGHT - 100) + 100]
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
    (@foods.count * 0.008).to_i
  end

  def draw
    @herbavores.each(&:draw)
    @foods.each(&:draw)
    draw_background
    Gosu::Image.from_text(self, "herbavores: #{@herbavores.count}",
      Gosu.default_font_name, 45).draw(20, 10, ZOrder::TEXT, 1, 1, WHITE)
    Gosu::Image.from_text(self, "foods: #{@foods.count}",
      Gosu.default_font_name, 45).draw(20, 50, ZOrder::TEXT, 1, 1, WHITE)
  end

  def button_down(id)
    case id
    when Gosu::KbEscape
      close
    end
  end

  def draw_background
    self.draw_quad(
      0, 100, WHITE,
      self.width, 100, WHITE,
      0, self.height, WHITE,
      self.width, self.height, WHITE,
      ZOrder::BACKGROUND)
  end

end
