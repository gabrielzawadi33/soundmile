import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class PlaylistHelper {
  static final PlaylistHelper _instance = PlaylistHelper._internal();
  factory PlaylistHelper() => _instance;
  static Database? _database;

  PlaylistHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'music_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        '''
        CREATE TABLE playlists (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL
        )
      ''');
    await db.execute(
        '''
        CREATE TABLE playlist_songs (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          playlist_id INTEGER NOT NULL,
          song_id INTEGER NOT NULL,
          FOREIGN KEY (playlist_id) REFERENCES playlists (id)
        )
      ''');
  }

  Future<int> createPlaylist(String name) async {
    final db = await database;
    return await db.insert('playlists', {'name': name});
  }

  Future<int> addSongToPlaylist(int playlistId, int songId) async {
    final db = await database;
    return await db.insert('playlist_songs', {
      'playlist_id': playlistId,
      'song_id': songId,
    });
  }

  Future<List<String>> getPlaylists() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('playlists');

    return List.generate(maps.length, (i) {
      return maps[i]['name'];
    });
  }

  Future<int?> getPlaylistIdByName(String name) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'playlists',
      where: 'name = ?',
      whereArgs: [name],
    );

    if (maps.isNotEmpty) {
      return maps.first['id'] as int?;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getPlaylistsWithSongCount() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        '''
        SELECT playlists.id, playlists.name, COUNT(playlist_songs.id) as song_count
        FROM playlists
        LEFT JOIN playlist_songs ON playlists.id = playlist_songs.playlist_id
        GROUP BY playlists.id, playlists.name
      ''');

    return maps;
  }

  Future<List<int>> getSongIdsForPlaylist(int playlistId) async {
    final Database db = await database;
 print(
          '$playlistId>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    final List<Map<String, dynamic>> maps = await db.query(
      'playlist_songs',
      columns: ['song_id'],
      where: 'playlist_id = ?',
      whereArgs: [playlistId],
    );
print(maps);
    return maps.map((map) => map['song_id'] as int).toList();
  }
}
