import 'package:chween_app/provider/auth_provider.dart';
import 'package:chween_app/services/chat_service.dart';
import 'package:chween_app/services/socket_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class ChatProviderState {
  final bool isLoading;
  final Map<String, dynamic>? selectedUser;
  final List<dynamic> chats;
  final String? error;
  final int? messageSelected;
  final List<dynamic>? notificationCount;
  final List<dynamic> onlineUsers;

  ChatProviderState({this.selectedUser, this.chats = const [], this.error, this.isLoading = false, this.messageSelected, this.notificationCount, this.onlineUsers = const []});

  ChatProviderState copyWith({
    bool? isLoading,
    Map<String, dynamic>? selectedUser,
    String? error,
    List<dynamic>? chats,
    int? messageSelected,
    List<dynamic>? notificationCount,
    List<dynamic>? onlineUsers,
  }) {
    return ChatProviderState(
      isLoading: isLoading ?? this.isLoading,
      selectedUser: selectedUser ?? this.selectedUser,
      error: error ?? this.error,
      chats: chats ?? this.chats,
      messageSelected: messageSelected ?? this.messageSelected,
      notificationCount: notificationCount ?? this.notificationCount,
      onlineUsers: onlineUsers ?? this.onlineUsers,
    );
  }

  ChatProviderState clear({bool clearSelectedUser = false, bool clearOptimisticMessage = false, bool clearMessageSelected = false, bool clearError = false}) {
    return ChatProviderState(
      isLoading: isLoading,
      chats: chats,
      notificationCount: notificationCount,
      onlineUsers: onlineUsers,

      // If true, force to null. If false, keep current state.
      selectedUser: clearSelectedUser ? null : selectedUser,
      messageSelected: clearMessageSelected ? null : messageSelected,
      error: clearError ? null : error,
    );
  }
}

// NOTIFIER
class ChatNotifier extends StateNotifier<ChatProviderState> {
  final ChatService chatService;
  final SocketService socket;
  final Ref ref;

  ChatNotifier(this.chatService, this.socket, this.ref) : super(ChatProviderState());

  // NOTIFICATION
  Future<void> getNotification() async {
    final res = await chatService.getNotification();
    state = state.copyWith(notificationCount: res);
  }

  // SET SELECTED USER VALUE AND RETRIEVE CHATS FROM DB
  Future<void> setSelectedUser(int id, String fullName, String profilePic) async {
    final selected = {"id": id, "full_name": fullName, "profile_pic": profilePic};
    state = state.copyWith(isLoading: true, selectedUser: selected);

    try {
      final getChat = await chatService.getChatWithId(id);
      state = state.copyWith(isLoading: false, chats: getChat);
    } catch (error) {
      state = state.copyWith(isLoading: false, chats: [], error: error.toString());
    }
  }

  // CLEAR SELECTED USER VALUE
  void clearSelectedUser() {
    state = state.clear(clearSelectedUser: true).copyWith(chats: []);
  }

  // SEND MESSAGE
  Future<void> sendMessage(int id, String text, String image) async {
    final tempId = (DateTime.now().millisecondsSinceEpoch).toString();
    final receiverId = state.selectedUser!['id'];
    final senderId = ref.read(authProvider).user?['id'].toString();
    final messageCreateTime = (DateTime.now()).toString();

    if (senderId == null) return;

    final preMessage = {"id": tempId, "sender_id": senderId, "receiver_id": receiverId, "text": text, "image": image, "created_at": messageCreateTime, "is_seen": false, "isOptimisticMessage": true};
    state = state.copyWith(chats: [...state.chats, preMessage]);

    try {
      String imageFromCloud = "";
      if (image.isNotEmpty) {
        final imageUrl = await chatService.uploadImage(image);
        if (imageUrl != null) {
          imageFromCloud = imageUrl;
        }
      }
      final res = await chatService.sendMessage(id, text, imageFromCloud);
      final Map<String, dynamic> responseMessage = res;
      state = state.copyWith(
        chats: state.chats.map((msg) {
          if (msg['id'] == tempId) {
            return responseMessage;
          }
          return msg;
        }).toList(),
      );
    } catch (err) {
      state = state.copyWith(error: err.toString());
    }
  }

  // **************************************************************************************************
  // GET ONLINE USERS
  void getOnlineUsers(List<dynamic> users) {
    state = state.copyWith(onlineUsers: users);
  }

  // GET NEW MESSAGES
  void liveMessage(dynamic newMessage) {
    final Map<String, dynamic> message = newMessage is List ? newMessage.first : newMessage;
    print(message);
    state = state.copyWith(chats: [...state.chats, message]);
  }

  // ***************************************************************************************************

  // SELECT MESSAGE TO DELETE
  void messageIdToDelete(int id) {
    state = state.copyWith(messageSelected: id);
  }

  // UNSELECT MESSAGE TO DELETE
  void unselectedMessageIdToDelete() {
    state = state.clear(clearMessageSelected: true);
  }

  // DELETE MESSAGE
  Future<void> deleteMessage(int id) async {
    try {
      await chatService.deleteMessage(id);
    } catch (error) {
      throw Exception("Error while deleting message: $error");
    }
  }
}

// PROVIDER
final chatServiceProvider = Provider((ref) => ChatService());
final socketServiceProvider = Provider((ref) => SocketService());

final chatProvider = StateNotifierProvider<ChatNotifier, ChatProviderState>((ref) {
  return ChatNotifier(ref.read(chatServiceProvider), ref.read(socketServiceProvider), ref);
});
