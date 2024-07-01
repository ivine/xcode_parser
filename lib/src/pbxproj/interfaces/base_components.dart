abstract class PbxprojComponent {
  @override
  String toString({int indentLevel = 0, bool removeN = false});

  PbxprojComponent copyWith();

  String childrenToString(List<NamedComponent> children, {int indentLevel = 0, bool removeN = false}) {
    String sb = '';
    final n = removeN ? '' : '\n';
    for (int i = 0; i < children.length; i++) {
      sb += ('${children[i].toString(indentLevel: removeN ? 0 : (indentLevel + 1), removeN: removeN)}');
    }
    return sb.toString();
  }
}

abstract class NamedComponent extends PbxprojComponent {
  final String? comment;
  final String uuid;
  NamedComponent({required this.uuid, this.comment});
}
