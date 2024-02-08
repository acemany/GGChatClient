extends Node
#https://quizizz.com/admin/quiz/65c39f2dd1c17c3bc760d373/edit?at=65c3ac4ce48800675b7cb78a

@onready var message_container = "ScrollContainer/VBoxContainer"
@onready var scroll_container = $ScrollContainer
@onready var button_scroll = $ButtonScroll
@onready var line_edit = $LineEdit

var socket = WebSocketPeer.new()
var started = false
var messages = []
var message = ""
var jmessage = {}
var channel_id = CHANEL_ID

var bronzeNick = "e7820a"
var silverNick = "b4b4b4"
var goldNick = "eefc08"
var chatYellow = "F2F932"
var diamondNick = "8781bd"
var kingNick = "30d5c8"
var topNick = "3BCBFF"
var darkPink = "BD70D7"
var undeadNick = "AB4873"
var premiumNick = "31a93a"
var moderatorNick = "ec4058"
var streamerNick = "e8bb00"


func _ready():
	socket.connect_to_url("wss://chat-1.goodgame.ru/chat2/")
	print("!STARTED!")
	
	for i in messages:
		var messa = RichTextLabel.new()
		messa.custom_minimum_size = Vector2(1000, 24)
		messa.autowrap_mode = TextServer.AUTOWRAP_WORD
		messa.bbcode_enabled = true
		var usercolor = ""
		if jmessage['data']['color'] == "premium-personal":
			usercolor = "purple"
		elif jmessage['data']['color'] == "simple":
			usercolor = "green"
		else:
			usercolor = "gray"
		messa.text = "[color=%s]%s[/color]: %s" % [usercolor, jmessage['data']['user_name'], jmessage['data']['text']]
		get_node(message_container).add_child(messa)

func _process(_delta):
	
	socket.poll()
	var state = socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		if not started:7e062991eae9061d8367f82cb1a7a4ad
			started = true
			socket.send_text(str({"type": "auth",
								 "data": {"user_id":INSERT_USERNAME,
										  "token":"INSERT_USER_TOKEN",
										  "object":"",
										  "active":true}}))
			socket.send_text(str({"type": "join",
								  "data": {"channel_id": "channel_id",
										   "hidden": 0,
										   "mobile": false,
										   "reload": false}}))
			socket.send_text(str({"type": "get_channel_history",
								  "data": {"channel_id": "channel_id"}}))
		else:
			while socket.get_available_packet_count():
				message = socket.get_packet().get_string_from_utf8()
				jmessage = JSON.parse_string(message)
				debuglog(message)
				if jmessage["type"] == "message":
					logf("New message from %s(%s): %s" % [jmessage['data']['user_name'], jmessage['data']['user_id'], jmessage['data']['text']], 0)
					print("%s: %s" % [jmessage['data']['user_name'], jmessage['data']['text']])
					append_message(jmessage)
				elif jmessage["type"] == "error":
					logf("Wss error{}" % jmessage['data'], 2)
					print("%s(%s)" % [jmessage['data']['errorMsg'], jmessage['data']])
				elif jmessage["type"] == "channel_counters":
					logf("%s clients and %s users in channel'%s'" % [jmessage['data']['clients_in_channel'], jmessage['data']['users_in_channel'], jmessage['data']["channel_id"]])
				elif jmessage["type"] == "channel_history":
					logf("Getting history of channel[%s] - %s" % [jmessage['data']["channel_id"], str(len(jmessage["data"]["messages"]))])
					for i in jmessage["data"]["messages"]:
						append_message(i, true)
				else:
					logf("Unknown message: %s" % message, 1)
					print("Received message: %s" % message)
			if button_scroll.button_pressed:
				scroll_container.scroll_vertical += 2
	elif state == WebSocketPeer.STATE_CLOSING:
		logf("Closing")
		print("!CLOSING!")
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = socket.get_close_code()
		var reason = socket.get_close_reason()
		print("!CLOSED WITH CODE!: %d, reason %s. Clean: %s" % [code, reason, code != -1])
		set_process(false)

func _physics_process(_delta):
	messages.sort_custom(id_sort)

func _on_line_edit_text_submitted(new_text):
	socket.send_text(str({"type": "send_message",
						  "data": {
							  "channel_id": "channel_id",
							  "text": new_text,
							  "color": "premium",
							  "icon": "top1",
							  "role": "",
							  "mobile": 0}}))
	line_edit.clear()


func separate_every(a: String, b: float):
	var aaa = []
	for i in range(ceil((len(a)-1)/b)):
		aaa.append([]) #[[] for i in range(ceil((len(rtext)-1)/b))]
	for i in range(len(a)):
		aaa[floor(i/b)].append(a[i])
	var aa = range(len(aaa))
	aa.fill("")
	for i in len(aaa):
		for j in aaa[i]:
			aa[i] += j
	return aa

func time_sort(a, b):
	return Time.get_unix_time_from_datetime_string(a["time"]) < Time.get_unix_time_from_datetime_string(b["time"])

func id_sort(a, b):
	return a["message_id"] < b["message_id"]

func append_message(jsonmessage, listin:bool = false):
	if not listin:
		jsonmessage = jsonmessage["data"]
	var messa = RichTextLabel.new()
	messa.custom_minimum_size = Vector2(1152, 1 * 24)
	messa.autowrap_mode = TextServer.AUTOWRAP_WORD
	var usercolor = ""
	if jsonmessage['color'] == "premium-personal":
		usercolor = premiumNick
	elif jsonmessage['color'] == "simple":
		usercolor = topNick
	elif jsonmessage['color'] == "undead":
		usercolor = undeadNick
	elif jsonmessage['color'] == "diamond":
		usercolor = diamondNick
	elif jsonmessage['color'] == "gold":
		usercolor = goldNick
	elif jsonmessage['color'] == "silver":
		usercolor = silverNick
	elif jsonmessage['color'] == "bronze":
		usercolor = bronzeNick
	elif jsonmessage['color'] == "premium":
		usercolor = premiumNick
	elif jsonmessage['color'] == "king":
		usercolor = kingNick
	elif jsonmessage['color'] == "streamer":
		usercolor = streamerNick
	elif jsonmessage['color'] == "gradient-fire":
		usercolor = chatYellow
	elif jsonmessage['color'] == "":
		usercolor = premiumNick
	else:
		print(jsonmessage['color'])
		usercolor = "#000000"
	messa.append_text("[color=%s]%s[/color]: %s" % [usercolor, jsonmessage['user_name'], jsonmessage['text']])
	get_node(message_container).add_child(messa)
	messages.append({"text": jsonmessage['text'],
					 "user_name": jsonmessage['user_name'],
					 "user_id": jsonmessage['user_id'],
					 "message_id": jsonmessage['message_id'],
					 "time": Time.get_datetime_string_from_unix_time(jsonmessage['timestamp']+10800)})

func logf(err: String, warn: int = 0):
	var warn_level = ""
	if warn > 1:
		warn_level = 'E'
	elif warn:
		warn_level = 'W'
	else:
		warn_level = 'I'
	var file = FileAccess.open("res://log.txt", FileAccess.READ_WRITE)
	file.store_string("%s\n[%s]-%s:\n%s\n" % [file.get_as_text(), warn_level, str(Time.get_datetime_string_from_system()), err])

func debuglog(txt: String):
	"Log.\ntxt - error text."
	var file = FileAccess.open("res://logg.txt", FileAccess.READ_WRITE)
	file.store_string("%s\n%s:\n%s\n" % [file.get_as_text(), str(Time.get_datetime_string_from_system()), txt])
