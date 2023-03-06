class Recent {
  final int topicID;
  final String topicName;
  final DateTime dateTime;

  Recent({
    required this.topicID,
    required this.topicName,
    required this.dateTime,
  });

  factory Recent.fromMap(Map<String, dynamic> json) {
    return Recent(
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
