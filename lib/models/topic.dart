class Topic {
  final int id;
  final String name;

  Topic(this.id, this.name);

  factory Topic.fromMap(Map<String, dynamic> map) {
    return Topic(
      map['id']?.toInt() ?? 0,
      map['name'] ?? '',
    );
  }
}
