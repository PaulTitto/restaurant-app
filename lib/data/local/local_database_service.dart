import 'package:sqflite/sqflite.dart';
import '../model/restaurant.dart';

class LocalDatabaseService {
  static const String _databaseName = 'restaurant_app.db';
  static const String _tableName = 'restaurant';
  static const int _version = 1;

  Future<void> createTables(Database database) async {
    await database.execute(
        """CREATE TABLE $_tableName(
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        city TEXT,
        pictureId TEXT,
        rating REAL
      )"""
    );
  }

  Future<Database> _initializeDb() async {
    return openDatabase(
      _databaseName,
      version: _version,
      onCreate: (Database db, int version) async {
        await createTables(db);
      },
    );
  }

  Future<int> insertRestaurant(Restaurant restaurant) async {
    final db = await _initializeDb();

    final data = {
      'id': restaurant.id,
      'name': restaurant.name,
      'description': restaurant.description,
      'city': restaurant.city,
      'pictureId': restaurant.pictureId,
      'rating': restaurant.rating,
    };

    return await db.insert(
      _tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all restaurants
  Future<List<Restaurant>> getAllRestaurants() async {
    final db = await _initializeDb();
    final results = await db.query(_tableName);

    return results.map((result) => Restaurant(
      id: result['id'] as String,
      name: result['name'] as String,
      description: result['description'] as String,
      city: result['city'] as String,
      pictureId: result['pictureId'] as String,
      rating: (result['rating'] as num).toDouble(),
    )).toList();
  }

  // Get restaurant by ID
  Future<Restaurant?> getRestaurantById(String id) async {
    final db = await _initializeDb();
    final results = await db.query(
      _tableName,
      where: "id = ?",
      whereArgs: [id],
      limit: 1,
    );

    if (results.isNotEmpty) {
      final result = results.first;
      return Restaurant(
        id: result['id'] as String,
        name: result['name'] as String,
        description: result['description'] as String,
        city: result['city'] as String,
        pictureId: result['pictureId'] as String,
        rating: (result['rating'] as num).toDouble(),
      );
    } else {
      return null;
    }
  }

  Future<int> removeRestaurant(String id) async {
    final db = await _initializeDb();
    return await db.delete(_tableName, where: "id = ?", whereArgs: [id]);
  }
}
