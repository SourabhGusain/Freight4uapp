import 'package:Freight4u/helpers/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:flutter/material.dart';

Widget textH1(String text,
    {double font_size = 20,
    Color color = blackColor,
    String font_family = "Rubik",
    TextAlign text_align = TextAlign.left,
    TextDecoration text_border = TextDecoration.none,
    FontWeight font_weight = FontWeight.bold,
    TextOverflow overflow = TextOverflow.clip}) {
  return Text(
    text,
    textAlign: text_align,
    style: TextStyle(
      decoration: text_border,
      color: color,
      fontSize: font_size,
      fontFamily: font_family,
      fontWeight: font_weight,
      overflow: overflow,
    ),
  );
}

Widget textH2(String text,
    {double font_size = 15,
    Color color = blackColor,
    String font_family = "Rubik",
    TextAlign text_align = TextAlign.left,
    TextDecoration text_border = TextDecoration.none,
    FontWeight font_weight = FontWeight.w800,
    TextOverflow overflow = TextOverflow.clip}) {
  return Text(
    text,
    textAlign: text_align,
    style: TextStyle(
      decoration: text_border,
      color: color,
      fontSize: font_size,
      fontFamily: font_family,
      fontWeight: font_weight,
      overflow: overflow,
    ),
  );
}

Widget textH3(String text,
    {double font_size = 12,
    Color color = blackColor,
    String font_family = "Rubik",
    TextAlign text_align = TextAlign.left,
    TextDecoration text_border = TextDecoration.none,
    FontWeight font_weight = FontWeight.w700,
    TextOverflow overflow = TextOverflow.clip}) {
  return Text(
    text,
    textAlign: text_align,
    style: TextStyle(
      decoration: text_border,
      color: color,
      fontSize: font_size,
      fontFamily: font_family,
      fontWeight: font_weight,
      overflow: overflow,
    ),
  );
}

Widget subtext(String text,
    {double font_size = 12,
    Color color = whiteGrey,
    String font_family = "Rubik",
    TextAlign text_align = TextAlign.left,
    TextDecoration text_border = TextDecoration.none,
    FontWeight font_weight = FontWeight.w500,
    TextOverflow overflow = TextOverflow.clip,
    int? maxLines}) {
  return Text(
    text,
    textAlign: text_align,
    maxLines: maxLines,
    style: TextStyle(
      decoration: text_border,
      color: color,
      fontSize: font_size,
      fontFamily: font_family,
      fontWeight: font_weight,
      overflow: overflow,
    ),
  );
}

Widget lightText(String text,
    {double font_size = 12,
    Color color = blackColor,
    String font_family = "Rubik",
    TextAlign text_align = TextAlign.left,
    TextDecoration text_border = TextDecoration.underline,
    FontWeight font_weight = FontWeight.w400,
    TextOverflow overflow = TextOverflow.clip}) {
  return Text(
    text,
    textAlign: text_align,
    style: TextStyle(
      decoration: text_border,
      color: color,
      fontSize: font_size,
      fontFamily: font_family,
      fontWeight: font_weight,
      overflow: overflow,
    ),
  );
}

Widget linkText(String text,
    {double font_size = 11,
    Color color = Colors.blueAccent,
    String font_family = "Rubik",
    TextAlign text_align = TextAlign.left,
    TextDecoration text_border = TextDecoration.underline,
    FontWeight font_weight = FontWeight.w200,
    TextOverflow overflow = TextOverflow.clip}) {
  return Text(
    text,
    textAlign: text_align,
    style: TextStyle(
      decorationColor: color,
      decoration: text_border,
      color: color,
      fontSize: font_size,
      fontFamily: font_family,
      fontWeight: font_weight,
      overflow: overflow,
    ),
  );
}

