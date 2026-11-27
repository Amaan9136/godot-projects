extends Control

@onready var name_edit: LineEdit = $VBoxContainer/NameEdit
@onready var username_edit: LineEdit = $VBoxContainer/UsernameEdit
@onready var password_edit: LineEdit = $VBoxContainer/PasswordEdit
@onready var status_label: Label = $VBoxContainer/StatusLabel
@onready var submit_button: Button = $VBoxContainer/SubmitButton
@onready var toggle_button: Button = $VBoxContainer/ToggleButton
@onready var guest_button: Button = $VBoxContainer/GuestButton

var registering: bool = false


func _ready() -> void:
	submit_button.pressed.connect(_on_submit)
	guest_button.pressed.connect(_on_guest)
	password_edit.text_submitted.connect(_on_submit.unbind(1))
	toggle_button.pressed.connect(func() -> void: _set_mode(not registering))
	_set_mode(false)
	if await Api.restore():
		GameManager.go_to_menu()


func _set_mode(value: bool) -> void:
	registering = value
	name_edit.visible = value
	submit_button.text = "Register" if value else "Login"
	toggle_button.text = "Have an account? Login" if value else "New here? Register"
	status_label.text = ""


func _on_submit() -> void:
	submit_button.disabled = true
	status_label.text = "Please wait..."
	var error: String = await Api.authenticate("/register" if registering else "/login", {"name": name_edit.text, "username": username_edit.text, "password": password_edit.text})
	if error.is_empty():
		GameManager.go_to_menu()
		return
	status_label.text = error
	submit_button.disabled = false


func _on_guest() -> void:
	Api.clear()
	GameManager.go_to_menu()
