import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:Freight4u/widgets/ui.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/pages/format/format.controller.dart';
import 'package:Freight4u/pages/dailyform/prestartform/prestartform.view.dart';
import 'package:Freight4u/pages/employeeform/generalform/generalform.view.dart';
import 'package:Freight4u/pages/employeeform/inductionform/inductionform.view.dart';
import 'package:Freight4u/pages/employeeform/fitnesschecklist/fitnesschecklist.view.dart';
import 'package:Freight4u/pages/employeeform/pitbulldocking/pitbulldocking.view.dart';
import 'package:Freight4u/pages/employeeform/palletoperation/palletoperation.view.dart';
import 'package:Freight4u/pages/employeeform/fatigueriskform/fatigueriskform.view.dart';
import 'package:Freight4u/pages/employeeform/corform/corform.view.dart';
import 'package:Freight4u/pages/employeeform/roadassessment/roadassessment.view.dart';
import 'package:Freight4u/pages/employeeform/cabassessment/cabassessment.view.dart';
import 'package:Freight4u/pages/employeeform/yellowbookassessment/yellowbookassessment.view.dart';
import 'package:Freight4u/pages/employeeform/safetyquestionnaire/safetyquestionnaire.view.dart';
import 'package:Freight4u/pages/employeeform/scissorlifttraining/scissorlifttraining.view.dart';
import 'package:Freight4u/pages/employeeform/dangerousgoods/dangerousgoods.view.dart';

class EmployeePage extends StatefulWidget {
  final Session session;
  const EmployeePage({super.key, required this.session});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  int _currentIndex = 0;

  void _showLoadingAndNavigate(
      BuildContext context, Widget Function() pageBuilder) async {
    // Show loading dialog with primary color spinner
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(
          color: primaryColor,
        ),
      ),
    );

    // Small delay to show loading spinner (optional, can remove)
    await Future.delayed(const Duration(milliseconds: 300));

    // Close loading dialog
    Navigator.of(context).pop();

    // Navigate to target page
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => pageBuilder()),
    );
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
                    textH1("EMPLOYMENT PACKAGES:"),
                    const SizedBox(height: 15),
                    customBox(
                      text: "General Form",
                      subtext:
                          "Complete this form daily to record general activity.",
                      onTap: () => _showLoadingAndNavigate(context,
                          () => GeneralFormPage(session: widget.session)),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "Company Induction Form",
                      subtext:
                          "Fill this out after completing your shift induction.",
                      onTap: () => _showLoadingAndNavigate(
                          context, () => InductionFormPage(session: session)),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "A Drivers Fit for Duty Checklist",
                      subtext: "Ensure you are fit for duty. Complete weekly.",
                      onTap: () => _showLoadingAndNavigate(context,
                          () => FitnessChecklistFormPage(session: session)),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "Pitbull and Docking Operation SWP Assessment",
                      subtext:
                          "Complete to assess safety during docking operations.",
                      onTap: () => _showLoadingAndNavigate(context,
                          () => PitbullDockingSWPFormPage(session: session)),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "Manual and Electrical Pallet Operation",
                      subtext:
                          "Record fuel usage and attach the corresponding receipt.",
                      onTap: () => _showLoadingAndNavigate(context,
                          () => EPJMPJAssessmentFormPage(session: session)),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "FATIGUE RISK MANAGEMENT",
                      subtext:
                          "Assess fatigue levels and ensure compliance with rest policies.",
                      onTap: () => _showLoadingAndNavigate(
                          context,
                          () =>
                              FatigueRiskManagementFormPage(session: session)),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "CoR",
                      subtext:
                          "Chain of Responsibility assessment to meet legal obligations.",
                      onTap: () => _showLoadingAndNavigate(
                          context, () => CoRFormPage(session: session)),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "Road Assessment Buddy Training",
                      subtext:
                          "Evaluate driver performance with a training buddy.",
                      onTap: () => _showLoadingAndNavigate(context,
                          () => RoadAssessmentFormPage(session: session)),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "In cab Assessment",
                      subtext:
                          "Evaluate safe driving habits and cab operations.",
                      onTap: () => _showLoadingAndNavigate(context,
                          () => InCabAssessmentFormPage(session: session)),
                    ),
                    // const SizedBox(height: 10),
                    // customBox(
                    //   text: "LINFOX Yellow Book Assessment",
                    //   subtext:
                    //       "Confirm knowledge of the LINFOX safety procedures.",
                    //   onTap: () => _showLoadingAndNavigate(context,
                    //       () => YellowBookAssessmentFormPage(session: session)),
                    // ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "Work Health and Safety Questionnaire",
                      subtext:
                          "Assess your understanding of workplace safety policies.",
                      onTap: () => _showLoadingAndNavigate(
                          context,
                          () => WorkHealthSafetyQuestionnairePage(
                              session: session)),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text:
                          "Coupling/Uncoupling: Prime Mover Trailer and B Double",
                      subtext:
                          "Demonstrate correct procedures for coupling/uncoupling.",
                      onTap: () => _showLoadingAndNavigate(
                          context, () => const PrestartformPage()),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "Safe Work Procedure: Tailgate Unload Operation",
                      subtext:
                          "Follow safe unloading practices and report any issues.",
                      onTap: () => _showLoadingAndNavigate(
                          context, () => const PrestartformPage()),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "EPJ/MPJ",
                      subtext:
                          "Complete manual handling competency requirements.",
                      onTap: () => _showLoadingAndNavigate(
                          context, () => const PrestartformPage()),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "Mass & Load Restraint Competency Questionnaire",
                      subtext:
                          "Test your understanding of load safety and regulations.",
                      onTap: () => _showLoadingAndNavigate(
                          context, () => const PrestartformPage()),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "Dangerous Goods Competency Questionnaire",
                      subtext:
                          "Ensure you are qualified to handle hazardous materials.",
                      onTap: () => _showLoadingAndNavigate(context,
                          () => DangerousGoodsCompetencyPage(session: session)),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "COVID-19 Multiple Choice Questionnaire",
                      subtext:
                          "Confirm awareness of COVID-19 safety procedures.",
                      onTap: () => _showLoadingAndNavigate(
                          context, () => const PrestartformPage()),
                    ),
                    const SizedBox(height: 10),
                    customBox(
                      text: "Scissor Lift",
                      subtext:
                          "Evaluate your understanding of safe scissor lift operation.",
                      onTap: () => _showLoadingAndNavigate(context,
                          () => ScissorLiftTrainingPage(session: session)),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: customBottomNavigationBar(
              context: context,
              selectedIndex: 2,
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
