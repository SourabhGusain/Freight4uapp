import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/get.dart';
import 'updatepassword.controller.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChangePasswordController>.reactive(
      viewModelBuilder: () => ChangePasswordController(),
      onViewModelReady: (controller) => controller.init(),
      builder: (context, ctrl, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: whiteColor,
            appBar: AppBar(
              title: textH1("Change Password", font_size: 18),
              backgroundColor: whiteColor,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        subtext("Update your password for better security.",
                            font_size: 14),
                        const SizedBox(height: 25),
                        textField(
                          "Full Name",
                          controller: ctrl.currentPasswordController,
                        ),
                        const SizedBox(height: 15),
                        textField(
                          "Mobile Number",
                          controller: ctrl.currentPasswordController,
                        ),
                        const SizedBox(height: 15),
                        textField(
                          "New Password",
                          controller: ctrl.newPasswordController,
                        ),
                        const SizedBox(height: 15),
                        textField(
                          "Confirm New Password",
                          controller: ctrl.confirmPasswordController,
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          child: darkButton(
                            buttonText("Change Password", color: whiteColor),
                            primary: primaryColor,
                            onPressed: () async {
                              FocusScope.of(context)
                                  .unfocus(); // dismiss keyboard

                              final success =
                                  await ctrl.changePassword(context);
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("Password changed successfully."),
                                  ),
                                );
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Failed to change password."),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),

                // Loader Overlay
                if (ctrl.isBusy)
                  Container(
                    color: Colors.black.withOpacity(0.4),
                    child: const Center(
                      child: CircularProgressIndicator(color: primaryColor),
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
