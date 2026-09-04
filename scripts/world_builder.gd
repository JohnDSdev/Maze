extends Node3D

var concrete: ShaderMaterial
var concrete_light: ShaderMaterial
var concrete_dark: ShaderMaterial
var concrete_black: ShaderMaterial
var organic_base: ShaderMaterial
var emissive_white: StandardMaterial3D
var emissive_dim: StandardMaterial3D
var wet_black: StandardMaterial3D
var metal_dark: StandardMaterial3D
var rng := RandomNumberGenerator.new()

const CHASM := Vector3(0, 0, 0)
const ORGANIC := Vector3(0, 0, 650)
const COLONNADE := Vector3(650, 0, 650)
const STADIUM := Vector3(1300, 0, 650)
const RESERVOIR := Vector3(1300, 0, 0)
const HANGING := Vector3(1300, 0, -650)
const CATHEDRAL := Vector3(650, 0, -650)
const QUARRY := Vector3(0, 0, -650)

func build_world() -> void:
    rng.seed = 918273645
    _make_materials()
    _build_chasm(CHASM)
    _build_organic_nave(ORGANIC)
    _build_colonnade(COLONNADE)
    _build_stadium(STADIUM)
    _build_reservoir(RESERVOIR)
    _build_hanging_city(HANGING)
    _build_light_cathedral(CATHEDRAL)
    _build_quarry(QUARRY)

    _build_tunnel(Vector3(0, 0, 230), Vector3(0, 0, 470), 0)
    _build_tunnel(Vector3(165, 0, 650), Vector3(465, 0, 650), 1)
    _build_tunnel(Vector3(835, 0, 650), Vector3(1055, 0, 650), 2)
    _build_tunnel(Vector3(1300, 0, 455), Vector3(1300, 0, 220), 3)
    _build_tunnel(Vector3(1300, 0, -220), Vector3(1300, 0, -470), 4)
    _build_tunnel(Vector3(1085, 0, -650), Vector3(835, 0, -650), 5)
    _build_tunnel(Vector3(465, 0, -650), Vector3(220, 0, -650), 6)
    _build_tunnel(Vector3(0, 0, -430), Vector3(0, 0, -230), 7)

func _make_materials() -> void:
    var concrete_shader := load("res://shaders/concrete.gdshader") as Shader
    concrete = ShaderMaterial.new()
    concrete.shader = concrete_shader
    concrete.set_shader_parameter("base_color", Vector3(0.34, 0.35, 0.36))
    concrete.set_shader_parameter("roughness_value", 0.90)
    concrete.set_shader_parameter("grain_scale", 0.30)

    concrete_light = ShaderMaterial.new()
    concrete_light.shader = concrete_shader
    concrete_light.set_shader_parameter("base_color", Vector3(0.47, 0.48, 0.49))
    concrete_light.set_shader_parameter("roughness_value", 0.91)
    concrete_light.set_shader_parameter("grain_scale", 0.22)

    concrete_dark = ShaderMaterial.new()
    concrete_dark.shader = concrete_shader
    concrete_dark.set_shader_parameter("base_color", Vector3(0.16, 0.17, 0.18))
    concrete_dark.set_shader_parameter("roughness_value", 0.94)
    concrete_dark.set_shader_parameter("grain_scale", 0.34)

    concrete_black = ShaderMaterial.new()
    concrete_black.shader = concrete_shader
    concrete_black.set_shader_parameter("base_color", Vector3(0.055, 0.06, 0.065))
    concrete_black.set_shader_parameter("roughness_value", 0.96)
    concrete_black.set_shader_parameter("grain_scale", 0.38)

    organic_base = ShaderMaterial.new()
    organic_base.shader = load("res://shaders/organic.gdshader") as Shader

    emissive_white = StandardMaterial3D.new()
    emissive_white.albedo_color = Color(0.93, 0.96, 1.0)
    emissive_white.emission_enabled = true
    emissive_white.emission = Color(0.93, 0.97, 1.0)
    emissive_white.emission_energy_multiplier = 7.0
    emissive_white.roughness = 0.28

    emissive_dim = StandardMaterial3D.new()
    emissive_dim.albedo_color = Color(0.70, 0.74, 0.78)
    emissive_dim.emission_enabled = true
    emissive_dim.emission = Color(0.64, 0.70, 0.78)
    emissive_dim.emission_energy_multiplier = 2.8
    emissive_dim.roughness = 0.45

    wet_black = StandardMaterial3D.new()
    wet_black.albedo_color = Color(0.012, 0.014, 0.017)
    wet_black.metallic = 0.18
    wet_black.roughness = 0.11

    metal_dark = StandardMaterial3D.new()
    metal_dark.albedo_color = Color(0.075, 0.08, 0.085)
    metal_dark.metallic = 0.75
    metal_dark.roughness = 0.38

