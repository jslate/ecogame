class GameWindow < Gosu::Window

  WIDTH = 720
  HEIGHT = 480
  WHITE = Gosu::Color.rgb(255,255,255)

  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = "EcoGame"
    @foods = 1.upto(1000).to_a.map {|_i| Food.new(self, rand(WIDTH), rand(HEIGHT)) }
    @herbavores = 1.upto(5).to_a.map {|_i| Herbavore.new(self, rand(WIDTH), rand(HEIGHT)) }
  end

  def update
    @herbavores.each(&:move)
    @herbavores.each { |herbavore| herbavore.eat(@foods) }
    @foods.reject!(&:eaten)
    @herbavores.reject!(&:dead)
    @herbavores = @herbavores.map(&:multiply).flatten
  end

  def draw
    @herbavores.each(&:draw)
    @foods.each(&:draw)
    draw_background
  end

  def button_down(id)
    case id
    when Gosu::KbEscape
      close
    end
  end

  def draw_background
    self.draw_quad(
      0, 0, WHITE,
      self.width, 0, WHITE,
      0, self.height, WHITE,
      self.width, self.height, WHITE,
      ZOrder::BACKGROUND)
  end

end
