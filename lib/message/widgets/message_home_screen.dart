import 'package:flutter/material.dart';
import 'package:flutter_zalo_bloc/message/widgets/widgets.dart';

class MessageHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
