# Xcode Parser

Xcode Parser is a package for working with Xcode project files (.pbxproj). This package allows you to read, modify, and save changes in .pbxproj files, which is especially useful for automating iOS development tasks.
## Features

- Reading and analyzing the contents of .pbxproj files.
- Modifying project settings and configurations.
- Saving changes to .pbxproj files.

## Installation

Incorporate the package into your Dart or Flutter project by adding it as a dependency in your `pubspec.yaml` file:
```yaml
dependencies:
  dart_pbxproj_parser: ^0.1.0
```

## Usage Examples
### Opening and Saving a .pbxproj File

```dart
import 'package:dart_pbxproj_parser/pbxproj.dart';

void main() async {
  var project = await Pbxproj.open('path/to/Runner.xcodeproj/project.pbxproj');
  await project.save();
}
```
### Available Methods and Operators

- `String toString()`, Converts to a final result.

- `PbxprojComponent copyWith();`, Copies by creating a new object.

- `T? find<T extends NamedComponent>(String key);`, Searches for a component by key in the list.


- `T? findComment<T extends NamedComponent>(String comment);`, Searches for a component by comment in the list.

- `void add(NamedComponent component);`, Adds a component to the object.

- `void replaceOrAdd(NamedComponent component);`, Replaces a component if it exists or adds it to the object.

- `void remove(String uuid);`, Removes a component from the object by uuid.

- `NamedComponent? operator [](String key);`, Searches for a component by uuid in HashMap.

### Objects

Creating and Adding Objects
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

Creating and Using a List

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


Searching, Adding, and Deleting Objects

```dart
void addObjectToProject(Pbxproj project) {
  var newObject = MapPbx(uuid: '000000000000000000000000');

  var group = project.find<MapPbx>(groupUuid);
  group?.add(ElementOfListPbx(newObject));

  print(group.childrenList); // List of children
  print(group.childrenMap); // HashMap<uuid, PbxprojComponent>
  
  final value = group['nameOfValue'];
  
  var section = project.find<SectionPbx>('nameOfSection');
  section?.children.replaseOrAdd(ElementOfListPbx(newObject));
  
  final list = project.findComment<ListPbx>('nameOfList');

  project.add(fileRef);
}
```



