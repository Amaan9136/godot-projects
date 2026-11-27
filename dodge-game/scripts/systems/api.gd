extends Node

var base_url: String = ProjectSettings.get_setting("application/config/api_url", "")
var token: String = ""
var user: Dictionary = {}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	token = LocalStore.read("session", "token", "")


func request(method: HTTPClient.Method, path: String, body: Dictionary = {}) -> Dictionary:
	var http := HTTPRequest.new()
	http.timeout = 10.0
	add_child(http)
	var headers := PackedStringArray(["Content-Type: application/json", "Authorization: Bearer " + token])
	if http.request(base_url + path, headers, method, JSON.stringify(body)) != OK:
		http.queue_free()
		return {"error": "Network error"}
	var response: Array = await http.request_completed
	http.queue_free()
	var data: Variant = JSON.parse_string(response[3].get_string_from_utf8())
	return data if data is Dictionary else {"error": "Network error"}


func authenticate(path: String, body: Dictionary) -> String:
	var data := await request(HTTPClient.METHOD_POST, path, body)
	if data.has("error"):
		return data.error
	token = data.token
	LocalStore.write("session", {"token": token})
	_apply(data.user)
	return ""


func restore() -> bool:
	if token.is_empty() or not user.is_empty():
		return false
	var data := await request(HTTPClient.METHOD_GET, "/me")
	if data.has("error"):
		return false
	_apply(data.user)
	return true


func clear() -> void:
	token = ""
	user = {}
	LocalStore.write("session", {"token": ""})
	GameManager.load_best()


func logout() -> void:
	clear()
	GameManager.go_to_menu()


func _apply(profile: Dictionary) -> void:
	user = profile
	GameManager.best_score = int(profile.bestScore)
	GameManager.best_level = int(profile.bestLevel)
