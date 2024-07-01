import 'package:xcode_parser/xcode_parser.dart';

void main() async {
  Pbxproj project = Pbxproj(path: 'ios/Runner.xcodeproj/project.pbxproj');
  addBuildConfiguration(project);
  addFramework(project);
  print(project);
  // Output

  //// !$*UTF8*$!
  // {
  // 	12459B9B277D272A45EDBC24 = {
  // 		isa = XCBuildConfiguration;
  // 		name = "CustomDebug";
  // 		buildSettings = {SWIFT_VERSION = 5.0; IPHONEOS_DEPLOYMENT_TARGET = 12.0; };
  // 	};
  // 	B1016741719B432C10A504E8 = {
  // 		isa = PBXGroup;
  // 		children = (
  // 			DE9302C66A7999063CB76C6D /* FrameworkName.framework */,
  // 			C43FE36031339AEC89A9EC36 /* Framework2Name.framework */,
  // 		);
  // 	};
  // }
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

void addFramework(Pbxproj project) {
  final uuidMap = project.generateUuid();
  final uuidFrameworkName = project.generateUuid();
  final uuidFramework2Name = project.generateUuid();

  final frameworksGroup = MapPbx(
    uuid: uuidMap,
    children: [
      MapEntryPbx('isa', VarPbx('PBXGroup')),
      ListPbx('children', [
        ElementOfListPbx(uuidFrameworkName, comment: 'FrameworkName.framework'),
        ElementOfListPbx(uuidFramework2Name, comment: 'Framework2Name.framework'),
      ]),
    ],
  );
  project.add(frameworksGroup);
}

final project = Pbxproj(
  path: 'example.pbxproj',
  children: [
    MapPbx(
      uuid: '12459B9B277D272A45EDBC24',
      children: [
        MapEntryPbx('baseEntry', VarPbx('example')),
        MapEntryPbx('name', VarPbx('"val"')),
        MapPbx(
          uuid: 'buildSettings',
          children: [
            MapEntryPbx('EX_ENTRY_VAL', VarPbx('val')),
            MapEntryPbx('EX_ENTRY_STRING', VarPbx('"string_val"')),
          ],
        ),
      ],
    ),
    ListPbx(
      'B1016741719B432C10A504E8',
      [
        ElementOfListPbx(
          'DE9302C66A7999063CB76C6D',
          comment: 'Comment.ext',
        ),
        ElementOfListPbx(
          'C43FE36031339AEC89A9EC36',
          comment: 'Comment',
        ),
      ],
    )
  ],
);
