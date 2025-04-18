import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/pages/signup/signup.view.dart';
import 'package:Freight4u/pages/format/format.controller.dart';
import 'package:Freight4u/pages/dailyform/dailyform.view.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
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
                backgroundColor: whiteColor,
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: 300,
                            width: double.infinity,
                            child: Image.asset("assets/images/login.png")),
                        const SizedBox(height: 20),
                        textH1("Log In", font_size: 30),
                        const SizedBox(height: 10),
                        subtext("Seamless Access. One Tap Away.",
                            font_size: 15),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 50,
                          child: textField(
                            "Enter Mobile no.",
                            hintText: "e.g. 1234567890",
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 50,
                          child: textField(
                            "Password",
                            hintText: "e.g. 23**",
                          ),
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
                            // onTap: () {
                            //   // Get.toWithNoBack(context, () => const ForgotPasswordPage());
                            // },
                          ),
                        ),
                        const SizedBox(height: 70),
                        SizedBox(
                          width: double.infinity,
                          child: darkButton(
                            buttonText("Log in", color: whiteColor),
                            primary: primaryColor,
                            onPressed: () {
                              Get.toWithNoBack(
                                  context, () => const DailyformPage());
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
                                Get.to(context, () => const SignupPage());
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
                )),
          );
        },
        onViewModelReady: (controller) {
          controller.init();
        });
  }
}
