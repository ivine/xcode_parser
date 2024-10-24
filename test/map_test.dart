import 'package:test/test.dart';
import 'package:xcode_parser1/xcode_parser1.dart';

void main() {
  group('MapPbx Tests', () {
    late MapPbx mapPbx;
    late MapEntryPbx<VarPbx> component;

    setUp(() {
      component = MapEntryPbx(
        '123',
        VarPbx('TestComponent'),
        comment: 'TestComment',
      );
      mapPbx = MapPbx(uuid: 'TestMapPbx');
    });

    test('Add NamedComponent', () {
      mapPbx.add(component);
      expect(mapPbx.childrenList, contains(component));
      expect(mapPbx.childrenMap[component.uuid], component);
    });

    test('Remove NamedComponent by UUID', () {
      mapPbx.add(component);
      mapPbx.remove(component.uuid);
      expect(mapPbx.childrenList, isNot(contains(component)));
      expect(mapPbx.childrenMap[component.uuid], isNull);
    });

    test('Replace or Add NamedComponent', () {
      mapPbx.add(component);
      final newComponent = MapEntryPbx(
        '1234',
        VarPbx('NewComponent'),
        comment: 'NewComment',
      );
      mapPbx.replaceOrAdd(newComponent);
      expect(mapPbx[newComponent.uuid], newComponent);

      final newComponent2 = newComponent.copyWith(
        value: VarPbx('NewComponent2'),
      );

      mapPbx.replaceOrAdd(newComponent2);
      expect(mapPbx[newComponent.uuid], newComponent2);
    });

    test('Find NamedComponent by UUID', () {
      mapPbx.add(component);
      final foundComponent = mapPbx.find<MapEntryPbx<VarPbx>>('123');
      expect(foundComponent, component);
    });

    test('Find NamedComponent by Comment', () {
      mapPbx.add(component);
      final foundComponent = mapPbx.findComment<MapEntryPbx<VarPbx>>('TestComment');
      expect(foundComponent, component);
    });

    test('String representation', () {
      mapPbx.add(component);
      final str = mapPbx.toString();
      expect(str.contains('TestMapPbx = {'), isTrue);
      expect(str.contains('123 = TestComponent /* TestComment */;'), isTrue);
      expect(str.contains('};'), isTrue);
    });

    test('CopyWith method', () {
      mapPbx.add(component);
      final newComponent = MapEntryPbx(
        '456',
        VarPbx('NewComponent'),
        comment: 'NewComment',
      );
      final copiedMapPbx = mapPbx.copyWith(
        uuid: 'NewMapPbx',
        children: [newComponent],
      );

      expect(copiedMapPbx.uuid, 'NewMapPbx');
      expect(copiedMapPbx.childrenList, contains(newComponent));
      expect(copiedMapPbx.childrenMap[newComponent.uuid], newComponent);
      expect(copiedMapPbx.childrenList, isNot(contains(component)));
      expect(copiedMapPbx.childrenMap[component.uuid], isNull);
    });
  });
}
