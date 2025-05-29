import 'dart:io';
import 'package:Freight4u/pages/dailyform/dailyform.view.dart';
import 'package:Freight4u/pages/employeeform/employeeform.view.dart';
import 'package:Freight4u/pages/hnlpolicy/hnlpolicy.view.dart';
import 'package:Freight4u/pages/profile/profile.view.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:Freight4u/pages/notification/notification.view.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:flutter/material.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/helpers/get.dart';

enum DeclarationAnswer { yes, no }

final Session session = Session();

// Future<dynamic> getNotificationCount(int id) async {
//   NoticeBoardModel obj = NoticeBoardModel();
//   dynamic res = await obj.getCount(id);

//   if (res['ok'] > 0) {
//     return res;
//   }
// }

// Widget getImage(StudentModel obj, {double width = 100}) {
//   if (obj.profile.isEmpty) {
//     return Image.asset(
//       "assets/images/profile.png",
//       width: width,
//       alignment: Alignment.centerLeft,
//     );
//   } else {
//     return Image.network(
//       "$media_url${obj.profile}",
//       alignment: Alignment.centerLeft,
//       width: width,
//     );
//   }
// }

// Widget getProfileImage(StudentModel obj, {double width = 65}) {
//   if (obj.profile.isEmpty) {
//     return Image.asset(
//       "assets/images/profile.png",
//       width: width,
//       fit: BoxFit.contain,
//     );
//   } else {
//     return Image.network(
//       "$media_url${obj.profile}",
//       width: width,
//       fit: BoxFit.contain,
//       errorBuilder: (context, error, stackTrace) {
//         return const Center(child: Icon(Icons.person));
//       },
//     );
//   }
// }

Widget primaryNavBar(
    BuildContext context, String companyName, String logoPath) {
  return Container(
    height: 65,
    width: double.infinity,
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    padding: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      color: primaryColor,
      borderRadius: BorderRadius.circular(50),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        )
      ],
    ),
    child: Row(
      children: [
        // Logo and company name
        Row(
          children: [
            Image.asset(
              logoPath,
              width: 35,
              height: 35,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
            textH2(companyName, color: whiteColor, font_size: 17),
          ],
        ),
        const Spacer(),

        IconButton(
          icon:
              const Icon(Icons.notifications_none, color: whiteColor, size: 20),
          tooltip: 'Notifications',
          onPressed: () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              ),
            );

            await Future.delayed(const Duration(seconds: 1));
            Navigator.of(context).pop();

            Get.to(context, () => const NotificationPage());
          },
        ),
      ],
    ),
  );
}

