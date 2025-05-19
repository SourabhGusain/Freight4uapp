import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:Freight4u/helpers/session.dart';
// import 'package:Freight4u/widgets/ui.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/pages/login/login.view.dart';
import 'package:Freight4u/pages/profile/profile.controller.dart';

class ProfilePage extends StatefulWidget {
  final Session session;
  const ProfilePage({super.key, required this.session});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FormatController>.reactive(
      viewModelBuilder: () => FormatController(widget.session),
      onViewModelReady: (controller) => controller.init(),
      builder: (context, ctrl, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xFFF5F7FA),
            body: Column(
              children: [
                _buildHeader(ctrl, context),
                Expanded(
                  child: SingleChildScrollView(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
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

  Widget _buildHeader(FormatController ctrl, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Stack(
        children: [
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
                        // Use data from controller
                        textH2(ctrl.name,
                            color: whiteColor,
                            font_size: 15,
                            font_weight: FontWeight.w700),
                        const SizedBox(height: 6),
                        textH3(
                          "Driver / Freight Operator",
                          color: whiteColor,
                          font_size: 11,
                        ),
                      ],
                    ),
                  ),

                  // Changed icon here from edit to info_outline
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        _showCustomerDetailsDialog(context, ctrl);
                      },
                      icon: const Icon(Icons.info_outline,
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
          backgroundColor: Colors.white,
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
              onPressed: () async {
                // Remove the session key
                bool removed =
                    await widget.session.removeSession('loggedInUser');
                print('Session key removed: $removed');

                // Double check if the session key still exists
                bool stillExists =
                    await widget.session.hasSession('loggedInUser');
                if (!stillExists) {
                  print('Session successfully cleared.');
                } else {
                  print('Session key still exists after removal!');
                }

                // Close the dialog
                Navigator.of(context).pop();

                // Navigate to login page
                Get.to(
                  context,
                  () => LoginPage(session: widget.session),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showCustomerDetailsDialog(BuildContext context, FormatController ctrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.account_circle, color: primaryColor),
              const SizedBox(width: 8),
              textH1(
                "Employee Details",
                font_size: 20,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              const SizedBox(height: 8),
              Row(
                children: [
                  textH2("Name:",
                      font_size: 15,
                      font_weight: FontWeight.w600,
                      overflow: TextOverflow.clip),
                  textH3(" ${ctrl.name}",
                      font_size: 14,
                      font_weight: FontWeight.w500,
                      color: primaryColor),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  textH2("Employee ID:",
                      font_size: 15, font_weight: FontWeight.w600),
                  textH3(" ${ctrl.name.split(' ').first}${ctrl.userId}",
                      font_size: 14,
                      font_weight: FontWeight.w500,
                      color: primaryColor),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  textH2("Email:", font_size: 15, font_weight: FontWeight.w600),
                  textH3(" ${ctrl.email}",
                      font_size: 14,
                      font_weight: FontWeight.w500,
                      color: primaryColor),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  textH2("Phone:", font_size: 15, font_weight: FontWeight.w600),
                  textH3(" ${ctrl.phone}",
                      font_size: 14,
                      font_weight: FontWeight.w500,
                      color: primaryColor),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  textH2("License Number:",
                      font_size: 15, font_weight: FontWeight.w600),
                  textH3(" ${ctrl.licenseNumber}",
                      font_size: 14,
                      font_weight: FontWeight.w500,
                      color: primaryColor),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  textH2("Vehicle Number:",
                      font_size: 15, font_weight: FontWeight.w600),
                  textH3(" ${ctrl.vehicleNumber}",
                      font_size: 14,
                      font_weight: FontWeight.w500,
                      color: primaryColor),
                ],
              ),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: textH2("Close", color: primaryColor),
              ),
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
