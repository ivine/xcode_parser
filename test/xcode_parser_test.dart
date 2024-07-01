import 'dart:io';

import 'package:test/test.dart';
import 'package:xcode_parser/xcode_parser.dart';

void main() async {
  /// Test
  group('Pbxproj Operations', () {
    late Pbxproj project;

    setUp(() async {
      /// current path
      final currentPath = Directory.current.path;
      print(currentPath);
      // Assuming Pbxproj.open is mocked to not require an actual file
      project = await Pbxproj.open('$currentPath/test/project.pbxproj');
    });

    test('Should open a project file successfully', () {
      expect(project, isNotNull);
      final currentPath = Directory.current.path;
      expect(project.path, equals('$currentPath/test/project.pbxproj'));
    });

    test('Should add a new component and save the project', () async {
      var uuid = project.generateUuid();
      var newComponent = MapPbx(uuid: uuid, children: []);
      project.add(newComponent);
      await project.save();

      // Verify the component was added
      var retrievedComponent = project[uuid];
      expect(retrievedComponent, equals(newComponent));
    });

    test('Should remove a component from the project', () {
      var initialCount = project.childrenList.length;
      var componentToRemove = project.childrenList.first;
      project.remove(componentToRemove.uuid);

      // Verify the component was removed
      expect(project.childrenList.length, equals(initialCount - 1));
      expect(project[componentToRemove.uuid], isNull);
    });

    test('Generate UUID should be unique', () {
      var uuid1 = project.generateUuid();
      var uuid2 = project.generateUuid();
      expect(uuid1, isNot(equals(uuid2)));
    });
  });

  group('Pbxproj Operations', () {
    late Pbxproj project;

    setUp(() async {
      /// Setup the test environment and mock dependencies if necessary
      final currentPath = Directory.current.path;
      project = await Pbxproj.open('$currentPath/test/project.pbxproj');
    });

    test('Project file path is correct', () {
      final currentPath = Directory.current.path;
      expect(project.path, equals('$currentPath/test/project.pbxproj'));
    });

    test('Adding and saving multiple components', () async {
      var initialCount = project.childrenList.length;
      var component1 = MapPbx(uuid: project.generateUuid(), children: []);
      var component2 = MapPbx(uuid: project.generateUuid(), children: []);
      project.add(component1);
      project.add(component2);
      await project.save();

      // Verify both components were added
      expect(project.childrenList.length, equals(initialCount + 2));
    });

    test('Removing a non-existent component does not affect project', () {
      var initialCount = project.childrenList.length;
      project.remove('non_existent_uuid');
      expect(project.childrenList.length, equals(initialCount));
    });

    test('Replace or add functionality works correctly', () {
      var uuid = project.generateUuid();
      var component = MapPbx(uuid: uuid, children: []);
      project.add(component);

      // Replace the existing component
      var newComponent = MapPbx(uuid: uuid, children: [MapEntryPbx(uuid, VarPbx('newValue'))]);
      project.replaceOrAdd(newComponent);

      var retrievedComponent = project[uuid] as MapPbx;
      expect(retrievedComponent.childrenList.last.toString(), equals(MapEntryPbx(uuid, VarPbx('newValue')).toString()));

      // Add a new component since the UUID does not exist
      var newUuid = project.generateUuid();
      var anotherComponent = MapPbx(uuid: newUuid, children: [MapEntryPbx(uuid, VarPbx('anotherValue'))]);
      project.replaceOrAdd(anotherComponent);

      expect(project[newUuid], isNotNull);
      expect((project[newUuid] as MapPbx).childrenList.last.toString(),
          equals(MapEntryPbx(uuid, VarPbx('anotherValue')).toString()));
    });

    test('Verify serialization and deserialization of project', () async {
      var uuid = project.generateUuid();
      var component = MapPbx(uuid: uuid, children: [MapEntryPbx(uuid, VarPbx('testValue'))]);
      project.add(component);
      await project.save();

      // Assuming serialization and deserialization logic is implemented
      var deserializedProject = await Pbxproj.open(project.path);
      var deserializedComponent = deserializedProject[uuid] as MapPbx;

      expect(deserializedComponent.childrenList.last.toString(),
          equals(MapEntryPbx(uuid, VarPbx('testValue')).toString()));
    });

    test('Exception handling for file operations', () async {
      // Redirect the open function to a non-existent file to simulate an error
      expect(() async => await Pbxproj.open('non_existent_directory/non_existent_file.pbxproj'),
          throwsA(isA<FileSystemException>()));
    });
  });
}
