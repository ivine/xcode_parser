import 'package:xcode_parser1/src/pbxproj/interfaces/base_components.dart';
import 'package:xcode_parser1/src/pbxproj/pbxproj.dart';

class ElementOfListPbx extends PbxprojComponent {
  final String? comment;
  final String value;

  ElementOfListPbx(this.value, {this.comment});

  @override
  String toString({int indentLevel = 0, bool removeN = false}) {
    String indent = Pbxproj.indent(indentLevel);
    String commentOut = comment != null ? ' /* $comment */' : '';
    return '$indent$value$commentOut,';
  }

  @override
  ElementOfListPbx copyWith({
    String? value,
    String? comment,
  }) {
    return ElementOfListPbx(
      value ?? this.value,
      comment: comment ?? this.comment,
    );
  }
}
