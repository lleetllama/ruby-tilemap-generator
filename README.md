# Procedural Map Generator

## Overview

**Procedural Map Generator** is a Ruby-based project designed to create and manipulate bitmap maps using various procedural generation techniques. The project is intended as a sandbox for experimenting with different algorithms and methods for terrain generation, including elevation mapping and river carving. While there is no specific end goal, the project aims to explore the capabilities of procedural generation and may eventually be used for more complex applications.

## Features

- **Terrain Generation**: Creates terrain maps using procedural noise algorithms.
- **River Carving**: Simulates rivers flowing from ice caps towards the ocean, with realistic meandering and terrain-following.
- **Customizable Parameters**: Adjust various parameters to tweak terrain and river generation.

## Components

1. **Map Generation**
   - Generates a bitmap map with terrain features using procedural noise.
   - Customizable parameters for scale, center weight, and center bias.

2. **River Carving**
   - Carves rivers from ice caps towards the ocean on the generated map.
   - Supports different river widths and meandering effects.

## Installation

1. **Clone the repository:**

```
   git clone https://github.com/yourusername/procedural-map-generator.git
   cd procedural-map-generator
```

2. **Install dependencies:**

   Ensure you have the required gems installed. You can install them using:

```
   gem install chunky_png
```

3. **Ensure you have a custom `Terrain` class and `NoiseGenerator` class.** These should be defined in `terrain.rb` and `noise_generator.rb`, respectively.

## Usage

### Map Generation

1. **Initialize the Map:**

```
   require_relative 'map'

   map = Map.new(100, 100, scale: 0.5, center_weight: 2.0, center_bias: 0.3)
   map.generate_bitmap('terrain_map_with_custom_colors.png')
```

   - **100, 100**: Width and height of the map.
   - **scale**: Noise scale for terrain generation.
   - **center_weight**: Weight for elevation adjustment towards the center.
   - **center_bias**: Bias for elevation adjustment towards the center.
   - **'terrain_map_with_custom_colors.png'**: Output file for the generated map.

2. **Display the Map:**

```
   map.display
```

   This will print the terrain grid to the console.

### River Carving

1. **Initialize the RiverCarver:**

```

   require_relative 'river_carver'

   river_carver = RiverCarver.new('terrain_map_with_custom_colors.png', 'river_carved_map.png', 5, 3)
   river_carver.carve_rivers

```

   - **'terrain_map_with_custom_colors.png'**: Input map file.
   - **'river_carved_map.png'**: Output file for the river-carved map.
   - **5**: Number of rivers to carve.
   - **3**: Width of the rivers.

## Customization

- **Terrain Parameters**: Adjust `scale`, `center_weight`, and `center_bias` in the `Map` class to experiment with different terrain features.
- **River Parameters**: Customize the number and width of rivers in the `RiverCarver` class.
- **Terrain Colors**: Modify the colors used for different terrain types in the `Terrain` class.

## Example

```
require_relative 'map'
require_relative 'river_carver'

# Generate a map
map = Map.new(200, 200, scale: 0.5, center_weight: 2.0, center_bias: 0.3)
map.generate_bitmap('terrain_map_with_custom_colors.png')

# Carve rivers on the generated map
river_carver = RiverCarver.new('terrain_map_with_custom_colors.png', 'river_carved_map.png', 10, 4)
river_carver.carve_rivers

```
