# Quadtree (Roblox / Luau)

> Written in Roblox Studio. Roblox saves projects as binary place files, so in 2026 I used Claude to extract the scripts into plain `.lua` files for GitHub. The code itself is unchanged.

A hand-written quadtree for 2D spatial partitioning, with a visualizer that draws the points and cells in the Roblox world.

## What it does

- **Insert:** points go into the smallest cell that holds them. A cell splits into four children once it holds more than 2 points, down to a minimum cell size.
- **Range query:** returns every point inside a rectangle, skipping any branch whose bounds don't intersect the range.
- **Locate:** finds the leaf cell that contains a point.
- **Visualizer:** draws points as spheres and cells as outlined squares, so you can watch the tree subdivide.
- `Merge` and `Remove` are stubbed out and were never finished.

## Files

- `src/ServerStorage/QuadTree.lua`: the quadtree module.
- `src/ServerStorage/QuadTree/Signal.lua`: a small event class used by the tree.
- `src/ServerScriptService/Script.server.lua`: demo that inserts 50 random points and draws them.

File suffixes follow the Rojo convention: `.server.lua` is a server `Script` and `.lua` is a `ModuleScript`.
