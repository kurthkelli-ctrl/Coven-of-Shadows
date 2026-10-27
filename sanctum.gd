
extends Node2D

# COVEN OF SHADOWS - MOONLIT SANCTUM
# Main game controller for Godot 4

# PLAYER DATA
var player_level: int = 2
var current_xp: int = 140
var max_xp: int = 200
var player_hp: float = 85.0
var player_mp: float = 65.0
var moon_coins: int = 10
var amethyst_gems: int = 30

# GARDEN DATA
var soil_moisture: float = 65.0
var growth_time_left: float = 84.0
var is_grown: bool = false

# MOON PHASES
enum MoonPhase { NEW, WAXING, FULL, WANING }
var current_moon: MoonPhase = MoonPhase.FULL

# SCENE NODES
@onready var background_sprite: Sprite2D = $Background
@onready var rowan_sprite: Sprite2D = $Rowan
@onready var garden_area: Area2D = $GardenPlot

# TOP BAR
@onready var label_level: Label = $UI/TopBar/LevelLabel
@onready var bar_hp: ProgressBar = $UI/TopBar/HPBar
@onready var bar_mp: ProgressBar = $UI/TopBar/MPBar
@onready var label_coins: Label = $UI/TopBar/CoinsLabel
@onready var label_gems: Label = $UI/TopBar/GemsLabel
@onready var label_moon_phase: Label = $UI/TopBar/MoonPhaseLabel

# GARDEN WIDGETS
@onready var moisture_widget: Control = $UI/MoistureWidget
@onready var moisture_bar: ProgressBar = $UI/MoistureWidget/MoistureBar
@onready var moisture_timer_label: Label = $UI/MoistureWidget/TimerLabel

@onready var harvest_widget: Control = $UI/HarvestWidget
@onready var growth_timer_label: Label = $UI/HarvestWidget/TimerLabel
@onready var btn_harvest: TextureButton = $UI/HarvestWidget/HarvestButton

@onready var toast_label: Label = $UI/ToastNotification

var rowan_start_position: Vector2
var toast_tween: Tween


func _ready() -> void:
	rowan_start_position = rowan_sprite.position

	garden_area.input_pickable = true
	garden_area.collision_layer = 1

	btn_harvest.pressed.connect(
		_on_harvest_button_pressed
	)

	garden_area.input_event.connect(
		_on_garden_plot_tapped
	)

	harvest_widget.visible = true
	moisture_widget.visible = true

	moisture_bar.max_value = 100.0
	bar_hp.max_value = 100.0
	bar_mp.max_value = 100.0

	update_all_ui()
	show_toast("Welcome to the Moonlit Sanctum!")


func _process(delta: float) -> void:
	if soil_moisture > 0.0:
		soil_moisture = max(
			0.0,
			soil_moisture - delta * 0.5
		)

	moisture_bar.value = soil_moisture

	if not is_grown:
		if soil_moisture > 10.0:
			growth_time_left = max(
				0.0,
				growth_time_left - delta
			)

			var time_text = format_time(
				growth_time_left
			)

			growth_timer_label.text = time_text
			moisture_timer_label.text = time_text

			if growth_time_left <= 0.0:
				plant_fully_grown()
		else:
			growth_timer_label.text = "DRY SOIL"
			moisture_timer_label.text = "WATER ME!"


# GARDEN INTERACTION
func _on_garden_plot_tapped(
	_viewport: Node,
	event: InputEvent,
	_shape_idx: int
) -> void:

	var tapped = false

	if event is InputEventScreenTouch:
		tapped = event.pressed

	elif event is InputEventMouseButton:
		tapped = (
			event.button_index == MOUSE_BUTTON_LEFT
			and event.pressed
		)

	if tapped:
		harvest_widget.visible = not harvest_widget.visible
		moisture_widget.visible = harvest_widget.visible


# PLANT GROWTH
func plant_fully_grown() -> void:
	is_grown = true
	btn_harvest.disabled = false
	btn_harvest.modulate = Color.WHITE

	growth_timer_label.text = "READY!"
	moisture_timer_label.text = "READY!"

	play_plant_glow_animation()
	show_toast("Moonlit Flora is in full bloom!")


