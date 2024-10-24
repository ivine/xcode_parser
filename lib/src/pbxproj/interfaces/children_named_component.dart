import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:xcode_parser1/src/pbxproj/interfaces/base_components.dart';

abstract class IChildrenNamedComponent extends NamedComponent {
  /// Getters
  List<NamedComponent> get childrenList;
  HashMap<String, NamedComponent> get childrenMap;

  /// Base constructor
  IChildrenNamedComponent({required super.uuid, super.comment});

  /// Methods
  ///
  /// The universal [find] method takes a [String]
  /// key and returns an instance of type [T] that extends [NamedComponent], or
  /// [null] if not found.
  T? find<T extends NamedComponent>(String key);

  /// [findComment] is a method that searches for a component of
  /// type [T] that extends [NamedComponent] based on a given [comment] string.
  /// It returns the found component or null if not found.
  T? findComment<T extends NamedComponent>(String comment);

  /// [add] is a method that adds a new [NamedComponent] to the list of children
  /// and updates the mapping of children by associating the component's UUID
  /// with the component itself.
  void add(NamedComponent component);

  /// [replaceOrAdd] is a method that replaces an existing [NamedComponent] in the list of children
  /// with a new component if it already exists, or adds a new component to the list of children
  /// and updates the mapping of children by associating the component's UUID with the component itself.
  ///
  /// The method takes a [NamedComponent] object named `component` as a parameter.
  /// If a component with the same UUID already exists in the list of children,
  /// it is replaced with the new component. Otherwise, the new component is added to the list of children.
  ///
  /// The method does not return anything.
  void replaceOrAdd(NamedComponent component);

  /// [remove] is a method that removes a [NamedComponent] from the list of children
  /// based on the component's UUID. It also removes the mapping of
  /// the component from the children map.
  void remove(String uuid);

  /// The [] operator is an indexer that allows accessing a [NamedComponent] from the list of children
  /// based on its UUID. It takes a [String] parameter named `uuid` and returns the corresponding
  /// [NamedComponent] if found, or null if not found.
  ///
  /// For example, to access a component with UUID "123", you can use the following syntax:
  /// ```dart
  /// NamedComponent? component = component[uuid];
  /// ```
  ///
  /// If the component with the given UUID exists in the list of children,
  /// it is returned. Otherwise, null is returned.
  NamedComponent? operator [](String key);
}

abstract class ChildrenNamedComponent extends IChildrenNamedComponent {
  final List<NamedComponent> _childrenList;
  final HashMap<String, NamedComponent> _childrenMap;

  @override
  List<NamedComponent> get childrenList => _childrenList;
  @override
  HashMap<String, NamedComponent> get childrenMap => _childrenMap;

  ChildrenNamedComponent({
    List<NamedComponent> children = const [],
    required super.uuid,
    super.comment,
  })  : _childrenList = List<NamedComponent>.from(children),
        _childrenMap = HashMap.fromIterable(
          children,
          key: (e) => e.uuid,
        );

  @override
  NamedComponent? operator [](String key) => _childrenMap[key];

  @override
  String toString({int indentLevel = 0, bool removeN = false}) =>
      childrenToString(childrenList, indentLevel: indentLevel, removeN: removeN);

  @override
  T? find<T extends NamedComponent>(String key) => _childrenList.firstWhereOrNull((test) => test.uuid == key && test is T) as T?;

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
