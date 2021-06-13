import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zalo_bloc/authentication/blocs/blocs.dart';
import 'package:flutter_zalo_bloc/authentication/models/models.dart';
import 'package:flutter_zalo_bloc/message/blocs/blocs.dart';
import 'package:loading_overlay/loading_overlay.dart';

class MessageScreen extends StatefulWidget {
  final UserMainInfo receiver;

  MessageScreen({required this.receiver});

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final _messageController = TextEditingController();
  late User user;

  @override
  void initState() {
    super.initState();

    AuthenticationState authenticationState =
        context.read<AuthenticationBloc>().state;
    if (authenticationState is Authenticated) {
      user = authenticationState.user;

      context.read<MessageBloc>().add(GetMessagesRequested(
            senderId: user.userMainInfo.id,
            receiverId: widget.receiver.id,
          ));
    }
  }

  Future<bool> _pop() {
    context.read<MessageBloc>().add(ResetMessages());
    return Future.value(true);
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      context.read<MessageBloc>().add(SendMessage(
            sender: user.userMainInfo,
            receiver: widget.receiver,
            content: _messageController.text,
          ));

      context.read<ConversationsBloc>().add(ResetConversations(
            receiver: widget.receiver,
            content: _messageController.text,
          ));

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _pop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.receiver.name),
        ),
        body: BlocBuilder<MessageBloc, MessageState>(
          builder: (context, state) {
            MessageBloc messageBloc = context.read<MessageBloc>();
            if (!messageBloc.subscribed) {
              messageBloc.subscribe(
                receiveCallback: messageBloc.getReiceiveCallbacl(),
              );
            }

            return LoadingOverlay(
              isLoading: state.loading,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          return Text(state.messages[index].content);
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: 'Tin nhắn',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Material(
                            child: IconButton(
                              onPressed: _sendMessage,
                              icon: Icon(Icons.send_rounded),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