Widget textField(String labelText,
    {TextEditingController? controller,
    String? hintText,
    Function? validator,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    String prefixText = "",
    bool isPassword = false,
    bool readOnly = false,
    Function(String)? onChanged,
    Function()? onTap}) {
  return TextFormField(
    validator: (text) {
      if (validator != null) {
        return validator(text);
      }
      return null;
    },
    controller: controller,
    keyboardType: keyboardType,
    maxLength: maxLength,
    obscureText: isPassword,
    readOnly: readOnly,
    onChanged: onChanged,
    onTap: onTap,
    decoration: InputDecoration(
      counterText: "",
      prefixText: prefixText, // Prefix text
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      labelText: labelText,
      hintText: hintText,
      hintStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          color: Color.fromARGB(255, 108, 108, 108)),
    ),
  );
}

Widget darkButton(Widget text,
    {Color primary = primaryColor,
    Function? onPressed,
    double borderRadius = 5}) {
  return ElevatedButton(
    onPressed: () {
      if (onPressed != null) {
        onPressed();
      }
    },
    style: ElevatedButton.styleFrom(
      foregroundColor: whiteColor,
      backgroundColor: primary, // Background color
      shadowColor: primary.withOpacity(0.5), // Shadow color
      elevation: 0, // Shadow elevation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
    child: text,
  );
}

Widget outlineButton(Widget text,
    {Color primary = primaryColor,
    double border_radius = 5,
    double width = 1,
    Function? onPressed}) {
  return OutlinedButton(
    onPressed: () {
      if (onPressed != null) {
        onPressed();
      }
    },
    style: OutlinedButton.styleFrom(
      foregroundColor: primary, // Background color
      elevation: 5, // Shadow elevation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(border_radius),
      ),
      side: BorderSide(
        color: primary, // Set disabled border color here
        width: width, // Set border width here
      ),
    ),
    child: text,
  );
}

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

Widget darkButtonIconText(Widget text,
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
    style: ElevatedButton.styleFrom(
      backgroundColor: whiteColor,
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
}

Widget buttonText(String text,
    {bool isLoading = false, Color color = blackColor, double font_size = 18}) {
  if (isLoading) {
    return Get.loading();
  }
  return textH2(text,
      font_size: font_size,
      color: color,
      font_weight: FontWeight.w500,
      overflow: TextOverflow.clip);
}

String? phoneValidator(String? val) {
  if (val != null) {
    if (val.isEmpty) {
      return "error_empty";
    } else if (val.length != 10) {
      return "mobile_error";
    }
  } else {
    return "error_empty";
  }
  return null;
}

String? emptyValidator(String? val) {
  if (val != null) {
    if (val.isEmpty) {
      return "error_empty";
    }
  } else {
    return "error_empty";
  }
  return null;
}

String? emailValidator(String? val) {
  if (val != null) {
    if (val.isEmpty) {
      return 'Email can not be empty!';
    } else if (!val.contains('@') && !val.contains('.com')) {
      return 'Please enter valid email';
    }
  } else {
    return 'Email can not be empty!';
  }
  return null;
}

Widget calendarDateField({
  required BuildContext context,
  required String label,
  required TextEditingController controller,
  String hintText = "Select a date",
}) {
  return GestureDetector(
    onTap: () async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: primaryColor, // Your app's primary color
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child!,
          );
        },
      );

      if (pickedDate != null) {
        String formattedDate = "${pickedDate.day.toString().padLeft(2, '0')}/"
            "${pickedDate.month.toString().padLeft(2, '0')}/"
            "${pickedDate.year}";
        controller.text = formattedDate;
      }
    },
    child: AbsorbPointer(
      child: SizedBox(
        height: 50,
        child: textField(
          label,
          controller: controller,
          hintText: hintText,
        ),
      ),
    ),
  );
}

