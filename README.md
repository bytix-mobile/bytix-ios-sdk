# ![header](https://i.imgur.com/KtdI3hP.png)

Библиотека для обмена информацией с удаленными устройствами с помощью технологии Bluetooth Low Energy (BLE)

- [О проекте](#О-проекте)
- [Установка](#Установка)
- [Как использовать](#Как-использовать)
  - [Настройка параметров](#Настройка-параметров)
  - [Управление](#Управление)
  - [События](#События)

<a name="О-проекте"></a>
## О проекте :warning:
Bytix предоставляет возможность взаимодействия с удаленными устройствами в широком спектре возможностей. Взаимодействие происходит с помощью CoreBluetooth, уделенно особое внимание энергоэффективности решения, что позволяет реализовать Ваши с минимальным энергопотреблением. Когда, при включенном сканировании, библиотека обнаружит устройство с назначенным UUID сервиса, произойдет попытка автоматического подключения к данному устройству, и библиотека начнет принимать данные, если у нас появляется устройство с тем же сервисом, но лучшим сигналом, библиотека сама переподключается к устройству с лучшим сигналом, и когда мы покидаем область с устройством, сигнал ухудшается, библиотека произведет автоматическое отключение для экономии энерегии.

Проверить работу библиотеки можно с помощью [Demo приложения](https://github.com/bytix-mobile/bytix-ios-test-app) библиотеки Bytix

<a name="Установка"></a>
## Установка :hammer:

#### Cocoapods

[Cocoapods](https://cocoapods.org/#install) Это менеджер зависимостей в проектах на языках Swift и Objective-C, для установки вам необходимо добавить библиотеку в ваш `Podfile` и выполнить установку зависимостей.

Добавьте в ваш Podfile:
```
pod 'Bytix'
```

Выполните команду через терминал, находясь в папке проекта
```
pod install
```

<a name="Как-использовать"></a>
## Как использовать :key:

После установки зависимостей вам необходимо импортировать фреймворк в целевой файл вашего приложения.
```
import Bytix
```

Теперь нам доступен управляющий класс BytixSDK. Инициализируем его, используя UUID целевого сервиса устройств, с которыми собираемся взаимодействовать
```
let bytixManager = BytixSDK("SOME-UUID")
```
<a name="Настройка-параметров"></a>
### Настройка параметров :globe_with_meridians:
Мы имеем возможность настроить SDK под решение конкретной задачи, для этого библиотека имеет набор параметров, которые можно установить через управляющий класс.

#### Connection treshold (Порог подключения)
Данный параметр регулирует порог сигнала RSSI для подключения к конкретному устройству.
Если сигнал будет такой же, или сильнее указанного значения, библиотека автоматически подключится к данному устройству.
##### Значение по умолчанию: -50
```
bytixManager.connectionTreshold = -50
```
#### Disconnection treshold (Порог отключения)
Данный параметр регулирует порог сигнала RSSI для отключения от устройства
Если сигнал будет такой же, или слабее указанного значения, библиотека автоматически отключится от данного устройства.
##### Значение по умолчанию: -70
```
bytixManager.disconnectionTreshold = -70
```
#### Idle connection time (Время простоя)
Данный параметр регулирует время ожидания сигнала от устройства. Если сигнал не поступал указанное данным параметром время, данное устройство будет считаться потерянным.
##### Значение по умолчанию: 20
```
bytixManager.idleConnectionTime = 20
```
#### Connecting timeout (Максимальное время на подключение)
Данный параметр регулирует максимальное время для подключения к устройству. Если нам не удалось подключиться к устройству за указанное время, библиотека остановит процедуру подключения.
##### Значение по умолчанию: 5
```
bytixManager.connectingTimeout = 5
```
<a name="Управление"></a>
### Управление :video_game:
Для управления сканированием контрольный класс содержит в себе 2 метода.

Начать сканирование устройств
```
bytixManager.startScanning()
```
Остановить сканирование устройств
```
bytixManager.stopScanning()
```

Для того, чтобы получить массив всех доступных устройств, используйте метод `getBeacons()`
```
let beaconsArray = bytixManager.getBeacons() // Тип: [BytixBeacon]
```

Для отправления данных подключенному устройству используйте метод `sendData(_ data: Data)`
```
bytixManager.sendData(someDataObject)
```
<a name="События"></a>
### События :dart:
Библиотека передает информацию, используя протокол `BytixDelegate` 
Для того, чтобы получать события, нам необходимо реализовать методы протокола, для этого назначаем необходимый класс в качестве делегата управляющего класса библиотеки
```
bytixManager.delegate = self
```
Произошло то, или иное событие и информация о маяках в радиусе взаимодействия обновилась
##### Обязательный метод протокола
```
func didUpdateBeacons()
```
Произошло подключение к удаленному устройству
```
func bytix(connectedTo device: BytixBeacon)
```
Произошло отключение от удаленного устройства
```
func bytix(disconnectedFrom device: BytixBeacon)
```
Произошла потеря удаленного устройства
```
func bytix(lost device: BytixBeacon)
```
Получены данные от подключенного удаленного устройства
```
func bytix(received data: Data, from device: BytixBeacon)
```
