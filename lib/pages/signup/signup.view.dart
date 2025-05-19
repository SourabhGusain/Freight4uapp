import 'dart:async';
import 'package:flutter/material.dart';
import 'package:Freight4u/widgets/ui.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/pages/login/login.view.dart';
import 'package:Freight4u/pages/signup/signup.controller.dart';
import 'package:stacked/stacked.dart';

class SignupPage extends StatefulWidget {
  final Session session;
  const SignupPage({super.key, required this.session});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _loadingBackToLogin = false;

  void _triggerLoginFlow() {
    if (_loadingBackToLogin) return;

    setState(() => _loadingBackToLogin = true);

    Timer(const Duration(seconds: 1), () {
      setState(() => _loadingBackToLogin = false);
      Get.to(
        context,
        () => LoginPage(session: widget.session),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignupController>.reactive(
      viewModelBuilder: () => SignupController(),
      onViewModelReady: (controller) => controller.init(),
      builder: (context, formcontroller, child) {
        final isLoading = formcontroller.isBusy || _loadingBackToLogin;

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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: _triggerLoginFlow,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.arrow_back_ios,
                                    size: 16,
                                    color: primaryColor,
                                  ),
                                  linkText(
                                    "Log in! ",
                                    font_size: 16,
                                    font_weight: FontWeight.bold,
                                    color: primaryColor,
                                    text_border: TextDecoration.none,
                                  ),
                                ],
                              ),
                            ),
                            subtext(" Already have an account?", font_size: 13),
                          ],
                        ),
                        const SizedBox(height: 30),
                        textH1("Sign Up", font_size: 30),
                        const SizedBox(height: 10),
                        subtext(
                          "Get on the road with Freight4U — the driver’s smart companion.",
                          font_size: 15,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 50,
                          child: textField(
                            "Full Name",
                            hintText: "e.g. Sam Li",
                            controller: formcontroller.fullNameController,
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 50,
                          child: textField(
                            "Enter Mobile no.",
                            prefixText: "+61",
                            hintText: "e.g. 1234567890",
                            controller: formcontroller.phoneController,
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 50,
                          child: textField(
                            "Enter Email",
                            hintText: "e.g. example@gmail.com",
                            controller: formcontroller.emailController,
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 50,
                          child: textField(
                            "License number",
                            hintText: "e.g. 23345 455**",
                            controller: formcontroller.licenseController,
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 50,
                          child: textField(
                            "Vehicle number",
                            hintText: "e.g. AU 2344**",
                            controller: formcontroller.vehicleController,
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 50,
                          child: textField(
                            "Enter Password",
                            hintText: "e.g. 123**",
                            controller: formcontroller.passwordController,
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 50,
                          child: textField(
                            "Confirm Password",
                            hintText: "e.g. 123**",
                            controller:
                                formcontroller.confirmPasswordController,
                          ),
                        ),
                        const SizedBox(height: 70),
                        SizedBox(
                          width: double.infinity,
                          child: darkButton(
                            buttonText("Sign up", color: whiteColor),
                            primary: primaryColor,
                            onPressed: () async {
                              formcontroller.printFormDataAsJson();
                              await formcontroller.submitForm(context);
                              if (formcontroller.isSignupSuccess) {
                                Get.to(
                                  context,
                                  () => LoginPage(session: widget.session),
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
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
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
