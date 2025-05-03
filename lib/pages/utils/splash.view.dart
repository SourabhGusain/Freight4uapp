import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/pages/login/login.view.dart';
import 'package:Freight4u/pages/format/format.controller.dart';

class SplashPage extends StatefulWidget {
  final Session session;
  const SplashPage({super.key, required this.session});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      Get.toWithNoBack(
          context,
          () => LoginPage(
                session: widget.session,
              ));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FormatController>.reactive(
      viewModelBuilder: () => FormatController(),
      builder: (context, ctrl, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: primaryColor,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/logo.png"),
                ],
              ),
            ),
          ),
        );
      },
      onViewModelReady: (controller) {
        controller.init();
      },
    );
  }
}
