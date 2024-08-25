require './lib/map'
require './lib/river_carver'


file_name = './terrain_map_with_custom_colors.png'
# Example usage
map = Map.new(512, 512, scale: 0.02, center_weight: 2.0, center_bias: 0.3)
#map.display
map.generate_bitmap(file_name)


# Carve rivers into the generated bitmap
river_carver = RiverCarver.new(file_name, 'terrain_map_with_rivers.png', 1)
river_carver.carve_rivers