Widget secondaryNavBar(BuildContext context, String pageTitle,
    {required VoidCallback onBack}) {
  return Container(
    height: 65,
    decoration: BoxDecoration(
      color: primaryColor,
      borderRadius: BorderRadius.circular(50),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    padding: const EdgeInsets.only(right: 0),
    child: Stack(
      alignment: Alignment.centerRight,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () async {
                    // Show loading dialog with primary color spinner
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      ),
                    );

                    // Wait for 1 second
                    await Future.delayed(const Duration(seconds: 1));

                    // Close the loading dialog
                    Navigator.of(context).pop();

                    // Then call the original onBack callback
                    onBack();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: whiteColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: primaryColor,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                textH2(pageTitle, color: whiteColor, font_size: 15),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

Widget customBox({
  required String text,
  required String subtext,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: whiteColor,
        border: Border.all(
          color: blackColor,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textH2(
              text,
              font_size: 16.0,
              font_weight: FontWeight.bold,
            ),
            const SizedBox(height: 3),
            textH2(
              subtext,
              font_size: 12.0,
              font_weight: FontWeight.w500,
              color: const Color.fromARGB(255, 88, 88, 88),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget customTypeSelector({
  required BuildContext context,
  required String text,
  required List<String> dropdownTypes,
  required String selectedValue,
  required Function(String) onChanged,
  String? hintText,
  double dropdownfontsize = 16.0,
}) {
  return GestureDetector(
    onTap: () {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                textH1(
                  text,
                  font_size: 16,
                  font_weight: FontWeight.w500,
                  color: blackColor,
                ),
                const SizedBox(height: 15),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dropdownTypes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final dropdownType = dropdownTypes[index];
                    final isSelected = dropdownType == selectedValue;

                    return InkWell(
                      onTap: () {
                        onChanged(dropdownType);
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color.fromARGB(255, 237, 244, 255)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? const Color.fromARGB(255, 0, 123, 255)
                                : Colors.grey.shade300,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: textH3(
                                dropdownType,
                                font_size: dropdownfontsize,
                                font_weight: isSelected
                                    ? FontWeight.w500
                                    : FontWeight.w400,
                                color: isSelected
                                    ? const Color.fromARGB(255, 0, 123, 255)
                                    : Colors.black87,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: primaryColor,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
    },
    child: InputDecorator(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: textH3(
              selectedValue.isNotEmpty
                  ? selectedValue
                  : (hintText ?? 'Select an option'),
              color: blackColor,
              font_size: 15,
              font_weight: FontWeight.w400,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    ),
  );
}

Widget customTypeBreakSelector({
  required BuildContext context,
  required String text,
  required List<String> dropdownTypes,
  String? selectedValue,
  String? hintText,
  Function(String)? onChanged,
}) {
  return StatefulBuilder(
    builder: (context, setModalState) {
      String selectedDropdownType = selectedValue ?? '';

      return GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            backgroundColor: Colors.white,
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    textH1(
                      text,
                      font_size: 20,
                      font_weight: FontWeight.w500,
                      color: blackColor,
                    ),
                    const SizedBox(height: 12),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: dropdownTypes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final dropdownType = dropdownTypes[index];
                        final isSelected = dropdownType == selectedDropdownType;

                        return InkWell(
                          onTap: () {
                            setModalState(() {
                              selectedDropdownType = dropdownType;
                            });

                            Navigator.pop(context);

                            if (onChanged != null) {
                              onChanged(dropdownType);
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color.fromARGB(255, 237, 244, 255)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? const Color.fromARGB(255, 0, 123, 255)
                                    : Colors.grey.shade300,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                textH3(
                                  dropdownType,
                                  font_size: 16,
                                  font_weight: isSelected
                                      ? FontWeight.w500
                                      : FontWeight.w400,
                                  color: isSelected
                                      ? const Color.fromARGB(255, 0, 123, 255)
                                      : Colors.black87,
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle,
                                    color: primaryColor,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: InputDecorator(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textH3(
                selectedValue?.isNotEmpty == true
                    ? selectedValue!
                    : (hintText ?? 'Select an option'),
                color: const Color.fromARGB(255, 54, 54, 54),
                font_size: 15,
                font_weight: FontWeight.w400,
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      );
    },
  );
}

class CustomDeclarationBox extends StatelessWidget {
  final String text;
  final DeclarationAnswer? selectedAnswer;
  final Function(DeclarationAnswer?) onChanged;

  const CustomDeclarationBox({
    Key? key,
    required this.text,
    required this.selectedAnswer,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: blackColor,
          width: 0.8,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: textH3(
                text,
                font_size: 12,
                font_weight: FontWeight.w400,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  textH3("Yes", font_weight: FontWeight.w600),
                  Checkbox(
                    value: selectedAnswer == DeclarationAnswer.yes,
                    onChanged: (checked) {
                      onChanged(checked == true ? DeclarationAnswer.yes : null);
                    },
                    activeColor: primaryColor,
                    checkColor: whiteColor,
                    side: const BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  textH3("No", font_weight: FontWeight.w600),
                  Checkbox(
                    value: selectedAnswer == DeclarationAnswer.no,
                    onChanged: (checked) {
                      onChanged(checked == true ? DeclarationAnswer.no : null);
                    },
                    activeColor: primaryColor,
                    checkColor: whiteColor,
                    side: const BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildCommentTextField({
  TextEditingController? controller,
  String hintText = "Enter your comment...",
  int minLines = 6,
  int? maxLines = 10,
  Color fillColor = Colors.white,
  Color borderColor = Colors.grey,
  Color focusedBorderColor = Colors.black, // or your blackColor
}) {
  return TextField(
    controller: controller,
    minLines: minLines,
    maxLines: maxLines,
    keyboardType: TextInputType.multiline,
    decoration: InputDecoration(
      hintText: hintText,
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: borderColor,
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: focusedBorderColor,
          width: 1,
        ),
      ),
      filled: true,
      fillColor: fillColor,
    ),
  );
}

// Widget textField(String labelText,
//     {TextEditingController? controller,
//     String? hintText,
//     Function? validator,
//     TextInputType keyboardType = TextInputType.text,
//     int? maxLength,
//     String prefixText = "",
//     bool isPassword = false,
//     bool readOnly = false,
//     Function(String)? onChanged,
//     Function()? onTap}) {
//   return TextFormField(
//     validator: (text) {
//       if (validator != null) {
//         return validator(text);
//       }
//       return null;
//     },
//     controller: controller,
//     keyboardType: keyboardType,
//     maxLength: maxLength,
//     obscureText: isPassword,
//     readOnly: readOnly,
//     onChanged: onChanged,
//     onTap: onTap,
//     decoration: InputDecoration(
//         counterText: "",
//         prefixText: prefixText, // Prefix text
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(5),
//         ),
//         labelText: labelText,
//         hintText: hintText,
//         hintStyle: const TextStyle(fontWeight: FontWeight.w400)),
//   );
// }

// Widget darkButton(Widget text,
//     {Color primary = primaryColor,
//     Function? onPressed,
//     double borderRadius = 5}) {
//   return ElevatedButton(
//     onPressed: () {
//       if (onPressed != null) {
//         onPressed();
//       }
//     },
//     style: ElevatedButton.styleFrom(
//       foregroundColor: whiteColor,
//       backgroundColor: primary, // Background color
//       shadowColor: primary.withOpacity(0.5), // Shadow color
//       elevation: 0, // Shadow elevation
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(borderRadius),
//       ),
//     ),
//     child: text,
//   );
// }

// Widget outlineButton(Widget text,
//     {Color primary = primaryColor,
//     double border_radius = 5,
//     double width = 1,
//     Function? onPressed}) {
//   return OutlinedButton(
//     onPressed: () {
//       if (onPressed != null) {
//         onPressed();
//       }
//     },
//     style: OutlinedButton.styleFrom(
//       foregroundColor: primary, // Background color
//       elevation: 5, // Shadow elevation
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(border_radius),
//       ),
//       side: BorderSide(
//         color: primary, // Set disabled border color here
//         width: width, // Set border width here
//       ),
//     ),
//     child: text,
//   );
// }

Widget buttonIconText(Widget text,
    {Color primary = primaryColor,
    IconData? icon,
    double border_radius = 5,
    Function? onPressed}) {
  return TextButton.icon(
    onPressed: () {
      if (onPressed != null) {
        onPressed();
      }
    },
    icon: Icon(
      icon,
      size: 18.0,
    ),
    style: OutlinedButton.styleFrom(
      foregroundColor: primary, // Background color
      elevation: 5, // Shadow elevation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(border_radius),
      ),
      side: BorderSide(
        color: primary, // Set disabled border color here
        width: 1, // Set border width here
      ),
    ),
    label: text,
  );
}

Widget buttonIcon(IconData icon,
    {Color primary = primaryColor,
    double border_radius = 5,
    Function? onPressed}) {
  return IconButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary, // Background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(border_radius),
        ),
        side: BorderSide(
          color: primary, // Set disabled border color here
          width: 1, // Set border width here
        ),
      ),
      onPressed: () {
        if (onPressed != null) {
          onPressed();
        }
      },
      icon: Icon(
        icon,
        size: 18.0,
      ));
  // TextButton.icon(

  //   icon: ,
  //   style: OutlinedButton.styleFrom(
  //     foregroundColor: primary, // Background color
  //     elevation: 5, // Shadow elevation
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(border_radius),
  //     ),
  //     side: BorderSide(
  //       color: primary, // Set disabled border color here
  //       width: 1, // Set border width here
  //     ),
  //   ),
  //   label: text,
  // );
}

// Widget buttonText(String text,
//     {bool isLoading = false,
//     Color color = Colors.white,
//     double font_size = 18}) {
//   if (isLoading) {
//     return Get.loading();
//   }
//   return textH2(text,
//       font_size: font_size,
//       color: color,
//       font_weight: FontWeight.w500,
//       overflow: TextOverflow.clip);
// }

// Widget menuTile(IconData icon, String title, {Function? function}) {
//   return ListTile(
//     onTap: () {
//       if (function != null) {
//         // scaffoldKey.currentState?.openDrawer();
//         function();
//       }
//     },
//     leading: Icon(icon),
//     title: textH3(title, font_size: 14, font_weight: FontWeight.w600),
//   );
// }

// Widget customerDrawer(context, StudentModel obj) {
//   return Drawer(
//     shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
//     child: SingleChildScrollView(
//       child: Column(
//         // padding: EdgeInsets.zero,
//         children: <Widget>[
//           SizedBox(
//             width: double.infinity,
//             child: DrawerHeader(
//               decoration: const BoxDecoration(
//                 color: primaryColor,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   getImage(obj, width: 50),
//                   const SizedBox(height: 10),
//                   textH1(obj.name, color: Colors.white),
//                   const SizedBox(height: 3),
//                   subtext("+91 ${obj.mobile}",
//                       font_size: 14, color: Colors.white),
//                 ],
//               ),
//             ),
//           ),
//           // menuTile(Icons.home, "Home", function: () {
//           //   Get.back(context);
//           //   Get.to(context, () => HomePage(obj));
//           // }),
//           // const Divider(thickness: 0.5, height: 1),
//           menuTile(Icons.menu_book_rounded, "Management Affairs", function: () {
//             Get.back(context);
//             Get.to(context, () => ManagementAffairsPage(obj));
//           }),
//           const Divider(thickness: 0.5, height: 1),
//           menuTile(Icons.menu_book_rounded, "Current Affairs", function: () {
//             Get.back(context);
//             Get.to(context, () => CurrentAffairsPage(obj));
//           }),
//           const Divider(thickness: 0.5, height: 1),
//           menuTile(Icons.menu_book_rounded, "Judgments", function: () {
//             Get.back(context);
//             Get.to(context, () => JudgementPage(obj));
//           }),
//           const Divider(thickness: 0.5, height: 1),
//           menuTile(Icons.menu_book_rounded, "Acts", function: () {
//             Get.back(context);
//             Get.to(context, () => ActsPage(obj));
//           }),
//           const Divider(thickness: 0.5, height: 1),
//           menuTile(Icons.question_answer, "MCQ", function: () {
//             Get.back(context);
//             Get.to(context, () => MCQListPage(obj));
//           }),
//           const Divider(thickness: 0.5, height: 1),
//           menuTile(Icons.payment, "Fees", function: () {
//             Get.back(context);
//             Get.to(context, () => FeesPage(obj));
//           }),
//           const Divider(thickness: 0.5, height: 1),
//           menuTile(Icons.book, "Exams", function: () {
//             Get.back(context);
//             Get.to(context, () => ExamLinkPage(obj));
//           }),
//           const Divider(thickness: 0.5, height: 1),
//           menuTile(Icons.calendar_month, "Attendance", function: () {
//             Get.back(context);
//             Get.to(context, () => AttendanceReportPage(obj));
//           }),
//           const Divider(thickness: 0.5, height: 1),
//           menuTile(Icons.open_in_browser, "Other Links", function: () {
//             Get.back(context);
//             Get.to(context, () => OtherLinkPage(obj));
//           }),
//           const Divider(thickness: 0.5, height: 1),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: ListTile(
//               leading: const Icon(
//                 Icons.logout,
//                 color: Colors.red,
//               ),
//               title: textH3("Logout",
//                   color: Colors.red,
//                   font_size: 15,
//                   font_weight: FontWeight.w600),
//               onTap: () {
//                 Get.logout(context);
//               },
//             ),
//           )
//         ],
//       ),
//     ),
//   );
// }

Widget customBottomNavigationBar({
  required BuildContext context,
  required int selectedIndex,
}) {
  List<BottomNavigationBarItem> items = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.today, size: 20),
      label: 'Daily',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.dashboard, size: 20),
      label: 'HNL',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.people, size: 20),
      label: 'Employee',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person, size: 20),
      label: 'profile',
    ),
  ];

  Future<void> _navigateWithLoading(
    BuildContext context,
    Widget Function() pageBuilder,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(
          color: primaryColor, // 👈 set your desired color here
        ),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 500));

    Navigator.of(context, rootNavigator: true).pop();

    Get.toWithNoBack(context, pageBuilder);
  }

  return BottomNavigationBar(
    items: items,
    backgroundColor: whiteColor,
    selectedItemColor: primaryColor,
    unselectedItemColor: Colors.grey,
    currentIndex: selectedIndex,
    onTap: (int index) {
      switch (index) {
        case 0:
          _navigateWithLoading(context, () => DailyformPage(session: session));
          break;
        case 1:
          _navigateWithLoading(context, () => HnlpolicyPage(session: session));
          break;
        case 2:
          _navigateWithLoading(context, () => EmployeePage(session: session));
          break;
        case 3:
          _navigateWithLoading(context, () => ProfilePage(session: session));
          break;
      }
    },
    type: BottomNavigationBarType.fixed,
    selectedLabelStyle: const TextStyle(fontSize: 12.0),
    unselectedLabelStyle: const TextStyle(fontSize: 10.0),
  );
}

// Widget bottomBar(context, indexSelected, StudentModel obj) {
//   List<TabItem> items = const [
//     TabItem(
//       icon: Icons.home,
//       title: 'Home',
//     ),
//     TabItem(
//       icon: Icons.notifications,
//       title: 'Notifications',
//     ),
//     TabItem(
//       icon: Icons.post_add,
//       title: 'Feeds',
//     ),
//     TabItem(
//       icon: Icons.wallet,
//       title: 'Fees',
//     ),
//     TabItem(
//       icon: Icons.account_box,
//       title: 'ID Card',
//     ),
//   ];

//   return BottomBarInspiredOutside(
//     items: items,
//     backgroundColor: primaryColor,
//     color: whiteColor,
//     colorSelected: Colors.white,
//     indexSelected: indexSelected,
//     onTap: (int index) {
//       if (index == 0) {
//         Get.toWithNoBack(context, () => HomePage(obj, index: index));
//       } else if (index == 1) {
//         Get.toWithNoBack(context, () {
//           NoticeBoardModel notic = NoticeBoardModel();
//           notic.markAsSeenAllSeen(obj.id);
//           return NotificationPage(obj);
//         });
//       } else if (index == 2) {
//         Get.toWithNoBack(context, () => FeedsPage(obj, index: index));
//       } else if (index == 3) {
//         Get.toWithNoBack(context, () => FeesPage(obj));
//       } else if (index == 4) {
//         Get.toWithNoBack(context, () => ProfilePage(obj, index: index));
//       }
//     },
//     top: -28,
//     animated: false,
//     itemStyle: ItemStyle.circle,
//     chipStyle: const ChipStyle(
//         notchSmoothness: NotchSmoothness.smoothEdge, background: primaryColor),
//   );
// }

// Widget facultyBottomBar(context, indexSelected, StudentModel obj,
//     {Function? onTap}) {
//   List<TabItem> items = const [
//     TabItem(
//       icon: Icons.home,
//       title: 'Home',
//     ),
//     TabItem(
//       icon: Icons.edit_note,
//       title: 'Lecture',
//     ),
//     TabItem(
//       icon: Icons.post_add,
//       title: 'Feeds',
//     ),
//     TabItem(
//       icon: Icons.work_off,
//       title: 'Leave',
//     ),
//     TabItem(
//       icon: Icons.notifications,
//       title: 'Notice',
//     ),
//   ];

//   return BottomBarInspiredOutside(
//     items: items,
//     backgroundColor: primaryColor,
//     color: whiteColor,
//     colorSelected: Colors.white,
//     indexSelected: indexSelected,
//     onTap: (int index) {
//       if (index == 0) {
//         Get.toWithNoBack(context, () => FacultyHomePage(obj, index: index));
//       } else if (index == 1) {
//         if (onTap != null) {
//         } else {
//           Get.toWithNoBack(context, () => LectureOption(obj, index: 1));
//         }
//       } else if (index == 2) {
//         Get.toWithNoBack(context, () => FacultyFeedsPage(obj, index: index));
//       } else if (index == 3) {
//         Get.toWithNoBack(context, () => LeaveRequestPage(obj, index: 3));
//       } else if (index == 4) {
//         NoticeBoardModel notic = NoticeBoardModel();
//         notic.markAsSeenEmpAllSeen(obj.id).then((res) {
//           Get.back(context);
//           if (res['ok'] > 0) {
//             Get.to(context, () => FacNotificationPage(obj, index: 4));
//           } else {
//             Get.viewMessage(context, res['error']);
//           }
//         });
//         Get.toWithNoBack(context, () => FacNotificationPage(obj, index: index));
//       }
//     },
//     top: -28,
//     animated: false,
//     itemStyle: ItemStyle.circle,
//     chipStyle: const ChipStyle(
//         notchSmoothness: NotchSmoothness.smoothEdge, background: primaryColor),
//   );
// }

// Widget iconWithTextSmall(IconData icon, String text,
//     {double size = 22,
//     String? textOpt,
//     Color color = blackColor,
//     Function? function,
//     dynamic args}) {
//   return GestureDetector(
//     onTap: () {
//       if (function != null) {
//         function();
//       }
//     },
//     child: Container(
//       padding: const EdgeInsets.symmetric(horizontal: 6),
//       decoration: BoxDecoration(
//         color: const Color.fromARGB(255, 247, 201, 141),
//         borderRadius: BorderRadius.circular(5),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           textOpt == null
//               ? Container(
//                   decoration: BoxDecoration(
//                     color: const Color.fromARGB(255, 247, 201,
//                         141), //Color.fromARGB(255, 255, 232, 201),

//                     borderRadius: BorderRadius.circular(
//                         50), // Adjust the radius as needed
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Color.fromARGB(255, 247, 201, 141),
//                         spreadRadius: 1,
//                         blurRadius: 1,
//                         offset: Offset(0,
//                             0), // Adjust the vertical offset to move the shadow down
//                       ),
//                     ],
//                   ),
//                   child: Icon(
//                     icon,
//                     color: primaryColor,
//                   ),
//                 )
//               : textH3(textOpt,
//                   color: color,
//                   text_align: TextAlign.center,
//                   font_size: 18,
//                   font_weight: FontWeight.bold),
//           const SizedBox(height: 5),
//           textH3(text,
//               color: Colors.black,
//               text_align: TextAlign.center,
//               font_size: 11,
//               font_weight: FontWeight.w500)
//         ],
//       ),
//     ),
//   );
// }

class ThumbsUpButton extends StatelessWidget {
  final IconData icon;
  final int count;
  final VoidCallback onPressed;

  ThumbsUpButton({
    required this.icon,
    required this.count,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(icon, size: 20),
          onPressed: onPressed,
        ),
        // textH3(count.toString(), font_size: 12)
      ],
    );
  }
}

class PostProvider extends ChangeNotifier {
  List<File> dataList = [];

  void deleteData(int index) async {
    dataList.removeAt(index);
    notifyListeners();
  }

  void clearData() async {
    dataList.clear();
    notifyListeners();
  }
}