func _build_chasm(o: Vector3) -> void:
    var root := Node3D.new()
    root.name = "TheChasm"
    root.position = o
    add_child(root)

    _box(Vector3(-76, -1.0, 0), Vector3(108, 2.0, 460), concrete_dark, true, root)
    _box(Vector3(76, -1.0, 0), Vector3(108, 2.0, 460), concrete_dark, true, root)
    _box(Vector3(-22.8, -78, 0), Vector3(2.0, 156, 460), concrete, false, root)
    _box(Vector3(22.8, -78, 0), Vector3(2.0, 156, 460), concrete, false, root)

    for z in range(-200, 201, 80):
        _box(Vector3(0, 0.35, z), Vector3(48, 0.7, 3.2), concrete_light, true, root)
        _box(Vector3(0, 2.8, z), Vector3(48, 0.55, 0.55), concrete_dark, false, root)
        if abs(z) % 160 == 0:
            _light_strip(Vector3(0, 13.5, z), Vector3(18, 0.16, 0.8), root, 11.0, 34.0, true)

    for z in range(-210, 211, 30):
        _box(Vector3(0, 18.0, z), Vector3(150, 1.2, 1.5), concrete_black, false, root)
        if int(z / 30) % 2 == 0:
            _light_strip(Vector3(-54, 17.3, z), Vector3(10, 0.14, 0.75), root, 8.0, 26.0, false)
            _light_strip(Vector3(54, 17.3, z), Vector3(10, 0.14, 0.75), root, 8.0, 26.0, false)

    for side in [-1.0, 1.0]:
        for i in range(82):
            var z := rng.randf_range(-220.0, 220.0)
            var y := rng.randf_range(-132.0, -7.0)
            var depth := rng.randf_range(1.0, 8.0)
            var sx := rng.randf_range(2.0, 11.0)
            var sy := rng.randf_range(2.0, 12.0)
            var sz := rng.randf_range(2.0, 14.0)
            var x: float = float(side) * (22.0 - depth * 0.42)
            _box(Vector3(x, y, z), Vector3(sx, sy, sz), concrete_dark if i % 3 else concrete_light, false, root)

    for z in [-205.0, 205.0]:
        _box(Vector3(-76, 5.0, z), Vector3(108, 10.0, 1.4), concrete_black, false, root)
        _box(Vector3(76, 5.0, z), Vector3(108, 10.0, 1.4), concrete_black, false, root)

func _build_organic_nave(o: Vector3) -> void:
    var root := Node3D.new()
    root.name = "OrganicNave"
    root.position = o
    add_child(root)

    _box(Vector3(0, -0.6, 0), Vector3(330, 1.2, 360), concrete, true, root)
    _box(Vector3(-166, 22, 0), Vector3(2.0, 44, 360), concrete_dark, true, root)
    _box(Vector3(166, 22, 0), Vector3(2.0, 44, 360), concrete_dark, true, root)
    _box(Vector3(0, 44, 0), Vector3(330, 1.5, 360), concrete_black, false, root)

    for z in range(-150, 151, 30):
        _box(Vector3(0, 42.7, z), Vector3(330, 1.6, 1.8), concrete_black, false, root)
        if z % 60 == 0:
            _light_strip(Vector3(0, 41.5, z), Vector3(56, 0.18, 0.95), root, 10.0, 42.0, true)

    var form_data := [
        [Vector3(-92, 31, -105), Vector3(28, 14, 42), 0.2],
        [Vector3(74, 27, -72), Vector3(37, 18, 24), 1.5],
        [Vector3(-20, 32, -18), Vector3(52, 12, 31), 2.8],
        [Vector3(105, 30, 38), Vector3(25, 20, 50), 4.1],
        [Vector3(-84, 25, 66), Vector3(34, 24, 33), 5.7],
        [Vector3(12, 28, 120), Vector3(48, 17, 28), 7.4],
        [Vector3(118, 34, 138), Vector3(31, 13, 44), 8.9]
    ]
    for entry in form_data:
        var mat := organic_base.duplicate() as ShaderMaterial
        mat.set_shader_parameter("seed_offset", entry[2])
        mat.set_shader_parameter("displacement", 1.8)
        _sphere(entry[0], entry[1], mat, root)

    for x in [-130.0, 130.0]:
        for z in range(-145, 146, 58):
            _box(Vector3(x, 11, z), Vector3(9, 22, 9), concrete_black, false, root)

