import 'package:xcode_parser1/src/pbxproj/interfaces/base_components.dart';
import 'package:xcode_parser1/src/pbxproj/pbxproj.dart';

class MapEntryPbx<T extends PbxprojComponent> extends NamedComponent {
  final T value;

  MapEntryPbx(
    String uuid,
    this.value, {
    super.comment,
  }) : super(uuid: uuid);

  @override
  String toString({int indentLevel = 0, bool removeN = false}) {
    String indent = removeN ? '' : Pbxproj.indent(indentLevel);
    String commentOut = comment != null ? ' /* $comment */' : '';
    final message = '$indent$uuid = $value$commentOut;${removeN ? ' ' : '\n'}';
    return message;
  }

  @override
  MapEntryPbx copyWith({
    String? uuid,
    T? value,
    String? comment,
  }) {
    return MapEntryPbx(
      uuid ?? this.uuid,
      value ?? this.value,
      comment: comment ?? this.comment,
    );
  }
}
