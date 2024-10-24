import 'package:test/test.dart';
import 'package:xcode_parser1/xcode_parser1.dart';

void main() {
  group('CommentPbx Tests', () {
    late CommentPbx commentPbx;

    setUp(() {
      commentPbx = CommentPbx('This is a comment');
    });

    test('String representation with default indentation', () {
      final str = commentPbx.toString();
      expect(str, '// This is a comment\n');
    });

    test('String representation with indentation', () {
      final str = commentPbx.toString(indentLevel: 2, removeN: false);
      expect(str, '\t\t// This is a comment\n');
    });

    test('CopyWith method with new comment', () {
      final copiedCommentPbx = commentPbx.copyWith(comment: 'New comment');
      expect(copiedCommentPbx.comment, 'New comment');
    });

    test('CopyWith method without changes', () {
      final copiedCommentPbx = commentPbx.copyWith();
      expect(copiedCommentPbx.comment, 'This is a comment');
    });
  });
}
