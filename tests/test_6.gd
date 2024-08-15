extends Node2D



const ORIGIN : Vector2 = Vector2(576, 266.4)
const TEXT : PackedStringArray = [
	"114514",
	"1919810",
	"鸡你太美",
	"你干嘛啊~哎呦~",
	"哇贞德仕泥鸭"
]



@onready var game_menu : VBoxContainer = %game_menu
@onready var game : Node2D = %game
@onready var sprite : Sprite2D = %sprite
@onready var subtitle : PanelContainer = %subtitle

var angle : float = 0.0:
	set(value):
		angle = wrapf(value, 0, TAU)
var velocity : float = PI / 2.0
var current : int = 0
var button : Button = null



func _ready() -> void:
	button = Button.new()
	button.text = "TEXT_QUIT_GAME"
	button.pressed.connect(SceneTreeUtilities.make_quit_confirmation)
	button.hide()
	subtitle.buttons.add_child(button)



func pause() -> void:
	game_menu.show()
	get_tree().paused = true



func resume() -> void:
	game_menu.hide()
	get_tree().paused = false



func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		if game_menu.visible:
			resume()
		else:
			pause()
	
	if get_tree().paused:
		return
	
	sprite.position = ORIGIN + Vector2(cos(angle), sin(angle)) * 100.0
	angle += velocity * delta
	
	if Input.is_action_just_pressed("ui_accept"):
		current = wrapi(current + 1, 0, TEXT.size())
	subtitle.text = TEXT[current]
	button.visible = current == 0



func _on_visibility_changed() -> void:
	if not is_instance_valid(game_menu):
		return
	
	if visible:
		pause()


func _on_button_pressed() -> void:
	velocity *= -1.0


func _on_game_menu_continue_game() -> void:
	resume()


func _on_game_menu_game_settings() -> void:
	resume()
	SceneTreeUtilities.change_to_temp_scene(FrameworkResources.BasicSettingsInterface.instantiate())


func _on_game_menu_quit_game() -> void:
	SceneTreeUtilities.make_quit_confirmation()
