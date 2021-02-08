import 'package:flutter/cupertino.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:personal_trainer_client/core/models/client.dart';
import 'package:personal_trainer_client/core/models/payment.dart';
import 'package:personal_trainer_client/core/services/auth_service/auth_service.dart';
import 'package:personal_trainer_client/core/services/auth_service/auth_service_interface.dart';
import 'package:personal_trainer_client/core/services/payment_service/payment_service.dart';
import 'package:personal_trainer_client/core/services/payment_service/payment_service_interface.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../locator.dart';

class PaymentViewModel extends BaseViewModel {
  final AuthService _authService = locator<AuthServiceInterface>();
  final PaymentService _paymentService = locator<PaymentServiceInterface>();
  final NavigationService _navigationService = locator<NavigationService>();

  BuildContext context;
  String loadingText = 'Initializing payment...';
  double totalCost = 0;

  void initialise(double cost, BuildContext context) async {
    totalCost = cost;

    this.context = context;
    await _paymentService.initialise();
    await makePayment(context);
  }

  Charge createCharge(Payment payment, String email, String accessCode) {
    Charge charge = Charge()
      ..amount = payment.amount.round() * 100
      ..accessCode = accessCode
      ..currency = 'ZAR'
      ..email = email;

    return charge;
  }

  Future<bool> verifyPayment(String reference) async {
    loadingText = 'Veryfing payment...';
    notifyListeners();
    bool verified = await _paymentService.verifyTransaction(reference);
    return verified;
  }

  Future makePayment(BuildContext context) async {
    Client client = await _authService.getCurrentUser();
    Payment payment = Payment(clientID: client.clientID, amount: totalCost);

    String result = await _paymentService.startTransaction(
        client.email, payment.amount.round());

    String accessCode = result.split(' ').first;
    String reference = result.split(' ').last;
    Charge charge = createCharge(payment, client.email, accessCode);

    final response = await PaystackPlugin.checkout(context, charge: charge);

    if (response.status == false)
      _navigationService.back(result: false);
    else {
      bool verified = await verifyPayment(reference);
      _navigationService.back(result: response.status && verified);
    }
  }
}
