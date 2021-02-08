abstract class CloudMessagingServiceInterface {
  Future<String> getFCMToken();

  Future trainerNewBookingAlert(
      {String trainerToken, String name, String day, String time});
  Future trainerCancelledBookingAlert(
      {String trainerToken, String name, String day, String time});
}
