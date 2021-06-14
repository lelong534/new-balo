import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zalo_bloc/message/blocs/blocs.dart';
import 'package:flutter_zalo_bloc/message/widgets/message_screen.dart';
import 'package:flutter_zalo_bloc/message/widgets/widgets.dart';

class MessageHomeScreen extends StatefulWidget {
  @override
  _MessageHomeScreenState createState() => _MessageHomeScreenState();
}

class _MessageHomeScreenState extends State<MessageHomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ConversationsBloc>().add(GetConversations());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<ConversationsBloc, ConversationsState>(
          builder: (context, state) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: state.conversations.length,
              itemBuilder: (context, index) {
                final conversation = state.conversations[index];

                String? avatar = conversation.partner.avatar;

                Widget avatarWidget;
                if (avatar is String) {
                  avatarWidget = CircleAvatar(
                    backgroundImage: NetworkImage(avatar),
                  );
                } else {
                  avatarWidget = CircleAvatar(
                    backgroundColor: Colors.brown.shade800,
                    child: Text(conversation.partner.name[0].toUpperCase()),
                  );
                }

                return ListTile(
                  leading: avatarWidget,
                  title: Text(conversation.partner.name),
                  subtitle: Text(conversation.lastContent),
                  trailing: Text(conversation.lastTime.toString()),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessageScreen(
                          receiver: conversation.partner,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DummySearchScreen(),
              ),
            );
          },
          child: Text('TÌM THÊM BẠN'),
        )
      ],
    );
  }
}
