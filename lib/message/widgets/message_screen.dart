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
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            margin: EdgeInsets.symmetric(vertical: 4),
                            width: MediaQuery.of(context).size.width,
                            alignment: state.messages[index].sender.id ==
                                    user.userMainInfo.id
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              child: Text(
                                state.messages[index].content,
                                style: TextStyle(color: Colors.white),
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: state.messages[index].sender.id ==
                                          user.userMainInfo.id
                                      ? [
                                          const Color(0xff007EF4),
                                          const Color(0XFF2A75BC)
                                        ]
                                      : [Colors.black38, Colors.black38],
                                ),
                                borderRadius: state.messages[index].content !=
                                        state.messages.last.content
                                    ? BorderRadius.all(Radius.circular(23))
                                    : (state.messages[index].sender.id ==
                                            user.userMainInfo.id
                                        ? BorderRadius.only(
                                            topLeft: Radius.circular(23.0),
                                            topRight: Radius.circular(23.0),
                                            bottomLeft: Radius.circular(23.0))
                                        : BorderRadius.only(
                                            topLeft: Radius.circular(23.0),
                                            topRight: Radius.circular(23.0),
                                            bottomRight:
                                                Radius.circular(23.0))),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
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
                            IconButton(
                              onPressed: _sendMessage,
                              icon: Icon(Icons.send_rounded),
                            )
                          ],
                        ),
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
