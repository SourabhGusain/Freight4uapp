import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:Freight4u/widgets/ui.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/pages/hnlpolicy/policydetail/policydetail.view.dart';
import 'package:Freight4u/pages/hnlpolicy/hnlpolicy.controller.dart';

class HnlpolicyPage extends StatefulWidget {
  final Session session;
  const HnlpolicyPage({super.key, required this.session});

  @override
  State<HnlpolicyPage> createState() => _HnlpolicyPageState();
}

class _HnlpolicyPageState extends State<HnlpolicyPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PolicyController>.reactive(
      viewModelBuilder: () => PolicyController(),
      onViewModelReady: (controller) => controller.init(),
      builder: (context, ctrl, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 252, 253, 255),
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(65),
              child: primaryNavBar(
                  context, "Freight 4 You", "assets/images/logo.png"),
            ),
            body: ctrl.isBusy
                ? const Center(child: CircularProgressIndicator())
                : ctrl.policies.isEmpty
                    ? const Center(child: Text("No policies found."))
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: primaryColor,
                                    width: 1,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.assignment_turned_in,
                                      size: 20,
                                      color: primaryColor,
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: textH2(
                                        "HUNTER & NORTHERN GROUP POLICIES (or Northern Freight Services):",
                                        font_size: 13,
                                        font_weight: FontWeight.w600,
                                        color: blackColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              ...ctrl.policies.map(
                                (policy) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: customBox(
                                    text: policy.name,
                                    subtext: policy.subtext,
                                    onTap: () async {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return const Center(
                                            child: CircularProgressIndicator(
                                              color: primaryColor,
                                            ),
                                          );
                                        },
                                      );
                                      await Future.delayed(
                                          const Duration(seconds: 1));
                                      Navigator.of(context).pop();
                                      Get.to(
                                        context,
                                        () => PolicyPage(policy: policy),
                                      );
                                    },
                                  ),
                                ),
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
    );
  }
}
