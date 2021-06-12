import 'package:flutter_zalo_bloc/message/models/models.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketIoClient {
  late Socket socket;
  bool init = false;

  void initialize() {
    socket = io(
      'https://zalochatserver.herokuapp.com',
      OptionBuilder().setTransports(['websocket']).disableAutoConnect().build(),
    );

    socket.onConnectError((e) {
      print('onConnectError: $e');
    });
  }

  void connect({required String userId}) {
    if (!init) {
      initialize();
      init = true;
    }

    socket.io.options['extraHeaders'] = {'user_id': userId};

    socket.connect();
  }

  void disconnect() {
    socket.disconnect();
  }

  void sendMessage({required Message message}) {
    socket.emit('send', messageToJson(message));
  }

  void subscribeCallback({required String event, dynamic callback}) {
    socket.on(event, (jsonData) {
      print('event: $event: $jsonData');
      callback(jsonData);
    });
  }
}
