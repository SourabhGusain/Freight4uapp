import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:Freight4u/widgets/ui.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/pages/login/login.view.dart';
import 'package:signature/signature.dart';
import 'package:Freight4u/pages/format/format.controller.dart';

class Nosmokingpolicy extends StatefulWidget {
  const Nosmokingpolicy({super.key});

  @override
  State<Nosmokingpolicy> createState() => _NosmokingpolicyState();
}

class _NosmokingpolicyState extends State<Nosmokingpolicy> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  late SignatureController _signatureController;

  List<DeclarationAnswer?> _declarationAnswers = List.filled(8, null);

  final String policyMarkdown = """
# Smoke-Free Workplace Policy

**Hunter & Northern Logistics Pty Ltd (NSW)** aims to further assist in providing a safe and healthy work environment for everyone.

## Policy Statement

- **Smoking is not permitted** in:
  - All internal areas of our work location  
  - Any area deemed hazardous  
  - Designated **NO SMOKING** areas

This policy has been implemented in the interest of protecting the **health and wellbeing of everyone**.

---

> ⚠️ _This policy is not intended to infringe upon any individual’s right to choose._

---

## Review

This policy will be **reviewed annually**, or earlier if required.

""";

  @override
  void initState() {
    super.initState();
    // Initialize the signature controller
    _signatureController = SignatureController(
      penColor: Colors.black,
      penStrokeWidth: 5.0,
      exportBackgroundColor: Colors.transparent,
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FormatController>.reactive(
      viewModelBuilder: () => FormatController(),
      onViewModelReady: (controller) => controller.init(),
      builder: (context, ctrl, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 252, 253, 255),
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(65),
              child: secondaryNavBar(
                context,
                "No Smoking Policy",
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Markdown widget for policy text
                    MarkdownWidget(
                      data: policyMarkdown,
                      padding: const EdgeInsets.only(bottom: 5),
                      selectable: true,
                      shrinkWrap: true,
                      config: MarkdownConfig(
                        configs: [
                          const PConfig(textStyle: TextStyle(fontSize: 15)),
                          const H1Config(
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          const H2Config(
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const H3Config(style: TextStyle(fontSize: 18)),
                          // const ListConfig(
                          //     style: TextStyle(
                          //         fontSize: 15)),
                          const CodeConfig(style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    textH1("Forms:"),

                    const SizedBox(height: 10),
                    SizedBox(
                      height: 50,
                      child: textField("Full Name"),
                    ),
                    const SizedBox(height: 10),

                    // Date field
                    SizedBox(
                      height: 50,
                      child: calendarDateField(
                        context: context,
                        label: "Date",
                        controller: _dateController,
                      ),
                    ),
                    const SizedBox(height: 10),

                    const SizedBox(height: 10),
                    textH3("Signature:",
                        font_size: 17, font_weight: FontWeight.w400),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      child: Signature(
                        controller: _signatureController,
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
                          onPressed: () {
                            _signatureController.clear();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: darkButton(
                        buttonText("Save", color: whiteColor),
                        primary: primaryColor,
                        // Add your onTap logic here
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
