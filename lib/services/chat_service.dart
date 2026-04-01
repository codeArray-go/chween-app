import 'dart:convert';
import 'package:chween_app/lib/fetch_url.dart';
import 'package:http/http.dart' as http;

class ChatService {
  Future<List<dynamic>> getNotification() async {
    final notification = await FetchUrl.get("/messages/getNoti");
    return notification;
  }

  Future<List<dynamic>> getChatWithId(int id) async {
    try {
      final res = await FetchUrl.get("/messages/$id");
      return res;
    } catch (e) {
      throw Exception("Error while getting you chats: $e");
    }
  }

  Future<String?> uploadImage(String image) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dvqgf2yib/upload');

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'chweenApp'
      ..files.add(await http.MultipartFile.fromPath('file', image));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonMap = jsonDecode(responseData);

      return jsonMap['secure_url'];
    }
    return null;
  }

  Future<Map<String, dynamic>> sendMessage(int id, String text, String imageUrl) async {
    try {
      final res = await FetchUrl.post("/messages/send/$id", body: {"text": text, "image": imageUrl});
      return res;
    } catch (error) {
      throw Exception("Error sending message: $error");
    }
  }

  Future<void> deleteMessage(int id) async {
    await FetchUrl.post("/messages/delete", body: {"message_id": id});
  }
}
