import 'package:personal_trainer_client/core/services/auth_service/auth_service_interface.dart';
import 'package:personal_trainer_client/locator.dart';
import 'package:personal_trainer_client/ui/constants/routes.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SignInViewModel extends BaseViewModel {
  final _authService = locator<AuthServiceInterface>();
  final _navService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();

  Future login(String email, String password) async {
    setBusy(true);
    var success = await _authService.signInWithEmail(email, password);
    setBusy(false);

    if (success) {
      //navigate to dashboard
      _navService.navigateTo(DashboardViewRoute);
    } else {
      //show failure snackbar
      _snackbarService.showSnackbar(
          message: 'Login failed. Please check your email and/or password.',
          duration: Duration(seconds: 3));
    }
  }

  void navigateToForgotPassword() {
    _navService.navigateTo(ForgotPasswordViewRoute);
  }
}