// Widget calendarTimeField({
//   required BuildContext context,
//   required String label,
//   required TextEditingController controller,
//   String hintText = "Select time",
// }) {
//   return GestureDetector(
//     onTap: () async {
//       TimeOfDay? pickedTime = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.now(),
//         initialEntryMode: TimePickerEntryMode.input, // 👈 Force input mode
//         builder: (context, child) {
//           return Theme(
//             data: Theme.of(context).copyWith(
//               timePickerTheme: TimePickerThemeData(
//                 backgroundColor: Colors.white,
//                 hourMinuteColor:
//                     MaterialStateColor.resolveWith((states) => Colors.white),
//               ),
//               colorScheme: ColorScheme.light(
//                 primary: primaryColor,
//                 onPrimary: Colors.white,
//                 onSurface: Colors.black,
//               ),
//             ),
//             child: child!,
//           );
//         },
//       );

//       if (pickedTime != null) {
//         final now = DateTime.now();
//         final dt = DateTime(
//             now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
//         String formattedTime = TimeOfDay.fromDateTime(dt).format(context);
//         controller.text = formattedTime;
//       }
//     },
//     child: AbsorbPointer(
//       child: SizedBox(
//         height: 50,
//         child: textField(
//           label,
//           controller: controller,
//           hintText: hintText,
//         ),
//       ),
//     ),
//   );
// }

