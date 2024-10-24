import 'package:test/test.dart';
import 'package:xcode_parser1/xcode_parser1.dart';

void main() {
  group('ElementOfListPbx Tests', () {
    late ElementOfListPbx element;

    setUp(() {
      element = ElementOfListPbx(
        'TestValue',
        comment: 'TestComment',
      );
    });

    test('String representation with comment', () {
      final str = element.toString(indentLevel: 0, removeN: false);
      expect(str, 'TestValue /* TestComment */,');
    });

    test('String representation without comment', () {
      element = ElementOfListPbx('TestValue');
      final str = element.toString(indentLevel: 0, removeN: false);
      expect(str, 'TestValue,');
    });

    test('String representation with indentation', () {
      final str = element.toString(indentLevel: 2, removeN: false);
      expect(str, '\t\tTestValue /* TestComment */,');
    });

    test('CopyWith method with new value', () {
      final copiedElement = element.copyWith(
        value: 'NewValue',
        comment: 'NewComment',
      );
      expect(copiedElement.value, 'NewValue');
      expect(copiedElement.comment, 'NewComment');
    });

    test('CopyWith method with partial changes', () {
      final copiedElement = element.copyWith(value: 'NewValue');
      expect(copiedElement.value, 'NewValue');
      expect(copiedElement.comment, 'TestComment');
    });

    test('CopyWith method without changes', () {
      final copiedElement = element.copyWith();
      expect(copiedElement.value, 'TestValue');
      expect(copiedElement.comment, 'TestComment');
    });
  });
}
