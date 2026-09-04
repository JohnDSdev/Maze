# Brutalist Maze

A goal-less first-person liminal maze built in Godot 4.7.2, designed for Android first but playable on desktop too.

The world is generated at runtime from primitive geometry and procedural shaders, so the repository stays tiny while the spaces stay enormous. The large spaces are deliberately finite under the hood, then repetition, scale, darkness, and fog hide their boundaries to create the intended impossible/infinite feeling without asking a phone to render actual infinity, which remains annoyingly expensive.

## Spaces

1. **The Chasm** - a seemingly bottomless concrete cut with thin bridges and irregular blocks protruding from the walls.
2. **The Organic Nave** - a tall hall where enormous warped forms hang overhead.
3. **The Colonnade** - an oversized Greek-inspired procession hall with repeating pillars.
4. **The Stadium** - a foggy stadium bowl whose seating disappears into distance.
5. **The Black Reservoir** - a low wet chamber of reflective darkness and concrete piers.
6. **The Hanging City** - suspended slabs, bridges, and impossible blocks looming above a floor plane.
7. **The Light Cathedral** - vertical fins and harsh luminous bars vanishing into fog.
8. **The Inverted Quarry** - descending terraces around a central void.

The eight spaces are connected into a continuous explorable loop by eight deliberately different tunnel designs. There is no score, objective, ending, enemy, or required route.

## Controls

Desktop: WASD, mouse look, Space to jump, Shift to sprint, R to reset if stuck.

Android: left virtual stick to move, drag the right side to look, circular arrow button to jump.

## Rendering

The Android build targets Godot's Vulkan **Mobile** renderer. It uses procedural concrete and organic shaders, PBR materials, emissive fixtures, real-time white spotlights, selective real-time shadows, glow, ACES tonemapping, and dense depth fog. Godot's true volumetric fog is Forward+-only, so the Android build uses Mobile-compatible fog and lighting instead of pretending a phone is a desktop GPU with better manners.

The project exports both `arm64-v8a` for modern Android hardware and `x86_64` so CI can install the same APK in an emulator.

## CI

Every push to `main` builds a debug Android APK with Godot 4.7.2 and uploads it as the `maze-android-apk` artifact. A second job boots an Android 35 x86_64 emulator, installs the APK, launches `com.johndsdev.brutalistmaze`, verifies that the process remains alive, and fails if logcat reports a GDScript parse/script error or an Android fatal exception.
