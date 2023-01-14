import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer_tools show log;

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
            const Text("Not verified"),
            TextButton(
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();
                },
                child: const Text("Send Email Verification")),
            TextButton(
                onPressed: (() {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("/login/", (route) => false);
                }),
                child: const Text("Login in other account")),
          ],
        ),
      ),
    );
  }
}
