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


- Read and analyze project data.
- Make changes to the project configuration.
- Save modifications back to the .pbxproj file, ensuring the project is updated according to the changes made.
#### Methods

##### Note:
```
`open` may take a few seconds, 
if your program needs to continue working 
during parsing, it is recommended to use 
isolates to prevent blocking the main thread.
```

- `static Future<Pbxproj> open(String path)` - Opens and analyzes the .pbxproj file at the specified path. Parameter path - path to the .pbxproj file. Returns: Future<Pbxproj> — an asynchronous result that contains an instance of Pbxproj after reading and analyzing the file.
- `Future<void> save()` - Saves the current state of the Pbxproj object back to the .pbxproj file.
- `String generateUuid()` - Generates a unique identifier (UUID), which can be used for new project components.
- `void add(NamedComponent component)` - Adds a new component to the project.
- `void remove(String uuid)` - Removes a component from the project by its UUID.
- `void replaceOrAdd(NamedComponent component)` - Replaces an existing component in the project or adds a new one if a component with such UUID is not found.
- `NamedComponent? operator [](String key)` - Allows access to a component by its UUID.

#### Example

```dart
void main() async {
  // Load the project
  var project = await Pbxproj.open('path/to/Runner.xcodeproj/project.pbxproj');

  // Add a new build configuration
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

  // Save changes
  await project.save();
}
```

### SectionPbx

`SectionPbx` is a specialized component within the xcode_parser
library that manages sections in Xcode project files (`*.pbxproj`). 
Sections in such files usually contain groups of related elements, such 
as source files, build configurations, resources, etc.

#### Methods

- `void add(NamedComponent component)` - Adds a new component to the section.
- `void remove(String uuid) - Removes` a component from the section by its UUID.
- `NamedComponent? find(String uuid)` - Searches for a component in the section by its UUID.
- `replaceOrAdd(NamedComponent component)` - Replaces an existing component in the section or adds a new one if a component with such UUID is not found.
- `find<T extends NamedComponent>(String key)` - Searches for a component in the section by its UUID and returns it if found. Returns null if the component is not found.
- `findComment<T extends NamedComponent>(String comment)` - Searches for a component by comment. This is useful if components have been marked with comments for further identification.
#### Example

```dart
void main() {
  // Create a section for build settings
  var buildConfigs = SectionPbx(name: 'XCBuildConfiguration');

  // Add a build setting for debug mode
  buildConfigs.add(MapPbx(
    uuid: 'debugConfig',
    children: [
      MapEntryPbx('name', VarPbx('Debug')),
      MapEntryPbx('buildSettings', VarPbx('{SETTINGS}')),
    ],
  ));

  // Output information about the section
  print(buildConfigs);
}
```

### MapPbx

`MapPbx` is a component of the `xcode_parser` library designed to 
manage mappings in Xcode project files (`*.pbxproj`).

#### Methods

- `void add(NamedComponent component)` - Adds a new component to the mapping.
- `void remove(String uuid)` - Removes a component from the mapping by its UUID.
- `NamedComponent? find(String uuid)` - Searches for a component in the mapping by its UUID and returns it if found. Returns null if the component is not found.
- `replaceOrAdd(NamedComponent component)` - Replaces an existing component in the mapping or adds a new one if a component with such UUID is not found.
- `find<T extends NamedComponent>(String key)` - Searches for a component in the mapping by its UUID and returns it if found. Returns null if the component is not found.
- `findComment<T extends NamedComponent>(String comment)` - Searches for a component by comment. This is useful if components have been marked with comments for further identification.

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

