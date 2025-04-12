import 'package:flutter/material.dart';
import 'package:Freight4u/pages/format/format.controller.dart';
import 'package:Freight4u/widgets/ui.dart';
import 'package:stacked/stacked.dart';

class FormatPage extends StatefulWidget {
  const FormatPage({super.key});
  @override
  State<FormatPage> createState() => _FormatPageState();
}

class _FormatPageState extends State<FormatPage> {
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
          return Scaffold(
            body: Stack(
              children: [space_30, Container()],
            ),
          );
        },
        onViewModelReady: (controller) {
          controller.init();
        });
  }
}
