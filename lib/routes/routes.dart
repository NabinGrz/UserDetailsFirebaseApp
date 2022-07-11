import 'package:flutter/cupertino.dart';
import 'package:learningfirebase/pages.dart/homepage.dart';
import 'package:learningfirebase/pages.dart/login-page/login.dart';
import 'package:learningfirebase/pages.dart/login-page/verification.dart';

class Routes {
  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/login":
        return CupertinoPageRoute(
          builder: (context) {
            return const LoginPage();
          },
        );
      case "/verify":
        Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        return CupertinoPageRoute(
          builder: (context) {
            return VerificationPage(
              verificationId: arguments["verificationId"],
            );
          },
        );
      case "/home":
        return CupertinoPageRoute(
          builder: (context) {
            return const HomePage();
          },
        );
      default:
    }
    return null;
  }
}
