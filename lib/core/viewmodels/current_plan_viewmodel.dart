import 'package:personal_trainer_client/core/models/client.dart';
import 'package:personal_trainer_client/core/models/package.dart';
import 'package:personal_trainer_client/core/models/purchases.dart';
import 'package:personal_trainer_client/core/services/firestore_service/firestore_service.dart';
import 'package:personal_trainer_client/core/services/firestore_service/firestore_service_interface.dart';
import 'package:personal_trainer_client/locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CurrentPlanViewModel extends BaseViewModel {
  final FirestoreService _firestoreService =
      locator<FirestoreServiceInterface>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Client myProfile;
  int selectedTrainer;
  Purchase currentPlan;
  Package currentPackage;
  bool isCancelling = false;

  void setIsCancelling(bool status) {
    isCancelling = status;
    notifyListeners();
  }

  void initialise(Client myProfile, int selectedTrainer) async {
    setBusy(true);

    this.myProfile = myProfile;
    this.selectedTrainer = selectedTrainer;
    currentPlan = await _firestoreService.getPurchase(
        myProfile.trainers[selectedTrainer], myProfile.clientID);

    if (currentPlan == null) return setBusy(false);

    currentPackage = await _firestoreService.getPackage(
        myProfile.trainers[selectedTrainer], currentPlan.packageID);
    setBusy(false);
  }

  void cancelPlan() async {
    setIsCancelling(true);

    bool success = await _firestoreService.cancelPurchase(
        myProfile.trainers[selectedTrainer], myProfile.clientID);

    if (success) {
      _snackbarService.showSnackbar(message: 'Plan has been cancelled');
      Future.delayed(Duration(seconds: 2), () => _navigationService.back());
    } else {
      _snackbarService.showSnackbar(message: 'Could not cancel plan');
    }

    setIsCancelling(false);
  }
}
