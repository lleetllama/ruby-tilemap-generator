require 'perlin_noise'

class NoiseGenerator
  def initialize(scale)
    @noise = Perlin::Noise.new(2)
    @scale = scale
  end

  def generate(x, y)
    @noise[x * @scale, y * @scale]
  end
end
