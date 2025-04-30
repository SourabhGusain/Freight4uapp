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

class SpeedingpolicyPage extends StatefulWidget {
  const SpeedingpolicyPage({super.key});

  @override
  State<SpeedingpolicyPage> createState() => _SpeedingpolicyPageState();
}

class _SpeedingpolicyPageState extends State<SpeedingpolicyPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  late SignatureController _signatureController;

  List<DeclarationAnswer?> _declarationAnswers = List.filled(8, null);

  final String policyMarkdown = """
# Speeding Policy:

Hunter and Northern Logistics will have systems in place to ensure all drivers, sub-contractors, and employees obey the law in regard to safe speed. This includes safe speed within Distribution Centres and other points of delivery. Failure to adhere to this policy will result in disciplinary action, including instant dismissal.

## HNL Will:

- **Fit speed limiters** to all heavy vehicles to deter speeding.
- **Reserve the right** to discipline any employee/person who breaches this policy or appropriate legal requirements.
- The company will **fit GPS systems** to vehicles that provide speed warnings to the management.
- Ensure **driver schedules** are prepared with speed compliance included.
- Require **copies of all drivers and sub-contractors RMS driving records** prior to employment or engagement with HNL.
- Undertake effective communication with employees on matters relating to **speed management** via toolbox meetings.
- **Investigate and act upon** all breaches of this policy.
- **Exceeding speed limit longer than 4 seconds** will alert management and a warning will be issued.
- **Exceeding 110 km/h** will result in instant dismissal.
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
                "Speeding Policy & Declaration",
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
