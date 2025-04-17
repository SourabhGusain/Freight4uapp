import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:Freight4u/widgets/ui.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/pages/login/login.view.dart';
import 'package:Freight4u/pages/format/format.controller.dart';
import 'package:Freight4u/pages/dailyform/prestartfrom/prestartform.view.dart';

class LinefoxPage extends StatefulWidget {
  const LinefoxPage({super.key});

  @override
  State<LinefoxPage> createState() => _LinefoxPageState();
}

class _LinefoxPageState extends State<LinefoxPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FormatController>.reactive(
      viewModelBuilder: () => FormatController(),
      builder: (context, ctrl, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 252, 253, 255),
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(65),
              child: primaryNavBar(
                  context, "Freight 4 You", "assets/images/logo.png"),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textH1("NDC LineHaul Forms:"),
                    const SizedBox(height: 15),
                    customBox(
                      text: "General Form",
                      subtext:
                          "Use this form for daily general reporting and trip-related notes.",
                      onTap: () =>
                          Get.to(context, () => const PrestartformPage()),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "Licence Declaration Form",
                      subtext:
                          "Declare that your driver’s licence details are current and valid.",
                      onTap: () =>
                          Get.to(context, () => const PrestartformPage()),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "Pre-Med Form",
                      subtext:
                          "Complete prior to duty to confirm you are fit for work.",
                      onTap: () =>
                          Get.to(context, () => const PrestartformPage()),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "Driver History Renewal Form",
                      subtext:
                          "Submit updated driving history for compliance and records.",
                      onTap: () =>
                          Get.to(context, () => const PrestartformPage()),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "Policy Check Form",
                      subtext:
                          "Acknowledge and confirm understanding of current company policies.",
                      onTap: () =>
                          Get.to(context, () => const PrestartformPage()),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: customBottomNavigationBar(
              context: context,
              selectedIndex: 1,
            ),
          ),
        );
      },
      onViewModelReady: (controller) {
        controller.init();
      },
    );
  }
}
