import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:Freight4u/widgets/ui.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/pages/login/login.view.dart';
import 'package:Freight4u/pages/format/format.controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FormatController>.reactive(
      viewModelBuilder: () => FormatController(),
      onViewModelReady: (controller) => controller.init(),
      builder: (context, ctrl, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xFFF5F7FA),
            body: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfileInfoCard(),
                        const SizedBox(height: 20),
                        textH1("Settings", font_size: 18),
                        const SizedBox(height: 10),
                        _buildProfileOptions(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: customBottomNavigationBar(
              context: context,
              selectedIndex: 3,
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Stack(
        children: [
          // Background container with gradient
          Container(
            height: 100,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [primaryColor, Color(0xFF3A7BD5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),

          // Foreground content
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar with border
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 0.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage("assets/images/profile.jpg"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        textH1("John Doe",
                            color: whiteColor,
                            font_size: 18,
                            font_weight: FontWeight.w600),
                        const SizedBox(height: 6),
                        textH3(
                          "Driver / Freight Operator",
                          color: whiteColor,
                          font_size: 13,
                        ),
                      ],
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.edit_outlined,
                          color: Colors.white, size: 22),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textH2("Email:", color: primaryColor),
              textH2("johndoe@example.com",
                  color: primaryColor, font_weight: FontWeight.w500),
            ],
          ),
          const SizedBox(
            height: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textH2("Phone:", color: primaryColor),
              textH2("+61 400 000 000",
                  color: primaryColor, font_weight: FontWeight.w500),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textH2("Employee ID:", color: primaryColor),
              textH2("F4U-001234",
                  color: primaryColor, font_weight: FontWeight.w500),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOptions(BuildContext context) {
    return Column(
      children: [
        customProfileBox(
          text: "Profile Settings",
          subtext: "Manage your personal details.",
          icon: Icons.person_outline,
          onTap: () => print("Go to Profile Settings"),
        ),
        const SizedBox(height: 12),
        customProfileBox(
          text: "Change Password",
          subtext: "Update your account password.",
          icon: Icons.lock_outline,
          onTap: () => print("Go to Change Password"),
        ),
        const SizedBox(height: 12),
        customProfileBox(
          text: "App Settings",
          subtext: "Manage your app preferences.",
          icon: Icons.settings_outlined,
          onTap: () => print("Go to App Settings"),
        ),
        const SizedBox(height: 12),
        customProfileBox(
          text: "Notification Settings",
          subtext: "Configure your notifications.",
          icon: Icons.notifications_outlined,
          onTap: () => print("Go to Notification Settings"),
        ),
        const SizedBox(height: 12),
        customProfileBox(
          text: "Privacy Policy",
          subtext: "Read our privacy policy.",
          icon: Icons.security_outlined,
          onTap: () => print("Go to Privacy Policy"),
        ),
        const SizedBox(height: 12),
        customProfileBox(
          text: "Log Out",
          subtext: "Sign out of your account.",
          icon: Icons.exit_to_app_outlined,
          onTap: () => _showLogoutConfirmation(context),
        ),
      ],
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: textH1("Log Out", font_size: 20),
          content: subtext("Are you sure you want to log out?",
              font_size: 15, font_weight: FontWeight.w400),
          actions: <Widget>[
            TextButton(
              child: textH2("Cancel", color: primaryColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: textH2("Log Out", color: primaryColor),
              onPressed: () {
                Navigator.of(context).pop();
                Get.to(context, () => const LoginPage());
              },
            ),
          ],
        );
      },
    );
  }
}

Widget customProfileBox({
  required String text,
  required String subtext,
  required VoidCallback onTap,
  IconData? icon,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: primaryColor, size: 26),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textH1(text, font_size: 15, font_weight: FontWeight.w600),
                const SizedBox(height: 4),
                textH3(subtext,
                    color: Colors.grey.shade600,
                    font_size: 13,
                    font_weight: FontWeight.w400),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded,
              size: 16, color: Colors.grey),
        ],
      ),
    ),
  );
}
