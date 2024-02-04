//To auto-generate, do dart run build_runner watch -d
//At first, t

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'ProfileClass.dart';

part 'riverpod.g.dart';

@Riverpod(keepAlive: true)
class getProfileList extends _$getProfileList {
  @override
  List<Person> build() {
    print("building LIST for 1st time");
    return [];
  }

  void addPersons() {
    var first = ref.read(get1stFormInfoProvider.notifier).state;
    var second = ref.read(get2ndFormInfoProvider.notifier).state;
    var occupation = "";
    if (second['occupation'] != 'Others') {
      occupation = second['occupation'];
    } else {
      occupation = second['occupationOthers'];
    }

    List<Person> oldState = state;

    oldState.add(Person(
        name: first['name'],
        age: first['age'],
        gender: first['gender'],
        occupation: occupation,
        height: second['height'],
        weight: second['height']));

    state = [...oldState];

    print("New List $state");
  }

  getList() {
    print("called");
    return state;
  }
}

@Riverpod(keepAlive: true)
class Get1stFormInfo extends _$Get1stFormInfo {
  @override
  Map<String, dynamic> build() {
    print("1st Map");
    return {};
  }

  setInfo(Map<String, dynamic> newInfo) {
    state = newInfo;
    print("state $state");
  }

  Map<String, dynamic> getState() {
    return state;
  }
}

@Riverpod(keepAlive: true)
class Get2ndFormInfo extends _$Get2ndFormInfo {
  @override
  Map<String, dynamic> build() {
    return {};
  }

  setInfo(Map<String, dynamic> newInfo) {
    state = newInfo;
    print("state $state");
  }

  Map<String, dynamic> getState() {
    return state;
  }
}
