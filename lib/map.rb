require_relative 'terrain'
require_relative 'noise_generator'
require 'chunky_png'

class Map
  def initialize(width, height, scale: 0.5, center_weight: 2.0, center_bias: 0.3)
    @width = width
    @height = height
    @scale = scale
    @center_weight = center_weight
    @center_bias = center_bias
    @grid = Array.new(height) { Array.new(width) }
    @noise_generator = NoiseGenerator.new(scale)
    generate_map
  end

  def generate_map
    min_noise = Float::INFINITY
    max_noise = -Float::INFINITY

    center_x = @width / 2.0
    center_y = @height / 2.0
    max_distance = Math.sqrt(center_x**2 + center_y**2)

    @height.times do |y|
      @width.times do |x|
        elevation = generate_elevation(x, y)
        
        # Calculate distance from the center
        distance = Math.sqrt((x - center_x)**2 + (y - center_y)**2)
        distance_ratio = distance / max_distance

        # Adjust elevation to favor the center more
        adjusted_elevation = elevation * (1 - distance_ratio**@center_weight) + @center_bias * (1 - distance_ratio)

        @grid[y][x] = Terrain.get_terrain(adjusted_elevation)

        # Track the min and max noise values
        min_noise = [min_noise, elevation].min
        max_noise = [max_noise, elevation].max
      end
    end

    puts "Noise value range: #{min_noise} to #{max_noise}"
  end

  def generate_elevation(x, y)
    @noise_generator.generate(x, y)
  end

  def generate_bitmap(filename = 'terrain_map_with_custom_colors.png')
    png = ChunkyPNG::Image.new(@width, @height, ChunkyPNG::Color::WHITE)
    @height.times do |y|
      @width.times do |x|
        terrain = @grid[y][x]
        png[x, y] = terrain[:color]
      end
    end
    png.save(filename)
    puts "Map saved as #{filename}"
  end

  def display
    @grid.each do |row|
      puts row.map { |tile| tile[:symbol] }.join(' ')
    end
  end
end