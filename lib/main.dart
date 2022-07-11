import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learningfirebase/firebase_options.dart';
import 'package:learningfirebase/routes/routes.dart';

FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
void main() async {
  //STEP 1
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //getAllDocumentsFromCollection();
  // getSpecificDocumentsFromCollection();
  // createNewDocuments();
  //createNewDocumentWithYourID();
  //updateDocument();
  //deleteDocument();
  runApp(MaterialApp(
    // home: const MyApp(),
    theme: ThemeData(fontFamily: GoogleFonts.lato().fontFamily),
    debugShowCheckedModeBanner: false,
    onGenerateRoute: Routes.onGenerateRoute,
    initialRoute:
        (FirebaseAuth.instance.currentUser == null) ? "/login" : "/home",
  ));
}

void getAllDocumentsFromCollection() async {
  // COLLECTION HAS DOCUMENT --> DOCUMENT HAS DATA
  QuerySnapshot querySnapshot =
      await _firebaseFirestore.collection("users").get();
  for (var doc in querySnapshot.docs) {
    log(doc.data().toString());
  }
}

void getSpecificDocumentsFromCollection() async {
  // COLLECTION HAS DOCUMENT --> DOCUMENT HAS DATA
  DocumentSnapshot documentSnapshot = await _firebaseFirestore
      .collection("users")
      .doc("LqxmOvsfsybaizavkxk2")
      .get();
  log(documentSnapshot.data().toString());
}

void createNewDocuments() async {
  Map<String, dynamic> newUserData = {
    "name": "NewUser",
    "email": "newuser@gmail.com"
  };

  await _firebaseFirestore.collection("users").add(newUserData);
  log("USER CREATED");
}

void createNewDocumentWithYourID() async {
  Map<String, dynamic> newUserData = {
    "name": "Unique",
    "email": "unique@gmail.com"
  };

  await _firebaseFirestore
      .collection("users")
      .doc("my-unique-id")
      .set(newUserData);
  log("WITH UNIQUE ID");
}

void updateDocument() async {
  //need ID OF document
  await _firebaseFirestore
      .collection("users")
      .doc("my-unique-id")
      .update({"email": "updatedemail@gmail.com"});
  log("DCOUMENT UPDATED");
}

void deleteDocument() async {
  //need ID OF document
  await _firebaseFirestore
      .collection("users")
      .doc("sdFy0hoUA6uvQ7OhQBjx")
      .delete();
  log("DCOUMENT DELETED");
}
