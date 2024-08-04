import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/item_model.dart';  // Ensure you have the Item model file in the correct path

class SQLiteService with ChangeNotifier{
  static final SQLiteService _instance = SQLiteService._internal();
  static Database? _database;

  factory SQLiteService() {
    return _instance;
  }

  SQLiteService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'items_database.db');
    return await openDatabase(
      path,
      version: 1,  // Increment this version if you need to change the database schema
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY,
        name TEXT,
        image TEXT,
        canAttack INTEGER,
        canDefend INTEGER,
        canSwitchDefend INTEGER,
        canHeal INTEGER,
        canDie INTEGER,
        canKill INTEGER,
        canGoGrave INTEGER,
        needsCondition INTEGER,
        hasAbility INTEGER,
        canUseAbility INTEGER,
        canRevive INTEGER,
        canBeRevived INTEGER,
        canBeEquipped INTEGER,
        canhaveEquipped INTEGER,
        canequipOther INTEGER,
        isThereabilityCondition INTEGER,
        effectValidFromGrave INTEGER,
        effectValidFromNone INTEGER,
        isAbilityRev INTEGER,
        isCurrentAbilityRev BLOB,
        equippedCards BLOB,
        appliedEffectCards BLOB,
        hp BLOB,
        attk BLOB,
        def BLOB,
        heal BLOB,
        graveAmount BLOB,
        handAmount BLOB,
        abilityDuration BLOB,
        abilityDurationRepeat INTEGER,
        turns INTEGER,
        equippedNumber BLOB,
        hasEffectOnIt INTEGER,
        effectActive INTEGER,
        canEffectBeAppliedOn INTEGER,
        canUseEffect INTEGER,
        condition BLOB,
        cardType INTEGER,
        activation INTEGER,
        range BLOB,
        target BLOB,
        targetNumber BLOB,
        targetType BLOB,
        ability BLOB,
        date TEXT
      )
    ''');
  }

  // Insert a single item
  Future<int> insertItem(Item item) async {
    Database db = await database;
    return await db.insert('items', item.toMap());
  }

  // Insert multiple items (bulk insert)
  Future<void> insertItems(List<Item> items) async {
    Database db = await database;
    Batch batch = db.batch();
    for (var item in items) {
      batch.insert('items', item.toMap());
    }
    await batch.commit(noResult: true);
  }

  // Get all items
  Future<List<Item>> getAllItems() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('items');
    return List.generate(maps.length, (i) {
      return Item.fromMap(maps[i]);
    });
  }

  // Get a single item by date
  Future<Item?> getItemByDate(DateTime date) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'items',
      where: 'date = ?',
      whereArgs: [date.toIso8601String()],
    );
    if (maps.isNotEmpty) {
      return Item.fromMap(maps.first);
    }
    return null;
  }

  // Update an item
  Future<int> updateItem(Item item) async {
    Database db = await database;
    return await db.update(
      'items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  // Delete an item
  Future<int> deleteItem(int id) async {
    Database db = await database;
    return await db.delete(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
