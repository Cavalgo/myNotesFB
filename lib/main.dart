import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/helpers/loading/loading_screen.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';
import 'package:mynotes/views/notes/create_note_view.dart';
import 'package:mynotes/views/notes/notes_view.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes/update_note_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';
import 'package:mynotes/constants/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AuthService myAuthService = AuthService.firebase();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: BlocProvider(
      create: (context) => AuthBloc(myAuthService),
      child: const HomePage(),
    ),
    routes: {
      MyRoutes.createNoteView: (context) => const CreateNoteView(),
      MyRoutes.updateNoteView: (context) => const UpdateNoteView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    bool loadingOn = false;
    return BlocConsumer<AuthBloc, AuthState>(
        builder: (BuildContext context, AuthState state) {
      if (state is AuthStateUnInitialized) {
        BlocProvider.of<AuthBloc>(context).add(const AuthEventInitialize());
        return const Center(child: CircularProgressIndicator());
      } else if (state is AuthStateLoggedIn) {
        return const NotesView();
      } else if (state is AuthStateLoggedOut) {
        return const LogInView();
      } else if (state is AuthStateNeedsVerification) {
        return const VerifyEmailView();
      } else if (state is AuthStateInRegisterView) {
        return const RegisterView();
      } else if (state is AuthStateNeedsVerification) {
        return const VerifyEmailView();
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    }, listener: (context, state) {
      if (state.loading) {
        loadingOn = true;
        LoadingScreen.myLoadingScreen
            .show(context: context, text: state.loadingText);
      }
      if (state.loading == false && loadingOn == true) {
        LoadingScreen.myLoadingScreen.hide();
        loadingOn = false;
      }
      if (state is AuthStateLoggedOut && state.exception != null) {
        if (state.exception is MyExceptions) {
          MyExceptions e = state.exception as MyExceptions;
          showErrorDialog(
            context,
            e.reason,
            e.description,
          );
        } else {
          showErrorDialog(
            context,
            GenericAuthException().reason,
            state.exception.toString(),
          );
        }
      }
      if (state is AuthStateInRegisterView && state.exception != null) {
        if (state.exception is MyExceptions) {
          MyExceptions e = state.exception as MyExceptions;
          showErrorDialog(
            context,
            e.reason,
            e.description,
          );
        } else {
          showErrorDialog(
            context,
            GenericAuthException().reason,
            state.exception.toString(),
          );
        }
      }
    });
  }
}

/*
// ***************************LEARNING_BLOC***************************

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
                Text("Current value -> ${state.value}"),
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
                        BlocProvider.of<CounterBloc>(context)
                            .add(IncrementEvent(_myController.text));
                        //context.read<CounterBloc>().add(DecrementEvent(_myController.text));
                      },
                      child: const Text('Increase'),
                    ),
                    const SizedBox(width: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<CounterBloc>(context)
                            .add(DecrementEvent(_myController.text));
                        context
                            .read<CounterBloc>()
                            .add(DecrementEvent(_myController.text));
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

*/