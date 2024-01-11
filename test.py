from json import dumps,loads

text="FFFFFFFFFF"
print(loads(f"""{{"type": "send_message",
                 "data": {{
                     "channel_id": "190739",
                     "text": "{text}",
                     "color": "streamer",
                     "icon": "top1",
                     "role": "",
                     "mobile": 0}}}}"""))

print(f"""{{"type": "send_message",
                    "data": {{
                        "channel_id": "190739",
                        "text": "{text}",
                        "color": "streamer",
                        "icon": "top1",
                        "role": "",
                        "mobile": 0}}}}""")