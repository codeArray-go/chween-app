import 'package:chween_app/manager/socket_manager.dart';
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
  final List<dynamic> notificationCount;
  final List<dynamic> onlineUsers;

  ChatProviderState({this.selectedUser, this.chats = const [], this.error, this.isLoading = false, this.messageSelected, this.notificationCount = const [], this.onlineUsers = const []});

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

  // -------------------- SOCKET RELATED FUNCTIONS --------------------
  // GET ONLINE USERS
  void getOnlineUsers(List<dynamic> users) {
    state = state.copyWith(onlineUsers: users);
  }

  // GET NEW MESSAGES
  void liveMessage(dynamic newMessage) {
    final Map<String, dynamic> message = newMessage is List ? newMessage.first : newMessage;
    state = state.copyWith(chats: [...state.chats, message]);
  }

  // UPDATE MESSAGE SEEN STATUS
  void setChats(int id) {
    final message = state.chats;

    final updatedChats = message.map((msg) {
      final rid = int.parse(msg["receiver_id"]);

      if (rid == id && (msg["is_seen"] == false)) {
        return {...msg, "is_seen": true};
      }
      return msg;
    }).toList();

    state = state.copyWith(chats: updatedChats);
  }

  // UPDATE DELETED MESSAGE
  void chatAfterDelete(int messageId) {
    final message = state.chats;

    final updatedMessage = message.where((msg) => int.parse(msg["id"]) != messageId).toList();
    state = state.copyWith(chats: updatedMessage);
  }

  // EMIT SEEN STATUS
  void emitSeenStatus() {
    final authId = ref.read(authProvider).user?['id'];
    final id = state.selectedUser?['id'];

    final data = {"messagesender_id": id, "myId": authId};
    ref.read(socketManagerProvider).emmitSeenStatus(data);
  }

  // GET UNREAD MESSAGE COUNT AFTER ONE USER MESSAGES ARE SEEN
  void notSeenMessage(int sender, String count) {
    bool found = false;

    final updatedNotification = state.notificationCount.map((elem) {
      if (sender == int.parse(elem['sender_id'])) {
        found = true;
        return {...elem, "unread_count": count};
      }
      return elem;
    }).toList();

    if (!found) {
      updatedNotification.add({"sender_id": sender.toString(), "unread_count": count});
    }

    state = state.copyWith(notificationCount: updatedNotification);
  }

  // --------------------------------------------------------------------

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
      final message = state.chats;

      final updatedMessage = message.where((msg) => int.parse(msg["id"]) != id).toList();
      state = state.copyWith(chats: updatedMessage);
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
