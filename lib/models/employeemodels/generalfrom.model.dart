import 'dart:convert';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';

class GeneralFormModel {
  final String name;
  final String dateOfBirth; // in YYYY-MM-DD
  final String streetAddress;
  final String streetAddressLine2;
  final String city;
  final String state;
  final String zipCode;
  final String areaCode;
  final String phone;
  final String email;
  final String password;
  final String tnf;

  // Emergency contact
  final String emergencyName;
  final String emergencyRelationship;
  final String emergencyAreaCode;
  final String emergencyPhone;
  final String emergencyStreetAddress;
  final String emergencyStreetAddressLine2;
  final String emergencyCity;
  final String emergencyState;
  final String emergencyZipCode;

  // Bank details
  final String nameOfInstitution;
  final String accountNumber;
  final String branchBsb;

  // Superfund
  final String superfund;
  final String superfundNumber;
  final String superfundAccountName;
  final String superfundBranchBsb;
  final String superfundAccountNumber;

  // Employment history
  final String sitesPreviouslyWorked;
  final String colesInduction;
  final String startDate;
  final String expiryDate;
  final String lastEmployerIn24Months;
  final String reasonForLeaving;

  // Reference
  final String referenceName;
  final String referenceLastName;
  final String referencePhoneNumber;

  final bool isActive;
  final String createdOn;
  final int createdBy;

  GeneralFormModel({
    required this.name,
    required String dateOfBirth,
    required this.streetAddress,
    required this.streetAddressLine2,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.areaCode,
    required this.phone,
    required this.email,
    required this.password,
    required this.tnf,
    required this.emergencyName,
    required this.emergencyRelationship,
    required this.emergencyAreaCode,
    required this.emergencyPhone,
    required this.emergencyStreetAddress,
    required this.emergencyStreetAddressLine2,
    required this.emergencyCity,
    required this.emergencyState,
    required this.emergencyZipCode,
    required this.nameOfInstitution,
    required this.accountNumber,
    required this.branchBsb,
    required this.superfund,
    required this.superfundNumber,
    required this.superfundAccountName,
    required this.superfundBranchBsb,
    required this.superfundAccountNumber,
    required this.sitesPreviouslyWorked,
    required this.colesInduction,
    required String startDate,
    required String expiryDate,
    required this.lastEmployerIn24Months,
    required this.reasonForLeaving,
    required this.referenceName,
    required this.referenceLastName,
    required this.referencePhoneNumber,
    required this.isActive,
    required String createdOn,
    required this.createdBy,
  })  : dateOfBirth = _toIsoDate(dateOfBirth),
        startDate = _toIsoDate(startDate),
        expiryDate = _toIsoDate(expiryDate),
        createdOn = _toIsoDate(createdOn);

