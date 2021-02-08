import 'package:personal_trainer_client/core/models/notification.dart';
import 'package:personal_trainer_client/core/models/session.dart';

abstract class DatabaseServiceInterface {
  Future<List<Session>> getBookings();
  Future<bool> addBooking(Session session);
  Future<bool> deleteBooking(String sessionID);

  Future<int> scheduleNotification(String sessionID);
  Future<Notification> getNotification(String sessionID);
  Future<bool> deleteNotification(int id);
}
