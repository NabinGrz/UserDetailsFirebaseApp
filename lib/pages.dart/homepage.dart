import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learningfirebase/utils/colors.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isUserAdded = false;
  File? image;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  double progressValue = 0;
  Future<String> uploadFile() async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child("ProfilePictures");
    final fullImageRef = imageRef.child("${const Uuid().v1()}-IMG");

    //UPLOADING FILE
    UploadTask uploadTask = fullImageRef.putFile(image!);

    uploadTask.snapshotEvents.listen((snapshot) {
      double percentage = snapshot.bytesTransferred / snapshot.totalBytes * 100;
      // log(percentage.toString());
      setState(() {
        progressValue = percentage;
      });
    });
    TaskSnapshot taskSnapshot = await uploadTask;

    //GETTING FILE URL/PATH TO PASS
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  void createUser() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    int age = int.parse(ageController.text.trim());
    //FOR CREATING DOWNLOADING URL

    Map<String, dynamic> user = {
      "name": name,
      "email": email,
      "age": age,
      "profilepic": await uploadFile() //GIVING PATH NAME
    };
    await _firebaseFirestore.collection("users").add(user);
    setState(() {
      isUserAdded = false;
      setState(() {
        progressValue = 0;
      });
      //image = null;
    });

    //
    // nameController.clear();
    // emailController.clear();
    // ageController.clear();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        "User Created Successfully!!",
      ),
      backgroundColor: Colors.green,
    ));
    // log("USER CREATED");
  }

  void deleteDocument(String docID) async {
    await _firebaseFirestore.collection("users").doc(docID).delete();
    // log("DELETED");
  }

  @override
  Widget build(BuildContext context) {
    print("BUILD WIDGET");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            StatefulBuilder(
                // stream: null,
                builder: (context, myState) {
              return CupertinoButton(
                onPressed: () async {
                  XFile? ximage = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (ximage != null) {
                    File? selectedImage = File(ximage.path);
                    myState(() {
                      image = selectedImage;
                    });
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          (image != null) ? FileImage(image!) : null,
                    ),
                    (progressValue != 0.0)
                        ? CircularProgressIndicator(
                            value: progressValue,
                            color: Colors.white,
                          )
                        : Container()
                  ],
                ),
              );
            }),
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
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: ageController,
                onChanged: (value) {},
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 20, color: Colors.black),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: accentColor,
                  hintText: 'Age',
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
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(200, 60),
                        elevation: 10,
                        primary: primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        if (nameController.text.trim().isNotEmpty &&
                            emailController.text.trim().isNotEmpty &&
                            ageController.text.trim().toString().isNotEmpty &&
                            image != null) {
                          myState(() {
                            isUserAdded = true;
                          });
                          createUser();
                        }
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
                    stream: _firebaseFirestore
                        .collection("users")
                        .orderBy("age", descending: false)

                        /// .where("age", isEqualTo: 18)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        List<QueryDocumentSnapshot<Object?>> userData =
                            snapshot.data!.docs;

                        return ListView.builder(
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          itemCount: userData.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(userData[index]["name"] +
                                  " (${userData[index]["age"]})"),
                              subtitle: Text(userData[index]["email"]),
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
                        // log("HAS NO DATA");
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
