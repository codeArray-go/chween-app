import 'package:chween_app/lib/flutter_secure_storage.dart';
import 'package:chween_app/services/socket_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../services/auth_services.dart';

// STATE
class AuthState {
  final bool isLoading;
  final Map<String, dynamic>? user;
  final String? error;

  AuthState({this.isLoading = false, this.user, this.error});

  AuthState copyWith({bool? isLoading, Map<String, dynamic>? user, String? error, List<dynamic>? onlineUsers}) {
    return AuthState(isLoading: isLoading ?? this.isLoading, user: user ?? this.user, error: error);
  }
}

// NOTIFIER
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService authService;
  final SocketService socket;

  AuthNotifier(this.authService, this.socket) : super(AuthState());

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await authService.logout();
      await getToken();
      state = AuthState();
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error.toString());
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await authService.login(email, password);
      state = state.copyWith(isLoading: false, user: result);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> checkAuth() async {
    final token = await getToken();
    state = state.copyWith(isLoading: true, error: null);

    try {
      if (token != null) {
        final result = await authService.checkAuth();
        state = state.copyWith(isLoading: false, user: result);
      } else {
        state = AuthState();
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

// PROVIDERS
final authServiceProvider = Provider((ref) => AuthService());
final socketServiceProvider = Provider((ref) => SocketService());

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authServiceProvider), ref.read(socketServiceProvider));
});
