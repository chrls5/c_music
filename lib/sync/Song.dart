
class Song {
  String name;

  int age;

  Song(this.name, this.age);

  factory Song.fromJson(dynamic json) {
    return Song(json['name'] as String, json['age'] as int);
  }

  @override
  String toString() {
    return '{ ${this.name}, ${this.age} }';
  }
}