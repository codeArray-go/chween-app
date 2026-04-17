import 'package:chween_app/lib/flutter_secure_storage.dart';
import 'package:chween_app/manager/socket_manager.dart';
import 'package:chween_app/services/socket_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../services/auth_services.dart';

// STATE
class AuthState {
  final bool isLoading;
  final Map<String, dynamic>? user;
  final String? error;
  final int selectedIndex;

  AuthState({this.isLoading = true, this.user, this.error, this.selectedIndex = 0});

  AuthState copyWith({bool? isLoading, Map<String, dynamic>? user, String? error, List<dynamic>? onlineUsers, int? selectedIndex}) {
    return AuthState(isLoading: isLoading ?? this.isLoading, user: user ?? this.user, error: error, selectedIndex: selectedIndex ?? this.selectedIndex);
  }
}

// NOTIFIER
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService authService;
  final SocketService socket;
  final Ref ref;

  AuthNotifier(this.authService, this.socket, this.ref) : super(AuthState());

  void selectPageIndex(int page) {
    state = state.copyWith(selectedIndex: page);
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await authService.logout();
      ref.read(socketManagerProvider).disconnect();
      state = AuthState(isLoading: false, user: null, error: null, selectedIndex: 0);
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error.toString());
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      state = AuthState(isLoading: true, user: null);
      final result = await authService.login(email, password);
      state = AuthState(isLoading: false, user: result, error: null, selectedIndex: 0);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signUp(String fullName, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await authService.signUp(fullName, email, password);
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
        state = AuthState(isLoading: false, user: null, error: null, selectedIndex: 0);
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
  return AuthNotifier(ref.read(authServiceProvider), ref.read(socketServiceProvider), ref);
});
