import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

const space_5 = Gap(5);
const space = Gap(10);
const space_20 = Gap(20);
const space_30 = Gap(30);

Widget basicPadding(Widget widget,
    {double verticalPadding = 10, double horizontalPadding = 10}) {
  return Container(
      padding: EdgeInsets.symmetric(
          vertical: verticalPadding, horizontal: horizontalPadding),
      child: widget);
}

// Widget supportNav() {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       const Icon(Icons.support_agent, color: blackColor),
//       const SizedBox(width: 5),
//       textH3("+91 9837994101")
//     ],
//   );
// }

// Widget homeTopNavBar() {
//   return Container(
//     decoration: const BoxDecoration(color: primaryColor),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Image.asset(
//           'assets/images/cab-dark-logo.png',
//           height: 80.0,
//           width: 100.0,
//           fit: BoxFit.contain,
//         ),
//         supportNav(),
//       ],
//     ),
//   );
// }

// Widget homeSecondTopNavBar(context, String title, String text) {
//   return Container(
//     decoration: const BoxDecoration(color: primaryColor),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         InkWell(
//           child: const Padding(
//             padding: EdgeInsets.only(left: 10),
//             child: Icon(Icons.arrow_back),
//           ),
//           onTap: () {
//             Get.back(context);
//           },
//         ),
//         const SizedBox(width: 10),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             textH3(title),
//             subtext(text),
//           ],
//         ),
//         Expanded(child: Container()),
//         Image.asset(
//           'assets/images/cab-dark-logo.png',
//           height: 80.0,
//           width: 100.0,
//           fit: BoxFit.contain,
//         ),
//       ],
//     ),
//   );
// }

Widget infoBoxWithIcon(Color color, String heading, String title,
    String imagePath, Function() callback) {
  return basicPadding(
    InkWell(
      onTap: callback,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: ResponsiveApp().width * .7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textH2(heading),
                  space_5,
                  subtext(title),
                ],
              ),
            ),
            space_5,
            Image.asset(
              imagePath,
              height: 50.0,
              width: 50.0,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget bulletPoint(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Icon(Icons.circle, size: 8, color: Colors.black),
        space_5,
        Expanded(child: subtext(text)),
      ],
    ),
  );
}

void bottomModelSheet(context, Widget body,
    {bool isScrollControlled = true,
    bool enableDrag = false,
    bool isDismissible = false,
    Function? onClose}) {
  showModalBottomSheet(
    isScrollControlled: isScrollControlled,
    backgroundColor: whiteColor,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
    ),
    context: context,
    builder: (context) => WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SingleChildScrollView(
        child: body,
      ),
    ),
  ).then((value) {
    if (onClose != null) {
      onClose();
    }
  });
}

void loadingModelSheet(
  context, {
  String text = "Loading...",
  bool isScrollControlled = true,
  bool enableDrag = false,
  bool isDismissible = false,
}) {
  showModalBottomSheet(
    isScrollControlled: isScrollControlled,
    backgroundColor: whiteColor,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
    ),
    context: context,
    builder: (context) => SingleChildScrollView(
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: SizedBox(
          height: 100,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Get.loading(),
                const SizedBox(width: 20),
                textH3(text, font_size: 15)
              ]),
        ),
      ),
    ),
  );
}

void confirmationModelSheet(
  context, {
  Function? onPressed,
  bool isScrollControlled = true,
  bool enableDrag = false,
  bool isDismissible = false,
}) {
  showModalBottomSheet(
    isScrollControlled: isScrollControlled,
    backgroundColor: whiteColor,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
    ),
    context: context,
    builder: (context) => SingleChildScrollView(
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: SizedBox(
          height: 150,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textH3("Are you sure, you want to pay?", font_size: 15),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                          child: darkButton(buttonText("Yes"), onPressed: () {
                        if (onPressed != null) {
                          Get.back(context);
                          onPressed();
                        }
                      }, borderRadius: 0)),
                      Expanded(
                          child:
                              outlineButton(buttonText("No", color: blackColor),
                                  onPressed: () {
                        Get.back(context);
                      }, border_radius: 0))
                    ],
                  )
                ]),
          ),
        ),
      ),
    ),
  );
}

void loginAlertModelSheet(
  context, {
  Function? onPressed,
  Function? onNotPressed,
  bool isScrollControlled = true,
  bool enableDrag = false,
  bool isDismissible = false,
}) {
  showModalBottomSheet(
    isScrollControlled: isScrollControlled,
    backgroundColor: whiteColor,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
    ),
    context: context,
    builder: (context) => SingleChildScrollView(
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: SizedBox(
          height: 150,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textH3("To Continue, Please do login!", font_size: 15),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                          child: darkButton(
                              buttonText("Login Now", color: blackColor),
                              onPressed: () {
                        if (onPressed != null) {
                          Get.back(context);
                          onPressed();
                        }
                      }, borderRadius: 0)),
                      Expanded(
                          child: outlineButton(
                              buttonText("Not Now", color: blackColor),
                              onPressed: () {
                        Get.back(context);
                        if (onNotPressed != null) {
                          onNotPressed();
                        }
                      }, border_radius: 0))
                    ],
                  )
                ]),
          ),
        ),
      ),
    ),
  );
}

void onErrorCatchModelSheet(
  context, {
  String text = "Loading...",
  bool isScrollControlled = true,
  bool enableDrag = true,
  bool isDismissible = true,
}) {
  showModalBottomSheet(
    isScrollControlled: isScrollControlled,
    backgroundColor: whiteColor,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
    ),
    context: context,
    builder: (context) => SingleChildScrollView(
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: SizedBox(
          height: 500,
          child: basicPadding(subtext(text, overflow: TextOverflow.clip)),
        ),
      ),
    ),
  );
}
