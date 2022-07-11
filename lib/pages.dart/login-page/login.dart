import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learningfirebase/utils/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneNumController = TextEditingController();

  void sendOTP() async {
    String phoneNum = "+977${phoneNumController.text.trim()}";
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNum,
          verificationCompleted: (credentials) {},
          verificationFailed: (ex) {},
          codeSent: (verificationId, resendToken) {
            log(verificationId.toString());
            log(resendToken.toString());
            log("OTP Send Successfully");

            Navigator.pushNamed(context, "/verify",
                arguments: {"verificationId": verificationId});
          },
          codeAutoRetrievalTimeout: (verificationId) {});
    } on FirebaseAuthException catch (ex) {
      log(ex.code.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text(
            //   "Email",
            //   style: TextStyle(
            //       fontSize: 14,
            //       fontWeight: FontWeight.normal,
            //       color: Colors.white.withOpacity(.9)),
            // ),
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    offset: const Offset(12, 26),
                    blurRadius: 50,
                    spreadRadius: 0,
                    color: Colors.grey.withOpacity(.1)),
              ]),
              child: TextField(
                controller: phoneNumController,
                maxLength: 10,
                onChanged: (value) {
                  //Do something wi
                },
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 20, color: Colors.black),
                decoration: InputDecoration(
                  // prefixIcon: Icon(Icons.email),
                  counterText: "",
                  filled: true,
                  fillColor: accentColor,
                  hintText: 'Phone Number',
                  hintStyle: TextStyle(color: Colors.grey.withOpacity(.75)),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 20.0),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: secondaryColor, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: errorColor, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            DecoratedBox(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                        colors: [primaryColor, secondaryColor])),
                child: ElevatedButton(
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      alignment: Alignment.center,
                      padding: MaterialStateProperty.all(const EdgeInsets.only(
                          right: 75, left: 75, top: 15, bottom: 15)),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      )),
                  onPressed: () {
                    sendOTP();
                  },
                  child: const Text(
                    "Verify",
                    style: TextStyle(color: accentColor, fontSize: 20),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