# HARVESTING
func _on_harvest_button_pressed() -> void:
	if is_grown:
		moon_coins += 25
		current_xp += 60

		is_grown = false
		growth_time_left = 84.0

		btn_harvest.disabled = true
		btn_harvest.modulate = Color(
			0.6, 0.6, 0.6, 1.0
		)

		play_rowan_kneel_anim()
		check_level_up()
		update_all_ui()

		show_toast(
            "Moonberry harvested! +25 Coins, +60 XP"
		)


# WATERING
func water_plant(amount: float = 35.0) -> void:
	soil_moisture = min(
		100.0,
		soil_moisture + amount
	)

	moisture_bar.value = soil_moisture

	show_toast("Watered with Moon Dew!")

	var tween = create_tween()
	tween.tween_property(
		moisture_widget,
		"scale",
		Vector2(1.1, 1.1),
		0.1
	)
	tween.tween_property(
		moisture_widget,
		"scale",
		Vector2.ONE,
		0.1
	)


# ROWAN ANIMATION
func play_rowan_kneel_anim() -> void:
	var tween = create_tween()

	tween.tween_property(
		rowan_sprite,
		"position:y",
		rowan_start_position.y + 4.0,
		0.15
	)

	tween.tween_property(
		rowan_sprite,
		"scale",
		Vector2(1.03, 0.97),
		0.15
	)

	tween.tween_property(
		rowan_sprite,
		"position:y",
		rowan_start_position.y,
		0.2
	)

	tween.tween_property(
		rowan_sprite,
		"scale",
		Vector2.ONE,
		0.2
	)


# PLANT GLOW
func play_plant_glow_animation() -> void:
	var tween = create_tween().set_loops(3)

	tween.tween_property(
		garden_area,
		"modulate",
		Color(1.3, 1.3, 2.0, 1.0),
		0.4
	)

	tween.tween_property(
		garden_area,
		"modulate",
		Color.WHITE,
		0.4
	)


# LEVEL SYSTEM
func check_level_up() -> void:
	while current_xp >= max_xp:
		current_xp -= max_xp
		player_level += 1

		max_xp = int(max_xp * 1.5)
		moon_coins += 50
		amethyst_gems += 5

		show_toast(
            "LEVEL UP! Rowan reached Level "
			+ str(player_level)
		)


# UPDATE UI
func update_all_ui() -> void:
	label_level.text = "Level " + str(player_level)

	bar_hp.value = player_hp
	bar_mp.value = player_mp

	label_coins.text = str(moon_coins)
	label_gems.text = str(amethyst_gems)

	moisture_bar.value = soil_moisture

	if is_grown:
		growth_timer_label.text = "READY!"
		moisture_timer_label.text = "READY!"
	else:
		growth_timer_label.text = format_time(
			growth_time_left
		)
		moisture_timer_label.text = format_time(
			growth_time_left
		)

	btn_harvest.disabled = not is_grown

	match current_moon:
		MoonPhase.NEW:
			label_moon_phase.text = "New Moon"
		MoonPhase.WAXING:
			label_moon_phase.text = "Waxing Moon"
		MoonPhase.FULL:
			label_moon_phase.text = "Full Moon"
		MoonPhase.WANING:
			label_moon_phase.text = "Waning Moon"


# TIME FORMAT
func format_time(seconds: float) -> String:
	var total_seconds: int = int(ceil(seconds))
	var minutes: int = int(total_seconds / 60)
	var remaining_seconds: int = total_seconds % 60

	return "%02d:%02d" % [
		minutes,
		remaining_seconds
	]


# NOTIFICATIONS
func show_toast(message: String) -> void:
	toast_label.text = message
	toast_label.visible = true

	if toast_tween and toast_tween.is_running():
		toast_tween.kill()

	toast_tween = create_tween()
	toast_tween.tween_interval(2.0)
	toast_tween.tween_callback(
		func(): toast_label.visible = false
	)
