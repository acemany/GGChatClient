extends Node

@onready var button_scroll = $Main/Head/ButtonScroll
@onready var channel_header = $Main/Head/ChannelHeader
@onready var channel_counter = $Main/Head/ChannelCounter
@onready var scroll_container = $Main/Body
@onready var message_container = $Main/Body/Messages
@onready var line_edit = $Main/Footer/LineEdit

@export var user_id: int
@export var user_token: String
#            Acemany   Degrabebs
@export_enum("207157", "190739") var channel_id: String = "207157"


var smile_loader = HTTPRequest.new()
var socket: WebSocketPeer = WebSocketPeer.new()

var started: bool = false
var messages: Array = []

var bronze_nick = "e7820a"
var silver_nick = "b4b4b4"
var gold_nick = "eefc08"
var chat_yellow = "f2f932"
var diamond_nick = "8781bd"
var king_nick = "30d5c8"
var top_nick = "3bCbff"
var dark_pink = "bd70d7"
var undead_nick = "ab4873"
var premium_nick = "31a93a"
var moderator_nick = "ec4058"
var streamer_nick = "e8bb00"


func _ready():
	add_child(smile_loader)
	smile_loader.connect("request_completed", _http_request_completed)
	#smile_loader.request("https://goodgame.ru/images/smiles/DegraBebs/%s.png" % smile)
	
	socket.connect_to_url("wss://chat-1.goodgame.ru/chat2/")
	print("STARTED")

func _process(_delta):
	socket.poll()
	var state = socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		if !started:
			started = true
			wss_start()
		else:
			while socket.get_available_packet_count():
				var message = socket.get_packet().get_string_from_utf8()
				var json_message = JSON.parse_string(message)
				var message_type: String = json_message["type"]
				var message_data: Dictionary = json_message["data"]
				print(message_data)
				match message_type:
					"success_join":
						channel_header.clear()
						channel_header.append_text("[center]%s[/center]" % message_data['channel_name'])
						line_edit.editable = not message_data['premium_only'] as bool
						channel_counter.text = "ጰ %s 🤖 %s" % [message_data['users_in_channel'], message_data['clients_in_channel']-message_data['users_in_channel']]
					"channel_history":
						for i in message_data['messages']:
							append_message(i)
					"message":
						append_message(message_data)
					"error":
						logf("Error%s" % message_data, 2)
						append_message({
							"text": message_data['errorMsg'],
							"user_name": "ERROR",
							"color": "undead",
							"user_id": 0,
							"message_id": INF,
							"timestamp": Time.get_unix_time_from_system()})
					"channel_counters":
						channel_counter.text = "ጰ %s 🤖 %s" % [message_data['users_in_channel'], message_data['clients_in_channel']-message_data['users_in_channel']]
					_:
						logf("Unknown message: %s" % message, 1)
						print("Received message: %s" % message)
			if button_scroll.button_pressed:
				scroll_container.scroll_vertical += 2
	elif state == WebSocketPeer.STATE_CLOSING:
		logf("Closing")
		print("Closing...")
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = socket.get_close_code()
		var reason = socket.get_close_reason()
		print("CLOSED WITH CODE: %d, reason %s. Clean: %s" % [code, reason, code != -1])
		get_tree().quit()

func _physics_process(_delta):
	messages.sort_custom(id_sort)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		socket.close(1000, "Esc. pressed")


func _on_line_edit_text_submitted(new_text: String) -> void:
	socket.send_text(str({"type": "send_message",
						  "data": {
							  "channel_id": channel_id,
							  "text": new_text,
							  "color": "premium",
							  "icon": "top1",
							  "role": "",
							  "mobile": 0}}))
	line_edit.clear()


func wss_start() -> void:
			socket.send_text(str({"type": "auth",
								  "data":{
									"user_id": user_id,
									"token": user_token,
									"object": "",
									"active": true}}))
			socket.send_text(str({"type": "join",
								  "data": {
									"channel_id": channel_id,
									"hidden": 0,
									"mobile": false,
									"reload": false}}))
			socket.send_text(str({"type": "get_channel_history",
								  "data": {
									"channel_id": channel_id}}))

func separate_every(string: String, freq: float) -> Array[String]:
	var preseparated: Array = []
	for i in range(ceil((len(string)-1)/freq)):
		preseparated.append([])
		
	for i in range(len(string)):
		preseparated[floor(i/freq)].append(string[i])
	var separated = range(len(preseparated))
	separated.fill("")
	
	for i in len(preseparated):
		for j in preseparated[i]:
			separated[i] += j
	return separated

func time_sort(a: Dictionary, b: Dictionary) -> bool:
	return Time.get_unix_time_from_datetime_string(a["time"]) < Time.get_unix_time_from_datetime_string(b["time"])

func id_sort(a: Dictionary, b: Dictionary) -> bool:
	return a["message_id"] < b["message_id"]

func append_message(jmessage: Dictionary) -> void:
	var message: RichTextLabel = RichTextLabel.new()
	message.fit_content = true
	
	var usercolor: String = ""
	match jmessage['color']:
		"premium-personal":
			usercolor = premium_nick
		"simple":
			usercolor = top_nick
		"undead":
			usercolor = undead_nick
		"diamond":
			usercolor = diamond_nick
		"gold":
			usercolor = gold_nick
		"silver":
			usercolor = silver_nick
		"bronze":
			usercolor = bronze_nick
		"premium":
			usercolor = premium_nick
		"king":
			usercolor = king_nick
		"streamer":
			usercolor = streamer_nick
		"gradient-fire":
			usercolor = chat_yellow
		"":
			usercolor = premium_nick
		_:
			print("Unsupported color \"%s\"" % jmessage['color'])
			usercolor = "#ff00ff"
	
	var message_text: String = jmessage['text']
	for i in range(1, 49):
		var smilec = "degrabebs%s" % i
		message_text = message_text.replace(":%s:" % smilec, "[img]res://cache/%s.png[/img]" % smilec)
	message_text = message_text.replace(":gg:", "[img]res://cache/gg.png[/img]")

	message.append_text("[color=%s]%s[/color]: %s" % [usercolor, jmessage['user_name'], message_text])
	message_container.add_child(message)
	messages.append({"text": jmessage['text'],
					 "user_name": jmessage['user_name'],
					 "user_id": jmessage['user_id'],
					 "message_id": jmessage['message_id'],
					 "timestamp": Time.get_datetime_string_from_unix_time(jmessage['timestamp']+10800)})

func _http_request_completed(_result, _response_code, _headers, body):
	var image = Image.new()
	print(image.load_png_from_buffer(body))
	print("Code %s" % image.save_png("res://cache/name.png"))


func logf(err: String, warn: int = 0) -> void:
	var warn_level = ""
	if warn > 1:
		warn_level = 'E'
	elif warn:
		warn_level = 'W'
	else:
		warn_level = 'I'
	var file = FileAccess.open("res://log.txt", FileAccess.READ_WRITE)
	file.store_string("%s\n[%s]-%s:\n%s\n" % [file.get_as_text(), warn_level, Time.get_datetime_string_from_system(), err])
