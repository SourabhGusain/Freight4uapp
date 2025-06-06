import 'dart:io';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:Freight4u/widgets/ui.dart';
import 'package:Freight4u/widgets/form.dart';

import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/helpers/session.dart';

class DownloaddocumnetsPages extends StatefulWidget {
  final Session session;
  const DownloaddocumnetsPages({super.key, required this.session});

  @override
  State<DownloaddocumnetsPages> createState() => _DownloaddocumnetsPagesState();
}

class _DownloaddocumnetsPagesState extends State<DownloaddocumnetsPages> {
  late SignatureController _signatureController;

  bool isBackLoading = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _signatureController = SignatureController(
      penColor: Colors.black,
      penStrokeWidth: 3,
      exportBackgroundColor: Colors.transparent,
    );
  }

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  Future<void> _handleBack() async {
    setState(() => isBackLoading = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) Navigator.of(context).pop();
  }

  Widget _dateField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: calendarDateField(
        context: context,
        label: label,
        controller: controller,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 252, 253, 255),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: secondaryNavBar(context, "Scissor Lift Training",
              onBack: _handleBack),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textH1("Scissor Lift Training Form"),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
