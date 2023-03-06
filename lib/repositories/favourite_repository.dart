import '../clients/database_client.dart';
import '../models/favourite.dart';

abstract class FavouriteRepisotry {
  Future<List<Favourite>> getAll();
  Future<void> add(Favourite favourite);
  Future<void> remove(int topicID);
  Future<void> removeAll();
  Future<bool> isContain(int topicID);
}

class FavouriteRepositoryDatabase extends FavouriteRepisotry {
  final DatabaseClient databaseClient;

  FavouriteRepositoryDatabase(this.databaseClient);

  final _favouriteTable = 'favourite';
  final _topicTable = 'topic';
  final _columnID = 'id';
  final _columnTopicID = 'topic_id';
  final _columnName = 'name';
  final _columnDateTime = 'date';

  void init() {
    //
  }

  @override
  Future<List<Favourite>> getAll() async {
    final database = await databaseClient.database;
    final maps = await database.rawQuery('''
SELECT $_columnTopicID, $_columnName as topic_name, $_columnDateTime FROM $_favouriteTable 
JOIN $_topicTable ON $_favouriteTable.$_columnTopicID = $_topicTable.$_columnID
''');
    if (maps.isEmpty) {
      return [];
    }
    return maps.map((e) => Favourite.fromMap(e)).toList();
  }

  @override
  Future<void> add(Favourite favourite) async {
    final database = await databaseClient.database;
    // remove first
    await database.delete(_favouriteTable,
        where: '$_columnTopicID = ?', whereArgs: [favourite.topicID]);
    await database.insert(_favouriteTable, favourite.toMap());
  }

  @override
  Future<void> remove(int topicID) async {
    final database = await databaseClient.database;
    await database.delete(_favouriteTable,
        where: '$_columnTopicID = ?', whereArgs: [topicID]);
  }

  @override
  Future<void> removeAll() async {
    final database = await databaseClient.database;
    await database.delete('favourite');
  }

  @override
  Future<bool> isContain(int topicID) async {
    final database = await databaseClient.database;
    final maps = await database.query(_favouriteTable,
        where: '$_columnTopicID = ?', whereArgs: [topicID]);
    return maps.isNotEmpty;
  }
}
