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
                              textH1(
                                  "HUNTER & NORTHERN GROUP POLICIES (or Northern Freight Services):"),
                              const SizedBox(height: 15),
                              ...ctrl.policies.map(
                                (policy) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: customBox(
                                    text: policy.name,
                                    subtext: policy.subtext,
                                    onTap: () => Get.to(
                                      context,
                                      () => PolicyPage(policy: policy),
                                    ),
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
