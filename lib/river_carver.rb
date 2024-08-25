require 'chunky_png'
require './lib/terrain'

class RiverCarver
  ICECAP_COLOR = Terrain::TERRAIN_TYPES[:snow_cap][:color]
  RIVER_COLOR = ChunkyPNG::Color.rgb(0, 0, 255) # Blue color for the river

  OCEAN_COLORS = [
    Terrain::TERRAIN_TYPES[:ocean][:color],
    Terrain::TERRAIN_TYPES[:open_ocean][:color]
  ]

  def initialize(filename, output_filename, number_of_rivers, river_width = 1)
    @filename = filename
    @output_filename = output_filename
    @number_of_rivers = number_of_rivers
    @river_width = river_width

    @image = ChunkyPNG::Image.from_file(filename)
    @width = @image.width
    @height = @image.height

    @ice_caps = find_ice_caps
    @ocean_distances = precompute_ocean_distances
  end

  def carve_rivers
    puts "Ice caps found: #{@ice_caps.size}"

    if @ice_caps.empty? || @ocean_distances.empty?
      puts "No ice caps or oceans found. Check color definitions and image data."
      return
    end

    @number_of_rivers.times do
      start_pos = @ice_caps.sample
      carve_river_from(start_pos) if start_pos
    end

    save_bitmap
  end

  private

  def find_ice_caps
    ice_caps_positions = []

    @height.times do |y|
      @width.times do |x|
        if @image[x, y] == ICECAP_COLOR
          ice_caps_positions << [x, y]
        end
      end
    end

    ice_caps_positions
  end

  def precompute_ocean_distances
    distances = Array.new(@width) { Array.new(@height, Float::INFINITY) }
    queue = []

    # Initialize distances with ocean cells
    @height.times do |y|
      @width.times do |x|
        if OCEAN_COLORS.include?(@image[x, y])
          distances[x][y] = 0
          queue << [x, y]
        end
      end
    end

    # BFS to compute the minimum distance to an ocean cell
    directions = [[1, 0], [-1, 0], [0, 1], [0, -1]]
    until queue.empty?
      x, y = queue.shift

      directions.each do |dx, dy|
        nx, ny = x + dx, y + dy
        if valid_coordinates?(nx, ny) && distances[nx][ny] == Float::INFINITY
          distances[nx][ny] = distances[x][y] + 1
          queue << [nx, ny]
        end
      end
    end

    distances
  end

  def carve_river_from(start_pos)
    return unless start_pos

    x, y = start_pos
    max_steps = 1000
    steps = 0

    path = Set.new
    path.add([x, y])

    while valid_coordinates?(x, y) && steps < max_steps
      current_color = @image[x, y]
      puts "Current position: (#{x}, #{y}), Color: #{current_color.to_s(16)}"

      # Check if we've reached the ocean
      if OCEAN_COLORS.include?(current_color) || adjacent_to_ocean?(x, y)
        puts "River reached the ocean at (#{x}, #{y}), Ocean color: #{current_color.to_s(16)}"

        # Draw one more step to ensure connection
        next_step = surrounding_cells(x, y).find { |nx, ny| OCEAN_COLORS.include?(@image[nx, ny]) }
        if next_step
          x, y = next_step
          draw_river(x, y)
        end

        break
      end

      # Mark the current tile as part of the river
      draw_river(x, y)

      # Move towards the ocean with some randomness for meandering
      surrounding = surrounding_cells(x, y)
      surrounding.sort_by! { |nx, ny| @ocean_distances[nx][ny] + rand(10) } # Add randomness for meandering

      if surrounding.any?
        x, y = surrounding.first
        path.add([x, y])
        steps += 1
      else
        puts "No valid neighbors to continue river carving at (#{x}, #{y})"
        break
      end
    end

    if steps >= max_steps
      puts "Max steps reached without finding ocean for river starting at (#{start_pos[0]}, #{start_pos[1]})"
    end
  end

  def surrounding_cells(x, y)
    directions = [[1, 0], [-1, 0], [0, 1], [0, -1]]
    directions.map { |dx, dy| [x + dx, y + dy] }.select { |nx, ny| valid_coordinates?(nx, ny) }
  end

  def adjacent_to_ocean?(x, y)
    surrounding_cells(x, y).any? { |nx, ny| OCEAN_COLORS.include?(@image[nx, ny]) }
  end

  def valid_coordinates?(x, y)
    x >= 0 && x < @width && y >= 0 && y < @height
  end

  def draw_river(x, y)
    half_width = (@river_width / 2.0).ceil

    (x - half_width).upto(x + half_width) do |dx|
      (y - half_width).upto(y + half_width) do |dy|
        @image[dx, dy] = RIVER_COLOR if valid_coordinates?(dx, dy)
      end
    end
  end

  def save_bitmap
    @image.save(@output_filename)
    puts "River carved map saved as #{@output_filename}"
  end
end

# Example usage:
# river_carver = RiverCarver.new('terrain_map_with_custom_colors.png', 'river_carved_map.png', 5, 3)
# river_carver.carve_rivers
