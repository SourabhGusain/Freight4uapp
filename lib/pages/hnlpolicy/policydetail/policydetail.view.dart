import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:signature/signature.dart';
import 'package:Freight4u/widgets/ui.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/models/policymodels/policy.model.dart';
import 'package:Freight4u/pages/hnlpolicy/hnlpolicy.controller.dart';

class PolicyPage extends StatefulWidget {
  final PolicyModel policy;
  const PolicyPage({super.key, required this.policy});

  @override
  State<PolicyPage> createState() => _PolicyPageState();
}

class _PolicyPageState extends State<PolicyPage> {
  bool isBackLoading = false;

  Future<void> _handleBack() async {
    setState(() {
      isBackLoading = true;
    });

    // Optional small delay so loading spinner is visible
    await Future.delayed(const Duration(milliseconds: 400));

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final markdown = widget.policy.content;

    return ViewModelBuilder<PolicyController>.reactive(
      viewModelBuilder: () => PolicyController(),
      onViewModelReady: (ctrl) => ctrl.init(),
      builder: (context, ctrl, child) {
        return SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(65),
              child: secondaryNavBar(context, widget.policy.name,
                  onBack: _handleBack),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MarkdownWidget(
                    data: markdown,
                    shrinkWrap: true,
                    selectable: true,
                    config: MarkdownConfig(configs: [
                      const PConfig(textStyle: TextStyle(fontSize: 15)),
                      const H1Config(
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const H2Config(
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  textH3("Remark", font_size: 17),
                  buildCommentTextField(
                    controller: ctrl.remarkController,
                    hintText: "Type here...",
                    minLines: 1,
                    maxLines: null,
                    fillColor: Colors.white,
                    borderColor: Colors.grey,
                    focusedBorderColor: Colors.black,
                  ),
                  const SizedBox(height: 20),
                  textH3("Signature:", font_size: 17),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Signature(
                      controller: ctrl.signatureController,
                      height: 200,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      height: 25,
                      width: 90,
                      child: darkButton(
                        buttonText("Clear", color: whiteColor, font_size: 10),
                        primary: primaryColor,
                        onPressed: () => ctrl.signatureController.clear(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: darkButton(
                      buttonText("Save", color: whiteColor),
                      primary: primaryColor,
                      onPressed: () {
                        ctrl.saveAgreement(context, widget.policy.id);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
