import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up.dart';
import '../../domain/usecases/watch_current_user.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignUp signUpUseCase;
  final SignIn signInUseCase;
  final SignOut signOutUseCase;
  final GetCurrentUser getCurrentUserUseCase;
  final WatchCurrentUser watchCurrentUserUseCase;

  StreamSubscription<AuthUser?>? _authSubscription;

  AuthCubit({
    required this.signUpUseCase,
    required this.signInUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
    required this.watchCurrentUserUseCase,
  }) : super(const AuthState.initial());

  void initialize() {
    final currentUser = getCurrentUserUseCase();
    if (currentUser != null) {
      emit(AuthState.authenticated(currentUser));
    } else {
      emit(const AuthState.unauthenticated());
    }

    _authSubscription?.cancel();
    _authSubscription = watchCurrentUserUseCase().listen((user) {
      if (user != null) {
        emit(AuthState.authenticated(user));
      } else {
        emit(const AuthState.unauthenticated());
      }
    });
  }

  Future<void> signUp({required String email, required String password}) async {
    emit(const AuthState.loading());

    try {
      final user = await signUpUseCase(email: email, password: password);

      if (user != null) {
        emit(AuthState.authenticated(user));
      } else {
        emit(const AuthState.unauthenticated());
      }
    } catch (e) {
      emit(AuthState.failure(e.toString()));
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(const AuthState.loading());

    try {
      final user = await signInUseCase(email: email, password: password);

      if (user != null) {
        emit(AuthState.authenticated(user));
      } else {
        emit(const AuthState.unauthenticated());
      }
    } catch (e) {
      emit(AuthState.failure(e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(const AuthState.loading());

    try {
      await signOutUseCase();
      emit(const AuthState.unauthenticated());
    } catch (e) {
      emit(AuthState.failure(e.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _authSubscription?.cancel();
    return super.close();
  }
}
