import 'package:personal_trainer_client/core/models/client.dart';
import 'package:personal_trainer_client/core/models/package.dart';
import 'package:personal_trainer_client/core/models/purchases.dart';
import 'package:personal_trainer_client/core/services/auth_service/auth_service.dart';
import 'package:personal_trainer_client/core/services/auth_service/auth_service_interface.dart';
import 'package:personal_trainer_client/core/services/firestore_service/firestore_service.dart';
import 'package:personal_trainer_client/core/services/firestore_service/firestore_service_interface.dart';
import 'package:personal_trainer_client/locator.dart';
import 'package:personal_trainer_client/ui/constants/routes.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PurchasesViewModel extends BaseViewModel {
  final FirestoreService _firestoreService =
      locator<FirestoreServiceInterface>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final AuthService _authService = locator<AuthServiceInterface>();
  final NavigationService _navigationService = locator<NavigationService>();

  int trainerIndex;
  Client client;
  List<Package> packages;

  Future initialise(int trainer) async {
    setBusy(true);

    trainerIndex = trainer;
    client = await _authService.getCurrentUser();
    packages =
        await _firestoreService.getPackages(client.trainers[trainerIndex]);

    notifyListeners();
    setBusy(false);
  }

  Future makePurchase(Package selectedPackage) async {
    setBusy(true);

    DateTime expiryDate = DateTime.now();
    Duration packagePeriod = getPeriod(selectedPackage.expiryDate);
    expiryDate = expiryDate.add(packagePeriod);

    Purchase currentPackage = await _firestoreService.getPurchase(
            client.trainers[trainerIndex], client.clientID) ??
        Purchase(
            sessions: 0, sessionsCompleted: 0, packageID: '', expiryDate: '');

    if ((currentPackage.sessions - currentPackage.sessionsCompleted > 0)) {
      setBusy(false);
      return _snackbarService.showSnackbar(
          message:
              'You still have remaining sessions on your package. Please finish these sessions before selecting a different package');
    } else if (currentPackage.expiryDate.isNotEmpty) {
      DateTime expired = DateTime.parse(currentPackage.expiryDate);

      if (!expired.isBefore(DateTime.now())) {
        setBusy(false);
        return _snackbarService.showSnackbar(
            message:
                'You already have an active package. Please try again when this package has expired or is depleted');
      }
    }

    Purchase purchase = Purchase(
        sessions: selectedPackage.noSessions,
        sessionsCompleted: 0,
        packageID: selectedPackage.packageID,
        expiryDate: expiryDate.toString());

    bool result = (await _navigationService.navigateTo(PaymentViewRoute,
        arguments: selectedPackage.price)) as bool;

    if (result == true) {
      bool success = await _firestoreService.createPurchase(
          client.trainers[trainerIndex], client.clientID, purchase);

      showResultSnackbar(success);
    } else {
      showResultSnackbar(false);
    }

    Future.delayed(Duration(seconds: 2), () => _navigationService.back());
    setBusy(false);
  }

  Duration getPeriod(String expiryPeriod) {
    int count = int.parse(expiryPeriod.split(' ').first);
    String period = expiryPeriod.split(' ').last;

    switch (period) {
      case 'days':
        return Duration(days: count);
      case 'weeks':
        return Duration(days: count * 7);
        break;
      case 'months':
        return Duration(days: count * 30);
      default:
        return Duration();
    }
  }

  void showResultSnackbar(bool success) {
    _snackbarService.showSnackbar(
        message: success ? 'Payment successful' : 'Payment failed',
        duration: Duration(seconds: 2));
  }

  void navigateToPrevView() {
    _navigationService.back();
  }
}
