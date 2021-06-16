import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zalo_bloc/app.dart';
import 'package:flutter_zalo_bloc/authentication/blocs/blocs.dart';
import 'package:flutter_zalo_bloc/authentication/repositories/repositories.dart';
import 'package:flutter_zalo_bloc/message/blocs/blocs.dart';
import 'package:flutter_zalo_bloc/message/repositories/repositories.dart';
import 'package:flutter_zalo_bloc/simple_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  Bloc.observer = SimpleBlocObserver();

  final authenticationRepository = AuthenticationRepository(
    authenticationApiClient: AuthenticationApiClient(),
    authenticationPersist: AuthenticationPersist(),
  );

  final socketIoRepository =
      SocketIoRepository(socketIoClient: SocketIoClient());

  final chatRepository = ChatRepository(chatApiClient: ChatApiClient());

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<AuthenticationBloc>(
        create: (context) => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          socketIoRepository: socketIoRepository,
        )..add(Initialize()),
      ),
      BlocProvider<MessageBloc>(
        create: (context) => MessageBloc(
          chatRepository: chatRepository,
          socketIoRepository: socketIoRepository,
        ),
      ),
      BlocProvider<ConversationsBloc>(
        create: (context) => ConversationsBloc(
          chatRepository: chatRepository,
        ),
      ),
    ],
    child: App(
      authenticationRepository: authenticationRepository,
    ),
  ));
}
