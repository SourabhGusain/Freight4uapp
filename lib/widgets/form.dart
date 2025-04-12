import 'package:Freight4u/helpers/get.dart';
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
        hintStyle: const TextStyle(fontWeight: FontWeight.w400)),
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
