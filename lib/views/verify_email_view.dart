import 'package:flutter/material.dart';
import 'dart:developer' as developer_tools show log;

import 'package:flutter_first_project/constants/routes.dart';
import 'package:flutter_first_project/services/auth/auth_service.dart';

class EmailVerificationView extends StatefulWidget {
  const EmailVerificationView({super.key});

  @override
  State<EmailVerificationView> createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends State<EmailVerificationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Email verification")),
      body: Center(
        child: Column(
          children: [
            const Text("We've sent you a verification email"),
            const Text("If you haven't received it, press the button below"),
            TextButton(
                onPressed: () async {
                  await AuthService.firebase().sendEmailVerification();
                },
                child: const Text("Send Email Verification")),
            TextButton(
                onPressed: (() {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(registerRoute, (route) => false);
                }),
                child: const Text("Login in other account")),
            TextButton(
              onPressed: () {
                AuthService.firebase().logOut();
                if (!mounted) return;
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
              child: const Text("Restart"),
            )
          ],
        ),
      ),
    );
  }
}
