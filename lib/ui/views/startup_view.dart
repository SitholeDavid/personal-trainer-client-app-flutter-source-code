import 'package:flutter/material.dart';
import 'package:personal_trainer_client/core/viewmodels/startup_viewmodel.dart';
import 'package:stacked/stacked.dart';

class StartupView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartupViewModel>.reactive(
      builder: (context, model, child) => Scaffold(),
      viewModelBuilder: () => StartupViewModel(),
      onModelReady: (model) => model.initialise(),
    );
  }
}
