abstract class PaymentServiceInterface {
  Future initialise();
  Future<String> startTransaction(String email, int amount);
  Future<bool> verifyTransaction(String reference);
}
