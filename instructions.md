# RIVERLANDS — PROJECT INSTRUCTIONS

## Project Overview

Use the Riverlands 3.png image file to create Riverlands, a relaxing low-poly 3D simulation/world-building game set on a large fictional island.

The island contains a connected rural economy, wildlife, farms, towns, railways, roads, rivers, fishing and forestry. The world should feel alive, but the visual and technical implementation should remain deliberately simple.

The project is being developed in **Godot**.

When working on Riverlands, make changes directly to the Godot project using the available Godot MCP tools whenever possible.

Do not generate an image when asked to add, move, modify or inspect something in the game. Unless explicitly asked for artwork, assume that requests refer to the actual Godot project.

---

# 1. VISUAL STYLE

Riverlands uses a simple **low-poly/isometric-diorama style**.

Prefer:

- Simple geometry
- Flat or minimally shaded materials
- Clear silhouettes
- Bright natural colours
- Low polygon counts
- Simple stylised buildings
- Simple vehicles and animals
- Large readable landscape features
- Minimal texture dependence

Avoid unnecessary realism, high-resolution textures, complex shaders, excessive geometry or photorealistic assets.

Objects should look good from the normal game camera rather than being highly detailed when viewed close up.

A tractor, for example, can be constructed from boxes and cylinders rather than requiring a detailed model.

---

# 2. THE ISLAND

Riverlands takes place on one large island surrounded by sea.

The terrain should include:

- Rolling hills
- Forested areas
- Open farmland
- A large central freshwater lake
- Rivers flowing from the lake to the sea
- Coastal areas
- Beaches and rocky sections where appropriate

The landscape should remain spacious. Do not fill every available area with objects.

Leave room for future expansion.

---

# 3. CENTRAL LAKE

A large freshwater lake forms the ecological centre of the island.

The lake should eventually contain or support:

- Reeds
- Mallard ducks
- Ducklings
- Jumping trout
- Frogs
- Other simple pond life

Reeds and wetlands can also become part of the island economy, including harvesting reeds for basketry or other products.

Several rivers flow outward from the lake toward the coast.

---

# 4. RIVERS

Rivers are important both visually and economically.

They should connect the central lake with the sea and provide opportunities for:

- Railway bridges
- Road bridges
- Watermills
- Fishing
- Wildlife
- Small boats
- Scenic areas
- Tourism

Rivers should generally follow believable downhill routes rather than appearing as arbitrary straight channels.

---

# 5. TOWNS

There are approximately **five small seaside towns**, generally located near river mouths.

Towns should have a small rural/coastal character.

Typical structures include:

- Small cottages
- Railway station
- Shops
- Market
- Wharf
- Fishing facilities
- Small industrial buildings
- Roads

Do not turn towns into large modern cities.

One larger town or regional centre may eventually develop as the island economy expands.

---

# 6. RAILWAY

All major towns are connected by railway.

The railway is one of the major visual features of Riverlands.

It may include:

- Steam locomotives
- Passenger carriages
- Freight wagons
- Stations
- Tunnels
- Railway bridges
- Level crossings
- Rural track
- Coastal track

Rail routes should follow terrain sensibly.

Avoid excessively sharp curves or unrealistic gradients.

Where terrain blocks the railway, prefer interesting solutions such as tunnels, cuttings or bridges.

---

# 7. ROAD NETWORK

Towns, farms and industries are also connected by roads.

Road traffic can eventually include:

- Passenger cars
- Buses
- Trucks
- Delivery vehicles
- Tractors
- Bicycles

Roads should complement the railway rather than replace it.

Freight should be able to move between farms, industries, markets, towns and wharves.

---

# 8. FARMING

The island has substantial agricultural land.

Important farming activities include:

### Sheep farming
Produces wool and potentially meat.

### Dairy farming
Produces milk that can later feed processing industries.

### Wheat farming
Produces grain.

Grain can be transported to mills and bakeries.

A possible production chain is:

Wheat Farm → Mill → Flour → Bakery → Town Market

Farms should have large open fields rather than excessive numbers of buildings.

Typical farm objects can include:

- Barns
- Farmhouses
- Fences
- Tractors
- Hay
- Livestock
- Crop fields

---

# 9. FORESTRY

Riverlands contains managed forests and a forestry industry.

Possible production chain:

Forest → Logs → Sawmill → Timber → Construction/Market

Forestry areas may include:

- Tree plantations
- Logging areas
- Sawmills
- Log trucks
- Railway freight
- Timber yards

Keep forests visually distinct from farmland.

---

# 10. WATER POWER AND WIND POWER

Traditional industries are part of the visual identity of Riverlands.

These can include:

- Watermills beside rivers
- Windmills in farming areas

These structures should be functional-looking landmarks rather than merely decorative objects.

