import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/assets/strings/strings.dart';
import 'package:surf_practice_chat_flutter/data/chat/repository/firebase.dart';
import 'package:surf_practice_chat_flutter/firebase_options.dart';
import 'package:surf_practice_chat_flutter/screens/chat.dart';
import 'package:surf_practice_chat_flutter/service/messages_bloc/messages_bloc.dart';
import 'package:surf_practice_chat_flutter/service/send_message_bloc/send_message_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform(
      androidKey: 'AIzaSyD5bCOfO29kCv2mIdmYa6CEKhud4Gs1YIU',
      iosKey: 'AIzaSyBZo6-selWq9F-oQqwjr9eB2VpSvFc9DYE',
      webKey: 'AIzaSyAtMxD7Nb6Z06IL2yg8DbI56xoneVhXSNQ',
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Refactor dependencies via Provider
    final chatRepository = ChatRepositoryFirebase(FirebaseFirestore.instance);
    final messagesBloc = MessagesBloc(chatRepository)..add(MessagesRefresh());
    final sendMessageBloc = SendMessageBloc(chatRepository, messagesBloc);

    return MaterialApp(
      title: appTitle,
      restorationScopeId: restorationScopeId,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: ChatScreen(
        chatRepository: chatRepository,
        messagesBloc: messagesBloc,
        sendMessageBloc: sendMessageBloc,
      ),
    );
  }
}
