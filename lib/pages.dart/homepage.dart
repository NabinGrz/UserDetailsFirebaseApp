import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learningfirebase/utils/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isUserAdded = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  void createUser() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();

    Map<String, dynamic> user = {"name": name, "email": email};
    await _firebaseFirestore.collection("users").add(user);
    setState(() {
      isUserAdded = false;
    });

    log("USER CREATED");
  }

  void deleteDocument(String docID) async {
    await _firebaseFirestore.collection("users").doc(docID).delete();
    log("DELETED");
  }

  @override
  Widget build(BuildContext context) {
    print("BUILD WIDGET");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: nameController,
                onChanged: (value) {},
                keyboardType: TextInputType.name,
                style: const TextStyle(fontSize: 20, color: Colors.black),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: accentColor,
                  hintText: 'Name',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: emailController,
                onChanged: (value) {},
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontSize: 20, color: Colors.black),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: accentColor,
                  hintText: 'Email Address',
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            DecoratedBox(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                        colors: [primaryColor, secondaryColor])),
                child: StatefulBuilder(
                  builder: (context, myState) {
                    return ElevatedButton(
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          alignment: Alignment.center,
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.only(
                                  right: 75, left: 75, top: 15, bottom: 15)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          )),
                      onPressed: () {
                        myState(() {
                          isUserAdded = true;
                        });
                        createUser();
                      },
                      child: isUserAdded
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Add User",
                              style:
                                  TextStyle(color: accentColor, fontSize: 20),
                            ),
                    );
                  },
                )),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
              child: const Divider(
                thickness: 1,
                color: Color.fromARGB(255, 145, 145, 145),
              ),
            ),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: _firebaseFirestore.collection("users").snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        List<QueryDocumentSnapshot<Object?>> userData =
                            snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: userData.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(userData[index]["name"].toString()),
                              subtitle:
                                  Text(userData[index]["email"].toString()),
                              trailing: IconButton(
                                  onPressed: () {
                                    deleteDocument(
                                        userData[index].reference.id);
                                  },
                                  icon: const Icon(
                                    CupertinoIcons.delete,
                                    size: 17,
                                    color: Colors.red,
                                  )),
                            );
                          },
                        );
                      } else {
                        log("HAS NO DATA");
                        return const Center(
                          child: Text(
                            "No Data Found",
                            style: TextStyle(fontSize: 22, color: Colors.grey),
                          ),
                        );
                      }
                    }))
          ],
        ),
      ),
    );
  }
}
