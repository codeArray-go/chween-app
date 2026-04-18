import 'package:chween_app/lib/flutter_secure_storage.dart';
import 'package:chween_app/manager/socket_manager.dart';
import 'package:chween_app/navigator_page.dart';
import 'package:chween_app/pages/login_page.dart';
import 'package:chween_app/provider/auth_provider.dart';
import 'package:chween_app/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthWrapper extends ConsumerStatefulWidget {
  const AuthWrapper({super.key});

  @override
  ConsumerState<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    ref.read(authProvider.notifier).checkAuth();
    ref.read(chatProvider.notifier).getNotification();
  }

  Future<void> _connectSocket() async {
    final token = await getToken();
    if (token == null) {
      debugPrint("Token not found, skipping socket connection");
      return;
    }
    ref.read(socketManagerProvider).connect(token);
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.user != null && previous?.user == null) {
        _connectSocket();
      }

      if (next.user == null && previous?.user != null) {
        debugPrint("Logging out: Disconnecting socket from Wrapper");
        ref.read(socketManagerProvider).disconnect();
      }
    });

    if (auth.isLoading) return Center(child: CircularProgressIndicator.adaptive());

    if (auth.user != null) return NavigatorPage(key: UniqueKey());
    return LoginPage(key: UniqueKey());
  }
}
