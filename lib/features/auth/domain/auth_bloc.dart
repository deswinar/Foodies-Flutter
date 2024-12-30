import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<AuthStarted>((event, emit) async {
      final user = authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    });

    on<AuthRegister>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.signUp(event.email, event.password, event.displayName);
        emit(AuthAuthenticated(user: user!));
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });


    on<AuthLoggedIn>((event, emit) async {
      emit(AuthLoading()); // Emit loading state while logging in
      try {
        emit(AuthAuthenticated(user: event.user));
      } catch (e) {
        emit(AuthError(message: 'Failed to log in.'));
      }
    });

    on<AuthLoggedOut>((event, emit) async {
      emit(AuthLoading()); // Emit loading state while logging out
      try {
        await authRepository.signOut();
        emit(AuthUnauthenticated());
      } catch (e) {
        emit(AuthError(message: 'Failed to log out.'));
      }
    });

    // Handle any errors during authentication
    on<AuthErrorOccurred>((event, emit) {
      emit(AuthError(message: event.message));
    });
  }
}
