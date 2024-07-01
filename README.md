<p align="center">
    <a href="https://pub.dev/packages/xcode_parser" align="center">
        <img src="https://github.com/EclipseAndrey/xcode_parser/blob/main/xc_logo_big.png?raw=true" width="4000px">
    </a>
</p>



# Xcode Parser

Xcode Parser is a package for working with Xcode project files (.pbxproj). This package allows you to read, modify, and save changes in .pbxproj files, which is especially useful for automating iOS development tasks.
## Features

- Reading and analyzing the contents of .pbxproj files.
- Modifying project settings and configurations.
- Saving changes to .pbxproj files.


| Dart                                                                                    | example.pbxproj                                                                       |
|-----------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------|
| ![before](https://github.com/EclipseAndrey/xcode_parser/blob/main/sc_dart.png?raw=true) | ![before](https://github.com/EclipseAndrey/xcode_parser/blob/main/sc_xc.png?raw=true) |

## Installation

Incorporate the package into your Dart or Flutter project by adding it as a dependency in your `pubspec.yaml` file:
```yaml
dependencies:
  xcode_parser: ^0.1.0
```
or
```shell
dart pub add xcode_parser
```

# Index
- [Installation](#installation)
- [Index](#index)
- [Objects and examples](#objects)
- - [Pbxproj](#pbxproj)
- - [SectionPbx](#sectionpbx)
- - [MapPbx](#MapPbx)
- - [MapEntryPbx](#MapEntryPbx)
- - [VarPbx](#VarPbx)
- - [ElementOfListPbx](#ElementOfListPbx)
- - [ListPbx](#ListPbx)



## Objects

### Pbxproj


- Читать и анализировать данные проекта.
- Вносить изменения в конфигурацию проекта.
- Сохранять модификации обратно в файл .pbxproj, обеспечивая актуализацию проекта в соответствии с внесенными изменениями.

#### Methods

##### Note:
```
`open` может занимать несколько секунд, 
если ваша программа должна продолжать работу 
во время парсинга, рекомендуется использовать 
изоляты для предотвращения блокировки основного потока
```

- `static Future<Pbxproj> open(String path)` - Открывает и анализирует файл .pbxproj по указанному пути. Параметр `path` -  путь к файлу .pbxproj.  Возвращает: `Future<Pbxproj>` — асинхронный результат, который содержит экземпляр `Pbxproj` после чтения и анализа файла.
- `Future<void> save()` - Сохраняет текущее состояние объекта `Pbxproj` обратно в файл .pbxproj.
- `String generateUuid()` - Генерирует уникальный идентификатор (UUID), который может быть использован для новых компонентов проекта.
- `void add(NamedComponent component)` - Добавляет новый компонент в проект.
- `void remove(String uuid)` - Удаляет компонент из проекта по его UUID.
- `void replaceOrAdd(NamedComponent component)` - Заменяет существующий компонент в проекте или добавляет новый, если компонент с таким UUID не найден.
- `NamedComponent? operator [](String key)` - Позволяет получить доступ к компоненту по его UUID.

#### Example

```dart
void main() async {
  // Загрузка проекта
  var project = await Pbxproj.open('path/to/Runner.xcodeproj/project.pbxproj');

  // Добавление новой конфигурации сборки
  var uuid = project.generateUuid();
  var config = MapPbx(
    uuid: uuid,
    children: [
      MapEntryPbx('isa', VarPbx('XCBuildConfiguration')),
      MapEntryPbx('name', VarPbx('"CustomDebug"')),
      MapPbx(
        uuid: 'buildSettings',
        children: [
          MapEntryPbx('SWIFT_VERSION', VarPbx('5.0')),
          MapEntryPbx('IPHONEOS_DEPLOYMENT_TARGET', VarPbx('12.0')),
        ],
      ),
    ],
  );
  project.add(config);

  // Сохранение изменений
  await project.save();
}
```

### SectionPbx

`SectionPbx` — это специализированный компонент в рамках библиотеки 
xcode_parser, который управляет разделами в файлах проекта Xcode 
(*.pbxproj). Разделы в таких файлах обычно содержат группы 
связанных элементов, таких как файлы исходного кода, конфигурации 
сборки, ресурсы и т.д.

#### Methods

- `void add(NamedComponent component)` - Добавляет новый компонент в секцию.
- `void remove(String uuid)` - Удаляет компонент из секции по его UUID.
- `NamedComponent? find(String uuid)` - Поиск компонента в секции по его UUID.
- `replaceOrAdd(NamedComponent component)` - Заменяет существующий компонент в разделе или добавляет новый, если компонент с таким UUID не найден.
- `find<T extends NamedComponent>(String key)` - Ищет компонент в разделе по его UUID и возвращает его, если он найден. Возвращает `null`, если компонент не найден.
- `findComment<T extends NamedComponent>(String comment)` - Ищет компонент по комментарию. Это полезно, если компоненты были помечены комментариями для дальнейшей идентификации.

#### Example

```dart
void main() {
  // Создание раздела для настроек сборки
  var buildConfigs = SectionPbx(name: 'XCBuildConfiguration');

  // Добавление настройки сборки для режима отладки
  buildConfigs.add(MapPbx(
    uuid: 'debugConfig',
    children: [
      MapEntryPbx('name', VarPbx('Debug')),
      MapEntryPbx('buildSettings', VarPbx('{SETTINGS}')),
    ],
  ));

  // Вывод информации о разделе
  print(buildConfigs);
}
```

### MapPbx

`MapPbx` — это компонент библиотеки `xcode_parser`, предназначенный для 
управления маппингами в файлах проекта Xcode (`*.pbxproj`). 
#### Methods

- `void add(NamedComponent component)` - Добавляет новый компонент в маппинг.
- `void remove(String uuid)` - Удаляет компонент из маппинга по его UUID.
- `NamedComponent? find(String uuid)` - Поиск компонента в маппинге по его UUID и возвращает его, если он найден. Возвращает `null`, если компонент не найден.
- `replaceOrAdd(NamedComponent component)` - Заменяет существующий компонент в маппинге или добавляет новый, если компонент с таким UUID не найден.
- `find<T extends NamedComponent>(String key)` - Ищет компонент в маппинге по его UUID и возвращает его, если он найден. Возвращает `null`, если компонент не найден.
- `findComment<T extends NamedComponent>(String comment)` - Ищет компонент по комментарию. Это полезно, если компоненты были помечены комментариями для дальнейшей идентификации.

#### Example

```dart
void main() {
  // Создание объекта MapPbx для настроек сборки
  var buildSettings = MapPbx(
    uuid: 'buildSettings',
    children: [
      MapEntryPbx('SWIFT_VERSION', VarPbx('5.0')),
      MapEntryPbx('IPHONEOS_DEPLOYMENT_TARGET', VarPbx('12.0')),
    ],
    comment: 'Main build settings'
  );

  // Добавление дополнительной конфигурации
  buildSettings.add(MapEntryPbx(
    'GCC_OPTIMIZATION_LEVEL', 
    VarPbx('s')
  ));

  // Вывод информации о маппинге
  print(buildSettings);
}
```

### MapEntryPbx

`MapEntryPbx` является компонентом библиотеки xcode_parser, 
который предназначен для представления отдельных записей
внутри маппингов файлов проекта Xcode (`*.pbxproj`). Этот компонент 
используется для хранения пар ключ-значение, где каждый ключ представлен 
UUID, а значение может быть любым компонентом, производным от PbxprojComponent.

#### Methods

- `String toString({int indentLevel = 0, bool removeN = false})` - Преобразует объект MapEntryPbx в строковое представление, которое может быть использовано для вывода или записи в файл. Параметр indentLevel управляет уровнем отступа для лучшей читаемости, а removeN определяет, следует ли добавлять переносы строк.
- `MapEntryPbx copyWith({String? uuid, T? value, String? comment})` - Создает копию объекта MapEntryPbx с возможностью замены его компонентов. Это полезно для модификации существующих записей, когда необходимо изменить только часть данных.

#### Example

```dart
void main() {
  // Создание объекта MapEntryPbx для настройки сборки
  var swiftVersion = MapEntryPbx(
    'SWIFT_VERSION',
    VarPbx('5.0'),
    comment: 'Swift version for the build configuration'
  );

  // Вывод информации о записи
  print(swiftVersion);

  // Создание копии с измененным значением
  var updatedSwiftVersion = swiftVersion.copyWith(
    value: VarPbx('5.2'),
    comment: 'Updated Swift version'
  );

  // Вывод обновленной информации
  print(updatedSwiftVersion);
}
```
### VarPbx
`VarPbx` является компонентом библиотеки `xcode_parser`, который используется 
для представления значений параметров в файлах проекта Xcode (`*.pbxproj`). 
Этот компонент предназначен для хранения простых данных, таких как строки, 
числа, или логические значения, которые являются частью конфигурации проекта Xcode.

#### Methods

- `String toString({int indentLevel = 0, bool removeN = false})` - Преобразует объект VarPbx в строковое представление. Этот метод облегчает интеграцию значения VarPbx в файлы .pbxproj в соответствующем формате.

#### Example

```dart
void main() {
  // Создание объекта VarPbx для хранения версии Swift
  var swiftVersion = VarPbx('5.0');

  // Вывод значения версии Swift
  print('Swift Version: ${swiftVersion}');

  // Использование VarPbx в MapEntryPbx для конфигурации проекта
  var buildSetting = MapEntryPbx(
    'SWIFT_VERSION',
    swiftVersion,
    comment: 'Specify the Swift version used for the build'
  );

  // Вывод полной записи настройки сборки
  print(buildSetting);
}
```

### ElementOfListPbx

`ElementOfListPbx` является компонентом библиотеки `xcode_parser`, 
предназначенным для представления элементов в списке, используемом 
в файлах проекта Xcode (`*.pbxproj`). Этот компонент обычно используется 
для представления значений в списках параметров, таких как список исходных 
файлов, ресурсы и другие групповые настройки.

#### Methods

`String toString({int indentLevel = 0, bool removeN = false})` - Преобразует объект ElementOfListPbx в строковое представление, учитывая уровень отступа и необходимость включения переносов строк. Метод удобен для формирования правильного формата записи элементов в .pbxproj файл.
`ElementOfListPbx copyWith({String? value, String? comment})` - Создает копию текущего элемента списка с возможностью изменения его значения или комментария. Это полезно для модификации существующих элементов при необходимости.

#### Example

```dart
void main() {
  // Создание элемента списка с комментарием
  var sourceFile = ElementOfListPbx(
      'MainViewController.swift',
      comment: 'Main view controller of the application'
  );

  // Вывод информации об элементе списка
  print(sourceFile);

  // Создание копии элемента с измененным комментарием
  var updatedSourceFile = sourceFile.copyWith(
      comment: 'Updated main view controller file'
  );

  // Вывод информации об обновленном элементе списка
  print(updatedSourceFile);
}
```

### ListPbx
`ListPbx` — это компонент библиотеки xcode_parser, предназначенный для 
управления списками в файлах проекта Xcode (`*.pbxproj`). Этот компонент 
используется для представления массивов значений, таких как файлы, 
конфигурации и другие коллекции элементов, связанных с проектом.


#### Methods

- `operator [](int index)` - Позволяет доступ к элементам списка по индексу.
- `int get length` - Возвращает количество элементов в списке.
- `void add(ElementOfListPbx element)` - Добавляет элемент в список.
- `String toString({int indentLevel = 0, bool removeN = false})` - Возвращает строковое представление объекта, учитывая уровень отступа и необходимость удаления переносов строк. Предназначено для формирования корректного вывода списка в файл .pbxproj.
- `ListPbx copyWith({String? uuid, List<ElementOfListPbx>?` - children, String? comment}): Создает копию текущего объекта списка с возможностью замены его компонентов. Это полезно при необходимости изменения списка без воздействия на исходный объект.


#### Example

```dart
void main() {
  // Создание списка для файлов проекта
  var fileList = ListPbx(
    'FILE_LIST',
    [
      ElementOfListPbx('AppDelegate.swift'),
      ElementOfListPbx('ViewController.swift'),
    ],
    comment: 'List of source files'
  );

  // Добавление нового файла в список
  fileList.add(ElementOfListPbx('MainViewController.swift'));

  // Вывод информации о списке файлов
  print(fileList);

  // Создание копии списка с изменением комментария
  var updatedFileList = fileList.copyWith(
    comment: 'Updated list of source files'
  );

  // Вывод обновленной информации о списке
  print(updatedFileList);
}
```

