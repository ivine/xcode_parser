import 'package:xcode_parser/xcode_parser.dart';

class CommentPbx extends NamedComponent {
  CommentPbx(String comment) : super(uuid: comment, comment: comment);
  @override
  String toString({int indentLevel = 0, bool removeN = false}) {
    return '// $comment\n';
  }

  @override
  PbxprojComponent copyWith({String? comment}) {
    return CommentPbx(comment ?? this.comment ?? '');
  }
}