  factory GeneralFormModel.fromJson(Map<String, dynamic> json) {
    return GeneralFormModel(
      name: json['name'] ?? '',
      dateOfBirth: json['date_of_birth'] ?? '',
      streetAddress: json['street_address'] ?? '',
      streetAddressLine2: json['street_address_line_2'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipCode: json['zip_code'] ?? '',
      areaCode: json['area_code'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      tnf: json['tnf'] ?? '',
      emergencyName: json['emergency_name'] ?? '',
      emergencyRelationship: json['emergency_relationship'] ?? '',
      emergencyAreaCode: json['emergency_area_code'] ?? '',
      emergencyPhone: json['emergency_phone'] ?? '',
      emergencyStreetAddress: json['emergency_street_address'] ?? '',
      emergencyStreetAddressLine2:
          json['emergency_street_address_line_2'] ?? '',
      emergencyCity: json['emergency_city'] ?? '',
      emergencyState: json['emergency_state'] ?? '',
      emergencyZipCode: json['emergency_zip_code'] ?? '',
      nameOfInstitution: json['name_of_institution'] ?? '',
      accountNumber: json['account_number'] ?? '',
      branchBsb: json['branch_bsb'] ?? '',
      superfund: json['superfund'] ?? '',
      superfundNumber: json['superfund_number'] ?? '',
      superfundAccountName: json['superfund_account_name'] ?? '',
      superfundBranchBsb: json['superfund_branch_bsb'] ?? '',
      superfundAccountNumber: json['superfund_account_number'] ?? '',
      sitesPreviouslyWorked: json['sites_previously_worked'] ?? '',
      colesInduction: json['coles_induction'] ?? '',
      startDate: json['start_date'] ?? '',
      expiryDate: json['expiry_date'] ?? '',
      lastEmployerIn24Months: json['last_employer_in_24_months'] ?? '',
      reasonForLeaving: json['reason_for_leaving'] ?? '',
      referenceName: json['reference_name'] ?? '',
      referenceLastName: json['reference_last_name'] ?? '',
      referencePhoneNumber: json['reference_phone_number'] ?? '',
      isActive: json['is_active'] ?? false,
      createdOn: json['created_on'] ?? '',
      createdBy: json['created_by'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "date_of_birth": dateOfBirth,
      "street_address": streetAddress,
      "street_address_line_2": streetAddressLine2,
      "city": city,
      "state": state,
      "zip_code": zipCode,
      "area_code": areaCode,
      "phone": phone,
      "email": email,
      "password": password,
      "tnf": tnf,
      "emergency_name": emergencyName,
      "emergency_relationship": emergencyRelationship,
      "emergency_area_code": emergencyAreaCode,
      "emergency_phone": emergencyPhone,
      "emergency_street_address": emergencyStreetAddress,
      "emergency_street_address_line_2": emergencyStreetAddressLine2,
      "emergency_city": emergencyCity,
      "emergency_state": emergencyState,
      "emergency_zip_code": emergencyZipCode,
      "name_of_institution": nameOfInstitution,
      "account_number": accountNumber,
      "branch_bsb": branchBsb,
      "superfund": superfund,
      "superfund_number": superfundNumber,
      "superfund_account_name": superfundAccountName,
      "superfund_branch_bsb": superfundBranchBsb,
      "superfund_account_number": superfundAccountNumber,
      "sites_previously_worked": sitesPreviouslyWorked,
      "coles_induction": colesInduction,
      "start_date": startDate,
      "expiry_date": expiryDate,
      "last_employer_in_24_months": lastEmployerIn24Months,
      "reason_for_leaving": reasonForLeaving,
      "reference_name": referenceName,
      "reference_last_name": referenceLastName,
      "reference_phone_number": referencePhoneNumber,
      "is_active": isActive,
      "created_on": createdOn,
      "created_by": createdBy,
    };
  }

  static String _toIsoDate(String date) {
    if (date.isEmpty) return '';
    if (date.contains('/')) {
      // assume DD/MM/YYYY format, convert to YYYY-MM-DD
      final parts = date.split('/');
      if (parts.length == 3) {
        final day = parts[0].padLeft(2, '0');
        final month = parts[1].padLeft(2, '0');
        final year = parts[2];
        return '$year-$month-$day';
      }
    }
    // Already assume YYYY-MM-DD or something else, return as is
    return date.split('T').first; // strip time if any
  }

  @override
  String toString() {
    return 'GeneralFormModel { name: $name, dateOfBirth: $dateOfBirth, phone: $phone, email: $email, ... }';
  }
}

Future<bool> postForm(GeneralFormModel formModel) async {
  final url = '$api_url/employee/general-form/';
  print('API URL: $url');

  try {
    final data = formModel.toJson();
    print('Sending data: $data');

    final response = await Api().postCalling(
      url,
      jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    print('Response: $response');

    if (response != null && response['ok'] == 1) {
      print('General form submitted successfully');
      return true;
    } else {
      print(
          'Failed to submit general form: ${response?['error'] ?? "Unknown error"}');
      return false;
    }
  } catch (e) {
    print('Error during postForm: $e');
    return false;
  }
}
