url="https://goodgame.ru/oauth2/token?Content-Type=application/x-www-form-urlencoded&grant_type=authorization_code&client_id=GGPYChatClient&client_secret=8r*lc66KpibjB(tSKwK,Z8emMNc+ji?WadUwiYENfzVTgTGy:3@MK3ZdMCte&redirect_uri=https://github.com/acemany/GGPYChatClient&code=def502002a45852186578f7190db242ba75b405ac0bc70ebd7f5f3728f16453c962baca9125b11aa1989188babd5a53436fe17832367845a6599717a53dd370e8644d9c8841348f6aaef918c0c923eddebec41bb748d70c0c279d4ab53249102d7a3e273c37b68fba96053bb399b36510b5ff6f194f028435c4b1187432e83323c00fc2a0e3077c7dc5fc381089e751c604e75a2f665d657f3529eb7aa768078ce600f5639ce3c1f0fa7bc961a62a468a8475eb54dfe7675a0ae9e40f4db470c20d68fc7dfa9ffab39641c20ab1625257811daeec3644cbcb1c0e2e44031ec296157992c52cd4322c31bd3ae7065964cd7bcd9e629672aa319dbe315c35da99553e09e6008df73ed22b6b93dd0c7d7904c122085acb4898ec875d2ded6afc249f80a3b4b9957e1610d012d11e3470d43881fde2ed65b83efdc3f0bf757117aea22adbf5ea19c42ab57ddded026c5f49cfe1a37c6ec009b5851eb4667f1e73d5363105194e7904872405227c44731590d72abf11e57c0ed6450216bc6554ba5"

import requests

response=requests.post(url)

print(response.text)