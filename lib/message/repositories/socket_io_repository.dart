import 'package:flutter_zalo_bloc/message/models/models.dart';
import 'package:flutter_zalo_bloc/message/repositories/repositories.dart';

class SocketIoRepository {
  final SocketIoClient socketIoClient;

  SocketIoRepository({required this.socketIoClient});

  void connect({required String userId}) {
    socketIoClient.connect(userId: userId);
  }

  void disconnect() {
    socketIoClient.disconnect();
  }

  void sendMessage({required Message message}) {
    socketIoClient.sendMessage(message: message);
  }

  void subscribeReceiveCallback({dynamic callback}) {
    socketIoClient.subscribeCallback(event: 'receive', callback: callback);
  }
}