func _build_colonnade(o: Vector3) -> void:
    var root := Node3D.new()
    root.name = "InfiniteColonnade"
    root.position = o
    add_child(root)

    _box(Vector3(0, -0.5, 0), Vector3(370, 1.0, 190), concrete_light, true, root)
    _box(Vector3(0, 31, -96), Vector3(370, 62, 2), concrete_dark, true, root)
    _box(Vector3(0, 31, 96), Vector3(370, 62, 2), concrete_dark, true, root)
    _box(Vector3(0, 62, 0), Vector3(370, 1.2, 190), concrete_black, false, root)

    for x in range(-168, 169, 16):
        for z in [-57.0, 57.0]:
            _greek_column(Vector3(x, 0, z), 19.0, root)
        if x % 32 == 0:
            _light_strip(Vector3(x, 56.5, 0), Vector3(1.0, 0.18, 48), root, 9.0, 36.0, true)

    _box(Vector3(0, 22.0, -74), Vector3(370, 4, 4), concrete, false, root)
    _box(Vector3(0, 22.0, 74), Vector3(370, 4, 4), concrete, false, root)
    _box(Vector3(0, 27.0, -74), Vector3(370, 2, 8), concrete_dark, false, root)
    _box(Vector3(0, 27.0, 74), Vector3(370, 2, 8), concrete_dark, false, root)

func _build_stadium(o: Vector3) -> void:
    var root := Node3D.new()
    root.name = "InfiniteStadium"
    root.position = o
    add_child(root)

    _box(Vector3(0, -0.6, 0), Vector3(490, 1.2, 390), concrete_dark, true, root)
    _box(Vector3(0, 0.02, 0), Vector3(150, 0.06, 82), wet_black, false, root)

    for tier in range(15):
        var y := 0.6 + tier * 1.15
        var inner_x := 92.0 + tier * 8.8
        var inner_z := 60.0 + tier * 7.3
        var thickness := 7.5
        var side_len_z := inner_z * 2.0 + thickness * 2.0
        _box(Vector3(inner_x, y, 0), Vector3(thickness, 1.0, side_len_z), concrete, tier < 5, root)
        _box(Vector3(-inner_x, y, 0), Vector3(thickness, 1.0, side_len_z), concrete, tier < 5, root)
        _box(Vector3(0, y, inner_z), Vector3(inner_x * 2.0, 1.0, thickness), concrete_light if tier % 3 == 0 else concrete, tier < 5, root)
        _box(Vector3(0, y, -inner_z), Vector3(inner_x * 2.0, 1.0, thickness), concrete_light if tier % 3 == 0 else concrete, tier < 5, root)

    for x in range(-210, 211, 42):
        _box(Vector3(x, 27, -165), Vector3(3, 54, 3), concrete_black, false, root)
        _box(Vector3(x, 27, 165), Vector3(3, 54, 3), concrete_black, false, root)
        _light_strip(Vector3(x, 39, -155), Vector3(1.2, 0.18, 18), root, 10.0, 50.0, x % 84 == 0)
        _light_strip(Vector3(x, 39, 155), Vector3(1.2, 0.18, 18), root, 10.0, 50.0, x % 84 == 0)

    _box(Vector3(0, 50, -183), Vector3(490, 2, 28), concrete_black, false, root)
    _box(Vector3(0, 50, 183), Vector3(490, 2, 28), concrete_black, false, root)

func _build_reservoir(o: Vector3) -> void:
    var root := Node3D.new()
    root.name = "BlackReservoir"
    root.position = o
    add_child(root)

    _box(Vector3(0, -0.7, 0), Vector3(360, 1.4, 440), concrete_black, true, root)
    _box(Vector3(0, 0.04, 0), Vector3(330, 0.08, 410), wet_black, false, root)
    _box(Vector3(-181, 10, 0), Vector3(2, 20, 440), concrete_dark, true, root)
    _box(Vector3(181, 10, 0), Vector3(2, 20, 440), concrete_dark, true, root)
    _box(Vector3(0, 20.5, 0), Vector3(360, 1.2, 440), concrete_black, false, root)

    for x in range(-145, 146, 58):
        for z in range(-180, 181, 60):
            _box(Vector3(x, 7.5, z), Vector3(8, 15, 8), concrete_dark, false, root)
            if int((x + z) / 2) % 2 == 0:
                _light_strip(Vector3(x, 19.2, z), Vector3(18, 0.14, 1.0), root, 7.0, 25.0, false)

    for z in range(-190, 191, 38):
        _box(Vector3(0, 19.2, z), Vector3(360, 0.7, 0.7), metal_dark, false, root)

