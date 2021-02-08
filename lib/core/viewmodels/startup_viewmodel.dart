import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:personal_trainer_client/core/services/auth_service/auth_service.dart';
import 'package:personal_trainer_client/core/services/auth_service/auth_service_interface.dart';
import 'package:personal_trainer_client/core/services/database_service/database_service.dart';
import 'package:personal_trainer_client/core/services/database_service/database_service_interface.dart';
import 'package:personal_trainer_client/core/services/local_notifications_service/local_notification_service.dart';
import 'package:personal_trainer_client/core/services/local_notifications_service/local_notification_service_interface.dart';
import 'package:personal_trainer_client/locator.dart';
import 'package:personal_trainer_client/ui/constants/routes.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final AuthService _authService = locator<AuthServiceInterface>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DatabaseService _databaseService = locator<DatabaseServiceInterface>();
  final LocalNotificationService _localNotificationService =
      locator<LocalNotificationServiceInterface>();

  Future initialise() async {
    await _localNotificationService.initialise();
    await _databaseService.initialise();
    await _databaseService.deleteBookings();

    bool loggedIn = await _authService.isUserLoggedIn();

    if (loggedIn)
      _navigationService.navigateTo(DashboardViewRoute);
    else
      _navigationService.navigateTo(SignInViewRoute);
  }
}
