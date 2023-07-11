import 'package:bloc/bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider myProvider)
      : super(const AuthStateUnInitialized(
          loading: true,
        )) {
    on<AuthEventInitialize>((event, emit) async {
      emit(const AuthStateUnInitialized(loading: true));
      await myProvider.initialize();
      final AuthUser? user = myProvider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(
          exception: null,
          loading: false,
        ));
      } else if (user.isEmailVerfied) {
        emit(AuthStateLoggedIn(
          user: user,
          loading: false,
        ));
      } else {
        emit(AuthStateNeedsVerification(
            email: myProvider.currentUser?.userEmail ?? '', loading: false));
      }
    });
    on<AuthEventLogIn>((event, emit) async {
      emit(const AuthStateLoggedOut(
        exception: null,
        loading: true,
      ));
      try {
        String email = event.email;
        String password = event.password;
        AuthUser user = await myProvider.logIn(
          email: email,
          password: password,
        );
        //To close the loading screen
        if (user.isEmailVerfied) {
          emit(AuthStateLoggedIn(
            user: user,
            loading: false,
          ));
        } else {
          emit(AuthStateNeedsVerification(
              email: myProvider.currentUser?.userEmail ?? '', loading: false));
        }
      } catch (e) {
        if (e is Exception) {
          emit(AuthStateLoggedOut(
            exception: e,
            loading: false,
          ));
        } else {
          Exception exception = Exception(e.toString());
          emit(AuthStateLoggedOut(
            exception: exception,
            loading: false,
          ));
        }
      }
    });
    on<AuthEventGoToRegisterView>((event, emit) {
      emit(const AuthStateInRegisterView(exception: null, loading: false));
    });
    on<AuthEventRegister>((event, emit) async {
      emit(const AuthStateInRegisterView(
        exception: null,
        loading: true,
      ));
      try {
        await myProvider.createUser(
          email: event.email,
          password1: event.password,
          password2: event.password2,
        );
        myProvider.sendEmailVerification();
        emit(AuthStateNeedsVerification(
          email: myProvider.currentUser?.userEmail ?? '',
          loading: false,
        ));
      } catch (e) {
        if (e is Exception) {
          emit(AuthStateInRegisterView(
            exception: e,
            loading: false,
          ));
        } else {
          emit(AuthStateInRegisterView(
            exception: Exception(e.toString()),
            loading: false,
          ));
        }
      }
    });
    on<AuthEventLogOut>((event, emit) async {
      //To show loading
      emit(AuthStateLoggedIn(
        user: myProvider.currentUser,
        loading: true,
      ));
      try {
        await myProvider.logOut();
        emit(const AuthStateLoggedOut(
          exception: null,
          loading: false,
        ));
      } catch (e) {
        if (e is Exception) {
          emit(AuthStateLoggedOut(
            exception: e,
            loading: false,
          ));
        } else {
          Exception exception = Exception(e.toString());
          emit(AuthStateLoggedOut(
            exception: exception,
            loading: false,
          ));
        }
      }
    });
    on<AuthEventGoToLogIn>((event, emit) {
      emit(const AuthStateLoggedOut(
        exception: null,
        loading: false,
      ));
    });
    on<AuthEventResendEmailVerification>((event, emit) async {
      await myProvider.sendEmailVerification();
      emit(state);
    });
    on<AuthEventCheckEmailVerified>((event, emit) async {
      await myProvider.reloadUser();
      if (myProvider.currentUser?.isEmailVerfied ?? false) {
        emit(AuthStateLoggedIn(
          user: myProvider.currentUser,
          loading: false,
        ));
      } else {
        emit(state);
      }
    });
  }
}
