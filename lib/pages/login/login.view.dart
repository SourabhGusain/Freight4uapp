import 'package:Freight4u/helpers/session.dart';
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
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginController>.reactive(
      viewModelBuilder: () => LoginController(),
      onViewModelReady: (controller) => controller.init(),
      builder: (context, ctrl, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: whiteColor,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 300,
                      width: double.infinity,
                      child: Image.asset("assets/images/login.png"),
                    ),
                    const SizedBox(height: 20),
                    textH1("Log In", font_size: 30),
                    const SizedBox(height: 10),
                    subtext("Seamless Access. One Tap Away.", font_size: 15),
                    const SizedBox(height: 20),
                    textField(
                      "Enter Mobile no.",
                      hintText: "e.g. 1234567890",
                      controller: ctrl.mobileController,
                    ),
                    const SizedBox(height: 15),
                    textField(
                      "Password",
                      hintText: "e.g. 23**",
                      controller: ctrl.passwordController,
                    ),
                    const SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerRight,
                      child: linkText(
                        "Forgot Password?",
                        font_size: 14,
                        font_weight: FontWeight.bold,
                        color: primaryColor,
                        text_border: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 70),
                    ctrl.isBusy
                        ? const Center(child: CircularProgressIndicator())
                        : SizedBox(
                            width: double.infinity,
                            child: darkButton(
                              buttonText("Log in", color: whiteColor),
                              primary: primaryColor,
                              onPressed: () async {
                                final isLoggedIn = await ctrl.login();
                                if (isLoggedIn) {
                                  Get.toWithNoBack(
                                      context,
                                      () => DailyformPage(
                                          session: widget.session));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Invalid mobile number or password"),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        subtext("Don't have an account?", font_size: 14),
                        GestureDetector(
                          onTap: () {
                            Get.to(
                                context,
                                () => SignupPage(
                                      session: widget.session,
                                    ));
                          },
                          child: linkText(
                            " Sign Up",
                            font_size: 15,
                            font_weight: FontWeight.bold,
                            color: primaryColor,
                            text_border: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
