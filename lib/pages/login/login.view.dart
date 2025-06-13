import 'dart:async';
import 'package:Freight4u/helpers/session.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:Freight4u/pages/login/login.controller.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/pages/dailyform/dailyform.view.dart';
import 'package:Freight4u/pages/signup/signup.view.dart';
import 'package:Freight4u/widgets/form.dart';

class LoginPage extends StatefulWidget {
  final Session session;
  const LoginPage({super.key, required this.session});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _signupLoading = false;

  @override
  void initState() {
    super.initState();
    initTracking();
    // pageIndex = widget.page;
  }

  Future<void> initTracking() async {
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      final result =
          await AppTrackingTransparency.requestTrackingAuthorization();
      print("Tracking status: $result");
    }
  }

  void _triggerSignupFlow() {
    if (_signupLoading) return;

    setState(() => _signupLoading = true);

    Timer(const Duration(seconds: 1), () {
      setState(() => _signupLoading = false);
      Get.to(
        context,
        () => SignupPage(session: widget.session),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginController>.reactive(
      viewModelBuilder: () => LoginController(),
      onViewModelReady: (controller) => controller.init(),
      builder: (context, ctrl, child) {
        bool isLoading = ctrl.isBusy || _signupLoading;

        return SafeArea(
          child: Scaffold(
            backgroundColor: whiteColor,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            subtext("Don't have an account?", font_size: 13),
                            GestureDetector(
                              onTap: _triggerSignupFlow,
                              child: Row(
                                children: [
                                  linkText(
                                    " Sign Up",
                                    font_size: 16,
                                    font_weight: FontWeight.bold,
                                    color: primaryColor,
                                    text_border: TextDecoration.none,
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          height: 225,
                          width: double.infinity,
                          child: Image.asset("assets/images/login.png"),
                        ),
                        const SizedBox(height: 40),
                        textH1("Welcome Back!",
                            font_size: 30, color: blackColor),
                        const SizedBox(height: 10),
                        subtext(
                            "Log in, to manage your deliveries and forms with Freight4U.",
                            font_size: 15),
                        const SizedBox(height: 40),
                        textField(
                          "Enter Mobile no.",
                          hintText: "e.g. 1234567890",
                          keyboardType: TextInputType.number,
                          controller: ctrl.mobileController,
                        ),
                        const SizedBox(height: 15),
                        textField(
                          "Password",
                          hintText: "e.g. 23**",
                          controller: ctrl.passwordController,
                        ),
                        const SizedBox(height: 70),
                        SizedBox(
                          width: double.infinity,
                          child: darkButton(
                            buttonText("Log in", color: whiteColor),
                            primary: primaryColor,
                            onPressed: () async {
                              final isLoggedIn = await ctrl.login(context);
                              if (isLoggedIn) {
                                Get.toWithNoBack(
                                  context,
                                  () => DailyformPage(session: widget.session),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
                if (isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
