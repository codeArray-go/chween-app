import 'package:chween_app/lib/fetch_url.dart';
import 'package:chween_app/lib/flutter_secure_storage.dart';

class AuthService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final res = await FetchUrl.post("/auth/login", body: {"email": email, "password": password});
      print("This is token from login page :$res['token']");
      await saveToken(res['token']);
      return res;
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  Future logout() async {
    try {
      deleteToken();
    } catch (error) {
      throw Exception("Error in logout: $error");
    }
  }

  Future checkAuth() async {
    try {
      final check = await FetchUrl.get("/auth/check");
      return check;
    } catch (e) {
      throw Exception("Internal Error");
    }
  }
}