Animated water wheels and windmill blades are encouraged where practical.

---

# 11. FISHING AND SEA TRANSPORT

Coastal towns may contain wharves supporting:

- Marine fishing
- Freshwater fishing
- Small fishing boats
- Cargo boats
- Passenger boats
- Ferries

Sea transport may eventually connect towns or move goods around the island.

Keep vessels simple and low-poly.

---

# 12. WILDLIFE

Wildlife helps make Riverlands feel alive.

Possible animals include:

- Ducks
- Ducklings
- Frogs
- Trout
- Rabbits
- Sheep
- Deer
- Birds

Animals do not initially require sophisticated AI.

Simple behaviours such as wandering, swimming, jumping, grazing or following predefined areas are sufficient.

Prefer many simple believable behaviours over a few highly complicated systems.

---

# 13. TOURISM

The natural environment can eventually support tourism.

Possible systems include:

- Hotels
- Bus tours
- Scenic railway trips
- Wildlife viewing
- Fishing
- Lake excursions
- Walking areas

Tourists may travel between towns and natural attractions.

Tourism should make use of the existing transport network.

---

# 14. ECONOMY

The long-term objective is to create a world where industries connect logically.

Examples:

Wheat → Mill → Flour → Bakery → Market

Trees → Sawmill → Timber → Town

Farm → Milk → Dairy processing → Market

Fish → Wharf → Market

Reeds → Basketry → Market

Goods should eventually move using road, railway or water transport.

Do not implement the entire economy at once.

Build individual systems that can later connect together.

---

# 15. DEVELOPMENT PHILOSOPHY

Riverlands should grow incrementally.

When asked to add something:

1. Inspect the existing scene first.
2. Understand nearby objects and terrain.
3. Reuse existing systems where appropriate.
4. Make the smallest sensible change that achieves the request.
5. Test the change.
6. Check for script errors.
7. Verify that the requested object or behaviour actually exists.
8. Preserve existing working systems.

Do not unnecessarily rebuild systems that already work.

---

# 16. GODOT PROJECT RULES

When interacting with the project:

- Prefer Godot MCP tools when available.
- Inspect the existing scene before modifying it.
- Modify the actual Godot project rather than merely describing what should be done.
- Do not claim a modification was completed unless it was actually performed.
- Verify important changes after making them.
- Check the Godot output/debugger for errors when practical.
- Preserve existing scene hierarchy and naming conventions where reasonable.
- Give new nodes meaningful names.
- Keep scripts understandable and maintainable.

If an MCP capability required for a task is unavailable, clearly state what could not be performed rather than pretending it succeeded.

---

# 17. CODE ORGANISATION

Avoid allowing Riverlands to become one enormous script.

As systems grow, separate them logically.

Examples:

- TrainController
- RailwayNetwork
- RoadVehicle
- TrafficManager
- BoatController
- WildlifeManager
- FarmManager
- EconomyManager
- TownManager
- DayNightManager

Reusable objects should preferably become scenes/components rather than being repeatedly generated by unrelated code.

However, do not over-engineer small prototypes.

Refactor when complexity actually justifies it.

---

# 18. PERFORMANCE

Riverlands may eventually contain many objects.

Prefer efficient techniques such as:

- Reusing meshes
- Instancing repeated objects
- Simple collision geometry
- Low-poly models
- Limited physics where unnecessary
- Simple AI
- Sensible visibility distances
- Avoiding excessive per-frame processing

Hundreds of decorative objects should not each require complicated scripts.

---

# 19. SCALE AND PLACEMENT

Before adding an object, inspect nearby objects to determine the existing world scale.

New objects should have believable relative sizes.

For example:

- Tractors should fit existing roads.
- People should fit through doors.
- Trains should fit railway track.
- Boats should fit rivers.
- Bridges should clear vehicles or vessels using them.

Do not guess coordinates when the existing scene can be inspected first.

---

# 20. DEFAULT INTERPRETATION OF REQUESTS

When a request says:

"Add a tractor behind the red-roofed building."

This means:

Inspect the Godot scene → identify the red-roofed building → create or place a low-poly tractor behind it → save the project → verify the tractor exists.

It does **not** mean generate a picture containing a tractor.

Similarly:

"Add ducks to the lake"

means add ducks to the Riverlands Godot world.

"Build a bridge across the river"

means modify the Godot scene.

Only create concept artwork or generated images when explicitly requested.

---

# 21. PRIORITY

The priority order for Riverlands is:

**Working → Simple → Visually clear → Efficient → Detailed**

A simple working low-poly implementation is preferable to an elaborate unfinished one.

Riverlands is intended to grow organically. New ideas will continually be added, so systems and scenes should remain flexible enough to accommodate future expansion.
