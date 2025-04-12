import 'dart:convert';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/widgets/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Get {
  static String sessionKey() => "loggedInUser";

  static void itemTapped(BuildContext context, int index, int current) {
    // if (index == 0) {
    //   Get.toWithNoBack(context, () => HomePage(lastIndex: current));
    // } else if (index == 1) {
    //   Get.toWithNoBack(context, () => WalletPage(lastIndex: current));
    // } else if (index == 2) {
    //   Get.toWithNoBack(context, () => TransactionsPage(lastIndex: current));
    // } else if (index == 3) {
    //   Get.toWithNoBack(context, () => ProfilePage(lastIndex: current));
    // }
  }

  static void to(BuildContext context, Widget Function() toPage,
      {Function? then}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => toPage()))
        .then((value) {
      if (then != null) {
        then();
      }
    });
  }

  static void toWithNoBack(BuildContext context, Widget Function() toPage) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => toPage()),
        (Route<dynamic> route) => false);
  }

  static void back(BuildContext context) {
    Navigator.of(context).pop();
  }

  static bool isBack(BuildContext context) {
    return Navigator.of(context).canPop();
  }

  static void logout(BuildContext context) {
    LoggedInUserActivity.set(false);
    Session obj = Session();
    // obj.removeSession(Get.sessionKey());
    obj.removeSession("loggedInUserKey");
  }

  static void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static void viewMessage(context, message,
      {Function? onClose, String label = "Close"}) {
    final snackBar = SnackBar(
      content: Text(message.toString()),
      action: SnackBarAction(
        label: label,
        onPressed: () {
          if (onClose != null) {
            onClose();
          }
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Widget loading() {
    return const SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
        strokeWidth: 2,
      ),
    );
  }

  static Widget loadingAnimated() {
    return Container(
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.black, width: .8),
        color: Colors.grey[300],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
            color: Colors.grey[300],
          ),
        ),
      ),
    );
  }

  static String dateTimeToDate(String date) {
    String date0 = date;
    try {
      DateTime dateTime = DateTime.parse(date);

      date0 = "${dateTime.day}-${dateTime.month}-${dateTime.year}";
    } catch (err) {}
    return date0;
  }

  static String dateTimeToDateAndTime(String date) {
    String date0 = date;

    try {
      String timeZone = "Asia/Kolkata"; // Set your desired timezone

      DateTime dateTime = DateTime.parse(date);

      // Initialize timezone package (do this once in your app)
      tz.initializeTimeZones();
      tz.Location location =
          tz.getLocation(timeZone); // Set your desired timezone
      tz.TZDateTime tzDateTime = tz.TZDateTime.from(dateTime, location);

      // Format the date in the desired timezone
      DateFormat dateFormat = DateFormat("dd-MM-yyyy hh:mm a");
      date0 = dateFormat.format(tzDateTime);
    } catch (err) {
      print("Error: $err");
    }

    return date0;
  }

  // static Future<List<StudentModel>?> getLoggedInUser() async {
  //   Session objSession = Session();
  //   return await objSession.hasSession(Get.sessionKey()).then((value) async {
  //     if (value == true) {
  //       return await objSession.getSession(Get.sessionKey()).then((data) async {
  //         StudentModel retailerModel = StudentModel();
  //         List<StudentModel>? res;
  //         if (data != null) {
  //           res = retailerModel.fromJson([json.decode(data)]);
  //         }
  //         return res;
  //       });
  //     }
  //     return null;
  //   });
  // }

  static Future<bool> isSessionExists() async {
    Session objSession = Session();
    return await objSession.hasSession(Get.sessionKey());
  }

  static Future<void> openUrl(context, url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      Get.viewMessage(context, 'Could not launch $url');
    }
  }

  static bool snapshotResult(snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasData) {
        return true;
      }
    }

    return false;
  }

  static bool snapshotNotFound(snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      if (!snapshot.hasData || snapshot.hasError) {
        return true;
      }
    }

    return false;
  }

  static Widget notFound(
      {String title = "Not Found!",
      String msg = "It seems record not found!"}) {
    return basicPadding(
      Container(
          height: 100,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 199, 121),
            borderRadius: BorderRadius.circular(5),
          ),
          child: basicPadding(
              SizedBox(
                width: ResponsiveApp().width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textH2(title, overflow: TextOverflow.clip),
                    subtext(msg,
                        color: const Color(0xFF3D3B3B),
                        overflow: TextOverflow.clip),
                  ],
                ),
              ),
              horizontalPadding: 20)),
    );
  }

  static Widget loadingRecords(
      {String title = "Loading...",
      String msg = "Fetching records from server!"}) {
    return basicPadding(
      Container(
          height: 100,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 199, 121),
            borderRadius: BorderRadius.circular(5),
          ),
          child: basicPadding(
              SizedBox(
                width: ResponsiveApp().width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textH2(title, overflow: TextOverflow.clip),
                    subtext(msg,
                        color: const Color(0xFF3D3B3B),
                        overflow: TextOverflow.clip),
                  ],
                ),
              ),
              horizontalPadding: 20)),
    );
  }
}

class ResponsiveApp {
  static double _height = 0;
  static double _width = 0;

  double get height => _height;
  double get width => _width;

  static void set(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
  }
}

class LoggedInUserActivity {
  static bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  static void set(bool value) {
    _isLoggedIn = value;
  }
}

dynamic dictValidate(dynamic map, key, value,
    {String valValidate = "", Function? parse}) {
  try {
    if (map.containsKey(key)) {
      if (map[key] != null && map[key] != valValidate) {
        if (parse != null) {
          return parse("${map[key]}");
        } else {
          return map[key];
        }
      } else {
        return value;
      }
    } else {
      return value;
    }
  } catch (err) {
    return value;
  }
}

class TokenHandler {
  static String _token = "";

  String get token => _token;

  static void set() {
    Session objSession = Session();
    objSession.hasSession(Get.sessionKey()).then((value) async {
      if (value == true) {
        return await objSession.getSession(Get.sessionKey()).then((data) async {
          if (data != null) {
            Map dt = json.decode(data);
            if (dt.containsKey("token")) {
              _token = dt["token"];
            }
          }
        });
      }
      return null;
    });
  }
}

class DeveloperOptionsChecker {
  static const platform = MethodChannel('com.example.developerOptions/check');

  static Future<bool> isDeveloperOptionsEnabled() async {
    try {
      final bool isEnabled =
          await platform.invokeMethod('checkDeveloperOptions');
      return isEnabled;
    } catch (e) {
      print("Failed to check developer options: $e");
      return false;
    }
  }
}

Future<bool> checkForDebugMode() async {
  bool isDeveloperOptionsEnabled =
      await DeveloperOptionsChecker.isDeveloperOptionsEnabled();

  // if (isDeveloperOptionsEnabled) {
  //   return true;
  // } else {
  //   return false;
  // }

  return false;
}
