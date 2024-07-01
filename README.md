# Xcode Parser

Xcode Parser — это пакет для работы с файлами проекта Xcode (.pbxproj). Пакет позволяет читать, модифицировать и сохранять изменения в .pbxproj файлах, что особенно полезно для автоматизации задач разработки под iOS.

## Особенности

- Чтение и анализ содержимого .pbxproj файлов.
- Модификация проектных настроек и конфигураций.
- Сохранение изменений в .pbxproj файл.

## Установка

Подключите пакет в вашем проекте Dart или Flutter, добавив зависимость в ваш `pubspec.yaml` файл:

```yaml
dependencies:
  dart_pbxproj_parser: ^0.1.0
```

## Примеры использования
### Открытие и сохранение .pbxproj файла

```dart
import 'package:dart_pbxproj_parser/pbxproj.dart';

void main() async {
  var project = await Pbxproj.open('path/to/Runner.xcodeproj/project.pbxproj');
  await project.save();
}
```
### Доступные операторы и методы

- `String toString()`, Преобразует в конечный результат

- `PbxprojComponent copyWith();`, Копирует создавая новый объект

- `T? find<T extends NamedComponent>(String key);`, ищет компонент по ключу в списке


- `T? findComment<T extends NamedComponent>(String comment);`, ищет компонент по комментарию в списке

- `void add(NamedComponent component);`, добавляет компонент в объект

- `void replaceOrAdd(NamedComponent component);`, заменяет компонент, если он существует или добавляет в объект

- `void remove(String uuid);`, удаляет компонент из объекта по uuid

- `NamedComponent? operator [](String key);`, ищет компонент по uuid в HashMap

### Объекты

Создание и добавление объектов
```dart
import 'package:dart_pbxproj_parser/pbxproj.dart';
import 'dart:io';

void main() async {
  var project = await Pbxproj.open('ios/Runner.xcodeproj/project.pbxproj');
  addBuildConfiguration(project);
  await project.save();
}

void addBuildConfiguration(Pbxproj project) {
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
}
```

Создание и использование списка

```dart
void addFramework(Pbxproj project) {
  var uuid = project.generateUuid();
  var frameworks = ListPbx('children', [
    ElementOfListPbx(uuid, comment: 'FrameworkName.framework'),
  ]);
  
  var frameworksGroup = MapPbx(
    uuid: project.generateUuid(),
    children: [
      MapEntryPbx('isa', VarPbx('PBXGroup')),
      frameworks,
    ],
  );
  project.add(frameworksGroup);
}
```


Поиск, добавление и удаление объектов

```dart
void addObjectToProject(Pbxproj project) {
  var newObject = MapPbx(uuid: '000000000000000000000000');

  var group = project.find<MapPbx>(groupUuid);
  group?.children.add(ElementOfListPbx(newObject));

  print(group.childrenList); // List of children
  print(group.childrenList); // HashMap<uuid, PbxprojComponent>
  
  final value = group['nameOfValue'];
  
  var section = project.find<SectionPbx>('nameOfSection');
  section?.children.replaseOrAdd(ElementOfListPbx(newObject));
  
  final list = project.findComment<ListPbx>('nameOfList');

  project.add(fileRef);
}
```



