import 'package:test/test.dart';
import 'package:xcode_parser1/xcode_parser1.dart';

void main() {
  group('SectionPbx Tests', () {
    late SectionPbx section;
    late MapEntryPbx<VarPbx> component;

    setUp(() {
      component = MapEntryPbx(
        '123',
        VarPbx('TestComponent'),
        comment: 'TestComment',
      );
      section = SectionPbx(name: 'TestSection');
    });

    test('Add NamedComponent', () {
      section.add(component);
      expect(section.childrenList, contains(component));
      expect(section.childrenMap[component.uuid], component);
    });

    test('Remove NamedComponent by UUID', () {
      section.add(component);
      section.remove(component.uuid);
      expect(section.childrenList, isNot(contains(component)));
      expect(section.childrenMap[component.uuid], isNull);
    });

    test('Replace or Add NamedComponent', () {
      section.add(component);
      final newComponent = MapEntryPbx(
        '123',
        VarPbx('NewComponent'),
        comment: 'NewComment',
      );
      section.replaceOrAdd(newComponent);
      expect(section.childrenList, contains(newComponent));
      expect(section.childrenMap[component.uuid], newComponent);
    });

    test('Find NamedComponent by UUID', () {
      section.add(component);
      final foundComponent = section.find<MapEntryPbx<VarPbx>>('123');
      expect(foundComponent, component);
    });

    test('Find NamedComponent by Comment', () {
      section.add(component);
      final foundComponent = section.findComment<MapEntryPbx<VarPbx>>('TestComment');
      expect(foundComponent, component);
    });

    test('String representation', () {
      section.add(component);
      final str = section.toString();
      expect(str.contains('/* Begin TestSection section */'), isTrue);
      expect(str.contains('123 = TestComponent /* TestComment */;'), isTrue);
      expect(str.contains('/* End TestSection section */'), isTrue);
    });

    test('CopyWith method', () {
      section.add(component);
      final newComponent = MapEntryPbx(
        '456',
        VarPbx('NewComponent'),
        comment: 'NewComment',
      );
      final copiedSection = section.copyWith(
        name: 'NewSection',
        children: [newComponent],
      );

      expect(copiedSection.name, 'NewSection');
      expect(copiedSection.childrenList, contains(newComponent));
      expect(copiedSection.childrenMap[newComponent.uuid], newComponent);
      expect(copiedSection.childrenList, isNot(contains(component)));
      expect(copiedSection.childrenMap[component.uuid], isNull);
    });
  });
}
