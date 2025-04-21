import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:Freight4u/widgets/ui.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/pages/login/login.view.dart';
import 'package:Freight4u/pages/format/format.controller.dart';
import 'package:Freight4u/pages/dailyform/prestartform/prestartform.view.dart';
import 'package:Freight4u/pages/dailyform/runsheetform/runsheetform.view.dart';
import 'package:Freight4u/pages/dailyform/weighbridgeform/weighbridgeform.view.dart';
import 'package:Freight4u/pages/dailyform/vehicleconditionform/vehicleconditionform.view.dart';
import 'package:Freight4u/pages/dailyform/fuelrecieptform/fuelrecieptform.view.dart';

class DailyformPage extends StatefulWidget {
  const DailyformPage({super.key});

  @override
  State<DailyformPage> createState() => _DailyformPageState();
}

class _DailyformPageState extends State<DailyformPage> {
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
                    textH1("DAILY REPORTS:"),
                    const SizedBox(height: 15),
                    customBox(
                      text: "Pre-Start/Fit for Duty Declaration.",
                      subtext:
                          "Must be filled out before operating the vehicle.",
                      onTap: () =>
                          Get.to(context, () => const PrestartformPage()),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "Runsheet",
                      subtext:
                          "To be filled out following the completion of your shift.",
                      onTap: () => Get.to(context, () => const RunsheetPage()),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "Weighbridge & Load Pic",
                      subtext: "Weekly completion is required.",
                      onTap: () =>
                          Get.to(context, () => const WeighbridgePage()),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "Vehicle Condition Report.",
                      subtext:
                          "Report all truck defects by completing this form.",
                      onTap: () =>
                          Get.to(context, () => const VehileconditionPage()),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "Fuel Reciept",
                      subtext:
                          "Attach the receipt and fill out the fuel expense form.",
                      onTap: () =>
                          Get.to(context, () => const FuelrecieptPage()),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: customBottomNavigationBar(
              context: context,
              selectedIndex: 0,
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
