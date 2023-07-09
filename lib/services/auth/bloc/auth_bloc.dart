import 'package:bloc/bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider myProvider) : super(const AuthStateLoading()) {
    on<AuthEventInitialize>((event, emit) async {
      await myProvider.initialize();
      final AuthUser? user = myProvider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(null));
      } else if (user.isEmailVerfied) {
        emit(AuthStateLoggedIn(user));
      } else {
        emit(const AuthStateNeedsVerification());
      }
    });
    on<AuthEventLogIn>((event, emit) async {
      try {
        String email = event.email;
        String password = event.password;
        AuthUser user = await myProvider.logIn(
          email: email,
          password: password,
        );
        if (user.isEmailVerfied) {
          emit(AuthStateLoggedIn(user));
        } else {
          emit(const AuthStateNeedsVerification());
        }
      } catch (e) {
        if (e is Exception) {
          emit(AuthStateLoggedOut(e));
        } else {
          Exception exception = Exception(e.toString());
          emit(AuthStateLoggedOut(exception));
        }
      }
    });
    on<AuthEventRegister>((event, emit) async {
      emit(const AuthStateLoading());
      try {
        await myProvider.createUser(
          email: event.email,
          password1: event.password,
          password2: event.password2,
        );
        myProvider.sendEmailVerification();
        emit(const AuthStateNeedsVerification());
      } catch (e) {
        if (e is Exception) {
          emit(AuthStateRegisterFailure(e));
        } else {
          emit(AuthStateRegisterFailure(Exception(e.toString())));
        }
      }
    });
    on<AuthEventLogOut>((event, emit) async {
      emit(const AuthStateLoading());
      try {
        await myProvider.logOut();
        emit(const AuthStateLoggedOut(null));
      } catch (e) {
        if (e is Exception) {
          emit(AuthStateLoggedOut(e));
        } else {
          Exception exception = Exception(e.toString());
          emit(AuthStateLoggedOut(exception));
        }
      }
    });
    on<AuthEventCheckEmailVerified>((event, emit) async {
      emit(const AuthStateLoading());
      await myProvider.reloadUser();
      if (myProvider.currentUser?.isEmailVerfied ?? false) {
        emit(AuthStateLoggedIn(myProvider.currentUser!));
      } else {
        emit(const AuthStateNeedsVerification());
      }
    });
  }
}