func _build_hanging_city(o: Vector3) -> void:
    var root := Node3D.new()
    root.name = "HangingCity"
    root.position = o
    add_child(root)

    _box(Vector3(0, -0.6, 0), Vector3(430, 1.2, 360), concrete_dark, true, root)
    _box(Vector3(0, 74, 0), Vector3(430, 2.0, 360), concrete_black, false, root)
    _box(Vector3(-216, 37, 0), Vector3(2, 74, 360), concrete_black, true, root)
    _box(Vector3(216, 37, 0), Vector3(2, 74, 360), concrete_black, true, root)

    var blocks := [
        [Vector3(-135, 40, -95), Vector3(70, 22, 64)],
        [Vector3(-25, 55, -110), Vector3(105, 16, 48)],
        [Vector3(105, 35, -75), Vector3(58, 34, 76)],
        [Vector3(145, 54, 25), Vector3(92, 18, 52)],
        [Vector3(34, 29, 78), Vector3(120, 24, 68)],
        [Vector3(-112, 50, 86), Vector3(74, 18, 96)],
        [Vector3(-5, 65, 10), Vector3(54, 12, 54)]
    ]
    for i in range(blocks.size()):
        var entry = blocks[i]
        _box(entry[0], entry[1], concrete_light if i % 3 == 0 else concrete, false, root)
        var block_size: Vector3 = entry[1]
        _box(entry[0] + Vector3(0, block_size.y * 0.5 + 20, 0), Vector3(1.4, 40, 1.4), metal_dark, false, root)

    _box(Vector3(0, 10, 0), Vector3(350, 1.1, 4.0), concrete_light, true, root)
    _box(Vector3(0, 10, 0), Vector3(4.0, 1.1, 290), concrete_light, true, root)
    _box(Vector3(-110, 15, 65), Vector3(130, 1.0, 3.0), concrete, true, root, Vector3(0, deg_to_rad(22), 0))

    for x in range(-180, 181, 60):
        _light_strip(Vector3(x, 70.5, 0), Vector3(22, 0.16, 1.0), root, 12.0, 62.0, x % 120 == 0)

func _build_light_cathedral(o: Vector3) -> void:
    var root := Node3D.new()
    root.name = "LightCathedral"
    root.position = o
    add_child(root)

    _box(Vector3(0, -0.6, 0), Vector3(370, 1.2, 370), concrete, true, root)
    _box(Vector3(0, 48, -186), Vector3(370, 96, 2), concrete_black, true, root)
    _box(Vector3(0, 48, 186), Vector3(370, 96, 2), concrete_black, true, root)

    for x in range(-150, 151, 30):
        for z in [-120.0, -60.0, 60.0, 120.0]:
            var h := 31.0 + float(abs(x) % 60) * 0.18
            _box(Vector3(x, h * 0.5, z), Vector3(5, h, 20), concrete_dark, false, root)
            _box(Vector3(x + (2.9 if z > 0 else -2.9), h * 0.52, z), Vector3(0.28, h * 0.78, 8.0), emissive_dim, false, root)

    for z in range(-150, 151, 50):
        _light_strip(Vector3(0, 56, z), Vector3(88, 0.18, 1.1), root, 12.0, 56.0, true)
        _box(Vector3(0, 57.5, z), Vector3(118, 3.0, 2.0), concrete_black, false, root)

    for x in [-178.0, 178.0]:
        _box(Vector3(x, 45, 0), Vector3(4, 90, 370), concrete_black, false, root)

