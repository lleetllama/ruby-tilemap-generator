require 'chunky_png'

class Terrain
  TERRAIN_TYPES = {
    open_ocean: { symbol: '~', color: ChunkyPNG::Color.rgb(30, 90, 135) },  # Water: dark blue
    ocean: { symbol: '~', color: ChunkyPNG::Color.rgb(62, 164, 240) },  # Water: Light blue
    beach: { symbol: ':', color: ChunkyPNG::Color.rgb(240, 237, 164) }, # Beach: Sandy yellow
    dunes: { symbol: '.', color: ChunkyPNG::Color.rgb(62, 181, 77) },   # Plain: Green
    plain: { symbol: '#', color: ChunkyPNG::Color.rgb(45, 135, 56) },   # Plain: Green
    steepe: { symbol: '#', color: ChunkyPNG::Color.rgb(30, 97, 38) },   # Plain: Green
    mountain: { symbol: '^', color: ChunkyPNG::Color.rgb(159, 148, 132) }, # Mountain: Grayish brown
    snow_cap: { symbol: '^', color: ChunkyPNG::Color.rgb(255, 255, 255) } # Mountain: Snowy white
  }

  def self.get_terrain(elevation)
    case elevation
    when 0.0..0.3
    TERRAIN_TYPES[:open_ocean]
    when 0.3..0.5
    TERRAIN_TYPES[:ocean]
    when 0.5..0.55
    TERRAIN_TYPES[:beach]
    when 0.55..0.6
    TERRAIN_TYPES[:dunes]
    when 0.6..0.72
    TERRAIN_TYPES[:plain]
    when 0.72..0.8
    TERRAIN_TYPES[:steepe]
    when 0.8..0.9
    TERRAIN_TYPES[:mountain]
    else
      TERRAIN_TYPES[:snow_cap]
    end
  end
end


  