import 'dart:io';

import 'package:hive/hive.dart';

part 'test_hive.g.dart';

@HiveType(typeId: 1)
class Person {
  Person({required this.name, required this.age, required this.friends});

  @HiveField(0)
  String name;

  @HiveField(1)
  int age;

  @HiveField(2)
  List<String> friends;

  @HiveField(3)
  List<String>? x;

  @override
  String toString() {
    return '$name: $age';
  }
}

void main() async {
  var path = Directory.current.path;
  Hive
    ..init(path)
    ..registerAdapter(PersonAdapter());

  var box = await Hive.openBox('testBox');
  print(box.runtimeType);
  box.length;

  var person = Person(
    name: 'Dave',
    age: 22,
    friends: ['Linda', 'Marc', 'Anne'],
  );
  box.keys;

  await box.put('dave', person);
  var results=box.values.where((element) => (element as Person).age>20);
  for(var x in results){
    print(x);
    print(x.runtimeType);
  }

  print(box.get('dave')); // Dave: 22
}