func _build_quarry(o: Vector3) -> void:
    var root := Node3D.new()
    root.name = "InvertedQuarry"
    root.position = o
    add_child(root)

    _box(Vector3(0, -1.0, 0), Vector3(440, 2, 440), concrete_black, true, root)
    for level in range(11):
        var y := -level * 3.2
        var half := 190.0 - level * 14.0
        var band := 12.0
        var mat := concrete_light if level % 4 == 0 else concrete
        _box(Vector3(half, y, 0), Vector3(band, 2.0, half * 2), mat, false, root)
        _box(Vector3(-half, y, 0), Vector3(band, 2.0, half * 2), mat, false, root)
        _box(Vector3(0, y, half), Vector3(half * 2, 2.0, band), mat, false, root)
        _box(Vector3(0, y, -half), Vector3(half * 2, 2.0, band), mat, false, root)

    _box(Vector3(0, 0.15, 0), Vector3(410, 0.3, 14), concrete_light, true, root)
    _box(Vector3(0, 0.15, 0), Vector3(14, 0.3, 410), concrete_light, true, root)
    for z in [-150.0, -75.0, 75.0, 150.0]:
        _box(Vector3(0, 15, z), Vector3(360, 2, 2), metal_dark, false, root)
        _box(Vector3(-150, 8, z), Vector3(2, 16, 2), metal_dark, false, root)
        _box(Vector3(150, 8, z), Vector3(2, 16, 2), metal_dark, false, root)
        _light_strip(Vector3(0, 13.8, z), Vector3(44, 0.14, 0.8), root, 9.0, 38.0, false)

func _build_tunnel(a: Vector3, b: Vector3, style: int) -> void:
    var delta := b - a
    var length := delta.length()
    var root := Node3D.new()
    root.name = "Tunnel_%02d" % style
    root.position = (a + b) * 0.5
    root.rotation.y = atan2(delta.x, delta.z)
    add_child(root)

    var width := 12.0
    var height := 8.5
    if style == 5:
        width = 16.0
        height = 11.0
    elif style == 7:
        width = 7.5
        height = 14.0

    _box(Vector3(0, -0.35, 0), Vector3(width, 0.7, length), concrete_dark, true, root)
    _box(Vector3(-width * 0.5, height * 0.5, 0), Vector3(0.7, height, length), concrete, true, root)
    _box(Vector3(width * 0.5, height * 0.5, 0), Vector3(0.7, height, length), concrete, true, root)
    if style != 6:
        _box(Vector3(0, height, 0), Vector3(width, 0.7, length), concrete_black, false, root)

    var step := 8.0 if style in [0, 1, 5] else 10.0
    var count := int(length / step)
    for i in range(count + 1):
        var z := -length * 0.5 + i * step
        match style:
            0:
                _tunnel_frame(root, z, width, height, 0.55, 0.0)
            1:
                var offset := sin(i * 1.35) * 1.6
                _tunnel_frame(root, z, width - 1.4, height - 0.8, 0.45, offset)
            2:
                _box(Vector3(-width * 0.42, height * 0.52, z), Vector3(0.8, height * 0.78, 1.0), concrete_black, false, root, Vector3(0, 0, deg_to_rad(-9)))
                _box(Vector3(width * 0.42, height * 0.52, z), Vector3(0.8, height * 0.78, 1.0), concrete_black, false, root, Vector3(0, 0, deg_to_rad(9)))
                _box(Vector3(0, height * 0.9, z), Vector3(width * 0.7, 0.7, 1.0), concrete_black, false, root)
            3:
                _box(Vector3(-width * 0.36, 1.0, z), Vector3(0.7, 2.0, 1.1), metal_dark, false, root)
                _box(Vector3(width * 0.36, 1.0, z), Vector3(0.7, 2.0, 1.1), metal_dark, false, root)
                _cylinder(Vector3(-width * 0.34, height - 1.0, z), 0.23, step * 0.85, metal_dark, false, root, Vector3(deg_to_rad(90), 0, 0))
            4:
                var side := -1.0 if i % 2 == 0 else 1.0
                _box(Vector3(side * width * 0.34, height * 0.5, z), Vector3(width * 0.34, height * 0.74, 1.0), concrete_black, false, root)
            5:
                _tunnel_frame(root, z, width, height, 0.8, 0.0)
                _box(Vector3(0, height * 0.62, z), Vector3(width * 0.28, height * 0.55, 1.5), concrete_black, false, root)
            6:
                _box(Vector3(0, 10.0, z), Vector3(width + 5, 0.7, 1.4), concrete_black, false, root)
                _box(Vector3(-width * 0.58, 5.0, z), Vector3(0.8, 10, 1.0), concrete_dark, false, root)
                _box(Vector3(width * 0.58, 5.0, z), Vector3(0.8, 10, 1.0), concrete_dark, false, root)
            7:
                _box(Vector3(-width * 0.30, height * 0.5, z), Vector3(0.7, height * 0.82, 1.0), concrete_black, false, root)
                _box(Vector3(width * 0.30, height * 0.5, z), Vector3(0.7, height * 0.82, 1.0), concrete_black, false, root)

        if i % 2 == 0:
            _light_strip(Vector3(0, height - 0.7, z + step * 0.15), Vector3(width * 0.46, 0.12, 0.7), root, 6.5 if style != 7 else 5.5, 20.0, i % 6 == 0)

