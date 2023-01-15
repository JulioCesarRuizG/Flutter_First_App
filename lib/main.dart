import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_first_project/constants/routes.dart';
import 'package:flutter_first_project/views/login_view.dart';
import 'package:flutter_first_project/views/register_view.dart';
import 'dart:developer' as developer_tools show log;

import 'firebase_options.dart';
import 'views/verify_email_view.dart';

/*
Future<int> futureImplement() {
  return Future.delayed(const Duration(seconds: 3), () {
    return 10;
  });
}

void futureTest() async {
  int foo = await futureImplement();
  print(foo);
}

Stream<int> streamImplement() {
  //return Stream.value(20);
  return Stream.periodic(const Duration(seconds: 4), (val) {
    return 15;
  });
}

void streamTest() async {
  await for (final foo in streamImplement()) {
    print(foo);
  }
}

Iterable<int> generatorImplement() sync* {
  // calcylates values synchronously, async* calculates them asynchronously (it needs to be returned inside a Stream)
  yield 1;
  yield 2;
  yield 3;
}

void generatorTest() {
  for (final value in generatorImplement()) {
    print(value);
  }
}

class GenericImplement<A, B> {
  final A val1;
  final B val2;

  GenericImplement(this.val1, this.val2);
}

void genericTest() {
  GenericImplement gen = GenericImplement("algo", 2);
  print("$gen.val1 $gen.val2");
}

void nullProbe(String? fn, String? mn, String? ln) {
  final String? name = fn;
  final String? middlename = mn;
  final String? lastname = ln;

  final String firstPicked = name ?? middlename ?? lastname ?? "Default";

  print(firstPicked);

  String? probe = fn;
  probe ??=
      mn; // if probe is null and mn is not null, then it assigns mn to probe
}
*/
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      notesRoute: (context) => const NotesView(),
      emailVerificationRoute: (context) => const EmailVerificationView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            var user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              final emailVerified = user.emailVerified;
              if (emailVerified) {
                return const NotesView();
              } else {
                return const EmailVerificationView();
              }
            } else {
              return const LoginView();
            }
          default:
            return Scaffold(
              appBar: AppBar(title: const Text("Login")),
              body: const Center(child: CircularProgressIndicator()),
            );
        }
      },
    );
  }
}

enum MenuAction { logout }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogOut = await showLogOutDialog(context);
                  if (shouldLogOut) {
                    await FirebaseAuth.instance.signOut();
                    if (!mounted) return;
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (route) => false,
                    );
                  }
                  break;
                default:
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                    value: MenuAction.logout, child: Text("Log Out"))
              ];
            },
          )
        ],
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Sign Out"),
        content: const Text("Are you sure you want to Sign Out?"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Log Out"))
        ],
      );
    },
  ).then((value) => value ?? false);
}
