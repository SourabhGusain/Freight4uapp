import 'package:flutter/material.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/pages/format/format.view.dart';
import 'package:Freight4u/pages/utils/splash.view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Session session = Session();
  String? key = await session.getSession("loggedInUserKey");
  bool isLoggedIn = false;
  if (key != null && key != "") {
    isLoggedIn = true;
  }
  LoggedInUserActivity.set(isLoggedIn);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveApp.set(context);
    return MaterialApp(
      title: 'Freight 4 You',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.orange, scaffoldBackgroundColor: Colors.white),
      home: const SplashPage(),
    );
  }
}
