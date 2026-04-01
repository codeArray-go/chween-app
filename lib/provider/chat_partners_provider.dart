import 'package:chween_app/lib/fetch_url.dart';
import 'package:flutter_riverpod/legacy.dart';

class ChatPartnersState {
  final bool isLoading;
  final List<Map<String, dynamic>>? partners;
  final String? error;

  ChatPartnersState({this.isLoading = false, this.partners, this.error});

  ChatPartnersState copyWith({bool? isLoading, List<Map<String, dynamic>>? partners, String? error}) {
    return ChatPartnersState(isLoading: isLoading ?? this.isLoading, partners: partners ?? this.partners, error: error ?? this.error);
  }
}

//NOTIFIER
class ChatPartnersNotifier extends StateNotifier<ChatPartnersState> {
  ChatPartnersNotifier() : super(ChatPartnersState(isLoading: true)) {
    fetchPartners();
  }

  Future<void> fetchPartners() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await FetchUrl.get("/messages/chats");
      final partners = List<Map<String, dynamic>>.from(response);
      state = state.copyWith(isLoading: false, partners: partners);
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error.toString());
    }
  }
}

// PROVIDERS
final chatPartnerProvider = StateNotifierProvider<ChatPartnersNotifier, ChatPartnersState>((ref) {
  return ChatPartnersNotifier();
});
