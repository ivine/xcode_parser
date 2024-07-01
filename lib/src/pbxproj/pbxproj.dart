import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:xcode_parser/src/pbxproj/interfaces/base_components.dart';
import 'package:xcode_parser/src/pbxproj/interfaces/children_component.dart';
import 'package:xcode_parser/src/pbxproj/pbxproj_parse.dart';

class Pbxproj extends ChildrenComponent {
  final String path;

  static String indent(int indentLevel) => '	' * (indentLevel);

  Pbxproj({super.children, required this.path});

  @override
  String toString({int indentLevel = 0, bool removeN = false}) {
    String indent = Pbxproj.indent(indentLevel);
    StringBuffer sb = StringBuffer();
    sb.write('// !\$*UTF8*\$!\n');
    sb.write('$indent{\n');
    sb.write(super.toString(indentLevel: indentLevel));
    sb.write('$indent}');
    return sb.toString();
  }

  @override
  Pbxproj copyWith({
    List<NamedComponent>? children,
    String? path,
  }) {
    return Pbxproj(
      children: children ?? childrenList,
      path: path ?? this.path,
    );
  }

  static Future<Pbxproj> open(String path) async {
    final file = File(path);
    final content = await file.readAsString();
    if (content.isEmpty) {
      return Pbxproj(path: path);
    }
    return parsePbxproj(content, path, debug: true);
  }

  Future<void> save() async {
    final file = File(path);
    await file.writeAsString(toString());
  }

  String generateUuid() {
    const chars = '0123456789ABCDEF';
    final rand = Random();
    final uuid = List.generate(24, (index) => chars[rand.nextInt(chars.length)]).join();
    return _checkUuid(uuid);
  }

  String _checkUuid(String uuid) {
    final content = toString();
    if (content.contains(uuid)) {
      return generateUuid();
    } else {
      return uuid;
    }
  }
}
