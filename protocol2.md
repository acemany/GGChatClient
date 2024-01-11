# Протокол асинхронного взаимодействия между клиентом и сервером для чата GG v2.

- [Протокол асинхронного взаимодействия между клиентом и сервером для чата GG v2.](#протокол-асинхронного-взаимодействия-между-клиентом-и-сервером-для-чата-gg-v2)
  - [Общая информация](#общая-информация)
    - [Условные обозначения](#условные-обозначения)
    - [Техническая информация](#техническая-информация)
    - [Общий вид JSON-сообщения](#общий-вид-json-сообщения)
  - [Протокол](#протокол)
    - [Основные изменения по сравнению с протоколом v1](#основные-изменения-по-сравнению-с-протоколом-v1)
    - [Версия протокола](#версия-протокола)
    - [Авторизация на сервере (необязательная)](#авторизация-на-сервере-необязательная)
      - [Получение токена](#получение-токена)
    - [Выбор канала](#выбор-канала)
      - [Получение списка каналов](#получение-списка-каналов)
      - [Присоединение к каналу](#присоединение-к-каналу)
      - [Отключение пользователя от канала](#отключение-пользователя-от-канала)
    - [Информация о канале](#информация-о-канале)
      - [Получение списка пользователей](#получение-списка-пользователей)
      - [Получение списка помощников стримера](#получение-списка-помощников-стримера)
      - [Получение количества клиентов и пользователей](#получение-количества-клиентов-и-пользователей)
      - [Информация о статусе канала](#информация-о-статусе-канала)
      - [Изменение настроек](#изменение-настроек)
      - [Выбор случайного зрителя](#выбор-случайного-зрителя)
    - [Игнор-лист](#игнор-лист)
      - [Получение игнор-листа](#получение-игнор-листа)
      - [Добавить в игнор лист](#добавить-в-игнор-лист)
      - [Удалить из игнор листа](#удалить-из-игнор-листа)
      - [Получение истории сообщений канала](#получение-истории-сообщений-канала)
    - [Сообщения](#сообщения)
      - [Отправка сообщения](#отправка-сообщения)
      - [Получение сообщения](#получение-сообщения)
      - [Отправка приватного сообщение](#отправка-приватного-сообщение)
      - [Получение приватного сообщения](#получение-приватного-сообщения)
    - [Уведомления о донатах / подписках / премиумах](#уведомления-о-донатах--подписках--премиумах)
      - [Подписка на канал](#подписка-на-канал)
      - [Донат](#донат)
      - [Активация премиума](#активация-премиума)
      - [Подарочный премиум](#подарочный-премиум)
    - [Модерация](#модерация)
      - [Удаление сообщения](#удаление-сообщения)
      - [Бан пользователя](#бан-пользователя)
      - [Предупреждение пользователя](#предупреждение-пользователя)
      - [Назначение / снятие прав помошника стримера](#назначение--снятие-прав-помошника-стримера)
    - [Голосования](#голосования)
      - [Создание голосования](#создание-голосования)
      - [Запрос текущего голосование](#запрос-текущего-голосование)
      - [Выбор варианта пользователем](#выбор-варианта-пользователем)
      - [Запрос результатов](#запрос-результатов)
      - [Получение результатов](#получение-результатов)
  - [Ошибка](#ошибка)
  - [Уровни прав](#уровни-прав)
  - [Обработка смайлов на стороне клиента](#обработка-смайлов-на-стороне-клиента)


Этот документ описывает протокол общения между клиентом GG-чата и сервером GG-чата.  
Сам документ находится в стадии черновика и любая его часть может быть изменена.  
После того, как протокол будет зафиксирован, ему будет присвоена соответсвующая версия.  
Предпологается, что протокол открытый и не привязан к конкретной клиентской технологии.  
Любой желающий может реализовать клиента, поддерживающего этот протокол.
(Например клиент для iOS или Android)

## Общая информация

* Основан на JSON-кодировании.
* Максимальная длина сообщения 4кб, включая JSON-разметку.
* Под асинхронностью понимается то, что после отправки сообщения одной из сторон,
не обязательно прийдет ответ именно на это сообщение.
* За 1 раз отсылается 1 сообщение.
* Обмен возможен только между клиентом и сервером, т.е. минуя сервер, клиенты общаться не могут.
* Одно соединение может обслуживать несколько каналов (стримов).

### Условные обозначения

- `req_to_server` - запрос клиента к серверу
- `res_to_client` - ответ сервера клиенту
- `res_to_all` - ответ сервера всем клиентам
- `res_to_all_in_channel` - ответ сервера всем клиентам в определенном канале
- `channel_id` - идентификатор канала

channel_id может быть разных видов:
  - `"5"` - чат канала
  - `"r128"` - чат раздела флудилка на форуме
  - `"cup:642ab9c7cddb590015abe39f.298fcf07-e5a5-45b9-b325-5cb81eb8f625"` - чат турнира


### Техническая информация

Для подключения к серверу чата следует использовать websocket-соединение по адресу:

    wss://chat-1.goodgame.ru/chat2/


### Общий вид JSON-сообщения

```json
{
    "type": "", // заголовок сообщения
    "data": {
        //Дополнительная информация.
    }
}
```

data - вынесена в отдельную json сущность, для более удобного разбора параметров сообщения.

## Протокол

### Основные изменения по сравнению с протоколом v1

* Атрибуты `premium` и `payments` убраны, вместо них используются группы.
* Числовое значение для `payments` рекомендуется заменить на набор групп, по уровню доната.
* Для каждого канала пользователь может находиться в разных группах.
* Группа `premium` - предопределенная, остальные группы не регулируются.


### Версия протокола

После установления соединения на "траспортном" уровне, сервер немедленно отвечает сообщением

```json
//res_to_client
{
    "type": "welcome",
    "data": {
        "protocolVersion": 2
    }
}
```

### Авторизация на сервере (необязательная)

Если авторизация не проводилась, то клиент считается гостем

```json
//req_to_server
{
    "type": "auth",
    "data": {
        "user_id": 123,           // идентификатор пользователя на сайте, либо 0 для гостей
        "token": "123123fhjdhfjd" // ключ авторизации. Если не указан, то будет запрошен гостевой доступ.
    }
}

//res_to_client
{
    "type": "success_auth",
    "data": {
        "user_id": "123",     // id-пользователя на сайте, для гостей 0
        "user_name": "Василий" // nick на сайте, для гостей ""
    }
}
```

#### Получение токена

> [!WARNING]  
> Использование этого метода авторизации не рекомендуется.  
> Рекомендуемый метод авторизации для приложений - [OAuth2](https://github.com/GoodGame/api4-php-client/)

Для того чтобы получить токен авторизации необходимо отправить POST-запрос по адресу https://goodgame.ru/ajax/chatlogin  
Через запрос нужно передать два поля (используя формат form-data):

- `login` // Имя пользователя
- `password` // Пароль

Ответ придёт в формате JSON:

```json
//res_to_client
{
    "code": 4,
    "user_id": "12345", // id пользователя
    "login_page": "",
    "settings": "{\"alignType\":0,\"pekaMod\":false,\"sound\":1,\"soundVolume\":14,\"smilesType\":4,\"hide\":0,\"quickBan\":false,\"quickDelete\":1,\"customIcons\":{\"5\":\"none\",\"6809\":\"star\"},\"customColors\":{\"6809\":\"premium-personal\"},\"role\":\"\"}",
    "token": "fa2e9010cb9a4228215be14fbde13226", // токен авторизации
    "result": true, // результат операции
    "return": false,
    "response": "Вы успешно вошли на сайт" // "дружелюбный" результат операции
}
```

### Выбор канала

#### Получение списка каналов

```json
//req_to_server
{
    "type": "get_channels_list",
    "data": {
        "start": 0, // стартовая позиция (отсчет с 0)
        "count": 50 // количество каналов на страницу
    }
}

//res_to_client
{
    "type": "channels_list",
    "data": {
        "channels": [{
            "channel_id": "5",
            "channel_name": "имя канала",
            "clients_in_channel": 545, // всего клиентов в канале, включая гостей
            "users_in_channel": 332,   // всего авторизованных пользователей в канале
        },
        ...] // массив каналов, где есть хотя бы 1 пользователь, гости не считаются.
    }
}
```

Список каналов сортируется по количеству пользователей. На первой позиции чат с наибольшим показателем.

Если channel_id известен заранее, то это сообщение можно не отсылать.

#### Присоединение к каналу

Клиент посылает сообщение о намерении присоединиться к каналу.

Клиент одновременно может присоединиться к нескольким каналам.

```json
//req_to_server
{
    "type": "join",
    "data": {
        "channel_id": "5", // идентификатор канала
        "hidden": 0,       // для модераторов: не показывать ник в списке юзеров
        "mobile": false,   // флаг с какого устройства идет подключение
        "reload": false
    }
}
```

Если сервер присоединяет клиента к каналу, то клиент информируется сообщением.

```json
//res_to_client
{
    "type": "success_join",
    "data": {
        "channel_id": "5",
        "channel_name": "Марафон по ...",
        "channel_key": "Miker",
        "channel_streamer": { // информация о стримере
            "baninfo": false,
            "banned": false,
            "hidden": false,
            "id": 1,
            "name": "Miker",
            "username": "Miker" // username
            "avatar": "1_mtmA.png",
            "payments": 7,
            "premium": 1,
            "premiums": ["5"],
            "resubs": {"5": 7},
            "rights": 50,
            "staff": 0,
            "regtime": 1201532455,
            "ggPlusTier": 0,
            "role": ""
        },
        "motd": "Сообщение дня",
        "room_type": "stream",
        "room_premium": true,
        "premium_price": 0,
        "donate_buttons": "",
        "clients_in_channel": 187, // всего клиентов в канале, включая гостей
        "users_in_channel": 143,   // всего авторизованных пользователей в канале
        "user_id": 123456,         // для гостей "0"
        "name": "some_username",   // для гостей ""
        "access_rights": 0,  // по этому полю клиент понимает права пользователя, в этом канале
        "premium_only": 0,
        "premium": false,
        "premiums": ["94123"],
        "notifies": {"94123": 0},
        "resubs": {"94123": 7},
        "gg_plus_tier": 0,
        "is_banned": false,  // забанен или нет в этом канале
        "banned_time": 0,    // до какого времени забанен
        "reason": "",        // текстовая строка с причиной бана
        "permanent": false,
        "payments": 1,
        "paymentsAll": {"5": 1, "94123": 7},
        "jobs": true
    }
}
```

Где:

jobs типа ?bool, где
1. true = Задания включены;
2. false = Задания выключены;
3. null = неизвестный канал.

В данной реализации протокола, гости находятся в состоянии readonly.

#### Отключение пользователя от канала

```json
//req_to_server
{
    "type": "unjoin",
    "data": {
        "channel_id": "5" // идентификатор канала
    }
}

//res_to_client
{
    "type": "unjoin",
    "data": {
        "success": true
    }
}
```

### Информация о канале

#### Получение списка пользователей

```json
//req_to_server
{
    "type": "get_users_list2",
    "data": {
        "channel_id": "5"
    }
}
```

Список пользователей в канале. Гости не учитываются.

```json
//res_to_client
{
    "type": "users_list",
    "data": {
        "channel_id": "5",
        "clients_in_channel": 0,  // всегда 0
        "users_in_channel": 142,  // всего авторизованных пользователей в канале
        "users": [{
            "baninfo": false,
            "banned": false,
            "hidden": 0,
            "id": 123456,
            "name": "dfcz",
            "avatar": "103977_I5up.jpg",
            "payments": 4,
            "premium": 1,
            "premiums": ["0", "5", "29187", "190739"],
            "resubs": {"0": 4, "5": 6, "29187": 7, "190739": 1},
            "rights": 0,
            "staff": 0,
			       "regtime": 1323496436,
            "ggPlusTier": 3,
            "role": ""
        },
        ...] // Массив пользователей которые в данный момент находятся в канале
        // для экономии памяти, клиент может игнорировать этот список.
    }
}
```

#### Получение списка помощников стримера

Получить полный список помощников стримера на канале, даже если они не в чате.

```json
//req_to_server
{
    "type": "get_stream_moders_list",
    "data": {
        "channel_id": "5"
    }
}
```

```json
//res_to_client
{
  "type": "stream_moders_list",
  "data": {
    "channel_id": "5",
    "moders": [
      {
        "id": "222509",
        "name": "Элая́р",
        "rights": "10"
      },
      {
        "id": "366036",
        "name": "jokie",
        "rights": "10"
      },
      ...
    ]
  }
}
```

#### Получение количества клиентов и пользователей

```json
//req_to_server
{
    "type": "get_channel_counters",
    "data": {
        "channel_id": "5"
    }
}
```

Также сервер сам периодически присылает данные сообщения по каналам, к которым присоединился клиент.

```json
//res_to_client
{
    "type": "channel_counters",
    "data": {
        "channel_id": "5",
        "clients_in_channel": 545, // всего клиентов в канале, включая гостей
        "users_in_channel": 332,   // всего авторизованных пользователей в канале
    }
}
```

#### Информация о статусе канала

Периодически сервер присылает информацию о статусе канала

```json
//res_to_client
{
    "type": "update_channel_info",
    "data": {
        "channel_id": "5",
        "premium_only": 0,
        "started": 1693073499  // время начала трансляции (0 - стрим не запущен)
    }
}
```

#### Обновление настроек журнала заданий

```json
//res_to_client
{
  "type": "update_channel_info_jobs",
  "data": {
    "channel_id": "5",
    "jobs": {
      "enabled": false,
      "minimumAmount": 100,
      "maxActiveJobsPerUser": 5,
      "filter": "1,5", // Кто может создавать задания
      "colorSkin": 0,
      "backgroundImage": "",
      "canCreate": false
    }
  }
}
```

#### Изменение настроек

```json
//res_to_client
{
    "type": "setting",
    "data": {
        "channel_id": "5",
        "name": "motd",  // имя команды: motd, slowmod, smiles, peka...
        "value": "Сообщение дня",
        "moder_id": 1210045,  // id-пользователя, установившего команду
        "moder_name": "Валера",
        "moder_rights": 10,
        "moder_premium": 0,
        "silent": 1
    }
}
```

#### Выбор случайного зрителя

Выбрать пользователя из чата, используя переданные фильтры.

```json
//req_to_server
{
    "type": "get_random",
    "data": {
        "already": [123456],  // уже выбранные зрители
        "version": 2,
        "premiums": true,  // выбирать премиум-зрителей
        "donaters": true,  // выбирать поддкржавших канад
        "others": true,    // выбирать обычных зрителей
        "noModers": true,  // не выбирать модераторов
        "channel_id": "5"
    }
}
```

Результат с информацией о выбранном зрителе.

```json
//res_to_client
{
    "type": "random_result",
    "data": {
        "channel_id": "5",
        "success": true,
        "data": {
            "baninfo": false,
            "banned": false,
            "hidden": 0,
            "id": 123456,
            "name": "Miker",
            "avatar": "1_mtmA.png",
            "payments": 7,
            "premium": 1,
            "premiums": ["5"],
            "resubs": {"5": 7},
            "rights": 20,
            "staff": 0,
            "regtime": 1328196040,
            "ggPlusTier": 0,
            "role": ""
        }
    }
}
```

Нет зрителей, подходящих под выбранные критерии.

```json
//res_to_client
{
    "type": "random_result",
    "data": {
        "channel_id": "5",
        "success": false,
        "data": []
    }
}
```

### Игнор-лист

#### Получение игнор-листа

```json
//req_to_server
{
    "type": "get_ignore_list",
    "data": {}
}
```

Список общий для всех каналов.

```json
//res_to_client
{
    "type": "ignore_list",
    "data": {
        "users": [{
            "id": "6",
            "name": "Василий"
        },
        ...
        ]
    }
}
```

#### Добавить в игнор лист

```json
//req_to_server
{
    "type": "add_to_ignore_list",
    "data": {
        "user_id": "77"
    }
}
```

Ответ аналогичен команде `get_ignore_list`

#### Удалить из игнор листа

```json
//req_to_server
{
    "type": "del_from_ignore_list",
    "data": {
        "user_id": "77"
    }
}
```

Ответ аналогичен команде `get_ignore_list`

#### Получение истории сообщений канала

```json
//req_to_server
{
    "type": "get_channel_history",
    "data": {
        "channel_id": "5",
        "from": "123" // id-сообщения с которого выдавать историю (необязательный)
    }
}

//res_to_client
{
    "type": "channel_history",
    "data": {
        "channel_id": "5",
        "messages":[{
            "channel_id": "5",
            "user_id": 139690,  // id юзера
            "user_name": "Василий",
            "user_rights": 51,
            "premium": 1,  // премиум статус пользователя отправившего сообщение
            "premiums": ["0", "5", "3893"],
            "resubs": {"0": 4, "5": 7, "3893": 6},
            "staff": 1,
            "color": "moderator",
            "icon": "staff",  // используется в служебных целях на стороне клиента
            "role": "",
            "mobile": 0,  // используется в служебных целях на стороне клиента
            "payments": 5,
            "paymentsAll": {"5": 5, "184": 1, "3893": 6, "178814": 1},
            "gg_plus_tier": 2,
            "isStatus": 0,
            "message_id": 1693062969443,  // номер сообщения, нужно для удаления сообщения из чата
            "timestamp": 1693062969,  // unixtime время прихода сообщения на сервер
            "text": "Всем чмоки в этом чатике :jokie5:",  // оригинальное сообщение, за исключением того, что html-разметка эскейпится
            // клиент сам занимается преобразованием спец. символов (например подстановка смайлов)
            "regtime": 1356599267
        },
        ...] // Массив сообщений, более раннии сообщения первее.
    }
}
```

### Сообщения

#### Отправка сообщения

```json
//req_to_server
{
    "type": "send_message",
    "data": {
        "channel_id": "5",
        "text": "Hello :scarypeka: ", // html-разметка эскейпится
        "color": "streamer",
        "icon": "top1",
        "role": "",
        "mobile": 0
    }
}
```

#### Получение сообщения

```json
//res_to_all_in_channel
{
    "type": "message",
    "data": {
        "channel_id": "15365",
        "user_id": 162675,  // id юзера
        "user_name": "Resmile",
        "user_rights": 0,
        "premium": 1,  // премиум статус пользователя отправившего сообщение
        "premiums": ["15365", "40756"],
        "resubs": {"15365": 4, "40756": 2},
        "staff": 0,
        "color": "silver",
        "icon": "none",
        "role": "",
        "mobile": 0,
        "payments": 2,
        "paymentsAll": {"5": 2, "6515": 2, "15365": 2, "183946": 1},
        "gg_plus_tier": 0,
        "isStatus": 0,
        "message_id": 1693043578692,  // номер сообщения, нужно для удаления сообщения из чата
        "timestamp": 1693043579,  // unixtime время прихода сообщения на сервер
        "text": "Miker, :panic:",  // оригинальное сообщение, за исключением того, что html-разметка эскейпится
        // клиент сам занимается преобразованием спец. символов (например подстановка смайлов)
        "regtime": 1371037120
    }
}
```

#### Отправка приватного сообщение

```json
//req_to_server
{
    "type": "send_private_message",
    "data": {
        "channel_id": "5",
        "user_id": "124", //получатель
        "username": "Вася", // или вместо id пользователя его ник
        "text": "Привет, как дела?" // обрабатывается аналогично всем сообщениям
    }
}
```

#### Получение приватного сообщения

```json
//res_to_client
{
    "type": "private_message",
    "data": {
        "channel_id": "5",
        "user_id": "124", // отправитель
        "user_name": "Василий",
        "user_rights": 10,
        "user_groups": ["premium"],
        "hideIcon": false,
        "mobile": false,    // используется в служебных целях на стороне клиента
        "target_id": "124", // получатель
        "target_name": "Валера",
        "timestamp": 1432319351, // unixtime,
        "text": "Привет, как дела?" // обрабатывается аналогично всем сообщениям
    }
}
```

### Уведомления о донатах / подписках / премиумах

Уведомления приходят всем на канале, даже неавторизованным пользователям.

#### Подписка на канал

```json
{
    "type": "follower",
    "data": {
        "userId": 58559,
        "user_id": 58559,
        "username": "MyDream",
        "userName": "MyDream",
        "channel_id": 158456
    }
}
```

#### Донат

```json
// res_to_client
// Поля total и title передаются только при донате в призовой фонд турнира
{
    "type": "payment",
    "data": {
        "userId": "779436",
        "userName": "marked0ne",
        "channel_id": "15365",
        "amount": "1111.00",
        "message": "ну с ДР. С НГ тада",
        "voice": "",
        "total": 0,
        "title": "",
        "link": "",
        "gift": 0,
        "is_commission_covered": false  // покрыл ли донатер комиссию платежной системы
    }
}
```

#### Активация премиума

```json
{
    "type": "premium",
    "data": {
        "channel_id": "139026",
        "userId": "1605798",
        "userName": "Agroshkolnik42",
        "payment": 0,
        "resub": "1"
    }
}
```

#### Подарочный премиум

```json
{
    "type": "gifted_premiums",
    "data": {
        "channel_id": 190074,
        "title": "Премиум на 30 дней на канал jokie",
        "payer": "marked0ne",
        "users": [
            {
                "id": 1234163,
                "username": "Krommm_77"
            }
        ]
    }
}
```

### Модерация

#### Удаление сообщения

```json
//req_to_server
{
    "type": "remove_message",
    "data": {
        "channel_id": "5",
        "message_id": "100" // номер сообщения, которое нужно удалить
    }
}
```

При этом сервер отсылает также всем клиентам в канале сообщение

```json
//res_to_all_in_channel
{
    "type": "remove_message",
    "data": {
        "channel_id": "163568",
        "message_id": 1693044447764,  // номер сообщения, которое нужно удалить
        "adminName": "HomoStarr"      // ник пользователя, вынесшего бан
    }
}
```

#### Бан пользователя

```json
//req_to_server
{
    "type": "ban2",
    "data": {
        "userId": 123456,
        "roomId": "5",  // канал в котором вынесен бан
        "reason": "",   // причина
        "comment": "Hello :scarypeka:",  // текст сообщения, за который вынесен бан
        "type": 0,       // 0 - на время, 1 - до конца стрима, 2 - бессрочно
        "duration": 20,  // время бана в минутах
        "deleteMessage": true
    }
}
```

Что бы всем в чате было видно, кого и за что.

```json
//res_to_all_in_channel
{
    "type": "user_ban",
    "data": {
        "channel_id": "45507",
        "user_id": 116718,        // id забаненого пользователя
        "user_name": "Smit_Bir",  // ник забаненого пользователя
        "moder_id": 470771,           // id пользователя, вынесшего бан
        "moder_name": "D1sconnect4",  // ник пользователя, вынесшего бан
        "moder_rights": 20,
        "moder_premium": true,
        "duration": 1200,  // время, на сколько забанен пользователь в секундах
        "type": 0,
        "reason": "",
        "show": true
    }
}
```

#### Предупреждение пользователя

```json
//req_to_server
{
    "type": "warn",
    "data": {
        "channel_id": "5",
        "user_id": "124",  // кого предупреждаем
        "reason": "Плохо себя ведешь" //причина
    }
}
```

Что бы всем в чате было видно, кого и за что.

```json
//res_to_all_in_channel
{
    "type": "user_warn",
    "data": {
        "channel_id": "190074",
        "user_id": 532735,          // id пользователя, кому вынесено предупреждение
        "user_name": "Yogurtkill",  // ник предупрежденного пользователя
        "moder_id": 94363,      // id пользователя, вынесшего предупреждение
        "moder_name": "Gojji",  // ник пользователя, вынесшего предупреждение
        "moder_rights": 10,
        "moder_premium": true,
        "reason": ""
    }
}
```

#### Назначение / снятие прав помошника стримера

Пользователь, обладающий правами выше или равных правам стримера, может назначать/снимать помошников стримера для выбранного канала

Уровни прав описаны ниже.

```json
//req_to_server
{
    "type": "make_moderator",
    "data": {
        "channel_id": "5",
        "user_id": "124"
    }
}
```

```json
//req_to_server
{
    "type": "clean_moderator",
    "data": {
        "channel_id": "5",
        "user_id": "124"
    }
}
```

### Голосования

#### Создание голосования

```json
//req_to_server
{
    "type": "new_poll",
    "data": {
        "channel_id": "5",
        "title": "Зеленое или старкрафт?", // заголовок голосования
        "answers": [{"text": "Зеленое"}, {"text": "старкрафт"}, {"text": "я упырь"}], // массив вариантов, не больше 6
    }
}
```

После создания голосования, клиенты получают сообщение

```json
//res_to_all_in_channel
{
   "type": "new_poll",
    "data": {
        "channel_id": "5",
		    "title": "Зеленое или старкрафт?", // заголовок голосования
        "answers": [
			       {"id": 0, "text": "Зеленое", "voters": 0}, 
			       {"id": 1, "text": "красное", "voters": 0}, 
			       {"id": 2, "text": "я упырь", "voters": 0}
		    ], // массив вариантов, не больше 6
        "moder_id": 123, // id пользователя, создавшего голосование
        "moder_name": "Валера", // ник пользователя, создавшего голосование
    }
}
```

#### Запрос текущего голосование

```json
//req_to_server
{
    "type": "get_poll",
    "data": {
        "channel_id": "5"
    }
}
```

Ответом будет сообщение `new_poll`, если этот пользователь еще не голосовал или `poll_results` -  если голосовал

#### Выбор варианта пользователем

```json
//req_to_server
{
    "type": "vote",
    "data": {
        "channel_id": "5",
        "answer_id": 1
    }
}
```

#### Запрос результатов

```json
//req_to_server
{
    "type": "get_poll_results",
    "data": {
        "channel_id": "5",
    }
}
```

#### Получение результатов

```json
//res_to_client
{
    "type": "poll_results",
    "data": {
        "channel_id": "5",
        "title": "Зеленое или старкрафт?", // заголовок голосования
        "voters": 200, // количество проголосовавших
        "answers": [
            {"id": 1, "text": "Зеленое", "voters": 100}, 
			      {"id": 2, "text": "красное", "voters": 50}, 
			      {"id": 3, "text": "я упырь", "voters": 50}
		    ], // массив вариантов, не больше 6
    }
}
```

Клиент сам строит график и высчитывает процентное соотношение. Так же сам решает, что делать, если во время отображения результатов голосования,
приходит сообщение "new_poll" (Новое голосование).


## Ошибка

В любой момент, с сервера может прийти сообщение, информирующее об ошибке.

```json
//res_to_client
{
    "type": "error",
    "data": {
        "channel_id": "5",
        "errorMsg": "Нельзя забанить самого себя" // Готовое сообщение.
    }
}
```

## Уровни прав

| Код | Название | Уровень |
| --- | -------- | ------- |
| casual | Обычный | 0 |
| stream_moder | Помошник стримера | 10 |
| streamer | Стример | 20 |
| moderator | Модератор | 30 |
| smoderator | Супермодератор | 40 |
| admin | Администратор | 50 |


## Обработка смайлов на стороне клиента

Для разных каналов доступен разный набор смайлов. Весь набор смайлов, а также их тип можно получить по url:

    http://goodgame.ru/js/minified/global.js

Рассмотрим структуру ответа:

```javascript
    var Global = {
        Smiles : [
            {
                "id":"874",
                "bind":"26",
                "name":"thup",
                "donat":0,
                "premium":0,
                "internal_id":104,
                "paid":0,
                "animated":"1",
                "tag":"?tuvney",
                "img":"https:\/\/goodgame.ru\/images\/smiles\/thup.png",
                "img_big":"https:\/\/goodgame.ru\/images\/smiles\/thup-big.png",
                "img_gif":"https:\/\/goodgame.ru\/images\/anismiles\/thup-gif.gif",
                "channel":"",
                "channel_id":0
            }, 
            ... 
        ],
        Channel_Smiles : {
            "1577": [
                {
                    "id":"95",
                    "bind":"112",
                    "name":"shimoro2",
                    "donat":0,
                    "premium":1,
                    "internal_id":2,
                    "paid":0,
                    "animated":"",
                    "tag":"?tuvney",
                    "img":"https:\/\/goodgame.ru\/images\/smiles\/shimoro2.png",
                    "img_big":"https:\/\/goodgame.ru\/images\/smiles\/shimoro2-big.png",
                    "img_gif":"https:\/\/goodgame.ru\/images\/anismiles\/shimoro2-gif.gif",
                    "channel":"SHIMORO",
                    "channel_id":"1577"
                }, 
                ...
            ]
            ...
        },
        ...
    }
```

`Smiles` отвечает за общедоступные смайлы,  
`Channel_Smiles` - за смайлы, привязанные к конкретному каналу.

Так же, каждый смайл описан следующим набором характеристик:

* `bind` - для внутренних нужд
* `name` - код смайла в тексте сообщения
* `donat` - признак донатного смайла
* `premium` - премиум смайл (является ли пользователь премиум-клиентом в данном канале можно узнать из собщений `success_join`, `message`, `private_message`)
* `paid` - признак платного смайла (узнать список доступных платных смайлов можно в поле `payments` из собщений `success_join`, `message`, `private_message`)

Так же, все платные смайлы доступны клиентам с правами больше чем стримерские (стримеру, модераторам, супермодераторам и админам).