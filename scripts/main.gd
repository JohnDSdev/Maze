extends Node3D

const WorldBuilder = preload("res://scripts/world_builder.gd")

@onready var world_root: Node3D = $World

func _ready() -> void:
    _configure_environment()
    var builder := WorldBuilder.new()
    builder.name = "ProceduralWorld"
    world_root.add_child(builder)
    builder.build_world()

func _configure_environment() -> void:
    var env := Environment.new()
    env.background_mode = Environment.BG_COLOR
    env.background_color = Color(0.0025, 0.0028, 0.0032)
    env.background_energy_multiplier = 0.15
    env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    env.ambient_light_color = Color(0.20, 0.215, 0.23)
    env.ambient_light_energy = 0.18
    env.reflected_light_source = Environment.REFLECTION_SOURCE_DISABLED
    env.tonemap_mode = Environment.TONE_MAPPER_ACES
    env.tonemap_exposure = 1.05
    env.fog_enabled = true
    env.fog_light_color = Color(0.22, 0.235, 0.25)
    env.fog_light_energy = 0.35
    env.fog_density = 0.0065
    env.fog_aerial_perspective = 0.55
    env.fog_sky_affect = 1.0
    env.volumetric_fog_enabled = true
    env.volumetric_fog_density = 0.032
    env.volumetric_fog_albedo = Color(0.68, 0.72, 0.76)
    env.volumetric_fog_emission = Color(0.006, 0.007, 0.008)
    env.volumetric_fog_emission_energy = 0.45
    env.volumetric_fog_length = 115.0
    env.volumetric_fog_detail_spread = 1.6
    env.volumetric_fog_ambient_inject = 0.28
    env.volumetric_fog_temporal_reprojection_enabled = true
    env.glow_enabled = true
    env.glow_intensity = 0.55
    env.glow_bloom = 0.18

    var world_env := WorldEnvironment.new()
    world_env.environment = env
    add_child(world_env)

    var fill := DirectionalLight3D.new()
    fill.light_color = Color(0.30, 0.32, 0.35)
    fill.light_energy = 0.22
    fill.shadow_enabled = false
    fill.rotation_degrees = Vector3(-58.0, -28.0, 0.0)
    add_child(fill)
