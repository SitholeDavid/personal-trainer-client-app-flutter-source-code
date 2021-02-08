import 'package:personal_trainer_client/core/services/auth_service/auth_service.dart';
import 'package:personal_trainer_client/core/services/auth_service/auth_service_interface.dart';
import 'package:personal_trainer_client/locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ForgotPasswordViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthServiceInterface>();
  SnackbarService _snackbarService = locator<SnackbarService>();

  void sendResetPasswordEmail(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
    } catch (e) {}

    _snackbarService.showSnackbar(
        message: 'Password reset email has been sent.',
        duration: Duration(seconds: 2));
  }
}
