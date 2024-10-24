import 'package:xcode_parser1/src/pbxproj/interfaces/base_components.dart';
import 'package:xcode_parser1/src/pbxproj/interfaces/children_named_component.dart';
import 'package:xcode_parser1/src/pbxproj/map/map_entry_pbx.dart';
import 'package:xcode_parser1/src/pbxproj/pbxproj.dart';

class MapPbx extends ChildrenNamedComponent {
  MapPbx({
    super.children,
    required super.uuid,
    super.comment,
  });

  @override
  String toString({int indentLevel = 0, bool removeN = false}) {
    final allEntry = childrenList.every((test) => test is MapEntryPbx);

    String indent = Pbxproj.indent(indentLevel);
    String commentOut = comment != null ? ' /* $comment */' : '';
    String sb = '';
    final n = allEntry ? '' : '\n';
    sb += ('$indent$uuid$commentOut = {$n');
    sb += (super.toString(indentLevel: indentLevel, removeN: allEntry));
    sb += ('${allEntry ? '' : indent}};${removeN ? ' ' : '\n'}');
    return sb.toString();
  }

  @override
  MapPbx copyWith({
    String? uuid,
    List<NamedComponent>? children,
    String? comment,
  }) {
    return MapPbx(
      uuid: uuid ?? this.uuid,
      children: children ?? childrenList,
      comment: comment ?? this.comment,
    );
  }
}