Widget calendarTimeField({
  required BuildContext context,
  required String label,
  required TextEditingController controller,
  String hintText = "Select time",
}) {
  return GestureDetector(
    onTap: () async {
      TimeOfDay selectedTime = TimeOfDay.now();

      await showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        isScrollControlled: true,
        builder: (BuildContext builder) {
          return Container(
            padding: const EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
              bottom: 32,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top bar with Cancel and Done buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        child: textH2(
                          'Cancel',
                          font_weight: FontWeight.w500,
                          font_size: 15,
                          color: primaryColor,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      textH2(
                        'Select Time',
                        font_weight: FontWeight.w500,
                        font_size: 16,
                        color: primaryColor,
                      ),
                      CupertinoButton(
                        child: textH2(
                          'Done',
                          font_weight: FontWeight.w500,
                          font_size: 15,
                          color: primaryColor,
                        ),
                        onPressed: () {
                          final formattedTime24 =
                              '${selectedTime.hour.toString().padLeft(2, '0')}:'
                              '${selectedTime.minute.toString().padLeft(2, '0')}';
                          controller.text = formattedTime24;
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 250,
                    child: CupertinoTheme(
                      data: const CupertinoThemeData(
                        primaryColor: primaryColor,
                        brightness: Brightness.light,
                      ),
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.time,
                        use24hFormat: false,
                        initialDateTime: DateTime(
                          0,
                          0,
                          0,
                          selectedTime.hour,
                          selectedTime.minute,
                        ),
                        onDateTimeChanged: (DateTime newDateTime) {
                          selectedTime = TimeOfDay.fromDateTime(newDateTime);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
    child: AbsorbPointer(
      child: SizedBox(
        height: 50,
        child: textField(
          label,
          controller: controller,
          hintText: hintText,
        ),
      ),
    ),
  );
}

// Widget calendarTimeField({
//   required BuildContext context,
//   required String label,
//   required TextEditingController controller,
//   String hintText = "Select time",
// }) {
//   return GestureDetector(
//     onTap: () async {
//       int selectedHour = TimeOfDay.now().hourOfPeriod;
//       int selectedMinute = TimeOfDay.now().minute;
//       String selectedPeriod =
//           TimeOfDay.now().period == DayPeriod.am ? 'AM' : 'PM';

//       // const primaryColor = Colors.purple; // ✅ your primary color
//       const unselectedColor = Color.fromARGB(255, 60, 60, 60);
//       const backgroundColor = Colors.white;

//       await showModalBottomSheet(
//         context: context,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         isScrollControlled: true,
//         builder: (BuildContext builder) {
//           return Container(
//             padding: const EdgeInsets.only(
//               top: 16,
//               left: 16,
//               right: 16,
//               bottom: 32,
//             ),
//             decoration: const BoxDecoration(
//               color: backgroundColor,
//               borderRadius: BorderRadius.vertical(
//                 top: Radius.circular(20),
//               ),
//             ),
//             child: SafeArea(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       CupertinoButton(
//                         child: textH2(
//                           'Cancel',
//                           font_weight: FontWeight.w500,
//                           font_size: 15,
//                           color: primaryColor,
//                         ),
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                       textH2(
//                         'Select Time',
//                         font_weight: FontWeight.w500,
//                         font_size: 16,
//                         color: primaryColor,
//                       ),
//                       CupertinoButton(
//                         child: textH2(
//                           'Done',
//                           font_weight: FontWeight.w500,
//                           font_size: 15,
//                           color: primaryColor,
//                         ),
//                         onPressed: () {
//                           final hour = selectedPeriod == 'PM'
//                               ? (selectedHour % 12) + 12
//                               : selectedHour % 12;
//                           final time =
//                               TimeOfDay(hour: hour, minute: selectedMinute);
//                           controller.text = time.format(context);
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   // The custom wheel picker
//                   SizedBox(
//                     height: 250,
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: _buildWheel(
//                             context,
//                             1,
//                             12,
//                             selectedHour,
//                             (index) => selectedHour = index + 1,
//                             primaryColor,
//                             unselectedColor,
//                           ),
//                         ),
//                         Expanded(
//                           child: _buildWheel(
//                             context,
//                             0,
//                             59,
//                             selectedMinute,
//                             (index) => selectedMinute = index,
//                             primaryColor,
//                             unselectedColor,
//                           ),
//                         ),
//                         Expanded(
//                           child: CupertinoPicker(
//                             scrollController: FixedExtentScrollController(
//                               initialItem: selectedPeriod == 'AM' ? 0 : 1,
//                             ),
//                             itemExtent: 40,
//                             onSelectedItemChanged: (index) {
//                               selectedPeriod = index == 0 ? 'AM' : 'PM';
//                             },
//                             selectionOverlay: Container(
//                               decoration: const BoxDecoration(
//                                 border: Border.symmetric(
//                                   horizontal:
//                                       BorderSide(color: primaryColor, width: 1),
//                                 ),
//                               ),
//                             ),
//                             children: ['AM', 'PM'].map((period) {
//                               return Center(
//                                 child: Text(
//                                   period,
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     color: selectedPeriod == period
//                                         ? primaryColor
//                                         : unselectedColor,
//                                     fontWeight: selectedPeriod == period
//                                         ? FontWeight.bold
//                                         : FontWeight.normal,
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     },
//     child: AbsorbPointer(
//       child: SizedBox(
//         height: 50,
//         child: textField(
//           label,
//           controller: controller,
//           hintText: hintText,
//         ),
//       ),
//     ),
//   );
// }

// Widget _buildWheel(
//   BuildContext context,
//   int start,
//   int end,
//   int selectedValue,
//   ValueChanged<int> onSelected,
//   Color primaryColor,
//   Color unselectedColor,
// ) {
//   return CupertinoPicker(
//     scrollController:
//         FixedExtentScrollController(initialItem: selectedValue - start),
//     itemExtent: 40,
//     onSelectedItemChanged: onSelected,
//     selectionOverlay: Container(
//       decoration: BoxDecoration(
//         border: Border.symmetric(
//           horizontal: BorderSide(color: primaryColor, width: 1),
//         ),
//       ),
//     ),
//     children: List.generate(end - start + 1, (index) {
//       final value = start + index;
//       final isSelected = value == selectedValue;
//       return Center(
//         child: Text(
//           value.toString().padLeft(2, '0'),
//           style: TextStyle(
//             fontSize: 20,
//             color: isSelected ? primaryColor : unselectedColor,
//             fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//           ),
//         ),
//       );
//     }),
//   );
// }
