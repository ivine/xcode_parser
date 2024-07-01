import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:xcode_parser/src/pbxproj/interfaces/base_components.dart';

abstract class IChildrenComponent extends PbxprojComponent {
  /// Getters
  List<NamedComponent> get childrenList;
  HashMap<String, NamedComponent> get childrenMap;

  /// Base constructor
  IChildrenComponent({List<NamedComponent> children = const []});

  /// Methods
  ///
  T? find<T extends NamedComponent>(String key);
  T? findComment<T extends NamedComponent>(String comment);
  void add(NamedComponent component);
  void replaceOrAdd(NamedComponent component);
  void remove(String uuid);
  NamedComponent? operator [](String key);

  @override
  String toString({int indentLevel = 0, bool removeN = false}) =>
      childrenToString(childrenList, indentLevel: indentLevel);
}

abstract class ChildrenComponent extends IChildrenComponent {
  final List<NamedComponent> _childrenList;
  final HashMap<String, NamedComponent> _childrenMap;

  @override
  List<NamedComponent> get childrenList => _childrenList;
  @override
  HashMap<String, NamedComponent> get childrenMap => _childrenMap;

  ChildrenComponent({
    List<NamedComponent> children = const [],
  })  : _childrenList = children,
        _childrenMap = HashMap.fromIterable(
          children,
          key: (e) => e.uuid,
        );

  @override
  NamedComponent? operator [](String key) => _childrenMap[key];

  @override
  T? find<T extends NamedComponent>(String key) =>
      _childrenList.firstWhereOrNull((test) => test.uuid == key && test is T) as T?;

  @override
  T? findComment<T extends NamedComponent>(String comment) =>
      _childrenList.firstWhereOrNull((test) => (test.comment?.contains(comment) ?? false) && test is T) as T?;

  @override
  void add(NamedComponent component) {
    _childrenList.add(component);
    _childrenMap[component.uuid] = component;
  }

  @override
  void remove(String uuid) {
    _childrenList.removeWhere((test) => test.uuid == uuid);
    _childrenMap.remove(uuid);
  }

  @override
  void replaceOrAdd(NamedComponent component) {
    _childrenMap[component.uuid] = component;
    _childrenList.indexWhere((test) => test.uuid == component.uuid);
    final indexInList = _childrenList.indexWhere((test) => test.uuid == component.uuid);
    if (indexInList == -1) {
      _childrenList.add(component);
    } else {
      _childrenList[indexInList] = component;
    }
  }
}
