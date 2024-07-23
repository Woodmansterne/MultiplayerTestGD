extends Node2D

var peer = ENetMultiplayerPeer.new()
@export var player_scene : PackedScene
@onready var button_container: VBoxContainer = %ButtonContainer
@onready var status_label: Label = %StatusLabel

##SERVER SIGNALS
signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected

func _ready():
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)



func _on_host_button_pressed() -> void:
	peer.create_server(7000,32)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	_add_player()
	button_container.hide()
	status_label.text = "STATUS: HOSTING GAME"
	#player_connected.emit(1,"HOST")

func _add_player(id = 1):
	print("ID: %s Connected!" % id)
	var new_player = player_scene.instantiate()
	new_player.name = str(id)
	call_deferred("add_child",new_player)

var PC_IP = "192.168.0.26"
func _on_join_button_pressed() -> void:
	peer.create_client(PC_IP,7000)
	multiplayer.multiplayer_peer = peer
	button_container.hide()
	status_label.text = "STATUS: JOINED AS PEER"


func _on_join_button_local_pressed() -> void:
	peer.create_client("localhost",7000)
	multiplayer.multiplayer_peer = peer
	button_container.hide()
	status_label.text = "STATUS: JOINED LOCALLY AS PEER"


func _on_player_disconnected():
	print("Player disconnected!")
func _on_connected_ok():
	print("Connected OK!")
func _on_connected_fail():
	print("Connection failed!")
func _on_server_disconnected():
	print("Server disconnected!")
