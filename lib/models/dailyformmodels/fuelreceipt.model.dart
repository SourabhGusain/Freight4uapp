import 'dart:io';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';

class FuelReceiptModel {
  static const List<String> paymentChoices = ['YES', 'NO'];

  final String name;
  final String date; // yyyy-MM-dd
  final String rego;
  final String paymentWithFuelCard; // 'YES' or 'NO'
  final File fuelReceipt; // file to upload
  final bool isActive;
  final String createdOn; // yyyy-MM-dd
  final int? createdBy;

  FuelReceiptModel({
    required this.name,
    required this.date,
    required this.rego,
    required this.paymentWithFuelCard,
    required this.fuelReceipt,
    this.isActive = true,
    required this.createdOn,
    this.createdBy,
  }) {
    if (!paymentChoices.contains(paymentWithFuelCard)) {
      throw ArgumentError('Invalid payment choice: $paymentWithFuelCard');
    }
  }

  Map<String, dynamic> toMultipartFields() {
    final fields = <String, dynamic>{
      'name': name,
      'date': date,
      'rego': rego,
      'payment_with_fuel_card': paymentWithFuelCard,
      // Assuming your Api helper can handle File directly for multipart
      'fuel_receipt': fuelReceipt,
      'is_active': isActive ? '1' : '0', // use '1'/'0' if API expects it
      'created_on':
          createdOn.contains('T') ? createdOn.split('T').first : createdOn,
    };

    if (createdBy != null) {
      fields['created_by'] = createdBy.toString();
    }

    return fields;
  }

  static Future<bool> submitFuelReceipt(FuelReceiptModel model) async {
    final url = "$api_url/dailyreport/fuel-receipt/";
    final api = Api();

    final fields = model.toMultipartFields();

    final result = await api.multipartOrJsonPostCall(
      url,
      fields,
      isMultipart: true,
    );

    if (result['ok'] == 1) {
      print('Fuel receipt submitted successfully.');
      return true;
    } else {
      print('Failed to submit fuel receipt: ${result['error']}');
      return false;
    }
  }
}
