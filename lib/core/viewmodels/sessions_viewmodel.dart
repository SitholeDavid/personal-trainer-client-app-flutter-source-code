import 'package:personal_trainer_client/core/models/client.dart';
import 'package:personal_trainer_client/core/models/notification.dart';
import 'package:personal_trainer_client/core/models/purchases.dart';
import 'package:personal_trainer_client/core/models/session.dart';
import 'package:personal_trainer_client/core/services/auth_service/auth_service.dart';
import 'package:personal_trainer_client/core/services/auth_service/auth_service_interface.dart';
import 'package:personal_trainer_client/core/services/cloud_messaging_service/cloud_messaging_service.dart';
import 'package:personal_trainer_client/core/services/cloud_messaging_service/cloud_messaging_service_interface.dart';
import 'package:personal_trainer_client/core/services/database_service/database_service.dart';
import 'package:personal_trainer_client/core/services/database_service/database_service_interface.dart';
import 'package:personal_trainer_client/core/services/firestore_service/firestore_service.dart';
import 'package:personal_trainer_client/core/services/firestore_service/firestore_service_interface.dart';
import 'package:personal_trainer_client/core/services/local_notifications_service/local_notification_service.dart';
import 'package:personal_trainer_client/core/services/local_notifications_service/local_notification_service_interface.dart';
import 'package:personal_trainer_client/locator.dart';
import 'package:personal_trainer_client/ui/constants/enums.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../utils.dart';

class SessionsViewModel extends BaseViewModel {
  final DialogService _dialogService = locator<DialogService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final FirestoreService _firestoreService =
      locator<FirestoreServiceInterface>();
  final AuthService _authService = locator<AuthServiceInterface>();
  final DatabaseService _databaseService = locator<DatabaseServiceInterface>();
  final NavigationService _navigationService = locator<NavigationService>();
  final LocalNotificationService _notificationService =
      locator<LocalNotificationServiceInterface>();
  final CloudMessagingService _messagingService =
      locator<CloudMessagingServiceInterface>();

  List<Session> sessions;
  List<DateTime> days;
  String trainerID;
  Client client;
  DateTime selectedDay;
  bool isUpdating = false;
  String loadingText = 'Fetching booking slots..';

  Future initialise(String day, int trainer) async {
    setBusy(true);

    client = await _authService.getCurrentUser();
    trainerID = client.trainers[trainer];
    await getSessions(day);

    setBusy(false);
  }

  Future getSessions(String day, {int pos = 0}) async {
    setBusy(true);
    generateDaysOfTheWeek();
    selectedDay = days[pos];
    sessions = await _firestoreService.getSessions(trainerID, pos);

    setBusy(false);
    notifyListeners();
  }

  Future changeDay(DateTime date) async {
    setBusy(true);

    int index = days.indexOf(date);
    selectedDay = days[index];

    sessions = await _firestoreService.getSessions(trainerID, index + 1);

    setBusy(false);
    notifyListeners();
  }

  Future<bool> scheduleNotification(String date, String sessionID) async {
    int id = await _databaseService.scheduleNotification(sessionID);
    bool success = await _notificationService.scheduleNotification(date, id);
    return success;
  }

  Future cancelNotification(String sessionID) async {
    Notification notification =
        await _databaseService.getNotification(sessionID);

    await _notificationService.cancelNotification(notification.notificationID);
  }

  void setIsUpdating(bool isUpdating) {
    this.isUpdating = isUpdating;
    notifyListeners();
  }

  bool sessionHasPassed(String time) {
    DateTime startTime = DateTime.parse(time);
    DateTime now = DateTime.now();
    return startTime.isBefore(now);
  }

  Future requestUpdateSession(Session session) async {
    if (sessionHasPassed(session.startTime))
      return _snackbarService.showSnackbar(
          message: 'This session has already passed');

    int dayIndex = days.indexOf(selectedDay) + 1;
    String day = getFullWeekday(dayIndex);
    DateTime startTime = DateTime.parse(session.startTime);
    String sessionTime = formatTime(startTime);

    var response = await _dialogService.showCustomDialog(
        variant: DialogType.bookSlotDialog,
        title: session.client == 'Available' ? 'Book slot' : 'Cancel slot',
        customData: dialogCustomData({'day': day, 'time': sessionTime}));

    bool sessionUpdated = response.confirmed;

    if (sessionUpdated) {
      setIsUpdating(true);

      Purchase currentPackage =
          await _firestoreService.getPurchase(trainerID, client.clientID);

      //Check if user is attempting to book or cancel booking
      if (session.client == 'Available') {
        //Check if user has remaining sessions left on current package
        if (currentPackage.sessionsCompleted == currentPackage.sessions) {
          _snackbarService.showSnackbar(message: 'No sessions left on package');
          setIsUpdating(false);
          return;
        }

        //schedule notification
        await scheduleNotification(session.startTime, session.sessionID);

        session.client = client.name;
        session.clientID = client.clientID;
        session.clientToken = await _messagingService.getFCMToken();
        currentPackage.sessionsCompleted++;
        await _firestoreService.updatePurchase(
            trainerID, client.clientID, currentPackage);
      } else {
        await cancelNotification(session.sessionID);

        session.client = 'Available';
        session.clientID = '-';
        session.clientToken = '';

        currentPackage.sessionsCompleted = currentPackage.sessionsCompleted > 0
            ? currentPackage.sessionsCompleted - 1
            : 0;

        await _firestoreService.updatePurchase(
            trainerID, client.clientID, currentPackage);
      }

      bool success =
          await _firestoreService.updateSession(trainerID, dayIndex, session);

      if (success) {
        sessions.forEach((element) {
          if (element.sessionID == session.sessionID) {
            element = session;
          }
        });

        String day = formatDay(session.startTime);
        String time = formatTime(DateTime.parse(session.startTime));
        String name = client.name;

        String trainerToken =
            (await _firestoreService.getTrainer(trainerID)).myFCMToken;

        if (session.client == 'Available')
          _messagingService.trainerCancelledBookingAlert(
              name: name, day: day, time: time, trainerToken: trainerToken);
        else
          _messagingService.trainerNewBookingAlert(
              name: name, day: day, time: time, trainerToken: trainerToken);
      }

      notifyListeners();
      showResultSnackbar(success);
      Future.delayed(Duration(seconds: 2), () {
        if (success) _navigationService.back();
      });

      setIsUpdating(false);
    }
  }

  void showResultSnackbar(bool success) {
    _snackbarService.showSnackbar(
        message: success
            ? 'Session successfully updated'
            : 'Session could not be updated',
        duration: Duration(seconds: 2));
  }

  void generateDaysOfTheWeek() {
    DateTime refPoint = DateTime.now();
    days = List<DateTime>();

    for (int i = 0; i < refPoint.weekday; i++)
      days.add(refPoint.subtract(Duration(days: i)));

    for (int i = 7 - refPoint.weekday; i > 0; i--)
      days.add(refPoint.add(Duration(days: i)));

    days.sort((a, b) {
      if (a.weekday > b.weekday) {
        return 1;
      } else if (a.weekday < b.weekday) {
        return -1;
      } else
        return 0;
    });
  }
}
