import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zalo_bloc/helpers/time_helper.dart';
import 'package:flutter_zalo_bloc/message/blocs/blocs.dart';
import 'package:flutter_zalo_bloc/message/widgets/message_screen.dart';
import 'package:flutter_zalo_bloc/search/widgets/search_screen.dart';

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
                DateTime lastTime =
                    DateTime.fromMillisecondsSinceEpoch(conversation.lastTime);

                Widget avatarWidget;
                if (avatar is String) {
                  avatarWidget = CircleAvatar(
                    backgroundImage: NetworkImage(avatar),
                  );
                } else {
                  avatarWidget = CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(conversation.partner.name[0].toUpperCase()),
                  );
                }

                return ListTile(
                  leading: avatarWidget,
                  title: Text(conversation.partner.name),
                  subtitle: Text(conversation.lastContent),
                  trailing: Text(TimeHelper.readTimestamp(lastTime.toString())),
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
            showSearch(context: context, delegate: SearchScreen());
          },
          child: Text('TÌM THÊM BẠN'),
        )
      ],
    );
  }
}
