import 'package:test/test.dart';
import 'package:xcode_parser1/xcode_parser1.dart';

void main() {
  group('ListPbx Tests', () {
    late ListPbx listPbx;
    late ElementOfListPbx element;

    setUp(() {
      element = ElementOfListPbx(
        'TestValue',
        comment: 'TestComment',
      );
      listPbx = ListPbx('TestListPbx', [element]);
    });

    test('Add ElementOfListPbx', () {
      final newElement = ElementOfListPbx('NewValue', comment: 'NewComment');
      listPbx.add(newElement);
      expect(listPbx.length, 2);
      expect(listPbx[1], newElement);
    });

    test('Access ElementOfListPbx by index', () {
      expect(listPbx[0], element);
    });

    test('Length of ListPbx', () {
      expect(listPbx.length, 1);
    });

    test('String representation', () {
      final str = listPbx.toString();
      expect(str.contains('TestListPbx = ('), isTrue);
      expect(str.contains('TestValue /* TestComment */,'), isTrue);
      expect(str.contains(');'), isTrue);
    });

    test('CopyWith method', () {
      final newElement = ElementOfListPbx('NewValue', comment: 'NewComment');
      final copiedListPbx = listPbx.copyWith(
        uuid: 'NewListPbx',
        children: [newElement],
      );

      expect(copiedListPbx.uuid, 'NewListPbx');
      expect(copiedListPbx.length, 1);
      expect(copiedListPbx[0], newElement);
      expect(copiedListPbx.comment, listPbx.comment);
    });

    test('CopyWith method with partial changes', () {
      final copiedListPbx = listPbx.copyWith(comment: 'NewComment');
      expect(copiedListPbx.uuid, listPbx.uuid);
      expect(copiedListPbx.length, 1);
      expect(copiedListPbx[0], element);
      expect(copiedListPbx.comment, 'NewComment');
    });

    test('CopyWith method without changes', () {
      final copiedListPbx = listPbx.copyWith();
      expect(copiedListPbx.uuid, listPbx.uuid);
      expect(copiedListPbx.length, listPbx.length);
      expect(copiedListPbx[0], element);
      expect(copiedListPbx.comment, listPbx.comment);
    });
  });
}
