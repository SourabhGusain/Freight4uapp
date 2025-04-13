import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:Freight4u/widgets/ui.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/values.dart';
// import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/pages/login/login.view.dart';
import 'package:Freight4u/pages/format/format.controller.dart';

class DailyformPage extends StatefulWidget {
  const DailyformPage({super.key});
  @override
  State<DailyformPage> createState() => _DailyformPageState();
}

class _DailyformPageState extends State<DailyformPage> {
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
                backgroundColor: whiteColor,
                body: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(16.0), child: Column()),
                )),
          );
        },
        onViewModelReady: (controller) {
          controller.init();
        });
  }
}
