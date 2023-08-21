import 'package:flutter/material.dart';
import 'package:schedulex/pages/auth/login.dart';
import 'package:schedulex/pages/auth/register.dart';

class LoginRegister extends StatefulWidget {
  const LoginRegister({super.key});

  @override
  State<LoginRegister> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  bool isloginPage = true;

  void togglePages() {
    setState(() {
      isloginPage = !isloginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isloginPage) {
      return LoginPage(
        onTap: togglePages,
      );
    } else {
      return RegisterPage(
        onTap: togglePages,
      );
    }
  }
}
