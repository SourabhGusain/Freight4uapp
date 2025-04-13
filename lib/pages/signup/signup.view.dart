import 'package:flutter/material.dart';
import 'package:Freight4u/widgets/ui.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/pages/login/login.view.dart';
import 'package:Freight4u/pages/format/format.controller.dart';

// import 'package:Freight4u/helpers/widgets.dart';
import 'package:stacked/stacked.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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
                        textH1("Sign Up", font_size: 30),
                        const SizedBox(height: 10),
                        subtext("One Sign-Up. All Your Forms in One Place.",
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
                            "Enter Password",
                            hintText: "e.g. 23**",
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 50,
                          child: textField(
                            "Confirm Password",
                            hintText: "e.g. 23**",
                          ),
                        ),
                        const SizedBox(height: 70),
                        SizedBox(
                          width: double.infinity,
                          child: darkButton(
                            buttonText("Sign up", color: whiteColor),
                            primary: primaryColor,
                            // onTap: () {
                            //   // Get.toWithNoBack(context, () => const HomePage());
                            // },
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            subtext("Already have an account?", font_size: 14),
                            GestureDetector(
                              onTap: () {
                                Get.to(context, () => const LoginPage());
                              },
                              child: linkText(
                                " Log in",
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
