import 'dart:io';

import 'package:test/test.dart';
import 'package:xcode_parser/src/pbxproj/pbxproj_parse.dart';
import 'package:xcode_parser/xcode_parser.dart';

void main() {
  group('Pbxproj.open Tests', () {
    late String tempDirPath;
    late String tempFilePath;

    setUp(() async {
      tempDirPath = Directory.systemTemp.createTempSync().path;
      tempFilePath = '$tempDirPath/project.pbxproj';
    });

    tearDown(() async {
      final tempDir = Directory(tempDirPath);
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('Open Pbxproj file when file does not exist', () async {
      final pbxproj = await Pbxproj.open(tempFilePath);
      expect(pbxproj.path, tempFilePath);
      expect(pbxproj.childrenList, isEmpty);
    });

    test('Open Pbxproj file when file is empty', () async {
      final file = File(tempFilePath);
      await file.create(recursive: true);
      final pbxproj = await Pbxproj.open(tempFilePath);
      expect(pbxproj.path, tempFilePath);
      expect(pbxproj.childrenList, isEmpty);
    });

    test('Open Pbxproj file with content', () async {
      final file = File(tempFilePath);
      await file.create(recursive: true);
      await file.writeAsString('''// !\$*UTF8*\$!
      {
        someKey = someValue;
        "string test \$key" = "string "test" \$value";
       // comment
       someKey /* connemt */ = someValue;
      }''');

      final pbxproj = await Pbxproj.open(tempFilePath);
      expect(pbxproj.path, tempFilePath);
      expect(pbxproj.childrenList, isNotEmpty);
    });

    test('Open Pbxproj file and create necessary directories', () async {
      final customDirPath = '$tempDirPath/customDir';
      final customFilePath = '$customDirPath/project.pbxproj';
      final pbxproj = await Pbxproj.open(customFilePath);
      expect(pbxproj.path, customFilePath);
      expect(pbxproj.childrenList, isEmpty);
    });
  });

  group('parsePbxproj Tests', () {
    test('Parse simple PBX content', () {
      final content = '''
      {
        someKey = someValue;
      }
      ''';
      final pbxproj = parsePbxproj(content, '/path/to/project.pbxproj');
      expect(pbxproj.childrenList, isNotEmpty);
      expect((pbxproj.childrenList.first as MapEntryPbx).uuid, 'someKey');
      expect((pbxproj.childrenList.first as MapEntryPbx).value.toString(), 'someValue');
    });

    test('Parse PBX content with list', () {
      final content = '''
      {
        someList = (
          item1,
          item2 /* comment */
        );
      }
      ''';
      final pbxproj = parsePbxproj(content, '/path/to/project.pbxproj');
      expect(pbxproj.childrenList, isNotEmpty);
      final listPbx = pbxproj.childrenList.first as ListPbx;
      expect(listPbx[0].value, 'item1');
      expect(listPbx[1].value, 'item2');
      expect(listPbx[1].comment, 'comment');
    });

    test('Parse PBX content with nested maps', () {
      final content = '''
      {
        parentMap        = /* comment */ {
          childKey = childValue;
        };
      }
      ''';
      final pbxproj = parsePbxproj(content, '/path/to/project.pbxproj');
      expect(pbxproj.childrenList, isNotEmpty);
      final parentMap = pbxproj.childrenList.first as MapPbx;
      final childMapEntry = parentMap.childrenList.first as MapEntryPbx;
      expect(childMapEntry.uuid, 'childKey');
      expect(childMapEntry.value.toString(), 'childValue');
    });

    test('Parse PBX content with sections', () {
      final content = '''
      
      {
      /* Begin PBXSection section */
        sectionKey = sectionValue;
      /* End PBXSection section */
      }
      
      ''';
      final pbxproj = parsePbxproj(content, '/path/to/project.pbxproj', debug: true);
      expect(pbxproj.childrenList, isNotEmpty);
      final section = pbxproj.childrenList.first as SectionPbx;
      final sectionEntry = section.childrenList.first as MapEntryPbx;
      expect(section.name, 'PBXSection');
      expect(sectionEntry.uuid, 'sectionKey');
      expect(sectionEntry.value.toString(), 'sectionValue');
    });
  });
}
