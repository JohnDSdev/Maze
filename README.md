# Brutalist Maze

A goal-less first-person liminal maze built in Godot 4.7.2, designed for Android first but playable on desktop too.

The world is generated at runtime from primitive geometry and procedural shaders, so the repository stays tiny while the spaces stay enormous.

## Spaces

1. **The Chasm** - a seemingly endless deep concrete cut with thin bridges and protruding wall blocks.
2. **The Organic Nave** - a tall hall where enormous distorted forms hang overhead.
3. **The Colonnade** - an oversized Greek-inspired procession hall with repeating pillars.
4. **The Stadium** - a foggy stadium bowl whose seating disappears into distance.
5. **The Black Reservoir** - a low wet chamber of reflective darkness and concrete piers.
6. **The Hanging City** - suspended slabs, bridges, and impossible blocks looming above a floor plane.
7. **The Light Cathedral** - vertical fins and harsh luminous bars vanishing into fog.
8. **The Inverted Quarry** - descending terraces around a central void.

The spaces form a loop and are connected by eight deliberately different tunnel designs.

## Controls

Desktop: WASD, mouse look, Space to jump, Shift to sprint, R to reset if stuck.

Android: left virtual stick to move, drag the right side to look, circular arrow button to jump.

## Rendering

The project targets Godot Forward+ on Android for depth fog, volumetric fog, PBR lighting, procedural concrete, emissive fixtures, shadows, and ACES tonemapping. The geometry is intentionally simple and repeated so that the lighting can carry the visual weight without turning a phone into a ceramic cooktop.

## CI

Every push to `main` builds a debug Android APK with Godot 4.7.2, uploads it as a GitHub Actions artifact, boots an Android 35 x86_64 emulator, installs the APK, and verifies the package is present.
