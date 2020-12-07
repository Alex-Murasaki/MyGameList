import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String tableGame = "gamesTabela";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String publisherColumn = "publisherColumn";
final String genreColumn = "genreColumn";
final String devsColumn = "devsColumn";
final String yearColumn = "yearColumn";
final String plataformColumn = "plataformColumn";
final String coverColumn = "coverColumn";

class helper {
  static final helper _instance = helper.internal();

  factory helper() => _instance;

  helper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "games.db");
    return openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $tableGame($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT"
          ", $publisherColumn TEXT, $genreColumn TEXT, $devsColumn TEXT"
          ", $yearColumn INTEGER, $plataformColumn TEXT, $coverColumn TEXT)");
    });
  }

  Future<Game> InsertGame(Game game) async {
    print('inserir');
    Database dbGame = await db;
    game.id = await dbGame.insert(tableGame, game.toMap());
    return game;
  }

  Future<Game> SelectGame(int id) async {
    Database dbGame = await db;
    List<Map> maps = await dbGame.query(tableGame,
        columns: [
          idColumn,
          nameColumn,
          publisherColumn,
          genreColumn,
          devsColumn,
          yearColumn,
          plataformColumn,
          coverColumn
        ],
        where: '$idColumn = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Game.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> DeleteGame(int id) async {
    Database dbGame = await db;
    return await dbGame
        .delete(tableGame, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> EditGame(Game game) async {
    Database dbGame = await db;
    return await dbGame.update(tableGame, game.toMap(),
        where: "$idColumn = ?", whereArgs: [game.id]);
  }

  Future<List> getAllGames() async {
    Database dbGame = await db;
    List listMap = await dbGame.rawQuery("SELECT * FROM $tableGame");
    List<Game> listGames = List();
    for (Map map in listMap) {
      listGames.add(Game.fromMap(map));
    }
    return listGames;
  }

  Future<Game> getThisGame(int thisId) async {
    print('GET THIS GAME');
    Database dbGame = await db;
    List listMap = await dbGame.rawQuery("SELECT * FROM $tableGame WHERE $idColumn = $thisId"); 
    return Game.fromMap(listMap.elementAt(0));
  }

  Future<int> getQuantity() async {
    Database dbGame = await db;
    return Sqflite.firstIntValue(
        await dbGame.rawQuery("SELECT COUNT(*) FROM $tableGame"));
  }

  Future close() async {
    Database dbGame = await db;
    await dbGame.close();
  }
}

class Game {
  int id;
  String name;
  String publisher;
  String genre;
  String devs;
  int year;
  String plataform;
  String cover;

  Game();

  Game.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    publisher = map[publisherColumn];
    genre = map[genreColumn];
    devs = map[devsColumn];
    year = map[yearColumn];
    plataform = map[plataformColumn];
    cover = map[coverColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      publisherColumn: publisher,
      genreColumn: genre,
      devsColumn: devs,
      yearColumn: year,
      plataformColumn: plataform,
      coverColumn: cover
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

}