func _tunnel_frame(parent: Node3D, z: float, width: float, height: float, thickness: float, offset: float) -> void:
    _box(Vector3(-width * 0.5 + offset, height * 0.5, z), Vector3(thickness, height, thickness), concrete_black, false, parent)
    _box(Vector3(width * 0.5 + offset, height * 0.5, z), Vector3(thickness, height, thickness), concrete_black, false, parent)
    _box(Vector3(offset, height, z), Vector3(width, thickness, thickness), concrete_black, false, parent)

func _greek_column(pos: Vector3, height: float, parent: Node3D) -> void:
    _box(pos + Vector3(0, 0.45, 0), Vector3(5.6, 0.9, 5.6), concrete_light, false, parent)
    _box(pos + Vector3(0, 1.25, 0), Vector3(4.4, 0.7, 4.4), concrete, false, parent)
    _cylinder(pos + Vector3(0, height * 0.5 + 1.2, 0), 1.55, height, concrete_light, false, parent)
    _box(pos + Vector3(0, height + 1.35, 0), Vector3(4.6, 0.85, 4.6), concrete, false, parent)
    _box(pos + Vector3(0, height + 2.0, 0), Vector3(6.0, 0.5, 6.0), concrete_light, false, parent)

func _light_strip(pos: Vector3, size: Vector3, parent: Node3D, energy: float = 8.0, light_range: float = 30.0, shadows: bool = false) -> void:
    _box(pos, size, emissive_white, false, parent)
    var light := SpotLight3D.new()
    light.position = pos + Vector3(0, -0.25, 0)
    light.rotation_degrees.x = -90.0
    light.light_color = Color(0.86, 0.91, 1.0)
    light.light_energy = energy
    light.spot_range = light_range
    light.spot_angle = 68.0
    light.spot_attenuation = 0.72
    light.shadow_enabled = shadows
    light.distance_fade_enabled = true
    light.distance_fade_begin = min(45.0, light_range * 1.2)
    light.distance_fade_length = 22.0
    parent.add_child(light)

func _box(pos: Vector3, size: Vector3, material: Material, collision: bool, parent: Node3D, rotation: Vector3 = Vector3.ZERO) -> MeshInstance3D:
    var mesh := BoxMesh.new()
    mesh.size = size
    var instance := MeshInstance3D.new()
    instance.mesh = mesh
    instance.material_override = material
    instance.position = pos
    instance.rotation = rotation
    parent.add_child(instance)
    if collision:
        var body := StaticBody3D.new()
        var shape_node := CollisionShape3D.new()
        var shape := BoxShape3D.new()
        shape.size = size
        shape_node.shape = shape
        body.add_child(shape_node)
        instance.add_child(body)
    return instance

func _cylinder(pos: Vector3, radius: float, height: float, material: Material, collision: bool, parent: Node3D, rotation: Vector3 = Vector3.ZERO) -> MeshInstance3D:
    var mesh := CylinderMesh.new()
    mesh.top_radius = radius
    mesh.bottom_radius = radius
    mesh.height = height
    mesh.radial_segments = 16
    mesh.rings = 1
    var instance := MeshInstance3D.new()
    instance.mesh = mesh
    instance.material_override = material
    instance.position = pos
    instance.rotation = rotation
    parent.add_child(instance)
    if collision:
        var body := StaticBody3D.new()
        var shape_node := CollisionShape3D.new()
        var shape := CylinderShape3D.new()
        shape.radius = radius
        shape.height = height
        shape_node.shape = shape
        body.add_child(shape_node)
        instance.add_child(body)
    return instance

func _sphere(pos: Vector3, scale_value: Vector3, material: Material, parent: Node3D) -> MeshInstance3D:
    var mesh := SphereMesh.new()
    mesh.radius = 1.0
    mesh.height = 2.0
    mesh.radial_segments = 24
    mesh.rings = 12
    var instance := MeshInstance3D.new()
    instance.mesh = mesh
    instance.material_override = material
    instance.position = pos
    instance.scale = scale_value
    parent.add_child(instance)
    return instance
