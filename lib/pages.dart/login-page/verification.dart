import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learningfirebase/utils/colors.dart';

class VerificationPage extends StatefulWidget {
  final String verificationId;
  const VerificationPage({Key? key, required this.verificationId})
      : super(key: key);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController otpCodeController = TextEditingController();

  void verifyOTP() async {
    String otpCode = otpCodeController.text.trim();

    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId, smsCode: otpCode);
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
      if (userCredential.user != null) {
        Navigator.pushNamed(context, "/home");
        log("Logged In");
      } else {
        log("Something went wrong");
      }
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
                controller: otpCodeController,
                maxLength: 6,
                onChanged: (value) {
                  //Do something wi
                },
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 20, color: Colors.black),
                decoration: InputDecoration(
                  // prefixIcon: Icon(Icons.email),
                  labelStyle: const TextStyle(fontSize: 22),
                  // style
                  counterText: "",
                  filled: true,
                  fillColor: accentColor,
                  hintText: '6-Digit Code',
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
                    verifyOTP();
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(color: accentColor, fontSize: 20),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
