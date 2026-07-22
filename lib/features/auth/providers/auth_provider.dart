import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/mock_repository.dart';
import '../../../models/user_model.dart';

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

class AuthState {
  final bool isLoading;
  final UserModel? user;
  final String? error;

  AuthState({this.isLoading = false, this.user, this.error});

  AuthState copyWith({bool? isLoading, UserModel? user, String? error, bool clearError = false}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => AuthState();
  
  final MockRepository _repository = MockRepository();

  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final success = await _repository.login(username, password);
    if (success) {
      state = state.copyWith(isLoading: false, user: _repository.currentUser);
      return true;
    } else {
      state = state.copyWith(isLoading: false, error: 'Username atau password tidak sesuai.');
      return false;
    }
  }

  void logout() {
    _repository.logout();
    state = AuthState();
  }
}
