import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:Freight4u/widgets/ui.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/pages/login/login.view.dart';
import 'package:Freight4u/pages/format/format.controller.dart';
import 'package:Freight4u/pages/dailyform/prestartform/prestartform.view.dart';
import 'package:Freight4u/pages/hnlpolicy/policydetail/policydetail.view.dart';

class HnlpolicyPage extends StatefulWidget {
  final Session session;
  const HnlpolicyPage({super.key, required this.session});

  @override
  State<HnlpolicyPage> createState() => _HnlpolicyPageState();
}

class _HnlpolicyPageState extends State<HnlpolicyPage> {
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
                    textH1(
                        "HUNTER & NORTHERN GROUP POLICIES (or Northern Feight Services) :"),
                    const SizedBox(height: 15),
                    customBox(
                      text: "Speeding Policy",
                      subtext:
                          "Adheres to company rules regarding vehicle speed limits and reporting any violations.",
                      onTap: () => Get.to(context,
                          () => const PolicyPage(policy: "Speeding Policy")),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "No Smoking Policy",
                      subtext:
                          "Outlines strict no-smoking rules within vehicles and company premises.",
                      onTap: () => Get.to(context,
                          () => const PolicyPage(policy: "No Smoking Policy")),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "Drug & Alcohol Policy Statement",
                      subtext:
                          "Ensures a drug- and alcohol-free workplace; mandatory reporting and testing protocols apply.",
                      onTap: () => Get.to(
                          context,
                          () => const PolicyPage(
                              policy: "Drug & Alcohol Policy Statement")),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "Social Media Policy",
                      subtext:
                          "Guidelines on the appropriate use of social media related to work conduct and company reputation.",
                      onTap: () => Get.to(
                          context,
                          () =>
                              const PolicyPage(policy: "Social Media Policy")),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "Toll Road Policy",
                      subtext:
                          "Explains the use and reimbursement process for toll roads used during work-related travel.",
                      onTap: () => Get.to(context,
                          () => const PolicyPage(policy: "Toll Road Policy")),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "DC - Fit For Work Policy",
                      subtext:
                          "Covers physical and mental readiness requirements before starting work duties.",
                      onTap: () => Get.to(
                          context,
                          () => const PolicyPage(
                              policy: "DC - Fit For Work Policy")),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "Mobile Phone Policy Statement",
                      subtext:
                          "Details safe and permitted use of mobile phones during work and driving hours.",
                      onTap: () => Get.to(
                          context,
                          () => const PolicyPage(
                              policy: "Mobile Phone Policy Statement")),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "Harassment / Discrimination Policy",
                      subtext:
                          "Zero-tolerance stance on any form of workplace harassment or discrimination.",
                      onTap: () => Get.to(
                          context,
                          () => const PolicyPage(
                              policy: "Harassment / Discrimination Policy")),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "Food, Safety & Quality Policy",
                      subtext:
                          "Outlines food handling, safety, and quality standards expected during operations.",
                      onTap: () => Get.to(
                          context,
                          () => const PolicyPage(
                              policy: "Food, Safety & Quality Policy")),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "Fatigue Management Policy",
                      subtext:
                          "Defines procedures to manage driver fatigue, ensuring alertness and safety.",
                      onTap: () => Get.to(
                          context,
                          () => const PolicyPage(
                              policy: "Fatigue Management Policy")),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "Contractor Management Policy",
                      subtext:
                          "Responsibilities and standards for contractors working with or for the company.",
                      onTap: () => Get.to(
                          context,
                          () => const PolicyPage(
                              policy: "Contractor Management Policy")),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "Chain of Responsibility Policy",
                      subtext:
                          "Clarifies accountability across all roles for compliance with transport laws.",
                      onTap: () => Get.to(
                          context,
                          () => const PolicyPage(
                              policy: "Chain of Responsibility Policy")),
                    ),
                    const SizedBox(height: 10),
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
