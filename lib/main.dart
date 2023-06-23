import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/views/notes/create_note_view.dart';
import 'package:mynotes/views/notes/notes_view.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes/update_note_view.dart';
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
      MyRoutes.loginView: (context) => const LogInView(),
      MyRoutes.registerView: (context) => const RegisterView(),
      MyRoutes.verifyEmail: (context) => const VerifyEmailView(),
      MyRoutes.notesView: (context) => const NotesView(),
      MyRoutes.createUpdateNoteView: (context) => const CreateNoteView(),
      MyRoutes.updateNoteView: ((context) => const UpdateNoteView()),
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
