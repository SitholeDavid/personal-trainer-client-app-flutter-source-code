import 'package:flutter/material.dart';
import 'package:personal_trainer_client/locator.dart';
import 'package:personal_trainer_client/ui/router.dart';
import 'package:personal_trainer_client/ui/shared/setup_dialog_ui.dart';
import 'package:personal_trainer_client/ui/views/startup_view.dart';
import 'package:stacked_services/stacked_services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  setupDialogUi();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateRoute: generateRoute,
      navigatorKey: locator<NavigationService>().navigatorKey,
      home: StartupView(),
    );
  }
}
