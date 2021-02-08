import 'package:flutter/material.dart';
import 'package:personal_trainer_client/core/viewmodels/payment_viewmodel.dart';
import 'package:personal_trainer_client/ui/widgets/loading_indicator.dart';
import 'package:stacked/stacked.dart';

class PaymentView extends StatelessWidget {
  final double cost;
  PaymentView({this.cost});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PaymentViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
              backgroundColor: Colors.white,
              body: loadingIndicatorLight(loadingText: model.loadingText),
            ),
        onModelReady: (model) => model.initialise(cost, context),
        viewModelBuilder: () => PaymentViewModel());
  }
}
