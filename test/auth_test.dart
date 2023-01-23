import 'package:flutter_first_project/services/auth/auth_exceptions.dart';
import 'package:flutter_first_project/services/auth/auth_provider.dart';
import 'package:flutter_first_project/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group("MockAuthentication", () {
    final provider = MockAuthProvider();
    test(
      "Should not be initialized to begin with",
      () {
        expect(provider.isInitialized, false);
      },
    );

    test(
      "Cannot log out if not initialized",
      () {
        expect(
          provider.logOut(),
          throwsA(const TypeMatcher<NotInitializedException>()),
        );
      },
    );
    test(
      "Should be able to initialize",
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
    );

    test(
      "User should be null after initialization",
      () {
        expect(provider.currentUser, null);
      },
    );

    test(
      "Should be able to initialize in less than 2 seconds",
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test(
      "Create user should delegate to logIn function",
      () async {
        final badEmail = provider.createUser(
          email: "foo@bar.com",
          password: "123456",
        );

        expect(
          badEmail,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()),
        );

        final badPassword = provider.createUser(
          email: "1@1.com",
          password: "foobar",
        );

        expect(
          badPassword,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()),
        );

        final user = await provider.createUser(email: "foo", password: "bar");

        expect(provider.currentUser, user);
        expect(user.isEmailVerified, false);
      },
    );

    test(
      "Logged user should be able to get verified",
      () {
        provider.sendEmailVerification();
        final user = provider.currentUser;
        expect(user, isNotNull);
        expect(user!.isEmailVerified, true);
      },
    );

    test(
      "Should be able to log out and log in again",
      () async {
        await provider.logOut();
        expect(provider.currentUser, null);

        await provider.logIn(email: "1@1.com", password: "123456");
        expect(provider.currentUser, isNotNull);
      },
    );
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;

  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == "foo@bar.com") throw UserNotFoundAuthException();
    if (password == "foobar") throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotLoggedInAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotLoggedInAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}
