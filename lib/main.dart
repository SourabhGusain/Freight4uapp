import 'package:Freight4u/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/pages/format/format.view.dart';
import 'package:Freight4u/pages/utils/splash.view.dart';
import 'package:Freight4u/pages/dailyform/dailyform.view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Session session = Session();
  String? key = await session.getSession("loggedInUserKey");
  bool isLoggedIn = false;

  if (key != null && key.isNotEmpty) {
    isLoggedIn = true;
  }

  runApp(MainApp(isLoggedIn: isLoggedIn, session: session));
}

class MainApp extends StatelessWidget {
  final bool isLoggedIn;
  final Session session;

  const MainApp({super.key, required this.isLoggedIn, required this.session});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Freight 4 You',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: isLoggedIn
          ? DailyformPage(session: session)
          : SplashPage(session: session),
    );
  }
}
