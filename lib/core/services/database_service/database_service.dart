import 'package:personal_trainer_client/core/models/notification.dart';
import 'package:personal_trainer_client/core/models/session.dart';
import 'package:personal_trainer_client/core/services/database_service/database_service_interface.dart';
import 'package:personal_trainer_client/locator.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_migration_service/sqflite_migration_service.dart';

class DatabaseService extends DatabaseServiceInterface {
  static const String DB_NAME = 'personal_trainer_db.sqlite';
  static const String BookingsTable = 'bookings';
  static const String NotificationsTable = 'notifications';
  static const int DB_VERSION = 9;

  Database _database;

  final DatabaseMigrationService _migrationService =
      locator<DatabaseMigrationService>();

  Future initialise() async {
    _database = await openDatabase(DB_NAME, version: DB_VERSION);

    await _migrationService
        .runMigration(_database, migrationFiles: ['1_create_schema.sql']);
  }

  @override
  Future<bool> addBooking(Session session) async {
    try {
      var jsonData = session.toJson();
      jsonData['sessionID'] = session.sessionID;
      jsonData.removeWhere((key, value) => key == 'client');
      jsonData.removeWhere((key, value) => key == 'clientToken');
      await _database.insert(BookingsTable, jsonData);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future deleteBookings() async {
    await _database.delete(BookingsTable);
  }

  @override
  Future<bool> deleteBooking(String sessionID) async {
    try {
      await _database.delete(BookingsTable,
          where: 'sessionID = ?', whereArgs: [sessionID]);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<Session>> getBookings() async {
    try {
      var result = await _database.query(BookingsTable);
      var bookings = result
          .map((booking) => Session.fromMap(booking, booking['sessionID']))
          .toList();

      return bookings;
    } catch (e) {
      return <Session>[];
    }
  }

  @override
  Future<bool> deleteNotification(int id) async {
    try {
      await _database
          .delete(NotificationsTable, where: 'id = ?', whereArgs: [id]);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Notification> getNotification(String sessionID) async {
    try {
      var jsonData = await _database.query(NotificationsTable,
          where: 'sessionID = ?', whereArgs: [sessionID]);

      return Notification.fromMap(jsonData.first);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<int> scheduleNotification(String sessionID) async {
    try {
      int id =
          await _database.insert(NotificationsTable, {'sessionID': sessionID});
      return id;
    } catch (e) {
      return -1;
    }
  }
}
