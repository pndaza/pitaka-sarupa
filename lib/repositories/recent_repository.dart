import '../clients/database_client.dart';
import '../models/recent.dart';

abstract class RecentRepository {
  Future<List<Recent>> getAll();
  Future<void> add(Recent recent);
  Future<void> remove(int topicID);
  Future<void> removeAll();
  Future<bool> isContain(int topicID);
}

class RecentRepositoryDatabase extends RecentRepository {
  final DatabaseClient databaseClient;

  RecentRepositoryDatabase(this.databaseClient);

  final _recentTable = 'recent';
  final _topicTable = 'topic';
  final _columnID = 'id';
  final _columnTopicID = 'topic_id';
  final _columnName = 'name';
  final _columnDateTime = 'date';

  void init() {
    //
  }

  @override
  Future<List<Recent>> getAll() async {
    final database = await databaseClient.database;
    final maps = await database.rawQuery('''
SELECT $_columnTopicID, $_columnName as topic_name, $_columnDateTime FROM $_recentTable 
JOIN $_topicTable ON $_recentTable.$_columnTopicID = $_topicTable.$_columnID
''');
    if (maps.isEmpty) {
      return [];
    }
    return maps.map((e) => Recent.fromMap(e)).toList();
  }

  @override
  Future<void> add(Recent recent) async {
    final database = await databaseClient.database;
    // remove first
    await database.delete(_recentTable,
        where: '$_columnTopicID = ?', whereArgs: [recent.topicID]);
    await database.insert(_recentTable, recent.toMap());
  }

  @override
  Future<void> remove(int topicID) async {
    final database = await databaseClient.database;
    await database.delete(_recentTable,
        where: '$_columnTopicID = ?', whereArgs: [topicID]);
  }

  @override
  Future<void> removeAll() async {
    final database = await databaseClient.database;
    await database.delete('recent');
  }

  @override
  Future<bool> isContain(int topicID) async {
    final database = await databaseClient.database;
    final maps = await database.query(_recentTable,
        where: '$_columnTopicID = ?', whereArgs: [topicID]);
    return maps.isNotEmpty;
  }
}
