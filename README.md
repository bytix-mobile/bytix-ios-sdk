# ![header](https://i.imgur.com/KtdI3hP.png)

**Bytix** — библиотека для работы с BLE-маяками, предоставляющая возможность host-приложениям обнаруживать, подключаться и получать данные с маяков.

- [О проекте](#О-проекте)
- [Установка](#Установка)
- [Как использовать](#Как-использовать)
  - [Настройка параметров](#Настройка-параметров)
  - [Управление](#Управление)
  - [События](#События)

<a name="О-проекте"></a>
## О проекте :warning:

Библиотека обеспечивает автоматизированный процесс поиска, подключения и сбора идентификаторов станции и маяка для оперативного определения текущего местоположения.

#### Поиск маяков
Библиотека выполняет сканирование BLE-устройств в зоне действия, используя заданный Service UUID. Для фильтрации подходящих маяков применяются пороги уровня сигнала RSSI.  
Порог подключения - по умолчанию -75 dBm, порог отключения по умолчанию равен -85 dBm.

#### Подключение к маякам
При обнаружении одного или нескольких подходящих маяков устанавливается BLE-соединение с ближайшим устройством. Это необходимо для получения данных, так как MAC-адреса BLE-устройств рандомизируются на уровне ОС (iOS/Android), предотвращая использование их для фонового отслеживания.

#### Получение данных
После подключения через закрытый протокол считываются следующие идентификаторы:  
- **ID станции** — общий для всех маяков на одной станции.  
- **ID маяка** — уникальный идентификатор устройства.  

Для идентификации текущей станции достаточно данных от одного маяка.

#### Переподключение
Библиотека автоматически повторяет попытки подключения ко всем доступным маякам, минимизируя задержки при идентификации станции и исключая устройства с плохим сигналом в перегруженном 2.4 ГГц диапазоне.

### Рекомендации по использованию
- Рекомендуется запускать процесс поиска маяков при старте приложения, чтобы стабилизировать замеры сигнала и ускорить подключение.  
- Отображайте текущий статус поиска и подключения через UI-элементы (например, анимации или цветовые индикаторы), чтобы обеспечить лучшее взаимодействие. Выделите состояния:
  - Поиск маяков.  
  - Маяки найдены, подключение выполняется.  
  - Станция определена, данные обрабатываются.

Проверить работу библиотеки можно с помощью [Demo приложения](https://github.com/bytix-mobile/bytix-ios-test-app) библиотеки Bytix

-----

<a name="Установка"></a>
## Установка :hammer:

#### Cocoapods

Добавьте в ваш Podfile:
```
pod 'Bytix'
```

Выполните команду через терминал, находясь в папке проекта
```
pod install
```

#### Swift Package Manager (SPM)

```
dependencies: [
    .package(url: "https://github.com/bytix-mobile/bytix-ios-sdk.git", .upToNextMajor(from: "1.2.0"))
]
```

<a name="Как-использовать"></a>
## Как использовать :key:

После установки зависимостей вам необходимо импортировать фреймворк в целевой файл вашего приложения.
```swift
import Bytix
```

Теперь нам доступен управляющий класс BytixSDK. Инициализируем его, используя UUID целевого сервиса устройств, с которыми собираемся взаимодействовать
```swift
let bytixManager = BytixSDK("SOME-UUID")
```
<a name="Настройка-параметров"></a>
### Настройка параметров :globe_with_meridians:
Мы имеем возможность настроить SDK под решение конкретной задачи, для этого библиотека имеет набор параметров, которые можно установить через управляющий класс.

#### Connection treshold (Порог подключения)
Данный параметр регулирует порог сигнала RSSI для подключения к конкретному устройству.
Если сигнал будет такой же, или сильнее указанного значения, библиотека автоматически подключится к данному устройству.
##### Значение по умолчанию: -75
```swift
bytixManager.connectionTreshold = -75
```
#### Disconnection treshold (Порог отключения)
Данный параметр регулирует порог сигнала RSSI для отключения от устройства
Если сигнал будет такой же, или слабее указанного значения, библиотека автоматически отключится от данного устройства.
##### Значение по умолчанию: -95
```swift
bytixManager.disconnectionTreshold = -95
```
#### Idle connection time (Время простоя)
Данный параметр регулирует время ожидания сигнала от устройства. Если сигнал не поступал указанное данным параметром время, данное устройство будет считаться потерянным.
##### Значение по умолчанию: 3
```swift
bytixManager.idleConnectionTime = 3
```
#### Switch device time (Дельта смены устройства)
Данный параметр устанавливает разницу в сигнале между двух обнаруженных устройст, для определения приоритета для подключения. Если, при подключенном устройстве, мы обнаружили другое, которое имеет сигнал лучше на указанное данным параметром значение, то произойдет переподключение к новому устройству
##### Значение по умолчанию: 20
```swift
bytixManager.switchDeviceDelta = 20
```
#### Connecting timeout (Максимальное время на подключение)
Данный параметр регулирует максимальное время для подключения к устройству. Если нам не удалось подключиться к устройству за указанное время, библиотека остановит процедуру подключения.
##### Значение по умолчанию: 5
```swift
bytixManager.connectingTimeout = 5
```

#### Automatic connection (Автоматическое подключение) :fire:
Данный параметр отвечает за функцию автоматического подключения к устройству и уровне сигнала, превышающим пороговое значение, установленное в настройках SDK.
##### Значение по умолчанию: true (Включено)
```swift
bytixManager.autoConnection = true
```

#### Simultaneous connections (Одновременное подключение) :fire:
Данный параметр отвечает за количество подключаемых одновременно устройств при включенной функции автоматического подключения.
##### Значение по умолчанию: 3 (Включено)
```swift
bytixManager.simultaneousConnections = 3
```
<a name="Управление"></a>
### Управление :video_game:
Для управления сканированием контрольный класс содержит в себе 2 метода.

Начать сканирование устройств
```swift
bytixManager.startScanning()
```
Остановить сканирование устройств
```swift
bytixManager.stopScanning()
```

Для того, чтобы получить массив всех доступных устройств, используйте метод `getBeacons()`
```swift
let beaconsArray = bytixManager.getBeacons() // Тип: [BytixBeacon]
```

Для отправления данных подключенному устройству используйте метод `sendData(_ data: Data)`
```swift
bytixManager.sendData(someDataObject)
```

Для целевого подключения к устройству используйте метод `connect(to beacon: BytixBeacon)` :fire:
```swift
bytixManager.connect(to: beacon)
```

Для отключения от сопряженного устройства используйте метод `disconnect(from beacon: BytixBeacon)` :fire:
```swift
bytixManager.disconnect(from: beacon)
```
<a name="События"></a>
### События :dart:
Библиотека передает информацию, используя протокол `BytixDelegate` 
Для того, чтобы получать события, нам необходимо реализовать методы протокола, для этого назначаем необходимый класс в качестве делегата управляющего класса библиотеки
```swift
bytixManager.delegate = self
```
Произошло то, или иное событие и информация о маяках в радиусе взаимодействия обновилась
##### При изменении RSSI сигнала от маяка данный метод не вызывается. :fire:
```swift
func didUpdateBeacons()
```
Произошло подключение к удаленному устройству
```swift
func bytix(connectedTo device: BytixBeacon)
```
Произошло отключение от удаленного устройства
```swift
func bytix(disconnectedFrom device: BytixBeacon)
```
Произошла потеря удаленного устройства
```swift
func bytix(lost device: BytixBeacon)
```
Получены данные от подключенного удаленного устройства
```swift
func bytix(received data: Data, from device: BytixBeacon)
```
Изменился уровень сигнала от устройства :fire:
```swift
func bytix(updated RSSI: Int, from device: BytixBeacon)
```
