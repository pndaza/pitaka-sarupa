class Favourite {
  final int topicID;
  final String topicName;
  final DateTime dateTime;

  Favourite({
    required this.topicID,
    required this.topicName,
    required this.dateTime,
  });

  factory Favourite.fromMap(Map<String, dynamic> json) {
    return Favourite(
      topicID: json['topic_id'] as int,
      topicName: json['topic_name'] as String,
      dateTime: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'topic_id': topicID,
      // topic name will not be save
      'date': dateTime.toIso8601String(),
    };
  }
}
