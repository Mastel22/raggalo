import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Firebase;
import 'package:raggalo/models/breed.dart';
import 'package:raggalo/models/feedstuff.dart';
import 'package:raggalo/models/reserved_breed.dart';
import 'package:raggalo/models/reserved_feedstuff.dart';
import 'package:raggalo/models/user.dart';
import 'package:raggalo/models/vet_request.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class FirebaseService {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<User> signin(String email, String password) async {
    var credential = await Firebase.FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    if (credential.user != null) {
      var documentSnapshot = await firestore
          .collection("users")
          .doc(
            credential.user.uid,
          )
          .get();
      if (documentSnapshot.exists) {
        return User.fromJson(documentSnapshot.data());
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<User> signup(
    String email,
    String password,
    String names,
    String role,
    String id,
    String bio,
    String fee,
    String followupFee,
  ) async {
    var credential = await Firebase.FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    User user;
    if (credential.user != null) {
      user = User(
        id,
        credential.user.uid,
        names,
        role,
        email,
        null,
        null,
        bio,
        double.parse(fee),
        double.parse(followupFee),
      );
      await firestore
          .collection("users")
          .doc(credential.user.uid)
          .set(user.toJson());
    }
    return user;
  }

  static void signOut() {
    Firebase.FirebaseAuth.instance.signOut();
  }

  static Future<void> updateUser(
    String phone,
    String names,
    String id,
    String bio,
    String uid,
  ) async {
    await firestore
        .collection("users")
        .doc(uid)
        .update({"names": names, "phone": phone, "id": id, "bio": bio});
  }

  static Future<void> updateUserRole(String uid, String role) async {
    await firestore.collection("users").doc(uid).update({"role": role});
  }

  static Future<void> updateUserImage(String uid, String image) async {
    await firestore.collection("users").doc(uid).update({"image": image});
  }

  static Future<User> getUserDetails() async {
    Firebase.User currentUser = Firebase.FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return null;
    }

    DocumentSnapshot documentSnapshot =
        await firestore.collection("users").doc(currentUser.uid).get();

    if (!documentSnapshot.exists) {
      return null;
    }

    return User.fromJson(documentSnapshot.data());
  }

  static Future<void> addFeedstuff(
    String name,
    String expDate,
    String image,
    String ingredients,
    double quantity,
    String animal,
    String location,
  ) async {
    var id = firestore.collection("feedstuffs").doc().id;
    var feedstuff = Feedstuff(
        id, name, expDate, image, ingredients, quantity, animal, location);
    await firestore.collection("feedstuffs").doc(id).set(feedstuff.toJson());
  }

  static Future<void> addBreed(
    String name,
    String animal,
    String image,
    String location,
  ) async {
    var id = firestore.collection("breeds").doc().id;
    var breed = Breed(id, name, animal, image, location);
    await firestore.collection("breeds").doc(id).set(breed.toJson());
  }

  static Future<void> reserveFeedstuff(
    String idFeedstuff,
    String name,
    String image,
    double quantity,
    String animal,
    String uid,
    String createAt,
  ) async {
    var id = firestore.collection("reserved_feedstuffs").doc().id;
    var reseveredFeedstuff = ReservedFeedstuff(
        id, idFeedstuff, name, image, quantity, animal, uid, createAt);
    await firestore
        .collection("reserved_feedstuffs")
        .doc(id)
        .set(reseveredFeedstuff.toJson());
    await firestore
        .collection("feedstuffs")
        .doc(idFeedstuff)
        .update({"quantity": FieldValue.increment(-quantity)});
    var twilioFlutter = TwilioFlutter(
      accountSid: 'AC97afb3c1826f66bd6e5e47ba269dc30f',
      authToken: 'ec83e59c81eac683c77dc7594c8b4630',
      twilioNumber: '+13177903156',
    );
    await twilioFlutter.sendSMS(
      toNumber: "+250789390266",
      messageBody: "There a new client request",
    );
  }

  static Future<void> requestVisit(
    String requesertUid,
    String vetUid,
    String reason,
    bool withFollowup,
    String createAt,
  ) async {
    var id = firestore.collection("vet_requests").doc().id;
    var requestVisit = VetRequest(
      id,
      requesertUid,
      vetUid,
      reason,
      withFollowup,
      "Pending",
      createAt,
    );
    await firestore
        .collection("vet_requests")
        .doc(id)
        .set(requestVisit.toJson());
    await firestore
        .collection("users")
        .doc(vetUid)
        .update({"requests": FieldValue.increment(1)});
    var twilioFlutter = TwilioFlutter(
      accountSid: 'AC97afb3c1826f66bd6e5e47ba269dc30f',
      authToken: 'ec83e59c81eac683c77dc7594c8b4630',
      twilioNumber: '+13177903156',
    );
    await twilioFlutter.sendSMS(
      toNumber: "+250789390266",
      messageBody: "There a new client request",
    );
  }

  static Future<void> reserveBreed(
    String name,
    String image,
    String animal,
    String uid,
    String createAt,
  ) async {
    var id = firestore.collection("reserved_breeds").doc().id;
    var reseveredBreeds = ReservedBreed(
      id,
      name,
      image,
      animal,
      uid,
      createAt,
    );
    await firestore
        .collection("reserved_breeds")
        .doc(id)
        .set(reseveredBreeds.toJson());
    var twilioFlutter = TwilioFlutter(
      accountSid: 'AC97afb3c1826f66bd6e5e47ba269dc30f',
      authToken: 'ec83e59c81eac683c77dc7594c8b4630',
      twilioNumber: '+13177903156',
    );
    await twilioFlutter.sendSMS(
      toNumber: "+250789390266",
      messageBody: "There a new client request",
    );
  }

  static Future<void> updateRequestStatus(
    String requestId,
    String value,
  ) async {
    await firestore
        .collection("vet_requests")
        .doc(requestId)
        .update({"status": value});
  }
}
