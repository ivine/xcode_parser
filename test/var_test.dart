import 'package:test/test.dart';
import 'package:xcode_parser/xcode_parser.dart';

void main() {
  group('VarPbx Tests', () {
    late VarPbx varPbx;

    setUp(() {
      varPbx = VarPbx('TestValue');
    });

    test('String representation without indentation and without newline removal', () {
      final str = varPbx.toString(indentLevel: 0, removeN: false);
      expect(str, 'TestValue');
    });

    test('String representation with indentation and without newline removal', () {
      final str = varPbx.toString(indentLevel: 2, removeN: false);
      expect(str, 'TestValue');
    });

    test('CopyWith method with new value', () {
      final copiedVarPbx = varPbx.copyWith(value: 'NewValue');
      expect(copiedVarPbx.value, 'NewValue');
    });

    test('CopyWith method with same value', () {
      final copiedVarPbx = varPbx.copyWith();
      expect(copiedVarPbx.value, 'TestValue');
    });
  });
}
