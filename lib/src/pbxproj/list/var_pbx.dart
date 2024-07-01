import 'package:xcode_parser/src/pbxproj/interfaces/base_components.dart';

class VarPbx extends PbxprojComponent {
  final String value;
  VarPbx(this.value);

  @override
  String toString({int indentLevel = 0, bool removeN = false}) {
    return value;
  }

  @override
  VarPbx copyWith({String? value}) {
    return VarPbx(value ?? this.value);
  }
}
