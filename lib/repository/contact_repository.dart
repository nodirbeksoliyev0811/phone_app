import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/contact.dart';
import '../models/contact_sql.dart';

class DatabaseHelper {
  static Database? _database;
  static const String dbName = 'my_contacts.db';

  static Future<Database> open() async {
    if (_database == null) {
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, dbName);
      _database = await openDatabase(path, version: 1, onCreate: _onCreate);
    }
    return _database!;
  }

  static _onCreate(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    // const intType = 'INTEGER DEFAULT = 0';

    await db.execute('''CREATE TABLE ${ContactModelFields.tableName}(
        ${ContactModelFields.id} $idType, 
        ${ContactModelFields.name} $textType, 
        ${ContactModelFields.surname} $textType,
        ${ContactModelFields.phoneNumber} $textType
        ${ContactModelFields.userImage} $textType
     )''');
  }

  static Future<int> insertContact(Contact contact) async {
    final db = await open();
    return db.insert(ContactModelFields.tableName, contact.toMap());
  }

  static Future<List<Contact>> getContacts() async {
    final db = await open();
    final List<Map<String, dynamic>> contacts =
        await db.query(ContactModelFields.tableName);
    return List.generate(
        contacts.length, (index) => Contact.fromJson(contacts[index]));
  }

  static Future<int> updateContact(Contact contact) async {
    final db = await open();
    return db.update(ContactModelFields.tableName, contact.toMap(),
        whereArgs: [contact.id], where: '${ContactModelFields.id} = ?');
  }

  static search(String pattern) async {
    final db = await open();
    List<Map<String, dynamic>> contacts = await db.query(
        ContactModelFields.tableName,
        where:
            '${ContactModelFields.name} LIKE %$pattern% OR ${ContactModelFields.surname} Like %pattern% ');
    return List.generate(
        contacts.length, (index) => Contact.fromJson(contacts[index]));
  }

  static Future<int> deleteContact(int id) async {
    final db = await open();
    return db.delete(ContactModelFields.tableName,
        where: '${ContactModelFields.id} = ?', whereArgs: [id]);
  }

  static deleteContacts() async {
    final db = await open();
    db.delete(
      ContactModelFields.tableName,
    );
  }
  static Future<List<Contact>> getSortBy(String order) async {
    List<Contact>? allContact = [];
    final db = await open();
    allContact = (await db.query(ContactModelFields.tableName,
        orderBy: "${ContactModelFields.name} $order"))
        .map((e) => Contact.fromJson(e)).cast<Contact>()
        .toList();
    return allContact;
  }
}
