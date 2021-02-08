import 'package:personal_trainer_client/core/models/client.dart';
import 'package:personal_trainer_client/core/models/purchases.dart';
import 'package:personal_trainer_client/core/services/auth_service/auth_service.dart';
import 'package:personal_trainer_client/core/services/auth_service/auth_service_interface.dart';
import 'package:personal_trainer_client/core/services/database_service/database_service.dart';
import 'package:personal_trainer_client/core/services/database_service/database_service_interface.dart';
import 'package:personal_trainer_client/core/services/firestore_service/firestore_service.dart';
import 'package:personal_trainer_client/core/services/firestore_service/firestore_service_interface.dart';
import 'package:personal_trainer_client/core/utils.dart';
import 'package:personal_trainer_client/locator.dart';
import 'package:personal_trainer_client/ui/constants/routes.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DashboardViewModel extends BaseViewModel {
  final AuthService _authService = locator<AuthServiceInterface>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DatabaseService _databaseService = locator<DatabaseServiceInterface>();
  final FirestoreService _firestoreService =
      locator<FirestoreServiceInterface>();

  String prevBooking = '-';
  String nextBooking = '-';
  Client myProfile;
  int sessionsLeft = 1;
  int sessionsCompleted = 0;
  double percentageSessionsCompleted = 0.0;
  int selectedTrainer = 0;

  Future initialise() async {
    setBusy(true);
    await getBookings();
    await updateStats();
    setBusy(false);
  }

  Future updateStats() async {
    myProfile = await _authService.getCurrentUser();
    Purchase currentPackage = (await _firestoreService.getPurchase(
            myProfile.trainers[selectedTrainer], myProfile.clientID)) ??
        Purchase(
            sessions: 0, sessionsCompleted: 0, packageID: '', expiryDate: '');

    sessionsCompleted = currentPackage.sessionsCompleted;
    sessionsLeft = currentPackage.sessions - sessionsCompleted;
    percentageSessionsCompleted = sessionsCompleted / (currentPackage.sessions);
  }

  Future getBookings() async {
    var bookings = await _databaseService.getBookings();
    var bookingsBefore = sessionsBefore(bookings);
    var bookingsAfer = sessionsAfter(bookings);

    if (bookingsBefore.isNotEmpty) {
      var booking = bookingsBefore.last;
      prevBooking = formatDay(booking.startTime);
    }

    if (bookingsAfer.isNotEmpty) {
      var booking = bookingsAfer.first;
      nextBooking = formatDay(booking.startTime);
    }
  }

  Future navigateToClientView() async {
    await _navigationService.navigateTo(ClientViewRoute, arguments: myProfile);
    await initialise();
  }

  void navigateToSessions() async {
    await _navigationService.navigateTo(SessionsViewRoute,
        arguments: selectedTrainer);
    await initialise();
  }

  void navigateToPurchases() async {
    await _navigationService.navigateTo(PurchasesViewRoute,
        arguments: selectedTrainer);
    await initialise();
  }

  void navigateToCurrentPlan() async {
    await _navigationService.navigateTo(CurrentPlanViewRoute, arguments: {
      'myProfile': myProfile,
      'selectedTrainer': selectedTrainer
    });
  }
}
