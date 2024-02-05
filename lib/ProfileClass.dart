class Person {
  String name;
  String age;
  String gender;
  String occupation;
  String height;
  String weight;

  Person(
      {required this.name,
      required this.age,
      required this.gender,
      required this.occupation,
      required this.height,
      required this.weight});

  factory Person.fromJson(Map<String, dynamic> map) {
    return Person(
        name: map['name'],
        age: map['age'],
        gender: map['gender'],
        occupation: map['occupation'],
        height: map['height'],
        weight: map['weight']);
  }
}
