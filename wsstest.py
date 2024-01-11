from websocket import WebSocketApp
from threading import Thread
from json import loads,dumps
#"^3.7" import msvcrt


def message_sending(ws:WebSocketApp):
    while 1:
        message_text=input("Message: ")#msvcrt.kbhit()
        if message_text!="" and message_text!=0:
            #print(message_text)
            ws.send(f"""{{"type": "send_message",
                        "data": {{
                            "channel_id": "190739",
                            "text": "{message_text}",
                            "color": "streamer",
                            "icon": "top1",
                            "role": "",
                            "mobile": 0}}}}""")

def on_open(ws:WebSocketApp):
    print("Connection opened")
    ws.send("""{"type": "auth",
             "data": {"user_id": 0}}""")
    
    ws.send("""{"type": "join",
                "data": {
                    "channel_id": "190739",
                    "hidden": 0,
                    "mobile": false,
                    "reload": false}}""")
    t1 = Thread(target=message_sending,args=[ws])
    t1.start()

def on_message(ws:WebSocketApp, message:str):
    jmessage=loads(message)
    if jmessage["type"]=="message":
        print(f"{jmessage['data']['user_name']}: {jmessage['data']['text']}")
    elif jmessage["type"]=="channel_counters":pass
    else:
        print(f"Received message: {message}")

def on_close(ws:WebSocketApp):
    print("Connection closed")


ws=WebSocketApp("wss://chat-1.goodgame.ru/chat2/",
                on_open=on_open,
                on_message=on_message,
                on_close=on_close)
ws.run_forever()

print("End")
