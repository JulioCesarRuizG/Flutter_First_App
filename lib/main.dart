import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_first_project/views/login_view.dart';

import 'firebase_options.dart';

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
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              final emailVerified = user?.emailVerified ?? false;
              if (emailVerified) {
              } else {}

              return const Text("Done");
            default:
              return const Text("Loading");
          }
        },
      ),
    );
  }
}
