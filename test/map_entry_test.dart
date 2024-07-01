import 'package:test/test.dart';
import 'package:xcode_parser/xcode_parser.dart';

void main() {
  group('MapEntryPbx Tests', () {
    late MapEntryPbx<VarPbx> mapEntryPbx;
    late VarPbx component;

    setUp(() {
      component = VarPbx('TestComponent');
      mapEntryPbx = MapEntryPbx(
        '123',
        component,
        comment: 'TestComment',
      );
    });

    test('String representation without indentation and with comment', () {
      final str = mapEntryPbx.toString(indentLevel: 0, removeN: true);
      expect(str, '123 = TestComponent /* TestComment */; ');
    });

    test('String representation with indentation and without comment', () {
      mapEntryPbx = MapEntryPbx(
        '123',
        component,
      );
      final str = mapEntryPbx.toString(indentLevel: 2, removeN: false);
      expect(str, '\t\t123 = TestComponent;\n');
    });

    test('CopyWith method', () {
      final newComponent = VarPbx('NewComponent');
      final copiedMapEntryPbx = mapEntryPbx.copyWith(
        uuid: '456',
        value: newComponent,
        comment: 'NewComment',
      );

      expect(copiedMapEntryPbx.uuid, '456');
      expect(copiedMapEntryPbx.value, newComponent);
      expect(copiedMapEntryPbx.comment, 'NewComment');
    });

    test('CopyWith method with partial changes', () {
      final newComponent = VarPbx('NewComponent');
      final copiedMapEntryPbx = mapEntryPbx.copyWith(
        value: newComponent,
      );

      expect(copiedMapEntryPbx.uuid, '123');
      expect(copiedMapEntryPbx.value, newComponent);
      expect(copiedMapEntryPbx.comment, 'TestComment');
    });
  });
}
