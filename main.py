from pathlib import Path
import os

smile_file = Path(__file__).parent

"""try:
    if os.path.exists(smile_file):
        os.chmod(smile_file, 666)
        print("File permissions modified successfully!")
    else:
        print("File not found:", smile_file)
except PermissionError:
    print("Permission denied: You don't have the necessary permissions to change the permissions of this file.")"""

sosorry = ""

with open(smile_file/"global.js", "r") as f:
    sosorry = f.read()

with open(smile_file/"global.js", "w") as f:
    f.write(sosorry.replace("{\"id",",{\n            \"id"))
