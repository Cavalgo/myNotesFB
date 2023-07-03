import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    home: const HomePage(),
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
/*
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
*/

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _myController;
  @override
  void initState() {
    _myController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return CounterBloc();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Testing Bloc'),
        ),
        body: BlocConsumer<CounterBloc, CounterState>(
          listener: (context, state) {
            _myController.clear();
          },
          builder: (context, state) {
            final invalidValue =
                (state is CounterStateInvalidValue) ? state.invalidValue : '';
            return Column(
              children: <Widget>[
                Text("Current value => ${state.value}"),
                Visibility(
                  visible: state is CounterStateInvalidValue,
                  child: Text("Invalid input: $invalidValue"),
                ),
                TextField(
                  controller: _myController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Enter Text',
                    hintText: "Type the value",
                    prefixIcon: Icon(Icons.text_fields),
                    border: OutlineInputBorder(),
                    filled: true,
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        CounterBloc myCounter = context.read<CounterBloc>();
                        myCounter.add(IncrementEvent(_myController.text));
                      },
                      child: const Text('Increase'),
                    ),
                    const SizedBox(width: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        CounterBloc myCounter = context.read<CounterBloc>();
                        myCounter.add(DecrementEvent(_myController.text));
                      },
                      child: const Text('Decrease'),
                    ),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

//Basic initial state
abstract class CounterState {
  final int value;
  const CounterState(this.value);
}

//state 1
class CounterStateValid extends CounterState {
  CounterStateValid(super.value);
}

//state 2
class CounterStateInvalidValue extends CounterState {
  final String invalidValue;
  CounterStateInvalidValue({
    required this.invalidValue,
    required int previousValue,
  }) : super(previousValue);
}

//Event abstract
abstract class CounterEvent {
  final String value;

  CounterEvent(this.value);
}

//Event 1
class IncrementEvent extends CounterEvent {
  IncrementEvent(super.value);
}

//Event 2
class DecrementEvent extends CounterEvent {
  DecrementEvent(super.value);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  //Super is for our initial state
  //Every Bloc needs to have an initial state
  CounterBloc() : super(CounterStateValid(0)) {
    on<IncrementEvent>((event, emit) {
      int? integer = int.tryParse(event.value);
      if (integer == null) {
        emit(CounterStateInvalidValue(
          invalidValue: event.value,
          previousValue: super.state.value,
        ));
      } else {
        int newState = integer + super.state.value;
        emit(CounterStateValid(newState));
      }
    });
    on<DecrementEvent>((event, emit) {
      int? integer = int.tryParse(event.value);
      if (integer == null) {
        emit(CounterStateInvalidValue(
            invalidValue: event.value, previousValue: super.state.value));
      } else {
        int newState = super.state.value - (integer.abs());
        emit(CounterStateValid(newState));
      }
    });
  }
}
