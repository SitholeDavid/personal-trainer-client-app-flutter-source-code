import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_trainer_client/core/constants/working_days.dart';
import 'package:personal_trainer_client/core/models/purchases.dart';
import 'package:personal_trainer_client/core/models/trainer.dart';
import 'package:personal_trainer_client/core/models/session.dart';
import 'package:personal_trainer_client/core/models/package.dart';
import 'package:personal_trainer_client/core/models/client.dart';
import 'package:personal_trainer_client/core/services/firestore_service/firestore_service_interface.dart';
import 'package:personal_trainer_client/core/utils.dart';

class FirestoreService extends FirestoreServiceInterface {
  CollectionReference _trainersRef = Firestore.instance.collection('trainers');
  CollectionReference _packagesRef = Firestore.instance.collection('packages');
  CollectionReference _clientsRef = Firestore.instance.collection('clients');
  CollectionReference _sessionsRef = Firestore.instance.collection('sessions');
  CollectionReference _purchasesRef =
      Firestore.instance.collection('purchases');

  @override
  Future<Client> getClient(String clientID) async {
    try {
      var clientJson = await _clientsRef.document(clientID).get();

      if (clientJson == null) return null;

      return Client.fromMap(clientJson.data, clientID);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Package>> getPackages(String trainerID) async {
    try {
      var packagesJson = await _packagesRef
          .document(trainerID)
          .collection('my-packages')
          .getDocuments();

      if (packagesJson == null) return <Package>[];

      return packagesJson.documents
          .map(
              (snapshot) => Package.fromMap(snapshot.data, snapshot.documentID))
          .toList();
    } catch (e) {
      return <Package>[];
    }
  }

  @override
  Future<List<Session>> getSessions(String trainerID, int weekday) async {
    try {
      var sessionCollectionID = workingDays[weekday];
      var sessionsJson = await _sessionsRef
          .document(trainerID)
          .collection(sessionCollectionID)
          .getDocuments();

      if (sessionsJson == null) return <Session>[];

      var sessions = sessionsJson.documents
          .map(
              (snapshot) => Session.fromMap(snapshot.data, snapshot.documentID))
          .toList();

      var sortedSessions = sortSessions(sessions);
      return sortedSessions;
    } catch (e) {
      return <Session>[];
    }
  }

  @override
  Future<Trainer> getTrainer(String trainerID) async {
    try {
      var trainerJson = await _trainersRef.document(trainerID).get();
      var trainer = Trainer.fromMap(trainerJson.data, trainerID);
      return trainer;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateClient(Client updatedClient) async {
    try {
      await _clientsRef
          .document(updatedClient.clientID)
          .updateData(updatedClient.toJson());

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateSession(
      String trainerID, int weekday, Session session) async {
    try {
      var sessionCollectionID = workingDays[weekday];
      await _sessionsRef
          .document(trainerID)
          .collection(sessionCollectionID)
          .document(session.sessionID)
          .updateData(session.toJson());

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> createPurchase(
      String trainerID, String clientID, Purchase purchase) async {
    try {
      await _purchasesRef
          .document(trainerID)
          .collection('client-purchases')
          .document(clientID)
          .setData(purchase.toJson());

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Purchase> getPurchase(String trainerID, String clientID) async {
    try {
      var jsonData = await _purchasesRef
          .document(trainerID)
          .collection('client-purchases')
          .document(clientID)
          .get();

      Purchase purchase = Purchase.fromMap(jsonData.data, jsonData.documentID);
      return purchase;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updatePurchase(
      String trainerID, String clientID, Purchase purchase) async {
    try {
      await _purchasesRef
          .document(trainerID)
          .collection('client-purchases')
          .document(clientID)
          .updateData(purchase.toJson());

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Package> getPackage(String trainerID, String packageID) async {
    try {
      var packageData = await _packagesRef
          .document(trainerID)
          .collection('my-packages')
          .document(packageID)
          .get();

      return Package.fromMap(packageData.data, packageData.documentID);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> cancelPurchase(String trainerID, String clientID) async {
    try {
      await _purchasesRef
          .document(trainerID)
          .collection('client-purchases')
          .document(clientID)
          .delete();

      return true;
    } catch (e) {
      return false;
    }
  }
}
