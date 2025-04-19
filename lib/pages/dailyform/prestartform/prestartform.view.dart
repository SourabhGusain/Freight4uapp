import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:Freight4u/widgets/ui.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/pages/login/login.view.dart';
import 'package:Freight4u/pages/format/format.controller.dart';

class PrestartformPage extends StatefulWidget {
  const PrestartformPage({super.key});

  @override
  State<PrestartformPage> createState() => _PrestartformPageState();
}

class _PrestartformPageState extends State<PrestartformPage> {
  int _currentIndex = 0;

  // Use a list to hold individual answers for each declaration
  List<DeclarationAnswer?> _declarationAnswers = List.filled(8, null);

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
                "Pre-Start/Fit for Duty Declaration.",
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textH1("Forms:"),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 50,
                      child: textField("Full Name"),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 50,
                      child: textField(
                        "Date",
                        hintText: "e.g. DD/MM/YYYY",
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: textField(
                              "Time",
                              hintText: "e.g. HH:MM",
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: textField(
                              "Rego Name",
                              hintText: "e.g. ABC123",
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    customTypeSelector(
                      context: context,
                      text: "Select Contractor",
                      hintText: "Contractor",
                      dropdownTypes: ['Full-time', 'Part-time', 'Freelance'],
                    ),
                    const SizedBox(height: 10),
                    customTypeSelector(
                      context: context,
                      text: "Select Shape",
                      hintText: "Shape",
                      dropdownTypes: ['Box', 'Flatbed', 'Reefer'],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        textH1("FIT FOR DUTY DECLARATION:",
                            font_size: 15, font_weight: FontWeight.w600),
                        textH1(" *",
                            font_size: 20,
                            font_weight: FontWeight.bold,
                            color: Colors.red),
                      ],
                    ),
                    const SizedBox(height: 20),
                    customDeclarationBox(
                      context,
                      text:
                          "I have a current and valid\nlicense to operate this\nvehicle.",
                      selectedAnswer: _declarationAnswers[0],
                      onChanged: (answer) {
                        setState(() {
                          _declarationAnswers[0] = answer;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    customDeclarationBox(
                      context,
                      text: "I am fit to undertake my allocated tasks.",
                      selectedAnswer: _declarationAnswers[1],
                      onChanged: (answer) {
                        setState(() {
                          _declarationAnswers[1] = answer;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    customDeclarationBox(
                      context,
                      text:
                          "I am not fatigued or suffering any medical condition (that I am aware of) that may affect my ability to drive or complete my allocated tasks",
                      selectedAnswer: _declarationAnswers[2],
                      onChanged: (answer) {
                        setState(() {
                          _declarationAnswers[2] = answer;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    customDeclarationBox(
                      context,
                      text:
                          "I have had 24 hrs. Continuous stationary rest within the last 7 Days",
                      selectedAnswer: _declarationAnswers[3],
                      onChanged: (answer) {
                        setState(() {
                          _declarationAnswers[3] = answer;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    customDeclarationBox(
                      context,
                      text: "I have had a 10 hour rest break between shifts",
                      selectedAnswer: _declarationAnswers[4],
                      onChanged: (answer) {
                        setState(() {
                          _declarationAnswers[4] = answer;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    customDeclarationBox(
                      context,
                      text:
                          "I have NOT consumed alcohol and/or drugs (prescription) or otherwise that may impair my ability to work and drive",
                      selectedAnswer: _declarationAnswers[5],
                      onChanged: (answer) {
                        setState(() {
                          _declarationAnswers[5] = answer;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    customDeclarationBox(
                      context,
                      text:
                          "To the best of my knowledge, I have had NO driving infringements issued to me in the last 24hrs",
                      selectedAnswer: _declarationAnswers[6],
                      onChanged: (answer) {
                        setState(() {
                          _declarationAnswers[6] = answer;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    customDeclarationBox(
                      context,
                      text: "I am fit to undertake my allocated tasks.",
                      selectedAnswer: _declarationAnswers[7],
                      onChanged: (answer) {
                        setState(() {
                          _declarationAnswers[7] = answer;
                        });
                      },
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: darkButton(
                        buttonText("Save", color: whiteColor),
                        primary: primaryColor,
                        // onTap: () {
                        //   // Get.toWithNoBack(context, () => const HomePage());
                        // },
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: customBottomNavigationBar(
              context: context,
              selectedIndex: _currentIndex,
            ),
          ),
        );
      },
    );
  }
}
