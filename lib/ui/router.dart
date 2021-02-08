import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_trainer_client/core/models/client.dart';
import 'package:personal_trainer_client/ui/constants/routes.dart';
import 'package:personal_trainer_client/ui/views/client_view.dart';
import 'package:personal_trainer_client/ui/views/current_plan_view.dart';
import 'package:personal_trainer_client/ui/views/dashboard_view.dart';
import 'package:personal_trainer_client/ui/views/forgot_password_view.dart';
import 'package:personal_trainer_client/ui/views/payment_view.dart';
import 'package:personal_trainer_client/ui/views/purchases_view.dart';
import 'package:personal_trainer_client/ui/views/sessions_view.dart';
import 'package:personal_trainer_client/ui/views/sign_in_view.dart';
import 'package:personal_trainer_client/ui/views/startup_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case StartupViewRoute:
      return MaterialPageRoute(builder: (_) => StartupView());
    case SignInViewRoute:
      return MaterialPageRoute(builder: (_) => SignInView());
    case DashboardViewRoute:
      return MaterialPageRoute(builder: (_) => DashboardView());
    case ForgotPasswordViewRoute:
      return MaterialPageRoute(builder: (_) => ForgotPasswordView());
    case PurchasesViewRoute:
      var trainerIndex = settings.arguments as int;
      return MaterialPageRoute(
          builder: (_) => PurchasesView(trainerIndex: trainerIndex));
    case ClientViewRoute:
      var profile = settings.arguments as Client;
      return MaterialPageRoute(
          builder: (_) => ClientView(existingClient: profile));
    case SessionsViewRoute:
      var trainerIndex = settings.arguments as int;
      return MaterialPageRoute(
          builder: (_) => SessionsView(trainerIndex: trainerIndex));
    case PaymentViewRoute:
      double cost = settings.arguments as double;
      return MaterialPageRoute(
          builder: (_) => PaymentView(
                cost: cost,
              ));
    case CurrentPlanViewRoute:
      Map<String, dynamic> arguments =
          settings.arguments as Map<String, dynamic>;

      int selectedTrainer = arguments['selectedTrainer'] as int;
      Client myProfile = arguments['myProfile'] as Client;

      return MaterialPageRoute(
          builder: (_) => CurrentPlanView(
                myProfile: myProfile,
                selectedTrainer: selectedTrainer,
              ));

    default:
      return MaterialPageRoute(builder: (_) => null);
  }
}
