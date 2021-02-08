import 'package:personal_trainer_client/core/models/client.dart';
import 'package:personal_trainer_client/core/models/package.dart';
import 'package:personal_trainer_client/core/models/purchases.dart';
import 'package:personal_trainer_client/core/models/session.dart';
import 'package:personal_trainer_client/core/models/trainer.dart';

abstract class FirestoreServiceInterface {
  Future<Trainer> getTrainer(String trainerID);

  Future<Package> getPackage(String trainerID, String packageID);
  Future<List<Package>> getPackages(String trainerID);

  Future<List<Session>> getSessions(String trainerID, int weekday);
  Future<bool> updateSession(String trainerID, int weekday, Session session);

  Future<Client> getClient(String clientID);
  Future<bool> updateClient(Client updatedClient);

  Future<bool> createPurchase(
      String trainerID, String clientID, Purchase purchase);
  Future<Purchase> getPurchase(String trainerID, String clientID);
  Future<bool> cancelPurchase(String trainerID, String clientID);
  Future<bool> updatePurchase(
      String trainerID, String clientID, Purchase purchase);
}
