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

  String selectedContractType = "Contract";
  String selectedShapeType = "Shape";

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
              child: secondaryNavBar(
                context,
                "CompanyName",
                "Pre-Start/Fit for Duty Declaration.",
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textH1("Forms:"),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: textField(
                              "First Name",
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: textField(
                              "Last Name",
                              hintText: "e.g. 23**",
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 50,
                      child: textField(
                        "Date",
                        hintText: "e.g. DD/MM/YYYY",
                      ),
                    ),
                    SizedBox(height: 10),
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
                    GestureDetector(
                      onTap: () {
                        showContractBottomSheet(context, (selected) {
                          setState(() {
                            selectedContractType = selected;
                          });
                        });
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            subtext(selectedContractType,
                                color: const Color.fromARGB(255, 54, 54, 54),
                                font_weight: FontWeight.w400,
                                font_size: 15),
                            Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        showShapeBottomSheet(context, (selected) {
                          setState(() {
                            selectedShapeType = selected;
                          });
                        });
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            subtext(selectedShapeType,
                                color: const Color.fromARGB(255, 54, 54, 54),
                                font_weight: FontWeight.w400,
                                font_size: 15),
                            Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
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

void showContractBottomSheet(
    BuildContext context, Function(String) onSelected) {
  List<String> contractTypes = [
    "Contract",
    "Full-time",
    "Part-time",
    "Internship",
    "Freelance",
  ];

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: contractTypes.length,
          itemBuilder: (context, index) {
            return TextButton(
              onPressed: () {
                onSelected(contractTypes[index]);
                Navigator.pop(context);
              },
              child: Text(
                contractTypes[index],
                style: TextStyle(fontSize: 16),
              ),
            );
          },
        ),
      );
    },
  );
}

void showShapeBottomSheet(BuildContext context, Function(String) onSelected) {
  List<String> contractTypes = [
    "Contract",
    "Full-time",
    "Part-time",
    "Internship",
    "Freelance",
  ];

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: contractTypes.map((contractType) {
            return GestureDetector(
              onTap: () {
                onSelected(contractType);
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      contractType,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const Icon(
                      Icons.check_circle_outline,
                      color: Color.fromARGB(255, 0, 123, 255),
                    ), // Optional icon for visual feedback
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      );
    },
  );
}
