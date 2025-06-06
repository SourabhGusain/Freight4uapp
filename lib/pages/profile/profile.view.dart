import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/pages/login/login.view.dart';
import 'package:Freight4u/pages/profile/profile.controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Freight4u/pages/profile/downloaddocumnets/downloaddocumnets.view.dart';

class ProfilePage extends StatefulWidget {
  final Session session;
  const ProfilePage({super.key, required this.session});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _selectedImage;
  String? _savedImagePath;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? path = prefs.getString('profile_image_path');
    if (path != null && File(path).existsSync()) {
      setState(() {
        _savedImagePath = path;
        _selectedImage = File(path);
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final newPath = '${directory.path}/profile_image.jpg';
      final newImage = await File(pickedFile.path).copy(newPath);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image_path', newImage.path);

      setState(() {
        _selectedImage = newImage;
        _savedImagePath = newImage.path;
      });
    }
  }

  Future<void> _removeProfileImage() async {
    if (_savedImagePath != null) {
      File file = File(_savedImagePath!);
      if (await file.exists()) {
        await file.delete();
      }
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile_image_path');

    setState(() {
      _selectedImage = null;
      _savedImagePath = null;
    });
  }

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
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
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
                    child: CircleAvatar(
                      radius: 32,
                      backgroundColor: whiteColor,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : null,
                      child: _selectedImage == null
                          ? Icon(Icons.person, size: 48, color: primaryColor)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        textH2(ctrl.name,
                            color: whiteColor,
                            font_size: 15,
                            font_weight: FontWeight.w700),
                        const SizedBox(height: 6),
                        textH3("Driver / Freight Operator",
                            color: whiteColor,
                            font_size: 11,
                            font_weight: FontWeight.w500),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
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
          text: "Documents",
          subtext: "View & Download Training Files",
          icon: Icons.download_outlined,
          onTap: () =>
              // _showLoadingAndNavigate(
              (
            context,
            (() => DownloaddocumnetsPages(session: session),),
          ),
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

  void _showCustomerDetailsDialog(BuildContext context, FormatController ctrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: primaryColor,
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : null,
                  child: _selectedImage == null
                      ? const Icon(Icons.person,
                          size: 48, color: Colors.white70)
                      : null,
                ),
                const SizedBox(height: 16),
                // if (_selectedImage != null)
                TextButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.upload, color: primaryColor),
                  label: const Text(
                    "Add/Change Profile Image",
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                if (_selectedImage != null)
                  TextButton.icon(
                    onPressed: _removeProfileImage,
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.redAccent),
                    label: const Text(
                      "Remove Profile Image",
                      style: TextStyle(
                          color: Colors.redAccent, fontWeight: FontWeight.w600),
                    ),
                  ),
                const SizedBox(height: 10),
                textH1(ctrl.name, font_size: 22, font_weight: FontWeight.bold),
                const SizedBox(height: 4),
                textH3("Driver / Freight Operator"),
                const Divider(height: 30, thickness: 1),
                _infoTile(Icons.badge, "Employee ID",
                    "${ctrl.name.split(' ').first}${ctrl.userId}"),
                _infoTile(Icons.email, "Email", ctrl.email),
                _infoTile(Icons.phone, "Phone", ctrl.phone),
                _infoTile(Icons.confirmation_num, "License Number",
                    ctrl.licenseNumber),
                _infoTile(
                    Icons.directions_car, "Vehicle Number", ctrl.vehicleNumber),
                const SizedBox(height: 24),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: darkButton(
                    buttonText("Close", color: whiteColor, font_size: 15),
                    primary: primaryColor,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 22, color: primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textH2(title.toUpperCase(),
                    font_size: 12, font_weight: FontWeight.w600),
                const SizedBox(height: 2),
                textH1(value, font_size: 15, font_weight: FontWeight.w500),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: textH1("Log Out", font_size: 20),
        content: subtext("Are you sure you want to log out?", font_size: 15),
        actions: [
          TextButton(
            child: textH2("Cancel", color: primaryColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: textH2("Log Out", color: primaryColor),
            onPressed: () async {
              await widget.session.clearAll();

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => LoginPage(session: widget.session),
                ),
                (Route<dynamic> route) => false,
              );
            },
          )
        ],
      ),
    );
  }
}

Widget customProfileBox({
  required String text,
  required String subtext,
  required IconData icon,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: primaryColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87)),
                Text(subtext,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.black26),
        ],
      ),
    ),
  );
}

void _showLoadingAndNavigate(
    BuildContext context, Widget Function() pageBuilder) async {
  // Show loading dialog with primary color spinner
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(
      child: CircularProgressIndicator(
        color: primaryColor,
      ),
    ),
  );
}
