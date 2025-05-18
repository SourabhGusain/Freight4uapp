import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:Freight4u/models/policy.model.dart';
import 'package:Freight4u/models/agreement.model.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:signature/signature.dart';
import 'package:stacked/stacked.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/helpers/values.dart';

class PolicyController extends BaseViewModel {
  final remarkController = TextEditingController();
  final signatureController = SignatureController(
    penColor: Colors.black,
    penStrokeWidth: 5.0,
    exportBackgroundColor: Colors.white,
  );

  final AgreementService _agreementService = AgreementService();
  final PolicyService _policyService = PolicyService();

  List<PolicyModel> _policies = [];
  List<PolicyModel> get policies => _policies;

  Future<void> init() async {
    setBusy(true);
    try {
      _policies = await _policyService.fetchPolicies();
    } catch (e) {
      debugPrint("Error fetching policies: $e");
    } finally {
      setBusy(false);
    }
  }

  /// Save agreement with signature
  Future<void> saveAgreement(BuildContext context, int policyId) async {
    _showLoadingDialog(context);

    try {
      final Uint8List? signatureBytes = await signatureController.toPngBytes();
      if (signatureBytes == null || signatureBytes.isEmpty) {
        Navigator.pop(context);
        _showErrorDialog(context, "Please provide your signature.");
        return;
      }

      final String tempPath = Directory.systemTemp.path;
      final File signatureFile = File(
          '$tempPath/signature_${DateTime.now().millisecondsSinceEpoch}.png');
      await signatureFile.writeAsBytes(signatureBytes);

      final session = Session();
      final userIdStr = await session.getUserId();
      final int? userId = int.tryParse(userIdStr ?? '');
      if (userId == null) {
        Navigator.pop(context);
        _showErrorDialog(context, "User not logged in.");
        return;
      }

      final DateTime now = DateTime.now();
      final String nowDate =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      final agreement = AgreementModel(
        policyId: policyId,
        driverId: userId,
        signatureFile: signatureFile,
        remark: remarkController.text.trim(),
        status: "pending",
        isActive: true,
        date: nowDate,
        createdOn: nowDate,
        createdBy: userId,
      );

      final response = await _agreementService.createAgreement(agreement);
      Navigator.pop(context); // remove loading dialog

      if (response["ok"] == 1) {
        _showSuccessDialog(context, true);
      } else {
        _showErrorDialog(
            context, response["error"] ?? "Failed to submit agreement.");
      }
    } catch (e) {
      Navigator.pop(context);
      debugPrint("Error saving agreement: $e");
      _showErrorDialog(context, "Unexpected error: $e");
    } finally {
      setBusy(false);
    }
  }

  @override
  void dispose() {
    remarkController.dispose();
    signatureController.dispose();
    super.dispose();
  }

  /// --- Dialog Helpers ---

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: primaryColor),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, bool success) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Success"),
        content: const Text("Agreement submitted successfully."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Optionally pop back to previous screen
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
