import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/auth_manager/auth_service.dart';
import 'package:mynotes/views/notes_view.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';
import 'package:mynotes/constants/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const ViewStarter(),
    routes: {
      myRoutes.loginView: (context) => const LogInView(),
      myRoutes.registerView: (context) => const RegisterView(),
      myRoutes.verifyEmail: (context) => const VerifyEmailView(),
      myRoutes.notesView: (context) => const NotesView(),
    },
  ));
}

class ViewStarter extends StatefulWidget {
  const ViewStarter({super.key});

  @override
  State<ViewStarter> createState() => _ViewStarterState();
}

class _ViewStarterState extends State<ViewStarter> {
  AuthService myAuthService = AuthService.firebase();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: myAuthService.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final User? currentUser = FirebaseAuth.instance.currentUser;
          //si es null o false irá a LogIn View
          if (currentUser?.emailVerified ?? false) {
            return const NotesView();
          } else {
            return const LogInView();
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          return const Text('Error loading firebase');
        }
      },
    );
  }
}

/*
class HomePage extends StatelessWidget {
  HomePage({super.key});
  AuthService myAuthService = AuthService.firebase();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: myAuthService.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final User? currentUser = FirebaseAuth.instance.currentUser;
          //si es null o false irá a LogIn View
          if (currentUser?.emailVerified ?? false) {
            return const NotesView();
          } else {
            return const LogInView();
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          return const Text('Error loading firebase');
        }
      },
    );
  }
}
**/