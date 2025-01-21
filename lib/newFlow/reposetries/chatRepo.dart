
import '../services/app_url.dart';
import '../services/http_service.dart';

class ChatRepo {
  final ApiService apiService;

  ChatRepo(this.apiService);

  Future<void> sendMsgApi(String senderId, recieverId, msg) async {
    final response = await apiService.post(
      AppUrl.sendMsgUrl,
      headers: {
        "Content-type": "application/json",
      },
      body: {
        "senderId": senderId,
        "senderRole": "User",
        "receiverId": recieverId,
        "receiverRole": "Therapist",
        "message": msg
      },
    );

    print(response.body);
  }
}
